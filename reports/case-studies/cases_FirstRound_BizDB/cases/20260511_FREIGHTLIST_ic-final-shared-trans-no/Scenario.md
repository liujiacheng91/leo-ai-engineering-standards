# Scenario：IC Trans Final 内部交易号（internalTransNo）改造

> case-id：20260511_FREIGHTLIST_ic-final-shared-trans-no
> 阶段：RA(revise) —— 已按 TA(review) must-fix 11 条修订，并落地用户对 Q3 / Q4 / Q5 / Q6+Q9 的 4 项决策
> 关联需求：[REQ-202604300018](../../../.claude/requirements/202604300018.md)（"字段值固定/派生规则"段第 30 行需 amends）
> 风险初判：🟡 Yellow（见 `AI_Risk_Level.md`）

## 业务背景

IC_TRANS_FINAL 链产出的 IC Final 记录是**会计分录格式**：每条 IC 交易（`IcTransactionEntity`）固定拆成 3 行 —— 1 个 Header (`H`) + 2 个 费用行 (`D`，`P0005` / `OTH-PS`）。从会计视角看，这 3 行同属"一笔分录"，应共用一个内部凭证编号，便于在下游账务系统按编号回溯到同一笔 IC 交易。

当前实现把 `internalTransNo` 按"每条 Final 记录递增 1"的方式赋值，导致同一笔分录的 H/D/D 三行编号不同（如 `0001/0002/0003`），与会计直觉相反，下游凭证匹配也难做。本次改造调整为"每笔 IC 交易取一个编号，3 行共用"。

同时，编号来源从当前的本进程内 `int` 计数器（每次链执行重置归零，跨实例 / 跨批次无唯一性）切换到框架统一发号服务 `GlobalMonotonicService.nextEpoch("INTERNAL_TRANS_NO")`，以获得**跨进程、跨时段单调递增**的全局唯一编号。

## 现状描述

代码位置：`expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/node/ic/transfinal/Node2IcTransFinalCalc.java:91-178`

当前 `buildIcTransFinal(meta)` 内的赋值逻辑：

- 第 101 行 `int index = 0;`，每个 `IcTransFinalMetaItem` 处理一开始就归零
- 第 105 / 111 / 117 行：依次为 H / P0005 / OTH-PS 调用 `buildFinalEntity(..., ++index)`
- 第 154 行：`entity.setInternalTransNo(CustomTypeConvertUtils.toFourDigits(index));`
- `toFourDigits` 把整数补零成 4 位字符串

**当前产出形态**：假设 `meta.icTransactionList` 有 3 条 IC 交易 → 生成 9 条 Final 记录，`internalTransNo` 依次为 `0001` ~ `0009`，每 3 条对应同一笔 IC 交易但编号互不相同。

旁路情况：

- `IcTransactionFinalChangeEntity` 通过 `BeanUtils.copyProperties(finalEntity, change)` 把 `internalTransNo` 复制过来（`buildIcTransFinalChange`，第 73-89 行），与 Final 主表保持一致
- `CustomTypeConvertUtils.toFourDigits` 经全仓库 grep 仅此一处调用，无其他业务依赖
- IC_TRANS 链（非 Final）的 `IcTransactionEntity` 字段集合中没有 `internalTransNo`，本改造与 IC_TRANS 链无交集

## 新需求描述

1. **共用编号**：同一 `IcTransactionEntity` 生成的 3 条 `IcTransactionFinalEntity`（H + P0005 + OTH-PS）的 `internalTransNo` 取值必须完全相同
2. **不同交易区分**：不同 `IcTransactionEntity` 产生的 `internalTransNo` 必须不同（哪怕在同一次链执行中、同一个 `IcTransFinalMetaItem` 内）
3. **来源切换**：`transNo` 不再由本进程整数计数器派生，改为调用 `GlobalMonotonicService.nextEpoch("INTERNAL_TRANS_NO")` 获取
4. **调用粒度**：**每条 IC 交易调用一次**（不是每条 Final 记录），调用返回值在本交易内的 3 行 Final 共用
5. **编号格式**：`nextEpoch` 返回 `long`，调用方负责 `String.valueOf(...)` 转字符串；**放弃 4 位前导零格式化**（详见"已确认前置条件 / 假设"A4）
6. **联动**：`IcTransactionFinalChangeEntity` 的 `internalTransNo` 与对应 `IcTransactionFinalEntity` 保持一致（当前 `BeanUtils.copyProperties` 已自动满足，无需额外动作，但 AC 写入便于验收）

## 已确认前置条件 / 假设

> 本段为"已确认假设" + "仍需 TA 复核的假设"的混合清单。Q3 / Q4 / Q5 / Q6 / Q9 已由用户拍板（见各假设末尾标注），TA(architecture) 无需再回查框架包源码。

- **A1（已确认）**：`GlobalMonotonicService` 已在本服务依赖中（用户答 Q3），可直接通过 Spring 容器注入，**无需新增依赖坐标**。本任务**不属于** Yellow 边界扩张中的"新增依赖"项
- **A2（已确认）**：`nextEpoch(String key)` 接口契约由用户答 Q3 锁定 —— 同步阻塞调用，每次返回**单调递增的 `long`**，分布式锁 / 序列由框架保证；不会返回 null、不会重复。此前的"由框架兜底"担保性表述已替换为"用户确认的契约"，TA(architecture) 无需再去框架包验证基础契约
- **A3（已确认）**：`nextEpoch` 返回类型为 `long`（用户答 Q3）；调用方负责 `String.valueOf(...)` 转字符串赋给 `String internalTransNo` 字段
- **A4（已确认）**：放弃"4 位补零"约束（用户答 Q4）。具体口径拆分：
  - **schema 层面**：`internal_trans_no` 列类型是 `String`，无长度强约束
  - **业务层面**：用户拍板放弃 4 位前导零格式化，新编号长度由 `GlobalMonotonicService` 的 `long` 取值范围决定（通常多于 4 位）
  - 与 PDF 团队的对齐仍要走 RA(finalize)（Q1 / Q2 仍在待澄清）
- **A5（已确认）**：`nextEpoch` 的语义是"**每次重算取新号**"（用户答 Q5），**不是**"按业务键幂等返回相同号"。即同一 `globalInterlink + version` 多次跑链产生不同 `internalTransNo`。Kafka 重投 / 重复行去重不在本任务范围（见"已知问题"段）
- **A6（保留）**：本改造不动 IC_TRANS（非 Final）链，不动 `Node1IcFinalTrigger` / `Node3IcFinalSave`，不动 `IcTransactionFinalEntity` / `IcTransactionFinalChangeEntity` 的字段定义
- **A7（已确认 + 补充）**：`CustomTypeConvertUtils.toFourDigits` 在本次改造后**不再被任何业务调用**，是否物理删除该方法属 TA(architecture) 的 Surgical Changes 判断；**`CustomTypeConvertUtils` 工具类整体保留**（类内还有 `string2Integer` 等其他公用方法），TA 删除时仅作用于 `toFourDigits` 一个方法，**不要误删整个工具类**

## 异常 / 行为约定

> Q6 与 Q9 已由用户拍板，本段为对应行为约定的落地。

- **单条 transaction 失败 → log.error + skip**：循环处理 `meta.icTransactionList` 时，若某条 `IcTransactionEntity` 调用 `nextEpoch` 抛异常：
  1. 当前 transaction 派生的 H / P0005 / OTH-PS **3 行 Final 都不入** `meta.icTransactionFinalList`（避免半部落库 / 避免 `internalTransNo` 为 null 落地）
  2. 节点不中断，循环继续处理下一条 `IcTransactionEntity`
  3. 该失败 transaction 仅 `log.error("...", e)`，遵循 `process()` 外层吞异常约定
- **节点完成态**：节点跑完后 `icTransactionFinalList` 中只存在"全部成功的 transaction 对应的 3 行 Final"，不会出现"半组"（仅 H 没 D、或仅 D 没 H）
- **并发**：当前 IC_TRANS_FINAL 链节点是单线程顺序循环（Q7 已确认），`nextEpoch` 调用顺序与 `icTransactionList` 迭代顺序一致

## 验收标准

- AC-1：同一条 `IcTransactionEntity` 派生的 3 条 `IcTransactionFinalEntity`（`indicator='H'` / `chargeCode='P0005'` / `chargeCode='OTH-PS'`）的 `internalTransNo` 取值完全相同
- AC-2：同一次链执行中，不同 `IcTransactionEntity` 之间的 `internalTransNo` 不相同
- AC-3：`internalTransNo` 值由 `GlobalMonotonicService.nextEpoch("INTERNAL_TRANS_NO")` 提供 —— 每条 IC 交易调用一次，**且发号顺序与 `icTransactionList` 的迭代顺序一致**（QA 可用 Mockito 验证 invocation count 与顺序）；调用方对 `long` 返回值做 `String.valueOf(...)` 后赋给该交易 3 行 Final 的编号
- AC-4：每条 `IcTransactionFinalChangeEntity` 与其对应的 `IcTransactionFinalEntity` 的 `internalTransNo` 一致
- AC-5：IC_TRANS_FINAL 链跑通后落库的 `ic_transaction_final` 与 `ic_transaction_final_change` 两表中，同笔 IC 交易的 3 行记录在 `internal_trans_no` 列上呈"3 行同值、按交易分组"的形态，不再出现"按记录行递增"的形态
- AC-6：发号服务调用失败时的可观察终态：当 `nextEpoch` 对某条 `IcTransactionEntity` 抛异常时，**该 transaction 派生的 H / P0005 / OTH-PS 3 行 Final 都不在** `meta.icTransactionFinalList` 中；其他成功 transaction 的 3 行 Final 正常存在；节点不中断，整批不退出（QA 据此设计 negative 用例：mock `nextEpoch` 在第 N 条交易抛异常，断言列表中缺失该交易的 3 行，其他交易 3 行齐全）

## 影响范围

- **改动点**：仅 `Node2IcTransFinalCalc.buildIcTransFinal`（以及为引入 `GlobalMonotonicService` 而调整的构造器注入）
- **现有需求**：`REQ-202604300018` 的"字段值固定/派生规则"段第 30 行（"4 位自增序号，按本次生成顺序排列"）需 amends，由 RA(finalize) 操作
- **PDF 团队**：`internal_trans_no` 字段本身**保留**，只是取值方式变了 —— 同组 3 行由不同值变成相同值、跨记录序列从"全局连号 4 位"变成"按交易跳号、长度由 `long` 决定的单调递增"。需在 RA(finalize) 前与 PDF 团队对齐 Q1 / Q2（见"待澄清"段）
- **下游账务系统**：若有按编号回溯凭证的需求，此次改造**正向**改善（按编号能精确定位到一笔分录），但需告知下游编号格式 / 位数会变（4 位 → 长度由发号服务决定）
- **`CustomTypeConvertUtils.toFourDigits`**：本仓库无其他调用方，本次改造后成孤儿方法；工具类本身保留
- **IC_TRANS / FREIGHT_LIST 链**：不影响

## 实现层面备注（待 TA 拆解）

- 参照 `Node3IcFinalSave.java:30` 的构造器注入模式，`Node2IcTransFinalCalc` 新增 `private final GlobalMonotonicService globalMonotonicService;` 字段 + 构造器接收
- 不写字段 `@Autowired`（参见 `.claude/docs/conventions.md`）

## 范围边界

- **不动**：
  - IC_TRANS 链（`Node1Trigger` / `Node2ChargeMatching` / `Node3ChargeOffset` / `Node4Calc` / `Node5Save`）
  - IC_TRANS_FINAL 链的 `Node1IcFinalTrigger` 与 `Node3IcFinalSave`
  - `IcTransactionFinalEntity` / `IcTransactionFinalChangeEntity` 字段定义与表结构
  - DB 表 `ic_transaction_final` / `ic_transaction_final_change` 的 schema
  - `internalTransNo` 字段名 / 列名 / 类型（仍是 `String` / `internal_trans_no`）
  - `BeanUtils.copyProperties` 复制 Change 的逻辑
- **已确认不受影响（评审交叉验证）**：
  - **IC_TRANS（非 final）链的 `internalTransNo` 字段** —— 已 grep 验证 `IcTransactionEntity` 不含 `internalTransNo` 字段，IC_TRANS 链与本次改造无交集（原 Q10 升级）
  - **`IcTransactionEscalateEntity`（下游 escalate 表）** —— 已 grep 验证不含 `internalTransNo` 字段，escalate 表不受影响（原 Q11 升级）
- **不属于本任务**：
  - 新增 IC Final 记录种类 / 改变拆分规则（H + 2D 不变）
  - 调整 `transType` / `shareType` / `amount` 等其他字段派生规则
  - 物理删除 `CustomTypeConvertUtils.toFourDigits`（TA 视情况决定是否一并清理）
  - 历史已落库 `ic_transaction_final` 数据的回填（不向下兼容旧编号）
  - 修复 Kafka 重放导致的重复行问题（详见"已知问题"段）

## 已知问题（不在本任务修复）

- **Kafka 重放 + Node3Save 无 upsert 导致重复行 `internalTransNo` 不一致**（原评审 Q8）：
  - 背景：`IcTransFinalListener` 监听 `bus_ic_trans_final_queue_v1`，Kafka 默认 at-least-once，**同一消息可能被消费多次**；每次消费都走完整链 → 每次都调 `nextEpoch` → 同一笔 IC 交易在 `ic_transaction_final` 表中**多次落库且 `internalTransNo` 不同**
  - 当前实现：`Node3IcFinalSave` 是纯 `saveBatch`、无按业务键删除历史再插入的逻辑（grep 未见删除调用），重复消费会产生多组重复行
  - 与本任务的关系：本任务的改造让"重复行的 `internalTransNo` 不一致"从隐性（同进程 `++index` 重置归零后号段重叠 → 重复消息可能巧合产生相同号段）变成显性（`nextEpoch` 每次产生不同号 → 必然不同）。**本任务不修此问题**，仅在此显式记录，便于后续 owner 单独立项处理
  - 后续处理：建议另起 case 评估"是否给 IC_TRANS_FINAL 落库节点加按 `globalInterlink + version` upsert / 去重逻辑"，但与本任务无依赖

## 待澄清问题

> 仅剩 Q1 / Q2 两条，**阻塞 RA(finalize)**（需与 PDF 团队对齐），**不阻塞** TA(architecture)。
> 原 Q3 / Q4 / Q5 / Q6 / Q9 已由用户拍板落入"已确认前置条件 / 假设"与"异常 / 行为约定"。
> 原 Q7（并发）已确认单线程顺序循环。
> 原 Q10 / Q11 已升级为"范围边界已确认"。

- 🟡 **Q1（PDF / 下游，阻塞 finalize）**：PDF 团队 / 下游账务系统是否以 `internal_trans_no` 作为**行级唯一键**进行匹配？若是，"H + 2D 同值"会破坏匹配，需要下游同步调整或拒绝本次改造。
- 🟡 **Q2（PDF / 下游，阻塞 finalize）**：下游是否依赖 `internal_trans_no` 进行排序展示？若是，跨记录"跳号 / 非连续"以及"长度从 4 位变成更长"是否可接受？

## 初步风险等级建议

🟡 **Yellow**（保持不变，详细判定见 `AI_Risk_Level.md`）

主要理由：
- LiteFlow 节点算法层改造，**不**触及 Node5ProfitShare / Node10Exception / Node11Save 等"共享果子 / 唯一落库点"
- 字段值（`internal_trans_no`）属于下游 PDF 团队可见的落库列，取值规则变化需对外对齐
- 引入新外部服务调用 `GlobalMonotonicService.nextEpoch`，虽用户已确认依赖存在（A1），但仍属"新增对外调用"，按仓库默认归 Yellow
