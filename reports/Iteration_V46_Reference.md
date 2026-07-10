# V4.6 Iteration Reference

> Full context for V4.6 changes. For quick file-level lookup, see [Iteration_Change_Index.md](Iteration_Change_Index.md).
> For earlier versions, see [Iteration_V41_V44_Reference.md](Iteration_V41_V44_Reference.md) (V4.1-V4.4) and [Iteration_V45_Reference.md](Iteration_V45_Reference.md) (V4.5).

---

## 1. Problem Statement

Two data sources exposed gaps in V4.5:

1. **DMS DeepSeek case study** (850K tokens, 7 retries): 3 retries were `[Assumption]` -- AI used fields, methods, and APIs that did not exist. These were fully preventable by reading source before writing.

2. **FREIGHTLIST batch audit** (21 cases, 2.096M tokens, $39.88, $2.44/hr): Token consumption on small tasks was disproportionate due to full documentation flow, Opus on Green tasks, and no session boundary guidance.

V4.6 addresses both: retry prevention via template gates, and token reduction via workflow optimization.

---

## 2. Retry Prevention

### Technical Constraints Expansion

Solution.md Technical Constraints table expanded from 5 to 7 rows:

| New Row | Purpose |
|---|---|
| Cross-module / cross-service dependency declaration | Prevents `[Assumption]` retries where AI imports from modules not in the dependency tree |
| Mockito strictness setting | Prevents test failures from strict stub enforcement |

Added explicit "must not assume" language to field name and utility method rows.

### Pre-verified Environment Shortcut

Added `## Technical Environment (Pre-verified)` section to CLAUDE.md template (6 fields: Java version, JAVA_HOME, build tool, worktree support, test framework, Mockito strictness).

When filled, Solution.md SKILL writes "Confirmed from CLAUDE.md" instead of re-running `java -version`, `gradle -version`, or worktree builds. Saves 5-10K tokens/case.

---

## 3. Token Optimization (7 Changes)

### 3.1 Green Minimal Path

Gate condition: Green + single-file (or impl + test) + <50 lines diff.

9-step compact flow skipping PR_Template.md, AI_Case_Card.md, and Mapping_Rules.md. Target: 20-50K tokens vs 80-150K for full flow.

### 3.2 Closing Docs Single-Pass

Workflow Steps 10-12 consolidated into Step 10 "Closing". Generates Token_Usage_Report, AI_Case_Card, and PR_Template in one pass. Eliminates 2 redundant context re-reads (saves 15-20K tokens/case).

### 3.3 Session Boundary Markers

Recommended split points at Steps 4 (Solution.md), 7 (Test.md), and 8 (Implementation). Next session starts from the boundary document, not full conversation history. Criteria: >80K tokens, human confirmation needed, or context compaction occurred.

### 3.4 Conditional Template Sections

Solution.md: omit empty Impact Analysis subsections, Security, Rollback when content would be "None" or "N/A". Always generate: Solution Overview, Technical Constraints, Recommended Solution, Human Approval.

Verify.md: omit "Not Run" test result rows except required rows (Build, Unit Test, Type Check, Secrets Scan).

### 3.5 Skill Content Deduplication

ll-standards SKILL.md replaced duplicated tables (Hard Enforcement, Model Selection, Exploration Protocol) with references to ll-dev SKILL.md. Net reduction: ~400 tokens/session.

### 3.6 Token Report Enhancements

- Sanity-check lookup table (7 case types with expected token/cost ranges)
- Cross-check rule: AI_Case_Card Token Cost must match Token_Usage_Report total
- FREIGHTLIST batch $2.44/hr benchmark added to Cost Efficiency reference

### 3.7 Projected Impact

| Optimization | Saving/Case |
|---|---|
| Pre-verified Environment (3.1) | 5-10K |
| Closing single-pass (3.2) | 15-20K |
| Session boundaries (3.3) | 10-30% cumulative |
| Conditional sections (3.4) | 1-3K |
| Skill deduplication (3.5) | ~400 |
| Token report quick checks (3.6) | ~5K |
| Green Minimal Path (full flow skip) | 30-50K per Green case |

---

## 4. Enforcement Rules Added

### Track B Closure (verification SKILL.md check 3)

If Track B was used, `## Post-Merge Test Results` must not be empty when the case is closed. Final Status must be "Ready for Review" until post-merge build and test evidence (commit hash + pass count) is backfilled.

### Bug Fix Pre-check (ll-dev Behavior item 10)

Before writing code for a bug fix, confirm: (1) root cause hypothesis with user, (2) business-authoritative field source, (3) code style in target class. Prevents the two most common Bug Fix retries: business semantic mismatch and code style inconsistency.

### Saved Hours Calibration (token-report SKILL.md)

5-tier reference table:

| Change Scope | Saved Hours Range |
|---|---|
| One-line fix / single-field setter | 0.25-0.5h |
| 2-5 field completion / simple condition change | 0.5-1.0h |
| Multi-method logic / framework setup | 1.0-2.5h |
| Full feature (Entity + Mapper + Service + Test) | 2.0-4.0h |
| Large EDI mapping (100+ fields) | 8-16h |

Overestimates require explanation note.

### Merge_Decision.md Banned (Document Naming Standard)

Added to "Do Not Use" list. Content should be consolidated into Solution.md `## Human Approval`.

---

## 5. Case Study Audit (27 Cases)

### Coverage

| Team | Cases | Tokens | Cost | Saved Hours | Cost/Hr |
|---|---|---|---|---|---|
| FREIGHTLIST (batch) | 21 (18Y, 3G) | ~2.096M | ~$39.88 | ~16.35h | ~$2.44/hr |
| Dyson ocean-310 | 1 (Yellow) | ~232K | ~$1.38 | 14h | ~$0.10/hr |
| Dyson air-billing | 1 (Yellow) | N/A | N/A | N/A | N/A |
| Prior benchmarks | 4 | varies | varies | varies | $0.06-$0.37/hr |

### Key Findings

- 90% zero-retry rate across FREIGHTLIST batch (18/20 quantifiable cases)
- Task diversity: rule frameworks, field chains, EDI mapping, financial calculations, bug fixes
- Retrospective-to-template loop validated (air-billing findings applied in ocean-310)
- Primary cost driver: Opus used for Green/small Yellow tasks instead of Sonnet

### Audit Categories

| Category | Count | Description |
|---|---|---|
| A: Resolved by V4.6 | 11 | Issues addressed by the 7 token optimizations and 3 enforcement rules |
| B: Zero-cost rules applied | 3 | Track B closure, Bug Fix pre-check, Saved Hours calibration |
| C: Out of scope / already covered | 9 | Domain-specific proposals or features already in V4.2-V4.5 |
| D: Case-level corrections | 5 | Individual case data fixes (Saved Hours, soft cap text, cost mismatch) |

### Improvement Proposals Assessed

8 proposals from the FREIGHTLIST batch summary were assessed against V4.6 scope and 7 design principles:

| Verdict | Count | Items |
|---|---|---|
| Applied in V4.6 | 2 | Green Minimal Path, Token/ROI cross-check |
| Strengthened in V4.6 | 1 | Track B closure enforcement |
| Already covered | 2 | Model Routing Strategy, Case Library |
| Deferred to V4.8 | 1 | Multi-dimensional Reusable (V4.7 addressed Case Library instead via routing table + 11 registry entries) |
| Rejected (scope boundary) | 2 | Temporary Disable Governance, Calculation Logic P0 Checklist |

---

## 6. Git

| Tag | Content |
|---|---|
| v4.6.0 | Retry prevention + 7 token optimizations + 27-case audit + deck + enforcement rules |

3 commits:
- `42d0c2f` fix: strengthen Solution.md Technical Constraints to block Assumption retries
- `c3d374f` feat: add 7 token optimizations and engineering value deck
- `81faa49` fix: add Track B closure enforcement, Bug Fix pre-check, Saved Hours calibration

---

## 7. Design Decisions

| Decision | Rationale |
|---|---|
| Green Minimal Path as gate, not separate workflow | Keeps one workflow definition in ll-dev SKILL.md. Gate condition (Green + single-file + <50 lines) is checked after Step 3. Avoids a second parallel workflow that would need independent maintenance. |
| Session boundaries as recommendations, not mandatory stops | Small Green cases run in one session. Mandatory stops would add unnecessary overhead. Split criteria (>80K tokens, human confirmation, context compaction) let the engineer decide. |
| Closing as single pass, not three skill invocations | Three separate reads of the same context waste 15-20K tokens. Order (Token Report first, then Case Card, then PR Template) ensures data flows forward without re-reads. |
| Merge_Decision.md banned, not adopted | Solution.md already has `## Human Approval`. A separate file creates a sync/naming problem without adding information. Consolidation follows Single Ownership principle. |
| Pre-verified Environment in CLAUDE.md, not Solution.md | Environment facts (Java version, build tool) are project-level, not case-level. Declaring them once in CLAUDE.md and confirming in Solution.md eliminates redundant verification across all cases in the project. |
| Saved Hours calibration table, not formula | A formula implies false precision. A reference table with ranges lets engineers match their change scope to a band and explain outliers. Aligns with "state confidence level" principle. |

---

## 8. Remaining Gaps (Post-V4.7 Status)

| Gap | Status | Resolution |
|---|---|---|
| Multi-dimensional Reusable evaluation | Deferred to V4.8 | V4.7 addressed Case Library via routing table + 11 registry entries; Reusable field expansion remains open |
| Model routing adoption enforcement | Adoption gap | Rules exist since V4.1; teams default to Opus at session level. Not a standards change |
| Track B post-merge backfill consistency | Adoption gap | Enforcement rule added in V4.6; monitoring needed. Not a standards change |
| Green Minimal Path adoption data | Data needed | Applied in V4.6; next batch audit should measure token reduction |
| Case Type routing adoption | Applied in V4.7 | 9-type routing table + reference cases. Adoption data needed from next batch |
| Permission settings guide | Applied in V4.7 | claudecode_rule_setting.md (16 git + 24 PowerShell). Referenced from README |
