# Test.md

## Test Objective

验证 Node31AutoMode.processIml() 的三条分支：ACT走autoModeWorkflow、非ACT走fullAutoWorkflow、sectionHeader为null跳过。

## Test Scope

- In scope: Node31AutoMode.processIml() 控制流分支
- Out of scope: fullAutoWorkflow/semiAutoWorkflow/autoModeWorkflow 内部逻辑（已有独立case覆盖）

## Mock Strategy

- Mock framework: Mockito
- Objects to mock: IIcAutoModeService, IcTransMeta, IcTransMetaItem, IcSectionHeaderEntity
- Stub setup location: @BeforeEach
- Strictness setting: LENIENT -- 三个测试共享部分stub但各自消费不同子集

## Test Matrix

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-1 | Unit | transType=ACT, finalList有AR记录 | 调用autoModeWorkflow路径 | P0 | AC-1 |
| TC-2 | Unit | transType=PRV | 调用fullAutoWorkflow后continue | P0 | AC-2 |
| TC-3 | Unit | currentIcSectionHeader=null | 跳过，不调用任何workflow | P0 | AC-3 |

## Boundary Cases

| Scenario | Input | Expected Behavior |
|---|---|---|
| metaList为空 | 空list | 不进入循环，不调用任何方法 |
| transType为null | sectionHeader.transType=null | 不等于ACT，走fullAutoWorkflow |

## Pass Criteria

- [x] All new tests passed
- [ ] Build passed (Track B -- worktree无法执行gradle build)
- [x] No high-risk security issue
- [x] No sensitive data exposed

## Fix History

| Fix # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
