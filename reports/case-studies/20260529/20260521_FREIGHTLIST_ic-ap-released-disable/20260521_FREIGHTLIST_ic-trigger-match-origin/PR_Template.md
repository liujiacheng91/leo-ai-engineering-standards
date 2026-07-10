# Pull Request Template

## Summary

- 补充 `IcTriggerConfigServiceImpl.matchOrigin` 方法的 origin 字段匹配逻辑
- origin 为 `*` 时通配，否则查询 `ic_trigger_station_config` 表按 ORG 站点类型匹配 `keyShipment.shOrigin`
- Yellow 风险，单文件改动 +33/-5

## Related Documents

- [AI_Request.md](docs/ai/cases/20260521_FREIGHTLIST_ic-trigger-match-origin/AI_Request.md)
- [Scenario.md](docs/ai/cases/20260521_FREIGHTLIST_ic-trigger-match-origin/Scenario.md)
- [AI_Risk_Level.md](docs/ai/cases/20260521_FREIGHTLIST_ic-trigger-match-origin/AI_Risk_Level.md)
- [Solution.md](docs/ai/cases/20260521_FREIGHTLIST_ic-trigger-match-origin/Solution.md)
- [Task.md](docs/ai/cases/20260521_FREIGHTLIST_ic-trigger-match-origin/Task.md)
- [Test.md](docs/ai/cases/20260521_FREIGHTLIST_ic-trigger-match-origin/Test.md)
- [Verify.md](docs/ai/cases/20260521_FREIGHTLIST_ic-trigger-match-origin/Verify.md)

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~80K (estimated)

## Validation

- [ ] Build (Track B: 合并后执行)
- [ ] Unit Test (Track B: 合并后执行)
- [x] Integration Test (N/A)
- [x] Lint (N/A)
- [x] Security Scan (code review Pass)
- [x] Secrets Scan (无密钥/凭证)

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

- 构造器注入新增 `IIcTriggerStationConfigService` 依赖
- `IcTriggerConfigEntity.id` (Integer) -> `IcTriggerStationConfigEntity.ruleId` (Long) 类型转换通过 `longValue()`
- Track B 验证模式：worktree + JGit 不兼容，合并后需在主分支执行编译验证
