# Case Study: BizDB — LL-only Mode vs Multi-SubAgent Mode Token Comparison

> Source: `examples/token-usage/BizDB_Token_Usage_Report_Second_1th_V3.0.md` (V3.0) and `examples/token-usage/BizDB_Token_Usage_Report_Second_2th_V4.0.md` (V4.0)
> Project: bus-freightlist-handler-service / FREIGHTLIST team
> Task: IC_TRANS_FINAL chain batch deduplication

---

## Summary

Two runs of the same feature area under different execution modes show a **2.3x token reduction** when switching from Mode 3 (multi-SubAgent) to Mode 1 (LL-only), at identical pass rate.

| Version | Mode | Token | Cost | Retry | SubAgents | Result |
|---|---|---|---|---|---|---|
| V3.0 (second_1th) | Mode 3 — 7 SubAgents | 400,254 (est.) | $5.49 | 2 | 7 | Pass |
| V4.0 (second_2th) | Mode 1 — LL-only | 171,725 | $0.89 | 0 | 0 (2 Explore deviations) | Pass |

---

## Why the Gap

### V3.0: Mode 3 costs

- 7 subAgents dispatched across Scenario Analysis, Code Implementation, Test Generation, and Verification
- Main Claude orchestration overhead: ~38K tokens (pre-merge) + ~50K tokens (post-merge rework)
- 2 Self-Fix rounds after merge exposed Mockito strict mode issues (UnnecessaryStubbingException) and compile errors — root cause: QA subAgent ran in a separate worktree without build toolchain
- Retry cost: ~50K tokens ($1.05) entirely in post-merge rework

### V4.0: Mode 1 savings

- Grep / Read / Glob only — no subAgent dispatch
- Single-service change (+12 lines), clear input/output, no cross-module exploration required
- Retry = 0: no rework stage
- **Residual inefficiency**: Explore Agent invoked twice during Scenario Analysis (56,325 tokens) — Mode 1 rule violation. These tokens were counted honestly. Without this deviation, total would have been ~115K tokens.

---

## Lessons

| Lesson | Rule Derived |
|---|---|
| Task size determines mode — not team preference | Before any case: map task against Mode 1/2/3 criteria in `skills/feature-dev/SKILL.md` |
| Explore Agent in Mode 1 is a governance violation | Mode 1 rule: Grep/Read/Glob only. Explore Agent usage triggers Abnormal Cost Review |
| Post-merge rework is the most expensive Retry type | Mock strategy must be defined in Test.md before implementation; worktree build compatibility verified in Solution.md |
| Main Claude orchestration is real cost | Always estimate pre-merge and post-merge main Claude tokens separately |

---

## Token Distribution Comparison

| Stage | V3.0 Token | V3.0 % | V4.0 Token | V4.0 % |
|---|---:|---:|---:|---:|
| Scenario Analysis | 62,451 | 15.6% | 60,825 | 35.4% |
| Solution Design | 19,580 | 4.9% | 25,000 | 14.6% |
| Code Implementation | 49,003 | 12.2% | 35,000 | 20.4% |
| Test Generation | 109,096 | 27.3% | 20,000 | 11.6% |
| Verification | 72,124 | 18.0% | 30,900 | 18.0% |
| Rework / Retry | 50,000 | 12.5% | 0 | 0% |
| Main Claude orchestration | 38,000 | 9.5% | — | — |

V4.0 Scenario Analysis at 35.4% is inflated by the Explore Agent deviation (56,325 tokens). Corrected, it would be ~6% — consistent with Mode 1 targets.
