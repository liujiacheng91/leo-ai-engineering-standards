# Iteration Change Index

> Concise index of all changes per version. Use this file for quick lookup.
> For full context, see [Iteration_V41_V44_Reference.md](Iteration_V41_V44_Reference.md) (V4.1-V4.4), [Iteration_V45_Reference.md](Iteration_V45_Reference.md) (V4.5), and [Iteration_V46_Reference.md](Iteration_V46_Reference.md) (V4.6).

## V5.0 (current)

| Category | Change | Files |
|---|---|---|
| Case Studies | 11-case FREIGHTLIST batch 20260608 (auto-mode refactor, AR/AP charge processing, workflow stubs) | `reports/case-studies/20260608/` |
| Case Studies | 9-case FREIGHTLIST batch 20260609 (trigger-recalc, semi-auto, status code, trans-ref-id) | `reports/case-studies/20260609/` |
| Rules [S-06] | §1.5: Java getter/setter Grep verification before writing any method reference | `CLAUDE.md`, `ll-rules.md` |
| Rules [N-05] | §1.1: isAll.../isAny... empty collection = false (conservative default); exceptions in Solution.md | `CLAUDE.md`, `ll-rules.md` |
| Rules [N-01] | §2.1: Green Minimal Path -- 5-step flow for Green + stub + lines < 30 | `CLAUDE.md`, `ll-rules.md` |
| Rules [N-04] | §2.2: Batch Merge Order documentation when cases have code dependencies | `CLAUDE.md`, `ll-rules.md` |
| Rules [S-08] | §5.1: Green Mode 1 + files <= 3 + lines < 50 routes to Sonnet subAgent | `CLAUDE.md`, `ll-rules.md` |
| Rules [N-03] | §5.2: LiteFlow node modification = automatic Yellow regardless of change size | `CLAUDE.md`, `ll-rules.md` |
| Rules [S-02] | §6: Merge_Decision.md added to Forbidden Practices | `CLAUDE.md`, `ll-rules.md` |
| Rules [S-04/S-05/S-09] | §7.1: Track B requirements -- declaration consistency, human owner, full module test | `CLAUDE.md`, `ll-rules.md` |
| Rules [S-03] | §8 item 3: Yellow stop -- Solution.md Human Approval is gate; AI_Case_Card Human Intervention is not | `CLAUDE.md`, `ll-rules.md` |
| Rules [S-01] | §9.1: AI_Case_Card.md mandatory for every case | `CLAUDE.md`, `ll-rules.md` |
| Rules [S-07] | §9.2: Token_Usage_Report 4 required sections; missing Stage-Level = not closed | `CLAUDE.md`, `ll-rules.md` |
| Rules [N-02] | §9.3: Token figures from /usage actuals; estimates require explicit annotation | `CLAUDE.md`, `ll-rules.md` |
| Version | VERSION, plugin.json, marketplace.json updated to v5.0.0 | 3 files |

## V4.9

| Category | Change | Files |
|---|---|---|
| Plugin | `marketplace.json` added at repo root; `source` set to `"./ll-ai-engineering-standards"` (full repo cache fix) | `marketplace.json` |
| Plugin | `.gitignore` added to exclude local token file | `.gitignore` |
| Docs | README Option A updated: repo naming requirement + marketplace folder seeding step | `README.md` |
| Docs | CHANGELOG v4.9 entry corrected with accurate source path fix and root cause findings | `CHANGELOG.md` |
| Version | VERSION, plugin.json, marketplace.json updated to v4.9.0 | 3 files |

## V4.8

| Category | Change | Files |
|---|---|---|
| Template | Multi-dimensional Reusable Assets: 5-dimension table (Code/Pattern/Checklist/Process/Business Knowledge) | `templates/AI_Case_Card.md`, `skills/ll-dev/references/AI_Case_Card.md` |
| Report | Reusable Asset Registry instructions updated with 5-dimension Asset Type guidance | `reports/Reusable_Asset_Registry.md` |
| Alignment | Iteration_V46_Reference.md: "V4.7 Candidates" updated to "Post-V4.7 Status" | `reports/Iteration_V46_Reference.md` |

## V4.7

| Category | Change | Files |
|---|---|---|
| Routing | Case Type routing table (9 types with verification focus + reference cases) | `skills/ll-dev/SKILL.md` |
| Audit | FREIGHTLIST 25-case audit notes against V4.6 rules | `reports/case-studies/20260529/FREIGHTLIST_Audit_Notes_V46.md` |
| Audit | Dyson ocean-310 case audit notes against V4.6 rules | `reports/case-studies/20260529/Dyson_Ocean310_Audit_Notes_V46.md` |
| Report | Risk-benefit quadrant + Quadrant column in Scenario_Benefit_Matrix | `reports/Scenario_Benefit_Matrix.md` |
| Report | Per-case-type cost benchmarks from FREIGHTLIST batch | `reports/Token_Accounting_Before_After.md` |
| Report | V4.6 iteration reference document | `reports/Iteration_V46_Reference.md` |
| Report | V4.6 section in change index | `reports/Iteration_Change_Index.md` |
| Report | 11 new entries in Reusable Asset Registry | `reports/Reusable_Asset_Registry.md` |
| Deck | Corrected 3 proposal verdicts to "Applied in V4.6" | `LL_AI_Engineering_Standards_Deck.md` |
| Deck | Updated conclusion counts and Remaining Gaps | `LL_AI_Engineering_Standards_Deck.md` |
| Naming | Merge_Decision.md added to "Do Not Use" (Rule 17 sync) | `standards/Document_Naming_Standard.md`, `skills/ll-dev/references/Document_Naming_Standard.md` |
| Workflow | Step 10 owning skill corrected to match single-pass design | `skills/ll-dev/SKILL.md` |
| Config | Claude Code permission settings guide (16 git + 24 PowerShell + gated operations) | `claudecode_rule_setting.md`, `README.md` |
| Version | VERSION, plugin.json, marketplace.json, README, INSTALL, CHANGELOG updated to v4.7.0 | 6 files |

## V4.6

| Category | Change | Files |
|---|---|---|
| Retry Prevention | Solution.md Technical Constraints expanded: cross-module dependency + Mockito strictness verification | `templates/Solution.md`, `skills/solution-design/references/Solution.md` |
| Retry Prevention | Pre-verified Environment Shortcut (CLAUDE.md declares env once, Solution.md confirms) | `templates/CLAUDE.md`, `skills/ll-standards/references/CLAUDE.md`, `skills/solution-design/SKILL.md` |
| Token Optimization | Green Minimal Path (9-step compact flow for Green + single-file + <50 lines, target 20-50K) | `skills/ll-dev/SKILL.md` |
| Token Optimization | Closing docs single-pass (Steps 10-12 consolidated to Step 10, saves 15-20K/case) | `skills/ll-dev/SKILL.md` |
| Token Optimization | Session boundary markers at Steps 4, 7, 8 | `skills/ll-dev/SKILL.md` |
| Token Optimization | Conditional template sections (omit empty sections in Solution.md, Verify.md) | `skills/solution-design/SKILL.md`, `skills/verification/SKILL.md` |
| Token Optimization | ll-standards content deduplication (references ll-dev instead of duplicating tables) | `skills/ll-standards/SKILL.md` |
| Token Optimization | Token report sanity-check lookup table + cross-check rule | `skills/token-report/SKILL.md` |
| Enforcement | Track B closure check (Post-Merge Test Results must be backfilled before "Ready for Merge") | `skills/verification/SKILL.md` |
| Enforcement | Bug Fix pre-check (root cause + business source + code style confirmation) | `skills/ll-dev/SKILL.md` |
| Enforcement | Saved Hours 5-tier calibration table with overestimate explanation rule | `skills/token-report/SKILL.md` |
| Enforcement | FREIGHTLIST batch $2.44/hr benchmark added to Cost Efficiency reference | `skills/token-report/SKILL.md` |
| Naming | Merge_Decision.md added to "Do Not Use" (use Solution.md Human Approval instead) | `standards/Document_Naming_Standard.md`, `skills/ll-dev/references/Document_Naming_Standard.md` |
| Deck | Engineering value presentation (17 slides + appendix, V4.1-V4.6 evolution) | `LL_AI_Engineering_Standards_Deck.md` |
| Case Studies | 27-case audit (21 FREIGHTLIST + 2 Dyson + 4 prior benchmarks) | `reports/case-studies/20260529/` |

## V4.5

| Category | Change | Files |
|---|---|---|
| Plugin | Plugin manifest + marketplace manifest | `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` |
| Plugin | Plugin-level CLAUDE.md (auto-loaded rules) | `CLAUDE.md` |
| Plugin | /ll-setup skill (project initialization) | `skills/ll-setup/SKILL.md` |
| Namespace | feature-dev renamed to ll-dev (avoid official plugin collision) | `skills/ll-dev/`, 18 files updated |
| Consistency | AI_Case_Card.md added to ll-dev/references/ | `skills/ll-dev/references/AI_Case_Card.md` |
| Consistency | Model casing unified (Sonnet/Opus/Haiku) | `skills/ll-dev/SKILL.md` |
| Consistency | verification Self-Fix adds Rule 17 sync step | `skills/verification/SKILL.md` |
| Consistency | CLAUDE.md reference moved to ll-standards | `skills/ll-standards/references/CLAUDE.md` |
| Consistency | Rule 13 enforcement added to ll-dev | `skills/ll-dev/SKILL.md` |
| Consistency | ll-standards + ll-setup added to Skill Naming | `standards/Document_Naming_Standard.md` |
| Governance | Rule 20 (CLAUDE.md / ll-rules.md sync) | `GOVERNANCE.md` |
| Script Fix | install_project.sh Chinese text removed (Rule 19) | `scripts/install_project.sh` |
| Script Fix | install_project.py rewritten V4.3->V4.5 structure | `scripts/install_project.py` |
| Audit | End-to-end 118-check audit (all pass) | 5 dimensions: flow, templates, upgrade, governance, output |
| Governance | Rule 20 (CLAUDE.md / ll-rules.md sync) | `GOVERNANCE.md` |

## V4.4 (current)

| Category | Change | Files |
|---|---|---|
| Architecture | CLAUDE.md split: Section 1 (project) + ll-rules.md (standard) | `ll-rules.md`, `templates/CLAUDE.md` |
| Architecture | Skill deduplication: 35 -> 17 refs, single ownership | `skills/*/references/` |
| Architecture | feature-dev: template carrier -> orchestrator (~83% context reduction) | `skills/feature-dev/SKILL.md`, `skills/feature-dev/references/` |
| Upgrade | VERSION file + version stamp + atomic upgrade scripts | `VERSION`, `scripts/upgrade_project.*`, `scripts/install_project.*` |
| Migration | V4.3 -> V4.4 migration script (CLAUDE.md split) | `scripts/migrate_v43_to_v44.*` |
| SDLC | 9-stage AI-assisted SDLC standard document | `SDLC.md` |
| Scripts | All PS1/SH scripts English-only, Chinese via file I/O | `scripts/*.ps1`, `scripts/*.sh` |
| Governance | Rule 18 (atomic upgrade), Rule 19 (no Chinese in scripts) | `GOVERNANCE.md` |

## V4.3

| Category | Change | Files |
|---|---|---|
| QA | API Test Cases + Error Code Coverage | `templates/Test.md`, `skills/test-design/SKILL.md` |
| QA | Permission & Security Checklist (6 checks + Permission Matrix) | `templates/Test.md`, `skills/test-design/SKILL.md` |
| QA | AC Traceability Rule (every AC must have test) | `skills/test-design/SKILL.md` |
| QA | Fix History atomic pipeline (record -> apply -> proceed) | `skills/test-design/SKILL.md`, `skills/verification/SKILL.md` |
| QA | Completeness Checks (AC Mapping + Not Run explanation) | `skills/verification/SKILL.md` |
| Requirements | BA Business Model Input (Entities, State Machine, Permissions, Notifications) | `templates/Scenario.md`, `skills/scenario-analysis/SKILL.md` |
| Assets | Reusable Asset Registry | `reports/Reusable_Asset_Registry.md` |
| Workflow | Yellow approval gate (Human Approval before Task/Test) | `skills/feature-dev/SKILL.md` |
| Workflow | Red path restriction (analysis docs only) | `skills/feature-dev/SKILL.md` |
| Model | Sonnet-first for Yellow solution design | `skills/feature-dev/SKILL.md`, `skills/ll-standards/SKILL.md` |
| Workflow | task-breakdown SKILL.md expanded (Required Input, Stop Conditions, 5 rules) | `skills/task-breakdown/SKILL.md` |
| Workflow | solution-design SKILL.md expanded (Risk-Level Gating, Track B Declaration) | `skills/solution-design/SKILL.md` |
| Token | Near Threshold synced to standard | `standards/AI_Token_Cost_Standard.md` |

## V4.2

| Category | Change | Files |
|---|---|---|
| Solution | Technical Constraints table (Stop Condition) | `templates/Solution.md`, `skills/solution-design/SKILL.md` |
| Verification | Track A/B dual-track protocol + Worktree Exemption | `skills/verification/SKILL.md`, `templates/Verify.md`, `standards/AI_Verification_Standard.md` |
| Requirements | RA Draft Quality Gate (5-item checklist) | `skills/scenario-analysis/SKILL.md` |
| Case Card | Related Cases + Quality Metrics sections | `templates/AI_Case_Card.md` |
| Token | Saved Hours formula | `standards/AI_Token_Cost_Standard.md` |
| Token | Main Claude orchestration estimation | `skills/token-report/SKILL.md` |
| Token | Retry classification [Logic]/[Toolchain]/[Assumption] | `skills/token-report/SKILL.md`, `templates/Token_Usage_Report.md` |
| Token | Cost Efficiency (Cost/Saved Hours with benchmarks) | `templates/Token_Usage_Report.md`, `skills/token-report/SKILL.md` |

## V4.1

| Category | Change | Files |
|---|---|---|
| Enforcement | Hard Enforcement Layer (Before-Read/Write/Response) | `skills/feature-dev/SKILL.md`, `skills/ll-standards/SKILL.md` |
| Enforcement | Concise Output rules (no sycophantic, no emoji, no em-dash) | `templates/CLAUDE.md` |
| Model | Model Selection + Escalation Condition column | `skills/feature-dev/SKILL.md`, `skills/ll-standards/SKILL.md` |
| Model | Exploration Protocol (Steps 0-3 + Explore Agent 4-condition gate) | `skills/feature-dev/SKILL.md` |
| QA | Test.md mandatory sections (Scope, Data, Mock Strategy, Boundary, Fix History) | `templates/Test.md`, `skills/test-design/SKILL.md` |
| QA | Mockito 3 rules (anyInt, LENIENT, pre-declare strictness) | `templates/Test.md`, `skills/test-design/SKILL.md` |
| Templates | QA_Retry_Root_Cause.md, SubAgent_Token_Report.md | `templates/` |
| Token | Abnormal Cost Review triggers (Opus on Code Impl, Explore Agent deviation) | `standards/AI_Token_Cost_Standard.md`, `skills/token-report/SKILL.md` |
| Token | Model Naming Standard (Sonnet/Opus/Haiku, no version, no emoji) | `standards/AI_Token_Cost_Standard.md` |
| Token | Runtime Mode benchmark ($0.935 vs $1.318) | `standards/AI_Token_Cost_Standard.md` |
| Governance | Rule 13 (no Skill mixing), Rule 14 (CLAUDE.md mandatory) | `GOVERNANCE.md` |
| Case Studies | 4 archives (BizDB, EDI, VBO x2) | `reports/case-studies/` |
