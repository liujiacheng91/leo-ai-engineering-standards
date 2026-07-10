---
name: ll-standards
description: Load LL engineering standards, naming rules, output path rules and behavior principles.
---

# LL Standards Skill

Use this skill to apply default behavior rules, risk boundaries, naming standards, output path standards, forbidden practices, and verification discipline.

Must follow:

- Think Before Coding
- Simplicity First
- Surgical Changes
- Goal-Driven Execution
- No Risk Level, No AI Execution
- No Verify.md, No Merge
- Standard file names only
- Standard case folder only

## Hard Enforcement Constraints

Apply at every file operation and every response. These are not optional. Full gate definitions: `skills/ll-dev/SKILL.md` Hard Enforcement Layer section.

Summary:

- Before read: skip >100KB; no re-reads; >1,000 lines targeted only
- Before write: read target first; verify all API names/fields/versions from source
- Before response: no sycophantic openers; no emoji/em-dash; no trailing summary; result first

## Model Selection

See `skills/ll-dev/SKILL.md` Model Selection section for the full table and rules. Summary: Sonnet is default. Escalate to Opus only on specific conditions (3+ components, 2 consecutive failures). Haiku for retrieval only.

## Exploration Protocol

See `skills/ll-dev/SKILL.md` Exploration Protocol section. Summary: ask up to 3 narrowing questions before searching; Grep up to 3 rounds; stop and ask if not found.

## Reference Documents

CLAUDE.md behavior template: `templates/CLAUDE.md`
