---
name: ll-dev
description: Global entry for LL AI-assisted development. Use when the user wants the simplest end-to-end workflow and standard document generation.
---

# Feature Development Skill

## Goal

Use the simplest entry to generate standard intermediate documents and guide the full AI-assisted SDLC flow.

## Mandatory Output Path

All documents must be created or updated under:

```text
docs/ai/cases/<case-id>/
```

If `<case-id>` is missing, propose one using:

```text
YYYYMMDD_<team>_<scenario-slug>
```

## Workflow

Each step delegates to the owning Skill. In Mode 1, follow each Skill's SKILL.md steps inline. In Mode 3, individual Skills can be dispatched to subAgents.

| Step | Document | Owning Skill | Session | Notes |
|---|---|---|---|---|
| 1 | AI_Request.md | ll-dev (this skill) | A | Entry document |
| 2 | Scenario.md | scenario-analysis | A | Business Model Input for complex scenarios |
| 3 | AI_Risk_Level.md | risk-assessment | A | Green / Yellow / Red. **Green Minimal Path gate**: see below |
| 4 | Solution.md | solution-design | A | Technical Constraints (Stop Condition) + Track B Declaration |
| -- | **Session boundary A** | -- | -- | **Human confirms Solution.md before proceeding** |
| 5 | Mapping_Rules.md / Business_Rules.md | mapping-rules | B | If applicable |
| 6 | Task.md | task-breakdown | B | Requires approved Solution.md |
| 7 | Test.md | test-design | B | API Test + Permission Security (conditional) |
| -- | **Session boundary B** | -- | -- | **Human confirms Test.md before proceeding** |
| 8 | Implementation | (this skill) | C | Hard Enforcement Layer active |
| -- | **Session boundary C** | -- | -- | **Build passes before proceeding** |
| 9 | Verify.md | verification | D | Track A / B + Completeness Checks |
| 10 | Closing | (this skill) | D | PR_Template + AI_Case_Card + Token_Usage_Report in one pass |

Each Skill is self-contained: its SKILL.md defines rules, its references/ carries the template. Users can invoke any Skill independently (e.g., `/test-design` alone) without loading the full workflow.

### Session Boundaries

Session boundaries are recommended split points, not mandatory stops. Apply when:
- Context exceeds ~80K tokens and more stages remain
- Human confirmation is required (Yellow path Solution.md approval)
- Context compaction has occurred in the current session

When splitting at a boundary, the next session's input is the document produced at the boundary (Solution.md, Test.md, or code diff), not the full conversation history. This prevents context accumulation.

When the full workflow fits within context (small Green cases, Mode 1), run all steps in a single session.

### Green Minimal Path

After Step 3, if all conditions are met, switch to Green Minimal Path:

1. Risk level is Green
2. Change scope is single-file or two files (impl + test)
3. Expected diff is < 50 lines

Green Minimal Path workflow:

| Step | Document | Notes |
|---|---|---|
| 1 | AI_Request.md | Compact: requirement + scope + risk reason (3-5 lines) |
| 2 | Scenario.md | Compact: requirement statement + 1-3 ACs |
| 3 | AI_Risk_Level.md | One line: Green + reason |
| 4 | Solution.md | Technical Constraints only (use Pre-verified Environment Shortcut). Skip Impact Analysis, Recommended Solution, Security, Rollback sections |
| 5 | Task.md | Inline in Solution.md or 1-3 line standalone |
| 6 | Test.md | P0 checks only (happy path + one boundary) |
| 7 | Implementation | Hard Enforcement Layer active |
| 8 | Verify.md | Required rows only (Build, Unit Test, Type Check, Secrets Scan) |
| 9 | Token_Usage_Report.md | 1-line Task-Level summary. Skip Stage-Level, Cost Efficiency, Abnormal Cost Review |

Skip in Green Minimal Path: PR_Template.md, AI_Case_Card.md, Mapping_Rules.md. These can be generated on request.

Target token budget for Green Minimal Path: 20-50K tokens.

### Case Type Routing

After Step 3 (risk assessment), identify the case type and apply the corresponding verification focus and reference case. This table does not change the workflow -- it sharpens what to watch for within the existing steps.

| Case Type | Typical Risk | Mode | Verification Focus | Reference Case |
|---|---|---|---|---|
| Rule Framework | Yellow | 1 | Stub tracking; confirm all placeholders have follow-up cases | ic-trigger-rule-match |
| Field Completion (batch) | Yellow | 1 | Field source verified from entity class; Mapper XML consistent | ic-section-header-ic-type |
| Field Completion (single) | Green/Yellow | 1 | Green Minimal Path if <50 lines; verify setter exists in entity | ic-trans-final-shipment-number |
| Bug Fix | Yellow | 1 | Bug Fix pre-check (Behavior 10): root cause + business source + code style | ic-trans-system-type-null |
| Calculation Logic | Yellow | 1 | P0 boundary tests: null/zero/negative amounts, BigDecimal precision, total consistency | node5-calc-gp |
| EDI Mapping | Yellow | 2 | Mapping_Rules.md required; method signatures verified via javap; field-by-field AC trace | dyson_178737-ocean-310-billing |
| Trigger Control | Green/Yellow | 1 | Green Minimal Path if condition-only change; Yellow if LiteFlow path affected | ic-ap-share-type-filter |
| Interface Simplification | Green | 1 | Green Minimal Path; verify caller impact before changing method signature | upload-station-logic |
| Large Feature | Yellow | 3 | Full flow; SubAgent token tracking; AC traceability across all layers | VBO carrier (prior benchmark) |

Rules:
- Case type selection is a hint, not a gate. If the case does not match any row, follow the standard workflow without additional focus areas.
- Reference cases are in `reports/Reusable_Asset_Registry.md`. Read the reference case's Solution.md or Test.md when the current case matches the type -- reuse verification patterns, not just code patterns.
- Calculation Logic and Bug Fix types have the highest retry risk from the 27-case audit. Apply their verification focus areas even when the case seems simple.

### Closing Step (Step 10)

Generate PR_Template.md, AI_Case_Card.md, and Token_Usage_Report.md in a single pass. Do not generate each document as a separate skill invocation -- read the context once and produce all three. This eliminates redundant context re-reads that consume 15-20K tokens per case.

Order: Token_Usage_Report.md first (requires data collection), then AI_Case_Card.md (references token data), then PR_Template.md (summarizes everything).

## Naming Rules

Use fixed document names exactly as defined in `references/Document_Naming_Standard.md`.

## Execution Mode

Select one mode before starting. Mode determines tool usage, SubAgent strategy, and token budget.

| Mode | When to use | Token target |
|---|---|---|
| **Mode 1 — LL-only** | Small changes, single-service logic, bug fix, clear I/O, no cross-module exploration | 50K–150K |
| **Mode 2 — Mapping/EDI** | Field mapping, EDI X12, billing rules, customer-specific format conversion (>20 fields) | 80K–200K |
| **Mode 3 — Large Feature SubAgent** | >15 tasks or >20 new files, multi-layer changes (SQL+Mapper+Service+Controller+Test) | 200K–500K |

Mode 1 rules: use Grep/Read/Glob only -- no Explore Agent, no subAgents, no unrelated skill mixing.
Mode 2 rules: pre-populate Mapping_Rules.md and Business_Rules.md before implementation.
Mode 3 rules: subAgents allowed but token reporting mandatory; reference files >1,000 lines must be summarized before targeted reading.

All modes: do not mix unrelated external Skills in the same case execution. Skill combinations must be pre-defined in `skill-compositions/` (GOVERNANCE Rule 13).

## Hard Enforcement Layer

These are **execution constraints**, not suggestions. Check each gate at the stated moment — do not skip.

**Before every file read:**
- File >100KB → skip unless the task explicitly requires it. State the skip in the response.
- File already read in this session → do not re-read. Use the content from the earlier read.
- File >1,000 lines → read a targeted section only. State what was skipped.

**Before every file write or edit:**
- Target file exists and has not been read in this session → read it first.
- You are about to assert an API name, method signature, version number, field name, or CLI flag you have not verified from code or docs → read the source first, or remove the assertion and mark it as unverified.

**Before every response:**
- Response opens with "Great / Certainly / Of course / Sure / Absolutely / Happy to help" → delete the opener. Start with the answer.
- Response contains emoji or em-dash (—) → remove them.
- Response contains a statement of what you just did (trailing summary) → remove it.
- Response is longer than the task requires → trim. Result first, context only if non-obvious.

## Behavior

1. Apply CLAUDE.md Karpathy-inspired behavior mode (`templates/CLAUDE.md` is the canonical reference).
2. Apply Model Selection rules (see below) before every Agent tool call.
3. Clarify before coding.
4. Generate missing intermediate documents using templates.
5. Choose Green / Yellow / Red path.
6. Stop on unclear requirements, missing risk level, Red implementation request, or 3 failed fixes.
7. **Yellow path**: do not generate Task.md or Test.md until `Solution.md ## Human Approval` is signed by the human reviewer. Wait for explicit confirmation.
8. **Red path**: generate Scenario.md, AI_Risk_Level.md, and Solution.md (analysis only). Do not generate Task.md, Test.md, or any code.
9. Do not create all-in-one documents.
10. **Bug Fix pre-check**: when the task is a bug fix, confirm three things with the user before writing code: (1) root cause hypothesis -- state what you believe is broken and why, ask the user to confirm; (2) business-authoritative field source -- identify which object/field is the trusted source of truth for the value being fixed; (3) code style in the target class -- read the target method and its neighbors to match existing patterns (void + internal mutation vs return value, naming conventions, error handling style).

## Model Selection

Apply before every Agent tool call. Always pass the `model` parameter explicitly — never rely on the default.

| Task Type | Risk Level | Model | Escalation Condition |
|---|---|---|---|
| Simple CRUD, config changes, single-file edits | Green | Sonnet | No escalation |
| Multi-file refactor, standard feature implementation | Green / Yellow | Sonnet | 2 consecutive failures, or architecture dispute |
| QA test generation | Green / Yellow | Sonnet | Unknown test framework, 2+ consecutive failures, or complex Mock setup |
| Complex solution design, architecture decisions | Yellow | Sonnet | 3+ components or 2 consecutive Sonnet failures -> escalate to Opus |
| Complex test strategy, difficult verification | Yellow / Red | Opus | Already Opus |
| Analysis-only (Red path, no code changes allowed) | Red | Opus | Already Opus -- no code changes permitted |
| Code exploration (target location unknown) | Any | Sonnet | Apply Exploration Protocol; escalate to Opus only if architectural complexity found |
| Quick document lookup, single-fact retrieval | Any | Haiku | No escalation |

Rules:

- Default is Sonnet. Escalate to Opus only when the specific escalation condition in the table is met.
- Escalation is per-step, not per-case -- revert to Sonnet once the complex step is resolved.
- Red path: Opus for analysis only -- no agent may generate or apply code changes.
- `haiku` is for retrieval only — never use for code generation or document authoring.

## Exploration Protocol

Apply when the request involves locating code whose file, class, or module is not specified.

**Step 0 — Pre-exploration clarification** (trigger: target location is not specified):

Ask the user up to 3 of the following questions — only those that apply:
- "Do you know the file, class, or method name?"
- "Which service or module is this in?"
- "Is there a related file you've already seen that I can start from?"

Skip Step 0 if: user already provided a file name, class name, pasted code, or an explicit path.

Outcomes:
- User gives a specific answer → Read / Grep directly, skip Steps 1–3
- User gives a vague direction (e.g., "probably in billing") → use it to narrow the Grep scope in Step 2
- User says "I don't know" → proceed to Step 1

**Step 1 — Check CLAUDE.md Repository Structure:**
- Module is listed → targeted Read on that path, stop
- Not listed → proceed to Step 2

**Step 2 — Grep (up to 3 rounds):**
- Round 1: class name / method name / annotation
- Round 2: package name / interface name / constant
- Round 3: broader keyword
- Hit at any round → Read matched file, stop
- All 3 rounds exhausted without hit → proceed to Step 3

**Step 3 — Stop and ask again:**
- Do not continue searching
- Do not invoke Explore Agent
- Ask the user for the file location or a narrower hint

**Explore Agent gate** — all four conditions must be true:
1. Steps 0–3 completed without result
2. Execution mode is Mode 3
3. CLAUDE.md has no Repository Structure documented
4. Decision is logged in Abnormal Cost Review with reason and estimated token cost

## SubAgent Requirements

When using the Agent tool:

1. Pass `model=` explicitly per the Model Selection table above.
2. Instruct every subAgent to append the following line to its final output:
   ```
   Token usage: input=<n>, output=<n>, total=<n>
   ```
3. Collect all `Token usage:` lines from subAgent outputs and sum them into the Stage-Level table of `Token_Usage_Report.md`.
4. If a subAgent did not report token usage, note `subAgent tokens not included` in the Memory/Sub Agent column.
5. Use `templates/SubAgent_Token_Report.md` to track each group's input scope, deliverables, and token detail.

## Output

- Case ID
- Output path
- Generated / updated documents
- Open questions
- Risk level
- Recommended next decision
