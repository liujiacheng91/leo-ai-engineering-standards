# Scenario.md

## Scenario Name

Node31AutoMode 非ACT类型直接走fullAutoWorkflow

## Business Background

IC v2 链中 `Node31AutoMode`（`ic_auto_mode`）负责自动模式分流。当前逻辑在 transType 不为 ACT 时直接跳过（continue），导致 PRV 类型的 ic_transaction 和 ic_transaction_final 记录的 `ready_to_release`、`ar_invoice_no`、`allow_send` 字段始终为空。

## Current Problem

`Node31AutoMode.processIml()` 第 81 行：当 `transType != ACT` 时 `continue`，PRV 记录不经过任何自动模式处理，三个字段（ready_to_release / ar_invoice_no / allow_send）落库时为 null。

## Expected Outcome

非 ACT 类型（主要是 PRV）的记录也需要经过 `fullAutoWorkflow` 处理，设置 ready_to_release / ar_invoice_no / allow_send 字段值。

## In Scope

- `Node31AutoMode.processIml()` 控制流调整：非ACT时直接走 fullAutoWorkflow
- ACT 类型保持原有逻辑（按 station 判断 semi/full auto）

## Out of Scope

- `IcAutoModeServiceImpl` 的 fullAutoWorkflow / semiAutoWorkflow 内部逻辑不变
- Node20 / Node30 / Node40 不动
- 不改 entity / mapper / 表结构

## Acceptance Criteria

| AC ID | Acceptance Criteria | Verification Method |
|---|---|---|
| AC-1 | transType=ACT 时，仍走原有 autoModeWorkflow（按 station 判断 semi/full） | 代码审查 + 单测 |
| AC-2 | transType 非 ACT（如 PRV）时，直接调用 fullAutoWorkflow，设置 ready_to_release=N, ar_invoice_no=null, allow_send=1 | 代码审查 + 单测 |
| AC-3 | currentIcSectionHeader 为 null 时仍跳过，不进入任何处理 | 代码审查 |

## Suggested Risk Level

Yellow -- 修改 LiteFlow 链上节点的控制流逻辑
