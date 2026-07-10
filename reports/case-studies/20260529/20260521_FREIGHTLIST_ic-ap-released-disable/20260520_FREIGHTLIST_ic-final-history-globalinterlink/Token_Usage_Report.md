# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| ic-final-history-globalinterlink | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | 60,000 (estimated) | 15,000 (estimated) | 75,000 (estimated) | $0.75 (estimated) | 0 | No | 0.5 | Merged | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | 15,000 (estimated) | $0.15 | 20% | AI_Request + Scenario + Risk + Solution |
| Solution Design | Opus | 10,000 (estimated) | $0.10 | 13% | Solution.md 含 5 步实施方案 |
| Code Implementation | Opus | 30,000 (estimated) | $0.30 | 40% | 4 个 Edit + 字段验证 Grep |
| Test Generation | Opus | 10,000 (estimated) | $0.10 | 13% | Task + Test + Verify (Track B) |
| Verification | Opus | 5,000 (estimated) | $0.05 | 7% | Merge_Decision + 静态断言 |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无 self-fix |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $1.50/hr (estimated) |
| Token / Saved Hours | 150,000/hr (estimated) |

> Reference benchmarks: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr.
> 本 case 高于基准，因为是 Opus 模型处理 Yellow 风险单文件改动（路径 B Mode 1）。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Yellow 用了 Opus | 路径 B Mode 1 由主 Claude (Opus) 直接执行，未派 SubAgent | 单文件改动，Sonnet 亦可胜任；后续同类 Green/Yellow 路径 B 可评估切 Sonnet 降本 |
