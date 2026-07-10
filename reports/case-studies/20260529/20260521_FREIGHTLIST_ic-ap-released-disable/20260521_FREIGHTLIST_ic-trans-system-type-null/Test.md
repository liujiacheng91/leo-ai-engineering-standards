# Test Design - 20260521_FREIGHTLIST_ic-trans-system-type-null

## Test Scope

验证 `Node2IcTransCalc.createIcTrans()` 中 `systemType` 赋值逻辑的三个分支。

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | ext 不为空 | ext.flAsheSourceSystem=2 | systemType=2 | AC-1 |
| 2 | ext 为空, shipmentDetail 不为空 | shipmentDetail.sdSourceSystem=1 | systemType=1 | AC-1 |
| 3 | ext 和 shipmentDetail 都为空, keyShipment 存在 | keyShipment.shSourceSystem=1 | systemType=1 | AC-1, AC-2 |
| 4 | ext 和 shipmentDetail 都为空, keyShipment 为 null | - | systemType 保持 null（无兜底源） | AC-1 |
| 5 | Node3 final 复制 systemType | transaction.systemType=2 | finalEntity.systemType=2 | AC-3 |

## Mock Strategy

- 仓库无 src/test，本次为静态验证（代码走读 + Track B）
- Mockito strictness: N/A

## Boundary Cases

- keyShipment.shSourceSystem 本身为 null：systemType 赋值 null，与未设置等价，不引入错误默认值
- shipmentDetailList 为空但 keyShipment 存在：走 else 分支取 keyShipment

## Fix History

（无 Self-Fix）
