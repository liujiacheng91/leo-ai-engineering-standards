# Test.md

## Test Scope

`IcTriggerConfigServiceImpl` 中 `matchDestinationCountry`、`matchCountryConfig`、`getCountryFromParties` 三个方法的正确性，以及 `matchOriginCountry` 重构后行为不变。

## Mock Strategy

- Mockito strict stubs
- `IIcTriggerCountryConfigService.list(wrapper)` mock 返回不同配置列表
- `IMdAutoProgramPartiesService.list(wrapper)` mock 返回不同 parties 列表
- `IcTransMetaItem` mock `getKeyShipment()` 返回 `ShipmentHeaderEntity`

## Test Matrix

| Case ID | Description | Input | Expected | Related AC |
|---|---|---|---|---|
| TC-01 | destination_country=* 通配符匹配 | configValue="*" | return true | AC-1 |
| TC-02 | DST 国家配置列表为空 | countryType=DST, configList=empty | return false + triggerLog | AC-2, AC-3 |
| TC-03 | keyShipment 为空 | keyShipment=null | return false + triggerLog | AC-4 |
| TC-04 | shDestination 为空 | shDestination=null | return false + triggerLog | AC-4 |
| TC-05 | parties 查询返回空 | parties=empty | return false + triggerLog | AC-5, AC-6 |
| TC-06 | country 匹配成功 | country=HK, configList=[HK] | return true | AC-5, AC-6 |
| TC-07 | country 不匹配 | country=HK, configList=[SG,US] | return false + triggerLog | AC-6 |
| TC-08 | matchRule 传入 config.getId() | matchRule 调用链 | matchDestinationCountry 收到 configId | AC-7 |
| TC-09 | matchOriginCountry 委托 matchCountryConfig(ORG) | originCountry 场景 | 行为与重构前一致 | AC-8 |
| TC-10 | matchDestinationCountry 委托 matchCountryConfig(DST) | destinationCountry 场景 | 使用 DST countryType | AC-8 |
| TC-11 | getCountryFromParties 接受 partyId 参数 | partyId=shDestination | 按 partyId 查询 parties | AC-9 |
| TC-12 | 多条国家配置，匹配第二条 | configList=[SG,HK], country=HK | return true | AC-6 |

## Boundary Cases

- configId 为 null 时 ruleId 传 null（不 NPE）
- parties 返回多条时取第一条
- configValue 非 * 且非空，但 configList 有数据且匹配

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| (none) | | | | |
