# Test - ic-trans-stations-equal

## Test Scope
IcTransMetaItem.isStationsEqual 方法的新增 reportUploadStationConfigEntityList 判断逻辑.

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | station1==agentCode, station2==uploadStation | station1="A", station2="B", config(agentCode="A", uploadStation="B") | true | AC-1 |
| 2 | station2==agentCode, station1==uploadStation | station1="B", station2="A", config(agentCode="A", uploadStation="B") | true | AC-2 |
| 3 | 配置列表为 null | station1="A", station2="B", configList=null | 走 cnHkStationMap 逻辑 | AC-4 |
| 4 | 配置列表为空 | station1="A", station2="B", configList=[] | 走 cnHkStationMap 逻辑 | AC-4 |
| 5 | 配置列表有多条, 第二条匹配 | 第一条不匹配, 第二条匹配 | true | AC-5 |
| 6 | 配置列表全不匹配 | 无匹配项 | 继续走 cnHkStationMap | AC-3 |
| 7 | 直接相等优先于配置匹配 | station1==station2, 配置也匹配 | true(步骤2返回) | AC-3 |

## Notes
仓库无 src/test 结构, 以静态代码审查 + AC 追溯为主要验证手段.
