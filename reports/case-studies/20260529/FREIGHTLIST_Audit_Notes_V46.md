# FREIGHTLIST Case Study Audit Notes (V4.6)

> Audit date: 2026-05-30
> Audited against: LL AI Engineering Standards V4.6
> Scope: 25 sub-cases under `20260521_FREIGHTLIST_ic-ap-released-disable/`
> Purpose: Document what V4.6 rules would have caught. Original case files preserved as pre-V4.6 evidence.

---

## P0 Findings

### 1. Merge_Decision.md (banned in V4.6) -- 17 of 25 cases

`Merge_Decision.md` was added to the Document Naming Standard "Do Not Use" list in V4.6. Content should be consolidated into `Solution.md ## Human Approval`.

All 17 Yellow cases contain this file:

| Case | Has Merge_Decision.md |
|---|---|
| node5-calc-gp | Yes |
| ic-final-diff-amount | Yes |
| ic-final-history-globalinterlink | Yes |
| ic-final-history-station-filter | Yes |
| ic-trigger-rule-match | Yes |
| ic-ap-released-disable | Yes |
| ic-ap-share-type-filter | Yes |
| ic-node1-shipment-detail-fix | Yes |
| ic-section-header-ic-type | Yes |
| ic-section-header-rule-info | Yes |
| ic-section-header-trans-type | Yes |
| ic-trans-final-shipment-number | Yes |
| ic-trans-system-type-null | Yes |
| ic-trigger-match-fields | Yes |
| ic-trigger-match-origin | Yes |
| ic-trigger-dest-country | Yes |
| ic-trigger-origin-country | Yes |

V4.6 rule: use `Solution.md ## Human Approval` instead. This finding validates the ban -- systematic non-standard document proliferation across all Yellow cases.

### 2. ic-trans-ps-amount-var: 5 of 6 required docs missing

Only `Token_Usage_Report.md` exists. Missing: AI_Request.md, Scenario.md, AI_Risk_Level.md, Task.md, Test.md, Verify.md.

Even Green Minimal Path (V4.6) requires: AI_Request, Scenario, AI_Risk_Level, Task, Test, Verify, Token_Usage_Report (7 docs minimum).

---

## P1 Findings

### 3. Token_Usage_Report.md missing -- 4 Green cases

| Case | Risk | Docs Present | Token_Usage_Report |
|---|---|---|---|
| ic-trans-stations-equal | Green | 6 | Missing |
| ic-trans-upload-rule-config | Green | 6 | Missing |
| stations-equal-upload-config | Green | 6 | Missing |
| match-rule-wildcard | Green | 6 | Missing |

V4.6 rule: all cases MUST have Token_Usage_Report.md. Without it, cost efficiency cannot be measured or compared.

### 4. recal-match-rule: AI_Case_Card vs Token_Usage_Report cost mismatch

- AI_Case_Card Token Cost: ~$0.80
- Token_Usage_Report task total: $2.03
- Stage sum ($2.04) corroborates the $2.03 figure
- Delta: $1.23 (61% understatement in the Card)

V4.6 rule (token-report SKILL.md Step 8): cross-check AI_Case_Card Token Cost vs Token_Usage_Report total. This finding validates the cross-check rule.

### 5. ic-trigger-origin-country: Yellow missing AI_Case_Card + PR_Template

Yellow case with 9 docs present but missing AI_Case_Card.md and PR_Template.md. Both are required for Yellow path (non-Green Minimal Path).

---

## P2 Findings

### 6. Stage sum vs task total gaps -- 8 cases

Most Token_Usage_Report files have a gap between stage-level cost sum and task-level total. The pattern is consistent: closing docs (PR_Template + AI_Case_Card + Token_Usage_Report generation) are included in the task total but not broken out as a stage row.

| Case | Stage Cost Sum | Task Total | Gap |
|---|---|---|---|
| ic-section-header-trans-type | $2.53 | $2.85 | -$0.32 |
| ic-trigger-dest-country | $2.71 | $2.93 | -$0.22 |
| ic-ap-released-disable | $2.80 | $3.00 | -$0.20 |
| ic-trans-final-shipment-number | $0.65 | $0.80 | -$0.15 |
| ic-final-history-station-filter | $1.35 | $1.50 | -$0.15 |
| ic-final-diff-amount | -- | -- | -$0.08 (8K tokens) |
| ic-final-history-globalinterlink | $0.70 | $0.75 | -$0.05 |
| ic-section-header-ic-type | $0.75 | $0.80 | -$0.05 |

V4.6 rule (token-report SKILL.md Step 5): stage-level sum must equal task-level total within 10%. Most gaps are within tolerance but unexplained. V4.6 Closing Step (ll-dev Step 10) would capture this as a single stage row.

### 7. AI_Case_Card missing Token Cost field -- 2 cases

| Case | AI_Case_Card exists | Token Cost field |
|---|---|---|
| ic-section-header-trans-type | Yes | Missing |
| ic-trigger-match-fields | Yes | Missing |

Without the Token Cost field, cross-check (V4.6 Step 8) cannot be performed.

---

## P3 Finding

### 8. Saved Hours plausibility -- 2 cases

| Case | Change Scope | Saved Hours | Cost/Hr | Note |
|---|---|---|---|---|
| ic-section-header-trans-type | +2 lines (single setter) | 1.0h | $2.85/hr | V4.6 calibration: "2-5 field completion" = 0.5-1.0h; upper bound for 2 lines |
| ic-ap-released-disable | 1-line change (return true) | 0.4h | $7.50/hr | Highest Cost/hr in batch; Yellow classification driven by LiteFlow trigger path risk |

V4.6 rule (token-report SKILL.md Saved Hours calibration table): overestimates require explanation. Neither case provides one.

---

## Summary

| Priority | Count | V4.6 Rule That Would Have Caught It |
|---|---|---|
| P0 | 2 issues (17 + 1 cases) | Document Naming Standard "Do Not Use"; Green Minimal Path minimum docs |
| P1 | 3 issues (4 + 1 + 1 cases) | Token_Usage_Report mandatory; Cross-check rule (Step 8); Yellow required docs |
| P2 | 2 issues (8 + 2 cases) | Stage sum validation (Step 5); Closing Step stage row; Cross-check prerequisite |
| P3 | 1 issue (2 cases) | Saved Hours calibration table with overestimate explanation |

**Conclusion**: These cases were produced under V4.5 rules. The 8 findings above demonstrate concrete gaps that V4.6 rules address. The most impactful V4.6 additions validated by this audit: Merge_Decision.md ban (17 cases), Token cross-check rule (1 critical mismatch), and Saved Hours calibration (2 borderline cases). Original files are preserved as-is for historical reference.
