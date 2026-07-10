# Scenario.md

## Background

IC v2 链的 Node1Trigger.finalizeProcessResult() 在第 324 行将 transType（PRV/ACT）设到 meta 上，第 329 行调用 createIcSectionHeader(meta) 创建 ic_section_header。但 createIcSectionHeader() 方法内通过 copyPropertiesWithPrefix 从 FlAggregationSectionHeaderEntity 复制字段时，源实体没有 flAshTransType 字段，导致 trans_type 未被复制。方法内也没有显式 setTransType() 调用。

## Current Behavior

- ic_section_header.trans_type 始终为 null
- ic_transaction.trans_type 由 Node2IcTransCalc:776 从 meta.getTransType() 正确赋值（PRV/ACT）
- 两表 trans_type 不一致

## Expected Behavior

- ic_section_header.trans_type = meta.getTransType()（PRV 或 ACT）
- ic_section_header.trans_type 与 ic_transaction.trans_type 保持一致

## Acceptance Criteria

- AC-1: 当 createIcSectionHeader 被调用时，ic_section_header.trans_type 应被赋值为 meta.getTransType() 的值（PRV 或 ACT）

## Assumptions

- meta.getTransType() 在 createIcSectionHeader 调用前已被 finalizeProcessResult:324 设置，时序保证有效
- 不影响 ic_transaction / ic_transaction_final 的现有 transType 赋值逻辑

## Impact

- 影响表: ic_section_header（trans_type 字段）
- 影响节点: ic_trigger_v2 (Node1Trigger)
- 对 PDF 团队: 透明（不改表结构，只补充已有字段的赋值）
