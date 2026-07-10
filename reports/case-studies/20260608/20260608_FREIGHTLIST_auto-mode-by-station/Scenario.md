# Scenario: auto-mode-by-station

## 需求描述

补充 `IIcAutoModeService.getAutoModeByStation` 的占位逻辑（当前硬编码返回 0），改为从 partyList 中查找匹配的 party 并返回其 `mdAppAutoMode`。

## 验收标准

- AC-1: 遍历 partyList，筛选 `mdAppPartyId == arStationCode` 且 `mdAppJoinDate > 当前时间` 且 `mdAppStage > 0` 的记录
- AC-2: 多条匹配时取 `mdAppJoinDate` 最大的一条
- AC-3: 返回匹配 party 的 `mdAppAutoMode` 值
- AC-4: 无匹配 party 时返回 0（半自动）
- AC-5: 方法签名需增加 `List<MdAutoProgramPartiesEntity> partyList` 参数，接口和调用处同步修改
