# Scenario.md

## Requirement

Node31AutoMode 当前存在结构问题：注入 10 个未使用的 service、决策树分裂在 Node 和 Service 两处、autoModeWorkflow 业务逻辑放在节点而非 Service。需要在不改变业务结果的前提下重构，使决策树集中在 Service、Node 只做薄壳委托。

## Acceptance Criteria

- AC-1: Node31AutoMode 构造器仅注入 IIcAutoModeService 一个依赖
- AC-2: Node31AutoMode.processIml() 循环体只做 null 检查 + 委托 icAutoModeService.processAutoMode(meta)
- AC-3: IcAutoModeServiceImpl.processAutoMode() 包含完整决策树（非ACT走fullAuto、ACT按station判断semi/full）
- AC-4: 原 Node31.autoModeWorkflow 的 AR station 查找逻辑迁移到 IcAutoModeServiceImpl.resolveAutoMode()
- AC-5: fullAutoWorkflow / semiAutoWorkflow / processArCharges / processApCharges 等现有方法体不变
- AC-6: 编译通过，无新增/删除的 public API 破坏（除新增 processAutoMode 外）
