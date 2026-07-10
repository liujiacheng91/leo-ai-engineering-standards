# Token Accounting Before / After Comparison

## Background
In v3, token usage analysis focused on case-level totals.
There was no clear separation between orchestration and execution.

## v4.4 Improvements
- Main Claude / Orchestrator token separated
- Sub Agent / Skill token aggregated by phase
- Hotspots and reduction targets identified

## Governance Impact
Token accounting becomes a design-time governance tool rather than a postmortem.

## V4.6 Improvements

Token optimization shifted from accounting structure (V4.4) to consumption reduction:

| Optimization | Mechanism | Saving/Case |
|---|---|---|
| Green Minimal Path | Skip 3 documents for small Green cases | 30-50K |
| Closing single-pass | Consolidate 3 skill invocations to 1 | 15-20K |
| Pre-verified Environment | Declare env once in CLAUDE.md, confirm in Solution.md | 5-10K |
| Session boundaries | Split at Steps 4/7/8 to prevent context accumulation | 10-30% cumulative |
| Conditional sections | Omit empty "None" sections | 1-3K |
| Skill deduplication | ll-standards references ll-dev instead of duplicating | ~400 |
| Token report quick checks | Sanity-check lookup table + cross-check rule | ~5K |

### Benchmark Data (V4.6)

| Case Type | Tokens | Cost | Cost/Hr |
|---|---|---|---|
| LL-only BizDB V4.0 | 172K | $0.89 | $0.06/hr |
| EDI Mapping | 67.5K | $0.51 | $0.07/hr |
| Dyson ocean-310 (Mode 2) | 232K | $1.38 | $0.10/hr |
| VBO Large Feature | 225K | $4.50 | $0.18/hr |
| FREIGHTLIST Batch (21 cases) | 2.096M | $39.88 | $2.44/hr |

### Cost Benchmarks by Case Type (FREIGHTLIST Batch, 21 Cases)

| Case Type | Cases | Total Tokens | Total Cost | Saved Hours | Cost/Hr |
|---|---|---|---|---|---|
| Rule / Trigger Framework | 6 | ~598K | ~$13.27 | 6.75h | $1.97/hr |
| Calculation Logic | 4 | ~503K | ~$9.23 | 4.00h | $2.31/hr |
| Field Completion | 5 | ~470K | ~$7.35 | 2.75h | $2.67/hr |
| Bug Fix | 3 | ~317K | ~$6.23 | 2.20h | $2.83/hr |
| Trigger Control | 2 | ~208K | ~$3.80 | 0.65h | $5.85/hr |

Observations:
- Rule/Trigger Framework has the highest cumulative saved hours and best cost efficiency
- Calculation Logic has the highest per-case value (2h saved, zero retry)
- Trigger Control has the worst cost/hr due to minimal code changes with full documentation flow
- All case types used Opus; switching to Sonnet would reduce cost by 3-5x at same token count

### V4.6 Projected Impact

Low-effort optimizations (1, 2, 5, 6, 7): 25-35K tokens/case = 25-35% reduction.
Green Minimal Path: additional 30-50K/Green case.
Session boundaries: prevents context compaction waste on large cases.

## Conclusion
V4.4 token accounting enables structural, repeatable optimization. V4.6 acts on that structure with 7 targeted consumption reductions.