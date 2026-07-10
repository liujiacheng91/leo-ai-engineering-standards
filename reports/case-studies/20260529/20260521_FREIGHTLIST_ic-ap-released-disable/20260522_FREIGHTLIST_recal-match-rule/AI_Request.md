# AI_Request.md

## Task Metadata

- Case ID: 20260522_FREIGHTLIST_recal-match-rule
- Owner: Liangwb
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Task Type: feature
- Entry Check: /ll-dev

## Description

补充 `IcTriggerConfigServiceImpl.reCalMatchRule` 方法逻辑，将当前的 todo 桩替换为完整实现：
1. 从 `lastIcHeader` 获取 `ruleId`
2. 从 `ic_trigger_config` 表查找 rule，找不到则返回 true
3. 找到后赋值给 `meta.getCurrentTriggerConfig()`
4. 判断 `stop_after_minutes` 和 `regen_threshold` 两个字段是否满足
5. `stop_after_minutes` 逻辑调用 `checkStopReGenAfterMinutes`
6. `regen_threshold` 逻辑调用 `existOutstandingDiff`
7. 两个字段都满足才返回 true

## Expected Deliverables

- 修改 `IcTriggerConfigServiceImpl.java` 的 `reCalMatchRule` 方法
- LL 过程文档

## Input

- 用户需求描述（见 Description）
- 现有代码：`IcTriggerConfigServiceImpl.java:362-367`（todo 桩）

## Branch Info

- Base Branch: develop_1.1.0
- Task Type: feature
- New Branch Name: feat/recal-match-rule
- Worktree Path: .claude/worktrees/feat-recal-match-rule
