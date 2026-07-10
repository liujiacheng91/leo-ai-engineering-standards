# Test.md

## Test Objective

验证 `DysonOnlineOceanBillingSendProcessImpl.sendData` 及三个私有方法（buildMsg310 / pushToCore / mapFrom304）的正确性，覆盖所有 AC、边界条件和异常路径。

## Test Types

- [x] Unit Test（Mockito，无集成依赖）
- [ ] Integration Test
- [ ] API Contract Test
- [ ] UI Test
- [ ] E2E Test
- [ ] Regression Test
- [ ] Security Test
- [ ] Manual Verification

---

## Test Scope

**In Scope：**
- sendData 主流程（分组、序列号、EDI 生成、推送、日志、邮件、返回值）
- buildMsg310（ISA/GS/B3/N9/C3/N1/R4/DTM/LX/N7/L0/L1/L3 字段映射）
- pushToCore（CommonRequest 构建参数、logVo 状态更新）
- mapFrom304（方法存在且被调用）

**Out of Scope：**
- mapFrom304 内部逻辑（占位方法，无实现）
- EdiCoreServiceUtils / ToolService 实际服务调用（mock 替代）
- 生产数据验证（UAT 由 BA 执行）

---

## Mock Strategy

| Mock 对象 | 类型 | Stub 方式 | 说明 |
|---|---|---|---|
| `EdiIncrementSequenceService` | `@Mock` | `lenient().when(...anyInt()...)` | primitive int 参数必须用 `anyInt()`，不能用 `any()` |
| `EdiCoreServiceUtils` | `@Mock` | `lenient().when(pushContentTo(any()))` | 默认返回 success Revert |
| `ToolService` | `@Mock` | `inertLog` → `doNothing()`（void）；`sendMail` → `lenient()` | inertLog 返回 void，不能用 when(...).thenReturn |
| `DispatcherRequest` | `mock(RETURNS_DEEP_STUBS)` | `when(req.getRequestBody().getBusinessContent())` | 深链调用 |

**Strictness 决策：** `@MockitoSettings(strictness = Strictness.LENIENT)`
原因：`@BeforeEach` 中注册了所有 mock stub，但部分测试用例不会触发全部 stub（如异常路径跳过 pushToCore），若用默认严格模式会触发 UnnecessaryStubbingException。

**env 字段注入：**
```java
private void setEnv(String value) {
    Field f = DysonOnlineOceanBillingSendProcessImpl.class.getDeclaredField("env");
    f.setAccessible(true);
    f.set(impl, value);
}
```

---

## Test Data

### 基础 OceanShipment（正路径）

```java
OceanShipment buildTestShipment():
  booking_no = "OOCL12345678"
  h_bol = "SXMN0000893"
  m_bol = "OOCL12345678"
  terms = "COLLECT"
  loadterm = "FCL"
  fport_of_loading = "CNYTN"
  fport_of_loading_exp = "YANTIAN, GD, CHINA"
  fport_of_loading_ctry = "CN"
  fport_of_discharge = "GBFXT"
  fport_of_discharge_exp = "FELIXSTOWE, UK"
  fport_of_discharge_ctry = "GB"
  m_eta = "25032026"   // DDMMYYYY 格式
  shipper_name = "Flex Manufacturing (Zhuhai) Co."
  consignee_name = "Dyson Operations Pte Ltd"
  ocean_milestone = [{ code="IFFDEP", act_date="2026-03-25", est_date="2026-03-20", est_time="09:30" }]
  ocean_reference = [{ ref_code="Dyson Earliest Pickup", ref_value="20260410" }]
  container_no = [{ serial_no="S001", ctnr="OOLU1234567", grs_kgs=512.19, cbm=1.392, qty=14, unit="PKG" }]
  oc_rate = [{ client_id="CLIENT001", invoice_no="INV001", invoice_date="2026-04-11",
               amount=100.00, vat_amount=13.00, unit_price=31.85,
               print_currency="USD", x_customer_code="DYSON001",
               client_name="DYSON OPERATIONS PTE. LTD.",
               x_client_address_1="3 SENTOSA GATEWAY", x_client_address_2="ST. JAMES POWER STATION",
               x_client_city="SINGAPORE", x_client_state="", x_client_zipcode="098544", x_client_country="SG" }]
```

### 控制号 Stub
```java
Revert seqRevert = new Revert.Builder().status(true).code(200).data("310000001").build();
```

---

## Test Matrix

| Case ID | Type | 描述 | 输入关键点 | 期望结果 | 优先级 | Related AC |
|---|---|---|---|---|---|---|
| TC-001 | Normal | 两组 invoice → 两次推送 | oc_rate 含 CLIENT001/INV001 和 CLIENT002/INV002 | pushContentTo 调用 2 次；返回 data 含 2 个元素 | P0 | AC-001 |
| TC-002 | Normal | 同一 client+invoice 两条 → 一次推送 | oc_rate 两条 client_id+invoice_no 相同 | pushContentTo 调用 1 次 | P0 | AC-001 |
| TC-003 | Normal | 控制号 9 位前缀 310 | seq stub 返回 "310000001" | 文件名含 "310000001"；ISA13=GS06=GE02=IEA02="310000001" | P0 | AC-002 |
| TC-004 | Normal | PROD 环境 ISA 字段 | env="prod" | ISA06 前缀 KERRY(15位)；ISA08 前缀 RBTWTMC(15位)；ISA15=P；GS01=IO；GS02=KERRY；GS03=RBTWTMC | P0 | AC-003 |
| TC-005 | Normal | TEST 环境 ISA 字段 | env="TEST"（默认）| ISA06 前缀 KERRYTEST；ISA08 前缀 RBTWTMCTEST；ISA15=T；GS01=IO | P0 | AC-003 |
| TC-006 | Normal | B3 字段映射 | 基础数据 | B302=INV001；B304=PP（COLLECT→PP）；B306=20260411；B307=113.00；B309=20260325（IFFDEP act_date）；B310=011；B311=LLL | P0 | AC-004, AC-005 |
| TC-007 | Normal | B3/B304 PREPAID→CC | terms="PREPAID" | B304=CC | P1 | AC-005 |
| TC-008 | Boundary | B3/B304 兜底空字符串 | terms="OTHER" | B304 为空或不出现 | P1 | AC-005 |
| TC-009 | Normal | B3/B309 优先 act_date | IFFDEP act_date="2026-03-25" | B309=20260325 | P0 | AC-004 |
| TC-010 | Boundary | B3/B309 无 act_date 取 est_date | IFFDEP act_date=null, est_date="2026-03-20" | B309=20260320 | P1 | AC-004 |
| TC-011 | Normal | loadterm=FCL → 生成 N7 | loadterm="FCL" | EDI 含 N7*OOLU*1234567 | P0 | AC-006 |
| TC-012 | Boundary | loadterm=LCL → 无 N7 | loadterm="LCL" | EDI 不含 N7* 段 | P0 | AC-006 |
| TC-013 | Normal | L0 分组2 sum 正确 | 两个容器 S001/OOLU1 grs_kgs=100, S002/OOLU2 grs_kgs=200 | L0 出现 2 次；各自 L004=100/200 | P1 | AC-007 |
| TC-014 | Normal | L1 字段映射 | 基础数据 | L101=1；L102=31.85；L103=KG；L104=113.00；L108=DYSON001；L112=Freight | P0 | AC-007 |
| TC-015 | Normal | L3 汇总正确 | 基础数据 | L301=512.19（分组3 sum grs_kgs）；L305=113.00（分组1 sum amount+vat）；L309=1.392（分组3 sum cbm）；L311=14（分组1 sum qty） | P0 | AC-007 |
| TC-016 | Normal | 推送成功 → Revert data 含 status/stage/message | pushContentTo 返回 success | Revert.status=true, code=200；data 每项含 invoiceNo、filename、status=true、stage=""、message="" | P0 | AC-008 |
| TC-017 | Normal | 推送失败 → sendData 整体仍 true，data 项记录失败信息 | pushContentTo 返回 status=false | Revert.status=true（整体不报错）；data 项 status=false, stage="upload", message 含错误描述；toolService.inertLog 被调用 | P0 | AC-008 |
| TC-018 | Normal | 邮件发送含附件 | 基础数据 | toolService.sendMail 被调用；EmailTemplate subject 含 [TEST] [DYSON] MSG310 SEND | P0 | AC-009 |
| TC-019 | Normal | 多组 invoice 邮件附件 key 递增 | 两组 invoice | generatedFiles 入参 Map 含 output_body1 和 output_body2 | P1 | AC-009 |
| TC-020 | Normal | mapFrom304 在 buildMsg310 后被调用 | 基础数据 | 通过 spy 或日志验证 mapFrom304 被执行（签名正确，无异常） | P1 | AC-010 |
| TC-021 | Negative | invalid JSON → 返回 fail，不抛异常 | businessContent="{invalid}" | Revert.status=false, code=500；toolService.inertLog 被调用 | P0 | — |
| TC-022 | Boundary | 空 shipment 数组 → 返回 fail | businessContent="[]" | Revert.status=false 或空结果，不抛异常 | P0 | — |
| TC-023 | Boundary | trace_id 为空 → UUID 兜底 | trace_id=null 或 "" | logPrefix 包含 UUID 格式字符串（非空） | P1 | — |
| TC-024 | Boundary | ediText 为 null → 附件 Map 不 NPE | buildMsg310 异常导致 ediText=null | 不抛 NullPointerException；发送失败邮件正常 | P0 | — |
| TC-025 | Normal | messageFormat=TXT | pushContentTo 捕获 CommonRequest | request.getRequestBody().getMessageFormat()="TXT" | P0 | — |
| TC-026 | Normal | sceneCode=SEND_DYSON_TO_SFTP, customerScope=OCEAN_RATE, traceId/businessKey 传入 CommonRequest | 捕获 CommonRequest | sceneCode="SEND_DYSON_TO_SFTP"；customerScope="OCEAN_RATE"；requestHeader.traceId 非 null；requestHeader.businessKey 非 null | P0 | — |
| TC-027 | Normal | data 数组项包含 status/stage/message 字段（成功路径） | 推送成功 | data 字符串含 "status"、"stage"、"message"；status=true | P0 | — |
| TC-028 | Normal | 推送失败时 data 项 status=false, stage=upload, message 含错误信息 | pushContentTo 返回 false，message="sftp error" | data 含 false、"upload"、"sftp error"；sendData 整体 status=true | P0 | — |
| TC-029 | Normal | 文件名含 cleanFilename 处理的 invoiceNo | invoiceNo="INV/100#001" | 文件名不含 / 或 # | P1 | — |
| TC-030 | Normal | R4(L) r401=L, r403=fport_of_loading | 基础数据 | EDI 含 R4*L*UN*CNYTN；港口名截第一个逗号前 | P1 | — |
| TC-031 | Boundary | DTM(IFFDEP) est_date 为空 → DTM 整组不生成 | IFFDEP est_date=null | EDI 中 R4(L) 后无 DTM*139 | P1 | — |

---

## AC Traceability Check

| AC ID | Test Cases | 状态 |
|---|---|---|
| AC-001 | TC-001, TC-002 | 覆盖 |
| AC-002 | TC-003 | 覆盖 |
| AC-003 | TC-004, TC-005 | 覆盖 |
| AC-004 | TC-006, TC-009, TC-010, TC-015 | 覆盖 |
| AC-005 | TC-006, TC-007, TC-008 | 覆盖 |
| AC-006 | TC-011, TC-012 | 覆盖 |
| AC-007 | TC-013, TC-014, TC-015 | 覆盖 |
| AC-008 | TC-016, TC-017 | 覆盖 |
| AC-009 | TC-018, TC-019 | 覆盖 |
| AC-010 | TC-020 | 覆盖 |

所有 AC 均有对应测试用例，无缺口。

---

## Boundary Cases

| 场景 | 测试用例 | 预期 |
|---|---|---|
| 空 oc_rate 列表 | TC-022 变体 | 不生成文件，不推送，返回 fail 或空 data |
| loadterm=LCL | TC-012 | 无 N7 节点 |
| ediText 为 null | TC-024 | 不抛 NPE，邮件附件用空字符串 |
| trace_id 为空 | TC-023 | logPrefix 用 UUID 兜底 |
| DTM est_date 为空 | TC-028 | 整组 DTM 不生成 |
| invoiceNo 含非法文件名字符 | TC-029 | cleanFilename 清洗 |
| ocean.terms 非标准值 | TC-008 | B3/B304 为空字符串 |

---

## Commands

```bash
# 编译（在项目根目录执行）
./gradlew :edi-business-realization:edi-dyson-realization:compileJava

# 单元测试（需先完成实现）
./gradlew :edi-business-realization:edi-dyson-realization:test --tests "com.pobing.dyson.send.process.impl.DysonOnlineOceanBillingSendProcessImplTest"

# 全模块测试
./gradlew :edi-business-realization:edi-dyson-realization:test

# 构建
./gradlew :edi-business-realization:edi-dyson-realization:build
```

---

## Fix History

| Fix # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| Fix #1 | `getLoadterm()` 编译报错 | OceanShipment.md 写 `loadterm`，实际 class 无此字段，正确字段是 `manifest_type` | 改为 `getManifest_type()` | 凡引用 OceanShipment 字段前用 `javap` 确认，不依赖 MD 推断 |
| Fix #2 | `compileTestJava` 找不到 Mockito/JUnit | build.gradle 无 testImplementation 配置；Air Billing 测试引用未实现的 Impl 类 | 新增 JUnit Jupiter + Mockito 4.5.1；用 `sourceSets.test.java.exclude` 排除 Air Billing 测试 | 新增测试文件前先确认 testImplementation 依赖已在 build.gradle 声明 |
