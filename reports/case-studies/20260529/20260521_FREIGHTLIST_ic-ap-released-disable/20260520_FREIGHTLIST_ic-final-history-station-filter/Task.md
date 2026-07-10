# Task - 20260520_FREIGHTLIST_ic-final-history-station-filter

## Implementation Steps

| # | Task | File | Status |
|---|---|---|---|
| 1 | 将 `calcHistoryTotal` 改为 `queryHistoryList`，返回 `List<IcTransactionFinalEntity>` | Node3IcTransFinalCalc.java | Done |
| 2 | `buildIcTransFinal` 循环外预查询历史列表，传入 `buildFinalEntity` | Node3IcTransFinalCalc.java | Done |
| 3 | `buildFinalEntity` 签名改为接收 `List<IcTransactionFinalEntity> historyList` | Node3IcTransFinalCalc.java | Done |
| 4 | `calcAmount` 新增 `IcTransMetaItem meta` 参数，遍历历史列表按站点过滤累加 | Node3IcTransFinalCalc.java | Done |
| 5 | 站点比较统一使用 `meta.isStationsEqual` | Node3IcTransFinalCalc.java | Done |

## Commit

- `ca19a74` - 重构差额计算：历史查询返回列表并按站点过滤累加
