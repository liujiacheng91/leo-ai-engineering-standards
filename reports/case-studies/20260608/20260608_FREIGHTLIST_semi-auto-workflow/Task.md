# Task

1. `semiAutoWorkflow` 读 `meta.getLastIcHeader().getGeneratedPendingReleaseFlag()`
2. flag=1 调 `processApCharges(meta)`; 否则调 `processArCharges(meta)`
3. 新增 `processArCharges` / `processApCharges` 两个空私有方法
4. 接口 Javadoc 补充分支逻辑说明
