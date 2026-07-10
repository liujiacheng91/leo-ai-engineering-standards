---
name: verification
description: Generate Verify.md with evidence for build tests lint coverage scans UAT logs and data comparison.
---

# Verification Skill

Generate `Verify.md`. Do not claim success without evidence. If cannot run a check, explain why. Self-fix maximum 3 attempts.

## Verification Protocol

Choose the track based on worktree build availability.

### Track A — Pre-merge (worktree build available)

1. `gradle compileJava` / `bootJar`
2. `gradle test`
3. Static code assertion + AC trace

### Track B — Pre-merge build unavailable (worktree limitation)

Use Track B only when `Solution.md Technical Constraints` explicitly declares the worktree build limitation with a post-merge test plan. If not declared, Track A is mandatory.

1. Static code assertion + AC trace (required)
2. TA code-review (required)
3. Fill `## Post-Merge Test Plan` in `Verify.md`: command + owner + timing (required — cannot merge without this)
4. Post-merge: run `gradle test`, backfill result into `## Post-Merge Test Results` in `Verify.md`

Track B worktree build failure does not count as a Retry. Record root cause as `[Toolchain]` in Abnormal Cost Review.

## Output Format

Structure `Verify.md` in this order:

1. **Summary** (3 bullets max): what was verified, overall result, any blockers.
2. **Evidence**: test output, lint results, coverage data, scan logs, comparison tables.
3. **Caveats**: checks that could not be run and why.

Rules:

- Lead with the result. Context and methodology after.
- Numbers must include units (e.g., `coverage: 87%`, not `87`).
- Never state a check passed without reproducible evidence.
- Distinguish between what was observed and what is inferred — label inferences explicitly.
- If cause of failure is unclear: say so. Do not guess.
- After every Self-Fix: append a row to the Fix History table in `Test.md` recording symptom, root cause, fix action, and prevention rule; then immediately apply the prevention rule to the target file before proceeding. If the target file has a reference copy under `skills/*/references/`, sync that copy too (GOVERNANCE Rule 17). For detailed standalone root cause analysis, use `templates/QA_Retry_Root_Cause.md`.

## Conditional Sections

Only include Test Results rows for checks that were actually executed or are required by the risk level. Omit rows that would be "Not Run" with standard explanations. Required rows for all cases: Build, Unit Test, Type Check, Secrets Scan. Include other rows (Integration Test, Lint, Coverage, Security Scan, UAT, Log Analysis, Data Comparison) only when they were executed or when their absence requires a non-obvious explanation.

## Completeness Checks

Before writing the Final Status in Verify.md, perform these three checks:

1. **AC completeness**: every AC ID from Scenario.md must have a row in the Acceptance Criteria Mapping table. Empty rows are not allowed -- fill with evidence or explicitly state why verification was not possible.
2. **Test Results completeness**: any "Not Run" item in the Test Results table must have an explanation in the "Evidence / Notes" column (e.g., "worktree limitation -- see Post-Merge Test Plan"). Unexplained "Not Run" blocks the Final Status from being set to "Ready for Merge".
3. **Track B closure**: if Track B was used, `## Post-Merge Test Results` must not be empty when the case is closed. If post-merge tests have not been executed yet, Final Status must be "Ready for Review" (not "Ready for Merge"). Update to "Ready for Merge" only after backfilling post-merge build and test evidence with commit hash and pass count.
