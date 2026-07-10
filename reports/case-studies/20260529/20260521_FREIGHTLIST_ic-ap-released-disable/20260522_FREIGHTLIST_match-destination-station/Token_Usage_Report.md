# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| matchRule补充destination站点匹配逻辑 | bus-freightlist-handler-service | FREIGHTLIST | Green | Opus | ~80,000 (estimated) | ~5,000 (estimated) | ~85,000 (estimated) | $1.58 (estimated) | 0 | No | 0.5 | Pass | Yes |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~25,000 (estimated) | $0.45 (estimated) | 29% | 定位代码 + 读取3个文件 + 确认字段 |
| Solution Design | Opus | ~5,000 (estimated) | $0.10 (estimated) | 6% | 内联在 Scenario 中，无独立 Solution.md（Green） |
| Code Implementation | Opus | ~30,000 (estimated) | $0.56 (estimated) | 35% | 3次Edit + matchStationConfig提取 + matchDestination实现 |
| Test Generation | Opus | ~10,000 (estimated) | $0.19 (estimated) | 12% | Test.md + Verify.md |
| Verification | Opus | ~10,000 (estimated) | $0.19 (estimated) | 12% | 静态审查 + commit |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无自修复 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $3.16/hr (estimated) |
| Token / Saved Hours | 170,000 tokens/hr (estimated) |

> 参考基准: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr。本次高于基准因使用 Opus 模型（主 Claude 默认模型），无 SubAgent。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| (未触发) | Retry=0, 无单阶段>40%, Green未额外调Opus(主Claude默认), Total<500K | 无需处理 |
