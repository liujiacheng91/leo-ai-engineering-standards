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

### Technical Environment (Pre-verified)

> Fill once per project. Values here are treated as verified facts by Solution.md Technical Constraints -- AI will confirm rather than re-discover.

- Java version / compile target:
- JAVA_HOME:
- Build tool + version:
- Worktree build supported: Yes / No (if No, state reason and Track B is default)
- Test framework:
- Mockito strictness:

### Repository Structure

```text
[填写主要目录结构]
```

---

## 2. LL AI Engineering Standards

本项目使用 LL AI Engineering Standards 作为 AI 辅助研发的行为约束和流程标准。

详细规则见 `.claude/ll-rules.md`（由标准仓库安装和升级管理，请勿手动编辑）。

核心要求：

- Think Before Coding / Simplicity First / Surgical Changes / Goal-Driven Execution
- 不猜 API / 版本 / 字段名，先读代码或文档
- 不重复读取已读文件，>100KB 跳过，>1000 行定向读取
- 结果优先，无冗余输出，无 sycophantic 开头，无 emoji / em-dash
- 所有过程文档输出到 `docs/ai/cases/<case-id>/`
- No Risk Level, No AI Execution
- 任何代码变更必须输出 `Verify.md`
