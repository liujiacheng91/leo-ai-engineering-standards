# AI Token Cost Standard

## Required Metrics

| Field | Format | Description |
|---|---|---|
| Task | text | Short task description |
| Project | text | Project name from CLAUDE.md |
| Team | text | Team name |
| Risk Level | Green / Yellow / Red | From AI_Risk_Level.md |
| Model | text | All models used, e.g. `Sonnet`, `Sonnet + Opus` |
| Input Token | integer | Total input tokens across main agent and all subAgents |
| Output Token | integer | Total output tokens across main agent and all subAgents |
| Total Token | integer | Input Token + Output Token |
| Cost | decimal (USD) | See Cost Calculation below |
| Retry Count | integer | Number of self-correction retries in this case |
| Memory / Sub Agent usage | text | `No` / `Yes - <n> subAgents, total=<X>` / `Yes - subAgent tokens not included` |
| Saved Hours | decimal | Estimated human hours saved. See Saved Hours Calculation section for formula. |
| Result | Pass / Partial / Fail | Overall case result |
| Reusable | Yes / No | Whether artifacts can be reused in future cases |

## Cost Calculation

```
Cost (USD) = (Input Token / 1,000,000) × Input Price
           + (Output Token / 1,000,000) × Output Price
```

Reference prices (update when Anthropic adjusts pricing):

| Model | Input (USD/M tokens) | Output (USD/M tokens) |
|---|---|---|
| Claude Haiku | 0.80 | 4.00 |
| Claude Sonnet | 3.00 | 15.00 |
| Claude Opus | 15.00 | 75.00 |

If internal cost tracking uses a different unit, record the unit in the Cost column header (e.g., `Cost (RMB)`).

## Model Selection Rules

- Sonnet is the default model for all development tasks.
- Opus is required for: complex solution design (3+ components), complex test strategy, difficult verification blocked after 2 retries, Red-path analysis.
- Haiku is for retrieval only — never for code generation or document authoring.
- Red path: Opus for analysis only; no model may generate or apply code changes.

## Model Naming Standard

Model field must use the following canonical names. Do not attach version numbers.

| Canonical Name | Meaning |
|---|---|
| `Sonnet` | Claude Sonnet (any version) |
| `Opus` | Claude Opus (any version) |
| `Haiku` | Claude Haiku (any version) |

Multiple models: join with ` + `, e.g. `Sonnet + Opus`.

Risk field must use plain text only: `Green` / `Yellow` / `Red`. Do not use emoji prefixes.

## Abnormal Cost Review Triggers

Add a row to the Abnormal Cost Review table when any of the following occur:

- Retry Count = 2: annotate Retry Count cell with `Near Threshold` (not a full review row, but a warning)
- Retry Count ≥ 3 in a single case
- Any single workflow stage consumes > 40% of total tokens
- Opus is used on a Green-risk task
- Opus is used on a Yellow-risk task → record why Sonnet was insufficient
- Opus is used in the Code Implementation stage on any risk level → record why Sonnet was insufficient
- Explore Agent used when Grep / Read / Glob would suffice (LL-only mode deviation) → record token count wasted
- Total Token > 500,000 for a single case

## Runtime Mode

CLAUDE.md is the **primary and mandatory** runtime mode for all LL AI cases.

Rules-in-Prompt (pasting behavior rules directly into the chat) is permitted only as a fallback when the project has not yet configured CLAUDE.md.

Benchmark evidence (3 identical coding challenges, same 3/3 pass rate):

| Runtime Mode | Total Cost | vs Baseline |
|---|---|---|
| Rules pasted in chat per session | $1.318 | +41% |
| **CLAUDE.md (mandatory default)** | **$0.935** | baseline |

Conclusion: CLAUDE.md reduces per-session cost ~30% at identical output quality. Always configure it before starting AI cases.

## Saved Hours Calculation

```
Saved Hours = Manual Estimate - AI-Assisted Actual Time
```

- **Manual Estimate**: time a developer would independently complete equivalent work, including code reading + design + implementation + testing + documentation.
- **AI-Assisted Actual Time**: actual user time invested, including prompt writing + review + decision-point waiting.

Note: pure machine execution time (SubAgent runs, `gradle test`, CI pipeline) does not count toward AI-Assisted Actual Time.

## Token Optimization Tips

- Prefer editing existing files over full rewrites — rewrites consume significantly more output tokens.
- Do not re-read files already read in the same session unless the file may have changed.
- Skip files over 100KB unless specifically required.
- For files over 1,000 lines: read a targeted section or summary first — never load entire file unless all content is needed.
- Never guess API signatures, library versions, or CLI flags — verify by reading code or docs before asserting.
- Return only what was requested. Unrequested extras cost tokens and increase review effort.

## Rules

- 同一问题失败 3 次必须停止。
- 大型代码库用 MD 索引减少重复扫描。
- SubAgent tokens must be aggregated into the total; do not report only the main agent's usage.
- Never leave token fields blank — use `(estimated)` or `N/A - <reason>` when actual data is unavailable.
