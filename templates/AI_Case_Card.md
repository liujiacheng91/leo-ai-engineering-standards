# AI_Case_Card.md

## Basic Info

- Case ID:
- Team:
- Project:
- Scenario:
- Risk Level:
- AI Tool:
- Model:
- Owner:

## Outcome

- Original Estimate:
- Actual Time:
- Saved Hours:
- Token Cost:
- Result:
- Reusable: Yes / No -- if Yes, fill Reusable Assets below

## Quality Metrics

| Metric | Value | Notes |
|---|---|---|
| Retry Count | | |
| Retry Root Cause | [Logic] / [Toolchain] / [Assumption] / N/A if Retry = 0 | |
| RA Quality | Normal / Deviation | If Deviation: TA returned > 5 must-fix; record root cause below |
| RA Deviation Root Cause | | Which assumption was unverified / which AC was ambiguous |

## Related Cases

| Relationship | Case ID | Notes |
|---|---|---|
| supersedes | | Case that this one replaces or resolves |
| amends | | Case that this one corrects |
| follow-up | | Known issue left for a future case |
| depends-on | | Case whose output this case builds on |

## Reusable Assets

> Fill when `Reusable: Yes`. Check all dimensions that apply. For each checked dimension, describe what is reusable in the Description column.

| Dimension | Applies | Description |
|---|---|---|
| Code | [ ] | Reusable implementation: utility method, service pattern, mapper template |
| Pattern | [ ] | Reusable design approach: framework structure, field chain, grouping logic |
| Checklist | [ ] | Reusable verification list: P0 test cases, pre-check items, boundary conditions |
| Process | [ ] | Reusable workflow sequence: multi-step flow, session split strategy, closing approach |
| Business Knowledge | [ ] | Reusable domain insight: field source mapping, calculation rule, API behavior |

When registering in `reports/Reusable_Asset_Registry.md`, use the highest-value dimension as the Asset Type.

## Human Intervention

| Point | Reason | Decision | Owner |
|---|---|---|---|

## Lessons Learned

- What worked:
- What failed:
- What to improve:
