param(
    [string]$Target = "."
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")

if (-not (Test-Path $Target)) {
    Write-Host "[ERROR] Target path not found: $Target" -ForegroundColor Red
    exit 1
}
$TargetPath = Resolve-Path -Path $Target
$ClaudeMd = Join-Path $TargetPath "CLAUDE.md"
$ClaudeDir = Join-Path $TargetPath ".claude"
$VersionFile = Join-Path $ClaudeDir "ll-standards.version"

# Check if already V4.4
if (Test-Path $VersionFile) {
    $ver = (Get-Content $VersionFile -Raw).Trim()
    if ($ver -match "v4\.4") {
        Write-Host "[OK] Already at V4.4 ($ver). No migration needed." -ForegroundColor Green
        exit 0
    }
}

Write-Host "=== LL Standards Migration: V4.3 -> V4.4 ===" -ForegroundColor Yellow
Write-Host ""

# Step 1: Backup existing CLAUDE.md
if (Test-Path $ClaudeMd) {
    $backupPath = "$ClaudeMd.v43.bak"
    Copy-Item -Path $ClaudeMd -Destination $backupPath -Force
    Write-Host "[OK] Backed up CLAUDE.md -> CLAUDE.md.v43.bak" -ForegroundColor Green

    # Step 2: Extract Section 1 from old CLAUDE.md
    $content = Get-Content $ClaudeMd -Raw -Encoding UTF8
    $section2Marker = "## 2. Default Behavior Mode"
    $altMarker = "## 2. LL AI Engineering Standards"
    $splitIndex = $content.IndexOf($section2Marker)
    if ($splitIndex -lt 0) { $splitIndex = $content.IndexOf($altMarker) }

    if ($splitIndex -gt 0) {
        $section1 = $content.Substring(0, $splitIndex).TrimEnd()
        Write-Host "[OK] Extracted Section 1 from CLAUDE.md" -ForegroundColor Green
    } else {
        $section1 = $content.TrimEnd()
        Write-Host "[WARN] Could not find Section 2 marker. Keeping full content." -ForegroundColor Yellow
    }

    # Step 3: Read Section 2 from the V4.4 template (avoids embedding Chinese in this script)
    $templatePath = Join-Path $RepoRoot "templates\CLAUDE.md"
    $templateContent = Get-Content $templatePath -Raw -Encoding UTF8
    $templateSection2Marker = "## 2. LL AI Engineering Standards"
    $templateSplitIndex = $templateContent.IndexOf($templateSection2Marker)

    if ($templateSplitIndex -gt 0) {
        $section2 = $templateContent.Substring($templateSplitIndex)
    } else {
        Write-Host "[ERROR] Cannot find Section 2 in templates/CLAUDE.md" -ForegroundColor Red
        exit 1
    }

    # Step 4: Combine Section 1 (from project) + Section 2 (from template)
    $newContent = "$section1`n`n---`n`n$section2"
    [System.IO.File]::WriteAllText($ClaudeMd, $newContent, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[OK] CLAUDE.md rewritten (Section 1 preserved + ll-rules.md reference)" -ForegroundColor Green
} else {
    Write-Host "[WARN] No CLAUDE.md found. Will create during upgrade." -ForegroundColor Yellow
}

# Step 5: Run upgrade to install ll-rules.md + skills + version
Write-Host ""
Write-Host "Running upgrade_project..." -ForegroundColor Cyan
& (Join-Path $ScriptDir "upgrade_project.ps1") -Target $Target -Force

# Step 6: Clean up orphan directories from V4.3 install
$orphans = @(
    (Join-Path $TargetPath "docs\ai\templates"),
    (Join-Path $TargetPath "docs\ai\usage"),
    (Join-Path $TargetPath "docs\ai\skill-compositions")
)
foreach ($orphan in $orphans) {
    if (Test-Path $orphan) {
        Remove-Item -Path $orphan -Recurse -Force
        Write-Host "[OK] Removed orphan directory: $(Split-Path $orphan -Leaf)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Migration Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "What changed:" -ForegroundColor Yellow
Write-Host "  CLAUDE.md             -> Section 1 only + reference (backup: CLAUDE.md.v43.bak)" -ForegroundColor White
Write-Host "  .claude/ll-rules.md  -> NEW: behavior rules (Sections 2-9)" -ForegroundColor White
Write-Host "  .claude/skills/       -> Deduplicated (35 -> 17 reference files)" -ForegroundColor White
Write-Host "  .claude/ll-standards.version -> NEW: version stamp" -ForegroundColor White
Write-Host "  docs/ai/templates/    -> Removed (templates live in skill references)" -ForegroundColor White
Write-Host ""
Write-Host "Please review CLAUDE.md.v43.bak for any custom additions to Sections 2-9." -ForegroundColor Cyan
