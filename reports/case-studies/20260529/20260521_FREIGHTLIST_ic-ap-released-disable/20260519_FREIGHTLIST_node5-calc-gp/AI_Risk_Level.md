# AI_Risk_Level.md

## Case Info

- Case ID: 20260519_FREIGHTLIST_node5-calc-gp

## Risk Level: Yellow

## Justification

- Node5ProfitShare 是 LiteFlow 链上节点，默认归 Yellow
- calcGp 生成的 freightListGpEntity（sequence=9）不参与 ProfitShareTotal 计算（ProfitShareTotal = Distribution + Sweep，见 processIml line 143-149），不影响 Node7/Node8 消费的"共享果子"
- 不触发 Red 判定项：不改 ProfitShareTotal / 不改 Node10 Exception / 不改 Node11 Save / 不改 schema / 不改 Kafka

## Impact

- 影响 PDF 报表 FREIGHT_LIST_GP 行的数值展示
- 不影响其他 section 数据
