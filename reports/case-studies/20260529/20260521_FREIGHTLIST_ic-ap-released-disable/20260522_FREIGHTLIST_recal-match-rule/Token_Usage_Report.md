# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---|---|---:|---|---|
| reCalMatchRule 重计算触发规则匹配 | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | 60,000 (estimated) | 15,000 (estimated) | 75,000 (estimated) | $2.03 (estimated) | 0 | No | 0.75 | Pass | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | 15,000 (estimated) | $0.41 (estimated) | 20% | AI_Request + Scenario + AI_Risk_Level + Solution |
| Solution Design | Opus | 10,000 (estimated) | $0.27 (estimated) | 13% | Solution.md Technical Constraints + Track B |
| Code Implementation | Opus | 25,000 (estimated) | $0.68 (estimated) | 33% | 读源码 + 实现 reCalMatchRule + commit |
| Test Generation | Opus | 10,000 (estimated) | $0.27 (estimated) | 13% | Test.md 设计（静态断言，Track B） |
| Verification | Opus | 10,000 (estimated) | $0.27 (estimated) | 13% | Verify.md + Merge_Decision.md |
| Rework / Retry | N/A | 0 | $0.00 | 0% | 无自修复 |
| 收尾三件套 | Opus | 5,000 (estimated) | $0.14 (estimated) | 7% | PR_Template + AI_Case_Card + Token_Usage_Report |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $2.03 / 0.75h = $2.71/hr (estimated) |
| Token / Saved Hours | 75,000 / 0.75h = 100,000 tokens/hr (estimated) |

> 参考基准: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr。本 case 高于参考基准，因为路径 B / Mode 1 使用 Opus（Yellow 风险），且 token 为估算值。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 20260522_FREIGHTLIST_recal-match-rule | Yellow 任务使用 Opus | 路径 B / Mode 1 由主 Claude 直接执行，主 Claude 当前模型为 Opus，非显式升级；无可避免 |

备注：Retry Count = 0，未触发 Retry 阈值。单阶段最高 33%（Code Implementation），未触发 40% 阈值。整案 Total Token ~75K，远低于 500K 阈值。
