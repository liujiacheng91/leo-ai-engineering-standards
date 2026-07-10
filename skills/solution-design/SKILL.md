---
name: solution-design
description: Generate Solution.md with impact analysis, security considerations, test strategy and rollback plan.
---

# Solution Design Skill

Generate `Solution.md` under the standard case folder. Keep business rules separate from technical solution.

## Risk-Level Gating

- **Green**: generate full Solution.md, proceed to Task.md after completion.
- **Yellow**: generate full Solution.md, then **stop and wait** for `## Human Approval` to be signed before proceeding to Task.md / Test.md (GOVERNANCE Rule 6).
- **Red**: generate Scenario.md + AI_Risk_Level.md + Solution.md (analysis section only). Do not generate Impact Analysis, Recommended Solution, or Test Strategy. Do not proceed to Task.md.

## Mandatory: Fill Technical Constraints Before Writing

The `## Technical Constraints` table in `Solution.md` must be completed before any other section. This is a Stop Condition -- do not proceed to Impact Analysis or Recommended Solution without it.

| Constraint | How to Verify |
|---|---|
| Java language level / compile target | Read `sourceCompatibility` in `build.gradle` |
| Key entity field names referenced in this change | Read target entity class source |
| Available utility methods (JDK / framework version) | Read dependency versions in `build.gradle` |
| Mockito strictness setting | Read existing test classes or `build.gradle` |
| Worktree build feasibility | Run `gradle compileJava` |

These checks prevent the most common Retry causes: unverified field names, Java version assumption errors (e.g., `String.repeat()` unavailable), and deferred test discovery.

### Pre-verified Environment Shortcut

If `CLAUDE.md ## Technical Environment (Pre-verified)` is filled, use those values directly for Java version, build tool, worktree support, test framework, and Mockito strictness. Write "Confirmed from CLAUDE.md" in the conclusion column. Do not re-run `java -version`, `gradle -version`, or attempt a worktree build for values already declared.

Still verify per-case constraints (entity field names, utility methods, cross-module dependencies) by reading source code -- these are case-specific and cannot be pre-declared.

## Conditional Sections

Only generate Solution.md sections that have substantive content. If a section would contain only "None", "N/A", or "No changes", omit the section header entirely. Always generate: Solution Overview, Technical Constraints, Recommended Solution, Human Approval. Conditionally generate: Impact Analysis subsections, Security Considerations, Test Strategy, Rollback Plan.

## Track B Declaration

If worktree build is not feasible (JGit / `net.nemerosa.versioning` plugin throws `NoHeadException` on worktree `.git` file pointers):

1. Fill the `## Post-Merge Test Plan` subsection inside Technical Constraints: command + owner + timing
2. This declaration unlocks Track B verification mode in `skills/verification/SKILL.md`
3. Without this declaration, worktree build failure counts as a Retry

See `standards/AI_Verification_Standard.md` Worktree Build Limitation Exemption for the full 4-condition gate.
