# Test.md：IC_TRANS_FINAL 链 batch 内按业务键去重

> case-id：20260512_FREIGHTLIST_ic-final-batch-dedup
> 阶段：qa-engineer（测试设计）
> 风险等级：🟡 Yellow
> 被测方法：`IcTransactionFinalServiceImpl.start()`（worktree `feat/ic-final-batch-dedup`）
> 关联 AC：Scenario.md AC-1 ~ AC-5
> 测试框架：JUnit 5.10.2 + Mockito 5.11.0（已在 `expand/business-freightlist-summary/build.gradle` 声明）

---

## 一、测试范围说明

### 1.1 被测单元

`IcTransactionFinalServiceImpl.start(BusLiteFlowMeta, BusKafkaBatchEvent)` 中 L74-84 的**批内去重段**：

```java
LinkedHashMap<String, IcTransFinalMetaItem> dedupMap = new LinkedHashMap<>();
for (IcTransFinalMetaItem item : metaItems) {
    String dedupKey = item.getGlobalInterLink() + "#" + item.getVersion();
    dedupMap.putIfAbsent(dedupKey, item);
}
if (dedupMap.size() < metaItems.size()) {
    log.info("ic_trans_final batch dedup: before={}, after={}", ...);
}
metaItems = new ArrayList<>(dedupMap.values());
```

### 1.2 测试边界（不测）

- `buildMeta()` 方法（纯 JSON 映射，已由框架覆盖）
- `dispatch()` / `execute2Future()` 的内部实现（框架代码，通过 mock 隔离）
- Node1FinalTrigger / Node2IcTransFinalCalc / Node3FinalSave 节点（不在本次改动范围）
- Kafka 消费框架（`IcTransFinalListener`，上游入口）

### 1.3 mock 策略

因服务构造器有 4 个 final 字段（`BusEngineExecuteService`、`BusThreadConfigContext`、`BusLocalCaffeineService`、`IIcTriggerConfigService`），且 `buildMeta()` 内调用了 `localCaffeineService.getMap(...)`，单测需要 mock 这四个依赖。

核心断言通过 `ArgumentCaptor<IcTransFinalMeta>` 捕获 `execute2Future(...)` 入参，验证 `meta.getIcTransFinalMetaItemList()` 的 size 与内容。

---

## 二、五类用例设计

### 2.1 Normal（正常路径）

#### TC-N-01（对应 AC-1）：同 batch 内 2 条相同 key 事件去重为 1 条

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-N-01 |
| **对应 AC** | AC-1 |
| **描述** | batch 内 2 条 globalInterlink + version 完全相同的事件，去重后只剩 1 条 |
| **前置条件** | `busEngineExecuteService` 已 mock；`busThreadConfigContext.getThreadMap().get("FREIGHT_LIST")` 返回 mock ThreadPoolExecutor；`localCaffeineService.getMap(...)` 返回空 Map |
| **输入数据** | batch 含 2 条事件：`{globalInterlink: "I1", version: 10}` 和 `{globalInterlink: "I1", version: 10}` |
| **预期输出** | `execute2Future(...)` 的 meta 入参中 `icTransFinalMetaItemList.size() == 1`；唯一元素的 `globalInterLink == "I1"` 且 `version == 10` |
| **验证方式** | Mockito `ArgumentCaptor<IcTransFinalMeta>` 捕获 meta 后断言 |

---

#### TC-N-02（对应 AC-3）：3 条互不相同 key 事件均正常保留，顺序不变

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-N-02 |
| **对应 AC** | AC-3 |
| **描述** | batch 含 `(I1,10)`、`(I2,10)`、`(I1,20)` 三条互不相同的事件，去重不影响任何一条 |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | batch 含 3 条事件：`{I1,10}`、`{I2,10}`、`{I1,20}` |
| **预期输出** | `icTransFinalMetaItemList.size() == 3`；顺序严格为 I1-10, I2-10, I1-20（LinkedHashMap 插入顺序保留语义） |
| **验证方式** | ArgumentCaptor 捕获后断言 size 和顺序（`get(0).globalInterLink == "I1" && get(0).version == 10` 等） |

---

### 2.2 Boundary（边界用例）

#### TC-B-01（对应 AC-2）：3 条以上相同 key 去重为 1 条

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-B-01 |
| **对应 AC** | AC-2 |
| **描述** | batch 含 3 条 `(I1, 10)` 相同 key 事件，去重后仅保留 1 条（验证 putIfAbsent 对 N>=3 次的通用性） |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | batch 含 3 条事件：全部为 `{globalInterlink: "I1", version: 10}` |
| **预期输出** | `icTransFinalMetaItemList.size() == 1` |
| **验证方式** | ArgumentCaptor 断言 |

---

#### TC-B-02（对应 AC-5）：空 batch，dispatch 正常调用，传入空 list

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-B-02 |
| **对应 AC** | AC-5 |
| **描述** | `batchEvents.getBatchEvents()` 为 null，去重段对空 list 退化，dispatch 仍被正常调用 |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | `batchEvents.getBatchEvents() == null` |
| **预期输出** | `execute2Future(...)` 被调用 1 次；meta 中 `icTransFinalMetaItemList` 为空 list（非 null，size == 0）；不抛任何异常 |
| **验证方式** | ArgumentCaptor 断言 size == 0；`assertDoesNotThrow` 包裹 |

---

#### TC-B-03（对应 AC-5 变体）：batch 内所有事件 buildMeta 都返回 null，dispatch 正常调用空 list

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-B-03 |
| **对应 AC** | AC-5 |
| **描述** | batch 有 2 条事件，但 `JsonUtils.fromJson` 对两条都抛异常，全部被 try/catch 跳过，metaItems 为空，去重段对空 list 退化 |
| **前置条件** | mock `JsonUtils.getInstance()` 或使用无法反序列化的 JSON 字符串触发异常 |
| **输入数据** | batch 含 2 条事件，kafkaEvent.getEvent() 均返回无效 JSON 字符串 `"invalid"` |
| **预期输出** | `execute2Future(...)` 被调用 1 次；meta 中 `icTransFinalMetaItemList.size() == 0`；不抛异常 |
| **备注** | `JsonUtils` 是静态工具类，若无法 mock，可改为构造空 metaItems list 注入（验证方式降级为手工 trace） |
| **验证方式** | ArgumentCaptor 断言 + assertDoesNotThrow |

---

#### TC-B-04（对应 AC-5 变体）：batch size 为 0（空集合），行为同 TC-B-02

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-B-04 |
| **对应 AC** | AC-5 |
| **描述** | `batchEvents.getBatchEvents()` 为 empty list（非 null 但 size==0） |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | `batchEvents.getBatchEvents()` 返回 `new ArrayList<>()` |
| **预期输出** | `execute2Future(...)` 被调用 1 次；meta 中 `icTransFinalMetaItemList.size() == 0` |
| **验证方式** | ArgumentCaptor 断言 |

---

### 2.3 Negative（异常路径）

#### TC-NEG-01（should-consider §2，code-review.md）：dedupKey 中 globalInterLink 和 version 均为 null

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-NEG-01 |
| **对应 AC** | 非 AC 直接覆盖，对应 code-review.md should-consider §2 的建议 |
| **描述** | 两条事件的 globalInterlink 和 version 均为 null，dedupKey 拼成 `"null#null"`，第 2 条被 putIfAbsent 拦截 |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | batch 含 2 条事件：`{globalInterlink: null, version: null}` × 2 |
| **预期输出** | `icTransFinalMetaItemList.size() == 1`（null 脏数据也能被正常去重，不抛 NPE） |
| **验证方式** | ArgumentCaptor 断言；assertDoesNotThrow 确认无 NPE |

---

#### TC-NEG-02：buildMeta 返回 null 混合正常事件

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-NEG-02 |
| **对应 AC** | 对应 Solution.md §5.2 TC-Extra-1 |
| **描述** | batch 含 1 条 buildMeta 返回 null 的事件 + 2 条同 key 正常事件，null item 不进 metaItems，同 key 正常去重为 1 条 |
| **前置条件** | 构造 1 条 `event.globalInterlink = null` 触发 buildMeta 返回特殊行为，或直接用空 JSON 触发异常跳过 |
| **输入数据** | batch 含 3 条事件：第 1 条为触发 null/异常的数据；第 2、3 条为 `{I1, 10}` 同 key |
| **预期输出** | `icTransFinalMetaItemList.size() == 1`；唯一元素来自正常事件 |
| **验证方式** | ArgumentCaptor 断言 |

---

### 2.4 Regression（回归用例）

#### TC-REG-01：去重逻辑不改变无重复场景下的 list 内容（等价验证）

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-REG-01 |
| **对应 AC** | AC-3（无重复场景下的回归保证） |
| **描述** | 当 batch 内所有事件 key 互不相同时，去重后 list 内容与未加去重段时完全一致（size 不变、顺序不变、item 引用不变） |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | batch 含 2 条不同 key 事件 `{I1,10}`、`{I2,20}` |
| **预期输出** | `icTransFinalMetaItemList.size() == 2`；`get(0).globalInterLink == "I1"`；`get(1).globalInterLink == "I2"` |
| **验证方式** | ArgumentCaptor 断言 size 和顺序 |

---

#### TC-REG-02：startSingle 方法不受影响（回归 Solution §4.5）

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-REG-02 |
| **对应 AC** | Solution.md §4.5 |
| **描述** | `startSingle()` 是 HTTP 调试入口，天然单条入参，验证其调用路径不受本次改动影响 |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | 直接调用 `startSingle(flowChain, event)` 传入 1 条事件 |
| **预期输出** | `dispatchSingle(...)` 被调用 1 次；`execute2Resp(...)` 被调用 1 次；meta 中 `icTransFinalMetaItemList.size() == 1` |
| **备注** | `startSingle` 调 `dispatchSingle` → `execute2Resp`，路径与 `start()` 不同；`execute2Resp` 的 mock 与 `execute2Future` 独立 |
| **验证方式** | Mockito verify `busEngineExecuteService.execute2Resp(...)` 被调用 1 次 |

---

#### TC-REG-03：FREIGHT_LIST / IC_TRANS 链不受影响（代码层回归）

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-REG-03 |
| **对应 AC** | Solution.md §4.3 |
| **描述** | 静态检查 + Grep 验证：`DynamicFreightSummaryService`、`IcTransactionServiceImpl` 均未引用 `IcTransactionFinalServiceImpl`，本次改动不污染其他链 |
| **验证方式** | 静态检查（Grep），非单测；在 Verify.md 记录结果 |

---

### 2.5 Data Comparison（数据对比验证）

#### TC-DC-01（对应 AC-4）：同 key 重复时保留 batch 内先到的一条（FIFO 验证）

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-DC-01 |
| **对应 AC** | AC-4 |
| **描述** | batch 含 2 条同 key 事件，第 1 条 `cnHkStationMap` 非空（可区分标志），第 2 条 `cnHkStationMap` 为 null；去重后保留的是第 1 条（非 null 的那条） |
| **前置条件** | 直接构造 `IcTransFinalMetaItem` 对象，设置 `globalInterLink`、`version`，第 1 条额外设置 `cnHkStationMap = Map.of("HKG", "SZX")`，第 2 条 `cnHkStationMap = null`；将两条 item 预置进服务的 `metaItems`（通过控制 batch + mock buildMeta 或直接绕过 JSON 解析） |
| **输入数据** | item1 = `{I1, 10, cnHkStationMap={"HKG":"SZX"}}`；item2 = `{I1, 10, cnHkStationMap=null}` |
| **预期输出** | `icTransFinalMetaItemList.size() == 1`；唯一元素的 `cnHkStationMap` 不为 null（即来自 item1，先到的） |
| **验证方式** | ArgumentCaptor 捕获后断言 `list.get(0).getCnHkStationMap() != null` |

---

#### TC-DC-02：混合场景数据对比（3 条不同 key 无重复 vs 3 条含 1 组重复）

| 字段 | 内容 |
|---|---|
| **用例编号** | TC-DC-02 |
| **对应 AC** | AC-1、AC-3 综合对比 |
| **描述** | 对比两次调用：第 1 次 batch 含 `(I1,10)`、`(I2,10)`、`(I1,20)` 无重复→ size=3；第 2 次 batch 含 `(I1,10)`、`(I1,10)`、`(I2,10)` 有 1 组重复 → size=2（I1-10 保留 1 条，I2-10 保留 1 条） |
| **前置条件** | 同 TC-N-01 |
| **输入数据** | 两组 batch 分别调用 |
| **预期输出** | 第 1 次：size=3；第 2 次：size=2，顺序为 I1-10, I2-10 |
| **验证方式** | 两次 ArgumentCaptor 捕获分别断言 |

---

## 三、测试数据样本

### 3.1 辅助方法（测试类内）

```java
// 构造一条 BusKafkaEvent，其中 event payload 为合法 JSON
private static BusKafkaEvent makeKafkaEvent(String globalInterlink, Long version) {
    String json = String.format(
        "{\"globalInterlink\":\"%s\",\"version\":%d}",
        globalInterlink == null ? "null" : globalInterlink,
        version == null ? 0 : version
    );
    BusKafkaEvent event = new BusKafkaEvent();
    event.setEvent(json);
    return event;
}

// 直接构造 IcTransFinalMetaItem（绕过 JSON 解析，用于 AC-4 / TC-NEG-01）
private static IcTransFinalMetaItem makeMetaItem(String interLink, Long version) {
    IcTransFinalMetaItem item = new IcTransFinalMetaItem();
    item.setGlobalInterLink(interLink);
    item.setVersion(version);
    return item;
}
```

### 3.2 具体 JSON 样本

| 场景 | JSON |
|---|---|
| 正常事件 (I1, 10) | `{"globalInterlink":"I1","version":10}` |
| 正常事件 (I2, 10) | `{"globalInterlink":"I2","version":10}` |
| 正常事件 (I1, 20) | `{"globalInterlink":"I1","version":20}` |
| null key 事件 | `{"globalInterlink":null,"version":null}` |
| 无效 JSON（触发 buildMeta 异常） | `invalid-json` |

---

## 四、测试类设计概要

### 4.1 测试类定位

```
expand/business-freightlist-summary/
  src/test/java/com/pobing/bus/freight/list/summary/service/impl/
    IcTransactionFinalServiceImplTest.java
```

### 4.2 类结构草图

```java
@ExtendWith(MockitoExtension.class)
class IcTransactionFinalServiceImplTest {

    @Mock private BusEngineExecuteService busEngineExecuteService;
    @Mock private BusThreadConfigContext busThreadConfigContext;
    @Mock private BusLocalCaffeineService localCaffeineService;
    @Mock private IIcTriggerConfigService icTriggerConfigService;
    @Mock private ThreadPoolExecutor threadPoolExecutor;

    @InjectMocks private IcTransactionFinalServiceImpl service;

    // @BeforeEach：设置 busThreadConfigContext.getThreadMap().get("FREIGHT_LIST")
    //              返回 threadPoolExecutor
    //             设置 localCaffeineService.getMap(...) 返回 empty map
    //             设置 busEngineExecuteService.execute2Future(...) 返回完成的 CompletableFuture

    // 各 @Test 方法对应 TC-N-01 ~ TC-DC-02
}
```

### 4.3 核心断言模式

```java
// 捕获 meta 入参
ArgumentCaptor<IcTransFinalMeta> metaCaptor = ArgumentCaptor.forClass(IcTransFinalMeta.class);
verify(busEngineExecuteService).execute2Future(any(), anyString(), any(), metaCaptor.capture());
IcTransFinalMeta capturedMeta = metaCaptor.getValue();
List<IcTransFinalMetaItem> items = capturedMeta.getIcTransFinalMetaItemList();

// 断言 size
assertEquals(expectedSize, items.size());
// 断言顺序
assertEquals("I1", items.get(0).getGlobalInterLink());
assertEquals(10L, items.get(0).getVersion());
```

---

## 五、用例 ↔ AC 覆盖矩阵

| 用例编号 | AC-1 | AC-2 | AC-3 | AC-4 | AC-5 | 说明 |
|---|---|---|---|---|---|---|
| TC-N-01 | 主覆盖 | - | - | - | - | 2 条同 key → 1 条 |
| TC-N-02 | - | - | 主覆盖 | - | - | 3 条不同 key 均保留 |
| TC-B-01 | - | 主覆盖 | - | - | - | 3 条同 key → 1 条 |
| TC-B-02 | - | - | - | - | 主覆盖 | 空 batch |
| TC-B-03 | - | - | - | - | 辅助 | 全异常跳过 |
| TC-B-04 | - | - | - | - | 辅助 | 空集合 |
| TC-NEG-01 | - | - | - | - | - | null key 不抛 NPE |
| TC-NEG-02 | - | - | - | - | - | TC-Extra-1 |
| TC-REG-01 | - | - | 辅助 | - | - | 无重复回归 |
| TC-REG-02 | - | - | - | - | - | startSingle 回归 |
| TC-REG-03 | - | - | - | - | - | 静态检查，非单测 |
| TC-DC-01 | - | - | - | 主覆盖 | - | FIFO 保留先到条 |
| TC-DC-02 | 辅助 | - | 辅助 | - | - | 数据对比 |

AC-1 ~ AC-5 全部被至少 1 条用例主覆盖。

---

## 六、测试基础设施评估

| 项目 | 状态 | 说明 |
|---|---|---|
| `build.gradle` JUnit 5 依赖 | 已存在 | `testImplementation 'org.junit.jupiter:junit-jupiter:5.10.2'` |
| `build.gradle` Mockito 依赖 | 已存在 | `testImplementation 'org.mockito:mockito-core:5.11.0'` |
| `build.gradle` Mockito JUnit 扩展 | 已存在 | `testImplementation 'org.mockito:mockito-junit-jupiter:5.11.0'` |
| `src/test/java` 目录 | 不存在 | 需新建，代价极低（mkdir + 1 个测试文件），总改动 < 30 行 |
| Lombok 编译 | 已在 build.gradle 配置 | compileOnly + annotationProcessor，测试类不用 Lombok |

结论：接入代价极低，本 case QA 阶段将建立 `src/test` 目录并落地单测。
