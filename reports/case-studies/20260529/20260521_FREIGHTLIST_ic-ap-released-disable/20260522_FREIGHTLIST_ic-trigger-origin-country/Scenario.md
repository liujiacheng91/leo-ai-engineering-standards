# Scenario.md

## Case ID
20260522_FREIGHTLIST_ic-trigger-origin-country

## Background
IC 触发规则匹配方法 `matchRule` 中的 `matchOriginCountry` 当前是 `//todo` 桩方法（固定返回 true）。需要按业务规则补充 origin_country 维度的匹配逻辑。

## Requirements

当 IC 触发规则配置中的 `origin_country` 字段需要校验时，按以下逻辑匹配：

1. `origin_country` 为 `*` 时，通配匹配所有，返回 true
2. 否则按 `ic_trigger_config.id = ic_trigger_country_config.rule_id`、`ic_trigger_country_config.country_type = 'ORG'`、`ic_trigger_country_config.deleted = 0` 查找国家配置列表
3. 国家配置列表为空，返回 false
4. 国家配置列表不为空，获取 origin 的 country：
   - 按 `keyShipment.shOrigin = md_auto_program_parties.md_app_party_id` 且 `keyShipment.shJobDate >= md_auto_program_parties.md_app_join_date` 查找 parties 列表
   - 取第一行的 `md_app_country` 即为 origin_country
5. origin_country 为空则返回 false
6. 遍历国家配置列表，origin_country 在列表中则返回 true；全部不匹配则返回 false

## Assumptions

- `IcTriggerCountryConfigEntity` / `MdAutoProgramPartiesEntity` 的 entity / mapper / service 已创建就绪
- `ShipmentHeaderEntity.shJobDate` 字段已在外部 jar（`business-shipment-header:1.0.5`）中可用
- 用户描述的 `station_type` 对应实体字段为 `countryType`（映射 DB 列 `country_type`）
- `IMdAutoProgramPartiesService` 已注入到 `IcTriggerConfigServiceImpl`
- `IIcTriggerCountryConfigService` 尚未注入，需要新增

## Acceptance Criteria

- AC-1: 当 `ic_trigger_config.origin_country = '*'` 时，`matchOriginCountry` 返回 true
- AC-2: 当无对应 ORG 类型的 `ic_trigger_country_config` 记录时，返回 false
- AC-3: 当 `md_auto_program_parties` 中未找到匹配的 party 时，返回 false
- AC-4: 当找到 party 但其 `md_app_country` 为空时，返回 false
- AC-5: 当 party 的 `md_app_country` 在国家配置列表中时，返回 true
- AC-6: 当 party 的 `md_app_country` 不在国家配置列表中时，返回 false
- AC-7: 触发日志正确记录匹配过程

## Scope

- 改动文件: `IcTriggerConfigServiceImpl.java`（1 个文件）
- 不动: `matchDestinationCountry`（留 todo，后续单独 case）
