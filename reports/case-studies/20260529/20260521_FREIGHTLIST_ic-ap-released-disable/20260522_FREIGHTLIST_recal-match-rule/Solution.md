# Solution.md

## Case Info

- Case ID: 20260522_FREIGHTLIST_recal-match-rule
- Risk Level: Yellow
- Execution Mode: Mode 1 (LL-only)

## Technical Constraints

- Java 21
- `IcTriggerConfigEntity.id` 类型为 `Integer`，`IcSectionHeaderEntity.ruleId` 类型为 `Long`
- `checkStopReGenAfterMinutes(IcTransMetaItem meta, int minutes)` 已存在于 `IcTriggerConfigServiceImpl:99`
- `existOutstandingDiff(IcTransMetaItem meta)` 已存在于 `IcTriggerConfigServiceImpl:147`
- `IcTriggerConfigEntity.stopAfterMinutes` 类型为 `Integer`
- `IcTriggerConfigEntity.regenThreshold` 类型为 `BigDecimal`
- `existOutstandingDiff` 内部通过 `meta.getCurrentTriggerConfig()` 获取 threshold
- `ServiceImpl.getById(Serializable)` 可直接用 Long 类型查 Integer 主键
- Worktree 构建不可行（JGit / versioning 兼容性）

## Recommended Solution

修改 `IcTriggerConfigServiceImpl.reCalMatchRule` 方法，将 todo 桩替换为完整实现：

1. 从 `meta.getLastIcHeader()` 获取 `ruleId`，null 检查后查 DB
2. `this.getById(ruleId)` 查找配置，找不到返回 true
3. 找到后 `meta.setCurrentTriggerConfig(config)` + 写 triggerLog
4. 依次检查 `stopAfterMinutes`（null 跳过）和 `existOutstandingDiff`
5. 两者都通过才返回 true

改动文件：1 个（`IcTriggerConfigServiceImpl.java`）

## Post-Merge Test Plan (Track B)

- Command: `gradle :expand:business-freightlist-summary:test`
- Owner: Liangwb
- Timing: 合并到 develop_1.1.0 后立即执行
