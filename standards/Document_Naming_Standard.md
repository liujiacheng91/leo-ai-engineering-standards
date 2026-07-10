# Document Naming Standard

## 1. Fixed Process Document Names

所有 AI 过程文档必须使用以下固定文件名，不允许随意改名：

```text
AI_Request.md
Scenario.md
AI_Risk_Level.md
Business_Rules.md
Mapping_Rules.md
Solution.md
Task.md
Test.md
Verify.md
PR_Template.md
AI_Case_Card.md
Token_Usage_Report.md
```

## 2. Case Folder Naming

案例目录必须放在：

```text
docs/ai/cases/<case-id>/
```

推荐 `<case-id>` 格式：

```text
YYYYMMDD_<team>_<scenario-slug>
```

示例：

```text
docs/ai/cases/20260510_IFF_mapping-address-rule/
docs/ai/cases/20260510_WMS_green-crud-order-status/
docs/ai/cases/20260510_FIN_report-sql-aging/
```

## 3. Skill Naming

Skill 名称必须使用小写字母、数字和连字符：

```text
ll-dev
ll-setup
ll-standards
scenario-analysis
risk-assessment
mapping-rules
solution-design
task-breakdown
test-design
verification
pr-summary
token-report
```

## 4. Prompt Naming

Prompt 文件使用 PascalCase 或下划线命名：

```text
Code_Understanding.md
Scenario_Analysis.md
Solution_Design.md
Task_Breakdown.md
Test_Generation.md
Verification.md
Review.md
```

## 5. Optional Supplementary Documents

以下文档不是每个案例的必须文档，仅在特定条件下触发创建。命名固定，不允许改名。

| Document | Trigger | Location |
|---|---|---|
| `QA_Retry_Root_Cause.md` | 任何 Self-Fix 发生后，需要详细记录根因和预防规则时 | `docs/ai/cases/<case-id>/` |
| `SubAgent_Token_Report.md` | Mode 3 执行中，每个 SubAgent Group 完成后 | `docs/ai/cases/<case-id>/` |

模板位置：`templates/QA_Retry_Root_Cause.md`、`templates/SubAgent_Token_Report.md`

## 6. Do Not Use

不允许使用：

```text
final.md
temp.md
all-in-one.md
notes.md
AI.md
Merge_Decision.md
需求.md
方案.md
测试.md
验证.md
```

`Merge_Decision.md` 的内容应合并到 `Solution.md ## Human Approval` 中。合并决定、审批人和日期均在 Solution.md 中记录，无需单独文件。

其他名称不允许的原因：无法被脚本稳定校验，也不利于跨团队复盘和统计。
