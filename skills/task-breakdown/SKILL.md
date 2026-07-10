---
name: task-breakdown
description: Generate Task.md and Test.md from approved solution.
---

# Task Breakdown Skill

Break approved Solution.md into executable tasks with function-level design, file assignments, and done criteria.

## Required Input

- Approved `Solution.md` (for Yellow cases: `## Human Approval` must be signed)
- `Scenario.md` (for AC reference)
- `AI_Risk_Level.md` (for risk-level gating)

## Stop Conditions

- Solution.md not yet created → stop, run solution-design first
- Yellow case and Solution.md `## Human Approval` not signed → stop, wait for human confirmation
- Red case → stop, Task.md generation is not permitted for Red path

## Output

Generate `Task.md` under the standard case folder with the following structure:

1. **Task Table**: one row per task, each with ID, description, input, output, affected files, done criteria, related AC
2. **Dependency Order**: execution sequence (which tasks must complete before others)
3. **Estimation**: token budget estimate per task (based on file count and complexity)

## Rules

- Each task must trace back to at least one AC in Scenario.md
- Each task must list specific files to create or modify — no vague descriptions like "update the service layer"
- Done criteria must be verifiable (compile, test pass, specific output) — not "code looks correct"
- If the Solution.md Technical Constraints declared a worktree build limitation, note which tasks require post-merge verification
- Task granularity: one task per logical unit of change (e.g., one entity + its mapper + its service = one task, not three)
