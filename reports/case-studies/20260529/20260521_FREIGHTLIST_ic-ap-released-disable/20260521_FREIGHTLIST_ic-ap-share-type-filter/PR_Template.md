# Pull Request Template

## Summary
- IC v2 trigger 的 isAllApChargeReleased 方法增加 share_type=P 过滤条件，仅检查 cdlShareType=P 的 AP 费用是否 Released

## Related Documents
- docs/ai/cases/20260521_FREIGHTLIST_ic-ap-share-type-filter/
- AI_Request.md / Scenario.md / AI_Risk_Level.md / Solution.md / Task.md / Test.md / Verify.md

## AI Assistance
- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~$0.80 (estimated)

## Validation
- [ ] Build (Track B: 合并后执行 `gradle :expand:business-freightlist-summary:compileJava`)
- [ ] Unit Test (仓库无 src/test)
- [x] Static Code Review (diff +2/-2, 条件追加)
- [x] Security Scan (red-lines 6 项全 Pass)
- [x] Secrets Scan (无密钥/凭证)

## Security Checklist
- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes
- 改动仅涉及 trigger 判断逻辑（追加 share_type=P 条件），不改落库、不改算法
- 不影响 DB schema，不影响 PDF 团队
- IC_TRANS 每天触发 2 次，IC_TRANS_FINAL 每月 1 次
