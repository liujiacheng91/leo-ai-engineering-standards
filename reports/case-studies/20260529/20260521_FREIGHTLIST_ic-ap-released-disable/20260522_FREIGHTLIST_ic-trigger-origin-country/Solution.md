# Solution.md

## Case ID
20260522_FREIGHTLIST_ic-trigger-origin-country

## Technical Constraints

- Java 21
- `ShipmentHeaderEntity.getShJobDate()` 来自外部 jar `business-shipment-header:1.0.5`（`@Data` 生成 getter）
- `IcTriggerCountryConfigEntity.countryType` 映射 DB 列 `country_type`（用户描述为 `station_type`，以实体为准）
- `IcTriggerCountryConfigEntity.ruleId` 类型 `Long`，`IcTriggerConfigEntity.id` 类型 `Integer`，查询时需类型转换
- Worktree 构建受 JGit / versioning 插件限制（Track B）

## Post-Merge Test Plan

- Command: `gradle :expand:business-freightlist-summary:test`
- Owner: Liangwb
- Timing: 合并后立即执行

## Recommended Solution

### Execution Mode: Mode 1 (LL-only)

### 改动范围

仅修改 `IcTriggerConfigServiceImpl.java`：

1. **新增依赖注入**: 构造器添加 `IIcTriggerCountryConfigService` 参数
2. **修改 `matchOriginCountry` 签名**: 增加 `Integer configId` 参数
3. **更新 `matchRule` 调用点**: 传入 `config.getId()`
4. **实现 `matchOriginCountry` 方法体**: 按用户 6 步逻辑
5. **抽取 `getOriginCountryFromParties` 私有方法**: 封装 parties 查询逻辑

### 匹配逻辑流程

```
origin_country == "*" --> return true
    |
    v (非通配)
查询 ic_trigger_country_config (rule_id, country_type='ORG', deleted=0)
    |
    v
列表为空 --> return false
    |
    v (列表不为空)
查询 md_auto_program_parties (party_id=shOrigin, join_date<=shJobDate)
    |
    v
取第一行 md_app_country
    |
    v
country为空 --> return false
    |
    v
遍历 country config 列表匹配 --> true/false
```

### 不改动项

- `matchDestinationCountry` 保持 `//todo` 桩（后续单独 case）
- 不引入缓存（当前触发频率 IC_TRANS 每天 2 次，DB 直查可接受）
- 不改其他 match 方法
