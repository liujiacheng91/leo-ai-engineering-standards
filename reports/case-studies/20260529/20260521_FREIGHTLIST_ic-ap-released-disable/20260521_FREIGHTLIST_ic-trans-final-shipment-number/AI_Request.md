# AI_Request.md

## Task
ic_transaction_final.shipment_number 字段为空，应赋值为 house_no

## Owner
Liangwb

## Team
FREIGHTLIST

## Project
bus-freightlist-handler-service

## Task Type
bug fix (字段赋值遗漏)

## Branch Info
- Base Branch: develop_1.1.0
- Task Type: feature (字段赋值补充，非线上 bug)
- New Branch Name: feat/ic-trans-final-shipment-number
- Worktree Path: .claude/worktrees/feat-ic-trans-final-shipment-number

## Entry Check
- [x] 需求明确：shipment_number = house_no
- [x] 改动范围已定位：Node3IcTransFinalCalc.buildFinalEntity()
- [x] 风险等级：Yellow（LiteFlow 节点字段赋值）
