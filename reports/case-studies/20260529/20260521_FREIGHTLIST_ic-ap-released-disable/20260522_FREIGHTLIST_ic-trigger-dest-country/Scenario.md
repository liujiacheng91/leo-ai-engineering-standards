# Scenario.md

## Background

IC 触发规则 `matchRule` 包含 9 个匹配维度。前序 case 已实现 `matchOriginCountry`（countryType=ORG），本次补充 `matchDestinationCountry`（countryType=DST）并将两者抽取为通用方法。

## Acceptance Criteria

- AC-1: `destination_country="*"` 时返回 true
- AC-2: 按 `rule_id + countryType='DST' + deleted=0` 查询 `ic_trigger_country_config`
- AC-3: 配置列表为空返回 false
- AC-4: 获取 keyShipment 的 `shDestination`，为空返回 false
- AC-5: 按 `shDestination=mdAppPartyId, shJobDate>=mdAppJoinDate` 查 `md_auto_program_parties` 取第一行 `mdAppCountry`
- AC-6: country 为空返回 false；在列表中返回 true；不在返回 false
- AC-7: `matchRule` 调用传入 `config.getId()`
- AC-8: `matchOriginCountry` 和 `matchDestinationCountry` 共用同一个通用方法 `matchCountryConfig`
- AC-9: `getOriginCountryFromParties` 泛化为 `getCountryFromParties(ShipmentHeaderEntity, String partyId)`

## Assumptions

- `ShipmentHeaderEntity` 有 `getShDestination()` 方法（已在 `matchDestination` 方法中验证使用）
- destination 的 country 查询逻辑与 origin 完全一致，仅 partyId 来源和 countryType 不同
- 重构不改变 `matchOriginCountry` 的外部行为

## Risk Suggestion

Yellow：IC 触发规则 service 层改动，单文件重构
