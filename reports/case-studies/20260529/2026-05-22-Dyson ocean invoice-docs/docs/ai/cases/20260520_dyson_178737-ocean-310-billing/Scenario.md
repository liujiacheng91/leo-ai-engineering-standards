# Scenario.md

## Scenario Name

Dyson Online Ocean Billing Send - MSG310 EDI Generation

## Business Background

LL 业务系统将 OceanShipment（含费用 oc_rate 列表和箱信息 oc_container 列表）推送至 EDI 接口。
EDI 将每组 oc_rate（按 client_id + invoice_no 分组）转换为一份 X12 MSG310 文件，推送给 Dyson。

## Current Problem

新增功能，目前无对应实现类。需要新建：
- `DysonOnlineOceanBillingSendProcess`（接口/抽象元数据）
- `DysonOnlineOceanBillingSendProcessImpl`（核心实现）

## Expected Outcome

1. 按 oc_rate.client_id + oc_rate.invoice_no 分组，每组生成一份 X12 MSG310 文件
2. 文件推送至 EDI Core（SFTP）
3. 写入日志表（EdiRunCycleLog）
4. 发送邮件通知（含原始报文和转换后报文作为附件）

## In Scope

- 新建 Process 接口类和 Impl 实现类（send/process 路径下）
- MSG310 X12 字段映射（ISA/GS/ST/B3/B2A/N9/C3/N1/N3/N4/R4/DTM/LX/N7/L0/L1/L3/SE/GE/IEA）
- 3 种分组逻辑（见分组定义）
- 日志写入和邮件发送
- `mapFrom304` 方法框架（占位方法，具体逻辑由人工补充）

## Out of Scope

- `mapFrom304` 内部实现（N9 非标准类型、R4*R、R4*E、N7/N722 的 "From 304" 字段、V1 船舶信息）
- MSG304 接收流程修改
- 生产环境部署和配置

## Grouping Definition

| 分组编号 | 分组键 | 作用 |
|---|---|---|
| 分组1 | oc_rate.client_id + oc_rate.invoice_no | 决定生成几份 MSG310 文件；B3、N1(BT/PR)、N3/N4(BT/PR)、L3/L3-05/L3-11 均按此分组统计 |
| 分组2 | oc_container.serial_no + oc_container.ctnr | 每个 N7/L0 节点对应一条分组2记录；N7/L0 的权重/体积/件数均按此分组 sum |
| 分组3 | oc_container.serial_no | L3/L3-01（总重）、L3/L3-09（总体积）按此分组 sum |

注：`oc_container` 在代码中对应 `OceanShipment.container_no`（`List<OceanShipmentContainer>`）。

## Method Structure

按需求约束，实现类必须包含 4 个独立方法：

| 方法 | 签名 | 说明 |
|---|---|---|
| 主流程 | `process(DispatcherRequest request)` | try-catch 包裹；最后调用日志和邮件 |
| 转换映射 | `buildMsg310(String logPrefix, OceanShipment oceanShipment, List<OceanRate> rateGroup)` | 生成单份 Msg310X12 |
| 推送 EDI Core | `pushToCore(String logPrefix, String filename, String content)` | 调用 EdiCoreServiceUtils |
| 占位转换 | `mapFrom304(String logPrefix, Msg310 msg310, OceanShipment oceanShipment)` | 人工实现 R4*R / R4*E / N9 非标准 / N7/N722 |

## Acceptance Criteria

| AC ID | Acceptance Criteria | Verification Method |
|---|---|---|
| AC-001 | 每组 oc_rate（client_id + invoice_no）生成独立 MSG310 文件 | 构造含 2 组 invoice 的 OceanShipment，验证生成 2 个文件 |
| AC-002 | ISA/GS 控制号（9 位，前缀 310）由序列服务生成，非重复 | 调用序列服务验证返回格式 |
| AC-003 | PROD 环境 ISA06=KERRY / ISA08=RBTWTMC / ISA15=P；TEST 反之 | 分 env=prod / env=uat 验证 |
| AC-004 | B3/B302=min(invoice_no)，B3/B307=sum(amount+vat_amount) by group1 | 对照 mapping.csv 字段验证 |
| AC-005 | ocean.terms=COLLECT → B3/B304=PP；ocean.terms=PREPAID → B3/B304=CC | 枚举两种 terms 值验证 |
| AC-006 | ocean.loadterm=LCL 时不生成 N7 节点 | 构造 loadterm=LCL 数据验证 |
| AC-007 | L0 按分组2生成，字段 sum 正确 | 对照 mapping.csv L0 字段验证 |
| AC-008 | 推送 EDI Core 后写入日志表，status=1 表成功 | 日志表查询 |
| AC-009 | 邮件发送含 input_body 和 output_body 两个附件 | 邮件收件箱验证 |
| AC-010 | mapFrom304 方法在 buildMsg310 完成后被调用（占位调用正确） | 代码 review 确认调用位置 |

## Open Questions (已确认 2026-05-20)

| Q# | 问题 | 确认结果 | 备注 |
|---|---|---|---|
| Q1 | 文件名格式冲突 | 使用 mapping.csv 格式：`LL_DYSON_310_#{invoiceNo}_#{controlNumber}.txt`，invoiceNo 去除非文件名字符 | requirements.md 描述已过期 |
| Q2 | B3/B304 兜底逻辑 | 给空字符串 | 待 BA 最终确认；当前以空字符串处理 |
| Q3 | oc_rate.customer_code 字段名 | 使用 `x_customer_code` | OceanRate 实体字段名 |
| Q4 | x_client_address 下划线 | 使用 `x_client_address_1` / `x_client_address_2`（带下划线）| 以 OceanRate 实体定义为准 |
| Q5 | V1 段是否需要 | 保留 V1（加入 mapFrom304 占位范围，人工实现） | mapping.csv 无 V1 映射，归入人工处理范围 |

## Suggested Risk Level

```text
Yellow
```

理由：
- 新增实现类，不修改已有逻辑，隔离性高
- 涉及 3 种分组聚合逻辑，逻辑复杂度中等
- mapFrom304 为占位方法，降低了不确定性
- 有 5 个 open question 需要人工确认后才能开始 Solution
- 需要人工确认 Solution.md 后方可生成 Task.md 和 Test.md

## Required Additional Documents

- [x] Mapping_Rules.md (需生成，基于 mapping.csv + 本文分组定义)
- [ ] Solution.md (待 Open Questions Q1–Q5 确认后生成)
- [ ] Task.md (待 Solution.md 人工审批后)
- [ ] Test.md (待 Solution.md 人工审批后)
