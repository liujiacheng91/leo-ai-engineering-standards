# CLAUDE.md

## 1. Project Context

### Project Name

LL AI Engineering Standards

### Business Context

Claude Code AI-assisted SDLC 标准仓库。提供三层架构（Governance / Skills / Application）的行为约束、流程模板和插件系统，供下游项目通过 `claude plugin install` 或 `install_project.py` 安装使用。

### Technical Stack

- Runtime: Claude Code plugin system + shell scripts
- Install: Python 3 (install_project.py)
- Templates: Markdown
- Versioning: Git tags (vX.Y.Z)
- CI/CD: N/A (template repository)

### Technical Environment (Pre-verified)

- Java version / compile target: N/A (非 Java 项目)
- JAVA_HOME: N/A
- Build tool + version: N/A
- Worktree build supported: N/A
- Test framework: N/A
- Mockito strictness: N/A

### Repository Structure

```text
.
├── skills/            # 独立 Skill 定义（每个含 SKILL.md + references/）
├── skill-compositions/# Skill 组合编排
├── templates/         # 项目模板（CLAUDE.md, cases/ 等）
├── scripts/           # 安装/同步脚本
├── prompts/           # Prompt 模板
├── references/        # 共享引用文档（sdlc-detail.md 等）
├── standards/         # 标准规则定义
├── optimization/      # Token 优化相关
├── reports/           # 报告模板
├── cases/             # 案例示例
├── examples/          # 使用示例
├── usage/             # 使用文档
├── CLAUDE.md          # 本文件（Section 1 项目信息 + Section 2 标准摘要）
├── ll-rules.md        # 详细规则（与 .claude/ll-rules.md 同步）
├── GOVERNANCE.md      # 完整 20 条治理规则
├── SDLC.md            # 执行模式、角色定义、案例证据链
└── VERSION            # 版本号
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
