# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| 关闭 All AP RELEASED 校验 | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | 150,000 (estimated) | 10,000 (estimated) | 160,000 (estimated) | $3.00 (estimated) | 0 | No | 0.4 | Pass | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | 50,000 (estimated) | $1.00 (estimated) | 31% | AI_Request + Scenario + AI_Risk_Level + Solution |
| Solution Design | Opus | 20,000 (estimated) | $0.40 (estimated) | 13% | 含 Solution.md Track B Declaration |
| Code Implementation | Opus | 30,000 (estimated) | $0.60 (estimated) | 19% | 单方法注释 + return true |
| Test Generation | Opus | 20,000 (estimated) | $0.40 (estimated) | 13% | Task.md + Test.md（静态验证，无单测代码） |
| Verification | Opus | 20,000 (estimated) | $0.40 (estimated) | 13% | Verify.md + Merge_Decision.md |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无 Retry |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $7.50/hr (estimated) |
| Token / Saved Hours | 400,000 tokens/hr (estimated) |

> 参考基准: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr. 本次成本偏高因包含完整 Yellow 文档流程（8 份文档），实际代码改动极小。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 未触发 | Retry=0, 单阶段最高 31% (<40%), 总 token ~160K (<500K) | 无需行动 |
