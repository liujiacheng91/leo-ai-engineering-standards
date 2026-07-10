# AI_Request.md

## Basic Info
- Case ID: 20260521_FREIGHTLIST_ic-ap-share-type-filter
- Owner: LiangWB
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Created: 2026-05-21

## Task Description
IC v2 trigger 中 isAllApChargeReleased 方法增加 share_type=P 过滤条件。当前逻辑检查所有 AP 费用是否 Released，需改为仅检查 share_type=P 的 AP 费用。

## Task Type
feature

## Branch Info
- Base Branch: develop_1.1.0
- Task Type: feature
- New Branch Name: feat/ic-ap-share-type-filter
- Worktree Path: .claude/worktrees/feat-ic-ap-share-type-filter

## Expected Output
- IcTriggerConfigServiceImpl.isAllApChargeReleased 方法增加 cdlShareType="P" 条件

## Entry Check
- [x] Task type identified: feature
- [x] Base branch determined: develop_1.1.0
- [x] Risk level needed: Yellow (IC trigger logic change)
