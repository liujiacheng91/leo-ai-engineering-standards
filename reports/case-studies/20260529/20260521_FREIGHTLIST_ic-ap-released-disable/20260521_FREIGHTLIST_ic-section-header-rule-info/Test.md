# Test

## Case
20260521_FREIGHTLIST_ic-section-header-rule-info

## Test Scope
- Node1Trigger.createIcSectionHeader 方法中 ruleId/triggerRule 赋值逻辑

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | lastIcHeader 不为空 | lastIcHeader.ruleId=5L, lastIcHeader.triggerRule="RuleA" | icSectionHeader.ruleId=5L, triggerRule="RuleA" | AC-1 |
| 2 | lastIcHeader 为空, currentTriggerConfig 不为空 | currentTriggerConfig.id=3, ruleName="RuleB" | icSectionHeader.ruleId=3L, triggerRule="RuleB" | AC-2 |
| 3 | 两者都为空 | lastIcHeader=null, currentTriggerConfig=null | ruleId=null, triggerRule=null | AC-3 |
| 4 | lastIcHeader 的 ruleId/triggerRule 为 null | lastIcHeader.ruleId=null, triggerRule=null | icSectionHeader.ruleId=null, triggerRule=null | AC-1 |

## Fix History
（无）
