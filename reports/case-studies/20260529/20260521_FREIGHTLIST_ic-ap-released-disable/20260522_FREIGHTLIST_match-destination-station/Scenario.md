# Scenario - match-destination-station

## Background

IC 触发规则匹配（matchRule）目前已实现 origin 站点匹配逻辑（查 ic_trigger_station_config 表 station_type='ORG'），但 destination 字段的 matchDestination 方法仍是 stub（直接 return true）。

## Requirements

1. 补充 matchDestination 的具体逻辑，与 matchOrigin 对称，查询 station_type='DST' 的站点配置进行匹配
2. 将 origin 和 destination 的公共查询+匹配逻辑抽取为 matchStationConfig 方法

## Acceptance Criteria

- AC-1: 当 ic_trigger_config.destination 为通配符 * 时，matchDestination 返回 true
- AC-2: 当 ic_trigger_station_config 表中存在 station_type='DST' 且 station 与 keyShipment.shDestination 匹配的记录时，matchDestination 返回 true
- AC-3: 当无匹配的 DST 站点配置时，matchDestination 返回 false 并记录触发日志
- AC-4: matchOrigin 重构后行为不变，仍查 station_type='ORG' 匹配 keyShipment.shOrigin
- AC-5: matchStationConfig 作为公共方法被 matchOrigin 和 matchDestination 共用

## Assumptions

- ShipmentHeaderEntity 上 getShDestination() 方法可用（已通过代码验证）
- ic_trigger_station_config 表 station_type 字段值为 'ORG' 或 'DST'（已通过 entity 注释确认）
