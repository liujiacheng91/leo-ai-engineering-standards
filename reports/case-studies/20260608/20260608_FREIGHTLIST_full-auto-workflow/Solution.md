# Solution

## Technical Constraints

- Pre-verified Environment: worktree + JGit 不兼容，Track B
- 目标文件: `IcAutoModeServiceImpl.java:89-91`（当前 TODO 占位）
- 字段已验证: `IcSectionHeaderEntity.generatedPendingReleaseFlag`(Integer), `IcTransactionEntity.readyToRelease`(String)/`arInvoiceNo`(String)/`allowSend`(Integer), `IcTransactionFinalEntity` 同名字段
- Meta 访问: `IcTransMetaItem.currentIcSectionHeader` / `.icTransactionList` / `.icTransactionFinalList`

## Task

1. 在 `fullAutoWorkflow` 内获取 `meta.getCurrentIcSectionHeader()`，设 `generatedPendingReleaseFlag=0`
2. 遍历 `meta.getIcTransactionList()`，逐条设 `readyToRelease="N"`, `arInvoiceNo=null`, `allowSend=1`
3. 遍历 `meta.getIcTransactionFinalList()`，逐条设同样三个字段
4. 各步骤前做 null 安全检查
