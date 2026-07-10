# Dyson Ocean-310 Case Audit Notes (V4.6)

> Audit date: 2026-05-30
> Case: 20260520_dyson_178737-ocean-310-billing
> Path: 2026-05-22-Dyson ocean invoice-docs/docs/ai/cases/20260520_dyson_178737-ocean-310-billing/
> Risk: Yellow | Mode: 2 (EDI Mapping) | Model: Sonnet | Retry: 2 [Assumption]
> Original files preserved as pre-V4.6 evidence.

---

## Quality Assessment

This is the highest-quality case in the 27-case audit. Notable strengths:

- Complete 11-doc set (no Merge_Decision.md -- compliant with V4.6)
- Sonnet used throughout (correct model selection for Yellow Mode 2)
- Stage sums match task total exactly (0% gap, $1.38)
- Method Signature Confirmation section in Solution.md (Retrospective-driven from air-billing case)
- Cost efficiency $0.099/hr (best in batch, well within EDI $0.07/hr benchmark range)
- Human Approval with 7 specific corrections -- strong human-in-the-loop evidence
- Both retries correctly classified as [Assumption] with actionable prevention rules
- 24/24 tests passing with full AC mapping (10 ACs, each with evidence)

---

## Findings

### P1: Test count mismatch across documents

After a requirement change (2026-05-21), test count increased from 22 to 24. Three documents were not updated:

| Document | Test Count Stated | Actual (Verify.md) | Correct |
|---|---|---|---|
| Verify.md | 24/24 | 24/24 | Yes |
| AI_Case_Card.md | 22/22 | 24/24 | No |
| PR_Template.md (Summary) | 22 | 24 | No |
| PR_Template.md (Validation) | 22/22 | 24/24 | No |

V4.6 relevance: Closing single-pass (Step 10) would generate AI_Case_Card and PR_Template after the final Verify.md, ensuring they reference the same test count. The separate-invocation pattern in this case caused the stale data.

### P2: Solution.md Human Approval date typo

Line 314: `Date: 2025-05-20` should be `Date: 2026-05-20`.

This was flagged in the engineering deck (Slide 12, P2 finding).

### P2: AI_Case_Card Token Cost field

Token Cost field says "见 Token_Usage_Report.md" instead of the actual value "$1.38 (estimated)".

V4.6 rule (token-report SKILL.md Step 8): cross-check requires both documents to have the value. Using a reference link instead of the value blocks the cross-check.

### P3: Verify.md Self-Fix numbering

Self-Fix section lists fixes in order: Fix #1, Fix #3, Fix #2.

- Fix #1: [Assumption] loadterm field -- genuine self-fix
- Fix #2: [Assumption] testImplementation dependency -- genuine self-fix
- Fix #3: Requirement change (2026-05-21) -- NOT a self-fix

The numbering is confusing. Fix #3 is a requirement change that happened between sessions, not an AI self-correction. It should be labeled separately (e.g., "Requirement Change #1") to avoid inflating the self-fix count. The Retry Count = 2 in Token_Usage_Report.md is correct.

### P3: PR_Template test dependency count

PR_Template says "新增单元测试 22 个" in the Summary section. Actual final count is 24 (after TC-025 through TC-028 were added for requirement changes).

---

## What V4.6 Rules Would Have Prevented

| Finding | V4.6 Rule |
|---|---|
| Test count mismatch | Closing single-pass (Step 10): generate Card + PR after final Verify.md |
| Token Cost cross-check gap | Cross-check rule (Step 8): actual value required in both documents |
| Date typo | No specific rule -- human review item |
| Self-Fix numbering confusion | No specific rule -- but Bug Fix pre-check (Behavior 10) pattern of labeling root causes would help |

---

## Data Summary

| Metric | Value |
|---|---|
| Documents | 11 (complete, no banned files) |
| Tokens | 232K (estimated) |
| Cost | $1.38 (estimated) |
| Tests | 24/24 passed |
| Saved Hours | 14h (~1.5-2 person-days) |
| Cost/Hr | $0.099/hr |
| Retries | 2 [Assumption] |
| AC Coverage | 10/10 (100%) |
| Model | Sonnet (correct for Yellow Mode 2) |
| Stage-Task Gap | 0% (exact match) |

This case demonstrates what good Mode 2 (EDI Mapping) execution looks like: complete docs, correct model, Retrospective-driven improvements from prior case, strong human-in-the-loop, and excellent cost efficiency.
