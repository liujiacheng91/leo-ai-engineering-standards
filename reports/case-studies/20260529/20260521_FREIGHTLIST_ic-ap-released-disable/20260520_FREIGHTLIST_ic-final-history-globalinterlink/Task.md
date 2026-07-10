# Task - 20260520_FREIGHTLIST_ic-final-history-globalinterlink

## Task List

| # | Task | Status | File | Notes |
|---|---|---|---|---|
| 1 | 新增 `calcHistoryTotal` 方法，按 `globalInterlink` 查询历史总额 | Done | Node3IcTransFinalCalc.java | 替代旧 `calcDiffAmount`，查询字段从 serialNo 改为 globalInterlink |
| 2 | `buildIcTransFinal` 循环外预计算 `isDiffAmount` 和 `historyTotal` | Done | Node3IcTransFinalCalc.java | 避免循环内重复查询 DB |
| 3 | `buildFinalEntity` 签名增加 `isDiffAmount` + `historyTotal` 参数 | Done | Node3IcTransFinalCalc.java | 透传到 calcAmount |
| 4 | `calcAmount` 签名调整，使用预计算参数替代 meta 查询 | Done | Node3IcTransFinalCalc.java | 差额 = psAmount - historyTotal |
| 5 | 删除旧 `calcDiffAmount` 方法 | Done | Node3IcTransFinalCalc.java | 已被 calcHistoryTotal 替代 |

## Implementation Summary

单文件改动，5 个关联步骤在同一 commit (`6beeeca`) 完成。改动集中在 `Node3IcTransFinalCalc.java`，+38 / -32 行。
