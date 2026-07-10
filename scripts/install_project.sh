#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
FORCE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_VERSION="$(cat "$REPO_ROOT/VERSION" | tr -d '[:space:]')"

[[ ! -d "$TARGET" ]] && mkdir -p "$TARGET"
TARGET_PATH="$(cd "$TARGET" && pwd)"

# Layer 3 — Project-owned CLAUDE.md (only create if not exists)
if [[ ! -f "$TARGET_PATH/CLAUDE.md" ]]; then
  cp "$REPO_ROOT/templates/CLAUDE.md" "$TARGET_PATH/CLAUDE.md"
  echo "[OK] Created CLAUDE.md (edit Section 1 with your project info)"
else
  echo "[SKIP] CLAUDE.md already exists (project-owned, not overwritten)"
fi

# Layer 1 — Standard rules (safe to overwrite)
mkdir -p "$TARGET_PATH/.claude"
cp "$REPO_ROOT/ll-rules.md" "$TARGET_PATH/.claude/ll-rules.md"
echo "[OK] Installed .claude/ll-rules.md"

# Layer 2 — Skills (safe to overwrite)
SKILLS_DEST="$TARGET_PATH/.claude/skills"
if [[ -d "$SKILLS_DEST" ]]; then
  if [[ "$FORCE" == "--force" ]]; then rm -rf "$SKILLS_DEST"
  else mv "$SKILLS_DEST" "$SKILLS_DEST.bak.$(date +%Y%m%d%H%M%S)"; fi
fi
cp -R "$REPO_ROOT/skills" "$SKILLS_DEST"
SKILL_COUNT=$(find "$SKILLS_DEST" -maxdepth 1 -type d | wc -l)
echo "[OK] Installed .claude/skills/ ($((SKILL_COUNT - 1)) skills)"

# Version stamp
printf '%s' "$REPO_VERSION" > "$TARGET_PATH/.claude/ll-standards.version"
echo "[OK] Version: $REPO_VERSION"

# Layer 3 — Case output directory
mkdir -p "$TARGET_PATH/docs/ai/cases"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Quick Start:"
echo "  1. Edit CLAUDE.md Section 1 with your project info"
echo "  2. Open Claude Code in your project directory"
echo "  3. Type: /ll-dev"
echo ""
echo "Single Skill usage:"
echo "  /scenario-analysis    Generate Scenario.md"
echo "  /test-design          Generate Test.md"
echo "  /verification         Generate Verify.md"
echo ""
echo "Upgrade:"
echo "  scripts/upgrade_project.sh <target-path>"
