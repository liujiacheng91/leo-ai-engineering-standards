# AI_Request.md

## Task

重构 Node31AutoMode：删除 10 个未使用的 service 依赖，将 autoModeWorkflow 业务逻辑从 Node 搬到 IcAutoModeServiceImpl，Node 只做迭代+委托。

## Scope

- Node31AutoMode.java -- 删依赖、简化 processIml
- IIcAutoModeService.java -- 新增 processAutoMode 方法
- IcAutoModeServiceImpl.java -- 新增 processAutoMode + resolveAutoMode

## Branch Info

- Base Branch: develop_1.1.0
- Task Type: refactor
- User Confirmation: 用户在对话中确认方案后说"按你说的调整"
