# Case Study: VBO — Mixed Skill Execution Causes Token Reporting Pollution

> Source: VBO issue version report (referenced in `examples/token-usage/report_analyze_result.md` Section 3.1)
> Project: vbo-plus / VBO team
> Status: Abnormal sample — not a valid V4.0 baseline. For governance reference only.

---

## Summary

A VBO case executed with an unrelated external skill mixed into the standard LL flow. The result: token reporting was incomplete (Group E/F/G showed 0 tokens despite tasks being executed), stage percentages were distorted, and the report cannot be used as a standard performance baseline.

| Metric | Value |
|---|---|
| Total Token (reported) | 50,731 |
| SubAgent total (self-reported) | 40,981 |
| Main Claude orchestration gap | ~9,750 tokens (difference) |
| Groups with 0 token report | Group E, F, G |
| Code Implementation % | 83% — severely distorted |
| Usability as V4.0 baseline | Not usable |

---

## What Went Wrong

### Problem 1: Mixed skill polluted the workflow

An external skill unrelated to the standard LL SDLC was invoked during the case. This caused:
- The flow structure to diverge from the standard `AI_Request → Scenario → ... → Token_Usage_Report` chain
- SubAgent grouping to use non-standard labels (Group A–G)
- Token scope boundaries between stages to become ambiguous

### Problem 2: Group E/F/G reported 0 tokens

Three SubAgent groups (E, F, G) were noted as having processed their tasks, but returned no token breakdown. The report acknowledges this with `subAgent tokens not included` — but the distortion was not flagged in Abnormal Cost Review.

This is the scenario Item 9 addresses: any subAgent group that executed but did not self-report `Token usage:` must trigger an Abnormal Cost Review row marked `subAgent tokens not reconciled`.

### Problem 3: Code Implementation at 83%

Group B (PO entities) alone consumed 32,064 tokens — primarily from reading a 1,246-line reference file in full. Under Mode 3 rules, files >1,000 lines must be summarized before targeted reading. This rule was not applied.

The 83% Code Implementation share was entered into Abnormal Cost Review, but the analysis was limited to Group B; the other groups were not fully explained.

---

## Governance Rules Derived

| Observed Failure | Rule |
|---|---|
| Mixing external skills caused report structure pollution | GOVERNANCE.md Rule 13: no unrelated Skill mixing in a single case |
| Groups E/F/G executed but reported 0 tokens | `skills/token-report/SKILL.md` Step 5: subAgent tokens not reconciled → Abnormal Cost Review |
| 1,246-line reference file read in full | Mode 3 rule: files >1,000 lines must be summarized before targeted reading |
| Stage >40% not fully explained in Abnormal Cost Review | All Stage >40% rows must include specific cause and token breakdown by group |

---

## How to Treat This Report

- Do not use as a V4.0 performance baseline
- Use as an **abnormal sample** to validate governance rules (Items 2, 9, 10)
- The SubAgent partial data (Groups A–D) is still valid for Mode 3 grouping pattern reference
