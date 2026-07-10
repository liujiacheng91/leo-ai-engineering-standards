# Solution

## Technical Constraints

- Pre-verified Environment: worktree + JGit 不兼容，Track B
- 目标文件: `IcAutoModeServiceImpl.java:133-135`（当前 processArCharges TODO 占位）
- AR/AP 判断来源:
  - IcTransactionFinalEntity: `transType` 字段直接存储 AR/AP（Node30 line 308-313 设置）
  - IcTransactionEntity: 无直接 AR/AP 字段，通过 `psAmount > 0 = AR`（参考 Node30 的 `amount > 0` 逻辑）
- 常量: `IcStatus.PROVISIONAL = "PRV"`, `TransType.AR = "AR"`, `TransType.AP = "AP"`
- 新增 import: BigDecimal, IcStatus, TransType

## Task

1. 新增 `isArCharge(IcTransactionFinalEntity)` -- 读 transType 判断
2. 新增 `isArCharge(IcTransactionEntity)` -- 通过 psAmount > 0 计算
3. 实现 `processArCharges` -- 设置 header + 遍历 final + 遍历 transaction
