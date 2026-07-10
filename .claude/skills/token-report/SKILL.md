---
name: token-report
description: Generate or update Token_Usage_Report.md at the end of each AI case. Records model, token counts, cost, retry count, memory/sub-agent usage, saved hours, result, and reusability. Flags abnormal costs.
---

# Token Report Skill

## When to Trigger

Run this skill at the end of every AI case, as the final step after generating `AI_Case_Card.md`.

## Steps

1. **Locate or create** `Token_Usage_Report.md` under `docs/ai/cases/<case-id>/`.
2. **Collect token data** using this priority order:
   - First: values provided by the user from the Claude Code session UI.
   - Second: lines reported by subAgents in their outputs, in the format below — sum all subAgent totals:
     ```
     Token usage: input=<n>, output=<n>, total=<n>
     ```
   - Fallback: estimate from conversation context and mark each estimated value as `(estimated)`.

   **Main Claude orchestration token estimation** (when UI data is unavailable):

   Pre-merge orchestration estimate:
   - Read / Glob / Grep calls × avg 3,000 tokens (input)
   - \+ document writes × avg 2,000 tokens (output)
   - \+ SubAgent dispatch prompts × SubAgent count × 500 tokens (output)

   Post-merge rework estimate (if any):
   - Each Self-Fix round ≈ 25,000 tokens (input 20K + output 5K)

   Mark estimated orchestration values in the Notes column as `(estimated, orchestration overhead)`.
3. **Fill Task-Level row** with all required fields:
   - `Task`: short task description
   - `Project`: project name from CLAUDE.md
   - `Team`: team name
   - `Risk`: Green / Yellow / Red
   - `Model`: all model(s) used across main agent and subAgents (e.g., `Sonnet + Opus`)
   - `Input Token` / `Output Token` / `Total Token`: aggregated across main agent and all subAgents
   - `Cost`: calculated cost (USD or internal unit)
   - `Retry Count`: number of self-correction retries in this case
   - `Memory/Sub Agent`: `Yes - <n> subAgents, total=<X>` or `No`; if subAgent tokens unavailable, write `Yes - subAgent tokens not included`
   - `Saved Hours`: estimated human hours saved. Use these reference points for calibration:

     | Change Scope | Saved Hours Range |
     |---|---|
     | One-line fix / single-field setter | 0.25-0.5h |
     | 2-5 field completion / simple condition change | 0.5-1.0h |
     | Multi-method logic / framework setup | 1.0-2.5h |
     | Full feature (Entity + Mapper + Service + Test) | 2.0-4.0h |
     | Large EDI mapping (100+ fields) | 8-16h |

     If the estimated Saved Hours exceeds the upper bound for its change scope, add a note explaining why (e.g., complex domain knowledge, extensive cross-file reading)
   - `Result`: Pass / Partial / Fail
   - `Reusable`: Yes / No — whether artifacts (templates, scripts) can be reused
4. **Fill Stage-Level rows** for each workflow stage with model used, token count, cost, and percentage of total.
5. **Validate Token consistency** before writing:
   - Stage-Level sum must equal Task-Level Total Token ± 10% (accepted orchestration overhead).
   - If the gap exceeds 10%: add a note in Abnormal Cost Review explaining the discrepancy (e.g., main agent orchestration overhead not captured in stage breakdown).
   - If any subAgent reported `Token usage:` but the total was not included in Stage-Level: add a row to Abnormal Cost Review marked `subAgent tokens not reconciled`.
6. **Check for abnormal costs**:
   - Retry Count ≥ 3 → add a row to Abnormal Cost Review
   - Retry Count = 2 → add a note `Near Threshold` in the Retry Count cell
   - Any single stage > 40% of total tokens → add a row to Abnormal Cost Review
   - Opus used on a Green task → add a row to Abnormal Cost Review
   - Opus used on a Yellow task → add a row to Abnormal Cost Review with reason why Sonnet was insufficient
   - Opus used in Code Implementation stage (any risk level) → add a row to Abnormal Cost Review with reason why Sonnet was insufficient
   - Explore Agent used when Grep / Read / Glob would have sufficed (Mode 1 deviation) → add a row with estimated token waste

   **Retry root-cause classification**: when Retry Count > 0, annotate the Retry Count cell with the root cause category:
   - `[Logic]`: code logic error — preventable by improving Solution.md or Test.md
   - `[Toolchain]`: toolchain limitation — worktree JGit incompatibility, CI environment difference; address in a separate case
   - `[Assumption]`: unverified assumption — field name / API version / Java level not verified before coding (Hard Enforcement Layer not executed)
7. **Fill Cost Efficiency** section:
   - `Cost / Saved Hours` = Total Cost / Saved Hours (USD per saved hour). Lower is better.
   - `Token / Saved Hours` = Total Token / Saved Hours.
   - Reference benchmarks: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr, FREIGHTLIST batch $2.44/hr.
8. **Cross-check**: verify AI_Case_Card.md Token Cost matches Token_Usage_Report total. If different, add a row to Abnormal Cost Review explaining the discrepancy.
9. **Sanity check** estimated totals against expected ranges:

   | Case Type | Expected Total | Expected Cost (Sonnet) |
   |---|---|---|
   | Green one-line fix | 30-50K | $0.15-$0.25 |
   | Green Minimal Path (single-file, <50 lines) | 20-40K | $0.10-$0.20 |
   | Single-field Yellow | 60-90K | $0.30-$0.45 |
   | Multi-field Yellow | 100-140K | $0.50-$0.70 |
   | Framework / calculation Yellow | 150-220K | $0.75-$1.10 |
   | EDI mapping (Mode 2) | 150-250K | $0.75-$1.25 |
   | Large feature (Mode 3) | 250-500K | $4.00-$8.00 |

   If the estimated total is more than 50% above the expected range, add a note in Abnormal Cost Review.

10. **Save** the file. Do not modify any other case documents.

## Rules

- Follow field definitions in `references/AI_Token_Cost_Standard.md`.
- Use the template at `references/Token_Usage_Report.md` as structure reference.
- Never leave token fields blank -- use `(estimated)` or `N/A - <reason>` when actual data is unavailable.
- SubAgent tokens must be aggregated into the total; do not report only the main agent's usage.
