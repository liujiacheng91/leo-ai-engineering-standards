param([switch]$Force)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$SkillsDir = Join-Path $RepoRoot "skills"
$TargetDir = Join-Path $HOME ".claude\skills"
New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Get-ChildItem -Path $SkillsDir -Directory | ForEach-Object {
    $dest = Join-Path $TargetDir $_.Name
    if (Test-Path $dest) {
        if ($Force) { Remove-Item -Path $dest -Recurse -Force }
        else { Move-Item -Path $dest -Destination "$dest.bak.$(Get-Date -Format 'yyyyMMddHHmmss')" }
    }
    Copy-Item -Path $_.FullName -Destination $dest -Recurse -Force
    Write-Host "[OK] Installed skill: $($_.Name)" -ForegroundColor Green
}
