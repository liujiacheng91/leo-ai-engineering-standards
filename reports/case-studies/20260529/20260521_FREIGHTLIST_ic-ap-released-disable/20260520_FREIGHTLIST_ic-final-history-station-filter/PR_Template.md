# Pull Request Template

## Summary

重构 Node3IcTransFinalCalc 差额计算逻辑：历史查询返回列表并按站点过滤累加，替代原先返回总金额的方式。使用 meta.isStationsEqual 支持配对站点匹配。

## Related Documents

- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-station-filter/AI_Request.md`
- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-station-filter/Scenario.md`
- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-station-filter/AI_Risk_Level.md`
- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-station-filter/Solution.md`
- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-station-filter/Task.md`
- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-station-filter/Test.md`
- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-station-filter/Verify.md`

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~$1.50 (estimated)

## Validation

- [ ] Build (Track B: worktree JGit 不兼容，合并后执行)
- [ ] Unit Test (Track B: 合并后执行)
- [x] Static Assertions (8 项全部 Pass)
- [ ] Lint
- [ ] Security Scan
- [ ] Secrets Scan

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

改动仅 1 文件 +26/-21，核心变化是 calcAmount 内按站点过滤历史列表再累加差额，逻辑等价但粒度更细。
