# Token Usage Report

## Task-Level

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| semi-auto-workflow | bus-freightlist-handler-service | FREIGHTLIST | Green | Opus | ~60K (estimated) | ~8K (estimated) | ~68K (estimated) | ~$1.36 (estimated) | 0 | No | 0.3h | Done | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~15K (estimated) | ~$0.30 | 22% | AI_Request + Scenario + AI_Risk_Level |
| Solution Design | Opus | ~10K (estimated) | ~$0.20 | 15% | Solution.md |
| Code Implementation | Opus | ~15K (estimated) | ~$0.30 | 22% | semiAutoWorkflow 方法体 ~15行 |
| Test Generation | Opus | ~10K (estimated) | ~$0.20 | 15% | Task + Test |
| Verification | Opus | ~18K (estimated) | ~$0.36 | 26% | Verify.md + Token report |
| Rework / Retry | N/A | 0 | $0 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $4.53/hr |
| Token / Saved Hours | 227K/hr |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Green 用 Opus | 主 Claude session 为 Opus，非 SubAgent 选型 | 改进点：Green + 单文件 + <50 行应使用 Sonnet（预估可降低成本约 80%，$1.36 -> ~$0.28）|
| 未触发其他项 | Retry=0，无单阶段>40%，Total<500K | N/A |
