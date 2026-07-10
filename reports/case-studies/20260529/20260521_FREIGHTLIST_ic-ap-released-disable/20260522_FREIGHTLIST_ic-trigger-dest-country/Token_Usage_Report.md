# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| matchDestinationCountry + matchCountryConfig 通用方法抽取 | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | 120000 (estimated) | 15000 (estimated) | 135000 (estimated) | $2.93 (estimated) | 0 | No | 2.0 | Pass | Yes |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | 25000 (estimated) | $0.54 | 18.5% | AI_Request + Scenario + AI_Risk_Level + Solution |
| Solution Design | Opus | 15000 (estimated) | $0.33 | 11.1% | Solution.md + Task.md 拆解 |
| Code Implementation | Opus | 40000 (estimated) | $0.87 | 29.6% | 5 个 Edit 操作 + 代码静态验证 |
| Test Generation | Opus | 25000 (estimated) | $0.54 | 18.5% | Test.md 12 条用例 |
| Verification | Opus | 20000 (estimated) | $0.43 | 14.8% | Verify.md + Merge_Decision.md |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无 Self-Fix |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $1.47/hr (estimated) |
| Token / Saved Hours | 67500 tokens/hr |

> 参考基准: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr. 本案高于基准因为 Yellow 风险用 Opus 模型。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 20260522_FREIGHTLIST_ic-trigger-dest-country | Yellow 任务用了 Opus | 路径 B Mode 1 由主 Claude（Opus）直接执行; Sonnet 未在本会话可用; 属于 Opus 作为主模型的标准用法，非额外升级 |
