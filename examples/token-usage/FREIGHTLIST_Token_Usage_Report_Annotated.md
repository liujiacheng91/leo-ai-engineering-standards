# FREIGHTLIST Token Usage Report — Annotated Reader Guide

> This document shows how to read and interpret a `Token_Usage_Report.md`.
> Base example: BizDB V4.0 (second_2th), LL-only mode — `bus-freightlist-handler-service / FREIGHTLIST team`
> For the original report see: `BizDB_Token_Usage_Report_Second_2th_V4.0.md`

---

## How to Read This Document

Each section of a `Token_Usage_Report.md` answers a different question:

| Section | Question it answers |
|---|---|
| Task-Level | What was the total cost and outcome of this case? |
| Stage-Level | Where did the tokens go — was any stage disproportionate? |
| Abnormal Cost Review | Were any thresholds breached, and what was done? |

---

## Section 1: Task-Level Token Usage

```
| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count | Memory/Sub Agent | Saved Hours | Result | Reusable |
| ic-trans-offset-skip | bus-freightlist-handler-service | FREIGHTLIST | Yellow | Sonnet | 140,820 | 30,905 | 171,725 | $0.89 | 0 | No subagent (LL-only mode) | 1.5 | Pass | Yes |
```

**Field by field:**

- **Risk**: plain text only — `Green` / `Yellow` / `Red`. No emoji prefix. Yellow means human review required before merge.
- **Model**: canonical name — `Sonnet`, `Opus`, `Haiku`, or `Sonnet + Opus`. No version numbers attached.
- **Total Token**: Input + Output across main Claude and all subAgents. If subAgent tokens were not self-reported, mark `(estimated)` and note `subAgent tokens not included` in the Memory/Sub Agent cell.
- **Retry Count**: number of self-correction loops. `0` = clean run. `2` = Near Threshold (flag the cell). `3+` = Abnormal Cost Review required.
- **Memory/Sub Agent**: LL-only mode means no subAgents dispatched. If Explore Agent was accidentally invoked, note the deviation here — tokens already counted in Stage-Level.
- **Reusable**: Yes if any artifact from this case (test class, pattern, template rule) applies to future cases.

**Deviation recorded in this example**: The original report notes "⚠️ 误用 Explore Agent×2 (45,800+10,525)". These 56,325 tokens were counted honestly and are visible in Scenario Analysis at 35.4%. This is the correct approach — never adjust token counts retroactively to hide deviations.

---

## Section 2: Stage-Level Token Usage

```
| Stage               | Model  | Token  | Cost  | Pct   | Notes                                              |
| Scenario Analysis   | Sonnet | 60,825 | $0.24 | 35.4% | ⚠️ Explore Agent×2 (45,800+10,525); use Grep/Read |
| Solution Design     | Sonnet | 25,000 | $0.18 | 14.6% | (estimated)                                        |
| Code Implementation | Sonnet | 35,000 | $0.19 | 20.4% | (estimated)                                        |
| Test Generation     | Sonnet | 20,000 | $0.13 | 11.6% | (estimated)                                        |
| Verification        | Sonnet | 30,900 | $0.15 | 18.0% | (estimated)                                        |
| Rework / Retry      | —      | 0      | $0.00 | 0%    | No retries                                         |
```

**What to check:**

1. **Stage sum vs Task-Level total**: 60,825 + 25,000 + 35,000 + 20,000 + 30,900 = 171,725 — matches exactly. A gap >10% must be explained in Abnormal Cost Review.
2. **Any stage >40%**: triggers an Abnormal Cost Review row. Scenario Analysis at 35.4% is below threshold — but only because of the Explore deviation. Without it (~4,500 tokens for equivalent Grep/Read), Scenario Analysis would be ~2.6%.
3. **`(estimated)` labels**: acceptable when main Claude tokens are unavailable from the UI. Always label; never leave unmarked.
4. **Rework / Retry = 0**: compare to V3.0 of this same task where Rework = 50,000 tokens ($1.05). The difference: V3.0 had no Mock Strategy defined upfront; V4.0 had Retry = 0.

**Token hotspot in this example:**

Scenario Analysis at 35.4% (60,825 tokens). Investigation: two Explore Agent calls = 56,325 tokens wasted. This is 33% of the entire case cost and triggered the V4.1 Abnormal Cost Review rule: "Explore Agent used when Grep/Read/Glob would suffice → record token count wasted."

---

## Section 3: Abnormal Cost Review

```
| Case | Reason                                                       | Action              |
| —    | Retry=0 / max stage 35.4%<40% / no Opus / Total 172K<500K   | No action required  |
```

**How to read:**

- A single "未触发" row means all thresholds were checked and none were breached.
- Each row that IS triggered must state: which threshold, why it happened, and what action was taken or why no action is needed.
- "No action required" is valid only when the cause is fully explained.

**V4.1 additional checks** (apply to all new reports):
- Opus used in Code Implementation? → Record why Sonnet was insufficient
- Explore Agent in Mode 1? → Record token count wasted
- Retry = 2? → Add `Near Threshold` annotation to the Retry Count cell

---

## Common Mistakes When Writing Token Reports

| Mistake | Correct Form |
|---|---|
| `🟡 Yellow` in Risk field | `Yellow` |
| `claude-sonnet-4-6` in Model field | `Sonnet` |
| Total Token left blank | `(estimated)` with a note |
| Stage sum differs from Task-Level total by >10% | Explain the gap in Abnormal Cost Review |
| SubAgent executed but no token count returned | `subAgent tokens not included` in Memory/Sub Agent + Abnormal Cost Review row `subAgent tokens not reconciled` |
| Retry = 2 with no annotation | Add `Near Threshold` to the Retry Count cell |
