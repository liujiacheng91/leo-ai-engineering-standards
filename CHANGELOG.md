# Changelog

## v5.0.0

> Batch-derived behavior rules: 20260608 (11 cases) + 20260609 (9 cases) FREIGHTLIST audit encoded into CLAUDE.md and ll-rules.md. 12 new rules across 9 sections.

### Case Study Batches

- `reports/case-studies/20260608/`: 11-case FREIGHTLIST batch (auto-mode refactor, AR/AP charge processing, workflow orchestration stubs). All AI_Case_Card.md present; 0 retries; 100% first-pass rate.
- `reports/case-studies/20260609/`: 9-case FREIGHTLIST batch (trigger-recalc, semi-auto workflows, status code fix, trans-ref-id). 2 retries (1 [Assumption], 1 [Toolchain]).

### Behavior Rules (CLAUDE.md + ll-rules.md)

From 20260609 batch analysis (S-series):

- `§1.5 [S-06]` Java getter/setter names must be Grep-verified before writing -- camelCase from field name is ambiguous (`interLink` vs `interlink`)
- `§5.1 [S-08]` Green + Mode 1 + files <= 3 + lines < 50: spawn Sonnet subAgent for implementation; Opus handles coordination only
- `§6 [S-02]` `Merge_Decision.md` added to Forbidden Practices -- merge decisions belong in `Solution.md ## Human Approval`
- `§7.1 [S-04/S-05/S-09]` Track B requirements: declaration must match Verify.md evidence; Post-Merge Owner never "AI"; Post-Merge Plan must include full module test command
- `§8 item 3 [S-03]` Yellow stop condition clarified: `Solution.md ## Human Approval` is the execution gate; `AI_Case_Card.md` Human Intervention does not satisfy it
- `§9.1 [S-01]` `AI_Case_Card.md` mandatory for every case regardless of risk level or size
- `§9.2 [S-07]` `Token_Usage_Report.md` requires all 4 sections; missing Stage-Level = case not closed

From 20260608 batch analysis (N-series):

- `§1.1 [N-05]` `isAll...`/`isAny...` methods: empty collection defaults to `false` (conservative); exceptions must be declared in Solution.md
- `§2.1 [N-01]` Green Minimal Path formally defined: 5-step compact flow for Green + stub + change lines < 30 (omits Scenario/Task/Test/PR_Template)
- `§2.2 [N-04]` Batch Merge Order: when cases have code dependencies, required merge sequence must be documented; dependent must not merge before dependency
- `§5.2 [N-03]` LiteFlow node modification = automatic Yellow regardless of change size
- `§9.3 [N-02]` Token figures must come from `/usage` command actuals; estimated values require explicit `(estimated -- /usage not available)` annotation

---

## v4.9.0

> Plugin marketplace local-file install fix: correct source path for full repo caching; marketplace folder seeding documented.

### Plugin Marketplace Fix

- `marketplace.json`: added root-level copy (was only in `.claude-plugin/`); `source` changed to `"./ll-ai-engineering-standards"` (repo root) so the full tree (including `skills/`) is copied to the plugin cache. Previous value `"./.claude-plugin"` only copied 2 files, causing `failed to load: cache-miss`.
- `.gitignore`: added to exclude `.claude/ll-marketplace-token.txt` (local token file, never committed).
- `README.md`: Option A local install documents the repo directory naming requirement and the one-time marketplace folder seeding step.

### Root Cause: Claude Code `file` type marketplace behavior (recorded for future reference)

- `source` in a `file` type marketplace resolves from the PARENT of the directory containing `marketplace.json`. With `marketplace.json` at repo root, `source: "./ll-ai-engineering-standards"` correctly resolves to the repo root.
- Claude Code does NOT auto-create `~/.claude/plugins/marketplaces/<name>/` for `file` type marketplaces (unlike `github`/`git` sources). That folder must be seeded manually with the full repo for the plugin to load.
- GitLab `/-/raw/` URLs do not accept `PRIVATE-TOKEN` headers -- browser session only. Files API (`/api/v4/`) requires `read_api` scope; `read_repository` scope returns 403.
- Project ID: 180 (`architecture/ai_agent/ll-ai-engineering-standards`).

---

## v4.8.0

> Multi-dimensional Reusable Assets in AI_Case_Card, version alignment fixes.

### Multi-dimensional Reusable Assets

- `templates/AI_Case_Card.md`: expanded binary `Reusable: Yes/No` to 5-dimension evaluation table in new `## Reusable Assets` section:
  - Code: utility methods, service patterns, mapper templates
  - Pattern: framework structure, field chain, grouping logic
  - Checklist: P0 test cases, pre-check items, boundary conditions
  - Process: multi-step flow, session split strategy
  - Business Knowledge: field source mapping, calculation rules
- `skills/ll-dev/references/AI_Case_Card.md`: Rule 17 sync.
- `reports/Reusable_Asset_Registry.md`: updated instructions to reference the 5 dimensions for Asset Type selection.

### Version Alignment

- `reports/Iteration_V46_Reference.md`: updated "V4.7 Candidates" to "Post-V4.7 Status"; Multi-dimensional Reusable changed from "V4.7 candidate" to "Deferred to V4.8"; added V4.7 completion entries (Case Type routing, permission settings).

---

## v4.7.0

> Case Type routing, 27-case audit documentation, risk-benefit quadrant, deck consistency fixes, version file updates.

### Case Type Routing (ll-dev SKILL.md)

- 9-type routing table added after Step 3 (risk assessment): Rule Framework, Field Completion (batch/single), Bug Fix, Calculation Logic, EDI Mapping, Trigger Control, Interface Simplification, Large Feature.
- Each type maps to verification focus areas and a reference case from Reusable Asset Registry.
- No new skills created -- routing sharpens existing workflow steps.

### 27-Case Audit Documentation

- `reports/case-studies/20260529/FREIGHTLIST_Audit_Notes_V46.md`: 25-case audit against V4.6 rules (P0: 17 Merge_Decision.md violations, 1 case missing 5 docs; P1: 4 missing Token Reports, 1 cost mismatch 61%).
- `reports/case-studies/20260529/Dyson_Ocean310_Audit_Notes_V46.md`: highest-quality case audit (P1: test count 22 vs 24 after requirement change; P2: date typo, Token Cost reference instead of value).

### Risk-Benefit Quadrant

- `reports/Scenario_Benefit_Matrix.md`: 4-zone quadrant diagram with prioritization guidance. Quadrant column added to all 13 scenarios.
- `reports/Token_Accounting_Before_After.md`: per-case-type cost benchmarks from FREIGHTLIST batch (5 types).

### Deck Consistency Fixes

- Slide 14: corrected 3 proposal verdicts (Green Minimal Path, Token cross-check, Track B closure) from "candidate" to "Applied in V4.6".
- Slide 14 conclusion: updated counts to match actual V4.6 changes.
- Slide 17 Remaining Gaps: Green Minimal Path marked as applied.
- Slide 12: Merge_Decision.md P1 finding marked as resolved.

### Claude Code Permission Settings

- `claudecode_rule_setting.md`: new guide for `.claude/settings.local.json` with recommended permission config.
  - 16 git operations (add, commit, status, log, diff, tag, push, checkout, merge, branch, pull, fetch, ls-tree, config, mv, rm)
  - 24 PowerShell operations across 5 categories (File System, Path, Pipeline, Data, Output)
  - Intentionally gated operations (reset, force-push, clean, delete, Invoke-Expression)
  - Optional sections: RTK, Claude plugin, script execution, skill permissions
  - Anti-pattern section: how to clean auto-accumulated specific entries
- `README.md`: added "Claude Code Permission Settings" section with link; file listed in repo structure tree.

### Standards Fixes

- `Document_Naming_Standard.md`: `Merge_Decision.md` added to "Do Not Use" list with redirect to Solution.md Human Approval (Rule 17 sync, both copies).
- `ll-dev SKILL.md` Step 10: owning skill column corrected to match single-pass design.

### Reports Updated

- `Iteration_Change_Index.md`: V4.6 section added (15 changes).
- `Iteration_V46_Reference.md`: new file with full V4.6 context.
- `Reusable_Asset_Registry.md`: 11 new entries (batch benchmark, Dyson, 7 case type patterns, deck).
- `Scenario_Benefit_Matrix.md`: 5 new scenario types with cost benchmarks.
- `Token_Accounting_Before_After.md`: V4.6 optimization table and benchmark data.

### Version Files

- VERSION: v4.5.0 -> v4.7.0
- plugin.json: 4.5.0 -> 4.7.0
- marketplace.json: 4.5.0 -> 4.7.0
- README.md: title, upgrade path, version history, cost benchmarks updated
- INSTALL.md: upgrade path updated

---

## v4.6.0

> Assumption retry prevention + 7 token optimizations + 27-case audit + enforcement rules.

### Retry Prevention

- `Solution.md` Technical Constraints expanded from 5 to 7 rows: cross-module dependency verification, Mockito strictness.
- Pre-verified Environment Shortcut: CLAUDE.md `## Technical Environment (Pre-verified)` section (6 fields). Solution.md SKILL writes "Confirmed from CLAUDE.md" instead of re-discovering.

### Token Optimization (7 Changes)

- Green Minimal Path: 9-step compact flow for Green + single-file + <50 lines (target 20-50K tokens).
- Closing docs single-pass: Steps 10-12 consolidated to Step 10 (saves 15-20K/case).
- Session boundary markers at Steps 4, 7, 8.
- Conditional template sections: omit empty sections in Solution.md and Verify.md.
- ll-standards content deduplication: references ll-dev instead of duplicating tables (~400 tokens/session).
- Token report: sanity-check lookup table (7 case types) + cross-check rule (Card vs Report).
- FREIGHTLIST batch $2.44/hr benchmark added to Cost Efficiency.

### Enforcement Rules

- Track B closure check (verification SKILL.md check 3): Post-Merge Test Results must be backfilled before "Ready for Merge".
- Bug Fix pre-check (ll-dev Behavior 10): root cause + business source + code style confirmation before writing code.
- Saved Hours 5-tier calibration table with overestimate explanation rule.

### Engineering Value Deck

- `LL_AI_Engineering_Standards_Deck.md`: 17 slides covering V4.1-V4.6 evolution, 27-case audit data, improvement proposals assessment.

---

## v4.5.0

> Claude Code plugin marketplace support + skill namespace fix + cross-skill consistency audit.

### Plugin Distribution

- `.claude-plugin/plugin.json`: Plugin manifest declaring 12 skills (including new `ll-setup`), version, keywords, and metadata.
- `.claude-plugin/marketplace.json`: Self-hosted marketplace manifest (`ll-ai-standards`) enabling `claude plugin marketplace add` + `claude plugin install`. Validated with `claude plugin validate .`.
- Plugin-level `CLAUDE.md`: Behavior rules auto-loaded by Claude Code when plugin is active. Content identical to `ll-rules.md` (fallback for script-based installs).
- `skills/ll-setup/SKILL.md`: New setup skill (`/ll-setup`) that creates project CLAUDE.md (Section 1 template) + `docs/ai/cases/` directory.

### Skill Namespace Fix

- `skills/feature-dev/` renamed to `skills/ll-dev/` to avoid collision with `feature-dev@claude-plugins-official` (Anthropic's official plugin). All 18 active files updated; 7 historical files preserved.

### Cross-skill Consistency Fixes

- `AI_Case_Card.md` added to `ll-dev/references/` (was missing despite being listed as owned by ll-dev in Workflow Step 11).
- Model name casing unified across ll-dev and ll-standards (both now use Sonnet/Opus/Haiku capitalized form, matching AI_Token_Cost_Standard.md).
- `verification/SKILL.md` Self-Fix instruction updated with GOVERNANCE Rule 17 references/ sync step (was only in test-design).
- `CLAUDE.md` reference ownership moved from `custom-skill-template` to `ll-standards` (logical owner).
- GOVERNANCE Rule 13 (no external Skill mixing) now referenced in ll-dev Execution Mode section.
- `ll-standards` and `ll-setup` added to Document_Naming_Standard.md Skill Naming list.

### Two Distribution Paths

Plugin-native (recommended):

```text
claude plugin marketplace add <github-org>/ll-ai-engineering-standards
claude plugin install ll-standards@ll-ai-standards
/ll-setup
```

Script fallback (for environments without Claude Code CLI):

```text
scripts/install_project.ps1 -Target <project-path>
scripts/upgrade_project.ps1 -Target <project-path>
```

Both paths produce identical results. Plugin updates via `claude plugin update ll-standards`. Script updates via `scripts/upgrade_project.*`.

### Rules & Governance

- `CLAUDE.md` (plugin) and `ll-rules.md` (script fallback) have identical rule content (GOVERNANCE Rule 20).
- GOVERNANCE: 20 mandatory rules (Rule 20 added for plugin/script sync).

---

## v4.4.0

> 架构重构：三层分离 + 原子升级 + Skill 独立自治 + SDLC 标准化 + 脚本编码修复。

### SDLC 标准文档

- `SDLC.md`：从聊天式输出改写为标准文档。9 个 SDLC 阶段完整映射到 LL 文档和 Skill；Traditional vs AI-assisted 对比表；Human Role 转变表（BA/TA/Dev/QA）；3 种执行模式 + Token 目标；Case Evidence Chain 完整审计链。
- `README.md`：新增 AI-assisted SDLC 摘要节（工作流全景图 + 对比表 + SDLC.md 引用链接）。

### 脚本编码修复

- `scripts/install_project.ps1`：移除 Write-Host 中的中文文本，消除非 UTF-8 Windows 系统的解析阻塞。
- `scripts/migrate_v43_to_v44.ps1`：中文 Section 2 内容从 here-string 嵌入改为运行时读取 `templates/CLAUDE.md`，使用 `UTF8Encoding(false)` 写入无 BOM 的 UTF-8。
- `scripts/migrate_v43_to_v44.sh`：同步修复 -- heredoc 中文嵌入改为 sed 从 `templates/CLAUDE.md` 提取，脚本体内零中文。
- 设计原则：脚本自身只包含英文，中文内容通过文件 I/O 流转（Copy-Item / sed / printf），不受控制台 code page 影响。

### 三层架构分离

将标准仓库拆分为三个独立层：

- **Layer 1 (治理层)** — `ll-rules.md`：行为规则、SDLC 流程、风险规则、禁止事项、验证要求、停止条件。升级时安全覆盖。
- **Layer 2 (Skill 层)** — `.claude/skills/`：每个 Skill 自包含（SKILL.md + 专属 references/），可独立使用或组合使用。升级时安全覆盖。
- **Layer 3 (应用层)** — `CLAUDE.md` Section 1 + `docs/ai/cases/`：项目专有数据，升级永不触及。

### CLAUDE.md 拆分

- `templates/CLAUDE.md`：精简为 Section 1（Project Context）+ 引用 `.claude/ll-rules.md`。安装时仅首次创建，后续升级不覆盖。
- `ll-rules.md`：包含原 Sections 2-9 的全部行为规则。安装到 `.claude/ll-rules.md`，升级时整体替换。

### Skill 去重与独立自治

每个模板只归属一个 Skill 的 `references/`，消除跨 Skill 重复：

- `feature-dev` references/ 从 9 文件精简到 2 文件（AI_Request.md + Document_Naming_Standard.md），Token 减少 ~83%
- 17 个 reference 文件，每个只存在于 1 个 Skill 中（此前最多 6 份副本）
- 同步维护面从 35 个文件降到 17 个文件

`feature-dev` 从模板载体转型为编排器：Workflow 表列出每步的 Owning Skill，运行时按需加载各 Skill 上下文。

### 三种使用模式

- **Mode A (Full Flow)** — `/feature-dev` 编排全流程
- **Mode B (Single Skill)** — `/test-design` 等单独使用，只加载本 Skill 上下文
- **Mode C (Composition)** — 组合多个 Skill，按需逐个加载

### 版本升级

- `VERSION` 文件定义源 repo 版本
- `install_project` 脚本首次安装（CLAUDE.md 仅创建不覆盖）
- `upgrade_project` 脚本原子升级（替换 `.claude/ll-rules.md` + `.claude/skills/`，不触及 CLAUDE.md 和 cases/）
- `.claude/ll-standards.version` 记录已安装版本

---

## v4.3.0

> 来源：AI Value Share 第二轮会议分析 + 端到端工作流审计。

### QA 工程化增强

- `templates/Test.md`：新增 `## API Test Cases` 节（端点表 + Error Code Coverage 表）和 `## Permission & Security Checklist` 节（6 项标准检查 + Permission Matrix Test 表）；Pass Criteria 增加 API 和权限验证项。
- `skills/test-design/SKILL.md`：Mandatory Sections 表新增 API Test Cases 和 Permission & Security（条件触发）；新增 API Test Rules 节和 Permission & Security Rules 节；新增 AC Traceability Rule（每个 AC 必须有对应测试用例）；Fix History Rule 改为原子三步（record → apply prevention rule to target file → proceed）。
- `skills/verification/SKILL.md`：新增 Completeness Checks 节 — AC Mapping 不允许空行，Test Results "Not Run" 必须在 Evidence / Notes 列说明原因；Fix History 规则同步改为原子落地。

### BA 需求结构化输入

- `templates/Scenario.md`：新增 `## Business Model Input` 节（Entities & Fields / State Machine / Permission Matrix / Notification Rules / Test Data），复杂业务场景必填、简单 CRUD 可跳过；Required Additional Documents 补充 AI_Risk_Level.md。
- `skills/scenario-analysis/SKILL.md`：Rule 5 要求复杂场景下 BA 填写 Business Model Input 后再进入 Solution.md。

### 可复用资产索引

- `reports/Reusable_Asset_Registry.md`：新增跨案例可复用资产集中索引，初始 8 条记录（Token 优化模式、Mapping 规则、QA 模式、成本基准）。

### 工作流阻塞修复（端到端审计）

- `skills/feature-dev/SKILL.md`：
  - Behavior 新增 Yellow 审批门控（Solution.md Human Approval 未签则不生成 Task.md / Test.md）和 Red 路径限制（仅分析文档）。
  - Model Selection 修正 Yellow 方案设计从 Opus 默认改为 Sonnet 默认（3+ 组件或 2 次失败才升级），消除每次 Yellow 案例的假阳性 Abnormal Cost Review。
  - Workflow 末端从 "invoke token-report skill" 改为 "follow steps inline"，消除 Mode 1 下的语义歧义。
- `skills/task-breakdown/SKILL.md`：从 9 行空壳扩展为完整 Skill（Required Input、Stop Conditions、Output 结构、5 条任务规则含 AC 追溯和 worktree 标注传递）。
- `skills/solution-design/SKILL.md`：新增 Risk-Level Gating（Green/Yellow/Red 三条路径）和 Track B Declaration 节。
- `skills/ll-standards/SKILL.md`：同步修正 Yellow 方案设计模型选择。
- `templates/Solution.md`：Post-Merge Test Plan 从 blockquote 改为命名节 `### Post-Merge Test Plan (Track B Declaration)`，与 Verify.md 结构对齐。
- `standards/AI_Token_Cost_Standard.md`：补充 `Retry Count = 2: Near Threshold` 触发条件（此前仅在 SKILL.md 存在）。
- `templates/AI_Case_Card.md`：Retry Root Cause 增加 `N/A if Retry = 0` 选项。
- `skills/verification/SKILL.md`：修正 "Notes column" 引用为 "Evidence / Notes column"。

### 参考文件同步

- 共修复 14 份 `skills/*/references/` 下的过期副本（Solution.md ×2、Verify.md ×2、Test.md ×3、Scenario.md ×2、AI_Verification_Standard.md ×1、Document_Naming_Standard.md ×4、CLAUDE.md ×1、AI_Token_Cost_Standard.md ×1、Token_Usage_Report.md ×1）。
- `GOVERNANCE.md` Rule 17：修改 templates/ 或 standards/ 后必须同步所有 skills/*/references/ 副本。

---

## v4.2.0

> 来源：对 4 个实际 FREIGHTLIST / VBO 案例（20260511–20260514）的逐一审查，与 V4.1 标准做差距对比分析后落地。

### Solution.md 必填 Technical Constraints 节

- `templates/Solution.md`：新增 `## Technical Constraints` 必填表（Java 语言级别、关键实体字段名、工具方法可用性、Mockito strictness、Worktree 构建可行性），标注为 Stop Condition — 未填写不允许进入 Task.md / Test.md 阶段。
- `skills/solution-design/SKILL.md`：新增 "Mandatory: Fill Technical Constraints Before Writing" 节，说明每项约束的验证方式和防止的 Retry 类别。

### JGit / Worktree 双轨验证协议

- `skills/verification/SKILL.md`：新增 Verification Protocol 节，定义 Track A（worktree 构建可用）和 Track B（worktree 构建不可用）两轨，Track B 需 Solution.md 声明 post-merge test plan 方可激活；Track B worktree 构建失败不计入 Retry。
- `templates/Verify.md`：新增 `## Post-Merge Test Plan`（合并前必填）和 `## Post-Merge Test Results`（合并后回填）两节。
- `standards/AI_Verification_Standard.md`：新增 Worktree Build Limitation Exemption 节，定义 Track B 生效的 4 个必要条件；不满足条件时构建失败仍计入 Retry。

### RA Draft 质量门控

- `skills/scenario-analysis/SKILL.md`：新增 RA Draft Quality Gate 节，移交 TA 前必须通过 5 项自检（数据来源、边界条件、AC 覆盖、已知问题范围、影响文件清单）；TA 返回 > 5 must-fix 触发 RA 质量偏差记录。

### AI_Case_Card 结构增强

- `templates/AI_Case_Card.md`：新增 `## Related Cases` 表（supersedes / amends / follow-up / depends-on）和 `## Quality Metrics` 节（Retry 根因分类、RA 质量偏差标注），将 Saved Time 字段名修正为 Saved Hours。

### Saved Hours 统一计算口径

- `standards/AI_Token_Cost_Standard.md`：新增 `## Saved Hours Calculation` 节，定义公式 `Saved Hours = Manual Estimate − AI-Assisted Actual Time`，明确 Manual Estimate 包含读代码 + 设计 + 实现 + 测试 + 文档，AI-Assisted Actual Time 包含 prompt 编写 + review + 决策点等待，纯机器执行时间不计入。
- `skills/token-report/references/AI_Token_Cost_Standard.md`：同步更新。

### 主 Claude 编排 Token 估算方法论

- `skills/token-report/SKILL.md` Step 2：新增主 Claude 编排 token 估算方法（Read/Glob/Grep × 3K input、文档写入 × 2K output、SubAgent dispatch × 500 output、每轮 Self-Fix ≈ 25K），标注 `(estimated, orchestration overhead)`。

### Retry 根因分类

- `skills/token-report/SKILL.md` Step 6：新增 Retry 根因分类注释规则：`[Logic]` 代码逻辑错误、`[Toolchain]` 工具链限制、`[Assumption]` 未验证假设，要求在 Retry Count 单元格注明类别。
- `templates/Token_Usage_Report.md`：Retry Count 列标题更新为 `Retry Count ([Logic]/[Toolchain]/[Assumption])`。
- `skills/token-report/references/Token_Usage_Report.md`：同步更新。

### 修复参考文件一致性

- `standards/AI_Token_Cost_Standard.md` + `skills/token-report/references/AI_Token_Cost_Standard.md`：补充遗漏的 Abnormal Cost Review 触发条件"Opus 用于 Yellow 风险任务须说明原因"（已在 SKILL.md Step 6 存在但未写入标准文件）。

---

## v4.1.0

### Hard Enforcement Layer（执行层约束）

- `skills/feature-dev/SKILL.md`：新增 Hard Enforcement Layer 节，将 6 条行为规则从被动原则提升为 Before-Read / Before-Write / Before-Response 三类执行检查点：禁止重复读文件、禁止读 >100KB 文件、写前必须先读、断言 API/版本前必须验证、禁止 sycophantic 开头、禁止 emoji 和 em-dash。
- `skills/ll-standards/SKILL.md`：新增 Hard Enforcement Constraints 表（8 行），与 feature-dev 同步。
- `templates/CLAUDE.md`：Section 2.6 新增 Concise Output 规则（禁用 sycophantic 短语、禁止 emoji 和 em-dash、返回结果优先于解释）。

### Model 路由策略细化

- `skills/feature-dev/SKILL.md`：Model Selection 表新增 Escalation Condition 列（8 行），明确何时从 Sonnet 升级到 Opus（连续 2 次失败、架构争议、复杂 Mock、探索后复杂度确认）。
- `skills/ll-standards/SKILL.md`：同步补充 Escalation Condition 列，修正模型名称大小写。

### 代码探索协议

- `skills/feature-dev/SKILL.md`：新增 Exploration Protocol 节 — Step 0（用户确认文件/类/服务范围）→ Step 1（读 CLAUDE.md Repository Structure）→ Step 2（Grep ≤ 3 轮）→ Step 3（停止再问）；Explore Agent 4 条件门控（Steps 0–3 耗尽 + Mode 3 + 无 Repo Structure + 记录 Abnormal Cost Review）。
- `skills/ll-standards/SKILL.md`：新增 Exploration Protocol 摘要节。

### QA 强化

- `templates/Test.md`：完整重写，新增 Test Scope、Test Data、Mock Strategy、Boundary Cases、Fix History 五个必填节；Mock Strategy 节包含 3 条 Mockito 注意事项（anyInt() / @MockitoSettings LENIENT / 预先声明 strictness）。
- `skills/test-design/SKILL.md`：新增 Mandatory Sections 表、Mock Strategy Rules 节、Fix History Rule 节（含 QA_Retry_Root_Cause.md 引用）。
- `skills/verification/SKILL.md`：每次 Self-Fix 后必须向 Test.md Fix History 追加一行，并引用 QA_Retry_Root_Cause.md。

### SubAgent 治理

- `GOVERNANCE.md` Rule 13：禁止在同一 case 执行中混用无关外部 Skill；组合须在 skill-compositions/ 预定义。
- `GOVERNANCE.md` Rule 14：所有项目开始 AI 案例前必须配置 CLAUDE.md；Rules-in-Prompt 仅作 fallback。
- `skills/token-report/SKILL.md` Step 5：SubAgent token 未上报时 Abnormal Cost Review 必须追加 `subAgent tokens not reconciled`；Stage-Level 与 Task-Level 一致性校验 ±10%。

### Abnormal Cost Review 触发条件扩充

- `standards/AI_Token_Cost_Standard.md`：新增两个触发条件 — Opus 用于 Code Implementation 阶段（任意风险等级）须记录原因；Explore Agent 用于 LL-only 模式须记录浪费 token 数。
- Model Naming Standard 节：Risk 字段禁用 emoji，统一纯文本 Green / Yellow / Red；Model 字段禁止版本号。
- Runtime Mode 节：CLAUDE.md 作为强制默认，附 benchmark 数据（$0.935 vs $1.318，+41% 差距）。

### 新模板与案例沉淀

- `templates/QA_Retry_Root_Cause.md`：新增 Self-Fix 根因分析模板（Symptom / Root Cause / Fix Action / Prevention Rules / Reusable Assets）。
- `templates/SubAgent_Token_Report.md`：新增 SubAgent 每 Group Token 追踪模板。
- `standards/Document_Naming_Standard.md` Section 5：登记上述两份可选补充文档及触发条件。
- `reports/case-studies/`：新增 4 份案例研究归档（BizDB、EDI、VBO Mixed Skill、VBO Large Feature）。
- `examples/token-usage/FREIGHTLIST_Token_Usage_Report_Annotated.md`：完整 Token Report 阅读指南，以 BizDB V4.0 为注释样本。

---

## v4.0.0

### Token 消耗记录完善

- `templates/Token_Usage_Report.md`：Task-Level 补全 Project、Retry Count、Memory/Sub Agent、Reusable 字段；Stage-Level 补全 Model、Cost 列。
- `standards/AI_Token_Cost_Standard.md`：新增字段格式定义表、Cost 计算公式和参考价格表（Haiku/Sonnet/Opus）、Abnormal Cost Review 触发阈值（4 条明确条件）、模型选择规则。
- `skills/token-report/SKILL.md`：从 7 行摘要扩展为完整可执行 Skill，包含触发时机、5 步操作流程、三级 Token 数据获取策略（UI 实测值 → subAgent 自报汇总 → 上下文估算）。
- `skills/token-report/references/`：同步更新 Token_Usage_Report.md 和 AI_Token_Cost_Standard.md 为最新版本。

### Model 策略

- `skills/ll-standards/SKILL.md`：新增 Model Selection 矩阵（6 种场景 × Sonnet/Opus/Haiku），包含 Red 路径禁令和 Haiku 仅限检索规则。
- `skills/feature-dev/SKILL.md`：内联 Model Selection 矩阵，要求每次 Agent 工具调用必须显式传 `model=` 参数；新增 SubAgent Requirements 章节，定义 Token 自报格式和汇总协议。
- 两个矩阵统一对齐：复杂方案设计场景均使用 `opus`，消除歧义。

### workflow 与文档完整性

- `skills/feature-dev/SKILL.md`：补全工作流缺失步骤（Technical Context、Mapping_Rules/Business_Rules、Implementation、PR_Template），工作流末端改为 `invoke token-report skill`，与 `templates/CLAUDE.md` Section 3 保持一致。

### 减少 MD 文档读取

- 删除 `skills/feature-dev/references/CLAUDE.md` 和 `skills/ll-standards/references/CLAUDE.md` 两份与 `templates/CLAUDE.md` 完全相同的副本。
- `templates/CLAUDE.md` 标注为 CLAUDE.md 规范的单一权威来源。
- `templates/Token_Usage_Report.md` 标注为权威来源，`skills/token-report/references/Token_Usage_Report.md` 标注为只读副本。

---

## v0.3.0

- Added `templates/AI_Risk_Level.md` as case-level risk output template.
- Added `standards/Document_Naming_Standard.md`.
- Added `standards/AI_Case_Output_Path_Standard.md`.
- Strengthened `feature-dev` Skill to enforce document naming and case folder output.
- Added strict validation options to Python, PowerShell and Bash scripts.
- Added cross-platform initialization scripts to avoid Python-only dependency.
- Updated usage docs with standard output path and validation commands.

## v0.2.0

- Integrated Karpathy-inspired behavior principles into `CLAUDE.md`.
- Added usage modes: global entry, single skill invocation, skill composition, custom skill.
- Added `skill-compositions/`.
- Added PowerShell and Bash scripts.

## v0.1.0

- Initial standards, templates, prompts, skills, examples, reports and scripts.
