# 20260608 FREIGHTLIST Case Batch: Optimization Analysis

**Date:** 2026-06-09
**Batch:** 20260608 FREIGHTLIST (11 cases)
**Portfolio summary:** 11 cases, ~$14.39 total, 3.8h saved, avg ~$3.79/hr, 0 retries, all Track B.

---

## Case Inventory

| Case | Risk | Model | Tokens | Cost | Saved Hours | Cost/hr | Retries | Track |
|---|---|---|---|---|---|---|---|---|
| ap-charges-process | Green | Opus | ~68K | ~$1.36 | 0.2h | ~$6.80 | 0 | B |
| ar-charges-process | Green | Opus | ~75K | ~$1.50 | 0.3h | ~$5.00 | 0 | B |
| ar-charges-released | Green | Opus | ~61K | ~$1.20 | 0.3h | ~$4.00 | 0 | B |
| auto-mode-act-bypass | Yellow | Opus | ~95K | ~$1.95 | 0.5h | ~$3.90 | 0 | B |
| auto-mode-by-station | Green | Opus | ~90K | ~$1.80 | 0.5h | ~$3.60 | 0 | B |
| auto-mode-refactor | Yellow | Opus | ~82K | ~$1.68 | 0.5h | ~$3.36 | 0 | B (post-merge build: Pass) |
| execute-ap-charges | Green | Opus | ~68K | ~$1.36 | 0.3h | ~$4.53 | 0 | B |
| full-auto-workflow | Green | Opus | ~68K | ~$1.36 | 0.3h | ~$4.53 | 0 | B |
| get-ar-invoice-no | Green | Opus | ~61K | ~$1.20 | 0.3h | ~$4.00 | 0 | B |
| internal-trans-no-prefix | Yellow | Opus | ~55K | ~$1.10 | 0.2h | ~$5.50 | 0 | B |
| semi-auto-workflow | Green | Opus | ~68K | ~$1.36 | 0.3h | ~$4.53 | 0 | B |

---

## Issues Found

### Issue 1: AI_Case_Card.md missing from ALL 11 cases (Critical - SDLC gap)

`AI_Case_Card.md` is absent across every case. The LL SDLC workflow requires it as the final artifact: quality metrics, related cases, and multi-dimensional reusable asset evaluation (5-dimension table introduced in V4.8). Without it the evidence chain is incomplete and reusable asset tracking is lost.

**Scope:** All 11 cases.

**Action:** Add `AI_Case_Card.md` to each case. At minimum fill the 5-dimension reusable asset table and link related cases within this batch (many share the same AR/AP entity pattern).

---

### Issue 2: Merge_Decision.md present in 2 cases (Governance violation - Rule 17)

`auto-mode-act-bypass` and `auto-mode-refactor` both contain `Merge_Decision.md`. This document is explicitly banned by GOVERNANCE.md Rule 17 and `Document_Naming_Standard.md`. The content (commit SHA, change scope, base branch) belongs in `Solution.md` Human Approval section or `PR_Template.md`.

**Scope:** 2 cases.

**Action:** Remove `Merge_Decision.md` from both cases. Migrate content to `Solution.md` (Human Approval) and `PR_Template.md`.

---

### Issue 3: 100% Opus on Green cases - model selection violation (High - cost impact)

All 11 cases used Opus. 8 are Green risk; 6 are single-file stub fills with 3-40 lines. The standard is Sonnet-first; Opus escalates only on 3+ components or 2 consecutive failures. Token reports note: "主 Claude 当前 session 为 Opus，非 SubAgent 选型" - the engineer ran the full session as Opus without selecting down per case type.

**Cost impact of switching Green stubs to Sonnet:**

| Case | Current (Opus) | Sonnet estimate | Savings |
|---|---|---|---|
| ap-charges-process | ~$1.36 | ~$0.28 | ~$1.08 |
| ar-charges-released | ~$1.20 | ~$0.25 | ~$0.95 |
| execute-ap-charges | ~$1.36 | ~$0.28 | ~$1.08 |
| full-auto-workflow | ~$1.36 | ~$0.28 | ~$1.08 |
| get-ar-invoice-no | ~$1.20 | ~$0.25 | ~$0.95 |
| semi-auto-workflow | ~$1.36 | ~$0.28 | ~$1.08 |

Estimated savings for the 6 trivial Green stub cases: **~$6.20 (43% of total batch cost)**.
Cost efficiency would drop from ~$6.80/hr to ~$1.40/hr for stubs - below the EDI benchmark.

**Scope:** 6-8 cases.

**Action:** For Green + single-file + <50 line cases, start the session as Sonnet or explicitly select Sonnet at `/ll-dev` invocation. Model selection must be a deliberate per-case-type choice, not inherited from the session default.

---

### Issue 4: Green Minimal Path not applied (Medium - token overhead)

6 trivial Green stub cases ran the full 12-step flow despite meeting all 3 Green Minimal Path criteria: Green risk, single file, <50 lines of diff. Green Minimal Path target token load is 20-50K; these cases consumed 55-68K each (10-35% above target).

Estimated overhead per case from full vs minimal path: ~15-20K tokens.

**Scope:** 6 cases (ap-charges-process, ar-charges-released, execute-ap-charges, full-auto-workflow, get-ar-invoice-no, semi-auto-workflow).

**Action:** Apply the Green Minimal Path (9-step compact flow) when all 3 criteria are met. The path skips Steps 4 (Mapping Rules), 5 (Business Rules), and consolidates closing docs into a single pass.

---

### Issue 5: Post-merge verification backfill missing - 10 of 11 cases (High - evidence gap)

Track B is the correct protocol given the worktree/JGit constraint. The Track B contract requires `Post-Merge Test Results` to be backfilled after merge. Only `auto-mode-refactor` filled in post-merge build results (`gradle :expand:business-freightlist-summary:compileJava BUILD SUCCESSFUL`). The other 10 cases have `Post-Merge Test Plan` sections but no results.

This is not a documentation formality - it is the only build evidence for this batch.

**Scope:** 10 of 11 cases.

**Action:** After each batch of merges, run `gradle :expand:business-freightlist-summary:compileJava` and backfill the `Verify.md` Post-Merge Test Results section. If unit tests cannot run, state the reason explicitly.

---

### Issue 6: All token values are estimates - no actual measurements (Medium)

Every token figure in every report uses `~` and `(estimated)`. CLAUDE.md Section 1.5 requires numbers to have a source. The `/usage` command in Claude Code shows actual session token counts. Without actuals, cost efficiency metrics may be inaccurate across the entire batch.

**Scope:** All 11 cases.

**Action:** Check `/usage` at the end of each case session and record actual token counts. If actual data is not available, label the entire cost estimate row as `Estimated` and note the estimation method used.

---

### Issue 7: Reusable pattern not cross-referenced across cases (Medium)

The AR/AP entity filtering pattern (cdlTransType=AR, cdlSource="B", status in [POSTED, CAN_POST, RELEASED]) appears in at least 5 cases: ar-charges-released, execute-ap-charges, get-ar-invoice-no, semi-auto-workflow, ar-charges-process. Only ar-charges-process documents this as reusable.

When subsequent cases re-derive the same filter logic without referencing the pattern, it increases token consumption (re-explaining context) and introduces divergence risk. A semantic difference was already observed in ar-charges-released (empty list returns false vs true in isAllArChargePosted).

**Scope:** 5+ cases.

**Action:** In each `AI_Case_Card.md`, reference the prior case that established the AR/AP filter pattern. For cases that reuse it without change, mark Reusable=Yes with cross-reference. Document the empty list semantic divergence in `Business_Rules.md` or `Scenario.md`.

---

### Issue 8: Stage-level token breakdown missing in 9 cases (Medium)

Only `auto-mode-act-bypass` and `auto-mode-refactor` have stage-level token breakdowns. The other 9 cases have only a single-row Task-Level table. Stage-level data is what enables identifying which SDLC stages consume disproportionate tokens.

**Scope:** 9 cases.

**Action:** Add a Stage-Level breakdown to all `Token_Usage_Report.md` files. Even rough estimates by stage (Scenario/Solution/Implementation/Test/Verification) are more useful than a single aggregate number.

---

### Issue 9: Saved hours tier validation undocumented (Low)

Several cases with 3 lines of code claim 0.2h saved; cases with ~40 lines claim 0.5h. The V4.6 5-tier calibration table was added specifically to prevent overestimation. Without `AI_Case_Card.md` and a filled Abnormal Cost Review section, there is no documented validation that figures were checked against the tier table.

**Scope:** All 11 cases.

**Action:** For each case, explicitly confirm in `Token_Usage_Report.md` Abnormal Cost Review which tier applies and whether saved hours is within bounds.

---

### Issue 10: Cost efficiency regression vs prior FREIGHTLIST benchmark (High - batch-level)

V4.7 FREIGHTLIST batch benchmark: $2.44/hr. This batch average: ~$3.79/hr - a 55% regression. The primary driver is Opus usage on Green stub cases (Issues 3 and 4). Applying Sonnet for eligible Green cases would bring the batch average to approximately $1.50-2.00/hr, restoring and surpassing the prior benchmark.

**Scope:** Batch-level.

**Action:** Address Issues 3 and 4. Re-run cost efficiency calculation after model correction.

---

## Summary

| # | Issue | Severity | Scope | Primary Action |
|---|---|---|---|---|
| 1 | AI_Case_Card.md missing | Critical | All 11 | Add AI_Case_Card.md with 5-dimension table |
| 2 | Merge_Decision.md (banned doc) | High | 2 cases | Remove; migrate to Solution.md + PR_Template.md |
| 3 | Opus on Green stubs | High | 6 cases (~$6.20 recoverable) | Sonnet-first for Green + single-file + <50 lines |
| 4 | Green Minimal Path not used | Medium | 6 cases (~15-20K tokens each) | Apply 9-step compact flow when criteria met |
| 5 | Post-merge backfill missing | High | 10 of 11 | Backfill Verify.md after merge |
| 6 | All tokens estimated | Medium | All 11 | Record actuals via /usage |
| 7 | Reusable pattern not cross-referenced | Medium | 5+ cases | Cross-reference AR/AP filter in AI_Case_Card |
| 8 | Stage-level breakdown missing | Medium | 9 cases | Add stage breakdown to Token_Usage_Report |
| 9 | Saved hours tier validation | Low | All 11 | Confirm tier in Abnormal Cost Review |
| 10 | Cost efficiency regression | High | Batch | Driven by Issue 3; resolve together |

**Highest-leverage fix:** Issue 3 (model selection) - addresses cost regression, reduces per-case cost by ~80% for stubs, behavioral change with no documentation overhead.

**Most important for SDLC completeness:** Issue 1 (AI_Case_Card) and Issue 5 (post-merge backfill).
