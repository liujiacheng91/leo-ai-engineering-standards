# Token_Usage_Report - 20260520_FREIGHTLIST_ic-final-diff-amount

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| calcDiffAmount 差额计算逻辑 | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | 120,000 (estimated) | 8,000 (estimated) | 128,000 (estimated) | $2.40 (estimated) | 0 | No | 1.0 | Pass | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | 30,000 (estimated) | $0.60 (estimated) | 23% | AI_Request + Scenario + AI_Risk_Level + Solution |
| Solution Design | Opus | 20,000 (estimated) | $0.40 (estimated) | 16% | Solution.md 含 Track B Declaration |
| Code Implementation | Opus | 40,000 (estimated) | $0.80 (estimated) | 31% | 读源码 + 3 次 Edit + commit |
| Test Generation | Opus | 15,000 (estimated) | $0.30 (estimated) | 12% | Test.md 设计（无实际单测代码） |
| Verification | Opus | 15,000 (estimated) | $0.30 (estimated) | 12% | Verify.md + Merge_Decision.md |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无自修复发生 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $2.40 / 1.0h = $2.40/hr (estimated) |
| Token / Saved Hours | 128,000 / 1.0h = 128,000 tokens/hr (estimated) |

> 参考基准：EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr。本案高于基准，因 Yellow 风险用了 Opus（路径 B 主 Claude 亲自执行，非 SubAgent）。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Yellow 用 Opus | 路径 B 主 Claude 直接执行，非 SubAgent 调用；本次上下文因 context compaction 重新加载导致 Opus 持续使用 | 已知偏差，后续同类小改动考虑切 Sonnet 降本 |
