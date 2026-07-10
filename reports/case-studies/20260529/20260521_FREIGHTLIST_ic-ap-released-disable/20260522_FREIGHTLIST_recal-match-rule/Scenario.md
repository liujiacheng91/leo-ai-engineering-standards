# Scenario.md

## Case Info

- Case ID: 20260522_FREIGHTLIST_recal-match-rule
- Scenario: 实现 reCalMatchRule 重计算触发规则匹配逻辑

## Background

IC_TRANS 链的 Node1Trigger 节点在重计算场景下调用 `reCalMatchRule(meta)` 判断是否应触发重计算。当前该方法是 todo 桩，直接返回 true，未做任何规则校验。

需要补充完整逻辑：从上一次 IC 计算记录（`lastIcHeader`）中获取 `ruleId`，查找对应的触发配置，然后校验 `stop_after_minutes` 和 `regen_threshold` 两个维度。

## Assumptions

- `lastIcHeader` 为空或 `ruleId` 为空时，视为无历史规则约束，返回 true
- `ic_trigger_config` 中找不到对应 ruleId 的配置时，返回 true（配置可能已删除）
- `stopAfterMinutes` 为 null 时视为不限制，跳过该检查
- `existOutstandingDiff` 内部已通过 `currentTriggerConfig` 使用 `regenThreshold`

## Acceptance Criteria

- AC-1: 当 `lastIcHeader` 为空或 `ruleId` 为空时，`reCalMatchRule` 返回 true
- AC-2: 当 `ic_trigger_config` 中找不到 `ruleId` 对应记录时，返回 true
- AC-3: 找到配置后，赋值给 `meta.setCurrentTriggerConfig(config)`
- AC-4: `stopAfterMinutes` 为 null 时跳过该检查（视为通过）
- AC-5: `stopAfterMinutes` 不为 null 时调用 `checkStopReGenAfterMinutes(meta, stopAfterMinutes)`
- AC-6: `regen_threshold` 检查调用 `existOutstandingDiff(meta)`
- AC-7: 两个检查都通过才返回 true，任一不通过返回 false
- AC-8: 每个分支路径都通过 `appendTriggerLog` 记录日志
- AC-9: 找到配置后，将 ruleId 和 ruleName 写入 triggerLog（与 matchRule 一致）

## Scope

- 改动范围：`IcTriggerConfigServiceImpl.java` 的 `reCalMatchRule` 方法
- 不动：接口定义、其他方法、Node1Trigger 调用方
