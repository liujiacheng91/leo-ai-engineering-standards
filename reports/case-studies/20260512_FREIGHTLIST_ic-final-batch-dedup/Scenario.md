# Scenario：IC_TRANS_FINAL 链 batch 内按业务键去重

> case-id：20260512_FREIGHTLIST_ic-final-batch-dedup
> 阶段：RA(finalize)
> 关联前置 case：[20260511_FREIGHTLIST_ic-final-shared-trans-no](../20260511_FREIGHTLIST_ic-final-shared-trans-no/Scenario.md)（已知问题段 L114-118）
> 初步风险等级：🟡 Yellow（详见第"初步风险等级建议"段）

## 业务背景

IC_TRANS_FINAL 链处理 IC 交易终态数据：每条 `IcTransFinalMetaItem`（由 `(globalInterlink, version)` 唯一标识）走完 Node1FinalTrigger → Node2IcTransFinalCalc → Node3Save 三节点后，在 `ic_transaction_final` 等表落库，每笔 IC 交易固定产出 3 行（1H + 2D）。

case `20260511_FREIGHTLIST_ic-final-shared-trans-no` 落地后，用户在生产观察到同一笔 IC 交易出现 12 行（预期 6 行 = 2 组镜像对 × 3 行 H+P0005+OTH-PS）。定位结论：上游 Kafka 在**同一批次（batch）内**推送了两条 `(globalInterlink, version)` 相同的事件，`IcTransactionFinalServiceImpl.start()` 将两条事件各自 `buildMeta` 后均追加进 `metaItems`，链路以 `IcTransFinalMeta(metaItems)` 为上下文跑完整链，Node2 对重复 metaItem 各生成一组 3 行，Node3 各自落库，最终 6 行翻倍为 12 行。

Node1FinalTrigger 的存在性检查在"同批次全部 metaItem 先排 Node1 再走 Node2/Node3"的执行顺序下，无法阻断批内重复的第二条 metaItem，因为两条同时进入链时第一条尚未落库。

本 case 的定位和修复范围在前置 case Scenario.md L112-118 中已显式留记："建议另起 case 评估去重逻辑"。

## 现状描述

代码位置：`expand/business-freightlist-summary/.../service/impl/IcTransactionFinalServiceImpl.java:54-79`

`start()` 方法的当前流程：

1. 遍历 `batchEvents.getBatchEvents()`
2. 每条 `BusKafkaEvent` 反序列化为 `InterComTransFinalEvent`，调 `buildMeta(event)` 产出 `IcTransFinalMetaItem`
3. 非 null 的 metaItem 一律 `metaItems.add(...)`，**无任何去重逻辑**
4. `metaItems` 全量装入 `IcTransFinalMeta` 后调 `dispatch(...)` 启动链

当上游同 batch 内推送 2 条 `(globalInterlink, version)` 相同的事件，`metaItems` 中就会存在 2 条等价元素，链路对每条各跑一次完整的 Node2/Node3，产生重复落库。

## 新需求描述

在 `start()` 方法中，于 `metaItems` 凑完之后、`dispatch(...)` 调用之前，增加一段**批内去重**逻辑：

- 去重键：`(globalInterLink, version)`
- 保留策略：同 key 保留先到的 metaItem（FIFO，先进先保留）
- 实现约束：使用 `LinkedHashMap` + 合并策略 `(a, b) -> a` 保证插入顺序与保留语义一致
- 去重后的 metaItem 列表替换原 `metaItems`，再传入 `dispatch(...)`

本次改动仅限以上描述，**不涉及任何其他改动**（详见"范围边界"段）。

## 已确认前置条件

| 编号 | 决策内容 | 确认来源 |
|---|---|---|
| D1 | 改动范围仅限 `IcTransactionFinalServiceImpl.java` 的 `start(...)` 方法 | 用户（AI_Request.md） |
| D2 | 去重键为 `(globalInterLink, version)`，同 key 保留先到的 metaItem | 用户（AI_Request.md） |
| D3 | 仅覆盖"同一 Kafka batch 内含重复"这一时间窗口；跨批次/并发 race 不在范围内 | 用户（AI_Request.md） |
| D4 | 去重在 `metaItems` 凑完之后、`dispatch(...)` 调用之前执行 | 用户（AI_Request.md） |
| D5 | `InterComTransFinalEvent` 没有 `mvTs` 字段（与 IC_TRANS 链不同），去重键不含 mvTs | 架构文档（`architecture.md` Kafka schema 表） |
| D6 | `(globalInterlink, version)` 在 IC_TRANS_FINAL 业务链上下游（`IcTransactionFinalEntity` / `IcTransactionEntity` / `IcSectionHeaderEntity` 三张表的查询键）等价于"同一锁账周期的同一票货"，无更细粒度区分维度 | TA(review) 代码验证 |

## 异常 / 行为约定

- **buildMeta 异常**：当前已有 try/catch 包裹，异常时 `log.error` 并跳过该条，该条不进入 `metaItems`；去重逻辑在此之后执行，不影响此处行为。
- **去重后 metaItems 为空**：以空 List 传入 `dispatch`，链路按现有空 List 处理逻辑运行，行为与当前一致。
- **所有 key 唯一（无重复）**：去重逻辑退化为顺序保持，与当前行为等价，无额外副作用。

## 验收标准

- AC-1：当同一 Kafka batch 内含 2 条 `(globalInterlink, version)` 完全相同的事件时，`metaItems` 去重后只保留 1 条，链路仅对该 key 调用 Node2/Node3 一次，`ic_transaction_final` 表中该笔 IC 交易产出 6 行（而非 12 行）。
- AC-2：当同一 Kafka batch 内含 2 条以上 `(globalInterlink, version)` 相同的事件时，去重后同样只保留 1 条（保留最先出现的那条），落库行数不超出预期。
- AC-3：当同一 Kafka batch 内含多条 `(globalInterlink, version)` 互不相同的事件时，每条各自正常处理，去重逻辑不对它们产生任何影响（互不干扰）。
- AC-4：当同一 key 出现重复时，保留的是 batch 内最先出现（即 `batchEvents.getBatchEvents()` 中排序靠前）的那条 metaItem；后到的被丢弃。
- AC-5：去重后 `metaItems` 为空列表时，`dispatch(...)` 正常调用，链路不抛出异常。

## 影响范围

- **代码**：仅 `IcTransactionFinalServiceImpl.java` 的 `start(...)` 方法，1 个方法，约 5-8 行增量代码，不引入新依赖、不改构造器签名。
- **PDF 团队 / 下游账务**：本 case 不动任何 entity 字段、不改表结构；`ic_transaction_final` / `ic_transaction_final_change` / `ic_transaction_escalate` 的 schema 保持不变；对 PDF 团队透明。
- **其他链**：FREIGHT_LIST / IC_TRANS 链不受影响；`IcTransactionFinalServiceImpl` 以外的代码不变动。
- **事务**：不引入 `@Transactional`，当前无事务的现状保持不变。

## 范围边界

- 不动：Node1FinalTrigger / Node2IcTransFinalCalc / Node3Save 的实现
- 不动：`IcTransactionFinalEntity` / `IcTransactionFinalChangeEntity` 字段定义
- 不动：DB schema（不加唯一索引、不加 upsert）
- 不动：分布式锁 / `@Transactional`
- 不动：其他链（FREIGHT_LIST / IC_TRANS）
- 不解决：跨批次 / 并发消费 race 导致的重复（该场景由 Node1 现有存在性检查兜底；用户已接受此残余风险）
- 不解决：Node3Save 无 upsert 导致的跨批次重复落库问题（来自前置 case L114-118 的已知问题，后续视需要另立 case）

## 已知问题

- **残余重复风险（跨批次 / 并发）**：本 case 的去重窗口仅限同一 Kafka batch 内。若上游对同一 `(globalInterlink, version)` 分两次 batch 推送，或两个消费者实例并发消费，则本 case 的去重逻辑无效。此风险由 Node1 现有存在性检查兜底；用户已确认接受，后续视生产观察决定是否处理。
- **`startSingle` 方法未改**：该方法走调试路径（HTTP 单条入口），每次只有 1 条 metaItem，天然无重复，无需改动。

## 待澄清问题

无待澄清问题。

## 初步风险等级建议

🟡 **Yellow**

理由：
- 改动影响数据正确性（去重逻辑直接决定有多少条 metaItem 进入链路，进而影响落库行数）
- 仅改动 1 个 service 方法，不动 chain 节点、entity、schema、事务
- 不属于"共享果子算法"（Node5 ProfitShare 等），不属于唯一落库节点（Node11Save 等）
- 符合本仓库 Yellow 默认范围（service 层逻辑改动、影响数据正确性，但改动面最小化）

最终等级由 TA(review) 落 `AI_Risk_Level.md` 拍板。
