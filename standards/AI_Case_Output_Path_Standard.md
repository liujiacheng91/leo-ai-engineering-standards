# AI Case Output Path Standard

## 1. Standard Output Path

所有 AI 辅助研发案例必须输出到：

```text
docs/ai/cases/<case-id>/
```

## 2. Standard Case Folder Structure

```text
docs/ai/cases/<case-id>/
├── AI_Request.md
├── Scenario.md
├── AI_Risk_Level.md
├── Business_Rules.md              # if applicable
├── Mapping_Rules.md               # if applicable
├── Solution.md                    # Yellow / Red required
├── Task.md                        # Green / Yellow implementation required
├── Test.md
├── Verify.md                      # if implementation or verification occurred
├── PR_Template.md                 # if PR is created
├── AI_Case_Card.md
└── Token_Usage_Report.md
```

## 3. Risk-Based Minimum Documents

### Green

```text
AI_Request.md
Scenario.md
AI_Risk_Level.md
Task.md
Test.md
Verify.md
```

### Yellow

```text
AI_Request.md
Scenario.md
AI_Risk_Level.md
Solution.md
Task.md
Test.md
Verify.md
AI_Case_Card.md
Token_Usage_Report.md
```

如果涉及 Mapping / SQL / 转换逻辑，必须增加：

```text
Mapping_Rules.md 或 Business_Rules.md
```

### Red

```text
AI_Request.md
Scenario.md
AI_Risk_Level.md
Solution.md
AI_Case_Card.md
```

Red 场景 AI 只允许分析和建议，不允许自主修改或合并。

## 4. Validation

推荐在 PR 前执行：

```bash
./scripts/validate_ai_case.sh docs/ai/cases/<case-id> --risk yellow --strict --require-case-card --require-token-report
```
