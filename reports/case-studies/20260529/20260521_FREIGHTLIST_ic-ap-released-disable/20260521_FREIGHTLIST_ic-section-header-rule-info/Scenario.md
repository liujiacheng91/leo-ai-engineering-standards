# Scenario

## Case
20260521_FREIGHTLIST_ic-section-header-rule-info

## Background
IC v2 链 Node1Trigger 的 createIcSectionHeader 方法创建 IcSectionHeaderEntity 后，未设置 rule_id 和 trigger_rule 字段。需要根据优先级从 lastIcHeader 或 currentTriggerConfig 获取规则信息。

## Acceptance Criteria
- AC-1: 当 lastIcHeader 不为空时，新建的 icSectionHeader.ruleId = lastIcHeader.ruleId，icSectionHeader.triggerRule = lastIcHeader.triggerRule
- AC-2: 当 lastIcHeader 为空且 meta.currentTriggerConfig 不为空时，新建的 icSectionHeader.ruleId = currentTriggerConfig.id（转 Long），icSectionHeader.triggerRule = currentTriggerConfig.ruleName
- AC-3: 当 lastIcHeader 为空且 currentTriggerConfig 也为空时，ruleId 和 triggerRule 保持 null（不设置）

## Assumptions
- lastIcHeader 的 ruleId/triggerRule 可能为 null（历史数据未设置过），此时直接赋 null 可接受
- IcTriggerConfigEntity.id 为 Integer(auto-increment)，转 Long 无精度损失
