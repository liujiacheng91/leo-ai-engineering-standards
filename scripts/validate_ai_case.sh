#!/usr/bin/env bash
set -euo pipefail
CASE_PATH="."
RISK="green"
STRICT="false"
REQUIRE_CASE_CARD="false"
REQUIRE_TOKEN_REPORT="false"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --risk) RISK="$2"; shift 2 ;;
    --strict) STRICT="true"; shift ;;
    --require-case-card) REQUIRE_CASE_CARD="true"; shift ;;
    --require-token-report) REQUIRE_TOKEN_REPORT="true"; shift ;;
    *) CASE_PATH="$1"; shift ;;
  esac
done
CASE_PATH="$(cd "$CASE_PATH" && pwd)"
required=("AI_Request.md" "Scenario.md" "AI_Risk_Level.md")
case "$RISK" in
  green) required+=("Task.md" "Test.md" "Verify.md") ;;
  yellow) required+=("Solution.md" "Task.md" "Test.md" "Verify.md") ;;
  red) required+=("Solution.md") ;;
  *) echo "Invalid risk: $RISK" >&2; exit 1 ;;
esac
if [[ "$STRICT" == "true" ]]; then
  if [[ "$RISK" == "green" || "$RISK" == "yellow" ]]; then required+=("PR_Template.md"); fi
  required+=("AI_Case_Card.md" "Token_Usage_Report.md")
fi
[[ "$REQUIRE_CASE_CARD" == "true" ]] && required+=("AI_Case_Card.md")
[[ "$REQUIRE_TOKEN_REPORT" == "true" ]] && required+=("Token_Usage_Report.md")
missing=()
seen=""
for f in "${required[@]}"; do
  [[ "$seen" == *"|$f|"* ]] && continue
  seen="$seen|$f|"
  [[ -f "$CASE_PATH/$f" ]] || missing+=("$f")
done
if [[ ${#missing[@]} -gt 0 ]]; then
  echo "[FAIL] Missing required files:"
  for f in "${missing[@]}"; do echo "  - $f"; done
  exit 1
fi
echo "[OK] AI case validation passed: $CASE_PATH"
