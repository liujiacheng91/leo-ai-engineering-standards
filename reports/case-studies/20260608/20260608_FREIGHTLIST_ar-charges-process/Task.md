# Task

1. 新增 `isArCharge(IcTransactionFinalEntity)` -- 读 transType 字段（AR/AP）
2. 新增 `isArCharge(IcTransactionEntity)` -- psAmount > 0 = AR
3. 实现 `processArCharges`：设置 header flag/transType + 遍历 final/transaction 按 AR/AP 分别赋值
4. 新增 import: IcStatus, TransType, BigDecimal
