# Solution

## Technical Constraints

- Pre-verified Environment: worktree + JGit 不兼容，Track B
- 目标文件: IcAutoModeServiceImpl.java:321-324（当前 getArInvoiceNo 占位返回 null）
- 数据来源: meta.getLinkedCharges()（ChargeDetailLinkedEntity 列表）
- 筛选条件: cdlTransType=AR 且 cdlSource="B" 且 cdlChargeStatus 在 RELEASED_STATUS_LIST 中
- 返回值: 第一条 cdlTransNo 非空的记录的 cdlTransNo，全空返回 null
- 复用已有 RELEASED_STATUS_LIST 常量
- 使用 StringUtils.isNotBlank 检查 cdlTransNo（仓库现有风格）
