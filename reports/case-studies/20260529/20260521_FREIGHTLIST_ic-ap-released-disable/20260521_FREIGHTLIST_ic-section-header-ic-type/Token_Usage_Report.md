# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| ic-section-header-ic-type | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~65K (estimated) | ~15K (estimated) | ~80K (estimated) | ~$0.80 (estimated) | 0 | No | 0.75 | Merged | Yes |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~15K (estimated) | ~$0.15 | 19% | AI_Request + Scenario + AI_Risk_Level |
| Solution Design | Opus | ~10K (estimated) | ~$0.10 | 13% | Solution.md + Track B Declaration |
| Code Implementation | Opus | ~25K (estimated) | ~$0.25 | 31% | 3 files: Entity + Mapper XML + Node1Trigger |
| Test Generation | Opus | ~10K (estimated) | ~$0.10 | 13% | Task.md + Test.md (静态设计，Track B) |
| Verification | Opus | ~15K (estimated) | ~$0.15 | 19% | Verify.md + Merge_Decision.md |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | ~$1.07/hr (estimated) |
| Token / Saved Hours | ~107K/hr (estimated) |

> 参考基准: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr。本案高于 BizDB 基准，因 Yellow 风险 + Opus 模型 + 完整文档产出。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 未触发 | Retry=0, 无单阶段>40%, 未用 Explore Agent, Total<500K | 无需 review |
