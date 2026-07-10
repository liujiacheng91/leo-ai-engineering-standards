# Scenario - 20260520_FREIGHTLIST_ic-final-diff-amount

## Background

IC_TRANS_FINAL 链的 Node3 (`ic_trans_final_calc_v2`) 在 `calcAmount` 中判断：如果存在 ACT（首次实际交易），则金额应为差值而非全值。当前 `calcDiffAmount` 方法是空实现（`//todo`），需要补全。

## User Story

当 IC_TRANS_FINAL 链处理一条已有 ACT 记录的 interlink 时，生成的 `IcTransactionFinalEntity.amount` 应为当前 psAmount 与历史同 serialNo 已入库金额之差，而非全额。

## Acceptance Criteria

- AC-1: 当 firstActualIcHeader 存在时，calcDiffAmount 应从 ic_transaction_final 表查询 serialNo 相同且 version >= actVersion 的记录
- AC-2: 查询结果的 amount 字段累加得到 historyTotal
- AC-3: 返回值 = transaction.getPsAmount() - historyTotal
- AC-4: 查询无结果时 historyTotal = 0，返回 transaction.getPsAmount()

## Assumptions

- serialNo + version >= actVersion 是充分的过滤条件（用户明确指定）
- amount 字段可能为 null（需防御）

## Scope

- 改动文件：`Node3IcTransFinalCalc.java`（补全方法 + 注入服务）
- 不动：其他节点、其他表、chain 定义
