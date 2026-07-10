# Scenario

## Requirement

补充 `IcAutoModeServiceImpl.fullAutoWorkflow` 方法逻辑，实现全自动模式下对 IC 数据的标记处理：
1. 从 meta 获取 ic_section_header，设置 generated_pending_release_flag=0
2. 从 meta 获取 ic_transaction 记录，遍历设置 ready_to_release=N, ar_invoice_no=空, allow_send=1
3. 从 meta 获取 ic_transaction_final 记录，遍历设置 ready_to_release=N, ar_invoice_no=空, allow_send=1

## Acceptance Criteria

- AC-1: fullAutoWorkflow 调用后，meta.currentIcSectionHeader.generatedPendingReleaseFlag 被设为 0
- AC-2: meta.icTransactionList 中每条记录的 readyToRelease=N, arInvoiceNo=null, allowSend=1
- AC-3: meta.icTransactionFinalList 中每条记录的 readyToRelease=N, arInvoiceNo=null, allowSend=1
- AC-4: 列表为 null 或空时不报错，安全跳过
