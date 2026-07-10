# LL AI Engineering Standards v5.0

> Claude Code AI-assisted SDLC standards. Three-layer architecture with plugin marketplace support. Install via `claude plugin install` or fallback scripts.

## AI-assisted SDLC

SDLC (Software Development Life Cycle) in AI-assisted mode is not skipped -- it is compressed and partially automated. Human roles shift from execution to governance.

```text
Requirements --> Design --> Task --> Test --> Implementation --> Verification --> Release --> Cost
Scenario.md    Solution.md  Task.md  Test.md  Code + Hard      Verify.md       PR + Case    Token
+ BA Input     + Technical          + API    Enforcement       + Track A/B     Card         Report
+ RA Gate      Constraints          + Perm   Layer                                          + ROI
               (Stop Cond.)         + AC                       + Completeness
                                    Trace                      Checks
```

| Traditional SDLC | AI-assisted SDLC |
|---|---|
| Multi-role, sequential, manual | Single Agent orchestration, template-driven |
| BA writes requirements | AI generates + BA fills Business Model Input |
| Dev writes code | AI generates + Hard Enforcement Layer constraints |
| QA tests post-development | AI generates Test.md pre-implementation |
| Cost estimated by PM | Token Report with Stage-Level breakdown + Cost Efficiency |

Full SDLC stage mapping, role definitions, execution modes, and case evidence chain: **[SDLC.md](SDLC.md)**

## Architecture

```text
Layer 1 -- Governance (CLAUDE.md / ll-rules.md)
  Behavior rules / SDLC workflow / risk rules / verification / stop conditions
  Plugin: auto-loaded | Script: .claude/ll-rules.md

Layer 2 -- Skills (.claude/skills/ or plugin-managed)
  Each Skill is self-contained (SKILL.md + exclusive references/)
  Usable independently / in composition / as full workflow
  Upgrade-safe

Layer 3 -- Application (project CLAUDE.md + docs/ai/cases/)
  Project-owned data
  Never touched by upgrades
```

---

## Install / Upgrade

### Option A -- Plugin Install (recommended)

**Path A-1 -- URL install (git type, marketplace folder auto-managed):**

```bash
# 1. Add marketplace (one-time)
claude plugin marketplace add http://xxxxx/LeoLiu/ll_skill.git
    # .git suffix required -- without it Claude Code fetches the URL as JSON, not git clone

# 2. Install plugin
claude plugin install ll-standards@ll-ai-standards

# 3. Initialize project
/ll-setup

# 4. Edit CLAUDE.md Section 1, then:
/ll-dev
```

**Path A-2 -- Local clone (file type, required for private repos or offline):**

```bash
# 1. Clone repo (directory name must be "ll-ai-engineering-standards")
#    Public repo:
git clone http://xxxxx/LeoLiu/ll_skill.git ll-ai-engineering-standards
#    Private repo (requires access token):
git clone http://<username>:<access-token>@xxxxx/architecture/ai_agent/ll-ai-engineering-standards.git ll-ai-engineering-standards

# 2. Add marketplace
cd ll-ai-engineering-standards
claude plugin marketplace add "./.claude-plugin/marketplace.json"
    # IMPORTANT: use .claude-plugin/marketplace.json, NOT the root marketplace.json.
    # Root marketplace.json sets installLocation one level too high, causing cache-miss.

# 3. Install plugin
claude plugin install ll-standards@ll-ai-standards

# 4. Initialize project
/ll-setup

# 5. Edit CLAUDE.md Section 1, then:
/ll-dev
```

**Update to latest version:**

```bash
# Check current installed version
claude plugin list

# Update to latest
claude plugin update ll-standards@ll-ai-standards

# Verify update
claude plugin list
```

What update replaces (safe): behavior rules, skills, references, version stamp.
What update preserves (never touched): project CLAUDE.md Section 1, docs/ai/cases/.

### Option B -- Script Install (fallback)

For environments without Claude Code CLI:

```powershell
# Windows -- Install
git clone <repo-url> ll-ai-engineering-standards
cd ll-ai-engineering-standards
.\scripts\install_project.ps1 -Target "C:\your-project"

# Windows -- Upgrade
git pull
.\scripts\upgrade_project.ps1 -Target "C:\your-project"
```

```bash
# Linux / macOS -- Install
git clone <repo-url> ll-ai-engineering-standards
cd ll-ai-engineering-standards
chmod +x scripts/*.sh
./scripts/install_project.sh /path/to/your-project

# Linux / macOS -- Upgrade
git pull
./scripts/upgrade_project.sh /path/to/your-project
```

### Distribution Parity

| Component | Plugin | Script |
|---|---|---|
| Behavior rules | Plugin CLAUDE.md (auto-loaded) | .claude/ll-rules.md (copied) |
| Skills | Plugin skills/ (auto-discovered) | .claude/skills/ (copied) |
| Project CLAUDE.md | /ll-setup creates | install_project creates |
| Upgrade | `claude plugin update` | `upgrade_project.*` |
| Version tracking | Plugin system | .claude/ll-standards.version |

### Upgrade Path

```text
New project ---------> plugin install / install_project -----> v5.0
V4.3 project --------> migrate_v43_to_v44 ------------------> v4.4 -> upgrade
V4.4+ project -------> plugin update / upgrade_project ------> latest
```

Upgrade is atomic -- all components share one version number. No partial upgrades.

Details: **[INSTALL.md](INSTALL.md)**

---

## Usage Modes

| Mode | Command | Token Load | Use Case |
|---|---|---|---|
| Full Flow | `/ll-dev` | ~3K (orchestrator) + per-step | Full SDLC 12 steps |
| Single Skill | `/test-design` | ~5K (single Skill) | Only need Test.md |
| Composition | `/scenario-analysis` -> `/test-design` | Additive | Flexible combination |

### Available Skills

| Skill | Document | Purpose |
|---|---|---|
| `/ll-dev` | AI_Request.md | Full SDLC orchestrator |
| `/ll-setup` | CLAUDE.md | Project initialization |
| `/scenario-analysis` | Scenario.md | Requirements + BA Business Model Input + RA Quality Gate |
| `/risk-assessment` | AI_Risk_Level.md | Green / Yellow / Red evaluation |
| `/solution-design` | Solution.md | Technical Constraints (Stop Condition) + Track B Declaration |
| `/task-breakdown` | Task.md | Break approved Solution into executable tasks |
| `/test-design` | Test.md | Unit + API + Permission/Security + Mock + Fix History |
| `/verification` | Verify.md | Track A/B + Completeness Checks |
| `/token-report` | Token_Usage_Report.md | Cost Efficiency + Retry classification |
| `/pr-summary` | PR_Template.md | Pull request summary |
| `/mapping-rules` | Business/Mapping_Rules.md | Field mapping and business rules |

---

## Validation

```bash
# Linux / macOS
./scripts/validate_ai_case.sh docs/ai/cases/<case-id> --risk yellow --strict

# Windows
.\scripts\validate_ai_case.ps1 -CasePath "docs\ai\cases\<case-id>" -Risk yellow -Strict
```

---

## Claude Code Permission Settings

Recommended `.claude/settings.local.json` config for projects using LL standards. Pre-approves safe git and PowerShell operations to reduce approval prompts. Destructive operations (reset, force-push, delete) remain gated.

Details: **[claudecode_rule_setting.md](claudecode_rule_setting.md)**

---

## Source Repo Structure

```text
ll-ai-engineering-standards/
├── .claude-plugin/            Plugin manifest (plugin.json + marketplace.json)
├── VERSION                    Version stamp (source of truth)
├── CLAUDE.md                  Layer 1: behavior rules (plugin auto-load)
├── ll-rules.md               Layer 1: behavior rules (script fallback)
├── SDLC.md                    AI-assisted SDLC 9-stage definition
├── skills/                    Layer 2: modular Skills
│   └── <name>/SKILL.md + references/ (each template owned by one Skill)
├── standards/                 Standard documents (references/ source of truth)
├── templates/                 Template documents (references/ source of truth)
├── scripts/                   PS1 + SH + PY (no embedded Chinese)
│   ├── install_project.*      Fresh install
│   ├── upgrade_project.*      Normal upgrade (V4.4+)
│   ├── migrate_v43_to_v44.*   V4.3 migration
│   ├── install_global_skills.*  Global Skill install
│   └── validate_ai_case.*     Case validation
├── reports/                   Backlogs, Case Studies, Asset Registry
├── examples/                  Token Reports, Annotated Guides
├── GOVERNANCE.md              20 mandatory rules
├── CHANGELOG.md               Version history
├── INSTALL.md                 Install / Upgrade / Migrate guide
└── claudecode_rule_setting.md Recommended Claude Code permission settings
```

---

## Key Principles

- No `Scenario.md`, no AI implementation.
- No `AI_Risk_Level.md`, no AI execution.
- No `Solution.md Technical Constraints`, no Task / Test.
- Yellow: no `Solution.md Human Approval`, no Task / Test.
- No `Verify.md`, no PR merge.
- No Token record, no ROI conclusion.

## Token Cost

```
Cost (USD) = (Input / 1M) x Input Price + (Output / 1M) x Output Price
```

| Model | Input (USD/M) | Output (USD/M) |
|---|---|---|
| Haiku | 0.80 | 4.00 |
| Sonnet | 3.00 | 15.00 |
| Opus | 15.00 | 75.00 |

Sonnet is the default. Opus only on escalation (3+ components or 2 consecutive failures).
Cost Efficiency: `Cost / Saved Hours` (benchmarks: EDI $0.07/hr, Dyson $0.10/hr, VBO $0.18/hr, BizDB $0.59/hr, FREIGHTLIST batch $2.44/hr).

## Version History

| Version | Key Changes |
|---|---|
| v5.0 | Batch-derived behavior rules (12 rules from 20260608+20260609 audits): Green Minimal Path, LiteFlow=Yellow, AI_Case_Card mandatory, Stage-Level required, Merge_Decision.md forbidden, getter Grep verification, Sonnet routing, Track B requirements |
| v4.9 | Plugin marketplace GitLab support: root marketplace.json, Files API install pattern, local token file (.gitignore) |
| v4.8 | Multi-dimensional Reusable Assets (5-dimension evaluation in AI_Case_Card), all 8 improvement proposals resolved |
| v4.7 | Case Type routing table, 27-case audit notes, risk-benefit quadrant, per-case-type cost benchmarks, permission settings guide |
| v4.6 | Assumption retry prevention, 7 token optimizations, Green Minimal Path, Track B closure enforcement, Bug Fix pre-check, Saved Hours calibration, Merge_Decision.md banned |
| v4.5 | Plugin marketplace, /ll-dev rename (avoid official collision), /ll-setup, cross-skill consistency audit, dual distribution |
| v4.4 | Three-layer architecture, Skill deduplication (35->17 refs), atomic upgrade, CLAUDE.md split, SDLC doc, script encoding fix |
| v4.3 | API/permission test, AC traceability, Prevention Rule atomic pipeline, BA structured input, Yellow gate, Sonnet-first |
| v4.2 | Technical Constraints, JGit dual-track, RA quality gate, Retry classification, Saved Hours, Cost Efficiency |
| v4.1 | Hard Enforcement Layer, Exploration Protocol, QA sections, SubAgent governance, Runtime Mode benchmark |
| v4.0 | Token reporting, Model matrix, MD read optimization |
