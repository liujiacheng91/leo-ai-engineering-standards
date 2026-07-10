# Case Study: VBO — Large Feature Mode 3 with 39 Unit Tests

> Source: `examples/token-usage/VBO_Token_Usage_Report_Second_2th_V4.0.md`
> Project: vbo-plus / VBO team
> Task: Carrier Management (MSO Follow Up)
> Risk: Yellow

---

## Summary

A 16-task feature spanning 31 new files was delivered under Mode 3 with 39 unit tests, 1 self-fix, and a 25-hour saving estimate. Token usage at 225K and cost at $4.50 are proportional to scope and explained in Abnormal Cost Review.

| Metric | Value |
|---|---|
| Model | Opus (all stages) |
| Total Tokens | ~225,000 (est.) |
| Total Cost | ~$4.50 (est.) |
| Tasks | T-001 to T-016 (16 tasks) |
| New Files | 31 |
| Unit Tests | 39 (status workflow, validation, CRUD) |
| Retry Count | 1 |
| Saved Hours | ~25 h |
| Result | Pass |

---

## Scope

T-001 to T-014 covered: SQL schema, enums, PO objects, entities, mappers, XML mapper configs, services, DTOs, controller, mail utility, YAML config.
T-015: 39 unit tests.
T-016: `mvn clean package`, `Verify.md`, `PR_Template.md`, `AI_Case_Card.md`.

---

## Stage Token Distribution

| Stage | Token | % | Notes |
|---|---:|---:|---|
| Scenario Analysis | 25,000 | 11% | |
| Solution Design | 30,000 | 13% | |
| Code Implementation | 120,000 | 54% | ⚠️ >40% — Abnormal Cost Review row added |
| Test Generation | 20,000 | 9% | 39 unit tests |
| Verification | 15,000 | 7% | |
| Rework / Retry | 15,000 | 7% | String.repeat Java 11 compat + User.getUserId() field fix |

### Abnormal Cost Review

Code Implementation at 54% was flagged and justified: T-001 to T-014 spanned 31 new files across SQL + Mapper + Service + Controller + Test layers. Given the 16-task scope, 54% is proportional and expected under Mode 3. No action required.

---

## Self-Fix Analysis

| Fix # | Symptom | Root Cause | Prevention Rule |
|---|---|---|---|
| Fix #1 | `String.repeat()` compile error | Java 11 compat not pre-checked; `String.repeat()` requires Java 11+ | Add Java version compatibility check to Solution.md Technical Context |
| Fix #1 (cont.) | `User.getUserId()` field not found | Field name assumed without verification from entity class | Hard Enforcement: verify field names from source before asserting them |

---

## Opus Usage Assessment

All stages used Opus. The Abnormal Cost Review should have included an explanation for why Sonnet was not used in Code Implementation (T-001 to T-014). Based on scope (31 files, multi-layer), Opus was justified for the architecture complexity. However, the report did not explicitly document this reasoning — a gap corrected by the V4.1 trigger: "Opus used in Code Implementation stage → record why Sonnet was insufficient."

---

## Lessons

| Lesson | Rule Derived |
|---|---|
| 39 unit tests is achievable in Mode 3 with dedicated Test Generation stage | Mode 3 SubAgent grouping: separate Test Generation group with explicit deliverable list |
| 54% Code Impl is acceptable when scope justifies it | Abnormal Cost Review: explain root cause, not just "large scope" |
| Opus across all stages without justification | V4.1 trigger: Opus on Code Impl → record reason why Sonnet insufficient |
| Java version compat missed pre-implementation | Solution.md Technical Context: include runtime version and known compatibility constraints |

---

## Mode 3 Pattern

This case demonstrates the canonical Mode 3 structure:

```text
Main Claude orchestration
├── Group A: SQL + Schema
├── Group B: PO / Entity objects
├── Group C: Mapper + XML
├── Group D: Service + DTOs
├── Group E: Controller + YAML
├── Group F: Mail utility
└── Group G: Test Generation (39 unit tests)
```

Each group should output `Token usage: input=<n>, output=<n>, total=<n>` as its final line. This case used 1 SubAgent (Explore/Haiku) with tokens not fully included — a gap documented in the Memory/Sub Agent field.
