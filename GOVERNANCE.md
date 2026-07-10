# Governance

## 1. Mandatory Rules

1. 所有 AI 试用必须从 `AI_Request.md` 或 `/ll-dev` 进入。
2. 所有案例必须输出到 `docs/ai/cases/<case-id>/`。
3. 所有案例必须包含 `Scenario.md` 和 `AI_Risk_Level.md`。
4. 字段 Mapping、XML / JSON 转换、报表 SQL、客户差异化逻辑必须填写 `Mapping_Rules.md` 或 `Business_Rules.md`。
5. Green 场景允许 AI 自主实现、测试、验证。
6. Yellow 场景必须人工确认 `Solution.md` 和最终结果。Yellow 路径在 `Solution.md ## Human Approval` 签字前不允许生成 Task.md / Test.md。
7. Red 场景 AI 只允许分析和建议，不允许自主修改或合并。Red 路径只生成 Scenario.md、AI_Risk_Level.md、Solution.md（仅分析节）。
8. 所有代码变更必须输出 `Verify.md`。
9. 所有案例必须记录 Token、模型、执行轮次、节省工时和人工介入点。
10. Opus、Memory、Sub Agent、Skill 组合使用必须说明目的。
11. 不允许把需求、方案、任务、测试、验证混写在一个大 MD 中。
12. 所有文档必须使用 `standards/Document_Naming_Standard.md` 中定义的固定名称。
13. 禁止在同一 case 执行中混用与当前标准流程无关的外部 Skill；Skill 组合须在 `skill-compositions/` 中预先定义。
14. 所有项目在开始 AI 案例前必须配置 `CLAUDE.md`（Section 1 项目信息）和 `.claude/ll-rules.md`（行为规则）。运行 `install_project` 脚本完成初始化；直接将规则贴入 prompt（Rules-in-Prompt）仅允许作为 fallback。
15. `Solution.md` 的 `## Technical Constraints` 节未填写视为 Stop Condition -- 不允许进入 Task.md / Test.md 阶段。验证内容包括：Java 语言级别、关键实体字段名、工具方法可用性、Mockito strictness、Worktree 构建可行性。
16. 若 Worktree 构建不可行（JGit / versioning 插件限制），必须在 `Solution.md ## Post-Merge Test Plan (Track B Declaration)` 中填写命令 + 执行人 + 时机，并在 `Verify.md ## Post-Merge Test Plan` 节填写后方可合并。合并后须将测试结果回填 `Verify.md ## Post-Merge Test Results`。满足上述条件时，worktree 构建失败不计入 Retry Count。
17. 修改 `templates/` 或 `standards/` 下的权威文件后，必须同步更新该模板所归属的 `skills/<owner>/references/` 下的副本。V4.4 起每个模板只归属一个 Skill（见 `ll-dev/SKILL.md` Workflow 表 Owning Skill 列）。
18. 版本升级必须使用 `upgrade_project` 脚本进行原子操作（替换 `.claude/ll-rules.md` + `.claude/skills/` + 版本号），不允许手动部分升级。V4.3 项目须先运行 `migrate_v43_to_v44` 完成 CLAUDE.md 拆分。
19. 所有 PowerShell 和 Bash 脚本禁止在脚本体内嵌入中文文本。中文内容通过文件 I/O 读取（Copy-Item / sed / printf），确保在非 UTF-8 Windows 系统上正常运行。
20. 根目录 `CLAUDE.md`（plugin 自动加载）和 `ll-rules.md`（脚本安装 fallback）的规则内容必须保持一致。修改任一文件后须同步更新另一文件。`plugin.json` 中的 version 必须与 `VERSION` 文件一致。

## 2. Behavior Mode

所有 Claude Code 行为必须默认遵循（详见 `.claude/ll-rules.md`）：

- Think Before Coding
- Simplicity First
- Surgical Changes
- Goal-Driven Execution
- Accuracy & Hallucination Prevention
- Concise Output

## 3. Execution Mode Selection

在开始每个案例前，根据任务规模和类型选择执行模式。模式选择影响工具使用、SubAgent 策略和 Token 预算。详见 [SDLC.md](SDLC.md) Execution Modes 节。

### Mode 1 -- LL-only

适用：小改动、单服务逻辑调整、Bug fix、输入输出明确、无需跨模块探索。

- 默认 Sonnet。Opus 仅在 3+ 组件或连续 2 次 Sonnet 失败时升级。
- 禁止 Explore Agent；使用 Grep / Read / Glob 定向读取。
- 禁止混用无关 Skill（会污染流程口径）。
- Token 目标：50K-150K；Retry 目标：0-1。

### Mode 2 -- Mapping / EDI

适用：EDI X12、字段映射、客户化格式转换、Billing / Invoice / Cargo Milestone 等字段规则密集场景。

必须在实现前预先创建以下文档：
- `Mapping_Rules.md` -- 字段对应关系
- `Business_Rules.md` -- 业务规则和特殊处理逻辑

原因：提前固化映射规则可避免模型在实现阶段重复推断，显著减少 Token 消耗。

### Mode 3 -- Large Feature SubAgent

适用：多文件新增（> 15 个任务 / > 20 个文件）、多层架构改动（SQL + Mapper + Service + Controller + Test）、需要并行拆分任务。

- SubAgent 可以使用，但必须强制上报 token（输出末尾追加 `Token usage: input=X, output=Y, total=Z`）。
- 每个 Group / SubAgent 必须有明确输入范围和输出清单。
- 大参考文件（> 1,000 行）必须先摘要再定向读取，禁止直接全量读入。
- Stage > 40% 必须进入 Abnormal Cost Review 并附解释。

## 4. Weekly Review

```text
1. Completed cases and outcomes
2. Problem cases and root causes
3. Token consumption trends
4. Template and Skill improvements
5. Prompt optimization
6. Scenario benefit matrix update
7. Validation failure cases
```
