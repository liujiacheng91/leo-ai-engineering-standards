# AI_Request.md

## Task Metadata

- Case ID: 20260520_FREIGHTLIST_ic-trigger-rule-match
- Owner: Liangwb
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Created: 2026-05-20
- Path: B (LL Skill)
- Mode: 1 (LL-only)

## Input

用户需求原文：

1. 补充 trigger rule 逻辑，函数为 icTriggerService.matchRule，rule 存储在 ic_trigger_config 表，存储在 meta 的变量中可直接用，一条记录是一个 rule
2. 遍历 ic_trigger_config，判断 rule 是否满足，依次判断 ps_cutoff_date, entry_mode, stage, biz_type, ship_type, origin_country, origin, destination_country, destination，所有字段都满足才算这条 rule 满足
3. 如果有一条 rule 满足，则把 rule id 记到 ic_section_header.rule_id 字段，rule name 记到 ic_section_header.trigger_rule 字段，后续 config 不用继续判断，函数返回 true
4. 如果所有 rule 都不满足，返回 false
5. 9 个字段的判断逻辑暂不实现，先给每个字段写占位函数返回 true，后续单独开 case 补充

## Expected Output

- 修改 IcTriggerConfigServiceImpl.matchRule 方法
- 新增 9 个占位匹配方法
- matchRule 中将匹配的 rule 信息写入 meta.triggerLog 的 ruleId/triggerRule

## Branch Info

- Task Type: feature
- Base Branch: develop_1.1.0
- New Branch Name: feat/ic-trigger-rule-match
- Worktree Path: .claude/worktrees/feat-ic-trigger-rule-match

## Entry Check

- [x] 需求清晰
- [x] 目标文件已定位
- [x] 风险可评估
