# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|---:|---|---|
| Carrier Management (MSO Follow Up) | vbo-plus | vbo | Yellow | Opus 4.6 + Haiku | 180,000 (estimated) | 45,000 (estimated) | 225,000 (estimated) | $4.50 (estimated) | 1 | Yes - 1 subAgent (Explore/Haiku), subAgent tokens not included | 25 | Pass | Yes |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---:|---:|---:|---|
| Scenario Analysis | Opus 4.6 | 25,000 (estimated) | $0.50 (estimated) | 11% | Read ticket, codebase exploration, SDLC doc generation (AI_Request, Scenario, Risk Level) |
| Solution Design | Opus 4.6 | 30,000 (estimated) | $0.60 (estimated) | 13% | Solution.md, Task.md, Test.md generation |
| Code Implementation | Opus 4.6 | 120,000 (estimated) | $2.40 (estimated) | 54% | T-001 to T-014: SQL, enums, POs, entities, mappers, XML, services, DTOs, controller, mail utility, YAML config |
| Test Generation | Opus 4.6 | 20,000 (estimated) | $0.40 (estimated) | 9% | T-015: 39 unit tests covering status workflow, validation, CRUD |
| Verification | Opus 4.6 | 15,000 (estimated) | $0.30 (estimated) | 7% | T-016: mvn clean package, Verify.md, PR_Template.md, AI_Case_Card.md |
| Rework / Retry | Opus 4.6 | 15,000 (estimated) | $0.30 (estimated) | 7% | 1 retry: String.repeat() Java 11 compat fix, User.getUserId() field fix |

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Code Implementation stage > 40% | 54% of total tokens in implementation — expected for a 16-task feature spanning 31 new files | No action needed — proportional to task scope |
