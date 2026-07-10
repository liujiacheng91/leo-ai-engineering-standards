# Solution - 20260520_FREIGHTLIST_ic-final-diff-amount

## Technical Constraints

- Java 21
- MyBatis-Plus `IService.list(LambdaQueryWrapper)` 用于查询
- `IcTransactionFinalEntity` 字段：`serialNo`(String)、`version`(Long)、`amount`(BigDecimal)
- 构造器注入（不用 `@Autowired`）
- LiteFlow 节点吞异常不 rethrow

## Recommended Solution

在 `Node3IcTransFinalCalc` 中：

1. 注入 `IIcTransactionFinalService`（构造器注入，新增 final 字段）
2. `calcDiffAmount` 方法实现：
   - 用 `LambdaQueryWrapper` 查 `ic_transaction_final` 表：`serial_no = serialNo AND version >= actVersion`
   - stream reduce 累加 `amount`（null 安全）
   - 返回 `transaction.getPsAmount() - historyTotal`

改动文件：仅 `Node3IcTransFinalCalc.java`

## Worktree Build Feasibility

已知 JGit + worktree 不兼容（versioning 插件）。Track B 激活。

## Post-Merge Test Plan

- Command: `gradle :expand:business-freightlist-summary:test`
- Owner: Liangwb
- Timing: 合并后立即执行
