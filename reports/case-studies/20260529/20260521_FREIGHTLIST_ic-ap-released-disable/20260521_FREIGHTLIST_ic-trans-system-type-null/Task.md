# Task - 20260521_FREIGHTLIST_ic-trans-system-type-null

## Task Breakdown

| # | Task | Status |
|---|---|---|
| 1 | 定位 `systemType` 赋值逻辑在 `Node2IcTransCalc.createIcTrans()` | Done |
| 2 | 分析 ext / shipmentDetail 都为 null 时缺少兜底赋值 | Done |
| 3 | 添加 else 分支从 `meta.getKeyShipment().getShSourceSystem()` 兜底 | Done |

## Implementation Notes

- 改动文件：`Node2IcTransCalc.java` (line 788-793)
- 改动内容：在 `createIcTrans()` 方法中，当 `ext` 和 `shipmentDetail` 都为 null 时，从 `meta.getKeyShipment().getShSourceSystem()` 取值，因为同一票的 sourceSystem 一致
- Node3IcTransFinalCalc line 306 从 IcTransactionEntity 复制 systemType，无需额外改动
