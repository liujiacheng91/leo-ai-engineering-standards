# Token Usage Report

## Task-Level

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| auto-mode-by-station | bus-freightlist-handler-service | FREIGHTLIST | Green | Opus | ~80K (estimated) | ~10K (estimated) | ~90K (estimated) | ~$1.80 (estimated) | 0 | No | 0.5h | Done | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~15K (estimated) | ~$0.30 | 17% | AI_Request + Scenario + Risk |
| Solution Design | Opus | ~5K (estimated) | ~$0.10 | 6% | Solution (compact) |
| Code Implementation | Opus | ~40K (estimated) | ~$0.80 | 44% | 3 files: IIcAutoModeService + IcAutoModeServiceImpl + Node31AutoMode, ~40行；44% 超阈值，因 3 文件范围合理 |
| Test Generation | Opus | ~18K (estimated) | ~$0.36 | 20% | Task + Test |
| Verification | Opus | ~12K (estimated) | ~$0.24 | 13% | Verify.md + Token report |
| Rework / Retry | N/A | 0 | $0 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $3.60/hr |
| Token / Saved Hours | 180K/hr |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Green 用 Opus | 主 Claude session 为 Opus，非 SubAgent 选型 | 改进点：Green + 单文件 + <50 行应使用 Sonnet（预估可降低成本约 80%，$1.80 -> ~$0.37）|
| Code Implementation 44% | 超过 40% 阈值，但由 3 文件改动范围决定，属合理超出 | 可接受，无需修复 |
| 未触发其他项 | Retry=0，Total<500K | N/A |
