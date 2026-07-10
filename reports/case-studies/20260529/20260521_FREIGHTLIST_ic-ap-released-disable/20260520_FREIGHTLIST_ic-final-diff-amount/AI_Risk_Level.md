# AI Risk Level - 20260520_FREIGHTLIST_ic-final-diff-amount

## Risk Level: Yellow

## Justification

- 修改 LiteFlow 链上节点 (`ic_trans_final_calc_v2`) 的计算逻辑，按仓库风险默认表属于 Yellow
- 改动范围极小（1 个方法体 + 1 个构造器参数），不涉及 Node5/Node10/Node11（Red 节点）
- 不改表结构、不改 chain 定义、不改 Kafka topic
- IC_TRANS_FINAL 每月触发 1 次，影响面可控

## Impact

- 影响 ic_transaction_final 表写入的 amount 值
- 不影响 PDF 团队（不改表结构，只改计算逻辑）
- 不影响其他节点（calcDiffAmount 仅在 Node3 内部调用）
