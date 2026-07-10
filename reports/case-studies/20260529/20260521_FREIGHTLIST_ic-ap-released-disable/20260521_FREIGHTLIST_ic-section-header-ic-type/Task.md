# Task.md - 20260521_FREIGHTLIST_ic-section-header-ic-type

## Tasks

| # | Task | File | Status |
|---|---|---|---|
| 1 | IcSectionHeaderEntity 新增 icType 字段 | entity/IcSectionHeaderEntity.java | Done |
| 2 | IcSectionHeaderMapper.xml 补充 resultMap + columnList | resources/mybatis/IcSectionHeaderMapper.xml | Done |
| 3 | Node1Trigger.createIcSectionHeader() 添加 setIcType | node/ic/v2/Node1Trigger.java | Done |

## Notes

- InterComTransEvent.icType（line 32）、IcTransMetaItem.icType（line 30）、IcTransactionServiceImpl.buildMeta() 的 setIcType（line 108）均已存在，无需改动
- IC_TRANS_FINAL 流的 IcTransFinalMetaItem 不含 icType，Node1Trigger 只消费 IcTransMeta 上下文，不影响 FINAL 流
