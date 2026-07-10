# AI_Risk_Level.md

## Risk Level: Yellow

## Justification

- 改动在 IC 触发规则 service 层（`IcTriggerConfigServiceImpl`），被 Node1Trigger 间接调用
- 单文件改动，不涉及 LiteFlow 节点、DB schema、Kafka 路由
- 涉及重构（抽取通用方法），需确保 origin_country 行为不变
- 涉及 DB 查询（`ic_trigger_country_config` + `md_auto_program_parties`，只读）

## Impact

- 影响 IC_TRANS 和 IC_TRANS_FINAL 两条链的触发判断
- 不影响 FREIGHT_LIST 链
- 不影响 PDF 团队
