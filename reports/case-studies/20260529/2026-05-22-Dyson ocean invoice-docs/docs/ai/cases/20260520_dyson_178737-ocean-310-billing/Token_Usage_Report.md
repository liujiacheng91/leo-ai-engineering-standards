# Token_Usage_Report.md

> UI 实际 token 数据未提供，以下数值均为估算，标注 `(estimated)`。
> 估算方式：文件读取 × avg 3,000 input tokens；文档/代码写出 × avg 2,000 output tokens；自修复 × 7,000 tokens（本案例修复均为小改动）。

---

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost (USD) | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---|---|---:|---|---|
| Ocean 310 EDI Billing Send（MSG310 实现） | edi-dyson-realization | Dyson | Yellow | Sonnet | 175,000 (estimated) | 57,000 (estimated) | 232,000 (estimated) | $1.38 (estimated) | 2 (Near Threshold) `[Assumption]` | No | 14 | Pass | Yes |

**Retry 根因：**
- Fix #1 `[Assumption]`：`OceanShipment.loadterm` 字段名未用 `javap` 验证，依赖 MD 文档推断，编译失败
- Fix #2 `[Assumption]`：新建测试文件前未确认 `testImplementation` 依赖是否声明，编译失败

---

## Stage-Level Token Usage

| Stage | Model | Token | Cost (USD) | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis + Risk Assessment | Sonnet | 37,000 (estimated) | $0.22 | 16% | 读取 requirements.md / mapping.csv / OceanShipment.md / Msg310X12.md；生成 Scenario.md / AI_Risk_Level.md |
| Solution Design + Mapping Rules | Sonnet | 60,000 (estimated) | $0.36 | 26% | 读取 9+ 参考文件（Impl/CommonUtils/ToolService/Retrospective 等）；生成 Solution.md + Mapping_Rules.md + Q&A 确认 |
| Task + Test Generation | Sonnet | 24,000 (estimated) | $0.14 | 10% | 生成 Task.md / Test.md；读取模板 |
| Code Implementation | Sonnet | 88,000 (estimated) | $0.52 | 38% | JAR 检查（javap ×12+）；写 2 Java 实现文件 + 测试文件 + build.gradle；编译验证 |
| Verification | Sonnet | 16,000 (estimated) | $0.10 | 7% | 运行测试；读取 XML 报告；生成 Verify.md |
| PR / Case Card / Token Report | Sonnet | 7,000 (estimated) | $0.04 | 3% | 生成 PR_Template.md / AI_Case_Card.md / Token_Usage_Report.md |
| **合计** | Sonnet | **232,000 (estimated)** | **$1.38** | 100% | |

> Stage 合计与 Task-Level 一致（误差 0%），在 ±10% 范围内。

---

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | $1.38 / 14h = **$0.099/hr** (estimated) |
| Token / Saved Hours | 232,000 / 14h = **16,571 tokens/hr** (estimated) |

> 参考基准：EDI $0.07/hr，VBO $0.18/hr，BizDB $0.59/hr。
> 本案例 $0.099/hr，略高于 EDI 基准，主因为 Mode 2（大规模 Mapping + 多次 JAR 检查），属合理范围。

---

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Code Implementation 占 38% total | 单阶段超过总 token 的 40% 临界值（38%，接近但未超过）| 无需干预；主因为 100+ 字段映射和多次 `javap` 检查。后续可将 JAR 结构预检查提前到 Solution 阶段，减少实现时反复读取 |
| Retry Count = 2（Near Threshold）| 两次均为 `[Assumption]`：字段名和依赖声明未预先验证 | 已在 Test.md Fix History 中记录预防规则；在 Task.md 中增加"用 javap 确认字段"和"testImplementation 已声明"为 DONE 标准 |
