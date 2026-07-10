# Scenario

补充 IcAutoModeServiceImpl 中 getArInvoiceNo 的获取逻辑，数据源与 isAllArChargesReleased 相同。

## Acceptance Criteria

- AC-1: 从 meta.getLinkedCharges() 筛选 cdlTransType=AR 且 cdlSource="B" 且状态在 [POSTED, CAN_POST, RELEASED] 中的费用
- AC-2: 只要有一条费用的 cdlTransNo 不为空，即返回该 cdlTransNo
- AC-3: 所有符合条件的费用都没有 cdlTransNo 或无符合条件费用时返回 null
