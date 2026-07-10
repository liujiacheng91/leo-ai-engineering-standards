# Test - 20260520_FREIGHTLIST_ic-final-history-station-filter

## Test Scope

Node3IcTransFinalCalc 差额计算逻辑重构：历史查询返回列表 + 按站点过滤累加。

## Test Matrix

| # | Case | Type | Description | Related AC |
|---|---|---|---|---|
| T-1 | queryHistoryList 返回列表 | Normal | 给定 globalInterlink + actVersion，验证返回 List 而非 BigDecimal | AC-1 |
| T-2 | queryHistoryList 空结果 | Boundary | DB 无匹配记录时返回空 ArrayList | AC-1 |
| T-3 | queryHistoryList null 结果 | Negative | service.list 返回 null 时返回空 ArrayList | AC-1 |
| T-4 | calcAmount 站点过滤 | Normal | 历史列表含多站点，仅累加与当前 entity 相同站点的金额 | AC-2, AC-3 |
| T-5 | calcAmount 无匹配站点 | Boundary | 历史列表无相同站点记录，差额 = psAmount 全值 | AC-2 |
| T-6 | calcAmount amount 为 null | Negative | 历史记录 amount 为 null 时跳过不累加 | AC-2 |
| T-7 | isStationsEqual 配对匹配 | Normal | 验证使用 meta.isStationsEqual 而非直接字符串比较 | AC-3 |
| T-8 | 非差额模式 | Normal | isDiffAmount=false 时金额 = psAmount，isDiffAmount=0 | AC-4 |
| T-9 | AR/AP 判定 | Normal | 差额 > 0 设 AR，差额 <= 0 设 AP | AC-5 |
| T-10 | 循环外预查询 | Regression | 历史列表在 for 循环外查询一次，多条 transaction 共享同一列表 | AC-1 |

## Mock Strategy

- `IIcTransactionFinalService.list(LambdaQueryWrapper)` - Mock 返回预设历史列表
- `IcTransMetaItem.isStationsEqual(String, String)` - 按测试场景返回 true/false
- Mockito strict stubs; primitive 参数用 `eq()` 而非 `anyInt()`

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| - | N/A | N/A | N/A | N/A |
