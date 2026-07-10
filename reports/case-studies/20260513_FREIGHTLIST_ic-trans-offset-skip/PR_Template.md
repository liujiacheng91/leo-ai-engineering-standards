# Pull Request Template

## Summary

**IC trans 流程简化：暂停 charge offset 数据生成与落库**

- 注释掉 `Node3ChargeOffset` 中 `offsetHandle()` 及 `meta.setIcChargeOffsets()` 调用，停止生成反冲记录
- 注释掉 `Node5Save` 中 `icChargeDetailOffsetService.saveBatch()` 块，停止写入 `ic_charge_detail_offset` 表
- `Node4IcTransCalc` 三处读取 offset 的方法（fillPendingIc / fillReceiverOsPS / fillReceiverOsIcSweep）已有 null 保护，无需改动；相应字段（pendingIc / pendingPsIc / pendingNonPsIc）将固定为 0
- 所有原始逻辑以注释形式保留，可随时取消注释恢复

**影响范围**：仅 IC_TRANS 链中的 Node3 / Node5；FREIGHT_LIST 链、IC_TRANS_FINAL 链不受影响

## Related Documents

- [AI_Request.md](docs/ai/cases/20260513_FREIGHTLIST_ic-trans-offset-skip/AI_Request.md)
- [Scenario.md](docs/ai/cases/20260513_FREIGHTLIST_ic-trans-offset-skip/Scenario.md)
- [AI_Risk_Level.md](docs/ai/cases/20260513_FREIGHTLIST_ic-trans-offset-skip/AI_Risk_Level.md)
- [Solution.md](docs/ai/cases/20260513_FREIGHTLIST_ic-trans-offset-skip/Solution.md)
- [Task.md](docs/ai/cases/20260513_FREIGHTLIST_ic-trans-offset-skip/Task.md)
- [Test.md](docs/ai/cases/20260513_FREIGHTLIST_ic-trans-offset-skip/Test.md)
- [Verify.md](docs/ai/cases/20260513_FREIGHTLIST_ic-trans-offset-skip/Verify.md)

## AI Assistance

- Tool: Claude Code (LL-only 模式，主 Claude 亲自执行)
- Model: claude-sonnet-4-6
- Risk Level: 🟡 Yellow
- Token Cost: ~$0.89 (estimated)

## Validation

- [x] Build — **待合并后执行**（worktree 内 JGit 插件兼容性问题，与改动无关，见 Verify.md §1）
- [x] Unit Test — 仓库无 `src/test`，不适用
- [ ] Integration Test — 建议合并后 UAT 环境验证（发 IC_TRANS Kafka 消息）
- [x] Lint — 无 lint 工具配置，不适用
- [x] Security Scan — 不适用（无新 API / 无生产配置修改）
- [x] Secrets Scan — 无凭据涉及

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

1. 此 PR 为**业务简化**，不是 bug fix——`pendingIc`/`ReceiverOsPS pendingPsIc`/`ReceiverOsIcSweep pendingNonPsIc` 三个字段将从"未匹配 offset 汇总"改为固定 0，请确认业务方已知晓
2. `ic_charge_detail_offset` 表历史数据保留，不清理
3. 恢复路径：取消 Node3 / Node5 注释即可，无 schema 变更
