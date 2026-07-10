# Scenario.md

## Case Info

- Case ID: 20260519_FREIGHTLIST_node5-calc-gp
- Scenario: 补充 Node5ProfitShare calcGp 计算逻辑

## Background

Node5ProfitShare 的 `calcGp` 方法当前为空方法体（仅一行注释 `//计算FREIGHT_LIST_GP`）。该方法在 processIml 第 152-153 行被调用，用于生成 FREIGHT_LIST_GP 行（AmountType.SECTION_PS_FREIGHT_LIST_GP = "FREIGHT_LIST_CHARGE_TOTAL"），在 sectionProfitShareList 中排 sequence=9。

## Requirements

### AC-1

当存在 linkedFlCharges 和 sectionPomList 时，calcGp 应根据各 POM 的 AgentType，将对应站点的 FL GP（AR 加 AP 减）赋值到 freightListGpEntity 的 Origin/Destination/Sale1/Sale2 字段。

### AC-2

站点 GP 计算复用 BusFreightSummaryMetaV1.calcFlGpByStation()（getMaxGpStation 的底层方法），不重复实现 AR/AP 累加逻辑。

### AC-3

站点匹配使用 meta.isStationsEqual() 处理 CN-HK 站点映射场景，而非直接 HashMap.get()。

### AC-4

Total 字段 = Origin + Destination + Sale1 + Sale2 之和（与 calcProfitShareDistribution 的 Total 计算模式一致）。

## Assumptions

- calcGp 的 freightListGpEntity 不参与 ProfitShareTotal 计算（确认：processIml line 143-149 的 ProfitShareTotal 仅由 Distribution + Sweep 组成），因此改动不影响"共享果子"
- ThirdParty 字段保持注释/跳过状态（与现有 calcProfitShareDistribution / calcSweep 一致）

## Scope

- 改动文件：Node5ProfitShare.java（1 个文件）
- 不改动 BusFreightSummaryMetaV1.java（复用已有方法）
- 不改动 AmountType / Entity / 其他节点
