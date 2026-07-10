# Token Usage Report

## Task-Level

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ar-charges-process | bus-freightlist-handler-service | FREIGHTLIST | Green | Opus | ~65K (estimated) | ~10K (estimated) | ~75K (estimated) | ~$1.50 (estimated) | 0 | No | 0.3h | Done | Yes - isArCharge 重载模式可复用 |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~18K (estimated) | ~$0.36 | 24% | AI_Request + Scenario + AI_Risk_Level |
| Solution Design | Opus | ~12K (estimated) | ~$0.24 | 16% | Solution.md |
| Code Implementation | Opus | ~25K (estimated) | ~$0.50 | 33% | 2 overloaded isArCharge methods + processArCharges ~40行 |
| Test Generation | Opus | ~10K (estimated) | ~$0.20 | 13% | Task + Test |
| Verification | Opus | ~10K (estimated) | ~$0.20 | 13% | Verify.md + Token report |
| Rework / Retry | N/A | 0 | $0 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $5.00/hr |
| Token / Saved Hours | 250K/hr |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Green 用 Opus | 主 Claude session 为 Opus，非 SubAgent 选型 | 改进点：Green + 单文件 + <50 行应使用 Sonnet（预估可降低成本约 80%，$1.50 -> ~$0.30）|
| 未触发其他项 | Retry=0，无单阶段>40%，Total<500K | N/A |
