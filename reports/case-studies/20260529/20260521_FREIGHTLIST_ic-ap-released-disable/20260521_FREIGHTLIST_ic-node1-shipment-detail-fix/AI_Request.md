# AI Request

## Meta
- **Case ID**: 20260521_FREIGHTLIST_ic-node1-shipment-detail-fix
- **Owner**: LiangWB
- **Team**: FREIGHTLIST
- **Project**: bus-freightlist-handler-service
- **Risk Level**: Yellow
- **Execution Mode**: Mode 1 (LL-only)
- **Path**: B (LL Skill)

## Branch Info
- **Task Type**: bug fix
- **Base Branch**: develop_1.1.0
- **New Branch Name**: fix/ic-node1-shipment-detail-fix
- **Worktree Path**: .claude/worktrees/fix-ic-node1-shipment-detail-fix

## Description

IC v2 chain Node1Trigger `getShipmentDetails()` return value not stored in meta, causing Node2 `getShipmentDetail()` to always return null. Downstream effects:
1. `serial_no` field null on ic_transaction INSERT, DB rejects with "Field 'serial_no' doesn't have a default value"
2. Node2 line 782 `shipmentDetail.getSdSourceSystem()` NPE in else branch when shipmentDetail is null

## Fix Scope
1. Node1Trigger.java line 90: store return value `meta.setShipmentDetailList(getShipmentDetails(meta))`
2. Node2IcTransCalc.java: when shipmentDetail is null, fallback `entity.setSerialNo(meta.getCurrentIcSectionHeader().getSerialNo())`
3. Node2IcTransCalc.java line 782: add null check for shipmentDetail in else branch
