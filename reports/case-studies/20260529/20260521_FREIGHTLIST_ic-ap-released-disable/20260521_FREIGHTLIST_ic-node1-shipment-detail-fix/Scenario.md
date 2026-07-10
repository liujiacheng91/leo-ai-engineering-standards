# Scenario

## Case
20260521_FREIGHTLIST_ic-node1-shipment-detail-fix

## Background
IC v2 chain (`THEN(ic_trigger_v2, ic_trans_calc_v2, ic_trans_final_calc_v2, ic_save_v2)`) Node1Trigger loads shipment detail data but discards the return value. Downstream Node2 cannot find shipment detail, causing:
- `serial_no` field null on ic_transaction INSERT, DB rejects with `BatchUpdateException: Field 'serial_no' doesn't have a default value`
- Node2 line 782 potential NPE when shipmentDetail is null in else branch

## Acceptance Criteria
- AC-1: When IC_TRANS triggers, ic_transaction records should be successfully written to DB with correct serial_no values
- AC-2: When shipmentDetail is null for a station, serialNo should fall back to ic_section_header.serialNo instead of being null
- AC-3: When both ext and shipmentDetail are null, no NPE should occur at Node2 createIcTrans

## Assumptions
- ic_section_header.serialNo is always populated by Node1 (confirmed: copied from FL section header)
- The fix does not change any business calculation logic, only data flow plumbing

## Impact
- ic_transaction / ic_transaction_final tables resume normal writes
- No impact on PDF team (no schema change)
- No impact on FREIGHT_LIST chain
