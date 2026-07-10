# AI Risk Level - 20260521_FREIGHTLIST_ic-trigger-match-origin

## Risk Level: Yellow

## Rationale

- 改动位于 IC v2 链 Node1Trigger 的触发规则匹配逻辑（IcTriggerConfigServiceImpl）
- 虽然只改 1 个文件，但涉及 LiteFlow 链上节点的非算法部分（触发规则匹配）
- 需要新增构造器注入依赖（IIcTriggerStationConfigService）
- 需要修改 matchOrigin 方法签名和 matchRule 中的调用点
- 不动落库逻辑、不动 DB schema、不动链定义

## Impact

- IC_TRANS 每天触发 2 次、IC_TRANS_FINAL 每月触发 1 次
- matchOrigin 返回 false 会阻止该条规则触发，但不影响其他规则（matchRule 遍历所有 enabled 规则，满足任一即触发）
- 不影响 PDF 团队
