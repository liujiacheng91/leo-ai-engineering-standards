# Task.md：IC_TRANS_FINAL 链 batch 内按业务键去重

> case-id：20260512_FREIGHTLIST_ic-final-batch-dedup
> 阶段：java-backend-engineer（实现计划）
> 分支：feat/ic-final-batch-dedup
> worktree：.claude/worktrees/feat-ic-final-batch-dedup/

---

## 子任务清单

### T-1：在 `start()` 方法 L72 后插入 dedup 段

| 项目 | 内容 |
|---|---|
| **input** | `IcTransactionFinalServiceImpl.java` 当前 `start()` 方法，L58-72 循环已将非空 metaItem 追加到 `metaItems` 列表 |
| **output** | L72 与 L75 之间插入约 10 行去重代码：`LinkedHashMap<String, IcTransFinalMetaItem> dedupMap` → for 循环 `putIfAbsent` → size 变化时打 `log.info` → `metaItems = new ArrayList<>(dedupMap.values())` |
| **files** | `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/impl/IcTransactionFinalServiceImpl.java` |
| **done criteria** | 代码插入位置正确（L72 后、L75 前）；`LinkedHashMap` / `ArrayList` 均由现有 `import java.util.*` 覆盖，无需新增 import；注释为中文 |
| **verification** | 代码 diff 仅涉及 `start()` 方法内的去重段；`startSingle()` / `buildMeta()` / `dispatch()` 等方法无改动 |
| **引用 AC** | AC-1（同键 2 条去重为 1 条）、AC-2（同键 3 条去重为 1 条）、AC-3（3 条不同键均保留）、AC-4（保留 batch 内先到的一条） |

---

### T-2：验证 `startSingle()` 不受影响

| 项目 | 内容 |
|---|---|
| **input** | 改动后的 `IcTransactionFinalServiceImpl.java` |
| **output** | 确认 `startSingle()`（L82-91）代码无改动，路径天然无重复 |
| **done criteria** | `git diff develop_1.1.0...HEAD` 仅显示 `start()` 内的去重段新增行，`startSingle` 方法体无变化 |
| **引用 AC** | Solution.md §4.5 |

---

### T-3：本地编译验证

| 项目 | 内容 |
|---|---|
| **input** | worktree 内已改好的代码 |
| **output** | `gradle :service:bus-freightlist-handler-service:bootJar` 编译成功，无报错 |
| **done criteria** | Gradle 输出 `BUILD SUCCESSFUL` |
| **verification** | 编译日志截图 / 输出片段记录在本文档"验证结果"节 |
| **引用 AC** | LL Verify 要求（编译不通过不得 commit） |

---

### T-4：（可选）Mockito 单元测试

> Solution.md §5.1 建议选项 A，但 QA 阶段将另产出 Test.md + Verify.md；本 case 由主 Claude 在收尾阶段和用户确认是否跳过 QA 后再决定。

---

### T-5：产出 `impl-notes.md`

| 项目 | 内容 |
|---|---|
| **output** | `docs/ai/cases/20260512_FREIGHTLIST_ic-final-batch-dedup/impl-notes.md` |
| **done criteria** | 记录 dedupKey 拼接策略选择理由、是否落地单测的决策 |

---

## 改动文件清单（精确）

| 文件（相对仓库根） | 改动类型 | 涉及行号 |
|---|---|---|
| `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/impl/IcTransactionFinalServiceImpl.java` | 新增约 10 行（去重段插入） | 原 L72-L74 之间 |

不改动以下文件（Solution 明确锁定）：

- 任何 entity / mapper / XML
- `IcTransFinalMeta.java` / `IcTransFinalMetaItem.java`
- 任何 LiteFlow 节点（Node1FinalTrigger / Node2 / Node3Save）
- 任何 YAML / `build.gradle`
- DB schema

---

## 实现步骤（按实际操作顺序）

1. 在 `.claude/worktrees/feat-ic-final-batch-dedup/` worktree 内打开 `IcTransactionFinalServiceImpl.java`
2. 在 L72（外层 `if` 结束的 `}`）之后、L75（`//启动 flow chain` 注释）之前插入去重段：
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
3. 检查 import：`java.util.*`（L23）已覆盖 `LinkedHashMap` / `ArrayList`，无需新增
4. 运行 `gradle :service:bus-freightlist-handler-service:bootJar` 编译验证
5. 执行 `git diff develop_1.1.0...HEAD` 确认改动面只有目标方法内的去重段
6. commit

---

## 测试矩阵概要

| 用例编号 | 场景 | 输入 | 预期输出 |
|---|---|---|---|
| AC-1 | 同键 2 条 | batch 含 2 条 `(I1, 10)` 事件 | metaItems.size()==1；打印 dedup 日志 |
| AC-2 | 同键 3 条 | batch 含 3 条 `(I1, 10)` 事件 | metaItems.size()==1；打印 dedup 日志 |
| AC-3 | 3 条不同键 | `(I1,10)/(I2,10)/(I1,20)` | size==3；顺序保持 I1-10, I2-10, I1-20；不打 dedup 日志 |
| AC-4 | 同键保留先到 | batch 含 2 条同键事件，第 1 条特征字段=A | 保留第 1 条（特征字段=A） |
| AC-5 | 空 batch | batchEvents.getBatchEvents()==null 或 size==0 | dispatch 正常调用，传入空 list；无异常 |
| TC-Extra-1 | 混合 null + 同键 | buildMeta 返回 null 的 1 条 + 同键 2 条正常 | size==1；null 未进入 metaItems |

详细用例由 qa-engineer 在 `Test.md` 中拆解。

---

## 验证结果

### T-3 编译

**结论：BUILD SUCCESSFUL**

执行命令（临时将 worktree 改动文件复制到主仓库后编译，完成后还原）：

```
gradle :service:bus-freightlist-handler-service:bootJar
```

输出摘要：

```
> Task :expand:business-freightlist-summary:compileJava
（4 个 rawtype/unchecked 警告，均为已有代码的泛型告警，与本次改动无关）
> Task :service:bus-freightlist-handler-service:bootJar
BUILD SUCCESSFUL in 29s
```

备注：由于 `net.nemerosa.versioning` 插件不兼容 git worktree 的 `.git` 指针文件格式，无法在 worktree 目录直接运行 gradle，故采用临时复制 + 编译 + 还原的验证路径。详见 `impl-notes.md` §4。

### T-2 diff 检查

**结论：改动面仅限目标方法内的去重段**

执行命令：

```
git diff（在 worktree 目录）
```

diff 输出：

```diff
@@ -71,6 +71,18 @@ public CompletableFuture<BusKafkaBatchEvent> start(...)
         }

+        // 批内按 (globalInterLink, version) 去重：...
+        // 残余的跨批次 / 并发重复由 Node1FinalTrigger 现有存在性检查兜底
+        LinkedHashMap<String, IcTransFinalMetaItem> dedupMap = new LinkedHashMap<>();
+        for (IcTransFinalMetaItem item : metaItems) {
+            String dedupKey = item.getGlobalInterLink() + "#" + item.getVersion();
+            dedupMap.putIfAbsent(dedupKey, item);
+        }
+        if (dedupMap.size() < metaItems.size()) {
+            log.info("ic_trans_final batch dedup: before={}, after={}", ...);
+        }
+        metaItems = new ArrayList<>(dedupMap.values());
+
         //启动 flow chain
         return this.dispatch(...)
```

涉及文件：仅 `IcTransactionFinalServiceImpl.java` 1 个文件，净新增 12 行（含 2 行注释）。
`startSingle()` / `buildMeta()` / `dispatch()` / `getCnHkStationMap()` 等方法无改动。

---

## commit 列表

| commit hash | 分支 | 说明 |
|---|---|---|
| `c83acf9` | `feat/ic-final-batch-dedup` | 添加 IC_TRANS_FINAL batch 内按业务键去重逻辑 |
| `585bcef` | `develop_1.1.0` | 添加 Task.md：ic-final-batch-dedup 实现计划（文档） |
| `39d8ce9` | `develop_1.1.0` | 添加 impl-notes.md：ic-final-batch-dedup 实现决策日志（文档） |
