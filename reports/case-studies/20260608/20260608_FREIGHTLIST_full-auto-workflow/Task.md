# Task

1. 在 `IcAutoModeServiceImpl.fullAutoWorkflow` 内获取 `meta.getCurrentIcSectionHeader()`，设 `generatedPendingReleaseFlag=0`
2. 遍历 `meta.getIcTransactionList()`，逐条设 `readyToRelease="N"`, `arInvoiceNo=null`, `allowSend=1`
3. 遍历 `meta.getIcTransactionFinalList()`，逐条设同样三个字段
4. 各步骤前做 null 安全检查
5. 更新接口 `IIcAutoModeService.fullAutoWorkflow` 的 Javadoc 补充处理步骤
