# Test Design - 20260521_FREIGHTLIST_ic-trigger-match-fields

## Test Scope

5 个 matchRule 字段匹配方法的逻辑正确性验证。

## Mock Strategy

- Mockito strict stubs
- Mock `IcTransMetaItem`、`ShipmentHeaderEntity`、`FlAggregationSectionHeaderEntity`、`IcTriggerLogEntity`
- 注意 `anyInt()` / `anyLong()` 不匹配 null，primitive wrapper 用 `nullable(Integer.class)` 或 `isNull()`

## Test Matrix

| # | Case | Method | Input | Expected | Related AC |
|---|---|---|---|---|---|
| 1 | stage 相等 | matchStage | shipmentStage=1, config.stage=1 | true | AC-1 |
| 2 | stage 不等 | matchStage | shipmentStage=1, config.stage=2 | false + log | AC-1 |
| 3 | stage keyShipment 为空 | matchStage | keyShipment=null | false + log | AC-1 |
| 4 | stage 双方均为 null | matchStage | shipmentStage=null, stage=null | true | AC-1 |
| 5 | bizType 配置为空 | matchBizType | config.bizType=null | true | AC-2 |
| 6 | bizType 相等 | matchBizType | shBizType="AIR", config="AIR" | true | AC-2 |
| 7 | bizType 不等 | matchBizType | shBizType="AIR", config="OCEAN" | false + log | AC-2 |
| 8 | bizType keyShipment 为空 | matchBizType | keyShipment=null, config="AIR" | false + log | AC-2 |
| 9 | shipType 配置为空 | matchShipType | config.shipType="" | true | AC-3 |
| 10 | shipType 相等 | matchShipType | shShipType="FCL", config="FCL" | true | AC-3 |
| 11 | shipType 不等 | matchShipType | shShipType="FCL", config="LCL" | false + log | AC-3 |
| 12 | entryMode 配置为空 | matchEntryMode | config.entryMode=null | true | AC-4 |
| 13 | entryMode 相等 | matchEntryMode | shEntryMode="SINGLE", config="SINGLE" | true | AC-4 |
| 14 | entryMode 不等 | matchEntryMode | shEntryMode="SINGLE", config="MULTIPLE" | false + log | AC-4 |
| 15 | psCutoffDate 配置为空 | matchPsCutoffDate | psCutoffDate=null | true | AC-5 |
| 16 | ETD >= cutoff | matchPsCutoffDate | flAshEtd=2026-06-01, cutoff=2026-05-01 | true | AC-5 |
| 17 | ETD == cutoff | matchPsCutoffDate | flAshEtd=2026-05-01, cutoff=2026-05-01 | true | AC-5 |
| 18 | ETD < cutoff | matchPsCutoffDate | flAshEtd=2026-04-01, cutoff=2026-05-01 | false + log | AC-5 |
| 19 | flSectionHeader 为空 | matchPsCutoffDate | flSectionHeader=null, cutoff=2026-05-01 | false + log | AC-5 |
| 20 | flAshEtd 为空 | matchPsCutoffDate | flAshEtd=null, cutoff=2026-05-01 | false + log | AC-5 |

## Boundary Cases

- stage: Integer 的 null 对比（双方都 null = true，一方 null = false）
- psCutoffDate: 边界等值（ETD == cutoff 应返回 true，用 `!isBefore` 实现 >=）
- String 类型字段: 空字符串 / blank 字符串视为"配置为空"

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| - | - | - | - | - |
