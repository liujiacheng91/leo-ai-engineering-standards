# Scenario.md - 20260521_FREIGHTLIST_ic-section-header-ic-type

## Background

ic_section_header 表已通过 DDL 新增 ic_type 列（VARCHAR(16)），用于标识 IC 计算的触发类型：PS（分利计算，每天两次）或 MONTH_END（月结）。当前实体类和 Mapper XML 尚未同步，Node1Trigger.createIcSectionHeader() 也未对该字段赋值。

## Data Flow Analysis

数据流已验证完整：
1. Kafka 消息 InterComTransEvent 已有 icType 字段（event/InterComTransEvent.java:32）
2. IcTransactionServiceImpl.buildMeta() 已拷贝 meta.setIcType(event.getIcType())（line 108）
3. IcTransMetaItem 已有 icType 字段（meta/IcTransMetaItem.java:30）
4. Node1Trigger.createIcSectionHeader() 尚未设置 icSectionHeaderEntity.setIcType()
5. IcSectionHeaderEntity 尚未定义 icType 字段
6. IcSectionHeaderMapper.xml 尚未映射 ic_type 列

IC_TRANS_FINAL 链（IcTransFinalMetaItem / InterComTransFinalEvent）不含 icType 字段，Node1Trigger 只消费 IcTransMeta 上下文，FINAL 流在 Node1 不创建 ic_section_header。

## Acceptance Criteria

- AC-1: 当 IC_TRANS 链触发创建 ic_section_header 时，ic_type 字段应从 meta.getIcType() 获取并落库
- AC-2: IcSectionHeaderEntity 包含 icType 字段，映射到 ic_type 列
- AC-3: IcSectionHeaderMapper.xml 的 BaseResultMap 和 Base_Column_List 包含 ic_type

## Assumptions

- DDL 已在数据库执行（用户已说明"ic_section_header表增加了ic_type字段"）
- icType 取值范围：PS / MONTH_END（VARCHAR(16) 足够）
- IC_TRANS_FINAL 不需要 icType（FINAL 流 Node1Trigger 不创建 ic_section_header）

## Scope

- 改动文件：IcSectionHeaderEntity.java / IcSectionHeaderMapper.xml / Node1Trigger.java
- 不动：InterComTransEvent / IcTransMetaItem / IcTransactionServiceImpl（已有 icType 字段和拷贝逻辑）
