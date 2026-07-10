# Pull Request Template

## Summary

ic_section_header 表补充 ic_type 字段（VARCHAR(16)），用于标识计算触发类型（PS=分利计算/MONTH_END=月结）。数据从 Kafka InterComTransEvent.icType 经 buildMeta 传递到 Node1Trigger，最终落库到 ic_section_header。

Risk Level: Yellow

## Related Documents

- [docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-ic-type/](docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-ic-type/)
  - AI_Request.md / Scenario.md / AI_Risk_Level.md / Solution.md
  - Task.md / Test.md / Verify.md
  - Merge_Decision.md

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~80K (estimated)

## Validation

- [ ] Build (Track B: worktree 内 JGit 不兼容，合并后验证)
- [x] Unit Test (静态审查通过，无运行时测试)
- [ ] Integration Test (N/A)
- [ ] Lint (N/A)
- [x] Security Scan (red-lines 6 项全 Pass)
- [x] Secrets Scan (无密钥/凭证涉及)

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

- IC_TRANS_FINAL 不受影响（IcTransFinalMetaItem 无 icType 字段）
- DDL 由用户手动执行，代码仅补充 ORM 映射和赋值逻辑
- 改动不影响任何现有字段的赋值逻辑
