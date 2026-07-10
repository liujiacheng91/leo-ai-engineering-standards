#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
FORCE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_VERSION="$(cat "$REPO_ROOT/VERSION" | tr -d '[:space:]')"

if [[ ! -d "$TARGET" ]]; then
  echo "[ERROR] Target path not found: $TARGET" >&2
  exit 1
fi
TARGET_PATH="$(cd "$TARGET" && pwd)"
VERSION_FILE="$TARGET_PATH/.claude/ll-standards.version"

if [[ -f "$VERSION_FILE" ]]; then
  CURRENT_VERSION="$(cat "$VERSION_FILE" | tr -d '[:space:]')"
  echo "Current version: $CURRENT_VERSION"
  echo "Available version: $REPO_VERSION"
  if [[ "$CURRENT_VERSION" == "$REPO_VERSION" && "$FORCE" != "--force" ]]; then
    echo "[OK] Already up to date."
    exit 0
  fi
else
  echo "[WARN] No version file found. Run install_project first, or pass --force."
  if [[ "$FORCE" != "--force" ]]; then exit 1; fi
  CURRENT_VERSION="(none)"
fi

echo ""
echo "Upgrading: $CURRENT_VERSION -> $REPO_VERSION"
echo "  Replacing: .claude/ll-rules.md + .claude/skills/"
echo "  Preserving: CLAUDE.md + docs/ai/cases/"
echo ""

mkdir -p "$TARGET_PATH/.claude"

cp "$REPO_ROOT/ll-rules.md" "$TARGET_PATH/.claude/ll-rules.md"
echo "[OK] .claude/ll-rules.md updated"

rm -rf "$TARGET_PATH/.claude/skills"
cp -R "$REPO_ROOT/skills" "$TARGET_PATH/.claude/skills"
SKILL_COUNT=$(find "$TARGET_PATH/.claude/skills" -maxdepth 1 -type d | wc -l)
echo "[OK] .claude/skills/ updated ($((SKILL_COUNT - 1)) skills)"

printf '%s' "$REPO_VERSION" > "$VERSION_FILE"
echo "[OK] Version stamped: $REPO_VERSION"

echo ""
echo "Upgrade complete: $CURRENT_VERSION -> $REPO_VERSION"
echo "CLAUDE.md and docs/ai/cases/ were not modified."
