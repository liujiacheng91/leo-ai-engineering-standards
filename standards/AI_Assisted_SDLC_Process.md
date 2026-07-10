# AI Assisted SDLC Process

## Positioning

当前阶段定义为：

```text
AI 辅助研发试用 2.0 / 3.0 过渡阶段
```

推荐定义：

```text
在明确风险分级、标准流程、模板约束、人工确认、验证闭环下的 AI 辅助研发实践。
```

## Standard Process

```text
AI_Request.md
→ Scenario.md
→ AI_Risk_Level.md
→ Selection Path
→ Technical Context
→ Solution.md
→ Mapping_Rules.md / Business_Rules.md, if applicable
→ Task.md
→ Test.md
→ Implementation
→ Verify.md
→ PR_Template.md
→ AI_Case_Card.md
→ Token_Usage_Report.md
```

## Output Path

所有过程文档必须输出到：

```text
docs/ai/cases/<case-id>/
```

## Stop Conditions

- 需求不清；
- 风险等级缺失；
- Yellow 场景未确认 Solution；
- Red 场景要求 AI 修改代码；
- 自修复超过 3 次；
- 测试无法执行且无法解释原因；
- 涉及生产配置或敏感数据。
