# Solution

## Case
20260521_FREIGHTLIST_ic-section-header-rule-info

## Technical Constraints
- Java 21
- IcSectionHeaderEntity: ruleId (Long), triggerRule (String)
- IcTriggerConfigEntity: id (Integer), ruleName (String)
- IcTransMetaItem: lastIcHeader (IcSectionHeaderEntity), currentTriggerConfig (IcTriggerConfigEntity)
- Worktree 构建不可行（JGit/versioning 兼容性）

## Recommended Solution
Mode 1, 单文件修改。在 Node1Trigger.createIcSectionHeader 方法中，entity 创建完毕、设入 meta 之前，追加规则信息赋值逻辑：

```java
if (meta.getLastIcHeader() != null) {
    icSectionHeaderEntity.setRuleId(meta.getLastIcHeader().getRuleId());
    icSectionHeaderEntity.setTriggerRule(meta.getLastIcHeader().getTriggerRule());
} else if (meta.getCurrentTriggerConfig() != null) {
    icSectionHeaderEntity.setRuleId(meta.getCurrentTriggerConfig().getId().longValue());
    icSectionHeaderEntity.setTriggerRule(meta.getCurrentTriggerConfig().getRuleName());
}
```

## Post-Merge Test Plan
- Command: `gradle :expand:business-freightlist-summary:compileJava`
- Owner: LiangWB
- Timing: 合并后立即执行

## Track B Declaration
Worktree 内 gradle 因 JGit/versioning 插件 NoHeadException 无法执行编译/测试。
