# Scenario.md

## Background

IC 触发规则匹配（matchRule）在 IcTriggerConfigServiceImpl 中遍历 triggerConfigList，依次判断 9 个维度。前置 case（20260520_FREIGHTLIST_ic-trigger-rule-match）搭建了 matchRule 框架和 9 个 stub 方法，其中 5 个方法（matchStage / matchBizType / matchShipType / matchEntryMode / matchPsCutoffDate）目前为 `//todo return true` 占位。

## Current State

IcTriggerConfigServiceImpl.java 中 5 个方法均返回 true，导致规则匹配不生效（所有规则都通过）。

## Target State

5 个方法按业务规则实现字段比较逻辑，不匹配时记录 ic_trigger_log 并返回 false。

## Acceptance Criteria

- AC-1: matchStage -- keyShipment.shShipmentStage 与 config.stage 相等时返回 true，不相等时记 log 返回 false
- AC-2: matchBizType -- config.bizType 为空返回 true；keyShipment.shBizType 与 config.bizType 相等返回 true，不相等记 log 返回 false
- AC-3: matchShipType -- config.shipType 为空返回 true；keyShipment.shShipType 与 config.shipType 相等返回 true，不相等记 log 返回 false
- AC-4: matchEntryMode -- config.entryMode 为空返回 true；keyShipment.shEntryMode 与 config.entryMode 相等返回 true，不相等记 log 返回 false
- AC-5: matchPsCutoffDate -- config.psCutoffDate 为空返回 true；flSectionHeader.flAshEtd >= psCutoffDate 返回 true，不满足记 log 返回 false

## Assumptions

- keyShipment 和 flSectionHeader 在 matchRule 调用时已由上游节点填充到 IcTransMetaItem
- ShipmentHeaderEntity getter 命名：getShShipmentStage() / getShBizType() / getShShipType() / getShEntryMode()（已通过 Grep 确认）
- FlAggregationSectionHeaderEntity getter：getFlAshEtd()（已通过 Read 确认）
- appendTriggerLog(meta, remark) 可用于记录不匹配原因

## Scope

- 只改 IcTriggerConfigServiceImpl.java 中 5 个 match 方法
- 不动 matchRule 框架、其余 4 个 match 方法（matchOriginCountry / matchOrigin / matchDestinationCountry / matchDestination）、不动其他文件
