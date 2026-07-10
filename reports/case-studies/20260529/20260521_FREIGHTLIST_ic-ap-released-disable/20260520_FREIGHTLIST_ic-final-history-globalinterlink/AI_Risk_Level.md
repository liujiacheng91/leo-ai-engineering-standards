# AI Risk Level

## Risk: Yellow

## Reason
- 修改 LiteFlow 链上节点 `ic_trans_final_calc_v2` 的查询逻辑
- 改动影响 IC_TRANS_FINAL 链的差额计算结果（查询维度从 serialNo 变为 globalInterlink）
- 单文件改动，不涉及 DB schema / Kafka / 落库节点 / 生产配置

## Mitigation
- 仅改 `Node3IcTransFinalCalc.java` 一个文件
- 查询条件变更（serialNo -> globalInterlink）是用户明确要求的业务语义调整
- 差额公式 `psAmount - historyTotal` 不变
- 不涉及 Node11Save / Node4Save 等落库节点
