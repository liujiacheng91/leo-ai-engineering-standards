# Task

| 字段 | 值 |
|---|---|
| Case ID | 20260513_FREIGHTLIST_ic-trans-offset-skip |
| 分支 | feat/ic-trans-offset-skip |
| Commit | 48008ae |

## 实现拆解

| # | 文件 | 改动描述 | 行号 |
|---|---|---|---|
| 1 | `node/ic/trans/Node3ChargeOffset.java` | 注释掉 `offsetHandle()` 调用和 `meta.setIcChargeOffsets(icChargeOffsets)` | L54-56 |
| 2 | `node/ic/trans/Node5Save.java` | 注释掉 `icChargeDetailOffsetService.saveBatch()` 整个 if 块 | L78-81 |

## 未改动（已有防护，无需修改）

- `Node4IcTransCalc.java`：`fillPendingIc`（L427-429）、`fillReceiverOsPS`（L387-388）、`fillReceiverOsIcSweep`（L318-319）三处均有 `if (icOffsetList != null && icOffsetList.size() > 0)` 判断

## Diff 摘要

```
Node3ChargeOffset.java（-2 行有效代码，+1 行注释说明）
  - List<IcChargeDetailOffsetEntity> icChargeOffsets = offsetHandle(...);
  - meta.setIcChargeOffsets(icChargeOffsets);
  + //流程简化：暂停 charge offset 生成，待后续评估是否恢复

Node5Save.java（-4 行有效代码，+1 行注释说明）
  - if (!CollectionUtils.isEmpty(meta.getIcChargeOffsets())) {
  -     icChargeDetailOffsetService.saveBatch(meta.getIcChargeOffsets());
  - }
  + //流程简化：charge offset 写库已暂停，待后续评估是否恢复
```
