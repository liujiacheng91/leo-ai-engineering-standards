#!/usr/bin/env bash
# sync.sh — Drift detection for CLAUDE.md ↔ ll-rules.md and templates/ ↔ skills/*/references/
#
# Usage:
#   ./scripts/sync.sh          Check all sync pairs, report drift
#
# Exit codes: 0 = in sync, 1 = drift detected or error

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DRIFT=0
CHECKS=0

check_sync() {
  local label="$1"
  local file_a="$2"
  local file_b="$3"

  CHECKS=$((CHECKS + 1))

  if [ ! -f "$file_a" ]; then
    echo -e "${RED}[MISS]${NC} $label: $file_a does not exist"
    DRIFT=1
    return
  fi
  if [ ! -f "$file_b" ]; then
    echo -e "${RED}[MISS]${NC} $label: $file_b does not exist"
    DRIFT=1
    return
  fi

  # Compare rule content only (skip header comment blocks — first 6 lines)
  local hash_a
  local hash_b
  hash_a=$(tail -n +7 "$file_a" | md5 -q 2>/dev/null || tail -n +7 "$file_a" | md5sum | cut -d' ' -f1)
  hash_b=$(tail -n +7 "$file_b" | md5 -q 2>/dev/null || tail -n +7 "$file_b" | md5sum | cut -d' ' -f1)

  if [ "$hash_a" = "$hash_b" ]; then
    echo -e "${GREEN}[ OK ]${NC} $label"
  else
    echo -e "${RED}[DRIFT]${NC} $label: content differs (skipping header)"
    DRIFT=1
  fi
}

echo "=== Sync Check: CLAUDE.md ↔ ll-rules.md ==="
echo ""
check_sync "CLAUDE.md ↔ ll-rules.md (rule content)" \
  "$ROOT/CLAUDE.md" \
  "$ROOT/ll-rules.md"

echo ""
echo "=== Sync Check: templates/ ↔ skills/*/references/ ==="
echo ""

# Known pairs from GOVERNANCE Rule 17
# Each template belongs to exactly one owning skill
check_sync "templates/AI_Request.md ↔ skills/ll-dev/references/AI_Request.md" \
  "$ROOT/templates/AI_Request.md" \
  "$ROOT/skills/ll-dev/references/AI_Request.md"

check_sync "templates/AI_Case_Card.md ↔ skills/ll-dev/references/AI_Case_Card.md" \
  "$ROOT/templates/AI_Case_Card.md" \
  "$ROOT/skills/ll-dev/references/AI_Case_Card.md"

check_sync "templates/Document_Naming_Standard.md ↔ skills/ll-dev/references/Document_Naming_Standard.md" \
  "$ROOT/templates/Document_Naming_Standard.md" \
  "$ROOT/skills/ll-dev/references/Document_Naming_Standard.md"

check_sync "templates/Scenario.md ↔ skills/scenario-analysis/references/Scenario.md" \
  "$ROOT/templates/Scenario.md" \
  "$ROOT/skills/scenario-analysis/references/Scenario.md"

check_sync "templates/AI_Risk_Level.md ↔ skills/risk-assessment/references/AI_Risk_Level.md" \
  "$ROOT/templates/AI_Risk_Level.md" \
  "$ROOT/skills/risk-assessment/references/AI_Risk_Level.md"

check_sync "templates/Solution.md ↔ skills/solution-design/references/Solution.md" \
  "$ROOT/templates/Solution.md" \
  "$ROOT/skills/solution-design/references/Solution.md"

check_sync "templates/Mapping_Rules.md ↔ skills/mapping-rules/references/Mapping_Rules.md" \
  "$ROOT/templates/Mapping_Rules.md" \
  "$ROOT/skills/mapping-rules/references/Mapping_Rules.md"

check_sync "templates/Business_Rules.md ↔ skills/mapping-rules/references/Business_Rules.md" \
  "$ROOT/templates/Business_Rules.md" \
  "$ROOT/skills/mapping-rules/references/Business_Rules.md"

check_sync "templates/Task.md ↔ skills/task-breakdown/references/Task.md" \
  "$ROOT/templates/Task.md" \
  "$ROOT/skills/task-breakdown/references/Task.md"

check_sync "templates/Test.md ↔ skills/test-design/references/Test.md" \
  "$ROOT/templates/Test.md" \
  "$ROOT/skills/test-design/references/Test.md"

check_sync "templates/Verify.md ↔ skills/verification/references/Verify.md" \
  "$ROOT/templates/Verify.md" \
  "$ROOT/skills/verification/references/Verify.md"

check_sync "templates/PR_Template.md ↔ skills/pr-summary/references/PR_Template.md" \
  "$ROOT/templates/PR_Template.md" \
  "$ROOT/skills/pr-summary/references/PR_Template.md"

check_sync "templates/Token_Usage_Report.md ↔ skills/token-report/references/Token_Usage_Report.md" \
  "$ROOT/templates/Token_Usage_Report.md" \
  "$ROOT/skills/token-report/references/Token_Usage_Report.md"

echo ""
echo "=== Sync Check: plugin.json version ↔ VERSION ==="
echo ""

VERSION_FILE="$ROOT/VERSION"
PLUGIN_JSON="$ROOT/.claude-plugin/plugin.json"

if [ -f "$VERSION_FILE" ] && [ -f "$PLUGIN_JSON" ]; then
  VERSION=$(cat "$VERSION_FILE")
  PLUGIN_VERSION=$(python3 -c "
import json, sys
with open('$PLUGIN_JSON') as f:
    d = json.load(f)
v = d.get('version', '')
print(v.lstrip('v'))
" 2>/dev/null || echo "PARSE_ERROR")

  if [ "$PLUGIN_VERSION" = "PARSE_ERROR" ]; then
    echo -e "${RED}[ERR]${NC} Failed to parse $PLUGIN_JSON"
    DRIFT=1
  elif [ "${VERSION#v}" = "$PLUGIN_VERSION" ]; then
    echo -e "${GREEN}[ OK ]${NC} VERSION ($VERSION) ↔ plugin.json (v$PLUGIN_VERSION)"
  else
    echo -e "${RED}[DRIFT]${NC} VERSION=$VERSION but plugin.json version=v$PLUGIN_VERSION"
    DRIFT=1
  fi
else
  echo -e "${YELLOW}[SKIP]${NC} VERSION or plugin.json not found"
fi

echo ""
if [ "$DRIFT" -eq 1 ]; then
  echo -e "${RED}=== DRIFT DETECTED ===${NC}"
  echo ""
  echo "Action required:"
  echo "  1. Identify the authoritative version of each drifted pair"
  echo "  2. Copy the authoritative version to the other location"
  echo "  3. Re-run scripts/sync.sh to verify"
  echo ""
  echo "Common resolution commands:"
  echo "  cp CLAUDE.md ll-rules.md                                    # If CLAUDE.md is authoritative"
  echo "  cp templates/<file> skills/<owner>/references/<file>        # If template is authoritative"
  exit 1
else
  echo -e "${GREEN}=== ALL $CHECKS CHECKS PASSED ===${NC}"
  exit 0
fi
