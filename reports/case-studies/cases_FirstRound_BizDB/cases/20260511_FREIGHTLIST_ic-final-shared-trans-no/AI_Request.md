---
case-id: 20260511_FREIGHTLIST_ic-final-shared-trans-no
title: IC Trans Final 内部交易号（internalTransNo）改造 —— 同交易三条费用共用 + 来源切换为 GlobalMonotonicService
team: FREIGHTLIST
owner: Liangwb
created: 2026-05-11
expected-deliverables:
  - Scenario.md
  - AI_Risk_Level.md
  - Solution.md
  - Task.md
  - Test.md
  - Verify.md
  - PR_Template.md
  - AI_Case_Card.md
  - Token_Usage_Report.md
related-requirements:
  - REQ-202604300018   # 旧条目，保持 active，本任务对其第 30 行做 amends
  - REQ-202605110001   # 本任务定稿的修订案（amends 202604300018 §"字段值固定/派生规则" 第 30 行）
---

# AI_Request：IC Trans Final 内部交易号改造

## 任务一句话
把 `IC_TRANS_FINAL` 链 `Node2IcTransFinalCalc` 中 `internalTransNo` 的赋值方式调整为「**同一条 IC 交易的 3 条 Final 记录（H + P0005 + OTH-PS）共用同一个 transNo**」，且 transNo 来源由当前的 `++index` + `CustomTypeConvertUtils.toFourDigits(...)` 改为调用 `GlobalMonotonicService.nextEpoch("INTERNAL_TRANS_NO")`。

## 用户原话
> ic_trans_final 流程中的 internal trans no 需要调整；
> 1. 现在是三条费用的内部交易号累加，需要改为使用相同的 transNo。
> 2. 获取 transNo 获取方式：调用 GlobalMonotonicService 服务的 nextEpoch 方法，参数传 "INTERNAL_TRANS_NO"。

## 现状（代码佐证）
- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/node/ic/transfinal/Node2IcTransFinalCalc.java:101-120`
- 现在用 `int index = 0;` 起手，每生成一条 Final 记录就 `++index`，再 `CustomTypeConvertUtils.toFourDigits(index)`
- 后果：3 条 IC 交易 → 9 条 Final 记录，internalTransNo 形如 `0001` … `0009`

## 期望
- 同一 `IcTransactionEntity` 的 Header / 费用1(P0005) / 费用2(OTH-PS) 三条 Final 记录的 `internalTransNo` **完全相同**
- 不同 IC 交易之间继续保持各自的 transNo
- transNo 由 `GlobalMonotonicService.nextEpoch("INTERNAL_TRANS_NO")` 提供（每条 IC 交易调用一次）

## 风险初判
- 默认 🟡 **Yellow**：LiteFlow 节点改动，但不触及 Node5 / Node10 / Node11 等"共享果子"
- TA(review) 复核确认

## 输入材料清单
- 用户口头描述（见上文「用户原话」）
- 修订案 [REQ-202605110001](../../../.claude/requirements/202605110001.md)（本任务定稿，amends 202604300018 §"字段值固定/派生规则" 第 30 行）
- 旧条目 [REQ-202604300018](../../../.claude/requirements/202604300018.md)（仍 active，第 30 行以外段落仍为权威定义）
- 当前节点代码 `Node2IcTransFinalCalc.java`

## 待 RA(draft) 澄清的关键点（finalize 阶段已闭环）
1. `GlobalMonotonicService` 在本仓库未发现（推测来自内网 Nexus 框架包 `com.pobing.bus.*`），需澄清：
   - 依赖坐标 / 接口签名 / `nextEpoch` 返回类型 → **已确认**（用户答 Q3）
   - 是否已在本服务依赖中 → **已确认在依赖中**
2. `nextEpoch("INTERNAL_TRANS_NO")` 的返回值是数字、字符串还是其他？现有逻辑用的是 4 位补零字符串，是否仍要保持"位数 / 格式"约束？→ **已确认**（用户答 Q4：返回 `long`，放弃 4 位前导零格式化）
3. 改造后 `CustomTypeConvertUtils.toFourDigits` 是否还要保留？现有调用方有无其他业务依赖该方法？→ TA(architecture) 决定是否物理清理；工具类整体保留
4. `GlobalMonotonicService.nextEpoch` 的并发 / 幂等语义？是否每次必产出不同值？同一 mvTs 重放是否产生不同 transNo（影响 IC_TRANS_FINAL 重算场景）？→ **已确认**（用户答 Q5：每次重算取新号；Kafka 重放下重复行问题已记入 Scenario.md "已知问题"段，本任务不修）
5. 是否需要回填修改 `IcTransactionFinalChangeEntity` 的 `internalTransNo`（当前由 `BeanUtils.copyProperties` 自动带过来，逻辑不变也能保持一致，但建议明示）→ **已确认**（Scenario.md AC-5 已显式覆盖）
6. PDF 团队对齐（Q1 / Q2）→ **已确认**（PDF 不以 internal_trans_no 作行级唯一键、不依赖排序展示，跳号 / 变长可接受）
