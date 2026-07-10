# Task.md

## Task Goal

暂时关闭 IC 触发链中 All AP RELEASED 校验逻辑，`isAllApChargeReleased` 方法固定返回 `true`，原有逻辑注释保留。

## Related Documents

- AI_Request.md
- Scenario.md
- AI_Risk_Level.md
- Solution.md

## Task Breakdown

| Task ID | Task | Input | Output | Files | Done Criteria | Verification |
|---|---|---|---|---|---|---|
| T-1 | 注释 `isAllApChargeReleased` 方法体，固定返回 true | Solution.md | 代码修改 | `IcTriggerConfigServiceImpl.java` | 方法体注释、return true、Javadoc 保留 | 静态 review + AC trace |

## Function-Level Design

| Function / API | Responsibility | Input | Output | Error Handling | Test Requirement |
|---|---|---|---|---|---|
| `isAllApChargeReleased(IcTransMetaItem)` | 校验所有 AP 费用是否已释放（当前暂停，固定 true） | IcTransMetaItem | `true`（固定） | 无（直接返回） | 静态验证：调用方 Node1Trigger 两处分支走 true 路径 |
