# Test Design - 20260520_FREIGHTLIST_ic-final-history-globalinterlink

## Test Scope

Node3IcTransFinalCalc 的 `calcHistoryTotal`、`calcAmount`、`buildIcTransFinal` 方法改动。

## Mock Strategy

- `IIcTransactionFinalService.list(LambdaQueryWrapper)` mock 返回历史记录列表
- `IGlobalMonotonicService.nextEpoch` mock 返回固定值
- Mockito strictness: default (lenient not needed)

## Test Matrix

| # | Case | Type | Input | Expected | Related AC |
|---|---|---|---|---|---|
| 1 | 差额模式：有历史记录 | Normal | isDiffAmount=true, historyTotal=100, psAmount=150 | amount=50, isDiffAmount=1, transType=AP/AR | AC-1, AC-3 |
| 2 | 非差额模式 | Normal | isDiffAmount=false | amount=psAmount, isDiffAmount=0 | AC-1 |
| 3 | calcHistoryTotal 按 globalInterlink 查询 | Normal | globalInterlink="GL001", actVersion=5 | LambdaQueryWrapper 使用 globalInterlink 而非 serialNo | AC-2 |
| 4 | 历史记录为空 | Boundary | historyList 为空 | historyTotal=0 | AC-2 |
| 5 | 历史记录含 null amount | Boundary | 部分 history.amount=null | 跳过 null，只累加非 null | AC-2 |
| 6 | 多条 transaction 共用同一 historyTotal | Regression | 3 条 transaction，同一 globalInterlink | DB 只查询 1 次，3 条 final 共用同一 historyTotal | AC-3 |
| 7 | psAmount=0 被跳过 | Negative | transaction.psAmount=0 | 不生成 finalEntity | AC-1 |

## Boundary Cases

- historyTotal > psAmount: amount 为负数，transType=AP
- historyTotal = psAmount: amount=0，transType=AP（compareTo(ZERO) <= 0）
- historyTotal = 0: amount = psAmount

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| (none) | | | | |
