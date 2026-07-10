# Solution.md - 20260521_FREIGHTLIST_ic-section-header-ic-type

## Technical Constraints

- Java 21
- MyBatis-Plus @TableField / @Schema 注解
- IcSectionHeaderEntity 已有完整字段模式（@Data + @TableName + @Schema）
- IcTransMetaItem.getIcType() 已可用（meta/IcTransMetaItem.java:30）
- Worktree 构建不可行（JGit / versioning 插件兼容性问题）

## Recommended Solution

Path B / Mode 1 / Yellow

3 处改动：

1. **IcSectionHeaderEntity.java** - 末尾新增 icType 字段（@TableField("ic_type") + @Schema）
2. **IcSectionHeaderMapper.xml** - BaseResultMap 加 result 映射 + Base_Column_List 加 ic_type
3. **Node1Trigger.java** - createIcSectionHeader() 在 setTransType 之后加 setIcType(meta.getIcType())

不需要改动的文件（已确认已有 icType）：
- InterComTransEvent.java（line 32）
- IcTransMetaItem.java（line 30）
- IcTransactionServiceImpl.buildMeta()（line 108）

## Track B Declaration

Worktree 内 gradle build / test 因 JGit / versioning 插件不兼容会抛 NoHeadException，激活 Track B 验证。

## Post-Merge Test Plan

| Item | Detail |
|---|---|
| Command | `gradle :expand:business-freightlist-summary:compileJava` |
| Owner | Liangwb |
| Timing | 合并到 develop_1.1.0 后第一时间 |
