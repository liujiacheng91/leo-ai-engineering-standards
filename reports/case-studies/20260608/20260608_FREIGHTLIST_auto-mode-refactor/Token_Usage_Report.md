# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| auto-mode-refactor | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~70K (estimated) | ~12K (estimated) | ~82K (estimated) | ~$1.68 (estimated) | 0 | No | 0.5 | Pass | Yes |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~20K (estimated) | ~$0.40 | 24% | 方案讨论 + AI_Request/Scenario/Risk/Solution |
| Solution Design | Opus | ~15K (estimated) | ~$0.30 | 18% | 对话中方案确认 |
| Code Implementation | Opus | ~25K (estimated) | ~$0.50 | 31% | 3 文件改动 + 编译验证 |
| Test Generation | Opus | ~8K (estimated) | ~$0.16 | 10% | Task + Test + Verify |
| Verification | Opus | ~14K (estimated) | ~$0.28 | 17% | Merge_Decision + Token_Usage_Report |
| Rework / Retry | N/A | 0 | $0 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $3.36/hr |
| Token / Saved Hours | 164K/hr |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Yellow 用 Opus | 主 Claude 当前 session 为 Opus，非 SubAgent 选型 | N/A，主 Claude 默认模型 |
| 未触发其他项 | Retry=0, 无单阶段>40%, 未用 Explore Agent, Total<500K | N/A |
