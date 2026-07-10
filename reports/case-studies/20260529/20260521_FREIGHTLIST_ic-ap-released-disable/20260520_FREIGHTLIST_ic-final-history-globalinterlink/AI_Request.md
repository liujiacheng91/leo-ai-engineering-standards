# AI Request

## Task
修改 `Node3IcTransFinalCalc.calcDiffAmount` 的历史查询逻辑：
1. 查询条件从 `serialNo` 改为 `globalInterlink`
2. 历史查询 + historyTotal 计算提取到 `buildIcTransFinal` 循环外面，避免每个 transaction 重复查询
3. `firstActualIcHeader != null` 的差额判断也提取到循环外面

## Owner
dara.heng@transpeed.com.sg

## Team
FREIGHTLIST

## Project
bus-freightlist-handler-service

## Input
- 用户直接描述的优化需求

## Branch Info
- Task Type: feature (对已有 calcDiffAmount 逻辑的优化)
- Base Branch: develop_1.1.0
