# Solution：IC_TRANS_FINAL 链 batch 内按业务键去重

> case-id：20260512_FREIGHTLIST_ic-final-batch-dedup
> 阶段：TA(architecture)
> 风险等级：🟡 Yellow（详见 `AI_Risk_Level.md`）—— 本 Solution 必须经用户人工确认后才能派开发
> 关联：`Scenario.md`、`scenario-review.md`、`AI_Risk_Level.md`

---

## 1. 路径选型（Selection Path）

### 1.1 候选实现方式对比

| 编号 | 候选方案 | 说明 | 取舍 |
|---|---|---|---|
| A | `Stream + Collectors.toMap(keyExtractor, identity, (a, b) -> a, LinkedHashMap::new)` | 一行 Stream，原子化 | ❌ 否决 —— 仓库现有代码风格偏显式 for（见 `IcTransactionFinalServiceImpl.start()` 自身就是显式 for），团队对 Stream 收敛去重的可读性偏低；且对 key 抽取的可调试性较弱 |
| B | 显式 for + `HashSet<String>` 记录已见 key，命中 `continue` | 显式、贴近仓库风格 | △ 备选 —— 可读性好，但与现有循环耦合（要把去重段塞进 `for (BusKafkaEvent ...)` 内部或紧随其后），增量结构稍乱 |
| C | **现有循环不动**，metaItems 凑完后再用一个独立循环 + `LinkedHashMap<String, IcTransFinalMetaItem>` 去重 | 显式、与 Scenario D4「dispatch 前去重」时机一致；改动是"追加段"而非"侵入段" | ✅ **选定** |
| D | 在 `buildMeta()` 内部判断 + 跳过 | 侵入 `buildMeta` 语义（让它"看上下文"） | ❌ 否决 —— 破坏 `buildMeta` 纯函数语义，未来更难单元测试；Scenario D1 也限定改动只在 `start()` 内部 |

### 1.2 选定方案：C —— 显式 for + LinkedHashMap

**理由**：

- **Simplicity First**：现有循环 L58-72 保持原样，新增段是"列表→去重 LinkedHashMap→回填列表"的紧凑三步，逻辑边界清晰
- **Surgical Changes**：所有改动落在 L72 与 L75 之间的一段插入，不动现有任何已写代码行
- **可读性**：与仓库已有显式 for 风格一致（参考 `IcTransactionFinalServiceImpl` 自身、`IcTransactionServiceImpl` 等同模式 service）
- **可测性**：去重逻辑独立成段，单测可针对"凑完 metaItems 之后的 list"形态注入测试输入
- `LinkedHashMap` + `putIfAbsent` 自然实现 FIFO 保留语义（AC-4），无需额外 merge 函数

### 1.3 明确拒绝的备选项

依据 Scenario `§范围边界` L74-81，以下方案在本 case 全部**拒绝**：

| 拒绝方案 | 拒绝理由 |
|---|---|
| Node3FinalSave 删后插（upsert） | 越界改链上节点；不属于"同批次去重"问题域，与本 case 目标错位 |
| DB 唯一索引 `(global_interlink, version)` | 涉及 DB schema，红线项；用户已明确不动 schema（AI_Request L43） |
| Redis / Caffeine 分布式锁 | 跨批次 / 并发 race 不在本 case 范围（用户已接受残余风险） |
| `@Transactional` 包裹 Node3FinalSave | 越界；本仓库无 `@Transactional` 是既有设计（架构文档"落库节点的事务边界"段），不属于本 case 修复范畴 |
| 修改 `InterComTransFinalEvent` schema 或加 `mvTs` | 跨服务影响（红线项），且与去重目标无关 |
| Stream 收敛 | 1.1 中已说明，风格不符 |

---

## 2. 技术背景（Technical Context）

### 2.1 `IcTransactionFinalServiceImpl.start()` 当前流程

```text
start(flowChain, batchEvents)                            L54
  │
  ├── metaItems = new ArrayList<>()                       L56
  │
  ├── if (batchEvents.getBatchEvents() != null && size>0) L58
  │     for (BusKafkaEvent kafkaEvent : batchEvents)      L59
  │       try { event = JsonUtils.fromJson(...)            L62
  │             metaItem = buildMeta(event)                L63
  │             if (metaItem != null)                       L65
  │                 metaItems.add(metaItem)                 L66
  │       } catch (Exception e) { log.error(...) }         L68-70
  │     end for                                            L71
  │   end if                                               L72
  │
  └── return dispatch(flowChain, new IcTransFinalMeta(metaItems))  L75
        .thenApply(response -> { setSuccessEvents; return; })       L76-78
```

### 2.2 去重插入点（精确到行号）

**插入位置**：L72（外层 `if` 结束）之后、L75（`return this.dispatch(...)`）之前的空行处。

逻辑边界：
- **前置**：`metaItems` 已经按 batch 顺序追加完毕，含异常跳过后的剩余 items
- **后置**：将去重后的 list 重新封装到 `new IcTransFinalMeta(...)` 传入 `dispatch`

### 2.3 `metaItems` 与下游 `IcTransFinalMeta(metaItems)` 的关系

- `IcTransFinalMeta` 仅 1 个字段 `List<IcTransFinalMetaItem> icTransFinalMetaItemList`，构造器原样接收 list 引用（见 `IcTransFinalMeta.java` L8-15）
- 链路所有节点（Node1FinalTrigger / Node2IcTransFinalCalc / Node3Save）通过 `meta.getIcTransFinalMetaItemList()` 取 list，**对 list 的具体实现类无依赖**（`ArrayList` / `Collections.unmodifiableList` / `Arrays.asList` 等都能正常迭代）
- **替换为去重后的 list 不会影响下游链行为**——只要保证：
  1. list 非 null（去重逻辑保证：用 `new ArrayList<>(dedupMap.values())` 即可）
  2. list 中 item 顺序保留（保留 batch 内首次出现顺序，由 `LinkedHashMap` 保证）
  3. item 内字段未被修改（去重只过滤、不修改 item 内容）

三条均成立，下游链对此 list 的处理与原 list 等价（仅元素数量可能少 → 节点循环次数随之少）。

### 2.4 `InterComTransFinalEvent` schema 复习

```java
public class InterComTransFinalEvent {
    private String globalInterlink;
    private Long version;
}
```

`IcTransFinalMetaItem` 的去重键字段：
- `String globalInterLink`（注意大小写：meta 用 `globalInterLink`，event 用 `globalInterlink`，已由 `buildMeta()` L95 完成映射）
- `Long version`

二者均允许为 null（理论上）。**去重 key 拼接时必须处理 null**，避免 `null` 与空字符串歧义；选 `String.valueOf(...)` 显式转换 + 不可能在业务字段中出现的分隔符 `"#"`（globalInterlink 是 shipment interlink，version 是时间戳数字，两者都不含 `#`）。

---

## 3. 具体实现方案

### 3.1 代码增量（约 7 行 + 1 行 import）

**插入位置**：`IcTransactionFinalServiceImpl.java` L72 后、L75 前。

```java
        // 批内按 (globalInterLink, version) 去重：同一 Kafka batch 内的重复事件只保留先到的一条
        // 残余的跨批次 / 并发重复由 Node1FinalTrigger 现有存在性检查兜底
        LinkedHashMap<String, IcTransFinalMetaItem> dedupMap = new LinkedHashMap<>();
        for (IcTransFinalMetaItem item : metaItems) {
            String dedupKey = item.getGlobalInterLink() + "#" + item.getVersion();
            dedupMap.putIfAbsent(dedupKey, item);
        }
        if (dedupMap.size() < metaItems.size()) {
            log.info("ic_trans_final batch dedup: before={}, after={}", metaItems.size(), dedupMap.size());
        }
        metaItems = new ArrayList<>(dedupMap.values());
```

**Import 说明**：`LinkedHashMap` 已被现有 `import java.util.*;`（L23）通配覆盖，**无需新增 import**。`ArrayList` 同理。

### 3.2 dedupKey 拼接策略说明

| 备选 | 优劣 | 选定 |
|---|---|---|
| `globalInterLink + "#" + version` | 字符串拼接，`null` 会被 `String + null` 转成字面值 `"null"`，与正常值无歧义（业务字段不会含字面 `"null"` 且 `#` 不在业务字符集中） | ✅ |
| `Pair<String, Long>` (commons-lang3) | 等价但需引入 Pair 类型；优势是显式语义 | ❌ 现有循环已无 Pair 引入，刻意引入提升不大 |
| Java 16 `record DedupKey(String, Long)` | 类型最严谨 | ❌ 项目工具链 Java 21 支持，但仅为 7 行代码引入新 record 类型不值得；Simplicity First |
| `Objects.hash(...)` 当 key | 哈希碰撞理论可能（虽极小） | ❌ 不正确 |

**选定 `String` 拼接**。`null` 处理上：业务上 `globalInterLink` 与 `version` 在 `buildMeta()` L95-96 是从 event 直接拷贝，二者若 event 侧为 null，则 meta 侧也是 null —— 但这种 metaItem 本身就是"脏数据"，dedupKey 即便冲撞（"null#null"）保留先到一条不会影响业务结果（原本就没有可处理的业务键）。

### 3.3 日志埋点策略（结合 AC-4 / Scenario "去重前后 size 变化"）

| 场景 | 是否记日志 | 级别 | 说明 |
|---|---|---|---|
| 去重前后 size 相等（无重复） | ❌ 不记 | — | 生产 batch 大多数情况下无重复，避免日志噪声 |
| 去重前后 size 不等（有命中） | ✅ 记 | `INFO` | 直接打印 `before=X, after=Y`，定位"哪一批触发了去重" |
| 出现异常（不会，因为只是 Map 操作） | — | — | 不需要 try/catch |

理由：
- **避免噪声**：Kafka 批次量大，每批都打日志会污染 ELK；只在命中时打更聚焦
- **可观测性达标**：命中时打一条 `INFO` 足以让运维通过日志统计"生产环境同批次重复率"
- AC-1 ~ AC-3 在去重命中场景下会触发该日志，QA 可直接断言 log 输出（可选）

### 3.4 完整方法体（合入后）

为了让用户一眼看清最终形态，这里给出合入后 `start()` 方法的完整代码（仅作为评审参考，开发以"增量段"为准）：

```java
@Override
public CompletableFuture<BusKafkaBatchEvent> start(BusLiteFlowMeta flowChain, BusKafkaBatchEvent batchEvents) {

    List<IcTransFinalMetaItem> metaItems = new ArrayList<>();

    if (batchEvents.getBatchEvents() != null && batchEvents.getBatchEvents().size() > 0) {
        for (BusKafkaEvent kafkaEvent : batchEvents.getBatchEvents()) {
            try {
                //log.info("开始处理 kafkaEvent: {}", kafkaEvent.getEvent());
                InterComTransFinalEvent event = JsonUtils.getInstance().fromJson(kafkaEvent.getEvent(), InterComTransFinalEvent.class);
                IcTransFinalMetaItem metaItem = buildMeta(event);

                if (metaItem != null) {
                    metaItems.add(metaItem);
                }
            } catch (Exception e) {
                log.error("json转 meta 失败", e);
            }
        }
    }

    // 批内按 (globalInterLink, version) 去重：同一 Kafka batch 内的重复事件只保留先到的一条
    // 残余的跨批次 / 并发重复由 Node1FinalTrigger 现有存在性检查兜底
    LinkedHashMap<String, IcTransFinalMetaItem> dedupMap = new LinkedHashMap<>();
    for (IcTransFinalMetaItem item : metaItems) {
        String dedupKey = item.getGlobalInterLink() + "#" + item.getVersion();
        dedupMap.putIfAbsent(dedupKey, item);
    }
    if (dedupMap.size() < metaItems.size()) {
        log.info("ic_trans_final batch dedup: before={}, after={}", metaItems.size(), dedupMap.size());
    }
    metaItems = new ArrayList<>(dedupMap.values());

    //启动 flow chain
    return this.dispatch(flowChain, new IcTransFinalMeta(metaItems)).thenApply(response -> {
        batchEvents.setSuccessEvents(batchEvents.getBatchEvents());
        return batchEvents;
    });

}
```

### 3.5 空 batch / 全部异常场景的行为确认

- **空 batch**（`batchEvents.getBatchEvents()` 为 null 或 size==0）：现有 L58 的 if 不进入，`metaItems` 保持空 `ArrayList<>`；去重段对空 list 跑空循环，`dedupMap.size() == metaItems.size() == 0` 不打 log；`metaItems = new ArrayList<>(dedupMap.values())` 仍为空 list。下游 `dispatch` 正常调用，传入含空 list 的 `IcTransFinalMeta` —— 行为与改动前一致（AC-5 满足）
- **全部 buildMeta 异常**（每条都 try/catch 跳过）：`metaItems` 为空 list，路径同上
- **dedupKey 拼接出现 `"null#null"`**（globalInterLink 与 version 都为 null）：第 1 条占位 putIfAbsent，第 2 条命中已存在跳过 —— 行为与"业务键合法时去重"完全一致，不会误伤合法数据

---

## 4. 影响分析

### 4.1 对 Node1FinalTrigger / Node2 / Node3 行为的影响

| 节点 | 影响 | 说明 |
|---|---|---|
| Node1FinalTrigger | **零影响** | 节点代码未改；输入 list 元素数量可能减少，节点循环次数随之减少（这正是修复目标） |
| Node2IcTransFinalCalc | **零影响** | 同上 |
| Node3Save | **零影响** | 同上 |

### 4.2 对 IC_TRANS_FINAL 链整体行为的影响

- chain DSL（`bus_flow_chain` 表 EL）：**未改**
- chainId（`IC_TRANS_FINAL_0.0.1`，硬编码在 `IcTransFinalListener.java:75`）：**未改**
- 节点 `@LiteflowComponent` 字符串值：**未改**
- 节点数字编号：**未改**
- 节点 `process()` 实现：**未改**
- 链尾落库表（`ic_transaction_final` / `ic_transaction_final_change` / `ic_transaction_escalate`）schema：**未改**

**唯一行为差异**：当上游同 batch 推送重复事件时，链路只会对该 key 跑一次 Node1→Node2→Node3，落库行数从"重复×3 行"恢复到"1×3 行"。这是修复目标本身，不构成"链行为改变"的副作用。

### 4.3 对其他链（FREIGHT_LIST / IC_TRANS）的影响

**零影响**。本次改动仅触及 `IcTransactionFinalServiceImpl` 单文件单方法：

| 其他链 | 验证 |
|---|---|
| FREIGHT_LIST | 入口 `DynamicFreightSummaryService`，与本文件无引用关系 |
| IC_TRANS | 入口 `IcTransactionServiceImpl`（同包不同类），与本文件无引用关系；scenario-review 已 grep 验证 |

### 4.4 对 PDF 团队 / 下游账务的影响

**零影响**：

- 不改任何 entity 字段
- 不改任何表 schema
- 不改任何字段语义
- 修复后 `ic_transaction_final` 行数从"错误的 12 行"回归到"正确的 6 行"——PDF 团队按业务逻辑读到的 IS 6 行本就是 PDF 报表期望的行数，反而是修复"错误数据"的正向影响

### 4.5 对 `startSingle()` 的影响

**零影响**：

- `startSingle()` 是 HTTP 调试入口（`IcTransactionController.singleFinal` L57），单条 `InterComTransFinalEvent` 入参，天然不存在 batch 内重复
- 本次改动只动 `start()`，`startSingle()` 代码未变
- 即使将来生产改用 `startSingle`（不会发生），单条输入也不触发去重路径，行为等价

---

## 5. 测试策略

### 5.1 单元测试切入点

**Mock 对象**：
- `BusEngineExecuteService busEngineExecuteService` —— mock 后捕获 `execute2Future` 的 `meta` 入参（核心断言点）
- `BusThreadConfigContext busThreadConfigContext` —— mock `getThreadMap()` 返回包含 `"FREIGHT_LIST"` 的 Map，value 用 `ThreadPoolExecutor` 的 mock 或 `Runnable::run` 同步执行器
- `BusLocalCaffeineService localCaffeineService` —— mock `getMap(...)` 返回空 Map（cnHkStationMap 与去重逻辑无关，给空即可）
- `IIcTriggerConfigService icTriggerConfigService` —— mock 返回任意；本路径不会调用

**核心断言**：通过 `ArgumentCaptor<IcTransFinalMeta>` 捕获 `dispatch` 内部传给 `execute2Future` 的 meta 对象，验证 `meta.getIcTransFinalMetaItemList()` 的 size 与内容顺序。

**测试类位置**：仓库当前**无 `src/test`**（见根 CLAUDE.md "构建与运行"段说明）。Task 阶段由开发决定：

- 选项 A：在 `expand/business-freightlist-summary/` 新建 `src/test/java/...` 目录与 `IcTransactionFinalServiceImplTest` 单测类（首个测试落地）
- 选项 B：仅以 `Verify.md` 手工验证场景表 + 日志快照为证据（仓库历史做法）

**TA 建议选项 A**：本 case Yellow 等级，去重逻辑值得首个落地的 Mockito 单测样例；同时为后续 service 层改造打开"可测"的基础设施。

### 5.2 AC-1 ~ AC-5 测试用例草图（断言点列举，不写完整代码）

| AC | 输入构造 | 关键断言点 |
|---|---|---|
| AC-1 | batch 含 2 条同 `(globalInterlink=I1, version=10)` 的事件 | `meta.getIcTransFinalMetaItemList().size() == 1`；该 item 的 globalInterLink/version 为 I1/10；`busEngineExecuteService.execute2Future(...)` 只被调用 1 次（去重不影响调用次数，仍是 1 次链调用） |
| AC-2 | batch 含 3 条同 key 事件（全部 `(I1, 10)`） | `meta.getIcTransFinalMetaItemList().size() == 1`；同 AC-1 |
| AC-3 | batch 含 3 条互不相同 key 事件 `(I1,10) / (I2,10) / (I1,20)` | size == 3；list 顺序为 I1-10, I2-10, I1-20（验证 `LinkedHashMap` 顺序保留） |
| AC-4 | batch 含 2 条同 key 事件，但通过 `JsonUtils.fromJson` mock 让两次 `buildMeta` 输出的 metaItem 在某非 key 字段上可区分（例如可比对引用 / 第二条特征值），验证保留的是**第一条** | 捕获 list 中唯一元素，验证它来自第一条事件（最直接的做法：用 spy 监控 `buildMeta` 返回值队列） |
| AC-5 | batch 为空 / batch 全部 `JsonUtils.fromJson` 抛异常 | `dispatch` 正常被调用 1 次，传入的 meta.getIcTransFinalMetaItemList() 为空 list（不抛 NPE，不抛任何异常） |

附加测试（非 AC，但建议覆盖）：
- **TC-Extra-1**：batch 中混合 1 条 buildMeta 返回 null（事件 schema 错误） + 2 条同 key 正常事件 → 验证 null 不进 metaItems，同 key 去重为 1 条，最终 list size == 1
- **TC-Extra-2**：去重日志断言 —— 命中去重时验证 `log.info("ic_trans_final batch dedup: before=..., after=...")` 被调用（用 logback `ListAppender` 或 mockito-inline 拦截 `log`），未命中时验证未调用。可选。

### 5.3 集成测试 / 手工验证建议

**建议手工验证场景**（落 `Verify.md`）：

1. **本地启动服务**，通过 `IcTransactionController.singleFinal` POST 单条触发，确认 `startSingle()` 路径未受影响（基线对照）
2. **直接构造 batch 模拟**：在 `start()` 单测无法跑或团队选 B 时，可以临时写一个 HTTP 调试 endpoint 接受 `List<InterComTransFinalEvent>` 转成 `BusKafkaBatchEvent` 调 `start()`，本地观察日志和 DB
3. **生产灰度观察**：上线后选一天观察 `ic_trans_final batch dedup` 日志条数，统计生产环境真实的同批次重复率

集成测试不强制，Yellow 等级单测 + 手工验证 + code-review 三道防线足够。

---

## 6. 回滚方案

### 6.1 回滚动作

**Git revert 单个 commit 即可**。本次改动只影响 1 个文件、约 10 行增量代码，commit 粒度精确到"批内去重"一件事。

操作：
```bash
git revert <commit-sha>
```

### 6.2 回滚成本评估

- **代码层**：极低。只回退 1 个 commit，无 schema / 配置 / 依赖联动
- **数据层**：无回滚需求。本次修复**不会**修改任何历史已落库数据；去重逻辑仅影响"修复上线后新进入的 batch"
- **下游影响**：回滚后行为退化为修复前（同批次重复会产生 12 行而非 6 行），下游 PDF 团队取值逻辑能否容忍重复行需对齐（修复前已有此问题，因此回滚等于"恢复已知 bug 状态"，下游早已用 Node1 兜底）

### 6.3 触发回滚的条件

| 触发条件 | 处理 |
|---|---|
| 上线后发现去重逻辑过激（误判合法不同业务对象为重复）| 回滚；同时立即排查 dedupKey 设计 |
| 上线后发现 `ic_trans_final` 缺失原本应该存在的行 | 回滚；确认是否存在"同 batch 内 (interlink, version) 相同但语义不同"的边界场景（scenario-review 已论证此场景不存在，但仍预留兜底） |
| 上线后发现日志噪声超出预期 | 不需回滚，只需把 `log.info` 改为 `log.debug` 后另发一个补丁 |
| 跨批次重复仍高频出现 | 不需回滚，本 case 本就未覆盖此场景；启另一个 case 处理 |

**评估结论**：回滚成本极低、风险极低。Yellow 等级的标准回滚预案，**无需开关 / feature flag**——单 commit revert 足以。

---

## 7. 构造器 / 依赖 / 命名规范确认

### 7.1 构造器 / 依赖

- **不引入新字段**：`IcTransactionFinalServiceImpl` 现有 4 个 final 字段（`busEngineExecuteService` / `busThreadConfigContext` / `localCaffeineService` / `icTriggerConfigService`）保持不变
- **不动构造器签名**：现有 L46-51 构造器签名保持不变
- **不引入新依赖类**：仅使用 `java.util.LinkedHashMap` / `ArrayList`，已被 L23 `import java.util.*;` 覆盖
- **不引入新外部库**：无新 Gradle 依赖

### 7.2 新方法 / 新变量命名

参照 `.claude/docs/code_style.md` 与 `.claude/docs/conventions.md`：

| 命名 | 类型 | 选定 | 理由 |
|---|---|---|---|
| 去重 Map | `LinkedHashMap<String, IcTransFinalMetaItem>` | **`dedupMap`** | 短而表意；"dedup" 在仓库其他代码无冲突命名；camelCase 符合规范 |
| 单条 key 字符串 | `String` | **`dedupKey`** | 与 `dedupMap` 对应一致 |
| 循环变量（item） | `IcTransFinalMetaItem` | **`item`** | 同类型变量在仓库其他 service for-each 循环中已使用（短而清晰） |

**不抽取独立 private 方法**：去重段仅 7 行，强行抽 `private List<IcTransFinalMetaItem> dedup(List<IcTransFinalMetaItem>)` 会引入过度设计（违反 Simplicity First）；同时该逻辑当前**只在 `start()` 一处用到**，复用价值为 0。后续如有第二处需要去重再考虑抽取。

### 7.3 注释规范

- 增量代码使用**中文**注释（符合 `.claude/rules/language.md`）
- 注释内容写"做什么 + 为什么"，不写"怎么做"（代码已自解释）
- 已示例：`// 批内按 (globalInterLink, version) 去重：同一 Kafka batch 内的重复事件只保留先到的一条` + `// 残余的跨批次 / 并发重复由 Node1FinalTrigger 现有存在性检查兜底`

### 7.4 日志规范

- 使用现有 `@Slf4j` 注入的 `log`，无需新增
- 日志文案中文 + 英文键值混合（与现有 `log.error("json转 meta 失败", e)` 风格一致）
- 不在每条 batch 都打 log（避免噪声），仅在命中去重时打 INFO（见 §3.3）

---

## 8. 拆给开发的子任务（落到 Task.md 的指南）

每条子任务对应 Scenario 中的 AC 或本 Solution 的具体段落：

| 序号 | 子任务 | 对应 AC / Solution 段 |
|---|---|---|
| T-1 | 在 `IcTransactionFinalServiceImpl.start()` L72 后插入 dedup 段（§3.1 完整代码） | AC-1 / AC-2 / AC-3 / AC-4 / §3.1 |
| T-2 | 验证插入位置不影响 `startSingle()`（不动 L83-91） | §4.5 |
| T-3 | 本地编译通过：`gradle :service:bus-freightlist-handler-service:bootJar` | LL Verify 要求 |
| T-4 | （可选）新建 `expand/business-freightlist-summary/src/test/java/.../IcTransactionFinalServiceImplTest.java`，覆盖 AC-1 ~ AC-5 + TC-Extra-1 | §5.2 |
| T-5 | 在 `impl-notes.md` 记录：dedupKey 拼接策略选择理由 + 是否落地单测的决策 | LL Yellow 流程 |

**开发约束**：
- 仅改 `IcTransactionFinalServiceImpl.java`，禁止顺手重构 `getCnHkStationMap` / `dispatch` / `startSingle` 等无关方法
- 新分支命名：`feat/ic-final-batch-dedup`（与 case-id 的 scenario-slug 对齐，见 `.claude/rules/commit-branch.md`）
- 用 `git worktree` 隔离到 `.claude/worktrees/feat-ic-final-batch-dedup/`，基于 `develop_1.1.0`

---

## 9. 总览检查清单（用户确认 Solution 时可对照）

- [x] 路径选型给出 4 个候选并说明取舍
- [x] 选定方案有明确的 Karpathy 4 原则对应理由
- [x] 拒绝的备选项 6 个已列出（含 schema / 锁 / 事务 / 节点删后插）
- [x] 现状代码行号精确（L54-79）
- [x] 增量代码段（7 行）给出可直接落地的完整片段
- [x] dedupKey 拼接策略说明清楚 null 处理 与 `#` 分隔符的安全性
- [x] 日志埋点决策（仅命中时打 INFO）
- [x] 影响分析覆盖三条链 / PDF / startSingle
- [x] 测试策略含 AC-1 ~ AC-5 草图 + 2 个附加测试
- [x] 回滚方案明确（单 commit revert，无开关）
- [x] 命名规范确认（dedupMap / dedupKey / item，不抽 private 方法）
- [x] 子任务清单可直接交给 java-backend-engineer
- [x] 不引入新字段 / 新依赖 / 新构造器参数

---

Token usage: input=14820, output=4760, total=19580
