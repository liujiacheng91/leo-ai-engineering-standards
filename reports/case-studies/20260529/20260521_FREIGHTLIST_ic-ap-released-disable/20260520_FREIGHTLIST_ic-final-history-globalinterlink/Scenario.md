# Scenario - ic-final-history-globalinterlink

## Background
`Node3IcTransFinalCalc.calcDiffAmount` 当前按 `serialNo` 查 `ic_transaction_final` 表历史记录，且每个 transaction 循环内都重复查询。同一 interlink 下多个 transaction_final 记录共享同一个 `globalInterlink`，查询结果相同但被重复执行。

## Goal
1. 查询条件从 `serialNo` 改为 `globalInterlink`（按业务语义，历史差额应按 interlink 粒度查）
2. 将历史查询和 historyTotal 累加提取到 `buildIcTransFinal` 的 transaction 循环外
3. 将 `meta.getFirstActualIcHeader() != null` 的差额判断也提取到循环外

## Acceptance Criteria
- AC-1: 历史查询改用 `globalInterlink` 字段匹配（不再用 `serialNo`）
- AC-2: 历史查询在 transaction 循环外只执行一次，循环内复用结果
- AC-3: 差额判断 `isDiffAmount` 在循环外计算一次，循环内直接使用
- AC-4: 差额公式不变：`transaction.getPsAmount() - historyTotal`
- AC-5: 非差额模式（无 firstActualIcHeader）行为不变：amount = psAmount, isDiffAmount = 0

## Assumptions
- 同一 `IcTransMetaItem` 下所有 `IcTransactionEntity` 共享同一个 `globalInterlink`
- `IcTransactionFinalEntity` 有 `globalInterlink` 字段且已建立索引/可查询
