# Task.md

## Task Goal
在 Node3IcTransFinalCalc.buildFinalEntity() 中补充 shipmentNumber 赋值，使 ic_transaction_final.shipment_number = house_no。

## Related Documents

- AI_Request.md
- Scenario.md
- AI_Risk_Level.md
- Solution.md

## Task Breakdown

| Task ID | Task | Input | Output | Files | Done Criteria | Verification |
|---|---|---|---|---|---|---|
| T-1 | 在 buildFinalEntity() 中添加 setShipmentNumber | transaction.getHouseNo() | entity.shipmentNumber 被赋值 | Node3IcTransFinalCalc.java | setShipmentNumber 紧跟 setHouseNo 之后 | 静态审查 + Track B 合并后编译 |

## Function-Level Design

| Function / API | Responsibility | Input | Output | Error Handling | Test Requirement |
|---|---|---|---|---|---|
| Node3IcTransFinalCalc.buildFinalEntity() | 构建 IcTransactionFinalEntity | IcTransactionEntity transaction | IcTransactionFinalEntity（含 shipmentNumber） | 外层 process() 吞异常 | AC-1: shipmentNumber == houseNo |
