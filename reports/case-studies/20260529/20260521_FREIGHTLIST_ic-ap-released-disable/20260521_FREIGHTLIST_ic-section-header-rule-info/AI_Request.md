# AI_Request.md

## Meta
- Case ID: 20260521_FREIGHTLIST_ic-section-header-rule-info
- Owner: LiangWB
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Task Type: feature
- Entry Check: /ll-dev Path B, Mode 1

## Branch Info
- Base Branch: develop_1.1.0
- New Branch Name: feat/ic-section-header-rule-info
- Worktree Path: .claude/worktrees/feat-ic-section-header-rule-info

## Description
ic_section_header 创建后设置 rule_id 和 trigger_rule 字段：
1. 优先从 lastIcHeader 继承（ruleId, triggerRule）
2. 若 lastIcHeader 为空且 currentTriggerConfig 不为空，从触发配置获取（id -> ruleId, ruleName -> triggerRule）

## Input
- 用户需求描述（对话内）
- Node1Trigger.java:474 createIcSectionHeader 方法
- IcSectionHeaderEntity (ruleId, triggerRule)
- IcTransMetaItem (lastIcHeader, currentTriggerConfig)
- IcTriggerConfigEntity (id, ruleName)

## Expected Output
- 修改 Node1Trigger.java createIcSectionHeader 方法
