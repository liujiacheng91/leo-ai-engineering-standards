# AI_Request.md

## Task Metadata

- Owner: Liangwb
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Case ID: 20260522_FREIGHTLIST_ic-trigger-dest-country
- Task Type: feature
- Entry: /ll-dev
- Path: B (Mode 1)

## Description

补充 `matchRule` 中 `destination_country` 字段的匹配逻辑，与 `origin_country` 逻辑类似但 `countryType='DST'`；同时将两者抽取为统一的通用方法。

## Expected Output

- `IcTriggerConfigServiceImpl.java` 中 `matchDestinationCountry` 从 todo 桩替换为完整实现
- 抽取 `matchCountryConfig` 通用方法，`matchOriginCountry` 和 `matchDestinationCountry` 都调用它
- `getOriginCountryFromParties` 泛化为 `getCountryFromParties`，支持按 partyId 参数查询

## Input

- 用户提供的 3 条业务规则
- 前序 case `20260522_FREIGHTLIST_ic-trigger-origin-country` 的实现作为基线

## Branch Info

- Base Branch: develop_1.1.0
- Task Type: feature
- New Branch Name: feat/ic-trigger-dest-country
- Worktree Path: .claude/worktrees/feat-ic-trigger-dest-country

## Entry Check

- [x] 需求明确
- [x] 目标文件已知
- [x] 风险可评估
