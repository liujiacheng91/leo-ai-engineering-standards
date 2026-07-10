# Test.md

## Test Objective

验证 Node5ProfitShare.calcGp 方法按 AC-1~AC-4 正确计算 FREIGHT_LIST_GP 行各 AgentType 的金额与 Total。

---

## Test Scope

- In scope: calcGp 方法、getGpByAgentCode 辅助方法
- Out of scope: calcProfitShareDistribution / calcSweep / ProfitShareTotal（不受本次改动影响）

---

## Test Data

| Case | Input | Expected |
|---|---|---|
| Normal: ORG+DST+SAL1 POM, 3 stations with FL charges | gpByStation={STA1:100, STA2:-50, STA3:200}, POM matches via isStationsEqual | Origin=100, Dest=-50, Sale1=200, Total=250 |
| Empty linkedFlCharges | gpByStation={} | All fields remain null/default |
| Null sectionPomList | meta.sectionPomList=null | Early return, no assignment |
| No station match | POM agentCode not matching any gpByStation key | BigDecimal.ZERO for that agent |
| CN-HK mapping | agentCode="CNSHA", stationCode="HKSHA" via cnHkStationMap | Matched via isStationsEqual |
| Two SAL POM entries | SAL POM with saleIndex=1 and saleIndex=2 | Sale1 and Sale2 assigned separately |

---

## Mock Strategy

- Mock framework: Mockito
- Objects to mock: BusFreightSummaryMetaV1 (partial mock / spy for isStationsEqual), FlAggregationSectionPomEntity
- Stub setup location: @BeforeEach
- Strictness setting: LENIENT (calcGp is private, testing via reflection or through processIml path; some stubs may not be used by all test methods)

---

## Test Types

- [x] Unit Test
- [ ] Integration Test
- [ ] API Contract Test
- [ ] UI Test
- [ ] E2E Test

---

## Test Matrix

| Test Case | Type | Related AC | Priority |
|---|---|---|---|
| calcGp with normal POM list assigns per AgentType | Unit | AC-1 | High |
| calcGp reuses calcFlGpByStation (no manual AR/AP logic) | Unit | AC-2 | High |
| Station matching uses isStationsEqual not direct get | Unit | AC-3 | High |
| Total = sum of Origin+Dest+Sale1+Sale2 | Unit | AC-4 | High |
| Empty gpByStation returns early | Unit | AC-1 | Medium |
| Null sectionPomList returns early | Unit | AC-1 | Medium |
| No matching station returns ZERO | Unit | AC-3 | Medium |
| SAL POM correctly split into Sale1/Sale2 | Unit | AC-1 | Medium |

---

## Boundary Cases

- sectionPomList has POM entries with agentCode blank/null
- gpByStation has negative GP values (AP > AR for a station)
- Multiple POM entries with same AgentType (e.g., duplicate ORG due to data issues)

---

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| (none) | | | | |
