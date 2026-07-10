# Test

## P0 Cases

- T1: fullAutoWorkflow 正常调用后，sectionHeader.generatedPendingReleaseFlag=0, 每条 transaction 的 readyToRelease=N/arInvoiceNo=null/allowSend=1
- T2: meta 中列表为 null 或空时不报错，安全跳过
