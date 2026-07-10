# Scenario - 20260521_FREIGHTLIST_ic-trigger-match-origin

## Background

IC v2 链 Node1Trigger 调用 IcTriggerConfigServiceImpl.matchRule 进行 9 维度触发规则匹配。matchOrigin 是其中一个维度，当前实现是 todo 占位（直接返回 true）。需要补充具体匹配逻辑，涉及关联查询 ic_trigger_station_config 表。

## User Requirements

1. 当 origin 为 `*` 时，返回 true（通配符，不限制出发站）
2. 否则根据 ic_trigger_config.id = ic_trigger_station_config.rule_id, ic_trigger_station_config.station_type = 'ORG', ic_trigger_station_config.deleted = 0 找到 station config 列表
3. 如果列表为空，返回 false
4. 如果列表不为空，遍历列表，keyShipment.sh_origin 等于任一 ic_trigger_station_config.station 则返回 true
5. 如果一条都不满足，返回 false

## Assumptions

- IcTriggerStationConfigEntity / IIcTriggerStationConfigService / IcTriggerStationConfigMapper 已存在
- matchOrigin 当前签名为 `matchOrigin(IcTransMetaItem meta, String origin)`，需要扩展传入 configId 用于关联查询
- IcTriggerConfigEntity.id 类型为 Integer，IcTriggerStationConfigEntity.ruleId 类型为 Long，需要类型转换
- 不匹配时调用 appendTriggerLog 记录日志，与其他 match 方法保持一致

## Acceptance Criteria

- AC-1: 当 origin 为 `*` 时，matchOrigin 返回 true
- AC-2: 当 origin 非 `*` 且 station config 列表为空时，返回 false 并记录 trigger log
- AC-3: 当 origin 非 `*` 且 keyShipment.shOrigin 匹配任一 station config 的 station 时，返回 true
- AC-4: 当 origin 非 `*` 且 keyShipment.shOrigin 不匹配任何 station config 时，返回 false 并记录 trigger log
- AC-5: matchOrigin 使用构造器注入 IIcTriggerStationConfigService，不使用字段注入

## Scope

- 改动文件：IcTriggerConfigServiceImpl.java（1 个文件）
- 不动：落库逻辑、DB schema、其他 match 方法、LiteFlow 链定义
