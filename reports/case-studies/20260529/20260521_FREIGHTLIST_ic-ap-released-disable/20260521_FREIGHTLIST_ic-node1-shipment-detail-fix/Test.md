# Test

## Case
20260521_FREIGHTLIST_ic-node1-shipment-detail-fix

## Test Scope
- Node1Trigger.processIml: getShipmentDetails 返回值存入 meta.shipmentDetailList
- Node2IcTransCalc.createIcTrans: shipmentDetail 为 null 时 serialNo 兜底逻辑
- Node2IcTransCalc.createIcTrans: ext 和 shipmentDetail 都为 null 时无 NPE

## Mock Strategy
- Mockito strictness: LENIENT（LiteFlow NodeComponent 依赖框架上下文）
- IcTransMetaItem: 手动构造，设置 shipmentDetailList / currentIcSectionHeader
- ShipmentDetailEntity / IcSectionHeaderEntity: 手动构造并 set 字段

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | shipmentDetail 存在 | meta.shipmentDetailList 非空，station 匹配 | entity.serialNo = shipmentDetail.sdSerialNo | AC-1 |
| 2 | shipmentDetail 为 null | meta.shipmentDetailList 为空 | entity.serialNo = sectionHeader.serialNo | AC-2 |
| 3 | ext 和 shipmentDetail 都为 null | ext=null, shipmentDetail=null | 不抛 NPE，systemType 不被设置 | AC-3 |
| 4 | ext 存在 | ext 非空 | entity.systemType = ext.sourceSystem（不受 shipmentDetail null 影响） | AC-1 |
| 5 | Node1 存储返回值 | getShipmentDetails 返回列表 | meta.shipmentDetailList 被赋值 | AC-1 |

## Boundary Cases
- shipmentDetailList 为 null（未初始化）
- shipmentDetailList 为空 list（初始化但无数据）
- station 不匹配任何 shipmentDetail

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| - | N/A | N/A | N/A | N/A |
