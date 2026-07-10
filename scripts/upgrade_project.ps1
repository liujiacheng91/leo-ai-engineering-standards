param(
    [string]$Target = ".",
    [switch]$Force
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$RepoVersion = (Get-Content (Join-Path $RepoRoot "VERSION") -Raw).Trim()

if (-not (Test-Path $Target)) {
    Write-Host "[ERROR] Target path not found: $Target" -ForegroundColor Red
    exit 1
}
$TargetPath = Resolve-Path -Path $Target
$VersionFile = Join-Path $TargetPath ".claude\ll-standards.version"

if (Test-Path $VersionFile) {
    $CurrentVersion = (Get-Content $VersionFile -Raw).Trim()
    Write-Host "Current version: $CurrentVersion" -ForegroundColor Cyan
    Write-Host "Available version: $RepoVersion" -ForegroundColor Cyan
    if ($CurrentVersion -eq $RepoVersion -and -not $Force) {
        Write-Host "[OK] Already up to date." -ForegroundColor Green
        exit 0
    }
} else {
    Write-Host "[WARN] No version file found. Run install_project first, or use -Force." -ForegroundColor Yellow
    if (-not $Force) { exit 1 }
    $CurrentVersion = "(none)"
}

Write-Host ""
Write-Host "Upgrading: $CurrentVersion -> $RepoVersion" -ForegroundColor Yellow
Write-Host "  Replacing: .claude/ll-rules.md + .claude/skills/" -ForegroundColor Yellow
Write-Host "  Preserving: CLAUDE.md + docs/ai/cases/" -ForegroundColor Green
Write-Host ""

# Atomic upgrade: ll-rules.md
$RulesSource = Join-Path $RepoRoot "ll-rules.md"
$RulesDest = Join-Path $TargetPath ".claude\ll-rules.md"
New-Item -ItemType Directory -Force -Path (Join-Path $TargetPath ".claude") | Out-Null
Copy-Item -Path $RulesSource -Destination $RulesDest -Force
Write-Host "[OK] .claude/ll-rules.md updated" -ForegroundColor Green

# Atomic upgrade: skills/
$SkillsDest = Join-Path $TargetPath ".claude\skills"
if (Test-Path $SkillsDest) { Remove-Item -Path $SkillsDest -Recurse -Force }
Copy-Item -Path (Join-Path $RepoRoot "skills") -Destination $SkillsDest -Recurse -Force
Write-Host "[OK] .claude/skills/ updated ($((Get-ChildItem $SkillsDest -Directory).Count) skills)" -ForegroundColor Green

# Write version
Set-Content -Path $VersionFile -Value $RepoVersion -NoNewline
Write-Host "[OK] Version stamped: $RepoVersion" -ForegroundColor Green

Write-Host ""
Write-Host "Upgrade complete: $CurrentVersion -> $RepoVersion" -ForegroundColor Green
Write-Host "CLAUDE.md and docs/ai/cases/ were not modified." -ForegroundColor Cyan
