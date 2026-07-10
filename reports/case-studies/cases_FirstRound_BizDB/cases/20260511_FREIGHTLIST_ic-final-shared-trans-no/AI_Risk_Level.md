---
case-id: 20260511_FREIGHTLIST_ic-final-shared-trans-no
risk-level: Yellow
assessed-by: tech-architect (review mode)
assessed-at: 2026-05-11
related-requirements:
  - REQ-202604300018 (待 amends "字段值固定/派生规则" 第 30 行)
---

# AI 风险等级评估

## 风险等级

🟡 **Yellow**

## 判定依据

1. **触及组件**：仅 IC_TRANS_FINAL 链的 `Node2IcTransFinalCalc.buildIcTransFinal`（计算节点，非落库节点）；不触及 FreightList 链的 Node5ProfitShare（共享果子）、Node10Exception、Node11Save（唯一落库点），也不动 IC_TRANS_FINAL 链的 Node1 / Node3
2. **不动 schema / 不动表结构**：`ic_transaction_final.internal_trans_no` 与 `ic_transaction_final_change.internal_trans_no` 字段类型、列名、表结构均保持不变，仅取值规则变化
3. **不动生产配置**：不涉及 `*-prod.yml` / Consul / Kafka topic / busType / chainId 任何一处
4. **PDF 团队可见列的取值规则变化**：`internal_trans_no` 列从"按记录全局连号"变为"按 IC 交易分组、3 行同值、跨交易跳号单调递增"，下游若以此列做行级唯一键 / 排序展示会受影响 —— 这是 Yellow 触发的关键，须在 RA(finalize) 前对齐 PDF 团队
5. **引入新外部框架依赖**：`GlobalMonotonicService.nextEpoch` 来自内网 Nexus 框架包（仓库内 0 命中），属"新增对外调用 / 边界扩张"。按本仓库默认归 Yellow，不进 Red（Red 要求触及认证 / 授权 / 加密 / 审计 / 生产数据，本次均不触及）

## AI 可做的事

- 评审需求草案（已完成，本文档同步产出）
- 撰写 / 修订 Scenario.md（RA draft / revise）
- 取需求池新编号、amends REQ-202604300018（RA finalize）
- 产出 Solution.md（TA architecture）—— **必须经用户人工确认后才能进入实现**
- 起独立分支 `feat/ic-final-shared-trans-no` 在 worktree 中实现代码改动
- 写测试 / 跑构建 / 验证
- 产出 PR_Template.md / AI_Case_Card.md / Token_Usage_Report.md

## AI 不可做的事

- 在 Solution.md 未经用户人工确认前**修改代码**（Yellow 铁律）
- 在 Test.md / Verify.md 未完成且 TA(code-review) 未通过前**合并 PR**（Yellow 铁律：结果须人工 sign-off）
- 自主决定 4 位格式化是否保留（待 Q4 拍板）
- 自主决定 nextEpoch 业务键幂等需求（待 Q5 拍板）
- 自主决定 GlobalMonotonicService 异常时的回退策略（待 Q6 / Q9 拍板）
- 自主决定是否物理删除 `CustomTypeConvertUtils.toFourDigits`（Surgical Changes 原则，由 TA 在 Solution 中拍板范围 + 用户确认）
- 修改 `build.gradle` 引入新依赖坐标前**未经用户确认**（若 GlobalMonotonicService 不在已传递依赖中，新增依赖属边界扩张）

## 是否需用户拍板 Solution.md

✅ **必须**（Yellow 强制要求）

Solution.md 必须包含以下决策点的明确答复，逐项让用户 sign-off：

1. GlobalMonotonicService 的 GAV 与 Spring 注入方式（取决于 Q3）
2. nextEpoch 是否需要业务键幂等（取决于 Q5）
3. 4 位前导零是否保留（取决于 Q4）
4. nextEpoch 异常时的回退策略（取决于 Q6 + Q9）
5. 是否物理删除 `CustomTypeConvertUtils.toFourDigits`（Surgical Changes 颗粒度选择）
6. 是否在 Scenario / Solution 中明示"Kafka 重放下 internalTransNo 不唯一"为已知历史问题、不在本任务修复（取决于 Q8）

## Stop Conditions 触发情况

按 `.claude/rules/ll-standards.md` "Stop Conditions" 7 条核查：

| # | Stop Condition | 触发？ | 备注 |
|---|---|---|---|
| 1 | 需求不清，业务规则缺关键定义 | ⚠️ **局部触发** | Q3（框架接口签名）、Q5（业务幂等需求）、Q6+Q9（异常策略）三项前置答复缺失，**阻塞 architecture 阶段**；但需求**主线**（3 行共用 transNo + 切换到 nextEpoch）已清晰，不阻塞 RA 继续 revise / finalize |
| 2 | 风险等级缺失或被跳过 | ❌ 未触发 | 本文档同步产出，Yellow 已落定 |
| 3 | Yellow 场景 Solution 未经人工确认 | ❌ 当前未到该阶段 | TA(architecture) 产出 Solution.md 后才进入该检查点 |
| 4 | Red 场景被要求自主修改代码 | ❌ 未触发 | 非 Red |
| 5 | 自修复超过 3 次 | ❌ 未触发 | 当前未进入实现阶段 |
| 6 | 测试无法执行且无法解释原因 | ❌ 当前未到该阶段 | 未进入 QA 阶段 |
| 7 | 涉及生产配置 / 生产数据 / 生产环境 | ❌ 未触发 | 不涉及生产侧任何资产 |

**当前状态**：Stop Condition #1 局部触发 → 主 Claude **必须**先用 AskUserQuestion 收集 Q3 / Q5 / Q6+Q9 三项关键答复，再调 RA(revise) 修订 Scenario.md；不应直接派 TA(architecture)。

## 升级 / 降级触发条件

- **升级到 Red 的条件**（任一）：
  - Q5 答复为"需按业务键幂等" + 实现方案需要查 DB 已存在编号或做去重 → 触及业务规则核心改写，升级 Red
  - 发现 nextEpoch 实际行为不满足"单调递增 + 非 null"，需要在调用方实现兜底 fallback 业务逻辑 → 升级 Red
  - PDF 团队答复"internal_trans_no 是下游账务系统行级唯一键，不能改"→ 本次改造与 PDF 团队约束冲突，需求本身被推翻
- **降级到 Green 的条件**：无（外部框架依赖 + PDF 可见列变化两项任意一项均足以维持 Yellow）
