# AI_Request.md

## Basic Info

- Case ID: 20260512_FREIGHTLIST_ic-final-batch-dedup
- Request Name: IC_TRANS_FINAL 链 batch 内按业务键去重
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Owner: Liangwb（用户）
- Date: 2026-05-12
- Output Path: docs/ai/cases/20260512_FREIGHTLIST_ic-final-batch-dedup/

## Request Type

- [x] Refactoring（service 层增加批内去重逻辑，幂等性补丁）

## Expected AI Output

- [x] Scenario.md
- [x] AI_Risk_Level.md
- [x] Solution.md
- [x] Task.md
- [x] Test.md
- [x] Verify.md
- [x] Code Change
- [x] PR Summary
- [x] AI_Case_Card.md
- [x] Token_Usage_Report.md

## 背景与触发

用户在 case `20260511_FREIGHTLIST_ic-final-shared-trans-no` 落地后观察到 `ic_transaction_final` 表里同一笔 IC 交易出现 12 行（预期 6 行 = mirror 对 × 3 行 H+P0005+OTH-PS）。经定位是上游 Kafka 同一批次内推送了两条同 `(globalInterlink, version)` 的事件，导致 `IcTransactionFinalServiceImpl.start()` 凑出的 `metaItems` 列表里有重复，链路上的 Node1 存在性检查在"同批次多 metaItem 先全部 Node1 再到 Node2/Node3"的执行顺序下无法挡住，每个重复 metaItem 各自走完一遍 Node2/Node3，结果 6 行翻倍成 12 行。

Scenario.md L114-118 当初就把"幂等性"作为已知问题、不在本 case 修复显式记录在案，本次新立 case 单独处理。

## 改动范围（最小化）

**只动一处**：`expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/impl/IcTransactionFinalServiceImpl.java`，方法 `start(BusLiteFlowMeta flowChain, BusKafkaBatchEvent batchEvents)`，在 `metaItems` 凑完之后、`dispatch(...)` 之前增加一段按 `(globalInterLink, version)` 的去重，同 key 保留先到的。

明确**不动**：

- Node1FinalTrigger / Node2IcTransFinalCalc / Node3Save
- `IcTransactionFinalEntity` / `IcTransactionFinalChangeEntity` 字段与表结构
- DB schema（不加唯一索引）
- 其他链（FREIGHT_LIST / IC_TRANS）

## 已知边界 / 用户已确认

- 本次改动**仅覆盖"同一 Kafka batch 内重复"**这一窗口
- **跨批次 / 并发消费 race** 仍可能产生重复，本 case 不修，依赖 Node1 现有存在性检查兜底；用户已接受这一残余风险，后续视生产观察决定是否再立 case 处理 Node3 删后插 / DB 唯一索引
- 不动落库节点、不引入 `@Transactional`、不加分布式锁

## 输入清单

- 业务背景：见上文及 `docs/ai/cases/20260511_FREIGHTLIST_ic-final-shared-trans-no/Scenario.md` L114-118
- 现状代码：`IcTransactionFinalServiceImpl.java:54-80`
- 现象样本：用户提供的 `ic_transaction_final` 两行 H 记录（同 `stationCode=KYSHAA`、不同 `internalTransNo=10/12`），证实重复来自批内多 metaItem
- 关联文档：
  - `.claude/docs/architecture.md` "落库节点的事务边界（当前现状）" 一段
  - `.claude/docs/business-context.md` "IC_TRANS / IC_TRANS_FINAL" 一段

## 风险初判

- 倾向 🟡 Yellow：service 层逻辑改动、影响数据正确性，但**仅 1 个方法、不动 chain 节点、不动 schema、不动事务**
- 由 TA(review) 在评审 Scenario 后落 `AI_Risk_Level.md` 最终拍板

## Required Human Input

- Business Rules: 同一 `(globalInterlink, version)` 在同一 Kafka batch 内重复时，链路应只处理一次
- Sample Data: 已提供（用户贴出的两条 `ic_transaction_final` 记录）
- Acceptance Criteria: 由 RA(draft) 在 Scenario.md 中落实
- Technical Constraints: 只动 `IcTransactionFinalServiceImpl.start()`、不影响其他链
- Risk Level: 倾向 Yellow，待 TA(review) 确认

## Entry Check

- [x] Required input available
- [x] No sensitive data included
- [ ] Scenario.md completed（待 RA(draft) 产出）
- [ ] Risk level completed（待 TA(review) 同步给出）
