# Claude Code Permission Settings

> Recommended `.claude/settings.local.json` for projects using LL AI Engineering Standards.
> Copy this config to your project's `.claude/settings.local.json` to reduce approval prompts during standard workflow operations.

## Recommended Config

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "Bash(git log:*)",
      "Bash(git diff:*)",
      "Bash(git tag:*)",
      "Bash(git push:*)",
      "Bash(git checkout:*)",
      "Bash(git merge:*)",
      "Bash(git branch:*)",
      "Bash(git pull:*)",
      "Bash(git fetch:*)",
      "Bash(git ls-tree:*)",
      "Bash(git config:*)",
      "Bash(git mv:*)",
      "Bash(git rm:*)",
      "PowerShell(Get-ChildItem:*)",
      "PowerShell(Get-Content:*)",
      "PowerShell(New-Item:*)",
      "PowerShell(Select-Object:*)",
      "PowerShell(Sort-Object:*)",
      "PowerShell(Where-Object:*)",
      "PowerShell(ForEach-Object:*)",
      "PowerShell(Measure-Object:*)",
      "PowerShell(Group-Object:*)",
      "PowerShell(Compare-Object:*)",
      "PowerShell(Test-Path:*)",
      "PowerShell(Join-Path:*)",
      "PowerShell(Split-Path:*)",
      "PowerShell(Resolve-Path:*)",
      "PowerShell(Copy-Item:*)",
      "PowerShell(Move-Item:*)",
      "PowerShell(ConvertFrom-Json:*)",
      "PowerShell(ConvertTo-Json:*)",
      "PowerShell(Out-Null:*)",
      "PowerShell(Out-String:*)",
      "PowerShell(Write-Output:*)",
      "PowerShell(Add-Type:*)",
      "PowerShell(Get-Date:*)",
      "PowerShell(Select-String:*)"
    ]
  }
}
```

## What Each Permission Covers

### Git Operations (16 entries)

| Permission | Purpose | Used In |
|---|---|---|
| `git add` | Stage files | Every commit |
| `git commit` | Create commits | Every commit |
| `git status` | Check working tree | Before every commit/merge |
| `git log` | View commit history | Version checks, PR prep |
| `git diff` | View changes | Before every commit |
| `git tag` | Create/list version tags | After merge to main |
| `git push` | Push to remote | After every commit |
| `git checkout` | Switch branches | Branch workflow (main/V4.x) |
| `git merge` | Merge branches | Version merge to main |
| `git branch` | List/manage branches | Branch management |
| `git pull` | Pull from remote | Sync with upstream |
| `git fetch` | Fetch remote refs without merging | Pre-merge checks, remote comparison |
| `git ls-tree` | Inspect tree objects | File structure verification |
| `git config` | Read/write git config | User info, remote URLs |
| `git mv` | Rename/move tracked files | Skill namespace changes, file reorganization |
| `git rm` | Remove tracked files | Template cleanup, deduplication |

### PowerShell Operations (24 entries, Windows only)

#### File System (6 entries)

| Permission | Purpose | Used In |
|---|---|---|
| `Get-ChildItem` | List directory contents | Case study scanning, file discovery |
| `Get-Content` | Read file contents | PPTX extraction, config reading, VERSION file |
| `New-Item` | Create files/directories | docs/ai/cases/ setup, .claude/ directory |
| `Copy-Item` | Copy files/directories | install_project.ps1, upgrade_project.ps1 (ll-rules.md, skills/) |
| `Move-Item` | Rename/move files | install_project.ps1 (skills/ backup before overwrite) |
| `Test-Path` | Check if path exists | Pre-flight checks, CLAUDE.md existence before install |

#### Path Operations (3 entries)

| Permission | Purpose | Used In |
|---|---|---|
| `Join-Path` | Build cross-platform paths | All install/upgrade/migrate scripts |
| `Split-Path` | Extract parent/leaf from path | Script self-location (`$MyInvocation.MyCommand.Path`) |
| `Resolve-Path` | Resolve relative to absolute path | Target path validation in scripts |

#### Pipeline Operations (7 entries)

| Permission | Purpose | Used In |
|---|---|---|
| `Select-Object` | Property selection, First/Last N items | `-ExpandProperty Name`, `-First 60` |
| `Sort-Object` | Sort pipeline output | Case directory ordering |
| `Where-Object` | Filter pipeline output | Conditional file filtering |
| `ForEach-Object` | Iterate pipeline items | Per-file processing in case audits |
| `Measure-Object` | Count/sum pipeline items | File counting, line counting |
| `Group-Object` | Group pipeline by property | Case grouping by type/risk |
| `Compare-Object` | Diff two collections | File comparison, template sync verification |

#### Data Operations (4 entries)

| Permission | Purpose | Used In |
|---|---|---|
| `ConvertFrom-Json` | Parse JSON to object | plugin.json, marketplace.json, settings.local.json reading |
| `ConvertTo-Json` | Serialize object to JSON | Config file generation |
| `Select-String` | Regex search in files | Pattern matching (PowerShell equivalent of grep) |
| `Add-Type` | Load .NET assemblies | ZIP extraction for PPTX reading (`System.IO.Compression`) |

#### Output Operations (4 entries)

| Permission | Purpose | Used In |
|---|---|---|
| `Write-Output` | Emit objects to pipeline | Script output |
| `Out-Null` | Suppress unwanted output | `New-Item ... \| Out-Null` in scripts |
| `Out-String` | Convert objects to string | Pipeline result formatting |
| `Get-Date` | Current date/time | Backup file naming (`yyyyMMddHHmmss` suffix) |

## What Is NOT Allowed (intentionally)

These operations remain gated and require manual approval:

| Operation | Reason |
|---|---|
| `git reset --hard` | Destructive -- discards uncommitted changes |
| `git push --force` | Destructive -- can overwrite remote history |
| `git clean` | Destructive -- deletes untracked files |
| `git rebase` | Can rewrite commit history |
| `Remove-Item` / `rm` | Destructive -- file/directory deletion |
| `Clear-Content` | Destructive -- empties file contents |
| `Stop-Process` / `kill` | Destructive -- process termination |
| `Set-Content` / `Out-File` | Write operations -- use Claude Code's Write/Edit tools instead |
| `Set-ItemProperty` | Registry/property modification |
| `Invoke-WebRequest` / `curl` | Network calls -- use Claude Code's WebFetch tool instead |
| `Invoke-Expression` / `iex` | Arbitrary code execution -- security risk |
| `Start-Process` | External process launch -- requires case-by-case review |

## Optional: RTK (Rust Token Killer) Permissions

If using RTK for token-optimized CLI operations, add these entries:

```json
"Bash(rtk git:*)",
"Bash(rtk ls:*)",
"Bash(rtk read:*)",
"Bash(rtk find:*)",
"Bash(rtk grep:*)"
```

RTK acts as a transparent proxy that reduces token consumption by 60-90% on CLI output. When RTK is installed, Claude Code hooks automatically rewrite commands (e.g., `git status` becomes `rtk git status`).

## Optional: Claude Plugin Management

If managing LL standards via Claude Code plugin system:

```json
"Bash(claude plugin:*)"
```

## Optional: Script Execution

If running install/upgrade/validation scripts or inline processing:

```json
"Bash(python3:*)",
"Bash(node:*)"
```

Use cases: `install_project.py`, `validate_ai_case.py`, inline PPTX/JSON processing.

## Optional: Skill Permissions

If using Claude Code skills that trigger shell commands:

```json
"Skill(commit-commands:commit)"
```

## Anti-Pattern: Auto-Accumulated Permissions

Claude Code auto-adds specific permission entries when you approve a command. Over time this creates entries like:

```json
"Bash(git merge V4.1 --no-ff -m ' *)",
"Bash(git merge V4.4 --no-ff -m ' *)",
"Bash(git merge V4.5 --no-ff -m ' *)",
"Bash(Get-ChildItem -Path \"reports/case-studies/20260529/...\" -Directory)"
```

These are overly specific and accumulate noise. Replace them with wildcard patterns:

| Auto-accumulated | Replace with |
|---|---|
| `Bash(git merge V4.1 --no-ff -m ' *)` | `Bash(git merge:*)` |
| `Bash(git commit -m ' *)` | `Bash(git commit:*)` |
| `Bash(Get-ChildItem -Path "specific/path" ...)` | `PowerShell(Get-ChildItem:*)` |
| `Bash(Select-Object -First 60)` | `PowerShell(Select-Object:*)` |

Periodically clean your `.claude/settings.local.json` by replacing specific entries with the wildcard patterns from this guide.

## Design Rationale

- **Wildcard patterns over specific commands**: `Bash(git merge:*)` covers all merge operations. No need for per-branch entries.
- **Redundant Bash commands removed**: `cat`, `ls`, `head`, `tail`, `grep`, `wc`, `sort`, `tr`, `echo`, `date` are handled by Claude Code's built-in tools (Read, Glob, Grep) which do not require permission entries.
- **PowerShell pipeline coverage**: `Select-Object`, `Sort-Object`, `Where-Object`, `Measure-Object` cover the most common pipeline operations used in directory scanning and case study audits.
- **Read-only bias**: PowerShell permissions cover read, filter, and create operations only. Write operations (`Set-Content`, `Out-File`) are excluded -- use Claude Code's Write/Edit tools instead.
- **Destructive operations gated**: Any command that could lose work (reset, force-push, clean, delete) requires explicit user approval every time.
- **Optional sections are additive**: Start with the recommended config. Add optional sections only when the tooling is installed and needed.
