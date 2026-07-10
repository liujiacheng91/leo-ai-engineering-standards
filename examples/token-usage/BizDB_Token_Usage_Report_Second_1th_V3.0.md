# Token_Usage_Report.md
<!-- Source of truth. skills/token-report/references/Token_Usage_Report.md is a read-only copy for skill loading — always update this file first, then sync the copy. -->

> **2026-05-12 严格口径更新**：合并 `dd0f815` 后跑 `gradle test` 暴露 3 编译错误 + 5 Mockito 严格模式问题，主 Claude 自修复 2 轮（commit `96cefe3` + `8153709`），10/10 PASSED。Retry Count 从 0 校准为 2，Rework / Retry 阶段 token 已回填，Task-Level 总量与成本同步上调。

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| IC_TRANS_FINAL 链 batch 内去重 | bus-freightlist-handler-service | FREIGHTLIST | 🟡 Yellow | Sonnet + Opus | 352,865 (estimated) | 47,389 (estimated) | 400,254 (estimated) | $5.49 USD (estimated) | 2 | Yes - 7 subAgents (total=312,254 自报精确) + 主 Claude 编排 pre-merge ~38K (estimated) + post-merge rework ~50K (estimated) | 5.0 | Pass | Yes |

> 说明：
> - **精确部分**：7 个子 agent 自报 token 共 312,254（input=277,865 / output=34,389），$3.39 USD
> - **估算部分**：
>   - 主 Claude 编排（pre-merge：派活 / Read / Glob / Grep / 写三件套）≈ 38,000 token（input 30K + output 8K），Opus 价 ≈ $1.05 USD
>   - 主 Claude rework（post-merge：跑 test → 修编译错误 → 修 Mockito 严格模式 → 回填 Verify.md）≈ 50,000 token（input 45K + output 5K），Opus 价 ≈ $1.05 USD
> - **整案估计**：≈ 400,254 token / $5.49 USD（含主 Claude 编排估算；标 (estimated) 因主 Claude tool_uses / duration_ms / token 系统无法回放精确读数）

## Stage-Level Token Usage

> 百分比基线 = 整案估计总量 400,254（含主 Claude 编排估算）。"主 Claude 编排 pre-merge" 是分布在前 5 个阶段的派活 / 三件套撰写，单独列在最下方说明。

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Sonnet + Opus | 62,451 | $1.24 | 15.6% | RA(draft) 10,588 (Sonnet $0.058) + TA(review) 41,500 (Opus $1.133) + RA(finalize) 10,363 (Sonnet $0.053) |
| Solution Design | Opus | 19,580 | $0.58 | 4.9% | TA(architecture) 产出 Solution.md，含路径选型 / 技术背景 / 实现拆解 / 测试策略 / 回滚方案 |
| Code Implementation | Sonnet | 49,003 | $0.21 | 12.2% | java-backend-engineer 在 worktree `feat/ic-final-batch-dedup` 上 commit `c83acf9`（代码 +12 行）+ Task.md / impl-notes.md |
| Test Generation | Sonnet | 109,096 | $0.41 | 27.3% | qa-engineer 70% 比例：Test.md 5 类用例设计 + 10 个 Mockito 单测代码 commit `e3693cb`（QA 总 136,370 × 70%） |
| Verification | Sonnet + Opus | 72,124 | $0.96 | 18.0% | TA(code-review) 44,850 (Opus $0.838) + qa-engineer 30% 验证执行部分 27,274 (Sonnet $0.105)：编译 / 静态断言 / AC trace / 主仓库现有测试回归 |
| Rework / Retry | Opus (主 Claude) | 50,000 (estimated) | $1.05 (estimated) | 12.5% | 合并后跑 `gradle test` 暴露 3 编译错误 (commit `96cefe3` 修复：包名 / UUID / `@MockitoSettings(LENIENT)`) + 1 轮 Verify.md §8 回填 (commit `8153709`)；2 轮自修复在 LL Stop Conditions 阈值（≥3）内。Token / cost 是主 Claude 估算（无 subagent 自报） |

> **stage 总和**（子 agent 自报精确 + Rework 估算）：62,451 + 19,580 + 49,003 + 109,096 + 72,124 + 50,000 = 362,254；cost 之和 $1.24 + $0.58 + $0.21 + $0.41 + $0.96 + $1.05 = $4.45 USD
>
> **主 Claude 编排 pre-merge**（未计入上表，分布在前 5 个阶段的派活与三件套撰写）：≈ 38,000 token / $1.05 USD (estimated)
>
> **整案估计总量**：362,254 + 38,000 = 400,254 token / $4.45 + $1.05 = $5.50 USD（与 Task-Level $5.49 一致，差 $0.01 为四舍五入）

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| 未触发 | 重算后各阶段 token 占比均 < 40%（最高 Test Generation 27.3%），**Retry Count = 2**（在阈值 ≥3 内），Green 任务未用 Opus（本 case 是 Yellow），整案 Total Token ~400,254 < 500,000 | 无需 action，但 Retry Count 已接近阈值（差 1），后续若再多 1 轮自修复就会触发 |

### Retry 来源分析（供后续优化参考）

| Retry 轮 | 触发 | 主因 | 是否可避免 |
|---|---|---|---|
| 第 1 轮 | `gradle test` 报 3 编译错误（包名 / UUID / setChainId 类型） | QA 在 worktree 内无法跑测试（JGit 不兼容），导致测试代码的编译类问题只能合并后暴露 | **可避免**：若解决 versioning 插件与 worktree 的兼容性，QA 阶段就能跑测试发现这些问题；建议另立 case 处理（已在 AI_Case_Card §"What to improve" 记录） |
| 第 2 轮 | `gradle test` 报 5 个 `UnnecessaryStubbingException` | QA 在生成测试时不知道 Mockito 严格模式对 setUp 共享 stub 的限制（仓库无 Mockito 先例可参考） | **部分可避免**：在仓库引入 Mockito 测试基础设施时，CLAUDE.md 或 conventions.md 应加一条 "Mockito 默认 strictness 设置" 的注意事项；当前作为本 case 的可复用资产 (`IcTransactionFinalServiceImplTest` 用 `@MockitoSettings(LENIENT)`) 留存 |

## 复盘要点

### Model Selection 是否合理

按 `.claude/rules/ll-standards.md` "Model Selection" 与 `.claude/rules/agent-workflow.md` "调用约定"中员工 ↔ 默认 model 推荐：

| 阶段 | 推荐 model | 实际 model | 是否符合 |
|---|---|---|---|
| RA(draft / finalize) | Sonnet | Sonnet | ✅ |
| TA(review / architecture / code-review) | Opus | Opus | ✅ |
| java-backend-engineer | Sonnet | Sonnet | ✅ |
| qa-engineer | Sonnet（验证卡 ≥2 次时升 Opus） | Sonnet | ✅（QA 未卡，无需升级） |

**结论**：全部符合默认推荐，未出现"Green 用 Opus" / "代码生成用 Haiku" 等违规情况。

### SubAgent Token 上报合规性

7 个子 agent 全部按 prompt 要求在最终输出末尾追加了 `Token usage: input=<n>, output=<n>, total=<n>` 行；主 Claude 收尾时已逐条汇总到 Task-Level / Stage-Level 表，无 `Yes - subAgent tokens not included` 情况。

### ROI 评估

- 估计人工耗时：~7 小时（定位 2-3h + 设计 1h + 实现 0.5h + 测试 2h + 验证 1h）
- AI 辅助实际耗时：~2.5 小时（含 7 次子 agent 派活 + 主 Claude pre-merge 编排 + post-merge 2 轮自修复 + 用户确认 / 决策的等待时间）
- 节省人工：约 4.5 小时
- AI 成本：约 $5.49 USD（含主 Claude 编排 + Rework 估算；严格口径）
- **每节省 1 人时 ≈ $1.22 USD**，ROI 仍显著为正（但比初算的 $0.89 略高 —— 因为 Rework 阶段拉高了成本）

### 可复用产物

1. **5 阶段瀑布执行链**：`AI_Request → Scenario → AI_Risk_Level → Solution → Task → Test/Verify → 三件套` 全流程已跑通，可作为本仓库 Yellow 风险 case 的标准模板
2. **批内去重模式**：`LinkedHashMap<String, T> + putIfAbsent + LinkedHashMap::values + ArrayList wrapping` 的 5 行写法，可在仓库其他 service 层去重 / 幂等场景复用
3. **Mockito service 层单测样例**：`IcTransactionFinalServiceImplTest` 是仓库内首个 service 层 Mockito 单测，可作为后续测试基础设施 case 接入时的参考模板
