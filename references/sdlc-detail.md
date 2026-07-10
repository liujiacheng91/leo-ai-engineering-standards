# SDLC Detail Reference

> Loaded on demand by skills (`/ll-dev`, stage skills). Not loaded in every conversation.
> This file contains the detailed SDLC workflow, output paths, document names,
> verification requirements, and closing requirements previously in CLAUDE.md.

---

## 1. LL AI-assisted SDLC Workflow

```text
AI_Request.md
-> Scenario.md (Business Model Input)
-> AI_Risk_Level.md
-> Solution.md (Technical Constraints Stop Condition + Track B Declaration)
-> Mapping_Rules.md / Business_Rules.md (if applicable)
-> Task.md
-> Test.md (API Test + Permission Security + AC Traceability)
-> Implementation (Hard Enforcement Layer)
-> Verify.md (Track A/B + Completeness Checks)
-> PR_Template.md
-> AI_Case_Card.md (Quality Metrics + Related Cases)
-> Token_Usage_Report.md (Cost Efficiency + Retry classification)
```

### 1.1 Green Minimal Path [N-01]

Applies when: Risk=Green + Mode 1 + single business concern (stub / single field / constant rename) + change lines < 30.

Compact flow (5 steps):

```text
AI_Request.md -> Solution.md (inline code) -> Implementation -> Verify.md -> Token_Usage_Report.md
```

Omit: Scenario.md, Task.md, Test.md, PR_Template.md.
Required even on Green Minimal Path: AI_Case_Card.md (mandatory per §4.1).

### 1.2 Bug Fix Path (Green/Yellow, Mode 1)

Applies when: the primary task is fixing a confirmed bug (not new feature + bug fix mixed).

Compact flow (5 steps):

```text
AI_Request.md -> Solution.md (root cause + fix) -> Implementation -> Verify.md (regression check) -> AI_Case_Card.md
```

Key differences from standard flow:
- `Solution.md` must include Root Cause section (what caused the bug, why it wasn't caught).
- `Verify.md` must include regression check (what test proves this bug won't recur).
- `Token_Usage_Report.md` optional for Green + < 50 line changes.

### 1.3 Refactor Path (Green, Mode 1)

Applies when: behavior-preserving structural change (rename, extract method, move class).

Compact flow (4 steps):

```text
AI_Request.md (before/after behavior assertion) -> Solution.md (inline) -> Implementation -> Verify.md (diff review)
```

Key differences from standard flow:
- `AI_Request.md` must declare "behavior unchanged" explicitly with before/after signatures.
- `Verify.md` focuses on diff review and existing test pass, not new test creation.
- Omit: Scenario.md, Task.md, Test.md, PR_Template.md, Token_Usage_Report.md.

### 1.4 Batch Merge Order [N-04]

When a batch contains cases with code dependencies (case A calls a method defined in case B), record the required merge sequence in the batch-level document or each dependent case's Solution.md Impact Analysis:

```text
Merge Order: [case-B] -> [case-A]
```

The dependent case must not be merged before the dependency. State this explicitly in Solution.md Impact Analysis for each dependent case.

---

## 2. Output Path Requirement

All process documents must be output to:

```text
docs/ai/cases/<case-id>/
```

Recommended `<case-id>` format:

```text
YYYYMMDD_<team>_<scenario-slug>
```

---

## 3. Fixed Document Names

Process documents must use these fixed names:

```text
AI_Request.md
Scenario.md
AI_Risk_Level.md
Business_Rules.md
Mapping_Rules.md
Solution.md
Task.md
Test.md
Verify.md
PR_Template.md
AI_Case_Card.md
Token_Usage_Report.md
```

---

## 4. Verification Requirement

Any code change must output `Verify.md`.

If a verification check cannot be executed, explain why.

### 4.1 Track B Requirements [S-04, S-05, S-09]

When worktree build fails due to known toolchain issues (e.g. `net.nemerosa.versioning` + JGit incompatibility):

- Declare Track B in `Solution.md` before proceeding to `Task.md`. Solution.md Track B declaration must match Verify.md evidence -- they must not contradict.
- `Verify.md` Post-Merge Test Plan `Owner` must be a human name (developer name or `开发者`). Never write `Owner: AI` -- AI cannot execute post-merge tests.
- Post-Merge Test Plan must include a full module test command (e.g. `gradle :module:test`), not only the current case's compile command, to catch cross-case test regressions.

---

## 5. Closing Requirements

### 5.1 AI_Case_Card.md (Mandatory) [S-01]

`AI_Case_Card.md` is required for every case regardless of risk level or size. It must include:

- Basic Info, Outcome, Quality Metrics (Retry Count + Root Cause classification)
- Reusable Assets (all 5 dimensions, even if all are `[ ]`)
- Human Intervention points (approver, decision, date)
- Related Cases (any case sharing the same method, class, feature branch, or upstream dependency)
- Lessons Learned (what worked, what failed, what to improve)

"Simple case" or "Green with no retry" is not a valid reason to omit `AI_Case_Card.md`.

### 5.2 Token_Usage_Report.md Required Sections [S-07]

`Token_Usage_Report.md` is only complete when it contains all four sections:

- Task-Level
- Stage-Level (per-stage breakdown: token, cost, percentage, notes)
- Cost Efficiency (Cost / Saved Hours, Token / Saved Hours)
- Abnormal Cost Review

A `Token_Usage_Report.md` missing Stage-Level cannot serve as case closure evidence. Stage-Level is the only way to identify which stage caused rework cost.

### 5.3 Token Actuals vs Estimates [N-02]

Task-Level token figures must come from `/usage` command measurement at session end. Record format:

```text
Input: Xk / Output: Yk / Total: Zk (measured, /usage YYYY-MM-DD)
```

Estimated values are only acceptable when `/usage` is unavailable. When estimating, append `(estimated -- /usage not available)` to each figure. Estimated values cannot be used as the sole basis for Abnormal Cost Review conclusions.
