# Token_Usage_Report

<!-- Source of truth. 严格口径见 .claude/rules/token-report-strict.md -->

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| ic-trans-offset-skip | bus-freightlist-handler-service | FREIGHTLIST | 🟡 Yellow | sonnet | 140,820 | 30,905 | 171,725 | $0.89 | 0 | No subagent (LL-only mode)；⚠️ 实际误用 2 次 Explore Agent（应直接用 Grep/Read），已纳入 token 总量 | 1.5 | Pass | Yes |

> Cost 计算：Sonnet 4.6 标准价 $3/MTok input + $15/MTok output。subAgent input 精确，主 Claude 部分 estimated。

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | sonnet | 60,825 | $0.24 | 35.4% | ⚠️ 误用 Explore Agent×2 (45,800+10,525)；LL-only 模式应直接用 Grep/Read；token 已实际产生，如实计入 |
| Solution Design | sonnet | 25,000 | $0.18 | 14.6% | 主 Claude 写 Scenario / AI_Risk_Level / Solution.md (estimated) |
| Code Implementation | sonnet | 35,000 | $0.19 | 20.4% | 读 Node3/Node4/Node5 + 2 处 Edit + commit (estimated) |
| Test Generation | sonnet | 20,000 | $0.13 | 11.6% | 写 Task.md / Test.md (estimated) |
| Verification | sonnet | 30,900 | $0.15 | 18.0% | 写 code-review / Verify / PR_Template / AI_Case_Card / Token_Usage_Report (estimated) |
| Rework / Retry | — | 0 | $0.00 | 0% | 无自修复轮次；JGit worktree 构建失败为已知工具链问题，非代码错误，不计 Retry |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| — | 未触发：Retry=0 / 单阶段最高 35.4% < 40% / 未用 Opus / Total ~172K < 500K | 无需处理 |

---

## 附：SubAgent Token 明细

| SubAgent | 阶段 | input | output | total |
|---|---|---:|---:|---:|
| Explore (IC_TRANS 流程探索) | Scenario Analysis | 42,000 | 3,800 | 45,800 |
| Explore (Node3/Node4/Node5 代码读取) | Scenario Analysis | 8,420 | 2,105 | 10,525 |

主 Claude 编排（含 worktree 创建、文件读写、commit）：约 90K input + 25K output（estimated），标注 `(estimated)`。

**Memory/Sub Agent 列说明**：LL-only 模式规定"无 subagent"，四员工（RA/TA/Dev/QA）未使用。但主 Claude 在代码探索阶段误调 Explore Agent×2，属于操作偏差；token 已实际产生（56,325 tokens），如实纳入 Scenario Analysis 阶段计入总量，不回退。主 Claude 编排 pre-merge ~90K estimated；Retry = 0，无 post-merge rework。

**Mode: LL-only**（四员工瀑布暂停期，Skill 流执行）
**⚠️ 偏差记录**：Scenario Analysis 阶段误用 Explore Agent（应改为 Grep/Read/Glob 直接探索），后续 case 须改正。
