# 需求评审意见 - 20260511_FREIGHTLIST_ic-final-shared-trans-no

> 评审人：tech-architect（review 模式）
> 评审时间：2026-05-11
> 输入：Scenario.md (RA draft) + AI_Request.md + Node2IcTransFinalCalc.java + REQ-202604300018

## 整体评估

**需修改** —— 业务理解与改造范围基本正确，Yellow 风险定位合理；但有 3 个澄清问题（Q3 / Q5 / Q6）属于"实现路径强依赖项"，必须先得到答复才能进入 architecture 阶段；另有 4 个遗漏点需要 RA 在 revise 时补进 Scenario.md。

## 业务理解一致性核查

RA 对会计分录格式（1 H + 2 D 同属一笔分录、共用内部凭证号）的理解准确，与代码中 `buildIcTransFinal` 按 transaction 循环并产出 3 行（indicator='H' / chargeCode='P0005' / chargeCode='OTH-PS'）的拆分结构完全对应。"3 行共用 transNo" 在会计上是常见做法，本次改造方向与业务直觉一致。

已交叉验证（不依赖 RA 文档单方陈述）：

- `CustomTypeConvertUtils.toFourDigits` 全仓库仅 `Node2IcTransFinalCalc.java:154` 一处调用（含 RA 自述一致）
- `internalTransNo` 字段在 `IcTransactionFinalEntity:116` 与 `IcTransactionFinalChangeEntity:116` 都是 `String`（A3 关于目标字段是 String 的部分得到验证）
- `IcTransactionEscalateEntity` 不含 `internalTransNo` 字段（下游 escalate 表不受影响）
- `GlobalMonotonicService` 在本仓库 0 命中（确认是 `com.pobing.bus.*` 外部框架包）
- `Node3Save` 落 `ic_transaction_final` / `ic_transaction_final_change` / `ic_transaction_escalate` 三张表，第三张不携带 `internalTransNo`

## 逐条假设评审

| # | 假设摘要 | 结论 | 评审意见 |
|---|---|---|---|
| A1 | `GlobalMonotonicService` 已由 `com.pobing.bus.*` 框架包提供，可直接 Spring 注入 | **暂接受 / 待 Q3 拍板** | 仓库 0 命中确实指向外部依赖。若 build.gradle 当前依赖**不包含**该 Bean，则属"Yellow 边界扩张"，需 TA(architecture) 在 Solution 中显式声明 GAV 与 Bean 注入方式。**RA revise 时不需要改 A1，但要把 Q3 提到"阻塞 architecture 的前置条件"** |
| A2 | `nextEpoch` 同步阻塞、单调递增、分布式锁由框架兜底、不返回 null/不重复 | **需修正** | 这是对**框架行为**的假设，不应由 RA 自行担保。改写为：「**待 Q3 验证**：本 Scenario 假设 nextEpoch 满足"同步、单调、非 null、不重复"，由 TA 在 architecture 阶段读框架代码或文档核实；若实际行为不满足任何一点（如可能返回 null、可能抛异常），方案需调整异常路径与降级策略」 |
| A3 | 返回值可直接赋 `String internalTransNo`；返回 long/Long 时 `String.valueOf`；返回 String 更佳 | **接受** | 目标字段类型已核实为 String。返回类型由 TA 在框架接口签名核实后定，本 Scenario 不预设是正确的处理方式 |
| A4 | 放弃"4 位补零"约束；下游字段 String 对长度无强约束 | **需修正** | "下游字段 String 对长度无强约束"是 schema 层面的判断，不能等同于"业务/PDF/账务侧无长度约束"。建议改写为：「**schema 层面** `internal_trans_no` 是 String 无长度强约束；**业务层面**是否仍需 4 位 / 固定宽度由 Q4 拍板」，不要把 schema 推论直接当成业务结论 |
| A5 | nextEpoch 语义是"每次新号"而非"按业务键幂等返回同号" | **接受**，但绑定 Q5 | 这是关键语义，必须由产品/财务侧拍板。当前 RA 写法（默认非幂等，需 Q5 推翻才走另一方案）是稳妥的 |
| A6 | 不动 IC_TRANS 链 / Node1 / Node3 / 实体字段定义 / 表结构 | **接受** | 已交叉验证：IC_TRANS（非 final）链上 `IcTransactionEntity` 字段集合中确实没有 `internalTransNo`（grep 命中 0），IC_TRANS 链与本次改造无交集 |
| A7 | `toFourDigits` 改造后成孤儿方法，是否物理删除由 TA Surgical Changes 判断 | **接受** | 工具类还有其他公用方法（`string2Integer` 等），TA 删除时只动 `toFourDigits` 一个方法即可，工具类本身保留。**建议 RA revise 时把"工具类保留、仅 toFourDigits 是孤儿"这一行加进 Scenario.md，避免 TA 误以为整个工具类待删** |

## 逐条 AC 评审

| # | AC 摘要 | 可验证性 | 评审意见 |
|---|---|---|---|
| AC-1 | 同一 IcTransactionEntity 派生的 3 条 Final（H/P0005/OTH-PS）internalTransNo 完全相同 | ✅ 可单测 | 描述精确，QA 可按 indicator + chargeCode 三元组查 transNo 是否一致 |
| AC-2 | 不同 IcTransactionEntity 之间 internalTransNo 不相同（同次链执行内） | ✅ 可单测 | 描述精确 |
| AC-3 | internalTransNo 由 `nextEpoch("INTERNAL_TRANS_NO")` 提供，每条 IC 交易调用一次 | ⚠️ 部分可验证 | "每条交易调用一次"在单测中可通过 Mockito 验证 invocation count == icTransactionList.size()。**建议补充**："且发号顺序与 icTransactionList 的迭代顺序一致" |
| AC-4 | Change 与 Final 的 internalTransNo 一致 | ✅ 可单测 | 描述精确 |
| AC-5 | 落库 `ic_transaction_final` 与 `ic_transaction_final_change` 呈"3 行同值、按交易分组" | ✅ 可数据库比对 | QA data-comparison 用例自然覆盖 |
| AC-6 | 发号服务异常时遵守"吞异常 + log.error"约定 | ⚠️ 表述偏弱 | "不让整批退出"是 LiteFlow 默认约束。建议加一句明确的可观察行为：「**节点完成态**：当 nextEpoch 抛异常时，该 IcTransFinalMetaItem 的 `icTransactionFinalList` 处于何种状态（空 / 部分 / 全部回滚）需要可观察，QA 据此设计 negative 用例」。具体策略由 Q6 拍板 |

## 待澄清问题（Q1~Q7）补充评审

RA 已列 7 条，覆盖较全。**遗漏 / 需要追加**：

### 必补（4 条）

- **Q8（Kafka 重放幂等性）**：与 Q5 关联但角度不同。`IcTransFinalListener` 监听 `bus_ic_trans_final_queue_v1`，Kafka 默认 at-least-once，**同一消息可能被消费多次**。每次消费都走完整链 → 每次都调 `nextEpoch` → 同一笔 IC 交易在 `ic_transaction_final` 表中**多次落库且 internalTransNo 不同**。Q5 关注"主动重算"，Q8 关注"Kafka 自身重投"，需要拍板：
  - 上游是否保证 exactly-once？
  - 落库前是否按 `globalInterlink + version` 删历史再插？（grep `Node3Save` 未见删除逻辑，**当前是纯 saveBatch，重消费会产生重复行**）
  - 此问题**已超出本任务范围**，但本任务的改造让重复行的 internalTransNo 不一致更明显，建议在 Scenario.md 显式说明"已知历史问题，不在本任务修复"

- **Q9（nextEpoch 失败的回退策略）**：与 Q6 关联但更具体。除"吞异常 + log.error"外，需明确：
  - 是否允许在 nextEpoch 抛异常时**回退到旧 `toFourDigits(++index)` 逻辑**？（不建议，但要明确否决）
  - 是否允许跳过当前 IcTransactionEntity，继续处理剩余交易？还是直接 break 跳过该 metaItem 的整批 buildIcTransFinal？
  - 默认建议（待 TA 在 Solution 中拍板）：单条 transaction 调用失败 → log.error + continue，避免整批失败；但落库时该 transaction 的 3 行 Final 都不应入库（避免 transNo 为 null 落地）

- **Q10（影响 IC_TRANS（非 final）链上的 internalTransNo 字段）**：已交叉验证：`IcTransactionEntity`（IC_TRANS 链的产物）**不含** internalTransNo 字段，IC_TRANS 链不受影响。**RA revise 时把这一结论从"待澄清"升级为"已确认范围边界"**，无需再问

- **Q11（影响 IcTransactionEscalate 等下游表）**：已交叉验证：`IcTransactionEscalateEntity` **不含** internalTransNo 字段，下游 escalate 表不受影响。同 Q10，结论纳入"范围边界"，无需提问

### 已问问题的优先级标注（建议 RA revise 时显式标注）

- 🔴 **阻塞 architecture**：Q3（GlobalMonotonicService 依赖坐标与签名）、Q5（业务键幂等性需求）、Q6/Q9（异常策略）
- 🟡 **阻塞 finalize**（但 architecture 可以并行）：Q1（PDF 是否用 transNo 做行级唯一键）、Q2（PDF 排序展示是否容忍跳号）、Q4（4 位格式化是否保留）
- 🟢 **澄清即可**：Q7（并发，当前单线程顺序循环明确无问题）

## 红线 / Karpathy 合规速查

| 检查项 | 结果 | 备注 |
|---|---|---|
| 不改 `@LiteflowComponent` 字符串值 | ✅ | Scenario 范围边界明示不动 |
| 不改节点数字编号 | ✅ | Node2 仍是 Node2 |
| 不写 `*_history` 表 | ✅ | 本任务与 history 流无关 |
| 用 V1 Meta | ⚠️ N/A | 本任务涉及 IC 链，IC 链的 Meta（`IcTransFinalMeta` / `IcTransFinalMetaItem`）本身就是 IC 链的版本，不涉及 FreightList 的 V1/legacy 选择 |
| 构造器注入 | ⚠️ 待 TA architecture | RA 未具体说明，但 `Node3Save.java:30` 已示范模式，TA 应在 Solution 中明确 Node2 需新增构造器注入 GlobalMonotonicService |
| `process()` 吞异常 + log.error | ✅ | Scenario AC-6 已明确遵守 |
| Surgical Changes | ✅ | 改动范围非常聚焦（仅 `buildIcTransFinal` + 构造器），无连带重构 |
| Simplicity First | ✅ | 无多余抽象 |

## 必须修改（must-fix）清单（RA revise 时按条处理）

1. **A2 修正**：把"由框架兜底"的担保性表述改为"待 Q3 验证的假设"
2. **A4 修正**：拆开 schema 层面与业务层面的判断，"无长度约束"只在 schema 层成立
3. **A7 补充**：明示"工具类整体保留、仅 toFourDigits 改造后成孤儿方法"，避免 TA 误删
4. **AC-3 补充**：加"发号顺序与 icTransactionList 迭代顺序一致"
5. **AC-6 强化**：明示 nextEpoch 异常时 `icTransactionFinalList` 的可观察终态（空 / 部分 / 全），QA 据此设计 negative 用例
6. **新增 Q8**：Kafka 重放场景下 internalTransNo 唯一性变化的影响（结论：本任务不修，但需在 Scenario.md 中显式标注"已知历史问题"）
7. **新增 Q9**：nextEpoch 失败时的回退策略颗粒度（默认建议：单条 transaction continue，但不允许半部落库）
8. **Q10/Q11 移出"待澄清"**：升级为"范围边界已确认"（IC_TRANS 链与 escalate 表不受影响，已交叉验证）
9. **Q1~Q7 分级标注**：用 🔴 / 🟡 / 🟢 标出"阻塞 architecture / 阻塞 finalize / 一般"
10. **`build.gradle` 依赖核查注记**：在"待澄清"或"影响范围"段加一行：「TA(architecture) 进入前需先 grep `build.gradle` 中 `com.pobing.bus.*` 依赖，确认 GlobalMonotonicService 所在的 jar 是否已传递引入；若需新增 dependency，记为 Yellow 边界扩张并在 Solution 中标红」

## 阻塞问题

无强阻塞（不需要回到用户那里"推翻整个需求"），但有 3 个**阻塞下一阶段**的前置项：

- Q3（GlobalMonotonicService 接口签名）：阻塞 TA(architecture)
- Q5（业务键幂等性需求）：阻塞 TA(architecture)
- Q6 + Q9（异常策略）：阻塞 TA(architecture)

Q1 / Q2 / Q4 阻塞 RA(finalize)（涉及与 PDF 团队对齐），不阻塞 architecture 设计本身。

## 通过条件

按 must-fix 清单 1~11 改完 Scenario.md，且 Q3 / Q5 / Q6+Q9 由用户/产品/框架 owner 给出明确答复后，可进入：

- RA(finalize)：取需求池号 + amends REQ-202604300018 "字段值固定/派生规则" 第 30 行
- TA(architecture)：产出 Solution.md（Yellow 风险，需用户人工确认 Solution 后再派开发）

## 下一步建议

1. 主 Claude 先用 AskUserQuestion 收集 Q3 / Q5 / Q6+Q9 三项关键答复
2. RA(revise) 按本评审 must-fix 1~11 改 Scenario.md
3. 重新调 TA(review) 复评（如必要）或直接进入 RA(finalize)
4. RA(finalize) 与 PDF 团队对齐 Q1 / Q2 / Q4 后取号入池、amends REQ-202604300018
5. TA(architecture) 产出 Solution.md（必含：GlobalMonotonicService 注入方式 / nextEpoch 异常策略 / 是否保留 4 位格式化 / 是否物理删除 toFourDigits）
6. 用户确认 Solution.md → java-backend-engineer 起新分支 `feat/ic-final-shared-trans-no` 实现
