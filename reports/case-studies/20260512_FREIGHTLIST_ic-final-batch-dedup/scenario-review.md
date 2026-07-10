# 需求评审意见 - 20260512_FREIGHTLIST_ic-final-batch-dedup

## 整体评估

**通过** —— 草案 Scenario.md 在业务定位、改动范围、AC、范围边界、已知问题、风险初判方面均清晰自洽，与 AI_Request.md 完全对齐；用户已明确接受 D3「仅覆盖同批次重复」的残余风险边界，无需再扩张。

## 具体反馈

### must-fix（无）

本次评审未识别任何必须修改的阻塞性问题。

### should-consider（建议性，RA 可选择是否吸纳）

- **[Scenario.md §异常 / 行为约定 L55-56]**：去重后 metaItems 为空时的描述"`IcTransFinalMeta(Collections.emptyList())` 传入 dispatch"措辞偏向实现细节。当前 `start()` 第 56 行用的是 `new ArrayList<>()`，去重后理论上仍会得到一个空 List（不是必然为 `Collections.emptyList()`）。建议把这一行的描述弱化为"去重后 metaItems 若为空，则以空 List 传入 `dispatch`，链路按现有空 List 处理逻辑运行"，避免后续开发被字面引导到非必要的 `Collections.emptyList()` 调用。属于措辞细化，不影响 AC。

- **[Scenario.md §待澄清 L90 Q1]**：评审已替 RA 完成 Q1 的代码佐证（见下方"已验证项"），结论为"无遗漏"，可在 RA(finalize) 时把 Q1 直接关闭并并入"已确认前置条件"段，无需再回到用户确认。建议措辞：`D6 | (globalInterlink, version) 在 IC_TRANS_FINAL 业务链上下游（IcTransactionFinalEntity / IcTransactionEntity / IcSectionHeaderEntity 三张表的查询键）等价于"同一锁账周期的同一票货"，无更细粒度区分维度 | TA(review) 代码佐证`。

- **[Scenario.md §影响范围 L68]**：建议补一句"代码改动**不引入新依赖** / **不修改构造器签名**"，让影响面更显式（与 AC_Request.md 的"最小改动"基调对齐）。这是 nice-to-have，不影响通过。

- **[Scenario.md §已知问题 L86 `startSingle`]**：草案说"该方法走调试路径，每次只有 1 条 metaItem，天然无重复"。**已 grep 确认**：`startSingle` 唯一调用点是 `IcTransactionController.singleFinal`（L57），是 `@RestController` 暴露的本地调试接口，且本就只接受单个 `InterComTransFinalEvent`。判断成立，无需改动。此条仅作记录，不构成 must-fix。

- **[Scenario.md §影响范围 §代码 L68]**："约 5-10 行增量代码"建议改成"约 5-8 行"，与"LinkedHashMap + merge 函数 (a, b) -> a"这种紧凑实现一致；若 RA 倾向于保守估计也可保留。完全是个人偏好，可不动。

### 关于 RA Q1 的代码层结论（替 RA 闭环）

RA 留 Q1 让 TA 复核"同 globalInterlink + version 但属于不同锁账周期的情况是否存在"。经实际工具验证：

| 验证项 | 结论 |
|---|---|
| `InterComTransFinalEvent` 字段集 | 仅 `globalInterlink` + `version` 两个字段（event/InterComTransFinalEvent.java L17-23） |
| `IcTransactionEntity.version` 字段语义 | `Long`，注释为"时间戳(version)"（entity/IcTransactionEntity.java L55-60）—— version 字段本身**就是**用来标识锁账周期 / 业务版本的维度 |
| `Node1FinalTrigger` 业务键 | 三张表（`IcTransactionFinalEntity` / `IcTransactionEntity` / `IcSectionHeaderEntity`）全部以 `(globalInterlink, version)` 作为查询条件（Node1FinalTrigger.java L126-156）|
| `architecture.md` Kafka schema 表 | 明确标注 IC_TRANS_FINAL 消息**无 mvTs**（架构文档 L37） |

**结论**：`(globalInterlink, version)` 在 IC_TRANS_FINAL 业务链上下游全部位置等价于"同一锁账周期的同一票货"。不存在"同 globalInterlink + version 但分属不同锁账周期"的情况——这个判断成立的依据是：`version` 字段就是"锁账周期 / 业务版本"的唯一维度，没有"在 version 之上还有更高维度的锁账周期"这种东西。**Q1 闭环，无新发现待澄清问题**。

## 各评审要点逐条核查

### 1. 业务正确性

✅ 通过。去重键 `(globalInterLink, version)` 在 IC_TRANS_FINAL 业务上完整（见上方 Q1 闭环表）；保留先到的 metaItem（FIFO）与 `LinkedHashMap` + `(a, b) -> a` 的实现一致，无歧义；不会误伤合法的不同业务对象。

### 2. 范围边界合理性

✅ 通过。D1~D5 全部可落地：

- D1（仅 `start(...)`）：✅ 调用面已确认（`startSingle` 走 HTTP 调试，天然单条；`start` 是 Kafka 主入口）
- D2（去重键 + FIFO）：✅ 业务上完整
- D3（仅同 batch）：✅ **残余风险评估**：跨批次 / 并发消费 race 的实际生产概率取决于 Kafka 上游推送策略与消费者并发数。Node1FinalTrigger L60-93 的存在性检查（先查 `getIcTransactionFinalList` 再决定 continue）在跨批次场景下仍能挡住"第二批已落库后"的重复，但不能挡"两批几乎同时进入、第一批尚未落库"的窄窗口。**判断**：该窄窗口需要"同批次内 dedup（本 case 覆盖） + Node1 兜底（已有）"两层防线已经把同步链路上的可见重复降到极小概率，剩余的真正未防场景仅有"两个并发消费者实例同时拉到完全相同的消息"——这取决于 Kafka 消费者 group 配置是否允许同 partition 多消费者并发（标准 Kafka 语义不允许，本服务也未见 reactor / 多 consumer 配置）。**结论**：D3 边界合理，无需追加防护建议；用户已确认接受残余风险。
- D4（dispatch 前去重）：✅ 时机正确
- D5（不含 mvTs）：✅ 已代码佐证

### 3. AC 可验证性

✅ 通过。5 条 AC 均可用 Mockito 单元测试覆盖：

| AC | 测试设计 |
|---|---|
| AC-1 | 构造 batch 含 2 条同 key 事件 → mock `dispatch` 捕获 `IcTransFinalMeta` → 断言 `getIcTransFinalMetaItemList().size() == 1` |
| AC-2 | 同 AC-1 但事件数 ≥ 3 |
| AC-3 | 构造 batch 含 3 条不同 key 事件 → 断言去重后仍为 3 条且顺序保持 |
| AC-4 | 构造 batch 含 2 条同 key（payload 字段标记区分先后）→ 断言保留的是第一条（payload 与第一条事件一致）|
| AC-5 | 构造空 batch / 全部 buildMeta 失败的 batch → 断言 `dispatch` 仍被调用且传入空 List |

无遗漏，无冗余。AC-1 与 AC-2 略有重叠（都是同 key 重复），但 AC-2 显式覆盖 ≥ 3 条的退化情况，保留有意义。

### 4. 代码层影响面

✅ 通过。已 grep 验证：

- `IIcTransactionFinalService.start` 的唯一调用方是 `IcTransFinalListener.dispatch` L76（Kafka 主入口）
- `startSingle` 的唯一调用方是 `IcTransactionController.singleFinal` L57（本地调试，单条入）
- `start(...)` 内只动 metaItems 凑完后的一处，不会牵连构造器签名 / 字段定义 / 静态缓存 / 锁逻辑 / cnHkStationMap 等已有逻辑
- 不存在其他类似入链点

「仅动 1 个方法」判断成立，无遗漏。

### 5. Karpathy 4 原则

- **Think Before Coding**：✅ Scenario 列了 D1~D5 已确认前置条件与 Q1 待澄清项，假设充分暴露
- **Simplicity First**：✅ 严格遵守。`LinkedHashMap` + merge 函数是 Java 内建最简实现，没有引入 `@Transactional` / 唯一索引 / 分布式锁 / Node3 删后插 / @Async / 队列等更重方案。所有"不动"项在 §范围边界 L74-81 中明示
- **Surgical Changes**：✅ 改动锁定在 1 个方法的 1 个区段内，不顺手重构 cnHkStationMap 等无关逻辑
- **Goal-Driven Execution**：✅ 5 条 AC 对应明确的「目标 → 动作 → 验证方式 → 通过标准」，QA 可直接落地

## 阻塞问题

无。

## 通过条件

无（直接通过）。建议 RA 在 finalize 阶段可吸纳上述 should-consider 项（特别是 Q1 闭环，可省一次回环），但不强制。

## 已验证项

评审过程中实际 Read / Grep 过的代码与文档：

- `docs/ai/cases/20260512_FREIGHTLIST_ic-final-batch-dedup/AI_Request.md`
- `docs/ai/cases/20260512_FREIGHTLIST_ic-final-batch-dedup/Scenario.md`
- `docs/ai/cases/20260511_FREIGHTLIST_ic-final-shared-trans-no/Scenario.md`（L114-118 前置 case 已知问题段）
- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/impl/IcTransactionFinalServiceImpl.java`（完整方法体 L54-99）
- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/node/ic/transfinal/Node1FinalTrigger.java`（完整文件 L1-159，重点 L60-93、L125-156）
- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/meta/IcTransFinalMetaItem.java`（字段定义 L11-29）
- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/event/InterComTransFinalEvent.java`（消息 schema L12-23）
- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/listener/IcTransFinalListener.java`（dispatch 入口 L60-78）
- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/entity/IcTransactionEntity.java`（version 字段语义 L48-60）

Grep 覆盖：

- `startSingle` 调用方（6 处命中，全部确认归属：controller 调试入口 + service interface 声明 + impl 实现）
- `IIcTransactionFinalService` / `IcTransactionFinalServiceImpl` 引用面（全部归属确认）
- `IcTransFinalListener` / `InterComTransFinalEvent` 文件分布
- `IcTransactionEntity` 中 `version` 字段语义来源

## 风险等级

详见同目录 `AI_Risk_Level.md`。结论：🟡 **Yellow**，与 RA 初判一致，无需上调或下调。

---

Token usage: 由主 Claude 收尾时根据本次评审的实际消耗汇总到 `Token_Usage_Report.md`。
