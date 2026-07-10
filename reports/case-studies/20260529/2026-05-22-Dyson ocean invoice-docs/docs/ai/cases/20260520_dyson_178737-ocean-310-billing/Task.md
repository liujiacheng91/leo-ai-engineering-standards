# Task.md

## Task Goal

实现 `DysonOnlineOceanBillingSendProcessImpl`：将 OceanShipment 按 oc_rate 分组转换为 X12 MSG310 文件，推送 EDI Core，记录日志，发送邮件。

## Related Documents

- AI_Request.md
- Scenario.md
- AI_Risk_Level.md
- Solution.md
- Mapping_Rules.md
- Test.md

---

## Task Breakdown

| Task ID | Task | Input | Output | Files | Done Criteria | AC |
|---|---|---|---|---|---|---|
| TASK-001 | build.gradle 新增 edi-x12:0.0.4 | build.gradle | 编译通过 | `build.gradle` | `./gradlew :edi-business-realization:edi-dyson-realization:compileJava` 无报错；`Msg310X12Factory` 可 import | — |
| TASK-002 | 新增 Process 注册类 | Solution.md § 2 | Process Bean 注册 | `send/process/DysonOnlineOceanBillingSendProcess.java` | compileJava 通过；6 个 override 返回值与 Solution.md 一致 | — |
| TASK-003 | Impl 骨架 + sendData 主流程 | Solution.md § 3/4.1 | 主流程骨架含分组、try-catch、返回值、日志、邮件调用 | `send/process/impl/DysonOnlineOceanBillingSendProcessImpl.java` | compileJava 通过；JSON 解析失败时返回 status=false,code=500；trace_id 为空时用 UUID；Revert data 含 invoiceNo+filename | AC-001, AC-008, AC-009 |
| TASK-004 | buildMsg310 — 信封 + B3/B2A/N9/C3 | Solution.md § 4.2, Mapping_Rules.md 信封段/B3/N9/C3 节 | ISA/GS/ST/B3/B2A/N9(BM~FN)/C3 字段映射正确 | 同 TASK-003（同一文件） | env=prod → ISA06=KERRY,ISA15=P；env=uat → KERRYTEST,T；B3/B304 COLLECT→PP, PREPAID→CC, 其他→空字符串 | AC-002, AC-003, AC-005 |
| TASK-005 | buildMsg310 — N1 Loop（BT/SF/ST/PR） | Mapping_Rules.md N1 Loop 节 | 四组 N1Group（BT/SF/ST/PR）字段映射正确 | 同 TASK-003 | N1Group 数量=4；BT/PR 取 oc_rate 分组1字段；SF/ST 取 ocean 字段；地址合并截55字符 | AC-004 |
| TASK-006 | buildMsg310 — R4 Loop + DTM | Mapping_Rules.md R4 Loop 节 | R4(L)/R4(D) + DTM 生成；独立 DTM（Earliest Pickup）生成 | 同 TASK-003 | R4(L) r401="L"；R4(D) r401="D"；IFFDEP est_date 为空时 DTM 整组不生成；m_eta 格式 DDMMYYYY→yyyyMMdd 正确 | AC-004 |
| TASK-007 | buildMsg310 — LX/N7/L0/L1 + L3 | Mapping_Rules.md LX Loop/L3 节 | 一个 LxGroup；N7/L0 按分组2；L1 在每个 L0Group 内；L3 汇总正确 | 同 TASK-003 | loadterm=LCL → N7Group 为空；L0 grs_kgs/cbm/qty 按分组2 sum 正确；L3 按分组1/3 sum 正确 | AC-006, AC-007 |
| TASK-008 | pushToCore 方法 | Solution.md § 4.3 | CommonRequest 构建 + pushContentTo 调用 + logVo 状态更新 | 同 TASK-003 | sceneCode=SEND_DYSON_TO_SFTP；customerScope=AIR_RATE；messageFormat=TXT；推送成功 logVo.status="1"；失败="0" | AC-008 |
| TASK-009 | mapFrom304 占位方法 | Solution.md § 4.4 | 空方法体，buildMsg310 return 前调用 | 同 TASK-003 | 编译通过；方法签名 `mapFrom304(String logPrefix, Msg310 msg310, OceanShipment shipment)`；方法体含 logger.info 和 TODO 注释；在 buildMsg310 return 前被调用 | AC-010 |

---

## Dependency Order

```
TASK-001（build.gradle）
  └─ TASK-002（Process 注册类）
       └─ TASK-003（Impl 骨架 + sendData 主流程）
            ├─ TASK-004（buildMsg310 信封/B3/N9/C3）
            │    └─ TASK-005（N1 Loop）
            │         └─ TASK-006（R4 Loop + DTM）
            │              └─ TASK-007（LX/N7/L0/L1/L3）
            │                   └─ TASK-008（pushToCore）
            │                        └─ TASK-009（mapFrom304 占位）
            └─ （TASK-004~009 均在同一文件，可顺序完成后统一 compileJava 验证）
```

TASK-003 ~ TASK-009 均在 `DysonOnlineOceanBillingSendProcessImpl.java` 同一文件内，按顺序实现，最终统一编译验证。

---

## Function-Level Design

| 方法 | 职责 | 入参 | 返回 | 异常处理 | 测试要求 |
|---|---|---|---|---|---|
| `sendData(DispatcherRequest)` | 主流程入口：解析 JSON，按分组1循环，调 buildMsg310/pushToCore，最后发邮件 | DispatcherRequest | Revert（含 data JSON 数组） | catch 后返回 status=false,code=500,message=e.getMessage() | mock sequenceService/ediCoreServiceUtils/toolService；验证返回值和调用次数 |
| `buildMsg310(String, OceanShipment, List<OceanRate>, String)` | 构造完整 Msg310X12 对象 | logPrefix, shipment, rateGroup, controlNumber | Msg310X12 | 字段为 null 时 logger.warn + 跳过/留空，不抛异常 | 验证 ISA/B3/N1/R4/LX/L3 关键字段值；loadterm=LCL 时无 N7 |
| `pushToCore(String, String, String, EdiRunCycleLogRequestVo)` | 构建 CommonRequest，调 ediCoreServiceUtils.pushContentTo，更新 logVo | logPrefix, filename, content, logVo | void | 推送失败时 logVo.status="0"，logger.error，不抛异常 | 验证 CommonRequest sceneCode/customerScope/messageFormat=TXT；推送后 logVo.status 正确 |
| `mapFrom304(String, Msg310, OceanShipment)` | 人工占位：N9 非标准/R4*R/R4*E/N7N722/V1 | logPrefix, msg310, shipment | void | 无（空实现） | 验证方法存在且在 buildMsg310 return 前被调用 |

---

## Token Budget Estimate

| Task | 预估 token（输入+输出） | 说明 |
|---|---|---|
| TASK-001 | ~5K | 单行改动 |
| TASK-002 | ~8K | 简单 override 类 |
| TASK-003 | ~40K | 主流程 + 分组逻辑 + 日志/邮件骨架 |
| TASK-004 | ~35K | 映射密集，约 30 个字段 |
| TASK-005 | ~25K | 4 组 N1Group，结构重复 |
| TASK-006 | ~25K | R4/DTM 含条件逻辑 |
| TASK-007 | ~35K | 3 种分组聚合逻辑 |
| TASK-008 | ~15K | CommonRequest 构建 |
| TASK-009 | ~5K | 空方法 |
| **合计** | **~193K** | Mode 2 范围内（80K–200K）|
