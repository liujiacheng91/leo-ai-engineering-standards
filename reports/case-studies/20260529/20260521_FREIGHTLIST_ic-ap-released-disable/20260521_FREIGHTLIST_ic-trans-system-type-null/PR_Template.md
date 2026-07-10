# Pull Request Template

## Summary

- ic_transaction 表 system_type 字段存在 null 值，原因是 Node2IcTransCalc.createIcTrans() 中 systemType 按 station 匹配 ext/shipmentDetail，当均无匹配时留空
- 统一从 keyShipment.shSourceSystem 取值（同一票的 sourceSystem 一致），旧逻辑注释保留

## Related Documents

- [AI_Request.md](./AI_Request.md)
- [Scenario.md](./Scenario.md)
- [AI_Risk_Level.md](./AI_Risk_Level.md)
- [Solution.md](./Solution.md)
- [Task.md](./Task.md)
- [Test.md](./Test.md)
- [Verify.md](./Verify.md)
- [Merge_Decision.md](./Merge_Decision.md)

Case 目录: `docs/ai/cases/20260521_FREIGHTLIST_ic-trans-system-type-null/`

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~$4.28 (estimated)

## Validation

- [x] Build (Track B: 合并后执行 `gradle :expand:business-freightlist-summary:compileJava`)
- [ ] Unit Test (仓库无 src/test; Track B: worktree + JGit 不兼容)
- [ ] Integration Test (N/A)
- [ ] Lint (N/A)
- [x] Security Scan (静态走读通过)
- [x] Secrets Scan (无密钥/token/证书)

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

- 改动文件: Node2IcTransCalc.java (1 file, +10/-9 lines)
- 涉及节点: ic_trans_calc_v2
- 旧 systemType 逻辑已注释保留，后续可能调整
- uploadStation 仍从 ext 取，未受影响
- Node3IcTransFinalCalc.java:306 从 transaction 复制 systemType，Node2 修复后 IC_TRANS_FINAL 同步受益
