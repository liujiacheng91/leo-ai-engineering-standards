# Pull Request Template

## Summary
- 修复 IC v2 链 Node1Trigger 的 getShipmentDetails 返回值未存入 meta 的 bug，导致 Node2 的 shipmentDetail 永远为 null
- 补充 Node2 createIcTrans 中 shipmentDetail 为 null 时从 sectionHeader 取 serialNo 的兜底逻辑
- 修复 Node2 第 782 行 else 分支对 shipmentDetail 的 null 检查缺失（防 NPE）

## Related Documents
- docs/ai/cases/20260521_FREIGHTLIST_ic-node1-shipment-detail-fix/
- AI_Request.md / Scenario.md / AI_Risk_Level.md / Solution.md / Task.md / Test.md / Verify.md

## AI Assistance
- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~$1.50 (estimated)

## Validation
- [ ] Build (Track B: 合并后执行 `gradle :expand:business-freightlist-summary:compileJava`)
- [ ] Unit Test (仓库无 src/test)
- [x] Static Code Review (diff +9/-4, 逻辑清晰)
- [x] Security Scan (red-lines 6 项全 Pass)
- [x] Secrets Scan (无密钥/凭证)

## Security Checklist
- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes
- 改动仅涉及数据流修复（Node1 存值 + Node2 兜底 + NPE 防护），不改算法逻辑
- 不影响 DB schema，不影响 PDF 团队
- IC_TRANS 每天触发 2 次，IC_TRANS_FINAL 每月 1 次，修复后下次触发即生效
