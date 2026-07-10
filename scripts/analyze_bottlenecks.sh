#!/usr/bin/env bash
# analyze_bottlenecks.sh — Scan completed cases and identify AI collaboration bottlenecks.
#
# Usage:
#   ./scripts/analyze_bottlenecks.sh [cases_dir]
#
# Default cases_dir: docs/ai/cases/
#
# Output: Top 3 bottleneck areas based on retry patterns, stage-level token data,
# and root cause classifications from AI_Case_Card.md and Token_Usage_Report.md.

set -euo pipefail

CASES_DIR="${1:-docs/ai/cases}"

if [ ! -d "$CASES_DIR" ]; then
  echo "Cases directory not found: $CASES_DIR"
  echo "Run this script from the project root, or pass the cases directory as an argument."
  exit 1
fi

echo "=== AI Collaboration Bottleneck Analysis ==="
echo "Scanning: $CASES_DIR"
echo ""

# Counters
TOTAL_CASES=0
TOTAL_RETRIES=0
LOGIC_RETRIES=0
TOOLCHAIN_RETRIES=0
ASSUMPTION_RETRIES=0
STAGE_TOKENS_SUM=0
STAGE_COUNT=0

declare -A STAGE_COSTS
declare -A STAGE_COUNTS
declare -A ROOT_CAUSE_COUNTS

# Scan case directories
for case_dir in "$CASES_DIR"/*/; do
  [ -d "$case_dir" ] || continue

  case_card="$case_dir/AI_Case_Card.md"
  token_report="$case_dir/Token_Usage_Report.md"

  if [ ! -f "$case_card" ]; then
    continue
  fi

  TOTAL_CASES=$((TOTAL_CASES + 1))
  case_name=$(basename "$case_dir")

  # Extract retry count from AI_Case_Card.md
  retry_count=$(grep -i "Retry Count" "$case_card" 2>/dev/null | grep -oE '[0-9]+' | head -1 || echo "0")
  retry_count="${retry_count:-0}"
  TOTAL_RETRIES=$((TOTAL_RETRIES + retry_count))

  # Extract root cause classifications
  if grep -qi '\[Logic\]' "$case_card" 2>/dev/null; then
    LOGIC_RETRIES=$((LOGIC_RETRIES + 1))
    ROOT_CAUSE_COUNTS["[Logic]"]=$((${ROOT_CAUSE_COUNTS["[Logic]"]:-0} + 1))
  fi
  if grep -qi '\[Toolchain\]' "$case_card" 2>/dev/null; then
    TOOLCHAIN_RETRIES=$((TOOLCHAIN_RETRIES + 1))
    ROOT_CAUSE_COUNTS["[Toolchain]"]=$((${ROOT_CAUSE_COUNTS["[Toolchain]"]:-0} + 1))
  fi
  if grep -qi '\[Assumption\]' "$case_card" 2>/dev/null; then
    ASSUMPTION_RETRIES=$((ASSUMPTION_RETRIES + 1))
    ROOT_CAUSE_COUNTS["[Assumption]"]=$((${ROOT_CAUSE_COUNTS["[Assumption]"]:-0} + 1))
  fi

  # Extract stage-level token data from Token_Usage_Report.md
  if [ -f "$token_report" ]; then
    # Look for stage token percentages
    while IFS= read -r line; do
      # Match patterns like: "| Solution | 12,500 | 18% |"
      if echo "$line" | grep -qE '^\|.*\|.*\|.*%\|'; then
        stage_name=$(echo "$line" | awk -F'|' '{print $2}' | xargs)
        stage_pct=$(echo "$line" | awk -F'|' '{print $4}' | grep -oE '[0-9.]+' | head -1)
        if [ -n "$stage_name" ] && [ -n "$stage_pct" ] && [ "$stage_name" != "Stage" ] && [ "$stage_name" != "---" ]; then
          STAGE_COSTS["$stage_name"]=$(echo "${STAGE_COSTS["$stage_name"]:-0} + $stage_pct" | bc -l 2>/dev/null || echo "${STAGE_COSTS["$stage_name"]:-0}")
          STAGE_COUNTS["$stage_name"]=$((${STAGE_COUNTS["$stage_name"]:-0} + 1))
        fi
      fi
    done < "$token_report"
  fi
done

if [ "$TOTAL_CASES" -eq 0 ]; then
  echo "No completed cases found in $CASES_DIR"
  exit 0
fi

# --- Report ---

echo "## Case Summary"
echo ""
echo "  Total cases scanned: $TOTAL_CASES"
echo "  Total retries:       $TOTAL_RETRIES"
echo "  Avg retries/case:    $(echo "scale=1; $TOTAL_RETRIES / $TOTAL_CASES" | bc -l 2>/dev/null || echo "N/A")"
echo ""

echo "## Root Cause Distribution"
echo ""
for cause in "[Logic]" "[Assumption]" "[Toolchain]"; do
  count="${ROOT_CAUSE_COUNTS[$cause]:-0}"
  pct=$(echo "scale=0; $count * 100 / $TOTAL_CASES" | bc -l 2>/dev/null || echo "0")
  bar=$(printf '%*s' "$pct" '' | tr ' ' '#')
  echo "  $cause: $count cases ($pct%) $bar"
done
echo ""

echo "## Stage-Level Token Hotspots (average % of total budget)"
echo ""
# Sort stages by average percentage, descending
for stage in "${!STAGE_COUNTS[@]}"; do
  count="${STAGE_COUNTS[$stage]}"
  total="${STAGE_COSTS[$stage]}"
  avg=$(echo "scale=1; $total / $count" | bc -l 2>/dev/null || echo "0")
  echo "$avg $stage $count"
done | sort -rn | head -10 | while read -r avg stage count; do
  printf "  %-25s %5.1f%%  (n=%s)\n" "$stage" "$avg" "$count"
done
echo ""

echo "## Top 3 Bottleneck Recommendations"
echo ""

# Logic-based recommendation
if [ "${ROOT_CAUSE_COUNTS["[Logic]"]:-0}" -gt 0 ]; then
  echo "  1. [Logic] retries detected in ${ROOT_CAUSE_COUNTS["[Logic]"]} cases."
  echo "     Action: Review Solution.md quality before Task.md. Use /ll-drill solution-design."
  echo "     Target: reduce [Logic] retries by 50% within 5 cases."
  echo ""
fi

# Assumption-based recommendation
if [ "${ROOT_CAUSE_COUNTS["[Assumption]"]:-0}" -gt 0 ]; then
  echo "  2. [Assumption] retries detected in ${ROOT_CAUSE_COUNTS["[Assumption]"]} cases."
  echo "     Action: Add pre-implementation verification (F3 checkpoint). Ask AI to state assumptions before coding."
  echo "     Target: reduce [Assumption] retries to 0 within 3 cases."
  echo ""
fi

# Toolchain-based recommendation
if [ "${ROOT_CAUSE_COUNTS["[Toolchain]"]:-0}" -gt 0 ]; then
  echo "  3. [Toolchain] retries detected in ${ROOT_CAUSE_COUNTS["[Toolchain]"]} cases."
  echo "     Action: Add environment pre-check to CLAUDE.md Section 1. Verify toolchain before starting."
  echo "     Target: reduce [Toolchain] retries to 0 within 2 cases."
  echo ""
fi

if [ "$TOTAL_RETRIES" -eq 0 ]; then
  echo "  No retries detected. Your AI collaboration pipeline is clean."
  echo "  Next: review stage-level token hotspots above for efficiency gains."
fi

echo "=== End of Report ==="
