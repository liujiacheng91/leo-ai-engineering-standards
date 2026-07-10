# Solution

| 字段 | 值 |
|---|---|
| Case ID | 20260513_FREIGHTLIST_ic-trans-offset-skip |
| 风险等级 | 🟡 Yellow |
| 状态 | 待用户确认 |

## 1. 路径选型 / 技术背景

### 技术背景

IC_TRANS 链的 charge offset 数据流：
```
Node2（ic_charge_matching）
  → icCharges（含 offsetGroup 标记）
    → Node3（ic_charge_offset）
      → meta.icChargeOffsets（内存）
        → Node4（ic_trans_calc）读取：fillPendingIc / fillReceiverOsPS / fillReceiverOsIcSweep
        → Node5（ic_save）写入：ic_charge_detail_offset 表
```

关键约束：
- `ic_charge_detail_offset` 是 **write-only** 表（Mapper 无自定义 select 方法，无任何 DB 读取路径）
- Node4 三处 `meta.getIcChargeOffsets()` 调用均已有 `null/empty` 判断，offset 为 null 时安全返回 0
- Node5 写 offset 块已有 `CollectionUtils.isEmpty()` 保护，offset 为 null 时不执行 saveBatch

### 路径选型

选择**注释停用**而非删除代码：
- 符合用户要求"后续可能调整"，恢复成本极低（取消注释即可）
- 不改 LiteFlow 链定义（`bus_flow_chain` 表中 `ic_charge_offset` 节点保留），Node3 仍在链上，但执行后无副作用
- 不改 entity / mapper / service 层，结构完整

## 2. 改动方案

### 改动 A：Node3ChargeOffset.java

在 `processIml()` 中注释掉 offset 生成与 meta 设置：

```java
// 流程简化：暂停 charge offset 生成，待后续评估是否恢复
// List<IcChargeDetailOffsetEntity> icChargeOffsets = offsetHandle(meta.getIcCharges(), meta.getVersion());
// meta.setIcChargeOffsets(icChargeOffsets);
```

效果：`meta.getIcChargeOffsets()` 返回 null，Node4 三处计算结果为 0，Node5 写库块因 isEmpty 不执行。

### 改动 B：Node5Save.java

显式注释掉 offset 写库块（虽然 isEmpty 已隐式防止，但显式注释明确意图）：

```java
// 流程简化：charge offset 写库已暂停，待后续评估是否恢复
// if (!CollectionUtils.isEmpty(meta.getIcChargeOffsets())) {
//     //2.批量写入ic charge offset
//     icChargeDetailOffsetService.saveBatch(meta.getIcChargeOffsets());
// }
```

### 改动 C：Node4IcTransCalc.java

**无需改动**。三处 `meta.getIcChargeOffsets()` 调用已有防护：
- `fillPendingIc`：L427-429 已有 `if (icOffsetList != null && icOffsetList.size() > 0)`
- `fillReceiverOsPS`：L387-388 已有 `if (icOffsetList != null && icOffsetList.size() > 0)`
- `fillReceiverOsIcSweep`：L318-319 已有 `if (icOffsetList != null && icOffsetList.size() > 0)`

## 3. 业务影响

| 字段 | 变更前 | 变更后 |
|---|---|---|
| `pendingIc` | 未匹配 offset 记录的累计金额 | **固定为 0** |
| `ReceiverOsPS` 中 `pendingPsIc` | 未匹配 PS offset 的累计金额 | **固定为 0** |
| `ReceiverOsIcSweep` 中 `pendingNonPsIc` | 未匹配非 PS offset 的累计金额 | **固定为 0** |
| `ic_charge_detail_offset` 表 | 每次 IC trans 计算后写入 offset 记录 | **停止写入** |
| `icStatus` 逻辑 | 可能出现 OFFSET 状态 | OFFSET 状态不再触发（pendingIc 永远为 0） |

## 4. 回滚方案

取消 Node3 / Node5 的注释即可完全恢复原状，无 DB schema 变更，无数据迁移需求。

---

> **Yellow 风险：以上 Solution 需用户确认后才能开始实施代码改动。**
