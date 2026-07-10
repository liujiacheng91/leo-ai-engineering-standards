# AI Cases 工作目录

> LL AI 工程标准要求所有 AI 辅助研发的过程文档落到 `docs/ai/cases/<case-id>/`。本目录是**所有任务的产物归集地**，已替代旧的 `.claude/work/<task-slug>/`（旧目录保留作历史快照，不再用于新任务）。

## case-id 命名规范

格式：

```text
YYYYMMDD_FREIGHTLIST_<scenario-slug>
```

- `YYYYMMDD`：任务起手日期（绝对日期，不要写"今天"/"本周"）
- `FREIGHTLIST`：本服务的固定 team 标识（LL 标准的 `<team>` 占位符）
- `<scenario-slug>`：英文 kebab-case 短名，描述场景，例如 `ic-final-cache-lock`、`fl-tax-calc`、`pom-rounding-rule`

示例：

```text
docs/ai/cases/20260511_FREIGHTLIST_pom-rounding-rule/
docs/ai/cases/20260512_FREIGHTLIST_add-fl-tax/
```

> 历史 task-slug（如 `fix-ic-final-cache-lock`）保留在 `.claude/work/` 作快照，**不**回填到 cases。新任务取号时检查本目录已存在的 case-id 避免重复。

## 标准目录结构

```text
docs/ai/cases/<case-id>/
├── AI_Request.md             # 任务起手，主 Claude 或 RA(draft) 写
├── Scenario.md               # RA(draft / revise) 产出，含假设和待澄清
├── AI_Risk_Level.md          # TA(review) 评估时同步给出
├── Business_Rules.md         # 适用时（业务规则需明确化）
├── Mapping_Rules.md          # 适用时（字段映射 / XML / JSON / 报表 SQL）
├── Solution.md               # TA(architecture) 产出（Yellow/Red 必填）
├── Task.md                   # java-backend-engineer 实现计划
├── Test.md                   # qa-engineer 测试设计
├── Verify.md                 # qa-engineer 执行证据 + TA(code-review) 结论
├── PR_Template.md            # 主 Claude 收尾时生成
├── AI_Case_Card.md           # 任务卡片，主 Claude 收尾归档
└── Token_Usage_Report.md     # Token / ROI 报告，主 Claude 收尾归档
```

> 不允许使用 `final.md` / `temp.md` / `notes.md` / `all-in-one.md` / 中文名（如 `需求.md`）。文件名必须严格匹配上表。

### 风险等级最低文档集

按 `.claude/rules/ll-standards.md` 的风险三级：

**🟢 Green**（小改动 / 文档 / 简单 CRUD）：

```text
AI_Request.md, Scenario.md, AI_Risk_Level.md, Task.md, Test.md, Verify.md
```

**🟡 Yellow**（默认大多数 LiteFlow 节点改动）：

```text
AI_Request.md, Scenario.md, AI_Risk_Level.md,
Solution.md, Task.md, Test.md, Verify.md,
AI_Case_Card.md, Token_Usage_Report.md
```

涉及字段映射 / 报表 / 客户差异化逻辑时额外要求：

```text
Mapping_Rules.md 或 Business_Rules.md
```

**🔴 Red**（生产配置 / 核心算法 / DB schema）：

```text
AI_Request.md, Scenario.md, AI_Risk_Level.md,
Solution.md,                      # 只到 Solution，不实现
AI_Case_Card.md
```

Red 只允许分析与建议，**不**产出 Task/Test/Verify，**不**进 PR。

## 员工产物 ↔ LL 文档映射

主 Claude 调员工时，**必须**在 prompt 里指明 `case-id`，员工据此写到正确路径：

| LL 文档 | 由谁产出 | 触发阶段 |
|---|---|---|
| `AI_Request.md` | 主 Claude（或 RA draft 时一并） | 任务接入 |
| `Scenario.md` | `requirement-analyst`（draft / revise） | 需求澄清 |
| `AI_Risk_Level.md` | `tech-architect`（review） | 需求评审同步出风险 |
| `Business_Rules.md` / `Mapping_Rules.md` | `requirement-analyst`（finalize，适用时） | 需求定稿，引用全局需求池编号 |
| `Solution.md` | `tech-architect`（architecture） | 需求定稿后 |
| `Task.md` | `java-backend-engineer` | 实现前的拆解 |
| `Test.md` | `qa-engineer`（设计阶段） | code-review 通过后、执行前 |
| `Verify.md` | `qa-engineer`（执行阶段） | 单测跑完 + 含 TA(code-review) 结论摘要 |
| `PR_Template.md` | 主 Claude（或调 `/pr-summary` Skill） | 用户确认合并前 |
| `AI_Case_Card.md` | 主 Claude（任务收尾） | 合并后 |
| `Token_Usage_Report.md` | 主 Claude（任务收尾，可调 `/token-report` Skill） | 合并后 |

## 项目个性化辅助文档（不在 LL 标准内，但保留）

部分评审 / 过程记录在 LL 标准里没有直接位置，本项目保留作为内部追溯材料，**与 LL 文档并列**放在 case 目录下：

| 文件 | 由谁产出 | 目的 |
|---|---|---|
| `scenario-review.md` | `tech-architect`（review） | Scenario 评审意见（评审循环用） |
| `code-review.md` | `tech-architect`（code-review） | 实现评审意见（must-fix 清单） |
| `impl-notes.md` | `java-backend-engineer` | 实现过程笔记 / 决策日志（不替代 Task.md，作补充） |

这三份只面向内部协作，不作为 LL 合规交付物。

## 与全局需求池的协作

`.claude/requirements/` 是**项目级长期需求沉淀**（编号 `YYYYMMDD<4 位流水>`，瘦模板，支持 supersede / amends）。

- `AI_Request.md`：单次任务级的元数据，记录"做什么 + 引用哪个需求"
- `.claude/requirements/<id>.md`：业务规则的长期权威定义
- `Scenario.md` / `Business_Rules.md` 可以**引用**需求池编号（如 `REQ-202604300015`），但不必抄全文

任务定稿时（RA finalize），若新增需求，按需求池规则取新编号写到 `.claude/requirements/`，同时在 case 的 `AI_Request.md` 列编号链接。

## 收尾打包流程

任务完成（用户已 sign-off）后，主 Claude 必须确认以下 5 项产物齐全：

1. `Verify.md` 已包含 build / 测试 / lint 等证据
2. `PR_Template.md` 已写好，引用 Verify 关键证据 + 风险等级
3. `AI_Case_Card.md` 已生成（团队、Owner、风险、Case-ID、结果一句话）
4. `Token_Usage_Report.md` 已生成（模型、Token、自修复次数、ROI 备注）
5. 若有需求变更，`.claude/requirements/` 已 supersede / amends 完毕

齐全后再合并 PR；缺失任一项停下来让用户决定补还是放行。

**收尾三件套写作铁律**：写第 2/3/4 项前**必须先 Read** `docs/ai/templates/<同名>.md` 模板，严格按模板表格结构填写。`Token_Usage_Report.md` 模板要求三个表（Task-Level / Stage-Level / Abnormal Cost Review），每个 agent 返回的 token 明细（`total_tokens` / `tool_uses` / `duration_ms`）必须逐条记录到对应表格，不允许只写概要。

## 校验脚本（暂未引入）

LL 提供了 `./scripts/validate_ai_case.sh`，本仓库尚未引入。后续若引入，按 `docs/ai/usage/05-validation-guide.md` 在 PR 前手动跑一次。
