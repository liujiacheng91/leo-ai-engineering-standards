# AI_Request.md

## Meta

- Case ID: 20260521_FREIGHTLIST_ic-ap-released-disable
- Owner: LiangWB
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Task Type: feature (临时关闭功能)
- Path: B (LL Skill)
- Mode: 1

## Description

临时关闭 "All AP RELEASED" 检查功能。将 `isAllApChargeReleased` 方法注释掉原有逻辑，固定返回 true。

## Branch Info

- Base Branch: develop_1.1.0
- New Branch: feat/ic-ap-released-disable
- Worktree Path: .claude/worktrees/feat-ic-ap-released-disable

## Entry Check

- [x] 需求清晰
- [x] 改动范围明确（单方法）
- [x] 无跨服务依赖
