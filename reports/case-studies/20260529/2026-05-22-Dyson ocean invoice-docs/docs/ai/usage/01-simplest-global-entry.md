# 使用方式 1：最简单的全局入口 Skill

## 调用方式

```text
/feature-dev 请根据我的需求，按照 LL AI 标准流程生成中间文档并判断风险
```

## 自动生成链路

```text
AI_Request.md
→ Scenario.md
→ AI_Risk_Level.md
→ Solution.md, if needed
→ Task.md
→ Test.md
→ Verify.md
```

## 输出路径

```text
docs/ai/cases/<case-id>/
```

## 价值

- 降低用户理解成本；
- 让 Claude 自动按模板提问和生成文档；
- 让中间文档天然统一格式；
- 支持脚本校验。
