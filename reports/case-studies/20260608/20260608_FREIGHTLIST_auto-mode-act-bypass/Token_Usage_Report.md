# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| auto-mode-act-bypass | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~80K (estimated) | ~15K (estimated) | ~95K (estimated) | ~$1.95 (estimated) | 0 | No | 0.5 | Pass | Yes |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~25K (estimated) | ~$0.50 | 26% | AI_Request + Scenario + AI_Risk_Level |
| Solution Design | Opus | ~20K (estimated) | ~$0.40 | 21% | Solution.md + Technical Constraints 验证 |
| Code Implementation | Opus | ~20K (estimated) | ~$0.40 | 21% | Node31AutoMode.java 3行改动 |
| Test Generation | Opus | ~10K (estimated) | ~$0.20 | 11% | Task + Test + Verify |
| Verification | Opus | ~15K (estimated) | ~$0.30 | 16% | Merge_Decision + 合并后编译验证 |
| Rework / Retry | N/A | 0 | $0 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $3.90/hr |
| Token / Saved Hours | 190K/hr |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 未触发 | Retry=0, 无单阶段>40%, 未用Explore Agent, Total<500K | N/A |
