# Task.md

## Task Goal

重构 Node31AutoMode：删除未使用依赖，将决策逻辑搬到 IcAutoModeServiceImpl，Node 只做薄壳委托。

## Task Breakdown

| Task ID | Task | Files | Done Criteria |
|---|---|---|---|
| T1 | Node31 删 10 个未使用依赖，保留 IIcAutoModeService | Node31AutoMode.java | 构造器仅 1 个参数 |
| T2 | Node31 删 autoModeWorkflow，processIml 改为委托 | Node31AutoMode.java | 循环体只剩 null 检查 + processAutoMode |
| T3 | 接口新增 processAutoMode | IIcAutoModeService.java | 方法声明 + Javadoc |
| T4 | 实现 processAutoMode + resolveAutoMode | IcAutoModeServiceImpl.java | 非ACT走fullAuto，ACT按station判semi/full |
