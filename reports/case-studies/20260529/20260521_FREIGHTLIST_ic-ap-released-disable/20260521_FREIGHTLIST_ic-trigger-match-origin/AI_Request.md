# AI Request - 20260521_FREIGHTLIST_ic-trigger-match-origin

## Basic Info

| Field | Value |
|---|---|
| Owner | Liangwb |
| Team | FREIGHTLIST |
| Project | bus-freightlist-handler-service |
| Date | 2026-05-21 |
| Task Type | feature |
| Path | B (`/ll-dev` Skill flow) |
| Execution Mode | Mode 1 (LL-only) |

## Description

补充 IcTriggerConfigServiceImpl.matchRule 中 matchOrigin 方法的具体逻辑，替换原 todo 占位。

## Input

- 用户需求：matchOrigin 字段匹配逻辑
- 前序 case：20260521_FREIGHTLIST_ic-trigger-match-fields（matchStage/matchBizType/matchShipType/matchEntryMode/matchPsCutoffDate）
- 前序 case：20260521_FREIGHTLIST_ic-trigger-rule-match（matchRule 触发规则匹配框架）

## Expected Output

- IcTriggerConfigServiceImpl.java 中 matchOrigin 方法实现
- Yellow 最低文档集

## Branch Info

- Base Branch: develop_1.1.0
- Task Type: feature
- New Branch Name: feat/ic-trigger-match-origin
- Worktree Path: .claude/worktrees/feat-ic-trigger-match-origin

## Entry Check

- [x] 需求清晰（用户给出 5 步逻辑）
- [x] 风险等级已评估（Yellow）
- [x] 不涉及生产配置
- [x] 不涉及密钥/敏感数据
