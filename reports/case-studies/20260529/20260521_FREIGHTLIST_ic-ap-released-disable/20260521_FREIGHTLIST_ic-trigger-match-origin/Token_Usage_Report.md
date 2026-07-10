# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---:|---|---:|---:|---:|---:|---:|---|---:|---|---|
| ic-trigger-match-origin | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | 70,000 (estimated) | 10,000 (estimated) | 80,000 (estimated) | $0.80 (estimated) | 0 | No | 0.5 | Merged | Yes |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | 15,000 (estimated) | $0.15 (estimated) | 19% | AI_Request + Scenario + AI_Risk_Level + Solution |
| Solution Design | Opus | 10,000 (estimated) | $0.10 (estimated) | 13% | Solution.md Technical Constraints |
| Code Implementation | Opus | 30,000 (estimated) | $0.30 (estimated) | 38% | Read 源码 + 4 处 Edit + commit |
| Test Generation | Opus | 10,000 (estimated) | $0.10 (estimated) | 13% | Task.md + Test.md |
| Verification | Opus | 10,000 (estimated) | $0.10 (estimated) | 13% | Verify.md + Merge_Decision.md |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无 Retry |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $1.60/hr (estimated) |
| Token / Saved Hours | 160,000/hr (estimated) |

> Reference benchmarks: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr.
> 本案 $1.60/hr 高于基准，因为是跨上下文继续（context 压缩后恢复消耗额外 token）。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Yellow 用 Opus | 路径 B 主 Claude 亲自执行，使用 Opus 模型 | 跨 context 继续任务，Opus 是当前 session 默认模型；单文件改动实际 token 可控 |
