# Test

| 字段 | 值 |
|---|---|
| Case ID | 20260513_FREIGHTLIST_ic-trans-offset-skip |

## Normal Cases

| # | 场景 | 前置条件 | 期望结果 |
|---|---|---|---|
| N-01 | IC trans 正常触发 | 有未匹配费用（offsetGroup 为空）的 icCharges | Node3 不生成 offset 记录；`meta.getIcChargeOffsets()` 为 null；`ic_charge_detail_offset` 表无新记录 |
| N-02 | IC trans 正常触发 | 所有 icCharges 都已匹配（offsetGroup 不为空） | 同 N-01，Node3 之前本来也不生成 offset，行为不变 |
| N-03 | pendingIc 计算 | 任意 IC trans 触发 | `pendingIc` = 0（Node4 fillPendingIc 因 icOffsetList == null，跳过循环） |
| N-04 | ReceiverOsPS 计算 | 任意 IC trans 触发 | `pendingPsIc` 贡献为 0，`ReceiverOsPS = (t2.psAmount × -1) - interComPs` |
| N-05 | ReceiverOsIcSweep 计算 | 任意 IC trans 触发 | `pendingNonPsIc` 贡献为 0，`ReceiverOsIcSweep = (t2.totalIcSweep × -1) - postedNonPsIc` |
| N-06 | icStatus 判断 | pendingIc = 0，unpostIc > 0 | `icStatus` = POST（不再出现 OFFSET 状态） |
| N-07 | icStatus 判断 | pendingIc = 0，unpostIc = 0 | `icStatus` = BLANK |

## Boundary Cases

| # | 场景 | 期望结果 |
|---|---|---|
| B-01 | icCharges 为空列表 | Node3 本来也不生成 offset（offsetHandle 已处理空列表），行为无变化 |
| B-02 | metaList 为空 | Node3/Node5 各自已有 size>0 判断，直接跳过，无 NPE |
| B-03 | meta.getIcSectionHeader() == null | Node3/Node5 各自有 `continue`，跳过本条，无 NPE |

## Negative Cases

| # | 场景 | 期望结果 |
|---|---|---|
| NE-01 | `meta.getIcChargeOffsets()` 为 null 时 Node4 三处方法调用 | 无 NPE，`pendingIc`/`pendingPsIc`/`pendingNonPsIc` 均为 0 |
| NE-02 | `meta.getIcChargeOffsets()` 为 null 时 Node5 save 块 | `CollectionUtils.isEmpty(null)` 返回 true，saveBatch 已注释，`ic_charge_detail_offset` 表无写入 |

## Regression Cases

| # | 场景 | 期望结果 |
|---|---|---|
| R-01 | IC trans 其他字段（totalRevenue / totalCost / totalIcSweep / psAmount / postedIc / unpostIc） | 不受影响，逻辑未改动 |
| R-02 | ic_section_header / ic_charge_detail / ic_transaction / ic_transaction_change / ic_freight_list_report 写库 | 不受影响，Node5Save 其他 saveBatch 调用正常 |
| R-03 | FREIGHT_LIST 链（Node1~Node11） | 完全不受影响，两个改动文件仅在 IC_TRANS 链中 |
| R-04 | IC_TRANS_FINAL 链 | 完全不受影响，Node3/Node5 只属于 IC_TRANS 链 |
