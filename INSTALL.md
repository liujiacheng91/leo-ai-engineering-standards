# LL AI Engineering Standards -- Install & Upgrade Guide

## Quick Start

### Option A -- Plugin Install (recommended)

```bash
# 1. Add marketplace (one-time)
claude plugin marketplace add <github-org>/ll-ai-engineering-standards

# 2. Install plugin
claude plugin install ll-standards@ll-ai-standards

# 3. Initialize project
/ll-setup

# 4. Edit CLAUDE.md Section 1 with your project info, then:
/ll-dev
```

Plugin install automatically:
- Loads behavior rules (plugin CLAUDE.md) when plugin is active
- Makes all 12 skills available (`/ll-dev`, `/test-design`, etc.)
- No manual file copying needed

### Option B -- Script Install (fallback)

For environments without Claude Code CLI (CI pipelines, non-interactive setups):

**Windows PowerShell:**

```powershell
git clone <repo-url> ll-ai-engineering-standards
cd ll-ai-engineering-standards
.\scripts\install_project.ps1 -Target "C:\path\to\your-project"
```

**Linux / macOS:**

```bash
git clone <repo-url> ll-ai-engineering-standards
cd ll-ai-engineering-standards
chmod +x scripts/*.sh
./scripts/install_project.sh /path/to/your-project
```

Script install creates:

```text
your-project/
├── CLAUDE.md                         <- Project-owned (edit Section 1)
├── .claude/
│   ├── ll-rules.md                  <- Behavior rules (upgrade-managed)
│   ├── ll-standards.version         <- Version stamp
│   └── skills/                       <- All skills (upgrade-managed)
│       ├── ll-dev/              SDLC orchestrator
│       ├── scenario-analysis/        Scenario.md + BA Business Model Input
│       ├── solution-design/          Solution.md + Technical Constraints
│       ├── task-breakdown/           Task.md from approved Solution
│       ├── test-design/              Test.md + API Test + Permission/Security
│       ├── verification/             Verify.md + Track A/B
│       ├── token-report/             Token Report + Cost Efficiency
│       ├── ll-setup/               Project initialization
│       └── ...
└── docs/ai/cases/                    <- Case output directory
```

Edit `CLAUDE.md` Section 1 with your project info, then: `/ll-dev`

For the full AI-assisted SDLC workflow (9 stages), see [SDLC.md](SDLC.md).

---

## Usage Modes

### Mode A -- Full SDLC Flow

```text
/ll-dev
```

Orchestrates the full SDLC: AI_Request -> Scenario -> Risk -> Solution -> Task -> Test -> Implementation -> Verify -> PR -> Case Card -> Token Report.

Token budget: Mode 1 (50-150K) / Mode 2 (80-200K) / Mode 3 (200-500K).

### Mode B -- Single Skill

Use one Skill independently, only loads that Skill's context:

```text
/ll-setup           Initialize project (CLAUDE.md + docs/ai/cases/)
/scenario-analysis   Generate Scenario.md with RA Quality Gate
/solution-design     Generate Solution.md with Technical Constraints
/test-design         Generate Test.md with API Test + Permission Checklist
/verification        Generate Verify.md with Track A/B + Completeness Checks
/token-report        Generate Token_Usage_Report.md with Cost Efficiency
/risk-assessment     Evaluate Green / Yellow / Red risk level
/task-breakdown      Break Solution into executable tasks
/pr-summary          Generate PR summary
/mapping-rules       Generate Mapping_Rules.md / Business_Rules.md
```

### Mode C -- Composition

Combine Skills as needed:

```text
/scenario-analysis -> /test-design -> /verification
```

Each Skill loads only its own context. Total Token = sum of individual Skills.

---

## Version Upgrade

### Plugin upgrade

```bash
claude plugin update ll-standards@ll-ai-standards
```

### Script upgrade (V4.4+)

```powershell
# Windows
cd ll-ai-engineering-standards
git pull
.\scripts\upgrade_project.ps1 -Target "C:\path\to\your-project"
```

```bash
# Linux / macOS
cd ll-ai-engineering-standards
git pull
./scripts/upgrade_project.sh /path/to/your-project
```

**What upgrade replaces (safe):**
- `.claude/ll-rules.md` -- behavior rules
- `.claude/skills/` -- all Skills + references
- `.claude/ll-standards.version` -- version stamp

**What upgrade preserves (never touched):**
- `CLAUDE.md` -- project-specific info
- `docs/ai/cases/` -- historical case data

**Upgrade is atomic** -- all components share one version number. No partial upgrades.

### V4.3 to V4.4 (one-time migration)

V4.3 projects have a different CLAUDE.md structure. Use the migration script:

```bash
./scripts/migrate_v43_to_v44.sh /path/to/your-project        # Linux / macOS
.\scripts\migrate_v43_to_v44.ps1 -Target "C:\your-project"    # Windows
```

### Upgrade path summary

```text
New project ---------> plugin install / install_project -----> v5.0
V4.3 project --------> migrate_v43_to_v44 ------------------> v4.4 -> upgrade
V4.4+ project -------> plugin update / upgrade_project ------> latest
```

---

## Validation

```powershell
# Windows
.\scripts\validate_ai_case.ps1 -CasePath "docs\ai\cases\<case-id>" -Risk yellow -Strict
```

```bash
# Linux / macOS
./scripts/validate_ai_case.sh docs/ai/cases/<case-id> --risk yellow --strict
```

---

## Distribution Parity

Plugin install and script install produce identical results:

| Component | Plugin | Script |
|---|---|---|
| Behavior rules | Plugin CLAUDE.md (auto-loaded) | .claude/ll-rules.md (copied) |
| Skills | Plugin skills/ (auto-discovered) | .claude/skills/ (copied) |
| Project CLAUDE.md | /ll-setup creates | install_project creates |
| Upgrade | `claude plugin update` | `upgrade_project.*` |
| Version tracking | Plugin system | .claude/ll-standards.version |

---

## Script Encoding Note

All PowerShell and Bash scripts contain English text only. Chinese content is read from files at runtime via file I/O, not embedded in the script body. Scripts run correctly on Windows systems regardless of console code page.
