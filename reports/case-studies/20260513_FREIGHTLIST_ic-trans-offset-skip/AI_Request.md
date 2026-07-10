# AI_Request

| 字段 | 值 |
|---|---|
| Case ID | 20260513_FREIGHTLIST_ic-trans-offset-skip |
| Owner | LiangWB |
| Team | FREIGHTLIST |
| Project | bus-freightlist-handler-service |
| 创建时间 | 2026-05-13 |
| 预期产物 | Scenario.md / AI_Risk_Level.md / Solution.md / Task.md / Verify.md / PR_Template.md / AI_Case_Card.md / Token_Usage_Report.md |
| 模式 | LL-only（四员工瀑布暂停期） |

## 用户原始需求

1. IC trans 流程简化
2. 现有的 charge offset 中的逻辑调整，不再往 ic_transaction_offset（实际对应 `ic_charge_detail_offset`）写数据
3. 相关代码尽量不要删除，因为后续还有可能会调整
4. 其他流程有用到 ic_transaction_offset 数据的，需要一并调整，不能因为没有数据导致报错

## 输入清单

- IC_TRANS 链：ic_trigger → ic_charge_matching → **ic_charge_offset** → ic_trans_calc → ic_save（5节点）
- `Node3ChargeOffset.java`：生成 `IcChargeDetailOffsetEntity` 列表，存入 `meta.icChargeOffsets`
- `Node4IcTransCalc.java`：从 `meta.getIcChargeOffsets()` 读取，用于 fillPendingIc / fillReceiverOsPS / fillReceiverOsIcSweep 三处计算
- `Node5Save.java`：将 `meta.getIcChargeOffsets()` 批量写入 `ic_charge_detail_offset` 表
- 确认：`ic_charge_detail_offset` 为 write-only 表，无任何 DB 读取逻辑
- 确认：Node4 三处读取已有 `null` 判断，offset 为 null 时安全返回 0

## 需求池引用

无（新需求，本次在案内完结）
