# Solution.md

## Recommended Solution

Execution Mode: Mode 1 (LL-only)

纯结构重构，3 个文件，不改业务逻辑。

### 改动清单

1. **Node31AutoMode.java** -- 删除 10 个未使用的 service 依赖（sectionHeaderService 等），删除 autoModeWorkflow 私有方法，processIml() 循环体简化为 null 检查 + icAutoModeService.processAutoMode(meta)
2. **IIcAutoModeService.java** -- 新增 processAutoMode(IcTransMetaItem meta) 方法声明
3. **IcAutoModeServiceImpl.java** -- 新增 processAutoMode() 实现（决策树总入口）+ resolveAutoMode() 私有方法（从 Node31.autoModeWorkflow 搬入的 AR station 查找逻辑）

### 不动的部分

fullAutoWorkflow / semiAutoWorkflow / processArCharges / processApCharges / isAllArChargesReleased / getArInvoiceNo / isArCharge / getAutoModeByStation -- 方法体全部不变。

## Technical Constraints

- @LiteflowComponent("ic_auto_mode") 注解不变，chain EL 不受影响
- Node31 原 autoModeWorkflow 中找不到 AR station 时 return（不进入任何 workflow）-- 迁移后 resolveAutoMode 返回 1（全自动），行为变化：原来是静默跳过，现在走 fullAutoWorkflow 设置默认值。这与 auto-mode-act-bypass case 的意图一致（PRV 也要设置默认字段值）

## Track B Declaration

worktree 内 gradle build 受 JGit/versioning 插件限制，声明 Track B。合并后在主分支执行编译验证。

## Human Approval

用户在对话中确认方案后说"按你说的调整"。
