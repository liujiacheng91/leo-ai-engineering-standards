# Task - 20260520_FREIGHTLIST_ic-final-diff-amount

## Task Breakdown

| # | Task | Status |
|---|---|---|
| 1 | 在 `Node3IcTransFinalCalc` 构造器注入 `IIcTransactionFinalService` | Done |
| 2 | 实现 `calcDiffAmount` 方法：查询历史记录、累加 amount、计算差额 | Done |

## Implementation Notes

- 新增 `LambdaQueryWrapper` import 用于条件查询
- 新增 `IIcTransactionFinalService` import 和构造器注入（遵循仓库只用构造器注入的规约）
- `calcDiffAmount` 查询条件：`serialNo` 相等 + `version >= actVersion`
- 累加时对 `null` amount 做了防御性跳过
- 差额公式：`transaction.getPsAmount() - historyTotal`

## Files Changed

| File | Change |
|---|---|
| `Node3IcTransFinalCalc.java` | +2 imports, +1 field, 构造器加参数, 实现 calcDiffAmount 方法体 |
