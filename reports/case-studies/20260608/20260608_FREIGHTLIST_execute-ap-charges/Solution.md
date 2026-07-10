# Solution

## Technical Constraints

- Pre-verified Environment: worktree + JGit 不兼容，Track B
- 目标文件: `IcAutoModeServiceImpl.java:229-231`（当前 executeApChargesProcessing TODO 占位）
- 复用已有 isArCharge 重载方法判断 AR/AP
- 新增 getArInvoiceNo 占位方法（返回 String）
- 使用 IcStatus.ACTUAL 常量（已验证存在，值为 "ACT"）
