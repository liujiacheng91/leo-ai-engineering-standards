# Task.md

## Tasks

| ID | Description | Status |
|---|---|---|
| T1 | `matchRule` 中 `matchDestinationCountry` 调用增加 `config.getId()` 参数 | Done |
| T2 | 抽取 `getCountryFromParties(keyShipment, partyId)` 替代 `getOriginCountryFromParties` | Done |
| T3 | 抽取 `matchCountryConfig` 通用方法 | Done |
| T4 | `matchOriginCountry` 改为调用 `matchCountryConfig` | Done |
| T5 | `matchDestinationCountry` 从 todo 桩替换为调用 `matchCountryConfig` | Done |
