# AI Request - 20260520_FREIGHTLIST_ic-final-diff-amount

## Task Metadata

- **Owner**: Liangwb
- **Team**: FREIGHTLIST
- **Project**: bus-freightlist-handler-service
- **Date**: 2026-05-20
- **Task Type**: feature (补全已有方法的逻辑)
- **Execution Mode**: Mode 1 (LL-only)
- **Path**: B (`/ll-dev` Skill flow)

## Description

补充 `ic_trans_final_calc_v2` 节点中 `calcDiffAmount` 方法的计算差额逻辑。当前方法体为空（`//todo 计算差额`），需按业务规则实现：

1. 从 `ic_transaction_final` 表查找 serialNo 相同、version >= actVersion 的历史记录
2. 累加所有记录的 amount 得到 historyTotal
3. 差额 = transaction.getPsAmount() - historyTotal

## Input

- 用户提供了完整的算法伪代码
- 目标文件：`Node3IcTransFinalCalc.java` 第 331-340 行

## Expected Output

- `calcDiffAmount` 方法实现完整
- 注入 `IIcTransactionFinalService` 用于查询

## Branch Info

- **Base Branch**: develop_1.1.0
- **Task Type**: feature
- **New Branch Name**: feat/ic-final-diff-amount
- **Worktree Path**: .claude/worktrees/feat-ic-final-diff-amount
