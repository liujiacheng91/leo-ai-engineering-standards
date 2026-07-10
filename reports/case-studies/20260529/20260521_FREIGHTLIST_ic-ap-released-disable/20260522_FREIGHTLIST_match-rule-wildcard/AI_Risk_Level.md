# AI Risk Level

- **Risk Level**: Green
- **Case ID**: 20260522_FREIGHTLIST_match-rule-wildcard

## Justification

- 改动范围：单文件 `IcTriggerConfigServiceImpl.java`，3 个 private 方法各加一个 `||` 条件
- 不涉及 LiteFlow 链定义、DB schema、落库节点、Kafka topic
- 不涉及 Node5/Node10/Node11 等共享果子或唯一落库点
- 与 `matchOrigin` 已有的 `*` 通配符模式完全一致，风险极低
