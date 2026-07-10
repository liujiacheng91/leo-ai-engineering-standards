# Task - 20260521_FREIGHTLIST_ic-trigger-match-origin

## Task Summary

补充 `IcTriggerConfigServiceImpl.matchOrigin` 方法的 origin 字段匹配逻辑，替换原有的 todo 占位实现。

## Implementation Steps

| # | Step | File | Status |
|---|---|---|---|
| 1 | 添加 IIcTriggerStationConfigService 依赖注入 | IcTriggerConfigServiceImpl.java | Done |
| 2 | 更新 matchRule 调用签名，传入 config.getId() | IcTriggerConfigServiceImpl.java | Done |
| 3 | 实现 matchOrigin 逻辑（通配符/DB查询/遍历匹配） | IcTriggerConfigServiceImpl.java | Done |

## Changes Detail

### IcTriggerConfigServiceImpl.java

1. **Import**: 新增 `IIcTriggerStationConfigService` 导入
2. **字段 + 构造器**: 添加 `icTriggerStationConfigService` final 字段，构造器注入（遵循仓库规约，不用 @Autowired）
3. **matchRule 调用**: `matchOrigin(meta, config.getOrigin())` -> `matchOrigin(meta, config.getOrigin(), config.getId())`
4. **matchOrigin 方法实现**:
   - origin 为 `*` 时返回 true
   - 否则通过 LambdaQueryWrapper 查询 `ic_trigger_station_config`（ruleId = configId, stationType = "ORG", deleted = 0）
   - 列表为空返回 false
   - 遍历列表，`keyShipment.shOrigin` 匹配任一 `station` 返回 true
   - 均不匹配返回 false
   - 不匹配路径记录 triggerLog

## Technical Notes

- `IcTriggerConfigEntity.id` 是 Integer，`IcTriggerStationConfigEntity.ruleId` 是 Long，查询时做 `configId.longValue()` 转换
- 空值检查沿用仓库风格：`list != null && list.size() > 0`
- 字符串比较用 `Objects.equals` 处理 null 安全

## Commit

- `76a0668` -- 补充 matchOrigin 触发规则匹配逻辑
