# Solution

## Technical Constraints

- Pre-verified Environment: worktree + JGit 不兼容，走 Track B
- 改动文件: `IIcAutoModeService.java`(接口) + `IcAutoModeServiceImpl.java`(实现) + `Node31AutoMode.java`(调用处)

## Task

1. `IIcAutoModeService`: 方法签名增加 `List<MdAutoProgramPartiesEntity> partyList` 参数
2. `IcAutoModeServiceImpl.getAutoModeByStation`: 实现筛选逻辑 -- 按 partyId 匹配 + joinDate > now + stage > 0，多条取 joinDate 最大，返回 autoMode，无匹配返回 0
3. `Node31AutoMode.autoModeWorkflow`: 调用处传入 `meta.getPartyList()`
