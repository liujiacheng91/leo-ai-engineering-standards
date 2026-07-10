# Test - 20260520_FREIGHTLIST_ic-final-diff-amount

## Test Scope

对 `Node3IcTransFinalCalc.calcDiffAmount` 方法的单元测试设计。

## Mock Strategy

- Mock `IIcTransactionFinalService.list(LambdaQueryWrapper)` 返回不同场景的历史记录列表
- Mock `IcTransMetaItem` 和 `IcTransactionEntity` 提供输入参数
- Mockito strict stubs 模式

## Test Matrix

| # | Case | Input | Expected Output | Related AC |
|---|---|---|---|---|
| 1 | 有历史记录，差额为正 | psAmount=100, historyTotal=60 | amount=40 | AC-1, AC-3, AC-4 |
| 2 | 有历史记录，差额为负 | psAmount=50, historyTotal=80 | amount=-30 | AC-1, AC-3, AC-4 |
| 3 | 有历史记录，差额为零 | psAmount=100, historyTotal=100 | amount=0 | AC-1, AC-3, AC-4 |
| 4 | 无历史记录（空列表） | psAmount=100, historyList=[] | amount=100 | AC-1, AC-2, AC-4 |
| 5 | 历史记录 amount 含 null | psAmount=100, history=[50, null, 20] | amount=30 | AC-3 |
| 6 | firstActualIcHeader 为 null | meta.firstActualIcHeader=null | amount=0（不进入计算） | AC-1 |
| 7 | historyList 返回 null | icTransactionFinalService.list=null | amount=100 | AC-2 |

## Boundary Cases

- 历史记录列表为 null
- 历史记录列表为空
- 单条历史记录 amount 为 null
- 所有历史记录 amount 都为 null
- psAmount 很大时的精度

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| (none) | | | | |
