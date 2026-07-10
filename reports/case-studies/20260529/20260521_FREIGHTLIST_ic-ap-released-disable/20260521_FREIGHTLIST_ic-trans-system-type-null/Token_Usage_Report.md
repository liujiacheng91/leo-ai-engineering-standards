# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| ic_transaction.system_type null 修复 | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | 150,000 (estimated) | 27,000 (estimated) | 177,000 (estimated) | $4.28 (estimated) | 1 [Logic] | No subAgent (Path B Mode 1, 主 Claude Opus 亲自执行全流程) | 1.2 | Pass | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | 30,000 (estimated) | $0.73 (estimated) | 17% | AI_Request + Scenario + AI_Risk_Level |
| Solution Design | Opus | 23,000 (estimated) | $0.56 (estimated) | 13% | Solution.md + Track B Declaration |
| Code Implementation | Opus | 40,000 (estimated) | $0.97 (estimated) | 23% | 初次 fix + 代码走读定位 |
| Test Generation | Opus | 12,000 (estimated) | $0.29 (estimated) | 7% | Test.md 静态验证设计 |
| Verification | Opus | 18,000 (estimated) | $0.44 (estimated) | 10% | Verify.md + Merge_Decision.md |
| Rework / Retry | Opus | 29,000 (estimated) | $0.70 (estimated) | 16% | 用户返工：统一 keyShipment 取值 + 旧逻辑注释保留 + 更新 Verify/Merge_Decision |
| Closing Docs | Opus | 25,000 (estimated) | $0.59 (estimated) | 14% | PR_Template + AI_Case_Card + Token_Usage_Report + Merge_Decision 回填 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $3.57/hr (estimated) |
| Token / Saved Hours | 147,500 tokens/hr (estimated) |

> 高于 BizDB $0.59/hr 基准，原因：Path B 全程使用 Opus（主 Claude 模型），无法降级 Sonnet。见 Abnormal Cost Review。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Yellow 任务使用 Opus | Path B 模式主 Claude 即 Opus，全流程无 subAgent 可降级 Sonnet | 已知限制；未来考虑 Path B 小改动场景切换到 Sonnet 模式的主 Claude |
| Code Implementation 使用 Opus | 同上，Path B 无独立 DEV subAgent | 同上 |
| Retry Count = 1 | 未触发 Abnormal（阈值 3），但记录：初次方案假设错误 [Logic]，用户纠偏后一次修复 | 无需额外行动 |
