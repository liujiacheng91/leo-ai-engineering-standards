# Scenario

补充 IcAutoModeServiceImpl 中 isAllArChargesReleased 的判断逻辑，参考 IcTriggerConfigServiceImpl.isAllArChargePosted 的模式。

## Acceptance Criteria

- AC-1: 从 meta.getLinkedCharges() 获取费用列表，只筛选 cdlTransType=AR 且 cdlSource="B" 的记录
- AC-2: 筛选出的 AR+source=B 费用状态全部在 [POSTED, CAN_POST, RELEASED] 中时返回 true
- AC-3: 任一费用状态不在列表中返回 false
- AC-4: 没有符合条件的费用记录时返回 false（区别于 isAllArChargePosted 的空列表返回 true）
