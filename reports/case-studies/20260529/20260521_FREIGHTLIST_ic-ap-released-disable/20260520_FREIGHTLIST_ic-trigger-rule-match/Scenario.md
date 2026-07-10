# Scenario - 20260520_FREIGHTLIST_ic-trigger-rule-match

## Background

IC_TRANS 链的首节点 Node1Trigger 在首次计算时调用 `icTriggerService.matchRule(meta)` 判断是否有匹配的触发规则。当前该方法为占位实现（直接返回 true），需要补充完整的规则匹配框架。

触发规则存储在 `ic_trigger_config` 表，加载后放在 `meta.triggerConfigList` 中。每条 config 记录代表一条 rule，需要按 9 个维度（ps_cutoff_date, entry_mode, stage, biz_type, ship_type, origin_country, origin, destination_country, destination）逐一判断，全部满足才算匹配。

匹配成功时需把 rule 信息回写到 ic_section_header（ruleId + triggerRule）。

## Assumptions

- meta.triggerConfigList 在 Node1Trigger 执行前已被上游填充
- IcSectionHeaderEntity 已有 ruleId (Long) 和 triggerRule (String) 字段
- 9 个维度的具体比较逻辑后续单独开 case 补充，本次只搭框架（占位返回 true）

## Acceptance Criteria

- AC-1: matchRule 遍历 meta.triggerConfigList，对每条 config 依次调用 9 个维度的匹配方法
- AC-2: 任一 config 全部 9 个维度匹配成功时，设置 meta.currentTriggerConfig 并返回 true，后续 config 不再判断
- AC-3: 所有 config 都不匹配时返回 false
- AC-4: 匹配成功的 rule 信息（id, ruleName）写入 meta.triggerLog 的 ruleId 和 triggerRule 字段
- AC-5: 9 个维度各有独立的占位方法，返回 true 并标注 TODO
