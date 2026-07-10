# Solution.md - 20260521_FREIGHTLIST_ic-trans-final-shipment-number

## Technical Constraints
- Java 21
- IcTransactionFinalEntity.shipmentNumber 字段已存在（@TableField("shipment_number")）
- 数据源：IcTransactionEntity.houseNo（来源 Shipment_Header.sh_house_no）
- Worktree 构建不可行（JGit/versioning 不兼容）

## Recommended Solution
在 Node3IcTransFinalCalc.buildFinalEntity() 中，setHouseNo 之后添加 setShipmentNumber(transaction.getHouseNo())。

Execution Mode: Mode 1

## Post-Merge Test Plan (Track B)
- Command: `gradle :expand:business-freightlist-summary:compileJava`
- Owner: Liangwb
- Timing: 合并到 develop_1.1.0 后第一时间
