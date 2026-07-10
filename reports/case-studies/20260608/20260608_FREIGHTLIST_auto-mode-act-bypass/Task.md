# Task.md

## Task Goal

修改 Node31AutoMode.processIml() 的 transType 分支逻辑：非ACT时调用 fullAutoWorkflow 而非跳过。

## Related Documents

- AI_Request.md
- Scenario.md
- AI_Risk_Level.md
- Solution.md

## Task Breakdown

| Task ID | Task | Input | Output | Files | Done Criteria | Verification |
|---|---|---|---|---|---|---|
| T1 | 修改 processIml() 控制流 | Node31AutoMode.java:80-83 | 非ACT走fullAutoWorkflow+continue | Node31AutoMode.java | ACT走autoModeWorkflow，非ACT走fullAutoWorkflow | 代码审查+单测 |

## Function-Level Design

| Function / API | Responsibility | Input | Output | Error Handling | Test Requirement |
|---|---|---|---|---|---|
| Node31AutoMode.processIml() | 按transType分流自动模式处理 | IcTransMeta上下文 | meta中字段被设置 | 外层process()吞异常 | 验证三条分支：ACT/非ACT/null header |
