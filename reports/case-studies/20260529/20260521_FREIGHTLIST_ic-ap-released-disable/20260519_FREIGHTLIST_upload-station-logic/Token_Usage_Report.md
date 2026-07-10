# Token Usage Report

## Task-Level

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| upload-station-logic | bus-freightlist-handler-service | FREIGHTLIST | Green | Opus | ~80K (estimated) | ~15K (estimated) | ~95K (estimated) | ~$2.10 (estimated) | 0 | No | 0.5h | Complete | No |

## Stage-Level

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---|---|---|---|
| Scenario Analysis | Opus | ~15K (estimated) | ~$0.33 | 16% | 读代码 + 验证调用方 + 写 Scenario/AI_Risk_Level |
| Solution Design | Opus | ~5K (estimated) | ~$0.11 | 5% | Green 路径 B, 无独立 Solution.md |
| Code Implementation | Opus | ~30K (estimated) | ~$0.66 | 32% | 编辑 2 文件 + 编译验证 + worktree 管理 |
| Test Generation | Opus | ~5K (estimated) | ~$0.11 | 5% | 静态测试设计 (Test.md) |
| Verification | Opus | ~10K (estimated) | ~$0.22 | 11% | Verify.md + 编译证据 |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无自修复 |
| Documentation | Opus | ~30K (estimated) | ~$0.67 | 31% | LL 6 文档 + Token Report |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | ~$4.20/hr |
| Token / Saved Hours | ~190K/hr |
| Reference Baseline | BizDB $0.59/hr |

## Abnormal Cost Review

| Trigger | Status | Notes |
|---|---|---|
| Retry >= 3 | Not triggered | Retry = 0 |
| Single stage > 40% | Not triggered | Max = Code Implementation 32% |
| Green + Opus | Triggered | 主 Claude 运行在 Opus; 本任务为路径 B Mode 1 主 Claude 亲自执行, 不涉及 SubAgent model 选择 |
| Total > 500K | Not triggered | ~95K |
