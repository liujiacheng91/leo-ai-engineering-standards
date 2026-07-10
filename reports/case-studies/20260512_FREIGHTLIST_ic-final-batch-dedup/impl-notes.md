# impl-notes.md：ic-final-batch-dedup 实现决策日志

> case-id：20260512_FREIGHTLIST_ic-final-batch-dedup
> 阶段：java-backend-engineer
> 分支：feat/ic-final-batch-dedup
> 产出时间：2026-05-12

---

## 关键技术决策

### 1. dedupKey 拼接策略：选用字符串拼接而非 Pair/record

Solution.md §3.2 已完整分析，此处补充实现侧的确认：

- `item.getGlobalInterLink()` 来自 `buildMeta()` L95：`meta.setGlobalInterLink(event.getGlobalInterlink())`，大小写注意：event 字段是 `globalInterlink`（小写 l），meta 字段是 `globalInterLink`（大写 L），已由 `buildMeta` 完成映射
- `item.getVersion()` 来自 `buildMeta()` L96：`meta.setVersion(event.getVersion())`，类型为 `Long`
- `String.valueOf(null)` 的行为：Java 会将 null Long 直接通过字符串拼接转成字面量 `"null"`，对于重复检测场景（两个都是 null 的情况只保留第一条）是可接受的
- `#` 作为分隔符：经确认 globalInterlink 是 shipment interlink 编号（不含特殊符号），version 是时间戳数字，均不含 `#`，无歧义风险

**决定**：保持字符串拼接，不引入额外类型。

### 2. import 无需新增

`import java.util.*` 在 L23 已存在，`LinkedHashMap` 和 `ArrayList` 均在 `java.util` 包内，无需新增 import 行。这也是 Solution.md 中明确注明的（§3.1 Import 说明）。

### 3. 未落地 Mockito 单元测试（选 Option B）

Solution.md §5.1 提供了两个选项：
- **选项 A**：在 `expand/business-freightlist-summary/` 新建 `src/test` 目录，写 `IcTransactionFinalServiceImplTest`
- **选项 B**：仅以 `Verify.md` 手工验证场景表 + 日志快照为证据

**决定选 Option B**，理由：
- 本仓库目前没有 `src/test` 目录，若新建 `src/test` 属于超出 Solution 锁定范围的改动（Solution §8 "开发约束"第一条：仅改 `IcTransactionFinalServiceImpl.java`）
- 首次引入 Mockito 依赖和测试基础设施属于独立改动，应走独立 case，不混在本次 batch-dedup 修复里（Surgical Changes 原则）
- QA 阶段 `qa-engineer` 产出的 `Verify.md` 已涵盖手工验证场景，Yellow 等级下手工验证 + code-review 两道防线足够

建议补录：若将来要落 Mockito 测试基础设施，建议新开 `GREEN` case 专门处理 `src/test` 目录创建 + 依赖添加 + 第一个 test class 落地，可复用 Solution.md §5.1 的 Mock 策略描述。

### 4. 编译验证的特殊路径

由于 `net.nemerosa.versioning` 插件在 git worktree 环境下读取 `HEAD` 失败（插件不能解析 worktree 的 `.git` 指针文件），无法在 worktree 目录直接运行 `gradle bootJar`。

采用的验证方式：
1. 将改动文件临时复制到主仓库（`develop_1.1.0`）工作树
2. 在主仓库目录运行 `gradle :service:bus-freightlist-handler-service:bootJar`
3. 确认 `BUILD SUCCESSFUL`（4 个 warning 均为已有的 rawtype/unchecked 告警，与本次改动无关）
4. 立即还原主仓库文件

**结论**：改动代码语法正确，编译无错误，4 个警告均为既有代码的泛型告警。

---

## 给 QA 的提示

### 验证场景与造测试数据方式

参考 Solution.md §5.2 的 AC-1 ~ AC-5 测试用例草图：

| 场景 | 造数据方式 | 验证点 |
|---|---|---|
| AC-1：同键 2 条 | 向 `bus_ic_trans_final_queue_v1` 推 2 条相同 `(globalInterlink, version)` 的消息 | DB 里 `ic_transaction_final` 只写入 1 条（而非 2 条）；日志出现 `ic_trans_final batch dedup: before=2, after=1` |
| AC-2：同键 3 条 | 同上，推 3 条 | DB 只写 1 条；日志 `before=3, after=1` |
| AC-3：3 条不同键 | 推 `(I1,10) / (I2,10) / (I1,20)` 3 条不同键 | DB 写 3 条；**无** `ic_trans_final batch dedup` 日志 |
| AC-4：保留先到 | 推 2 条同键但字段值不同的消息（如第一条有特征值 A，第二条有特征值 B） | DB 里的那条保留第一条的特征值 A |
| AC-5：空 batch | 空消息或 `batchEvents == null` | 服务无异常；`ic_transaction_final` 无新写入 |

**注意**：`IcTransFinalListener` 处理 Kafka batch，同一 batch 内的多条消息才会触发去重。不同 batch（不同 Kafka poll 周期）的重复消息由 Node1FinalTrigger 的现有存在性检查兜底，不在本 case 覆盖范围内。

### 验证 `startSingle()` 不受影响

通过 HTTP 调试端点：`POST /icTransaction/singleFinal`（见 `IcTransactionController.java` singleFinal 方法），传入单条 `InterComTransFinalEvent`，确认功能正常。

---

## 改动文件清单（final）

| 文件 | 改动类型 | 改动内容 |
|---|---|---|
| `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/impl/IcTransactionFinalServiceImpl.java` | 新增 12 行 | `start()` 方法 L73-84 去重段 |

---

## 已知限制 / TODO

- **跨批次重复**：本 case 只解决同一 Kafka batch 内的重复，跨批次重复由 Node1FinalTrigger 现有逻辑兜底，不在本 case 范围
- **并发重复**：多个 consumer 实例同时处理不同 batch 的相同消息，不在本 case 范围
- **单测基础设施**：Mockito 测试框架引入留给独立 case（见"给 QA 的提示"节）
