# Solution.md

## Solution Overview

修改 `Node31AutoMode.processIml()` 的控制流：将非 ACT 类型从 `continue`（跳过）改为直接调用 `icAutoModeService.fullAutoWorkflow(meta)`。ACT 类型保持原有 `autoModeWorkflow` 逻辑不变。

## Technical Constraints

| 约束项 | 验证方式 | 结论 |
|---|---|---|
| Java 语言级别 | 读 build.gradle | Java 21 |
| fullAutoWorkflow 方法签名 | Grep 源码 | `void fullAutoWorkflow(IcTransMetaItem meta)` -- IIcAutoModeService:57, IcAutoModeServiceImpl:114 |
| IcStatus.ACTUAL 常量值 | 读 IcStatus.java:13 | `"ACT"` |
| Node31AutoMode 已注入 icAutoModeService | 读 Node31AutoMode.java:36,49 | 已通过构造器注入 |
| Worktree 构建可行性 | 已知 JGit + versioning 插件限制 | Track B |

### Post-Merge Test Plan (Track B Declaration)

- Command: `gradle :expand:business-freightlist-summary:compileJava`
- Owner: Liangwb
- Timing: 合并到 develop_1.1.0 后立即执行

## Impact Analysis

### Affected Files

- `Node31AutoMode.java` -- processIml() 控制流调整（约 5 行改动）

### Affected Modules

- expand/business-freightlist-summary

## Recommended Solution

在 `Node31AutoMode.processIml()` 中：

1. 保留 `currentIcSectionHeader == null` 时 `continue` 的判断（AC-3）
2. 将 `transType != ACT` 时的 `continue` 改为调用 `icAutoModeService.fullAutoWorkflow(meta)` 后 `continue`（AC-2）
3. ACT 类型仍走原有 `autoModeWorkflow(meta)` 逻辑（AC-1）

改动后的控制流：
```
for each meta:
  if sectionHeader == null -> continue
  if transType != ACT -> fullAutoWorkflow(meta) + continue
  if transType == ACT -> autoModeWorkflow(meta)  // 原逻辑
```

## Security Considerations

无安全影响。不涉及认证、授权、加密、审计逻辑。

## Test Strategy

单测验证三条分支：ACT 走 autoModeWorkflow、非 ACT 走 fullAutoWorkflow、sectionHeader 为 null 跳过。

## Rollback Plan

还原 Node31AutoMode.processIml() 中的 if 判断为原始 `continue`。

## Human Approval

- 风险等级确认: Yellow
- 方案确认: 用户确认非ACT类型改为调用 fullAutoWorkflow
- 合并目标: develop_1.1.0
- Feature Branch: feat/auto-mode-act-bypass
- Commit: 9dc36b1
- 单测: 未执行（Track B，worktree JGit 不兼容，合并后由 Liangwb 执行）
