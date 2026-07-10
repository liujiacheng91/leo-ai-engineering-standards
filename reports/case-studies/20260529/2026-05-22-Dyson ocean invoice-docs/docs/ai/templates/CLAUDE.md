# CLAUDE.md

## 1. Project Context

### Project Name

[填写项目名称]

### Business Context

[简要说明项目业务背景]

### Technical Stack

- Backend:
- Frontend:
- Database:
- CI/CD:
- Testing:

### Repository Structure

```text
[填写主要目录结构]
```

---

## 2. Default Behavior Mode: Karpathy-Inspired Discipline

本项目默认启用 Karpathy-inspired Claude Code 行为约束。目标是降低错误假设、减少过度设计、减少无关 diff、减少返工，从而降低 Token 消耗并提升结果准确性。

### 2.1 Think Before Coding

Claude 必须先列假设、暴露不确定点、提出澄清问题，不允许在业务规则不清时直接实现。

### 2.2 Simplicity First

Claude 必须优先选择最简单、最小、最直接的实现，不添加未要求的功能、抽象、配置和扩展点。

### 2.3 Surgical Changes

Claude 只能修改与当前任务直接相关的文件。每一行 diff 都必须能追溯到当前需求。

### 2.4 Goal-Driven Execution

Claude 必须将任务转化为可验证目标：目标 → 动作 → 验证方式 → 通过标准。

---

## 3. LL AI-assisted SDLC Workflow

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

---

## 4. Output Path Requirement

所有过程文档必须输出到：

```text
docs/ai/cases/<case-id>/
```

`<case-id>` 推荐格式：

```text
YYYYMMDD_<team>_<scenario-slug>
```

---

## 5. Fixed Document Names

过程文档必须使用以下固定名称：

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

---

## 6. Risk Rules

```text
Green  - AI 可自主实现、测试、验证
Yellow - AI 可实现，但必须人工确认方案和结果
Red    - AI 只允许分析和建议，不允许自主修改或合并
```

Rule:

```text
No Risk Level, No AI Execution.
```

---

## 7. Forbidden Practices

Claude 严禁：

- 处理密钥、Token、证书、私钥；
- 处理生产数据或未脱敏客户数据；
- 访问生产环境或生产数据库；
- 修改生产配置；
- 删除测试、降低断言、关闭质量规则；
- 绕过认证、授权、加密、审计逻辑；
- 自动合并 Red 风险变更。

---

## 8. Verification Requirement

任何代码变更必须输出 `Verify.md`。

无法执行的验证必须说明原因。

---

## 9. Stop Conditions

遇到以下情况必须停止：

1. 需求不清。
2. 风险等级缺失。
3. Yellow 场景未确认 Solution。
4. Red 场景要求 AI 修改代码。
5. 自修复超过 3 次。
6. 测试无法执行且无法解释原因。
7. 涉及生产配置或敏感数据。
