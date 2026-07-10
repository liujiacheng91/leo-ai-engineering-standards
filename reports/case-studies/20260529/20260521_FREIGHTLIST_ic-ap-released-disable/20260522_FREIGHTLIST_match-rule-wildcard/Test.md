# Test - match-rule-wildcard

## Test Scope

IC 触发规则匹配方法中 `matchBizType`、`matchShipType`、`matchEntryMode` 的通配符 `*` 支持。

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | bizType 为 `*` | config.bizType=`*` | matchBizType 返回 true | AC-1 |
| 2 | shipType 为 `*` | config.shipType=`*` | matchShipType 返回 true | AC-2 |
| 3 | entryMode 为 `*` | config.entryMode=`*` | matchEntryMode 返回 true | AC-3 |
| 4 | bizType 为空 | config.bizType=null | matchBizType 返回 true | AC-4 |
| 5 | bizType 精确匹配 | config.bizType=`AIR`, shipment.bizType=`AIR` | matchBizType 返回 true | AC-5 |
| 6 | bizType 不匹配 | config.bizType=`AIR`, shipment.bizType=`OCN` | matchBizType 返回 false | AC-5 |
