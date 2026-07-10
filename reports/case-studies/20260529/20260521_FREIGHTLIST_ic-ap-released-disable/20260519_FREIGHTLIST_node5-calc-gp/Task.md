# Task.md

## Case Info

- Case ID: 20260519_FREIGHTLIST_node5-calc-gp

## Tasks

### Task 1: 添加 Map import

- File: Node5ProfitShare.java
- Action: 添加 `import java.util.Map`

### Task 2: 实现 calcGp 方法体

- File: Node5ProfitShare.java
- Method: calcGp(FlAggregationSectionProfitShareEntity, BusFreightSummaryMetaV1)
- Action:
  1. 空值检查（meta / sectionPomList）
  2. 调用 meta.calcFlGpByStation() 获取 GP Map
  3. 遍历 sectionPomList，按 AgentType 赋值
  4. 计算 Total

### Task 3: 新增 getGpByAgentCode 辅助方法

- File: Node5ProfitShare.java
- Action: 私有方法，封装 isStationsEqual 匹配 GP Map 的逻辑
