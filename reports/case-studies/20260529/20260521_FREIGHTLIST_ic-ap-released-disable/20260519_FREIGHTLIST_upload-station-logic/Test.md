# Test Design - upload-station-logic

## Test Scope

`BusFreightSummaryMetaV1.getUploadStations` 方法逻辑变更 + `Node3ShipmentPom` 调用侧适配。

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | agentCode 有配置站点 | agentCode="AGENT1", config 含匹配记录 uploadStation="STATION_X" | 返回 "STATION_X" | AC-1 |
| 2 | agentCode 无配置站点 | agentCode="AGENT2", config 无匹配记录 | 返回 "AGENT2" | AC-2 |
| 3 | agentCode 为空 | agentCode=null 或 "" | 返回 null | AC-3 |
| 4 | config 列表为空 | agentCode="AGENT1", reportUploadStationConfigEntityList=null | 返回 "AGENT1" | AC-2 |
| 5 | Node3 uploadMap first-wins | 两个 POM 同 agentCode，同 uploadStation | uploadMap 仅保留第一个 | AC-4 |
| 6 | 多条 config 匹配同一 agentCode | agentCode="AGENT1", config 有 2 条匹配 | 返回首条匹配的 uploadStation | AC-1 |

## Mock Strategy

仓库无 src/test 基础设施。测试设计为静态断言 + 代码审查验证。

## Fix History

(empty)
