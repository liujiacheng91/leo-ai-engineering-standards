# 使用方式 2：单个 Skill 调用

```text
/scenario-analysis 请根据以下需求生成 Scenario.md
/risk-assessment 请根据 Scenario.md 判断风险等级并生成 AI_Risk_Level.md
/mapping-rules 请为这个 XML 到 JSON 转换生成 Mapping_Rules.md
/solution-design 请基于已确认的规则生成 Solution.md
/task-breakdown 请把 Solution 拆成 Task.md 和 Test.md
/verification 请根据执行结果生成 Verify.md
/token-report 请记录本次 Token 和 ROI
```

所有输出仍必须放在：

```text
docs/ai/cases/<case-id>/
```
