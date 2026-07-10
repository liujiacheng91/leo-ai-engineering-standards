# V4.1 to V4.4 Iteration Reference

> Full context for the V4.1-V4.4 iteration cycle. For quick file-level lookup, see [Iteration_Change_Index.md](Iteration_Change_Index.md).

---

## 1. Design Principles

These principles were established through the iteration and should guide future versions:

1. **Prevention over audit** -- Hard Enforcement Layer blocks violations at runtime (0 tokens) rather than logging compliance after the fact (5-10K tokens/case). AI_Execution_Log.md and AI_Preflight_Checklist.md were evaluated and rejected for this reason.

2. **Single ownership** -- Each template is owned by exactly one Skill's references/. Eliminates the sync drift problem that recurred 4 times across V4.1-V4.3 (14 stale copies fixed total). Enforced by GOVERNANCE Rule 17.

3. **Atomic upgrade** -- ll-rules.md + skills/ replaced as a unit with a single version number. No partial upgrades allowed. Enforced by GOVERNANCE Rule 18.

4. **Layer separation** -- Layer 1 (governance rules) and Layer 2 (skills) are upgrade-safe. Layer 3 (CLAUDE.md Section 1 + docs/ai/cases/) is project-owned, never touched by upgrades.

5. **Sonnet-first** -- Opus only on escalation (3+ components or 2 consecutive Sonnet failures). Yellow solution design changed from Opus-default to Sonnet-default in V4.3 to eliminate false-positive Abnormal Cost Reviews.

6. **Zero-cost rules** -- QA enforcement rules (AC traceability, completeness checks, Prevention Rule atomic pipeline) added as SKILL.md rules, not new template sections. Leverages existing context at verification time -- zero additional Token overhead.

7. **Scope boundary** -- This repo standardizes process, templates, and Token optimization. It does not address project-domain business problems, infrastructure provisioning, or organizational change.

---

## 2. Backlog Completion

### V4.1 Backlog (Items 1-15)

| Item | Description | Status |
|---|---|---|
| 1 | Opus on Code Impl triggers Abnormal Cost Review | Completed |
| 2 | Explore Agent deviation triggers Abnormal Cost Review | Completed |
| 3 | Risk field no emoji, plain text only | Completed |
| 4 | Model naming standard (Sonnet/Opus/Haiku, no version) | Completed |
| 5 | EDI report field sync | Closed (project-domain, out of scope) |
| 6 | Test.md mandatory sections (Scope, Data, Mock, Boundary, Fix History) | Completed |
| 7 | Mockito 3 rules in Test.md | Completed |
| 8 | Self-Fix Count >= 2 Near Threshold + Fix->Convention rule | Completed |
| 9 | SubAgent token not reported -> Abnormal Cost Review | Completed |
| 10 | No Skill mixing in same case | Completed |
| 11 | 4 case study archives | Completed |
| 12 | FREIGHTLIST Token Report annotated guide | Completed |
| 13 | QA_Retry_Root_Cause.md template | Completed |
| 14 | SubAgent_Token_Report.md template | Completed |
| 15 | Model routing Escalation Condition + Exploration Protocol | Completed |

### V4.2 Backlog (Items 16-23)

| Item | Description | Status |
|---|---|---|
| 16 | JGit/Worktree compatibility (Track B) | Completed |
| 17 | Dual-track verification protocol (Track A/B) | Completed |
| 18 | Solution.md Technical Constraints (Stop Condition) | Completed |
| 19 | RA Draft Quality Gate (5-item checklist) | Completed |
| 20 | AI_Case_Card Related Cases section | Completed |
| 21 | Saved Hours calculation formula | Completed |
| 22 | Main Claude orchestration token estimation | Completed |
| 23 | Retry root-cause classification [Logic/Toolchain/Assumption] | Completed |

### V4.3 Backlog (Items 24-31)

| Item | Description | Status |
|---|---|---|
| 24 | API Test Cases template | Completed |
| 25 | Permission & Security Checklist | Completed |
| 26 | UAT Ready checklist | Closed (depends on SIT infra, out of scope) |
| 27 | BA structured input (Business Model Input) | Completed |
| 28 | Solution.md business design elements | Closed (covered by Item 27) |
| 29 | Reusable Asset Registry | Completed |
| 30 | Cross-case Token/ROI dashboard | Closed (insufficient case volume) |
| 31 | BA/Dev/QA/Architect collaboration guide | Closed (needs org-level sponsorship) |

---

## 3. Reference Copy Sync History

This problem recurred 4 times before V4.4 eliminated it structurally:

| Round | Stale copies found | Root cause |
|---|---|---|
| V4.1 | 2 | Opus-on-Yellow trigger, Token Report Retry header not synced |
| V4.2 audit 1 | 9 | Solution, Verify, Test, AI_Verification_Standard, Document_Naming_Standard refs stale |
| V4.2 audit 2 | 5 | CLAUDE.md Section 2.6, 4x Document_Naming_Standard refs stale |
| Total pre-V4.4 | 16 copies fixed across 3 rounds |

V4.4 solution: reduced 35 reference copies to 17, each owned by exactly one Skill. GOVERNANCE Rule 17 updated for single-owner model.

---

## 4. End-to-End Audit Findings (V4.3)

The workflow audit before V4.3 release found 5 blocking issues and 3 contradictions:

| ID | Issue | Fix |
|---|---|---|
| B1 | Yellow approval gate missing in feature-dev | Added Behavior items 7-8 |
| B2 | task-breakdown SKILL.md was 9-line stub | Expanded to full Skill |
| B3 | solution-design SKILL.md missing Track B and Yellow/Red gating | Added Risk-Level Gating + Track B Declaration |
| B4 | Near Threshold only in SKILL.md, not in standard | Synced to AI_Token_Cost_Standard.md |
| B5 | Reference copy headers missing (Rule 17) | Structural issue, later resolved by V4.4 deduplication |
| C1 | Yellow solution design defaults Opus -> false-positive Abnormal Cost Review | Changed to Sonnet-first |
| C2 | Solution.md post-merge plan in blockquote, not named section | Changed to named subsection |
| C3 | "invoke token-report skill" ambiguous in Mode 1 | Changed to "follow steps inline" |

---

## 5. Rejected Proposals

| Proposal | Source | Reason for rejection |
|---|---|---|
| AI_Preflight_Checklist.md | V4.1 analysis | All 9 checks already covered by existing gates (Entry Check, Stop Conditions, Hard Enforcement Layer). Adding a file increases Token consumption with no incremental prevention value. |
| AI_Execution_Log.md | V4.1 analysis | Prevention mode (0 tokens) preferred over audit mode (5-10K tokens/case). 9 audit items diagnosed: items 3-9 have zero incremental value (prevented at runtime), items 1-2 have low value (conversation context already contains data). |
| Item 5 EDI field sync | V4.1 backlog | Project-domain business problem, not process standardization. |
| Item 26 UAT Ready | V4.3 backlog | Depends on SIT sandbox infrastructure that does not exist. |
| Item 28 Business design in Solution.md | V4.3 backlog | Redundant with Item 27 (BA Business Model Input in Scenario.md). |
| Item 30 ROI dashboard | V4.3 backlog | Insufficient case volume (4 cases). Single-case Cost Efficiency + manual analysis sufficient. |
| Item 31 Role collaboration guide | V4.3 backlog | Requires org-level sponsorship beyond standards repo scope. |

---

## 6. Git History

| Tag | Content | Date |
|---|---|---|
| v4.3.0 | V4.1 + V4.2 + V4.3 merged to main | 2026-05-16 |
| v4.4.0 | V4.4 architecture refactor merged to main | 2026-05-17 |

| Branch | Status |
|---|---|
| main | Production (v4.4.0) |
| V4.1 | Archived (merged to main via v4.3.0) |
| V4.4 | Current working branch |

---

## 7. Maturity Assessment (post-V4.3)

| Dimension | Score | Notes |
|---|---|---|
| Behavior rules | 5 / 5 | Hard Enforcement Layer + Concise Output |
| Process standards | 5 / 5 | 9-stage SDLC, Yellow/Red gating |
| Risk control | 5 / 5 | Yellow approval gate, Red path restriction |
| Verification | 5 / 5 | AC traceability, Completeness Checks, Track A/B |
| Token governance | 5 / 5 | Cost Efficiency, Retry classification, Sonnet-first |
| Output compliance | 5 / 5 | Naming standard, output path, no emoji/em-dash |
| Execution audit | 4 / 5 | Prevention mode (not audit mode) |
| Automation | 4 / 5 | validate_ai_case scripts (not yet expanded for V4.2+ rules) |
| Overall | 4.75 / 5 | |
