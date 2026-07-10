# Solution

## Case
20260521_FREIGHTLIST_ic-node1-shipment-detail-fix

## Technical Constraints
- Java 21
- LiteFlow NodeComponent pattern: process() swallows exceptions
- IcTransMetaItem.shipmentDetailList field exists (line 97), setter available via @Data
- ShipmentDetailEntity.getSdSerialNo() available
- IcSectionHeaderEntity.getSerialNo() available
- Worktree build: Track B (JGit/versioning incompatibility)

## Recommended Solution

### Fix 1: Node1Trigger.java line 90
Change `getShipmentDetails(meta)` to `meta.setShipmentDetailList(getShipmentDetails(meta))`.

### Fix 2: Node2IcTransCalc.java createIcTrans()
When `getShipmentDetail(station, meta)` returns null, fall back to `entity.setSerialNo(meta.getCurrentIcSectionHeader().getSerialNo())`.

### Fix 3: Node2IcTransCalc.java line 782
Change `else { entity.setSystemType(shipmentDetail.getSdSourceSystem()); }` to `else if (shipmentDetail != null) { ... }` to prevent NPE.

## Post-Merge Test Plan
- Command: `gradle :expand:business-freightlist-summary:compileJava`
- Owner: LiangWB
- Timing: immediately after merge to develop_1.1.0
