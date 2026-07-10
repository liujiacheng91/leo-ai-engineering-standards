# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---|---|---:|---|---|
| ic-ap-share-type-filter | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~40K (estimated) | ~8K (estimated) | ~48K (estimated) | ~$0.80 (estimated) | 0 | No - 主 Claude 直接执行 | 0.25 | 已合并 | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~10K (estimated) | ~$0.15 | 21% | 字段确认 + Scenario/AI_Risk_Level |
| Solution Design | Opus | ~5K (estimated) | ~$0.08 | 10% | Solution.md |
| Code Implementation | Opus | ~15K (estimated) | ~$0.23 | 31% | IcTriggerConfigServiceImpl 修改 |
| Test Generation | Opus | ~5K (estimated) | ~$0.08 | 10% | Test.md (无实际单测代码) |
| Verification | Opus | ~8K (estimated) | ~$0.12 | 17% | Verify.md + Merge_Decision.md |
| Rework / Retry | Opus | ~5K (estimated) | ~$0.08 | 10% | 收尾三件套 |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $3.20/hr (estimated) |
| Token / Saved Hours | 192K/hr (estimated) |

> 参考基准: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr. 本次 $3.20/hr 高于基准，因为是极小改动（+2/-2），AI 节省绝对时间有限。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 未触发 | Retry=0, 单阶段最高 31% (< 40%), Yellow 用 Opus (路径 B 主 Claude 直接执行无法降级), Total ~48K (< 500K) | 无需审查 |
