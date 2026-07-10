# Test

## P0 Cases

- T1: ic_section_header 设置 generatedPendingReleaseFlag=1, transType=PRV
- T2: ic_transaction_final AR 记录（transType=AR）设置 readyToRelease=Y, allowSend=1, arInvoiceNo=null, transType=PRV
- T3: ic_transaction_final AP 记录（transType=AP）设置 readyToRelease=N, allowSend=0, arInvoiceNo=null, transType=PRV
- T4: ic_transaction AR 记录（psAmount>0）设置 readyToRelease=Y, allowSend=1, arInvoiceNo=null, transType=PRV
- T5: ic_transaction AP 记录（psAmount<=0）设置 readyToRelease=N, allowSend=0, arInvoiceNo=null, transType=PRV
- T6: ic_transaction psAmount=null 视为 AP（不报错）
- T7: 空列表/null 列表不报错
