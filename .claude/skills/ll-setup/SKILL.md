---
name: ll-setup
description: Initialize a project for LL AI Engineering Standards. Creates project CLAUDE.md and case output directory.
---

# LL Project Setup Skill

Initialize the current project for LL AI-assisted SDLC.

## What this skill does

1. Creates `CLAUDE.md` at project root with Section 1 (Project Context) for you to fill in
2. Creates `docs/ai/cases/` directory for case output
3. Prints a Quick Start guide

## When to use

- First time setting up a project with LL standards
- When the ll-standards plugin is installed but the project has no CLAUDE.md yet

## Rules

- If `CLAUDE.md` already exists, do NOT overwrite it. Ask the user if they want to back up and recreate.
- The created `CLAUDE.md` contains only Section 1 (Project Context) and a reference to the plugin rules. The full behavior rules are auto-loaded from the plugin's CLAUDE.md -- do not duplicate them in the project file.
- After creating the files, remind the user to edit Section 1 with their project info.

## Project CLAUDE.md Template

Create with this content:

```markdown
# CLAUDE.md

## 1. Project Context

### Project Name

[Fill in project name]

### Business Context

[Brief description of project business context]

### Technical Stack

- Backend:
- Frontend:
- Database:
- CI/CD:
- Testing:

### Repository Structure

[Fill in main directory structure]

---

## 2. LL AI Engineering Standards

This project uses LL AI Engineering Standards for AI-assisted development governance.

Full rules are loaded from the ll-standards plugin (or .claude/ll-rules.md in fallback mode).
```

## Output

After setup, display:

```
Project initialized for LL AI Engineering Standards.

Next steps:
  1. Edit CLAUDE.md Section 1 with your project info
  2. Start: /ll-dev
  3. Or use individual skills: /scenario-analysis, /test-design, /verification
```
