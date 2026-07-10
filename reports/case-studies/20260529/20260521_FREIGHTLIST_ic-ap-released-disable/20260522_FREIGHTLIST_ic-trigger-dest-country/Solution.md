# Solution.md

## Technical Constraints

- Java 21
- 构造器注入（`IIcTriggerCountryConfigService` 和 `IMdAutoProgramPartiesService` 已注入）
- `ShipmentHeaderEntity`：`getShOrigin()` / `getShDestination()` / `getShJobDate()`
- `IcTriggerCountryConfigEntity`：`getRuleId(Long)` / `getCountryType()` / `getDeleted()` / `getCountry()`
- `MdAutoProgramPartiesEntity`：`getMdAppPartyId()` / `getMdAppJoinDate()` / `getMdAppCountry()`
- Worktree 构建不可行（JGit/versioning 兼容性），Track B

## Recommended Solution

1. 抽取 `matchCountryConfig(meta, countryValue, configId, countryType, partyId, dimensionName)` 通用方法
2. 抽取 `getCountryFromParties(keyShipment, partyId)` 通用方法（原 `getOriginCountryFromParties` 泛化）
3. `matchOriginCountry` 改为调用 `matchCountryConfig(..., "ORG", keyShipment.getShOrigin(), "originCountry")`
4. `matchDestinationCountry` 改为调用 `matchCountryConfig(..., "DST", keyShipment.getShDestination(), "destinationCountry")`
5. `matchRule` 中 `matchDestinationCountry` 调用增加 `config.getId()` 参数

## Post-Merge Test Plan

- Command: `gradle :expand:business-freightlist-summary:test`
- Owner: Liangwb
- Timing: 合并到 develop_1.1.0 后第一时间执行
