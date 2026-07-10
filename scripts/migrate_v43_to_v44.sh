#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ ! -d "$TARGET" ]]; then
  echo "[ERROR] Target path not found: $TARGET" >&2
  exit 1
fi
TARGET_PATH="$(cd "$TARGET" && pwd)"
CLAUDE_MD="$TARGET_PATH/CLAUDE.md"
VERSION_FILE="$TARGET_PATH/.claude/ll-standards.version"

# Check if already V4.4
if [[ -f "$VERSION_FILE" ]]; then
  VER="$(cat "$VERSION_FILE" | tr -d '[:space:]')"
  if [[ "$VER" == *"v4.4"* ]]; then
    echo "[OK] Already at V4.4 ($VER). No migration needed."
    exit 0
  fi
fi

echo "=== LL Standards Migration: V4.3 -> V4.4 ==="
echo ""

# Step 1: Backup existing CLAUDE.md
if [[ -f "$CLAUDE_MD" ]]; then
  cp "$CLAUDE_MD" "$CLAUDE_MD.v43.bak"
  echo "[OK] Backed up CLAUDE.md -> CLAUDE.md.v43.bak"

  # Step 2: Extract Section 1 from old CLAUDE.md (everything before "## 2.")
  SECTION1=$(sed -n '1,/^## 2\./p' "$CLAUDE_MD" | head -n -1)
  if [[ -z "$SECTION1" ]]; then
    SECTION1=$(cat "$CLAUDE_MD")
    echo "[WARN] Could not find Section 2 marker. Keeping full CLAUDE.md content."
  else
    echo "[OK] Extracted Section 1 from CLAUDE.md"
  fi

  # Step 3: Read Section 2 from V4.4 template (avoids embedding Chinese in this script)
  TEMPLATE_PATH="$REPO_ROOT/templates/CLAUDE.md"
  SECTION2=$(sed -n '/^## 2\./,$p' "$TEMPLATE_PATH")
  if [[ -z "$SECTION2" ]]; then
    echo "[ERROR] Cannot find Section 2 in templates/CLAUDE.md" >&2
    exit 1
  fi

  # Step 4: Combine Section 1 (from project) + Section 2 (from template)
  printf '%s\n\n---\n\n%s\n' "$SECTION1" "$SECTION2" > "$CLAUDE_MD"
  echo "[OK] CLAUDE.md rewritten (Section 1 preserved + ll-rules.md reference)"
else
  echo "[WARN] No CLAUDE.md found. Will create during upgrade."
fi

# Step 5: Run upgrade to install ll-rules.md + skills + version
echo ""
echo "Running upgrade_project..."
"$SCRIPT_DIR/upgrade_project.sh" "$TARGET" --force

# Step 6: Clean up orphan directories from V4.3 install
for orphan in "docs/ai/templates" "docs/ai/usage" "docs/ai/skill-compositions"; do
  ORPHAN_PATH="$TARGET_PATH/$orphan"
  if [[ -d "$ORPHAN_PATH" ]]; then
    rm -rf "$ORPHAN_PATH"
    echo "[OK] Removed orphan directory: $(basename "$orphan")"
  fi
done

echo ""
echo "=== Migration Complete ==="
echo ""
echo "What changed:"
echo "  CLAUDE.md             -> Section 1 only + reference (backup: CLAUDE.md.v43.bak)"
echo "  .claude/ll-rules.md  -> NEW: behavior rules (Sections 2-9)"
echo "  .claude/skills/       -> Deduplicated (35 -> 17 reference files)"
echo "  .claude/ll-standards.version -> NEW: version stamp"
echo "  docs/ai/templates/    -> Removed (templates live in skill references)"
echo ""
echo "Please review CLAUDE.md.v43.bak if you had custom additions to Sections 2-9."
