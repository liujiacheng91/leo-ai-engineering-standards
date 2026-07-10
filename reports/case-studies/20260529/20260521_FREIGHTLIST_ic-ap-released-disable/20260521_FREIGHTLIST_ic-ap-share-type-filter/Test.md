# Test

## Case
20260521_FREIGHTLIST_ic-ap-share-type-filter

## Test Scope
isAllApChargeReleased 方法的 share_type=P 过滤逻辑

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | AP+P+Released | linkedCharges=[AP, shareType=P, status=Released] | return true | AC-1 |
| 2 | AP+P+NotReleased | linkedCharges=[AP, shareType=P, status=Open] | return false + triggerLog | AC-1 |
| 3 | AP+I+NotReleased | linkedCharges=[AP, shareType=I, status=Open] | return true (跳过非P) | AC-2 |
| 4 | AP+N+NotReleased | linkedCharges=[AP, shareType=N, status=Open] | return true (跳过非N) | AC-2 |
| 5 | 无AP+P费用 | linkedCharges=[AR, shareType=P] | return true | AC-3 |
| 6 | 空linkedCharges | linkedCharges=[] | return true | AC-3 |
| 7 | 混合 | [AP+P+Released, AP+I+Open, AP+P+Released] | return true | AC-1, AC-2 |
| 8 | 混合含未Released P | [AP+P+Released, AP+P+Open] | return false | AC-1 |

## Fix History
(无)
