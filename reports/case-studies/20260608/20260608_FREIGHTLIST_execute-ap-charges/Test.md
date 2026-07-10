# Test

## P0 Cases

- T1: ic_section_header 设置 generatedPendingReleaseFlag=0, transType=ACT
- T2: ic_transaction_final AR 记录 readyToRelease=N, arInvoiceNo=null, allowSend=0, transType=ACT
- T3: ic_transaction_final AP 记录 readyToRelease=N, arInvoiceNo=arInvoiceNo值, allowSend=1, transType=ACT
- T4: ic_transaction AR/AP 同 T2/T3 规则
- T5: getArInvoiceNo 默认返回 null（占位行为）
- T6: 空列表/null 列表不报错
