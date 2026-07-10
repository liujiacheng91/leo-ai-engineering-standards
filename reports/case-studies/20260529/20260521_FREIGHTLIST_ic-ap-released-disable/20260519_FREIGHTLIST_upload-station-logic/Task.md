# Task - upload-station-logic

## Implementation Plan

### Task 1: BusFreightSummaryMetaV1.getUploadStations 签名和逻辑调整

- 文件: `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/meta/BusFreightSummaryMetaV1.java`
- 返回类型从 `List<String>` 改为 `String`
- 移除 `ArrayList` 收集逻辑，首个匹配直接 return
- 无匹配时返回 agentCode（而非空列表）

### Task 2: Node3ShipmentPom 调用逻辑简化

- 文件: `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/node/v1/Node3ShipmentPom.java`
- Lines 181-194 原逻辑（先 put agentCode + 再遍历 List put 各站点）替换为单次 put
- 保留 `!uploadMap.containsKey` 守卫维持 first-wins 语义

## Verification

- 编译检查: `gradle :expand:business-freightlist-summary:compileJava`
- 仓库无 src/test，Track B 验证
