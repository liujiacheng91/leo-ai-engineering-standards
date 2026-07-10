# Solution - 20260521_FREIGHTLIST_ic-trigger-match-origin

## Technical Constraints

- Java 21
- IcTriggerConfigEntity.id: Integer; IcTriggerStationConfigEntity.ruleId: Long
- 构造器注入 IIcTriggerStationConfigService（不用字段注入）
- LambdaQueryWrapper 查询 ic_trigger_station_config
- appendTriggerLog(meta, remark) 记录不匹配原因
- keyShipment 通过 meta.getKeyShipment() 获取，shOrigin 通过 getShOrigin() 获取

## Recommended Solution

Mode 1 单文件改动：

1. IcTriggerConfigServiceImpl 构造器新增 IIcTriggerStationConfigService 参数
2. matchOrigin 方法签名改为 `matchOrigin(IcTransMetaItem meta, String origin, Integer configId)`
3. matchRule 调用点传入 config.getId()
4. matchOrigin 实现逻辑：
   - origin 为 `*` 则返回 true
   - 否则用 LambdaQueryWrapper 查 station config（ruleId = configId.longValue(), stationType = "ORG", deleted = 0）
   - 列表为空返回 false + log
   - 遍历列表，keyShipment.shOrigin 匹配任一 station 返回 true
   - 都不匹配返回 false + log

## Track B Declaration

Worktree 构建不可行（JGit / net.nemerosa.versioning 插件与 git worktree 不兼容）。

### Post-Merge Test Plan

- Command: `gradle :expand:business-freightlist-summary:compileJava`
- Owner: Liangwb
- Timing: 合并到 develop_1.1.0 后立即执行
