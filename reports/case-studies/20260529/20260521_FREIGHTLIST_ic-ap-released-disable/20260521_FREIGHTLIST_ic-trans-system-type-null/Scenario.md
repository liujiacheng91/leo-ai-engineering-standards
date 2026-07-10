# Scenario.md

## Scenario Name

IC Transaction systemType 空值兜底

## Business Background

IC v2 链 Node2IcTransCalc 在 `createIcTrans` 方法中构建 `IcTransactionEntity` 时，`systemType` 字段的取值依赖两个来源：`ShipmentDetailEntity.sdSourceSystem`（按 station 匹配）和 `FlAggregationSectionHeaderExtEntity.flAsheSourceSystem`（按 station + agentType 匹配）。

## Current Problem

当某个 station 在 `meta.getShipmentDetailList()` 中无匹配项（`getShipmentDetail` 返回 null）、同时在 `meta.getSectionHeaderExtList()` 中也无匹配项（`getSectionHeaderExt` 返回 null）时，`entity.setSystemType(...)` 不会被执行，导致 `ic_transaction.system_type` 落库为 null。

代码路径（`Node2IcTransCalc.java:748-788`）：
- 748: `shipmentDetail = getShipmentDetail(station, meta)` -- 按 station 匹配
- 749-753: shipmentDetail != null 时设置 systemType
- 781: `ext = getSectionHeaderExt(meta, station, agentType)` -- 按 station + agentType 匹配
- 782-784: ext != null 时覆盖 systemType
- 785-787: ext == null 但 shipmentDetail != null 时从 shipmentDetail 取
- **缺失**：ext == null 且 shipmentDetail == null 时无兜底

## Expected Outcome

`ic_transaction.system_type` 在所有情况下都不为 null。当 station 精确匹配无结果时，从 `meta.getShipmentDetailList()` 中取第一个可用的 `sdSourceSystem` 兜底。

## In Scope

- `Node2IcTransCalc.createIcTrans` 方法的 systemType 兜底逻辑

## Out of Scope

- Node3IcTransFinalCalc（从 IcTransactionEntity 复制 systemType，上游修好即可）
- ShipmentDetail 数据本身为何不匹配（上游数据问题，不在本 case 范围）

## Acceptance Criteria

| AC ID | Acceptance Criteria | Verification Method |
|---|---|---|
| AC-001 | 当 ext 和 shipmentDetail 都为 null 时，systemType 从 shipmentDetailList 第一个元素取值 | 静态代码分析 |
| AC-002 | 当 shipmentDetailList 也为空时，systemType 保持 null（不引入错误默认值） | 静态代码分析 |
| AC-003 | 原有 ext / shipmentDetail 非 null 路径的 systemType 赋值逻辑不变 | 代码 diff 验证 |

## Suggested Risk Level

```text
Yellow
```
