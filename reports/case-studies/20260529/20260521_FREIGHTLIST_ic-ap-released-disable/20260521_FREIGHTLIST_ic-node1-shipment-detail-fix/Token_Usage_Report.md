# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---|---|---:|---|---|
| ic-node1-shipment-detail-fix | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Opus | ~80K (estimated) | ~15K (estimated) | ~95K (estimated) | ~$1.50 (estimated) | 1 [Logic] | No - 主 Claude 直接执行 | 0.5 | 已合并 | No |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus | ~20K (estimated) | ~$0.30 | 21% | 根因分析 + Scenario/AI_Risk_Level |
| Solution Design | Opus | ~15K (estimated) | ~$0.23 | 16% | Solution.md + Task.md |
| Code Implementation | Opus | ~25K (estimated) | ~$0.38 | 26% | Node1Trigger + Node2IcTransCalc 修改 |
| Test Generation | Opus | ~10K (estimated) | ~$0.15 | 11% | Test.md (无实际单测代码) |
| Verification | Opus | ~10K (estimated) | ~$0.15 | 11% | Verify.md + Merge_Decision.md |
| Rework / Retry | Opus | ~15K (estimated) | ~$0.23 | 16% | 1 轮返工: getShipmentDetails 方法重构为 void |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $3.00/hr (estimated) |
| Token / Saved Hours | 190K/hr (estimated) |

> 参考基准: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr. 本次 $3.00/hr 高于基准，因为是 bug 修复类任务（手工排查时间短，AI 节省绝对时间有限）。

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 未触发 | Retry=1 (< 3), 单阶段最高 26% (< 40%), Yellow 用 Opus (路径 B 主 Claude 直接执行无法降级), Total ~95K (< 500K) | 无需审查 |
