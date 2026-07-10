# Test.md：IC Trans Final 内部交易号（internalTransNo）改造

> case-id：20260511_FREIGHTLIST_ic-final-shared-trans-no
> 阶段：qa-engineer
> 产出日期：2026-05-11
> 输入文档：Solution.md §8、Scenario.md 验收标准 AC-1 ~ AC-6、code-review.md
> 测试文件：`expand/business-freightlist-summary/src/test/java/com/pobing/bus/freight/list/summary/node/ic/transfinal/Node2IcTransFinalCalcTest.java`

---

## 被测范围

| 文件 | 测试焦点 |
|---|---|
| `Node2IcTransFinalCalc.buildIcTransFinal` | 核心算法：internalTransNo 生成与共用逻辑 |
| `Node2IcTransFinalCalc.buildIcTransFinalChange` | Change 联动：BeanUtils.copyProperties 是否正确复制 internalTransNo |
| `IGlobalMonotonicService` | 通过 Mockito mock，验证调用次数与顺序 |

---

## 用例清单

### Normal 正常路径

| 编号 | 描述 | 前置条件 | 操作 | 期望结果 | 对应 AC |
|---|---|---|---|---|---|
| N-1 | 3 条 IC 交易，每组 3 行同值，跨组不同 | `icTransactionList` 有 3 条记录，mock `nextEpoch` 按顺序返回 100L / 200L / 300L | 调用 `buildIcTransFinal(meta)` | finalList.size()==9；第 0~2 行 internalTransNo=="100"；第 3~5 行=="200"；第 6~8 行=="300"；跨组 transNo 互不相同；`nextEpoch` 被调用 3 次 | AC-1 / AC-2 / AC-3 |
| N-2 | 1 条 IC 交易，3 行同 internalTransNo | `icTransactionList` 有 1 条，mock 返回 500L | 调用 `buildIcTransFinal(meta)` | finalList.size()==3；3 行 internalTransNo 均为 "500"；`nextEpoch` 被调用 1 次 | AC-1 |
| N-3 | 发号顺序与列表迭代顺序严格一致 | 3 条交易，mock 按顺序返回 1L / 2L / 3L | 调用 `buildIcTransFinal(meta)` | 第 i 条 transaction 的 3 行 internalTransNo == `String.valueOf(i+1)`；verify `nextEpoch` times(3) 且 key 均为 "INTERNAL_TRANS_NO" | AC-3 |

**N-1 详细断言**：
- 每组第 1 行 indicator=="H"，chargeCode==""
- 每组第 2 行 indicator=="D"，chargeCode=="P0005"
- 每组第 3 行 indicator=="D"，chargeCode=="OTH-PS"

---

### Boundary 边界用例

| 编号 | 描述 | 前置条件 | 操作 | 期望结果 | 对应 AC |
|---|---|---|---|---|---|
| B-1 | icTransactionList 为空列表 | `icTransactionList = new ArrayList<>()` | 调用 `buildIcTransFinal(meta)` | `icTransactionFinalList` 为空；`nextEpoch` 从未被调用 | AC-6（边界） |
| B-2 | icTransactionList 为 null | `icTransactionList = null` | 调用 `buildIcTransFinal(meta)` | `icTransactionFinalList` 为空；`nextEpoch` 从未被调用；不抛 NPE | AC-6（边界） |
| B-3 | nextEpoch 返回 0L 与 Long.MAX_VALUE | 2 条交易，mock 分别返回 0L、Long.MAX_VALUE | 调用 `buildIcTransFinal(meta)` | 第 1 组 3 行 internalTransNo=="0"；第 2 组 3 行 internalTransNo==`String.valueOf(Long.MAX_VALUE)`；不出现格式化错误 | AC-1 / AC-3（边界值） |

---

### Negative 异常路径

| 编号 | 描述 | 前置条件 | 操作 | 期望结果 | 对应 AC |
|---|---|---|---|---|---|
| NG-1 | 第 2 条交易 nextEpoch 抛 RuntimeException，第 1、3 条正常 | 3 条交易，mock 第 1 次返回 10L，第 2 次抛 RuntimeException，第 3 次返回 30L | 调用 `buildIcTransFinal(meta)` | finalList.size()==6；第 0~2 行 internalTransNo=="10"；第 3~5 行 internalTransNo=="30"；不含 tx-fail 的任何 Final 行；`nextEpoch` 被调用 3 次；方法不向上抛异常 | AC-6 |
| NG-2 | 全部 transaction nextEpoch 均抛异常 | 2 条交易，mock 均抛 RuntimeException | 调用 `buildIcTransFinal(meta)` | `icTransactionFinalList` 为空；方法正常返回（`assertDoesNotThrow`）；`nextEpoch` 被调用 2 次 | AC-6 |

---

### Regression 回归用例

| 编号 | 描述 | 前置条件 | 操作 | 期望结果 | 对应 AC |
|---|---|---|---|---|---|
| R-1 | IcTransactionFinalChangeEntity 与 IcTransactionFinalEntity 的 internalTransNo 逐行一致 | 2 条交易，mock 返回 999L / 888L | 依次调用 `buildIcTransFinal` 再调用 `buildIcTransFinalChange` | changeList.size() == finalList.size()；`for i: changeList[i].internalTransNo == finalList[i].internalTransNo` | AC-4 |
| R-2 | 成功交易固定产出 3 行（H + P0005 + OTH-PS），无半组记录 | 3 条交易，mock 返回 111L / 222L / 333L | 调用 `buildIcTransFinal(meta)` | finalList.size()==9；每组严格含 H/P0005/OTH-PS 各 1 行 | AC-1 / AC-6 |
| R-3 | 部分成功（NG-1 场景）后 changeList 行数与 finalList 一致，Node3Save 落库不受影响 | 3 条交易，第 2 条 nextEpoch 抛异常 | 依次调用 `buildIcTransFinal` 和 `buildIcTransFinalChange` | finalList.size()==6；changeList.size()==6；模拟 Node3Save 入参正确 | AC-4 / AC-6 |

---

### Data Comparison 数据比对

| 编号 | 描述 | 前置条件 | 操作 | 期望结果 | 对应 AC |
|---|---|---|---|---|---|
| DC-1 | 同 globalInterlink 3 行 internal_trans_no 相同，跨 globalInterlink 不同 | 2 条交易（不同 globalInterlink），mock 返回 20260511001L / 20260511002L | 调用 `buildIcTransFinal(meta)` | INTERLINK-A 的 3 行 internalTransNo 均 == "20260511001"；INTERLINK-B 的 3 行均 == "20260511002"；两组值不等；不再出现"按记录行递增"形态 | AC-2 / AC-5 |
| DC-2 | ic_transaction_final 与 ic_transaction_final_change 按 join key 对齐后 internalTransNo 完全一致 | 3 条不同金额的交易，mock 返回 20260511100L / 200L / 300L | 依次调用 `buildIcTransFinal` 和 `buildIcTransFinalChange` | finalList.size()==9；changeList.size()==9；逐行 `changeList[i].internalTransNo == finalList[i].internalTransNo`；3 组 internalTransNo 互不相同 | AC-4 / AC-5 |

---

## Mock 说明

- `IGlobalMonotonicService` 通过 `@Mock` + `MockitoExtension` 注入 `Node2IcTransFinalCalc` 构造器
- 调用次数断言：`verify(mock, times(N)).nextEpoch(eq("INTERNAL_TRANS_NO"))`
- 顺序断言：N-3 使用 `verify(..., times(3))` 验证总次数，结合值断言确认发号顺序（`times + String.valueOf` 联合证明）
- 异常注入：`when(...).thenThrow(new RuntimeException(...))`
- `buildIcTransFinal` 与 `buildIcTransFinalChange` 均通过 Java 反射调用（`setAccessible(true)`），与项目现有测试风格一致

## 排除范围

- DB / Mapper 层：`Node3Save` 落库逻辑不在本次单测范围，由 R-3 在内存层面验证 list 行数对齐
- `GlobalMonotonicServiceImpl` 的 Redis 集成行为：本任务不打真实 Redis，集成验证留 UAT 手工
- IC_TRANS 链（非 Final）：已在 code-review 中确认 `IcTransactionEntity` 无 internalTransNo 字段，不写单测

---

## 用例与 AC 映射总览

| AC | 覆盖用例 |
|---|---|
| AC-1（3 行同 transNo） | N-1 / N-2 / B-3 / R-2 |
| AC-2（不同交易不同 transNo） | N-1 / DC-1 |
| AC-3（发号顺序与迭代顺序一致） | N-1 / N-3 / B-3 |
| AC-4（Change 与 Final internalTransNo 一致） | R-1 / R-3 / DC-2 |
| AC-5（落库形态：按交易分组而非按记录行递增） | DC-1 / DC-2 |
| AC-6（nextEpoch 异常时该交易 3 行不入 list，节点不中断） | NG-1 / NG-2 / B-1 / B-2 / R-2 / R-3 |
