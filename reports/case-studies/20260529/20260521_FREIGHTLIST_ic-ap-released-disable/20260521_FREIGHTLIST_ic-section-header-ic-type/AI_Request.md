# AI_Request.md

## Basic Info

- Case ID: 20260521_FREIGHTLIST_ic-section-header-ic-type
- Request Name: ic_section_header 表新增 ic_type 字段，补充实体类、Mapper XML 及赋值逻辑
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Owner: Liangwb
- Date: 2026-05-21
- Output Path: docs/ai/cases/20260521_FREIGHTLIST_ic-section-header-ic-type/

## Request Type

- [x] Other: 新增字段（Entity + Mapper XML + 节点赋值）

## Expected AI Output

- [x] Scenario.md
- [x] AI_Risk_Level.md
- [x] Solution.md
- [x] Task.md
- [x] Test.md
- [x] Verify.md
- [x] Code Change
- [x] PR Summary
- [x] AI_Case_Card.md
- [x] Token_Usage_Report.md

## Required Human Input

- Business Rules: ic_type 取值 PS（分利计算，一天两次）/ MONTH_END（月结）；源头从 Kafka icType 字段获取，先存 meta 再赋值
- Sample Data: N/A
- Acceptance Criteria: ic_section_header.ic_type 应从 Kafka 消息的 icType 字段经 meta 传递并落库
- Technical Constraints: Track B（worktree + JGit/versioning 不兼容）
- Risk Level: Yellow（LiteFlow 节点字段改造）

## Branch Info

- Task Type: feature
- Base Branch: develop_1.1.0
- New Branch Name: feat/ic-section-header-ic-type
- Worktree Path: .claude/worktrees/feat-ic-section-header-ic-type

## Entry Check

- [x] Scenario.md completed
- [x] Risk level completed
- [x] Required input available
- [x] No sensitive data included
