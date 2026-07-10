# AI_Case_Card.md

## Basic Info

- Case ID: 20260519_FREIGHTLIST_node5-calc-gp
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Scenario: Node5ProfitShare calcGp calculation logic
- Risk Level: Yellow
- AI Tool: Claude Code
- Model: Opus
- Owner: Liangwb

## Outcome

- Original Estimate: 2.5 hours (manual: read existing patterns + understand calcFlGpByStation/isStationsEqual + implement + review + document)
- Actual Time: 0.5 hours (user: prompt + review + merge decision)
- Saved Hours: 2.0
- Token Cost: $4.50 (estimated)
- Result: Pass
- Reusable: Yes (calcGp pattern can reference for similar AgentType-based GP assignment)

## Quality Metrics

| Metric | Value | Notes |
|---|---|---|
| Retry Count | 0 | Code compiled on first attempt, no self-fix |
| Retry Root Cause | N/A | Retry = 0 |
| RA Quality | Normal | No TA review in path B; Scenario.md covered all 4 ACs |
| RA Deviation Root Cause | N/A | No deviation |

## Related Cases

| Relationship | Case ID | Notes |
|---|---|---|
| depends-on | (none) | calcFlGpByStation / isStationsEqual / getMaxGpStation implemented in prior session |
| follow-up | (none) | ThirdParty field remains skipped, consistent with calcProfitShareDistribution/calcSweep |

## Human Intervention

| Point | Reason | Decision | Owner |
|---|---|---|---|
| Merge Decision | Yellow risk, worktree unit test not executed | User chose "merge to develop_1.1.0" | Liangwb |

## Lessons Learned

- What worked: Reusing existing calcFlGpByStation/isStationsEqual/judgeSale/sumBigDecimal avoided duplicating AR/AP logic; referencing calcProfitShareDistribution pattern kept implementation consistent
- What failed: N/A (zero retries)
- What to improve: Track B (worktree JGit incompatibility) remains unresolved; unit tests only runnable post-merge
