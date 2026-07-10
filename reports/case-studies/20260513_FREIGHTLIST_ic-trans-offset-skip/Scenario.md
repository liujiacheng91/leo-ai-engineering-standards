# Scenario

| 字段 | 值 |
|---|---|
| Case ID | 20260513_FREIGHTLIST_ic-trans-offset-skip |
| 状态 | finalized |

## 业务背景

IC_TRANS 链当前共 5 个节点。其中 `ic_charge_offset`（Node3）负责对"未匹配费用"生成反冲记录（`IcChargeDetailOffsetEntity`），并通过 `ic_save`（Node5）落到数据库 `ic_charge_detail_offset` 表。

业务方决定简化 IC trans 流程：**暂停 charge offset 数据的生成与持久化**。原因尚未记录在需求文档，但代码须保留（后续可能恢复）。

## 场景范围

- **包含**：Node3 停止往 meta 写 offset 数据；Node5 停止写 `ic_charge_detail_offset` 表
- **包含**：Node4 三处使用 offset 数据的计算方法需能安全处理 offset 为 null/空 的情形
- **不包含**：修改 LiteFlow 链定义（不从 `bus_flow_chain` 表移除 `ic_charge_offset`，Node3 仍挂在链上但成为无副作用节点）
- **不包含**：删除 entity / mapper / service / Node3 代码（全部保留）
- **不包含**：其他服务对 `ic_charge_detail_offset` 的读取（本服务内无 DB 读取，跨服务影响超出本 repo 范围）

## 假设

1. 业务方已知晓此变更将导致 `pendingIc` / `ReceiverOsPS` 中 `pendingPsIc` / `ReceiverOsIcSweep` 中 `pendingNonPsIc` 三个字段将固定为 0
2. `ic_charge_detail_offset` 表中的历史数据不需要清理
3. Node4 现有 null 检查（已确认存在）已足够防护，无需额外代码改动

## 待澄清

无（"工作不停"模式，按上述假设推进）
