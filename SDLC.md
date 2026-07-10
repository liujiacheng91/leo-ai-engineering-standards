# LL AI-assisted SDLC

## SDLC Definition

SDLC (Software Development Life Cycle) is the complete engineering lifecycle from requirements to design, implementation, testing, verification, release, and maintenance.

In AI-assisted mode, SDLC is not skipped -- it is compressed and partially automated. Human roles shift from execution to governance: confirmation, decision-making, and risk control.

## Traditional SDLC vs AI-assisted SDLC

| Dimension | Traditional SDLC | AI-assisted SDLC |
|---|---|---|
| Execution | Multi-role, sequential, manual collaboration | Single Agent orchestration, template-driven, human confirms |
| Requirements | BA writes requirements, Dev interprets | AI generates Scenario.md, BA fills Business Model Input, RA Quality Gate |
| Design | Architect designs, team reviews | AI generates Solution.md with Technical Constraints (Stop Condition), human approves for Yellow |
| Implementation | Developer writes code manually | AI generates code following Hard Enforcement Layer constraints |
| Testing | QA writes and executes tests post-development | AI generates Test.md pre-implementation (unit + API + permission/security), Fix History atomic pipeline |
| Verification | Manual review and sign-off | AI generates Verify.md with Track A/B protocol, Completeness Checks |
| Cost Visibility | Estimated by project manager | Token Report with Stage-Level breakdown, Cost Efficiency, Retry classification |
| Knowledge Retention | Meeting notes, tribal knowledge | Structured case assets (AI_Case_Card, Reusable Asset Registry) |

## SDLC Stages and LL Mapping

### Stage 1 -- Requirements

Purpose: Define what to build, why, and the boundaries.

| Activity | LL Document | Owning Skill |
|---|---|---|
| Requirements clarification | AI_Request.md | ll-dev |
| Scenario analysis + BA structured input | Scenario.md (Business Model Input) | scenario-analysis |
| Risk classification | AI_Risk_Level.md | risk-assessment |

Quality gate: RA Draft Quality Gate (5-item checklist before TA handoff).

### Stage 2 -- Design

Purpose: Define the correct engineering approach.

| Activity | LL Document | Owning Skill |
|---|---|---|
| Technical constraints verification | Solution.md (Technical Constraints) | solution-design |
| Impact analysis + recommended solution | Solution.md | solution-design |
| Worktree build assessment | Solution.md (Track B Declaration) | solution-design |
| Field mapping / business rules | Mapping_Rules.md / Business_Rules.md | mapping-rules |

Quality gate: Technical Constraints is a Stop Condition -- unfilled blocks Task/Test. Yellow cases require Human Approval before proceeding.

### Stage 3 -- Task Breakdown

Purpose: Convert approved design into executable tasks.

| Activity | LL Document | Owning Skill |
|---|---|---|
| Task decomposition with AC traceability | Task.md | task-breakdown |

Quality gate: Each task must trace to at least one AC. Yellow cases require signed Solution.md Human Approval.

### Stage 4 -- Testing (Pre-Implementation)

Purpose: Define what to verify before writing code.

| Activity | LL Document | Owning Skill |
|---|---|---|
| Test scope, data, mock strategy | Test.md | test-design |
| API test cases (if REST API) | Test.md (API Test Cases) | test-design |
| Permission/security checklist (if applicable) | Test.md (Permission & Security) | test-design |
| AC traceability check | Test.md (Test Matrix Related AC) | test-design |

Quality gate: Every AC must have at least one test case. Mock Strategy must be filled before writing any test code.

### Stage 5 -- Implementation

Purpose: Generate code following the approved design and test plan.

| Activity | Constraint | Owning Skill |
|---|---|---|
| Code generation | Hard Enforcement Layer (Before-Read / Before-Write / Before-Response) | ll-dev |
| Model selection | Sonnet default, Opus on escalation (3+ components or 2 consecutive failures) | ll-dev |
| Self-Fix | Max 3 attempts, Fix History recorded with atomic Prevention Rule application | ll-dev |

Quality gate: Self-Fix Count >= 3 triggers stop and human escalation.

### Stage 6 -- Verification

Purpose: Confirm the implementation meets requirements with evidence.

| Activity | LL Document | Owning Skill |
|---|---|---|
| Build + test execution (Track A) | Verify.md | verification |
| Static assertion + TA code-review (Track B) | Verify.md + Post-Merge Test Plan | verification |
| AC completeness check | Verify.md (AC Mapping) | verification |
| Test results completeness check | Verify.md (Test Results) | verification |

Quality gate: AC Mapping must have zero empty rows. "Not Run" items require explanation. Track B requires Post-Merge Test Plan filled before merge.

### Stage 7 -- Release

Purpose: Package and deliver the change.

| Activity | LL Document | Owning Skill |
|---|---|---|
| PR summary generation | PR_Template.md | pr-summary |
| Case card documentation | AI_Case_Card.md (Quality Metrics + Related Cases) | ll-dev |

### Stage 8 -- Cost Accounting

Purpose: Record cost, efficiency, and lessons learned.

| Activity | LL Document | Owning Skill |
|---|---|---|
| Token usage reporting | Token_Usage_Report.md | token-report |
| Cost Efficiency calculation | Token_Usage_Report.md (Cost / Saved Hours) | token-report |
| Retry root-cause classification | Token_Usage_Report.md ([Logic]/[Toolchain]/[Assumption]) | token-report |
| Abnormal Cost Review | Token_Usage_Report.md | token-report |

### Stage 9 -- Iteration & Maintenance

Purpose: Feed lessons learned back into the next cycle and maintain delivered software.

| Activity | Mechanism |
|---|---|
| Fix History Prevention Rules applied to standards | Atomic pipeline: record -> apply to target file -> proceed |
| Case study archival | Reusable Asset Registry (reports/Reusable_Asset_Registry.md) |
| Cross-case linkage | AI_Case_Card Related Cases (supersedes / amends / follow-up / depends-on) |
| Standards versioning | VERSION file + upgrade_project atomic upgrade |
| Post-merge test backfill (Track B) | Verify.md Post-Merge Test Results |

Each completed case feeds improvements back into the standard: Prevention Rules land in CLAUDE.md / Test.md / Solution.md, reusable assets are indexed, and cross-case relationships are recorded for future reference.

## Human Roles in AI-assisted SDLC

| Role | Traditional SDLC | AI-assisted SDLC |
|---|---|---|
| BA / Requirement Analyst | Write requirements documents | Fill Scenario.md Business Model Input (entities, state machine, permissions, notifications, test data) |
| Tech Architect | Design architecture, review code | Review Solution.md, approve Yellow cases, TA code-review in Track B |
| Developer | Write code, fix bugs | Write AI_Request, review AI-generated code, make risk-level decisions |
| QA Engineer | Write and execute tests manually | Review Test.md, validate Verify.md evidence, confirm pass criteria |

Core shift: humans move from execution to governance -- confirming, deciding, and controlling risk rather than writing code directly.

## Execution Modes

| Mode | Scope | Token Target | SubAgent |
|---|---|---|---|
| Mode 1 -- LL-only | Small changes, single-service, bug fix | 50K-150K | Not allowed |
| Mode 2 -- Mapping/EDI | Field mapping, X12, customer-specific rules | 80K-200K | Not allowed |
| Mode 3 -- Large Feature | >15 tasks or >20 files, multi-layer changes | 200K-500K | Allowed (token reporting mandatory) |

## Case Evidence Chain

Each AI case produces a complete audit trail:

```text
AI_Request.md       -- what was requested
Scenario.md         -- what was analyzed (+ BA Business Model Input)
AI_Risk_Level.md    -- risk classification
Solution.md         -- how it will be built (+ Technical Constraints + Track B Declaration)
Task.md             -- what tasks were planned
Test.md             -- what tests were designed (+ API + Permission/Security)
Verify.md           -- what evidence was collected (+ Completeness Checks)
PR_Template.md      -- what was delivered
AI_Case_Card.md     -- what was learned (+ Quality Metrics + Related Cases)
Token_Usage_Report.md -- what it cost (+ Cost Efficiency + Retry classification)
```
