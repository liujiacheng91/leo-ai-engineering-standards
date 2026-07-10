# Pull Request Template

## Summary

- 将 `Node3IcTransFinalCalc.calcDiffAmount` 的历史查询字段从 `serialNo` 改为 `globalInterlink`
- 将 `isDiffAmount` 判断和 `historyTotal` 计算提到 `buildIcTransFinal` 循环外，避免对同一 interlink 重复查 DB
- 新增 `calcHistoryTotal` 方法替代旧的 `calcDiffAmount`

## Related Documents

- `docs/ai/cases/20260520_FREIGHTLIST_ic-final-history-globalinterlink/`
  - AI_Request.md / Scenario.md / AI_Risk_Level.md / Solution.md
  - Task.md / Test.md / Verify.md (Track B)
  - Merge_Decision.md

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~80K (estimated)

## Validation

- [ ] Build (Track B: 合并后在主分支执行)
- [ ] Unit Test (仓库无 src/test)
- [x] Static Assertion (查询字段 / 循环外预计算 / 方法签名 / 旧方法删除)
- [ ] Lint
- [ ] Security Scan
- [ ] Secrets Scan

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

单文件改动 (+38/-32)，只涉及 `Node3IcTransFinalCalc.java`。查询从 `serialNo` 改为 `globalInterlink` 是业务需求变更；循环外提取是性能优化。DB 表结构未变。
