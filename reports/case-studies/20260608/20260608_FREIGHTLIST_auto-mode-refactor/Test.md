# Test.md

## Test Objective

验证重构后 Node31AutoMode + IcAutoModeServiceImpl.processAutoMode() 的决策树行为与重构前一致。

## Test Scope

- In scope: processAutoMode 决策分派（非ACT/ACT-semi/ACT-full），resolveAutoMode AR station 查找
- Out of scope: fullAutoWorkflow/semiAutoWorkflow 内部逻辑（未改动）

## Mock Strategy

- Mock framework: Mockito
- Objects to mock: IcTransMetaItem, IcSectionHeaderEntity, IcTransactionFinalEntity, MdAutoProgramPartiesEntity
- Strictness: LENIENT

## Test Matrix

| Case ID | Input | Expected | Priority | Related AC |
|---|---|---|---|---|
| TC-1 | transType=PRV | 调用 fullAutoWorkflow | P0 | AC-3 |
| TC-2 | transType=ACT, party autoMode=0 | 调用 semiAutoWorkflow | P0 | AC-3 |
| TC-3 | transType=ACT, party autoMode=1 | 调用 fullAutoWorkflow | P0 | AC-3 |
| TC-4 | transType=ACT, finalList 为空 | 默认全自动(1)，调用 fullAutoWorkflow | P1 | AC-4 |
| TC-5 | transType=ACT, 无 AR 记录 | 默认全自动(1)，调用 fullAutoWorkflow | P1 | AC-4 |
| TC-6 | sectionHeader=null | Node31 跳过，不调用 processAutoMode | P0 | AC-2 |

## Fix History

| Fix # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
