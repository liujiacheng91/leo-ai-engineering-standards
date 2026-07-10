# Test - 20260521_FREIGHTLIST_ic-trigger-match-origin

## Test Scope

matchOrigin 方法的 5 个业务场景验证。

## Mock Strategy

- Mockito strict stubs（默认）
- Mock `IIcTriggerStationConfigService.list(wrapper)` 返回预设站点列表
- Mock `IcTransMetaItem` 及其 `getKeyShipment()` / `getTriggerLog()`

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | origin 为 * | origin="*" | return true | AC-1 |
| 2 | ORG 站点列表为空 | origin="HKG", DB 无 ORG 记录 | return false | AC-3 |
| 3 | ORG 站点列表有匹配 | origin="HKG", DB 有 station="HKG" | return true | AC-4 |
| 4 | ORG 站点列表无匹配 | origin="HKG", DB 有 station="SIN" | return false | AC-5 |
| 5 | shOrigin 为 null | keyShipment.shOrigin=null | return false | AC-5 |
| 6 | configId 为 null | configId=null | 查询执行不抛异常 | AC-2/AC-3 |

## Boundary Cases

- origin = null（不是 *，走 DB 查询路径）
- stationConfigList 返回 null vs 空 list
- keyShipment 为 null

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| (none) | | | | |
