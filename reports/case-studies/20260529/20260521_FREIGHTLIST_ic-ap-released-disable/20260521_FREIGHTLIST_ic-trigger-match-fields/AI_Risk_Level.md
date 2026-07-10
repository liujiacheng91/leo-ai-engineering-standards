# AI_Risk_Level.md

## Risk Level: Yellow

## Rationale

- 改动位于 LiteFlow v2 链上节点调用的 service 方法（Node1Trigger -> matchRule -> matchXxx）
- 单文件改动（IcTriggerConfigServiceImpl.java），5 个方法体替换
- 不动算法核心（Node5 ProfitShare / Node11 Save 等），不动 DB schema，不动 Kafka topic
- 属于"修改 LiteFlow 链上某节点的非算法部分"，按仓库风险默认值归 Yellow

## Impact Analysis

- 影响范围：IC_TRANS 和 IC_TRANS_FINAL 两条链的触发判断
- IC_TRANS 每天触发 2 次，IC_TRANS_FINAL 每月 1 次
- 改动前所有规则都能通过（todo return true），改动后不符合规则的会被正确拦截
- 不影响 FREIGHT_LIST 链
