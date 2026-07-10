# LL AI Engineering Standards
## Engineering Value & Version Evolution

---

## Slide 1 — Why This Matters

**AI tools alone do not produce consistent results**

- The same prompt gives different outputs across team members
- Without a shared workflow, every engineer invents their own process
- Skill difficulty varies: experienced engineers benefit, newcomers are blocked
- Context window constraints silently degrade output quality as conversations grow

**Engineering standards solve the consistency problem**

> Standards do not constrain AI — they constrain the *inputs* to AI so the outputs are reliable.

---

## Slide 2 — The Core Problem: Three Failure Modes

| Failure Mode | Symptom | Cost |
|---|---|---|
| **Assumption retries** | AI writes code against fields/APIs it did not verify | Re-work, re-test, extra tokens |
| **Context pollution** | Long-running sessions cause drift, hallucination, wrong references | Silent errors, late discovery |
| **No cost visibility** | "AI saved time" but no one knows by how much | Cannot justify investment, cannot improve |

**Without engineering standards, all three failures are invisible until after the fact.**

---

## Slide 3 — What Engineering Standards Actually Provide

```
AI Tool (raw)          LL AI Engineering Standards
─────────────          ──────────────────────────────
- No workflow          + Structured SDLC: 9 stages, 12 document types
- No gates             + Stop conditions before every high-risk phase
- No cost tracking     + Token Report with Retry classification
- No skill leveling    + Skill-per-stage: any team member follows the same path
- Full context always  + Targeted reads, 17 single-owner templates
```

---

## Slide 4 — Team Onboarding: Skill Barrier Before vs After

**Before (raw AI usage)**
- Senior engineers guide every junior interaction
- Each PR is a surprise — no one knows what AI did or why
- Reviewing AI-generated code requires understanding the full conversation history
- No handoff artifacts

**After (LL Standards)**
- Skill files guide each stage — junior engineers follow a checklist
- Every case produces: Scenario.md, Solution.md, Task.md, Test.md, Verify.md
- PR reviewer reads the document chain, not the conversation
- AI_Case_Card captures reusable assets for future cases

> **The standards shift the skill requirement from "know how to prompt AI" to "know which stage you are in."**

---

## Slide 5 — Context Window: The Silent Quality Problem

**What happens without context management**

- A 50-turn session accumulates context from early stages that is no longer relevant
- AI reads stale file versions, outdated assumptions, superseded decisions
- Long prompts consume tokens before any real work starts

**LL's engineering response**

| Mechanism | Effect |
|---|---|
| Single-owner skill files (17, not 35) | Each skill loads only what it needs |
| Targeted read rules: skip >100KB, section-read >1000 lines | 60–80% context reduction per read |
| Stage-based workflow | Each stage starts fresh with a defined input set |
| Solution.md Technical Constraints | Forces explicit verification *before* entering implementation, not during |

> V4.4 architecture refactor: `ll-dev` skill context reduced by ~83% through template deduplication.

---

## Slide 6 — Version Evolution: V4.1

### Hard Enforcement Layer (May 2026)

**Problem addressed**: Behavioral rules in CLAUDE.md were passive — AI could read them and ignore them.

**Improvement**: Elevated 6 rules to execution checkpoints:

- **Before-Read**: verify file exists, check size, targeted section if >1000 lines
- **Before-Write**: verify all referenced fields and API signatures exist in source
- **Before-Response**: no sycophantic openers, no estimates stated as fact

**Impact**

- Rule violations now cause a stop, not a warning
- Runtime enforcement costs 0 tokens — no audit document needed
- Benchmark: CLAUDE.md runtime mode costs $0.935 vs $1.318 for rules-in-prompt

> Principle established: **Prevention over audit** — block at zero cost rather than log after the fact.

---

## Slide 7 — Version Evolution: V4.2

### Technical Constraints Stop Condition + Cost Visibility (May 2026)

**Problem addressed**: AI was entering implementation with unverified assumptions about fields, APIs, and build environments.

**Improvement 1: Solution.md Technical Constraints table**

- Mandatory pre-implementation verification table
- If unfilled → Stop Condition; cannot proceed to Task.md or Test.md
- Verified: Java version, JAVA_HOME, entity field names, available API methods, cross-module dependencies

**Improvement 2: Retry Classification**

- Every retry labeled as `[Logic]`, `[Toolchain]`, or `[Assumption]`
- `[Assumption]` retries are fully preventable by reading source before writing

**Improvement 3: Cost Efficiency Section**

- Cost/Saved Hours benchmark (EDI: $0.07/hr, VBO: $0.18/hr, BizDB: $0.59/hr)
- First quantified ROI data in the team's history

---

## Slide 8 — Version Evolution: V4.3

### Test Quality + Permission Security + AC Traceability (May 2026)

**Problem addressed**: Tests were generated without structure, missing security coverage, and not traceable to requirements.

**Improvements**

| Addition | Value |
|---|---|
| API Test Cases section | Endpoint table + error code coverage, not just unit tests |
| Permission & Security Checklist | 6 standard checks + Permission Matrix — catches auth gaps before merge |
| AC Traceability Rule | Every Acceptance Criterion must have at least one test — no silent gaps |
| Fix History atomic pipeline | Record defect → apply prevention rule → proceed (stops repeat failures) |
| BA structured input in Scenario.md | Entities, State Machine, Permissions, Notifications as fields — not free text |

**Outcome**: Large feature (VBO) produced 39 unit tests, full permission coverage, zero post-merge rework.

---

## Slide 9 — Version Evolution: V4.4

### Architecture Refactor — Atomic Upgrades + Context Reduction (May 2026)

**Problem addressed**: 35 duplicate template copies drifted from their sources. Upgrading the standard required updating 35 files manually; one missed sync = silent inconsistency.

**Improvement: Three-layer separation**

```
Layer 1: Project-owned    CLAUDE.md Section 1    (never touched by upgrade)
Layer 2: Upgrade-managed  ll-rules.md + skills/  (replaced atomically)
Layer 3: Version stamp    ll-standards.version   (single source of truth)
```

**Results**

- Reference files: 35 → 17 (single ownership per template)
- ll-dev skill context: ~83% reduction
- Upgrade: one command, one version number, no partial states
- Install scripts: PS1 / SH / PY producing identical output

> Principle established: **Single ownership** — each template owned by exactly one skill's `references/` directory.

---

## Slide 10 — Version Evolution: V4.5

### Plugin Marketplace — One-Command Install (May 2026)

**Problem addressed**: Installing LL standards required manual script execution. Different environments (Windows/Linux/Mac) had inconsistent outcomes. Teams without script familiarity struggled to onboard.

**Improvement: Claude Code plugin distribution**

```bash
# Before V4.5
curl -o install_project.sh ... && bash install_project.sh

# After V4.5
claude plugin marketplace add <repo>
claude plugin install ll-standards@ll-ai-standards
/ll-setup
```

**Additional governance**

| Item | Value |
|---|---|
| 12 skills declared in plugin.json | Single manifest, version-locked |
| Namespace fix: feature-dev → ll-dev | No collision with Anthropic's official `feature-dev` plugin |
| End-to-end audit: 118 checks | Verified: flow traceability, template application, upgrade parity, governance rules |
| Dual distribution | Plugin (recommended) + scripts (fallback) — same output |

> **The engineering install barrier dropped from "run a script and hope" to "one command."**

---

## Slide 11 — Version Evolution: V4.6

### Assumption Retry Prevention + Token Optimization (May 2026)

**Source**: DMS DeepSeek case study (850K tokens, 7 retries) + FREIGHTLIST batch audit (21 cases, 2.1M tokens, $2.44/hr)

**Part A: Block [Assumption] retries**

| Retry | Category | What happened |
|---|---|---|
| #4 | [Assumption] | Used MyBatis-Plus StringUtils -- adapter had no such dependency |
| #5 | [Assumption] | Called DTO.getPolicy() / getToDestination() -- methods did not exist |
| #6 | [Assumption] | Called Spring StringUtils.isBlank() -- method does not exist |

Solution.md Technical Constraints expanded with cross-module dependency verification and explicit "must not assume" language.

**Part B: Token consumption optimization (7 changes)**

| # | Optimization | Saving/Case | Change |
|---|---|---|---|
| 1 | Project-level Technical Environment pre-declaration | 5-10K | CLAUDE.md template + solution-design SKILL shortcut |
| 2 | Closing docs single-pass generation | 15-20K | ll-dev workflow Step 10: one pass, not 3 skill invocations |
| 3 | Green Minimal Path | 30-50K (Green) | 9-step compact flow; skip AI_Case_Card, PR_Template, Mapping_Rules |
| 4 | Session boundary markers | 10-30% cumulative | Recommended split points at Steps 4, 7, 8 |
| 5 | Conditional template sections | 1-3K | Omit empty "None" sections in Solution.md and Verify.md |
| 6 | Duplicate skill content consolidation | ~400 | ll-standards references ll-dev instead of duplicating tables |
| 7 | Token report quick estimation + cross-check | ~5K | Lookup table for sanity checks; Card-vs-Report cross-check rule |

**Projected impact on FREIGHTLIST-type batches**

- Low-effort optimizations (1, 2, 5, 6, 7): 25-35K tokens/case = 25-35% reduction
- Green Minimal Path (3): additional 30-50K/Green case
- Session boundaries (4): prevents context compaction waste on large cases
- Sonnet-first enforcement (existing V4.1 rule): 3-5x cost reduction at same token count

> **V4.6 closes both gaps: [Assumption] retries blocked by template gates, token consumption reduced by workflow optimization.**

---

## Slide 12 — Version Evolution: V4.7

### Case Type Routing + Audit Documentation (May 2026)

**Source**: 27-case audit findings (FREIGHTLIST 25 + Dyson 2) + PPTX risk-benefit review analysis

**Part A: Case Type routing table**

After Step 3 (risk assessment), a 9-type routing table maps each case to verification focus areas and a reference case from the Reusable Asset Registry.

| Case Type | Verification Focus | Cost/Hr Benchmark |
|---|---|---|
| Rule Framework | Stub tracking, placeholder follow-up | $1.97/hr |
| Field Completion (batch) | Field source from entity, Mapper XML consistency | $2.67/hr |
| Field Completion (single) | Green Minimal Path if <50 lines | -- |
| Bug Fix | Pre-check: root cause + business source + code style | $2.83/hr |
| Calculation Logic | P0 boundary: null/zero/negative, BigDecimal, totals | $2.31/hr |
| EDI Mapping | Mapping_Rules.md, javap signatures, AC field trace | $0.10/hr |
| Trigger Control | Green Minimal Path if condition-only change | $5.85/hr |
| Interface Simplification | Caller impact before changing method signature | -- |
| Large Feature | Full flow, SubAgent tracking, AC across layers | $0.18/hr |

Design choice: **Option B** (routing within existing skills + Case Library) over Option A (scenario-specific skills). Option A would add ~15-25K tokens/session context and double maintenance surface. Option B keeps the 12-skill architecture and uses reference cases as the guidance layer.

**Part B: Audit documentation**

| Audit | Scope | Key Finding |
|---|---|---|
| FREIGHTLIST 25-case | All sub-cases vs V4.6 rules | P0: 17/25 have banned Merge_Decision.md; P1: recal-match-rule Card vs Report 61% cost mismatch |
| Dyson ocean-310 | Highest-quality case | P1: test count 22 vs 24 after requirement change (Closing single-pass would prevent) |

**Part C: Standards fixes, reports, and tooling**

- Merge_Decision.md added to "Do Not Use" (Document Naming Standard)
- Risk-benefit quadrant added to Scenario_Benefit_Matrix.md
- Per-case-type cost benchmarks from FREIGHTLIST batch
- Iteration_V46_Reference.md created; Reusable Asset Registry +11 entries
- Claude Code permission settings guide: 16 git + 24 PowerShell pre-approved operations, destructive operations gated
- Version bumped to v4.7.0 across all version files

> **V4.7 extends the workflow from "same steps for all cases" to "right verification depth for each case type" -- without adding new skills or new documents.**

---

## Slide 13 — Case Study Audit: 27 Cases Reviewed (May 2026)


Two teams' case output audited against V4.5 standards: Dyson (2 cases) and FREIGHTLIST (25 cases).

### FREIGHTLIST Batch Aggregate (21 quantifiable cases)

| Metric | Value |
|---|---|
| Total Cases | 21 (18 Yellow, 3 Green) |
| Total Tokens | ~2.096M |
| Total Cost | ~$39.88 |
| Total Saved Hours | ~16.35h |
| Aggregate Cost/Hr | ~$2.44/hr |
| Zero-Retry Cases | 18/20 (90%) |
| Case Types Covered | Rule framework, field completion, bug fix, calculation logic, trigger control, interface simplification |

### Dyson Ocean-310 (Yellow, EDI mapping)

| Metric | Value |
|---|---|
| Tokens | 232K (estimated) |
| Cost | $1.38 |
| Tests | 24/24 passed |
| Saved Hours | 14h (~1.5-2 person-days) |
| Cost/Hr | $0.099/hr |
| Retries | 2 [Assumption] -- field name and test dependency not pre-verified |

### Case Study Audit Findings

| Priority | Finding | Action |
|---|---|---|
| P0 | Air-billing case missing all docs | Backfill or annotate as pre-standard |
| P0 | `ic-trans-ps-amount-var` has only 1 doc | Backfill minimum set |
| P1 | Green path docs inconsistent | Define explicit Green Minimal Path policy |
| P1 | `Merge_Decision.md` non-standard | Resolved: added to Document Naming Standard "Do Not Use" list; use Solution.md Human Approval instead |
| P1 | Worktree Track B always used (100%) | Project-level CLAUDE.md declaration |
| P2 | Solution.md date typo | Fix "2025" to "2026" |
| P2 | 4 cases missing Token_Usage_Report | Require minimum cost tracking for all cases |
| -- | Retrospective improvement loop working | Evidence: Dyson air-billing Retrospective findings directly applied in ocean-310 case |

### What the Audit Proves

- AI handles **diverse task types** in production: rule frameworks, field chains, financial calculations, bug fixes -- not just simple patches
- 90% zero-retry rate with LL standards active; the 2 retries were user-driven design corrections, not compilation failures
- The Retrospective-to-Template loop works: air-billing Retrospective identified 6 problems; ocean-310 applied 4 fixes and reduced self-fix count

---

## Slide 14 — Measurable Engineering Value

### Cost Benchmarks Across Cases

| Case | Mode | Tokens | Cost | Retries | Saved Hours | Cost/Hr |
|---|---|---|---|---|---|---|
| BizDB V3.0 | 7 SubAgents | 400K | $5.49 | 2 | ~15 | $0.37 |
| BizDB V4.0 | LL-only | 172K | $0.89 | 0 | ~15 | **$0.06** |
| EDI Mapping | LL-only | 67.5K | $0.51 | 0 | 7 | **$0.07** |
| Dyson Ocean-310 | LL Mode 2 | 232K | $1.38 | 2 | 14 | $0.10 |
| VBO Large Feature | LL + SubAgent | 225K | $4.50 | 0 | 25 | $0.18 |
| FREIGHTLIST Batch (21) | LL Mode 1 | 2.1M | $39.88 | 2 | 16.35 | $2.44 |
| DMS DeepSeek | DeepSeek V4 Pro | 850K | N/A | 7 | 40 (est.) | N/A |

**Key observations**

- LL-only mode (no subagents, correct mode selection) cuts cost by 2.3x-6x compared to over-dispatched mode
- Large features (EDI mapping, VBO) amortize documentation cost: $0.07-$0.18/hr
- Small fixes with full documentation have inverted ratios: $2.44-$7.50/hr
- FREIGHTLIST batch $2.44/hr is above BizDB $0.59/hr benchmark -- primary driver: Opus used for Green/small Yellow tasks instead of Sonnet

### What Retries Actually Cost

- 1 `[Assumption]` retry = 5,000-15,000 tokens + 30-60 minutes engineer review time
- DMS case: 3 preventable retries = ~45K tokens wasted
- Prevention cost: read source file once before writing = ~200-500 tokens
- FREIGHTLIST batch: 90% zero-retry -- standards enforcement is working

---

## Slide 15 — Improvement Proposals: What Has Real Value

### Context

The FREIGHTLIST batch summary proposed 8 improvement recommendations. Each was assessed against V4.6 scope, the 7 established design principles (Prevention over audit, Single ownership, Atomic upgrade, Layer separation, Sonnet-first, Zero-cost rules, Scope boundary), and the rejected proposals precedent from V4.1-V4.4.

### Assessment

| # | Proposal | Verdict | Reasoning |
|---|---|---|---|
| 1 | Yellow Minimum Verification Gate | Already exists; strengthened in V4.6 | Track B protocol (V4.2) already requires Command/Owner/Timing; V4.6 added Track B closure enforcement (verification SKILL.md check 3) |
| 2 | Model Routing Strategy | Already exists | Model Selection table in ll-dev SKILL.md since V4.1; Sonnet-first with escalation conditions |
| 3 | Mini Flow for Green/small tasks | Applied in V4.6 | Implemented as Green Minimal Path in ll-dev SKILL.md: 9-step compact flow for Green + single-file + <50 lines, target 20-50K tokens |
| 4 | Temporary Disable Governance | Rejected | Scope boundary -- project-domain business control, not AI engineering process |
| 5 | Calculation Logic P0 Checklist | Rejected | Domain-specific (FREIGHTLIST financial logic); belongs in project CLAUDE.md, not cross-team standard |
| 6 | Multi-dimensional Reusable | Applied in V4.8 | AI_Case_Card expanded with 5-dimension Reusable Assets section (Code/Pattern/Checklist/Process/Business Knowledge); Registry instructions updated |
| 7 | Case Library / Case Type | Strengthened in V4.7 | Reusable Asset Registry (V4.3) expanded with 11 new entries; Case Type routing table added to ll-dev SKILL.md with reference cases per type |
| 8 | Token/ROI cross-check rule | Applied in V4.6 | Zero-cost rule added to token-report SKILL.md Step 8; prevents data inconsistency observed in 3+ cases |

### Conclusion

**Of 8 recommendations: 3 applied (Green Minimal Path + Token cross-check in V4.6, Multi-dimensional Reusable in V4.8), 2 strengthened (Track B closure in V4.6, Case Library in V4.7), 1 already covered, and 2 out of scope. All actionable proposals resolved.**

The strongest contribution of the batch analysis is not its template change proposals -- it is the **quantified evidence** (21 cases, 2.096M tokens, $39.88, 90% zero-retry, $2.44/hr aggregate). This data validates the standards at scale; the standards themselves need only minor refinement, not structural change.

> The fact that 5 of 8 recommendations were "already exists" is itself evidence that the standards are comprehensive. The gap is adoption consistency, not standard completeness.

---

## Slide 16 — Capability Requirements: Before vs After

| Capability | Raw AI Usage | LL Standards |
|---|---|---|
| Know which AI model to use | Required (experience) | Embedded in skill: Sonnet-first, Opus on escalation |
| Know when to use subagents | Required (experience) | Mode 1/2/3 criteria in ll-dev SKILL.md |
| Verify APIs before writing | Required (discipline) | Forced by Technical Constraints Stop Condition |
| Track token cost | Manual, ad hoc | Token_Usage_Report template with stage breakdown |
| Onboard new team member | Weeks of shadowing | Follow skill checklist + read document chain |
| Produce consistent artifacts | Depends on individual | Fixed document names, fixed output path, fixed structure |

> The standards do not make AI smarter. They make the *team's use of AI* reproducible.

---

## Slide 17 — Context Window Strategy: Practical Rules

**Problem**: A session that starts with Scenario Analysis and ends with Verification accumulates 100K+ tokens of context. Later stages read stale early-stage content.

**LL's mitigation approach**

1. **Stage-per-session**: each skill invocation starts a bounded context scope
2. **No re-reads**: rule 1.5 — do not re-read a file already read in this session
3. **Size gates**: skip >100KB files; section-read >1000-line files; state what was read and what was skipped
4. **Template as anchor**: Solution.md / Test.md serve as the stage's ground truth — not the conversation
5. **Document chain replaces conversation**: reviewer reads documents, not chat history

**Token distribution target (Mode 1 / LL-only)**

| Stage | Target % |
|---|---|
| Scenario Analysis | 5–10% |
| Solution Design | 10–20% |
| Code Implementation | 40–55% |
| Test Generation | 10–15% |
| Verification | 10–15% |
| Rework / Retry | < 5% |

> Rework above 10% triggers Abnormal Cost Review.

---

## Slide 18 — Summary: Engineering Value Delivered

### By Version

| Version | Primary Value | Measurable Outcome |
|---|---|---|
| V4.1 | Behavioral enforcement | 0-token prevention vs 5-10K tokens/audit |
| V4.2 | Stop Condition + cost visibility | First ROI benchmarks; retry classification |
| V4.3 | Test quality + traceability | 39 tests, full permission coverage, zero post-merge rework |
| V4.4 | Architecture simplification | 83% context reduction; 35 to 17 templates; atomic upgrades |
| V4.5 | One-command install | Onboarding from script-run to single CLI command |
| V4.6 | Retry prevention + token optimization | [Assumption] retries blocked; 25-35% token reduction via 7 workflow optimizations |
| V4.7 | Case Type routing + audit documentation | 9-type routing table; 27-case audit notes; risk-benefit quadrant; per-case-type benchmarks |
| V4.8 | Multi-dimensional Reusable Assets | 5-dimension reuse evaluation (Code/Pattern/Checklist/Process/Business Knowledge); all 8 proposals resolved |
| V4.9 | Plugin marketplace install fix | `file` type source path corrected; marketplace folder seeding documented; GitLab Files API findings recorded |

### At Scale: 27 Cases Audited

| Metric | Value |
|---|---|
| Teams covered | 2 (FREIGHTLIST, Dyson) |
| Total cases | 27 (21 FREIGHTLIST + 2 Dyson + 4 prior benchmarks) |
| Zero-retry rate | 90% (FREIGHTLIST batch) |
| Cost range | $0.06-$2.44/hr across different task types |
| Task diversity | Rule frameworks, field chains, EDI mapping, financial calculations, bug fixes |
| Improvement proposals assessed | 8 proposed, 3 applied (V4.6/V4.8), 2 strengthened (V4.6/V4.7), 1 already covered, 2 rejected (scope) -- all resolved |

### Cumulative Engineering Value

- **Standards reduce skill barrier**: junior engineers follow a checklist, not intuition
- **Standards reduce context cost**: targeted reads, single ownership, stage isolation
- **Standards produce evidence**: every case generates a traceable document chain
- **Standards enable improvement**: retry classification drives template fixes (V4.2 to V4.6 closed loop)
- **Standards are validated at scale**: 90% zero-retry across 21 production cases; standards comprehensive enough that 5 of 8 improvement proposals were "already exists"

### Remaining Gaps (Honest Assessment)

- **Small-task ROI inversion**: Green Minimal Path (V4.6) + Case Type routing (V4.7) address the standards side. Adoption data from next batch needed to measure actual token reduction.
- **Model routing adoption**: Sonnet-first rules exist since V4.1 but teams default to Opus at session level. Enforcement, not standards, is the gap.
- **Test execution evidence**: Track B closure enforcement added in V4.6; monitoring needed to verify compliance across teams.
- **Multi-dimensional Reusable**: applied in V4.8. AI_Case_Card now captures 5 reuse dimensions (Code/Pattern/Checklist/Process/Business Knowledge). Adoption data needed from next batch.

> The standards have reached a maturity point where the primary bottleneck is no longer "what rules to add" but "how consistently teams follow existing rules." V4.7 closes the loop from audit to action: case data drives routing rules, routing rules reference case data.

---

## Appendix — Document Chain Reference

```
AI_Request.md         (what to build)
Scenario.md           (business model + AC)
AI_Risk_Level.md      (Green / Yellow / Red)
Solution.md           (technical constraints + approved design)
Mapping_Rules.md      (if applicable)
Task.md               (executable tasks with AC traceability)
Test.md               (unit + API + permission/security)
  -> Implementation   (Hard Enforcement Layer active)
Verify.md             (Track A/B + completeness checks)
PR_Template.md        (handoff to human review)
AI_Case_Card.md       (quality metrics + reusable assets)
Token_Usage_Report.md (cost efficiency + retry classification)
```

**Output path**: `docs/ai/cases/<YYYYMMDD_team_scenario-slug>/`
