# Task

1. `IIcAutoModeService.getAutoModeByStation` 增加 `List<MdAutoProgramPartiesEntity> partyList` 参数
2. `IcAutoModeServiceImpl.getAutoModeByStation` 实现筛选逻辑
3. `Node31AutoMode.autoModeWorkflow` 调用处传入 `meta.getPartyList()`
