# Pull Request Template

## Summary

实现 Node5ProfitShare.calcGp 计算逻辑：按站点分组计算 FL GP（AR 加 AP 减），通过 isStationsEqual 匹配 POM agentCode 与站点编码，按 AgentType 分配到 Origin/Destination/Sale1/Sale2，汇总 Total。

## Related Documents

- [AI_Request.md](docs/ai/cases/20260519_FREIGHTLIST_node5-calc-gp/AI_Request.md)
- [Scenario.md](docs/ai/cases/20260519_FREIGHTLIST_node5-calc-gp/Scenario.md)
- [AI_Risk_Level.md](docs/ai/cases/20260519_FREIGHTLIST_node5-calc-gp/AI_Risk_Level.md)
- [Solution.md](docs/ai/cases/20260519_FREIGHTLIST_node5-calc-gp/Solution.md)
- [Task.md](docs/ai/cases/20260519_FREIGHTLIST_node5-calc-gp/Task.md)
- [Test.md](docs/ai/cases/20260519_FREIGHTLIST_node5-calc-gp/Test.md)
- [Verify.md](docs/ai/cases/20260519_FREIGHTLIST_node5-calc-gp/Verify.md)

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~$3.00 (estimated)

## Validation

- [x] Build (`gradle compileJava` BUILD SUCCESSFUL)
- [ ] Unit Test (仓库无 src/test，Track B)
- [ ] Integration Test (N/A)
- [ ] Lint (N/A)
- [x] Security Scan (无敏感数据改动)
- [x] Secrets Scan (无密钥涉及)

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

- 改动仅填充 calcGp 空方法体（+45 行），不影响 ProfitShareTotal 计算链（Distribution + Sweep 独立于 freightListGpEntity）
- 复用已有 calcFlGpByStation / isStationsEqual / judgeSale / sumBigDecimal，无新增外部依赖
- ThirdParty 字段保持跳过状态，与 calcProfitShareDistribution / calcSweep 一致
