# Solution

## Technical Constraints

- Pre-verified Environment: worktree + JGit 不兼容，Track B
- 目标文件: `IcAutoModeServiceImpl.java:80-82`（当前 TODO 占位）
- 数据来源: `IcTransMetaItem.lastIcHeader`（`IcSectionHeaderEntity`，line 65）
- 字段已验证: `IcSectionHeaderEntity.generatedPendingReleaseFlag`(Integer, line 268)

## Task

1. 在 `semiAutoWorkflow` 内获取 `meta.getLastIcHeader()` 的 `generatedPendingReleaseFlag`
2. flag=1 调 `processApCharges(meta)`; flag=0/null 调 `processArCharges(meta)`
3. 新增两个 private 空方法 `processArCharges` / `processApCharges`，带 TODO
4. 更新接口 Javadoc
