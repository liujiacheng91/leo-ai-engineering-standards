param(
    [string]$Target = ".",
    [switch]$Force
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$RepoVersion = (Get-Content (Join-Path $RepoRoot "VERSION") -Raw).Trim()

if (-not (Test-Path $Target)) { New-Item -ItemType Directory -Force -Path $Target | Out-Null }
$TargetPath = Resolve-Path -Path $Target

# Layer 3 - Project-owned CLAUDE.md (only create if not exists)
$ClaudeMd = Join-Path $TargetPath "CLAUDE.md"
if (-not (Test-Path $ClaudeMd)) {
    Copy-Item -Path (Join-Path $RepoRoot "templates\CLAUDE.md") -Destination $ClaudeMd -Force
    Write-Host "[OK] Created CLAUDE.md (edit Section 1 with your project info)" -ForegroundColor Green
} else {
    Write-Host "[SKIP] CLAUDE.md already exists (project-owned, not overwritten)" -ForegroundColor Cyan
}

# Layer 1 - Standard rules (safe to overwrite)
$ClaudeDir = Join-Path $TargetPath ".claude"
New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
Copy-Item -Path (Join-Path $RepoRoot "ll-rules.md") -Destination (Join-Path $ClaudeDir "ll-rules.md") -Force
Write-Host "[OK] Installed .claude/ll-rules.md" -ForegroundColor Green

# Layer 2 - Skills (safe to overwrite)
$SkillsDest = Join-Path $ClaudeDir "skills"
if (Test-Path $SkillsDest) {
    if ($Force) { Remove-Item -Path $SkillsDest -Recurse -Force }
    else { Move-Item -Path $SkillsDest -Destination "$SkillsDest.bak.$(Get-Date -Format 'yyyyMMddHHmmss')" }
}
Copy-Item -Path (Join-Path $RepoRoot "skills") -Destination $SkillsDest -Recurse -Force
$SkillCount = (Get-ChildItem $SkillsDest -Directory).Count
Write-Host "[OK] Installed .claude/skills/ ($SkillCount skills)" -ForegroundColor Green

# Version stamp
$VersionFile = Join-Path $ClaudeDir "ll-standards.version"
Set-Content -Path $VersionFile -Value $RepoVersion -NoNewline
Write-Host "[OK] Version: $RepoVersion" -ForegroundColor Green

# Layer 3 - Case output directory
$CasesDir = Join-Path $TargetPath "docs\ai\cases"
New-Item -ItemType Directory -Force -Path $CasesDir | Out-Null

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Quick Start:" -ForegroundColor Yellow
Write-Host "  1. Edit CLAUDE.md Section 1 with your project info" -ForegroundColor White
Write-Host "  2. Open Claude Code in your project directory" -ForegroundColor White
Write-Host "  3. Type: /ll-dev" -ForegroundColor White
Write-Host ""
Write-Host "Single Skill usage:" -ForegroundColor Yellow
Write-Host "  /scenario-analysis    Generate Scenario.md" -ForegroundColor White
Write-Host "  /test-design          Generate Test.md" -ForegroundColor White
Write-Host "  /verification         Generate Verify.md" -ForegroundColor White
Write-Host ""
Write-Host "Upgrade:" -ForegroundColor Yellow
Write-Host "  scripts/upgrade_project.ps1 -Target ." -ForegroundColor White
