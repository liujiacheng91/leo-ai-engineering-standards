# Solution.md

## Solution Overview

在 `Node2IcTransCalc.createIcTrans` 方法中，`ext == null && shipmentDetail == null` 时增加 else 分支，从 `meta.getShipmentDetailList()` 取第一个元素的 `sdSourceSystem` 作为 systemType 兜底值。

## Technical Constraints

| Constraint | Verification | Conclusion |
|---|---|---|
| Java level | build.gradle sourceCompatibility | Java 21 |
| Key entity fields | IcTransactionEntity.systemType (Integer) | `@TableField("system_type")` line 352 |
| ShipmentDetailEntity.sdSourceSystem | entity source | `@TableField("sd_source_system")` Integer type, line 311 |
| Worktree build | JGit/versioning known issue | Not viable -- Track B |

### Post-Merge Test Plan (Track B Declaration)

- Command: `gradle :expand:business-freightlist-summary:compileJava`
- Owner: Liangwb
- Timing: merge to develop_1.1.0 after

## Impact Analysis

### Affected Files

- `node/ic/v2/Node2IcTransCalc.java` -- createIcTrans 方法增加 else 兜底

### Affected Database Objects

- `ic_transaction.system_type` -- 原本可能为 null 的记录将被填充
- `ic_transaction_change.system_type` -- 通过 BeanUtils.copyProperties 同步

## Recommended Solution

在 `Node2IcTransCalc.java:785-788` 的 `else if` 之后增加 `else` 分支：

```java
} else {
    // ext和shipmentDetail都为空时，从shipmentDetailList中取第一个可用的systemType兜底
    if (meta.getShipmentDetailList() != null && meta.getShipmentDetailList().size() > 0) {
        entity.setSystemType(meta.getShipmentDetailList().get(0).getSdSourceSystem());
    }
}
```

## Rollback Plan

删除新增的 else 分支即可恢复原逻辑。
