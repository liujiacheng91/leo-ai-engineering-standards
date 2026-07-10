# Case Study: EDI — Sonnet-only Completes Mapping-Intensive Yellow Case

> Source: `examples/token-usage/EDI_Token_Usage_Report_V4.0.md`
> Case ID: 20260513_dyson_online-air-billing-send
> Project: Dyson Online Air Billing Send (MSG110 X12)
> Risk: Yellow

---

## Summary

A mapping-intensive Yellow case with 40+ EDI X12 fields, 5 new files, and 17 unit tests was completed by Sonnet alone at $0.51 with 2 self-fixes. Opus was not required.

| Metric | Value |
|---|---|
| Model | Sonnet only |
| Total Tokens | ~67,500 (est.) |
| Total Cost | $0.51 |
| Self-Fix Count | 2 / 3 |
| Unit Tests | 17 / 17 passed |
| Saved Hours | ~7.7 h |
| Result | Pass |

---

## What Was Built

- `DysonAirBillingInput` / `DysonAirBillingDetail` model classes
- `DysonOnlineAirBillingSendProcess` entry class
- `DysonOnlineAirBillingSendProcessImpl` (~360 lines) with ISA/GS/B3/N1/LX/L3 segment mapping
- 17 unit tests with `ArgumentCaptor` / `RETURNS_DEEP_STUBS` / reflection patterns

---

## Self-Fix Analysis

| Fix # | Symptom | Root Cause | Prevention Rule |
|---|---|---|---|
| Fix #1 | `spring-test` import not found | `spring-test` classpath not pre-validated before test generation | Add classpath check to Solution.md Technical Context before Test.md generation |
| Fix #2 | `anyInt()` matcher type mismatch | Mockito primitive parameter handling not pre-declared; used `any()` on `int` param | Add to Test.md Mock Strategy: "primitive params → anyInt()/anyLong(), never any()" |

Both fixes were predictable and preventable with upfront Mock Strategy definition.

---

## Stage Token Distribution

| Stage | Tokens | % | Notes |
|---|---:|---:|---|
| Scenario Analysis | 6,500 | 10% | |
| Solution Design | 10,000 | 15% | |
| Code Implementation | 37,700 | 56% | ⚠️ >40% — Abnormal Cost Review required |
| Verification | 8,300 | 12% | 2 self-fixes included |
| Documentation | 5,000 | 7% | |

Code Implementation at 56% was flagged. Root cause: 40+ field mapping with repeated context reads. Mitigation: pre-populate `Mapping_Rules.md` before implementation to avoid model re-inferring field mappings at generation time.

---

## Lessons

| Lesson | Rule Derived |
|---|---|
| Sonnet completes Yellow mapping cases without Opus | Default to Sonnet; escalate only on 2+ consecutive blocked retries |
| 40+ fields without Mapping_Rules.md inflates Code Impl token share | Mode 2 rule: pre-populate Mapping_Rules.md and Business_Rules.md before any implementation step |
| Mockito primitive traps repeat across cases | Add `anyInt()` rule to Test.md Mock Strategy as mandatory pre-read before test generation |
| Fix #1 and #2 were both foreseeable | Solution.md Technical Context must include classpath dependencies and Mockito strictness decision |

---

## Reusable Assets

| Asset | Reusable By |
|---|---|
| `buildMsg110X12` segment builder skeleton | Other MSG110 customers — parameterize ISA/GS values |
| `captureEdi` + `parseSegment` test utilities | All X12 EDI test classes |
| `anyInt()` Mockito fix pattern | All service-layer tests with primitive parameters |
