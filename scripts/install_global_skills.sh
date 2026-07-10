#!/usr/bin/env bash
set -euo pipefail
FORCE="false"
[[ "${1:-}" == "--force" ]] && FORCE="true"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
TARGET_DIR="$HOME/.claude/skills"
mkdir -p "$TARGET_DIR"
for skill in "$SKILLS_DIR"/*; do
  [[ -d "$skill" ]] || continue
  name="$(basename "$skill")"
  dest="$TARGET_DIR/$name"
  if [[ -e "$dest" && "$FORCE" != "true" ]]; then mv "$dest" "$dest.bak.$(date +%Y%m%d%H%M%S)"; elif [[ -e "$dest" ]]; then rm -rf "$dest"; fi
  cp -R "$skill" "$dest"
  echo "[OK] Installed skill: $name"
done
