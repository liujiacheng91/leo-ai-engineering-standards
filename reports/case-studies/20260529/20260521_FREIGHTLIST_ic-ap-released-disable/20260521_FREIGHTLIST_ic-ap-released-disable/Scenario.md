# Scenario.md

## Case
20260521_FREIGHTLIST_ic-ap-released-disable

## Background

IC_TRANS v2 链的 Node1Trigger 在触发判断中会调用 `isAllApChargeReleased` 检查所有 AP 费用是否已 Released。业务方要求临时关闭此检查，使该判断始终通过。

## Acceptance Criteria

- AC-1: `isAllApChargeReleased` 方法固定返回 true，不再遍历 linkedCharges 做状态检查
- AC-2: 原有逻辑以注释形式保留（便于后续恢复）
- AC-3: Node1Trigger 中调用 `isAllApChargeReleased` 的两处代码不需要改动（方法返回 true 即可跳过 PROVISIONAL 分支）

## Assumptions

- 这是临时关闭，后续可能恢复，因此用注释而非删除
- 接口签名 `IIcTriggerConfigService.isAllApChargeReleased` 保持不变

## Impact

- 影响 IC_TRANS 和 IC_TRANS_FINAL 的触发判断（共享 v2 链）
- 不影响 DB schema、不影响 PDF 团队
