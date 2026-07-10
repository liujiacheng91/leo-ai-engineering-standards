# AI_Request.md

## Task Metadata

- Case ID: 20260519_FREIGHTLIST_node5-calc-gp
- Owner: Liangwb
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Task Type: feature
- Created: 2026-05-19

## Description

补充 Node5ProfitShare 中 calcGp 方法的计算逻辑，实现 FREIGHT_LIST_GP 行的各 AgentType 金额赋值。

## Input

1. 补充 Node5ProfitShare 中的 calcGp 计算逻辑
2. 获取站点的 GP 复用 BusFreightSummaryMetaV1.java 中的 getMaxGpStation 函数（底层 calcFlGpByStation）
3. 其他赋值逻辑可以参考 Node5ProfitShare 中的 calcProfitShareDistribution 函数

## Expected Output

- calcGp 方法完整实现
- 按 POM 的 AgentType 将各站点 GP 分配到 Origin/Destination/Sale1/Sale2
- 合计 Total

## Branch Info

- Base Branch: develop_1.1.0
- Task Type: feature
- New Branch Name: feat/node5-calc-gp
- Worktree Path: .claude/worktrees/feat-node5-calc-gp

## Entry Check

- [x] Case directory created
- [x] Branch info confirmed (feature, default develop_1.1.0)
