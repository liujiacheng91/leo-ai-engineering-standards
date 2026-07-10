# V4.5 Iteration Reference

> Full context for V4.5 changes. For quick file-level lookup, see [Iteration_Change_Index.md](Iteration_Change_Index.md).
> For V4.1-V4.4 history, see [Iteration_V41_V44_Reference.md](Iteration_V41_V44_Reference.md).

---

## 1. Plugin Marketplace

### Why

Before V4.5, installation required cloning the repo and running scripts manually. Claude Code has a native plugin system (`claude plugin install`) that handles versioning, distribution, and updates automatically.

### What was built

| File | Purpose |
|---|---|
| `.claude-plugin/plugin.json` | Plugin manifest: name, version, 12 skills |
| `.claude-plugin/marketplace.json` | Self-hosted marketplace `ll-ai-standards` |
| `CLAUDE.md` (repo root) | Behavior rules auto-loaded when plugin is active |
| `ll-rules.md` | Same rules for script-based install (fallback) |
| `skills/ll-setup/SKILL.md` | Project initialization skill |

### Dual Distribution Parity

| Component | Plugin | Script |
|---|---|---|
| Behavior rules | Plugin CLAUDE.md (auto-loaded) | .claude/ll-rules.md (copied) |
| Skills | Plugin skills/ (auto-discovered) | .claude/skills/ (copied) |
| Project CLAUDE.md | /ll-setup creates | install_project creates |
| Upgrade | `claude plugin update` | `upgrade_project.*` |

GOVERNANCE Rule 20 ensures CLAUDE.md and ll-rules.md stay in sync.

---

## 2. Namespace Fix

### Problem

`feature-dev` collided with `feature-dev@claude-plugins-official` (Anthropic's official plugin). Both registered `/feature-dev`, causing unpredictable behavior.

### Solution

Renamed `skills/feature-dev/` to `skills/ll-dev/`. Convention established: use `ll-` prefix for any skill name that could collide with official/third-party plugins.

### Impact

- 18 active files updated (SKILL.md, GOVERNANCE, INSTALL, README, SDLC, scripts, usage docs, skill-compositions, standards)
- 7 historical files preserved as `feature-dev` (CHANGELOG v4.0-v4.4 entries, backlogs, case studies)
- No other skill name collisions found

---

## 3. Cross-skill Consistency Audit

### Method

Read all 12 SKILL.md files and cross-checked: references, workflow alignment, stop conditions, model selection, Fix History pipeline, template ownership, and GOVERNANCE coverage.

### Findings (10 issues, 6 fixed)

| # | Severity | Issue | Status |
|---|---|---|---|
| 1 | Critical | AI_Case_Card.md missing from ll-dev/references/ (owned per Workflow Step 11 but absent) | Fixed |
| 2 | Important | Model name casing: ll-dev used backtick lowercase, ll-standards used capitalized | Fixed -- unified to Sonnet/Opus/Haiku |
| 3 | Important | verification SKILL.md Self-Fix instruction missing GOVERNANCE Rule 17 references/ sync step | Fixed |
| 4 | Important | Document_Naming_Standard in ll-dev is a standards doc, sits outside template ownership model | Acceptable -- ll-dev needs it for naming enforcement |
| 5 | Important | CLAUDE.md reference ownership ambiguous (custom-skill-template vs ll-standards) | Fixed -- moved to ll-standards |
| 6 | Moderate | GOVERNANCE Rule 13 (no Skill mixing) not enforced by any skill | Fixed -- added to ll-dev |
| 7 | Moderate | GOVERNANCE Rule 18 (upgrade script) not referenced by skills | No fix needed -- operational rule |
| 8 | Moderate | GOVERNANCE Rule 19 (no Chinese in scripts) not referenced by skills | No fix needed -- developer rule |
| 9 | Low | GOVERNANCE Rule 20 enforcement only in header comments | No fix needed -- header comments sufficient |
| 10 | Low | ll-standards and ll-setup missing from Skill Naming list | Fixed |

### What was verified as consistent

- Cross-skill references: 13/13 paths resolve correctly
- Workflow table: 12/12 owning skills exist with correct templates
- Stop conditions: 7/7 consistent across all skills and GOVERNANCE
- Fix History atomic pipeline: identical between test-design and verification
- CLAUDE.md and ll-rules.md: Sections 1-8 content-identical

---

## 4. GOVERNANCE Changes

| Rule | Content |
|---|---|
| Rule 20 (new) | CLAUDE.md (plugin) and ll-rules.md (script) must stay in sync; plugin.json version must match VERSION file |

Total: 20 mandatory rules.

---

## 5. End-to-End Audit (v4.5.1)

Full 5-dimension audit after defect fixes (118 checks, all pass):

| Dimension | Checks | Pass |
|---|---|---|
| Standard Flow (SDLC 9 stages) | 18 | 18 |
| Template Application | 38 | 38 |
| Upgrade Strategy | 20 | 20 |
| Governance (20 rules) | 22 | 22 |
| Case Output & Token Output | 20 | 20 |

Defects found and fixed:
- `install_project.sh` line 49: Chinese text removed (Rule 19 violation)
- `install_project.py`: rewritten from V4.3-era structure to V4.5 model (orphan directories eliminated)
- All 3 install scripts (PS1/SH/PY) now produce identical results

---

## 6. Git

| Tag | Content |
|---|---|
| v4.5.0 | Plugin marketplace + ll-dev rename + consistency audit |
| v4.5.1 | Iteration docs + script defect fixes + install parity |

---

## 7. Design Decisions

| Decision | Rationale |
|---|---|
| Plugin + script dual distribution | Plugin for Claude Code users; scripts for CI/non-interactive environments. Both paths produce identical results. |
| ll- prefix convention | Any skill name that could collide with official/third-party plugins gets the ll- prefix. Currently: ll-dev, ll-setup, ll-standards. |
| Plugin CLAUDE.md = ll-rules.md content | Claude Code auto-loads the plugin's CLAUDE.md. Using it for behavior rules eliminates the need for a separate ll-rules.md install in plugin mode. Script mode still uses ll-rules.md. |
| marketplace.json at repo root | The repo itself IS the marketplace. `claude plugin marketplace add <repo>` registers it directly. |
