# Scenario

## Requirement

实现 IcAutoModeServiceImpl.executeApChargesProcessing 方法：
1. 通过 getArInvoiceNo 获取 AR 发票号（占位函数）
2. 设置 ic_section_header: generated_pending_release_flag=0, trans_type=ACT
3. 遍历 ic_transaction_final：AR 费用 allowSend=0/arInvoiceNo=null，AP 费用 allowSend=1/arInvoiceNo=获取值
4. 遍历 ic_transaction：同上 AR/AP 分别设置
5. 所有记录 readyToRelease=N, transType=ACT

## Acceptance Criteria

- AC-1: getArInvoiceNo 为占位方法，默认返回 null，带 TODO
- AC-2: ic_section_header 设置 generatedPendingReleaseFlag=0, transType=ACT
- AC-3: ic_transaction_final AR 记录 readyToRelease=N, arInvoiceNo=null, allowSend=0, transType=ACT
- AC-4: ic_transaction_final AP 记录 readyToRelease=N, arInvoiceNo=arInvoiceNo, allowSend=1, transType=ACT
- AC-5: ic_transaction AR/AP 同上规则
