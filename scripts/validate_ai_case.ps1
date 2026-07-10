param(
    [string]$CasePath = ".",
    [ValidateSet("green","yellow","red")][string]$Risk = "green",
    [switch]$Strict,
    [switch]$RequireCaseCard,
    [switch]$RequireTokenReport
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ResolvedCasePath = Resolve-Path -Path $CasePath
$Required = @("AI_Request.md", "Scenario.md", "AI_Risk_Level.md")
if ($Risk -eq "green") { $Required += @("Task.md", "Test.md", "Verify.md") }
if ($Risk -eq "yellow") { $Required += @("Solution.md", "Task.md", "Test.md", "Verify.md") }
if ($Risk -eq "red") { $Required += @("Solution.md") }
if ($Strict) {
    if ($Risk -in @("green", "yellow")) { $Required += @("PR_Template.md") }
    $Required += @("AI_Case_Card.md", "Token_Usage_Report.md")
}
if ($RequireCaseCard -and ($Required -notcontains "AI_Case_Card.md")) { $Required += "AI_Case_Card.md" }
if ($RequireTokenReport -and ($Required -notcontains "Token_Usage_Report.md")) { $Required += "Token_Usage_Report.md" }
$Missing = @()
foreach ($file in $Required) { if (-not (Test-Path (Join-Path $ResolvedCasePath $file))) { $Missing += $file } }
if ($Missing.Count -gt 0) {
    Write-Host "[FAIL] Missing required files:" -ForegroundColor Red
    foreach ($file in $Missing) { Write-Host "  - $file" -ForegroundColor Red }
    exit 1
}
Write-Host "[OK] AI case validation passed: $ResolvedCasePath" -ForegroundColor Green
