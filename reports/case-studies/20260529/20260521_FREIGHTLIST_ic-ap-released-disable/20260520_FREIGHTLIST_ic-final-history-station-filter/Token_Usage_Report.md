# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| ic-final-history-station-filter | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~80,000 (estimated) | ~15,000 (estimated) | ~95,000 (estimated) | ~$1.50 (estimated) | 0 | No | 0.5 | Done | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~15,000 (estimated) | ~$0.24 | 16% | AI_Request + Scenario + Risk + Solution |
| Solution Design | Opus | ~10,000 (estimated) | ~$0.16 | 11% | Solution.md 含 Track B Declaration |
| Code Implementation | Opus | ~35,000 (estimated) | ~$0.55 | 37% | 5 edits + Grep 验证 |
| Test Generation | Opus | ~10,000 (estimated) | ~$0.16 | 11% | Test.md 设计（无实际单测代码） |
| Verification | Opus | ~15,000 (estimated) | ~$0.24 | 16% | Verify.md + Merge_Decision.md |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无 retry |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | ~$3.00/hr (estimated) |
| Token / Saved Hours | ~190,000/hr (estimated) |

> Reference benchmarks: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr.

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Yellow + Opus | Yellow 任务使用 Opus | 路径 B 由主 Claude（Opus）直接执行，非 SubAgent 升级；单文件改动无需降级 Sonnet |
