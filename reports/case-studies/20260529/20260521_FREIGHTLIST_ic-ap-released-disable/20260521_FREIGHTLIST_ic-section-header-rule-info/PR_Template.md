# Pull Request Template

## Summary

- createIcSectionHeader 方法追加 ruleId/triggerRule 赋值逻辑（+9 行）
- 优先从 lastIcHeader 继承，其次从 currentTriggerConfig 获取
- 仅改内存赋值，不改落库逻辑，不改 DB schema

## Related Documents

- [AI_Request.md](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-rule-info/AI_Request.md)
- [Scenario.md](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-rule-info/Scenario.md)
- [AI_Risk_Level.md](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-rule-info/AI_Risk_Level.md)
- [Solution.md](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-rule-info/Solution.md)
- [Task.md](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-rule-info/Task.md)
- [Test.md](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-rule-info/Test.md)
- [Verify.md](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-rule-info/Verify.md)

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~80K (estimated)

## Validation

- [ ] Build (Track B: worktree + JGit 不兼容，合并后执行)
- [ ] Unit Test (Track B: 同上)
- [x] Integration Test (N/A)
- [x] Lint (静态代码审查通过)
- [x] Security Scan (N/A)
- [x] Secrets Scan (无密钥/token)

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

- 改动集中在 Node1Trigger.java:486-494，createIcSectionHeader 方法内
- 依赖 matchRule 中已有的 setCurrentTriggerConfig 赋值（ic-trigger-rule-match case）
- IcTriggerConfigEntity.id (Integer) 转 Long 使用 .longValue()
