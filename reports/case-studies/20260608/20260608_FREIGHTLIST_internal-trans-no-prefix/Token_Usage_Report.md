# Token Usage Report

## Task-Level

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| internal-trans-no-prefix | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~50K (estimated) | ~5K (estimated) | ~55K (estimated) | ~$1.10 (estimated) | 0 | No | 0.2h | Done | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~15K (estimated) | ~$0.30 | 27% | AI_Request + Scenario + AI_Risk_Level |
| Solution Design | Opus | ~10K (estimated) | ~$0.20 | 18% | Solution.md |
| Code Implementation | Opus | ~10K (estimated) | ~$0.20 | 18% | Node30IcTransFinalCalc 2行改动 |
| Test Generation | Opus | ~10K (estimated) | ~$0.20 | 18% | Task + Test |
| Verification | Opus | ~10K (estimated) | ~$0.20 | 18% | Verify.md + Token report |
| Rework / Retry | N/A | 0 | $0 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $5.50/hr |
| Token / Saved Hours | 275K/hr |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Yellow 用 Opus 合理 | LiteFlow Node 修改，符合升级条件 | N/A |
| 未触发其他项 | Retry=0，无单阶段>40%，Total<500K | N/A |
