# Test.md

## Case Info

- Case ID: 20260522_FREIGHTLIST_recal-match-rule

## Test Scope

- 目标方法：`IcTriggerConfigServiceImpl.reCalMatchRule`
- 验证策略：静态断言（Track B，worktree 内无法执行 gradle test）

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | lastIcHeader 为 null | meta.lastIcHeader = null | return true + 日志 | AC-1 |
| 2 | ruleId 为 null | lastIcHeader 存在但 ruleId = null | return true + 日志 | AC-1 |
| 3 | config 不存在 | ruleId = 999（DB 无此记录） | return true + 日志 | AC-2 |
| 4 | config 存在，两项均通过 | stopAfterMinutes = -1, outstanding 有变化 | return true + 设置 currentTriggerConfig | AC-3, AC-5, AC-6, AC-7 |
| 5 | config 存在，stopAfterMinutes 为 null | stopAfterMinutes = null | 跳过 stopAfterMinutes 检查，仅校验 regenThreshold | AC-4 |
| 6 | stopAfterMinutes 不通过 | stopAfterMinutes = 0, firstIcHeader 存在 | return false | AC-5, AC-7 |
| 7 | regenThreshold 不通过 | outstanding 无变化 | return false | AC-6, AC-7 |
| 8 | 两项均不通过 | stopAfterMinutes=0 + outstanding 无变化 | return false | AC-7 |
| 9 | triggerLog 写入验证 | config 存在 | triggerLog.ruleId 和 triggerRule 被设置 | AC-8, AC-9 |

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| (none) | | | | |
