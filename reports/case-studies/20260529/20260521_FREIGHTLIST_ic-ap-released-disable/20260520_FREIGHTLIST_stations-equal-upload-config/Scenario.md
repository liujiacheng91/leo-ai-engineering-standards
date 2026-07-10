# Scenario - stations-equal-upload-config

## Background
`BusFreightSummaryMetaV1.isStationsEqual` 用于判断两个站点是否"等效". 当前逻辑支持直接字符串相等和 `cnHkStationMap` 双向映射. 现在需要增加第三种等效判断: 通过 `reportUploadStationConfigEntityList` 中的 agentCode/uploadStation 配置对来匹配.

## Acceptance Criteria
- AC-1: 当 station1 等于某条配置的 flAruscAgentCode 且 station2 等于同一条配置的 flAruscUploadStation 时, isStationsEqual 返回 true
- AC-2: 当 station2 等于某条配置的 flAruscAgentCode 且 station1 等于同一条配置的 flAruscUploadStation 时, isStationsEqual 返回 true
- AC-3: 新判断逻辑在"直接相等判断"之后、"cnHkStationMap 映射判断"之前执行
- AC-4: reportUploadStationConfigEntityList 为 null 或空时, 跳过该判断, 不影响后续逻辑
- AC-5: 循环中找到第一组匹配即返回 true, 无需继续遍历

## Assumptions
- `reportUploadStationConfigEntityList` 已作为类字段存在(第71行), 数据由上游节点填充
- `FlAggregationReportUploadStationConfigEntity` 的 `getFlAruscAgentCode()` 和 `getFlAruscUploadStation()` 方法已验证存在(getUploadStations 方法第336-341行已使用)
