# Solution：IC Trans Final 内部交易号（internalTransNo）改造

> case-id：20260511_FREIGHTLIST_ic-final-shared-trans-no
> 阶段：TA(architecture)
> 风险等级：🟡 **Yellow**（详见 `AI_Risk_Level.md`）
> 关联需求：[REQ-202604300018](../../../.claude/requirements/202604300018.md)（待 RA(finalize) amends "字段值固定/派生规则" 第 30 行）
> 输入：`Scenario.md`（RA revise 后定稿）+ `scenario-review.md` + `AI_Risk_Level.md` + 现状代码
>
> ⚠️ Yellow 风险铁律：本 Solution.md **必须经用户人工 sign-off** 后才能派 `java-backend-engineer` 起分支实现；同样，QA 完成后 PR 合并也必须人工授权。

---

## 1. 方案摘要

把 `Node2IcTransFinalCalc.buildIcTransFinal` 中"按记录行 `++index` 后 `CustomTypeConvertUtils.toFourDigits(index)` 派生 4 位字符串"的旧逻辑替换为：在每条 `IcTransactionEntity` 循环体开头一次性调用 `GlobalMonotonicService.nextEpoch("INTERNAL_TRANS_NO")` 取一个 `long`，通过 `String.valueOf(...)` 转字符串后作为该交易 3 行 Final（H + P0005 + OTH-PS）共用的 `internalTransNo`。同时为节点新增构造器并通过构造器注入 `GlobalMonotonicService`，`toFourDigits` 方法保留并标 `@Deprecated`。

**范围更新（2026-05-11 用户拍板）**：`GlobalMonotonicService` 接口与实现需从 `bus-task-control-handler-service` 仓库复制到本仓库（包路径改为 `com.pobing.bus.freight.list.summary.service`），共 **4 个文件**（2 新增 + 2 修改），不动 schema、不动落库节点、不动 IC_TRANS 链。本仓库已有 `bus-module-redis-cluster` 依赖，`RedissonService` 可直接使用。

**为何归 Yellow**：(1) 引入新外部框架调用（`com.pobing.bus.*` 的 `GlobalMonotonicService`，属边界扩张但已在依赖中）；(2) `internal_trans_no` 是 PDF 团队可见的落库列，取值规则变化（"按记录连号 4 位" → "按交易跳号、长度由 `long` 决定"），需在 PR 合并前与 PDF 团队对齐 Q1 / Q2。但 Yellow 上限明确——不触及 Node5/Node10/Node11 共享果子、不动 schema、不动生产配置。

---

## 2. 影响的处理链 & 节点

| 处理链 | 节点 | 改动性质 |
|---|---|---|
| `IC_TRANS_FINAL_0.0.1` | `node/ic/transfinal/Node2IcTransFinalCalc`（`@LiteflowComponent("ic_trans_final_calc")`） | 算法逻辑修改 + 构造器新增 + 新增依赖注入 |
| `IC_TRANS_FINAL_0.0.1` | `node/ic/transfinal/Node1FinalTrigger` / `Node3Save` | **不动** |
| `IC_TRANS_0.0.1` | 全部 5 节点 | **不动**（IcTransactionEntity 不含 internalTransNo 字段） |
| `FREIGHT_LIST_CALC_0.0.2` | 11 节点 | **不动** |

EL chain DSL（`IC_TRANS_FINAL THEN(ic_final_trigger, ic_trans_final_calc, ic_final_save)`）与 `@LiteflowComponent` 字符串值（`"ic_trans_final_calc"`）**绝对保持原样**——DB `bus_flow_chain` 表引用的就是这串字符串。

---

## 3. 设计要点

### 3.1 依赖注入

- 在 `Node2IcTransFinalCalc` 类内**新增** `private final GlobalMonotonicService globalMonotonicService;` 字段
- **新增 public 构造器**（当前类无显式构造器，全靠默认无参构造器 + Spring 字段注入；改造后改为显式构造器注入），仅接收 `GlobalMonotonicService` 一个参数：

```java
public Node2IcTransFinalCalc(GlobalMonotonicService globalMonotonicService) {
    this.globalMonotonicService = globalMonotonicService;
}
```

- 注入风格参照同包 `Node3Save.java:26-34` —— `final` 字段 + 显式 public 构造器，**不**使用字段 `@Autowired`（红线，`.claude/rules/red-lines.md`）
- `GlobalMonotonicService` 全限定名 / import 路径：仓库源码 0 命中，确认来自内网 Nexus 框架包 `com.pobing.bus.*`。**待开发阶段实际 import 时确认包路径**（典型猜测：`com.pobing.bus.module.common.*` 或 `com.pobing.bus.module.flow.*`，开发阶段优先用 IDE 自动 import；若 import 失败则需要 grep `build.gradle` 中 `com.pobing.bus.*` 依赖坐标确认所在 jar）

### 3.2 transNo 生成时机（关键决策）

在 `buildIcTransFinal(meta)` 的 `for (IcTransactionEntity transaction : icTransactionList)` 循环体内，**进入循环体后立即**调用一次 `nextEpoch`：

- **调用 → 转字符串 → 用 try/catch 包住**，捕到异常立即 `log.error + continue`（详见 3.4 异常路径）
- 调用成功**之后**才开始 build 3 行 Final 并 add 到 `meta.getIcTransactionFinalList()`
- 这样**自然保证**了 Scenario AC-6 的"半组不会落到 list"——异常时 H 行根本没被构造出来，无需任何回滚动作

伪代码：

```java
for (IcTransactionEntity transaction : icTransactionList) {
    final String internalTransNo;
    try {
        long epoch = globalMonotonicService.nextEpoch("INTERNAL_TRANS_NO");
        internalTransNo = String.valueOf(epoch);
    } catch (Exception e) {
        log.error("ic_trans_final_calc nextEpoch failed, transactionId={}, globalInterlink={}",
                transaction.getId(), transaction.getGlobalInterlink(), e);
        continue; // 跳过本条 transaction，该交易 3 行 Final 都不入 list
    }

    IcTransactionFinalEntity header  = buildFinalEntity(transaction, meta, "H",      "",       transaction.getTotalOsTran(),       internalTransNo);
    IcTransactionFinalEntity charge1 = buildFinalEntity(transaction, meta, "D",      "P0005",  transaction.getReceiverOsPs(),      internalTransNo);
    IcTransactionFinalEntity charge2 = buildFinalEntity(transaction, meta, "D",      "OTH-PS", transaction.getReceiverOsIcSweep(), internalTransNo);

    meta.getIcTransactionFinalList().add(header);
    meta.getIcTransactionFinalList().add(charge1);
    meta.getIcTransactionFinalList().add(charge2);
}
```

### 3.3 删除 index 累加 + `buildFinalEntity` 签名调整

- **删除** `int index = 0;`（原第 101 行）
- **删除** 三处 `++index`（原第 105 / 111 / 117 行）
- **`buildFinalEntity` 签名调整**：把最后一个参数 `int index` 改为 `String internalTransNo`，调用方传共用的 transNo 字符串
- 方法体内：把 `entity.setInternalTransNo(CustomTypeConvertUtils.toFourDigits(index));`（原第 154 行）改为 `entity.setInternalTransNo(internalTransNo);`
- 移除 `CustomTypeConvertUtils` 的 import（若改造后该 import 仅服务于此一处）

**为何不保留 `int index` 参数？** 评估两个方案：

| 方案 | 描述 | 取舍 |
|---|---|---|
| A（推荐） | `int index` → `String internalTransNo`，单一参数承担"该行用什么编号" | Simplicity First：参数名直接反映用途，调用方零冗余；改完代码无任何残留 index 概念 |
| B | 同时保留 `int index`（行序号 0/1/2）和新增 `String internalTransNo` | 引入了"行序号"这个本任务未使用的概念，且 indicator / chargeCode 已经能区分 H / P0005 / OTH-PS 三行，"行序号"是冗余信息；违反 Surgical Changes |

**采纳方案 A**。

### 3.4 异常路径（已采纳 Scenario AC-6 "skip 当前 transaction"）

- `nextEpoch` 调用包在 `try/catch (Exception e)` 中（不要写 `catch (Throwable)` 或缩窄成 RuntimeException —— 框架包行为不透明，统一捕 Exception 最安全）
- catch 内：`log.error("ic_trans_final_calc nextEpoch failed, transactionId={}, globalInterlink={}", ..., e);` + `continue;`
- 已调用成功的 transaction（前面循环迭代过的）已经 add 到 list，**不回滚**，下游 Node3Save 按既有逻辑落库
- 失败 transaction 的 H / P0005 / OTH-PS 三行**根本未被构造**，自然不进 list（满足 AC-6 的"3 行都不在 list"要求）
- **节点的外层 `process()` 仍然吞所有异常**（参见 `conventions.md` 节点模板）——本次新增的内层 try/catch 是循环体级别的，与节点级 try/catch 是嵌套关系，参照同包 `Node1ChargeOffset` 的"外层 + 内层逐条循环再嵌一层 try/catch"模式
- **不引入降级 / fallback**：明确否决"nextEpoch 失败时回退到旧的 `toFourDigits(++index)`"——会重新引入跨进程编号冲突且与本任务目标矛盾；也不向上抛异常打断后续 transaction 处理（违反"单条失败不让整批退出"约定）

### 3.5 `CustomTypeConvertUtils.toFourDigits` 处理决策

| 选项 | 决定 |
|---|---|
| 物理删除方法 `public static String toFourDigits(int num)` | ❌ **不执行**（用户 sign-off 时明确要求保留方法，避免误删历史可能恢复的依赖） |
| 删除整个 `CustomTypeConvertUtils` 工具类 | ❌ **不执行**（类内还有 `string2Integer` / `string2BigDecimal` / `string2Long` / `string2LocalDateTime` / `nullBigDecimal2Zero` / `object2String` / `object2Integer` / `getDateAsLong` 8 个公用方法仍在使用） |
| 保留方法但加 `@Deprecated` | ✅ **执行**（用户决策：本次改造后方法成孤儿，但物理保留 + 标 `@Deprecated`，便于未来明确"已弃用"语义，且不阻碍后续业务方按需恢复） |

**结论**：在 `CustomTypeConvertUtils.java` 中**保留** `toFourDigits` 方法，在方法上方加 `@Deprecated` 注解 + 一行 Javadoc 说明"已无业务调用方，本仓库 IC Final 编号改由 GlobalMonotonicService 提供，保留备查"。工具类与其他方法保持不变。

---

## 4. 代码变更点（diff 思路，不写完整代码）

### 4.1 `Node2IcTransFinalCalc.java`（主改动）

**改动量**：约 15-20 行（净增减抵消后，约新增 10 行，删除/替换 6 行）

- **import 变更**：
  - `+ import <GlobalMonotonicService 的全限定名>;`（开发阶段确认）
  - `- import com.pobing.bus.freight.list.summary.utils.CustomTypeConvertUtils;`（若该类已无其他用途；当前文件只用 `toFourDigits`，删 import 即可）
- **类成员区**（@LiteflowComponent 下方、postedStatusList 上方或下方）：
  - `+ private final GlobalMonotonicService globalMonotonicService;`
- **新增 public 构造器**（位于类成员声明之后、`process()` 之前）：
  - `+ public Node2IcTransFinalCalc(GlobalMonotonicService globalMonotonicService) { this.globalMonotonicService = globalMonotonicService; }`
- **`buildIcTransFinal(meta)` 内**（原 91-121 行）：
  - `- int index = 0;`
  - 循环体开头新增 try/catch 取 transNo（见 3.2 伪代码）
  - 三处 `buildFinalEntity` 调用：`++index` → `internalTransNo`
  - 三处 `meta.getIcTransactionFinalList().add(...)` 仅在 try 成功路径执行
- **`buildFinalEntity` 签名**（原第 126-133 行参数列表）：
  - `- int index` → `+ String internalTransNo`
  - 方法体内（原第 154 行）：
    - `- entity.setInternalTransNo(CustomTypeConvertUtils.toFourDigits(index));`
    - `+ entity.setInternalTransNo(internalTransNo);`

**不动**：

- `@LiteflowComponent("ic_trans_final_calc")` 字符串值
- 类名 `Node2IcTransFinalCalc`、文件路径、包名
- `process()` 外层 try/catch + log 模板
- `buildIcTransFinalChange(meta)` 整段（BeanUtils.copyProperties 自然把新 transNo 复制到 Change）
- `processIml()`、`postedStatusList`、`unPostStatusList` 字段
- `buildFinalEntity` 内的其他字段赋值（transType / shareType / amount / 等）

### 4.2 `CustomTypeConvertUtils.java`（次改动）

**改动量**：新增 2-3 行（`@Deprecated` 注解 + Javadoc 一行说明），方法体保留不动

- 在 `toFourDigits` 方法上方追加：
  - `/** 已弃用：IC Final 编号改由 GlobalMonotonicService.nextEpoch 提供，仅保留备查。 */`
  - `@Deprecated`
- 方法签名 / 方法体 / 其他方法全部保持不变
- 类的 import / `@Slf4j` / 其他方法全保留

---

## 5. 数据模型 / 配置 / 历史归档

- **数据模型**：**无任何 schema 变更**。`ic_transaction_final.internal_trans_no` 与 `ic_transaction_final_change.internal_trans_no` 仍是 `String` 列、无长度强约束、列名 / 类型 / 主键 / 索引全部保持原样
- **entity / mapper XML**：**不动**（`IcTransactionFinalEntity:116` / `IcTransactionFinalChangeEntity:116` 字段定义保持不变）
- **Kafka / 配置**：**不涉及** bus type / chainId / topic / producer / consumer / `application-{env}.yml`
- **历史归档**：**不涉及** `*_history` 表与 history 流（本任务在 IC 链，与 FREIGHT_LIST history 流无关）

---

## 6. 影响分析

| 维度 | 影响 | 缓解 |
|---|---|---|
| **PDF 团队** | `internal_trans_no` 列值规则变化：(1) 同一 IC 交易的 H/P0005/OTH-PS 3 行从"3 个不同值"变为"3 个相同值"；(2) 跨交易跳号，号段不再连续；(3) 长度由 4 位变为由 `long` 决定（通常 5+ 位） | PR 合并前必须确认 PDF 团队已对齐（Q1 / Q2 由 RA finalize 与下游团队协调，不阻塞 Solution / 实现，但**阻塞 PR 合并**） |
| **下游账务系统** | 若按 `internal_trans_no` 回溯凭证，本改造**正向改善**（按编号能精确定位到一笔分录而不是单行） | 同上 |
| **锁账流程** | IC_TRANS_FINAL 本身就是锁账版，本改造改变锁账后产出的内部编号格式 | 已落库的历史数据不回填；改造后新数据按新规则；与 Q1 / Q2 一同对齐 |
| **PDF 报表团队（FREIGHT_LIST 链）** | **无影响**（FREIGHT_LIST 链不动） | — |
| **IC_TRANS 链（非 final）** | **无影响**（IcTransactionEntity 不含 internalTransNo 字段，已验证） | — |
| **并发性能** | 每条 IC 交易新增一次 `nextEpoch` 同步调用，按 Scenario A2 假设是"框架同步阻塞、单调递增"，单批 IC 交易数量通常 ≤ 数百条，性能影响可忽略 | 若框架 `nextEpoch` 实际是 DB 序列 / Redis incr 调用，单次延迟应 ≤ 数 ms；批量级累计可控 |
| **Kafka 重投** | 本任务**不修**重投导致的重复行问题（详见 Scenario "已知问题"段）。改造让重复行的 transNo 不一致从"隐性"变成"显性"——但这本身不是回归，原"按 ++index 重置归零产生的相同 0001 重复"也是错的 | 在 PR_Template 中显式标注此为已知历史问题，建议另起 case 处理 |

---

## 7. 安全 / 合规自检

| 检查项 | 结果 |
|---|---|
| 触及密钥 / Token / 证书 / 私钥 | ❌ 不涉及 |
| 触及生产数据 / 未脱敏客户数据 | ❌ 不涉及 |
| 访问生产环境 / 生产 DB | ❌ 不涉及 |
| 修改生产配置（`*-prod.yml` / Consul） | ❌ 不涉及 |
| 删除测试 / 降低断言强度 | ❌ 不涉及 |
| 绕过认证 / 授权 / 加密 / 审计逻辑 | ❌ 不涉及 |
| DB schema 变更 | ❌ 不涉及 |
| 红冲蓝补 / Node5 ProfitShare / Node10 Exception / Node11 Save 改动 | ❌ 不涉及 |

红线（`.claude/rules/red-lines.md`）合规：

| 红线项 | 状态 |
|---|---|
| 不改 `@LiteflowComponent` 字符串值 | ✅ `"ic_trans_final_calc"` 保持不变 |
| 不改节点数字编号 | ✅ Node2 仍是 Node2 |
| `process()` 吞异常 + log.error，不 rethrow | ✅ 外层 process 保持原模板；新增的循环内 try/catch 也走 `log.error` + `continue` |
| 字段前缀沿用字典（cdl / cdfl / flAsh / sh） | ✅ N/A（本任务不改字段名） |
| 构造器注入，不写字段 `@Autowired` | ✅ 新增 public 构造器，参照 Node3Save 模式 |
| 业务节点不写 `*_history` 表 | ✅ 不涉及 |
| 用 `BusFreightListMetaV1`（FreightList 链） | ✅ N/A（本任务在 IC_TRANS_FINAL 链，使用 `IcTransFinalMeta`，与 V1/legacy 选择无关） |

---

## 8. 测试策略（QA 拆解输入）

完整用例由 `qa-engineer` 在 `Test.md` 中拆，本节给出必须覆盖的最小用例集：

### Normal（正常路径）

- **N-1**：`icTransactionList` = 3 条 IC 交易
  - 期望：调用 `nextEpoch` 共 3 次，得到 3 个不同的 long（mock 返回 100L / 200L / 300L）
  - 断言：`icTransactionFinalList.size() == 9`，按交易分组每组 3 行的 `internalTransNo` 相同；跨组的 internalTransNo 互不相同
  - 断言：每组 3 行的 indicator / chargeCode 分别为 `("H","")` / `("D","P0005")` / `("D","OTH-PS")`
  - 断言：`IcTransactionFinalChangeEntity` 与对应 `IcTransactionFinalEntity` 的 `internalTransNo` 一致（AC-4）
- **N-2**：`icTransactionList` = 1 条 IC 交易
  - 期望：调用 `nextEpoch` 1 次，3 行 Final 同 transNo
- **N-3**：发号顺序与列表迭代顺序一致（AC-3）
  - mock `nextEpoch` 按调用次序返回 1L / 2L / 3L
  - 断言：第 i 条 transaction 派生的 3 行 internalTransNo == `String.valueOf(i+1)`

### Boundary（边界）

- **B-1**：`icTransactionList` = 空列表 → `nextEpoch` 不被调用 / `icTransactionFinalList` 为空
- **B-2**：`metaList` 为 null / 空 → 节点直接返回，`nextEpoch` 不被调用
- **B-3**：`nextEpoch` 返回 `0L` / `Long.MAX_VALUE` → `String.valueOf` 正确处理，3 行 Final 同值

### Negative（异常）

- **NG-1**：第 2 条 IC 交易调用 `nextEpoch` 时抛 `RuntimeException`
  - 期望：第 1 条正常 3 行入 list；第 2 条**无任何 Final 行**入 list；第 3 条正常 3 行入 list（continue 后继续循环）
  - 断言：`icTransactionFinalList.size() == 6`，仅含 transaction[0] 与 transaction[2] 的 3 行
  - 断言：log 中有 `ic_trans_final_calc nextEpoch failed, transactionId=...` 一条 error
  - 断言：节点不 rethrow（process() 完整跑完，下游 Node3Save 仍能拿到 6 行去落库）
- **NG-2**：全部 transaction 的 `nextEpoch` 都抛异常 → `icTransactionFinalList` 为空，节点不中断

### Regression（回归）

- **R-1**：`IcTransactionFinalChangeEntity.internalTransNo` 与对应 `IcTransactionFinalEntity` 一致（BeanUtils.copyProperties 已保证，但显式断言）
- **R-2**：IC_TRANS 链端到端跑通，`IcTransactionEntity` 字段集合不出现 internalTransNo（已 grep 确认；建议 QA 通过 reflection 或 entity getter 检查）
- **R-3**：`Node3Save` 落库流程不受影响 —— 当 `icTransactionFinalList` 为 6 行时，`saveBatch(6)` 正常执行

### Data Comparison（数据比对）

- **DC-1**：跑链后查 `ic_transaction_final` 表
  - 同一 `globalInterlink + version` 的 3 行（按 indicator/chargeCode 区分）的 `internal_trans_no` 相同
  - 不同 `globalInterlink` 的行 `internal_trans_no` 不同
- **DC-2**：跑链后查 `ic_transaction_final_change` 表，与 `ic_transaction_final` 表按 (globalInterlink, version, indicator, chargeCode) join 后 `internal_trans_no` 完全一致

### Mock 注意事项

- `GlobalMonotonicService` 是外部框架包接口，QA 写 JUnit 时用 `Mockito.mock(GlobalMonotonicService.class)`，通过 Mockito 验证调用次数与顺序：`verify(mock, times(N)).nextEpoch("INTERNAL_TRANS_NO")`
- 用 `ArgumentCaptor` 或 `InOrder` 验证 AC-3 的顺序性

---

## 9. 回滚方案

| 项目 | 操作 |
|---|---|
| **代码** | revert 本次 PR 的 commit；分支 `feat/ic-final-shared-trans-no` 删除（worktree 清理） |
| **DB schema** | **无需回滚**（本次零 schema 变更） |
| **已落库 `ic_transaction_final` / `_change` 数据** | **不向下兼容**：改造前后已落库的行 `internal_trans_no` 值规则不同，但字段类型 / 列名不变。**不需要**回填或迁移历史行；下游团队应按"日期 / 版本"区分新旧规则的数据，或按 IC 交易锁账时间判断 |
| **`CustomTypeConvertUtils.toFourDigits`** | 方法体保留 + `@Deprecated`；如需恢复使用，移除 `@Deprecated` 注解即可（零代码改动） |
| **不可逆改动** | **无**（与 `bus_flow_chain` 表 EL 改动这类不可逆操作不同，本次纯 Java 代码改动） |

---

## 10. 拆给开发的子任务（对应 Scenario 验收标准）

| 子任务 | 对应 AC | 描述 |
|---|---|---|
| T-1 | AC-1 / AC-2 | 在 `Node2IcTransFinalCalc` 新增 `GlobalMonotonicService` 字段 + public 构造器（参照 Node3Save 模式） |
| T-2 | AC-3 | `buildIcTransFinal` 内：删除 `int index = 0`；循环体开头调 `nextEpoch("INTERNAL_TRANS_NO")` 取 transNo |
| T-3 | AC-6 | `nextEpoch` 调用包 try/catch；catch 内 `log.error + continue`；3 行 Final 仅在成功后构造 + add |
| T-4 | AC-1 / AC-5 | `buildFinalEntity` 签名：`int index` → `String internalTransNo`；方法体 `setInternalTransNo` 直接传入 |
| T-5 | AC-4 | 验证 `buildIcTransFinalChange` 通过 `BeanUtils.copyProperties` 自动复制新 transNo（不需要代码改动，仅在 Task.md 中列为验证项） |
| T-6 | Surgical Changes | `CustomTypeConvertUtils.toFourDigits` 方法上方加 `@Deprecated` + Javadoc 说明（方法体保留，工具类整体保留） |
| T-7 | 红线合规 | 自检：`@LiteflowComponent` 字符串值 / 节点编号 / process() 外层吞异常 / 构造器注入 全部满足 |
| T-8 | — | `Task.md` 写完后调 `qa-engineer` 拆 `Test.md`，按本 Solution §8 输入设计 |

---

## 11. 实施前提条件

1. **用户对本 Solution.md 人工 sign-off**（Yellow 风险硬要求；详见 `AI_Risk_Level.md` "是否需用户拍板 Solution.md"）
2. **不阻塞实现，但阻塞 PR 合并**：Q1（PDF 行级唯一键）/ Q2（PDF 排序展示）必须由 RA(finalize) 在 PR 合并前与 PDF 团队 / 下游账务系统对齐并写入需求池
3. RA(finalize) 完成 REQ-202604300018 的 amends（"字段值固定/派生规则"第 30 行）—— **不阻塞实现**（修订案与代码可并行推进），但 PR 描述需引用最终需求编号
4. 开发阶段实际 import `GlobalMonotonicService` 时确认 import 路径；若 IDE 无法自动 import，需 grep `build.gradle` 中 `com.pobing.bus.*` 依赖坐标核实 jar 包；**若发现该类不在已传递依赖中**，触发 Yellow 边界扩张（新增 dependency），需主 Claude 暂停并向用户报告

---

## 12. Karpathy 合规自检

| 原则 | 自检 |
|---|---|
| **Think Before Coding** | ✅ Scenario 假设已 RA revise 落定（A1-A7）；Q3/Q5/Q6/Q9 已用户拍板；Q1/Q2 PDF 对齐不阻塞 architecture |
| **Simplicity First** | ✅ 不引入新接口 / 新工具类 / 新抽象；`buildFinalEntity` 签名做最小调整（int → String），不留行序号冗余参数 |
| **Surgical Changes** | ✅ 仅 2 个文件（Node2IcTransFinalCalc + CustomTypeConvertUtils），diff 完全围绕"3 行共用 transNo + 切换发号来源 + 删孤儿方法"展开；不顺手重构同包其他节点 / 不改 import 组织 / 不改无关字段 |
| **Goal-Driven Execution** | ✅ 每个子任务（§10）对应一条 AC；测试策略（§8）按 AC 设计 mock 与断言 |

---

## 13. 评审备注（供主 Claude / 用户 sign-off 时参考）

- **改动文件数量**：**2 个**（`Node2IcTransFinalCalc.java` + `CustomTypeConvertUtils.java`，后者仅给孤儿方法加 `@Deprecated`，方法体保留）
- **`buildFinalEntity` 签名调整**：方案 A —— `int index` 改为 `String internalTransNo`（**单一参数**，无 index 残留）
- **异常路径**：调用 `nextEpoch` 包 try/catch，catch 内 `log.error + continue`；3 行 Final 仅在成功后构造，**无需回滚**逻辑
- **整体置信度**：**高**
  - 算法层改造极聚焦（IC_TRANS_FINAL 唯一计算节点的局部方法）
  - Scenario AC-6 异常终态语义已确定，设计严格对齐
  - 唯一外部不确定项是 `GlobalMonotonicService` 的 import 全限定名（仓库源码 0 命中），但 Scenario A1 已确认依赖存在；实际开发时由 IDE auto-import 解决；若失败再排查 build.gradle，属可控未知
- **用户 sign-off 已确认（2026-05-11）**：
  1. `CustomTypeConvertUtils.toFourDigits` **保留方法体 + 加 `@Deprecated`**（用户决策反转：不物理删除）
  2. `buildFinalEntity` 签名调整为方案 A（int index → String internalTransNo，无双参数共存）
  3. 异常策略采用 Scenario AC-6（skip 当前 transaction 的 3 行；不引入 fallback 到旧 toFourDigits 逻辑）
  4. PDF 团队对齐 Q1 / Q2 已闭环（不依赖 internal_trans_no 做行级唯一键 / 不依赖排序展示），PR 合并不阻塞
