# Scenario

## Requirement

补充 IcAutoModeServiceImpl.processArCharges 方法逻辑：
1. 设置 ic_section_header 的 generated_pending_release_flag=1, trans_type=PRV
2. 遍历 ic_transaction_final，按 AR/AP 分别设置 ready_to_release/ar_invoice_no/allow_send/trans_type
3. 遍历 ic_transaction，按 AR/AP 分别设置（ic_transaction 无直接 AR/AP 字段，需从 psAmount 计算）
4. AR/AP 判断逻辑提取为共享函数，方便复用

## Acceptance Criteria

- AC-1: ic_section_header 的 generatedPendingReleaseFlag=1, transType=PRV
- AC-2: ic_transaction_final AR 记录 readyToRelease=Y, arInvoiceNo=null, allowSend=1, transType=PRV
- AC-3: ic_transaction_final AP 记录 readyToRelease=N, arInvoiceNo=null, allowSend=0, transType=PRV
- AC-4: ic_transaction AR 记录（psAmount>0）readyToRelease=Y, arInvoiceNo=null, allowSend=1, transType=PRV
- AC-5: ic_transaction AP 记录（psAmount<=0）readyToRelease=N, arInvoiceNo=null, allowSend=0, transType=PRV
- AC-6: isArCharge 为重载方法，IcTransactionFinalEntity 版读 transType，IcTransactionEntity 版计算 psAmount
