# Token Usage Report

## Task-Level

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ic-section-header-trans-type | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~120K (estimated) | ~15K (estimated) | ~135K (estimated) | ~$2.85 (estimated) | 0 | No | 1.0 | Merged | No |

## Stage-Level

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---|---|---|---|
| Scenario Analysis | Opus | ~30K (estimated) | ~$0.63 | 22% | 根因分析 + Scenario.md + AI_Risk_Level.md |
| Solution Design | Opus | ~20K (estimated) | ~$0.42 | 15% | Solution.md (Track B Declaration) |
| Code Implementation | Opus | ~30K (estimated) | ~$0.63 | 22% | Node1Trigger.java +2 lines |
| Test Generation | Opus | ~15K (estimated) | ~$0.32 | 11% | Task.md + Test.md |
| Verification | Opus | ~25K (estimated) | ~$0.53 | 19% | Verify.md + Merge_Decision.md + 收尾三件套 |
| Rework / Retry | N/A | 0 | $0 | 0% | 无 Retry |

## Cost Efficiency

- Cost per Saved Hour: ~$2.85 / 1.0h = $2.85/hr
- Token per Saved Hour: ~135K / 1.0h = 135K/hr
- Reference: BizDB baseline $0.59/hr

## Abnormal Cost Review

未触发。Retry Count = 0，无单阶段超 40%，未用 Explore Agent，Total Token < 500K。Yellow 任务使用 Opus 是因为 Path B 主 Claude 本身为 Opus 模型，非升级选择。
