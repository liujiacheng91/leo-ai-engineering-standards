# AI_Risk_Level.md

## Risk Level: Yellow

## Rationale

- 改动位于 LiteFlow 链上节点 `Node2IcTransCalc`（IC v2 链的第二节点）
- 仅增加一个 else 分支做兜底赋值，不改变已有逻辑路径
- 影响范围：`ic_transaction` 和 `ic_transaction_change` 表的 `system_type` 字段
- Node3IcTransFinalCalc 从 IcTransactionEntity 复制 systemType，上游修好下游自然修好

## Risk Factors

| Factor | Assessment |
|---|---|
| LiteFlow 节点改动 | Yellow（默认） |
| 改动范围 | 单方法增加 else 分支 |
| 影响落库表 | ic_transaction.system_type |
| 跨节点影响 | Node3 从 transaction 复制，无独立风险 |
| PDF 团队影响 | 无（system_type 不在 PDF 报表字段中） |
