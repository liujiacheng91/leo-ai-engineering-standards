# Scenario.md - 20260521_FREIGHTLIST_ic-trans-final-shipment-number

## Background
ic_transaction_final 表的 shipment_number 字段始终为 null。业务期望该字段与 house_no 保持一致。

## Root Cause
Node3IcTransFinalCalc.buildFinalEntity() 方法构建 IcTransactionFinalEntity 时设置了 houseNo 但遗漏了 shipmentNumber 赋值。

## Acceptance Criteria
- AC-1: 当 IC_TRANS_FINAL 链执行时，ic_transaction_final.shipment_number 应等于同行的 house_no 值
- AC-2: IC_TRANS 链不受影响（IcTransactionEntity 无 shipmentNumber 字段）

## Assumptions
- shipment_number 的数据源是 IcTransactionEntity.houseNo（来源：Shipment_Header.sh_house_no）
- 不涉及 DDL 变更（字段已存在）

## Impact
- 影响 IC_TRANS_FINAL 落库数据，Node3IcTransFinalCalc 是唯一构建 IcTransactionFinalEntity 的位置
- IC_TRANS 链 / FREIGHT_LIST 链不受影响
