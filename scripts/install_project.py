#!/usr/bin/env python3
import argparse, shutil
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--target', required=True)
parser.add_argument('--force', action='store_true')
args = parser.parse_args()

root = Path(__file__).resolve().parents[1]
target = Path(args.target).resolve()
target.mkdir(parents=True, exist_ok=True)

version = (root / 'VERSION').read_text().strip()

def backup_or_remove(path: Path):
    if path.exists() and args.force:
        if path.is_dir(): shutil.rmtree(path)
        else: path.unlink()
    elif path.exists():
        backup = path.with_name(path.name + '.bak')
        idx = 1
        while backup.exists():
            backup = path.with_name(path.name + f'.bak.{idx}')
            idx += 1
        path.rename(backup)

def copy_dir(src, dst):
    if not src.exists(): return
    backup_or_remove(dst)
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(src, dst)

def copy_file(src, dst):
    if not src.exists(): return
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)

# Layer 3 - Project-owned CLAUDE.md (only create if not exists)
claude_md = target / 'CLAUDE.md'
if not claude_md.exists():
    copy_file(root / 'templates/CLAUDE.md', claude_md)
    print('[OK] Created CLAUDE.md (edit Section 1 with your project info)')
else:
    print('[SKIP] CLAUDE.md already exists (project-owned, not overwritten)')

# Layer 1 - Standard rules (safe to overwrite)
claude_dir = target / '.claude'
claude_dir.mkdir(parents=True, exist_ok=True)
shutil.copy2(root / 'll-rules.md', claude_dir / 'll-rules.md')
print('[OK] Installed .claude/ll-rules.md')

# Layer 2 - Skills (safe to overwrite)
skills_dest = claude_dir / 'skills'
backup_or_remove(skills_dest)
shutil.copytree(root / 'skills', skills_dest)
skill_count = sum(1 for p in skills_dest.iterdir() if p.is_dir())
print(f'[OK] Installed .claude/skills/ ({skill_count} skills)')

# Version stamp
(claude_dir / 'll-standards.version').write_text(version)
print(f'[OK] Version: {version}')

# Layer 3 - Case output directory
(target / 'docs/ai/cases').mkdir(parents=True, exist_ok=True)

print('')
print('=== Installation Complete ===')
print('')
print('Quick Start:')
print('  1. Edit CLAUDE.md Section 1 with your project info')
print('  2. Open Claude Code in your project directory')
print('  3. Type: /ll-dev')
print('')
print('Upgrade:')
print('  python scripts/install_project.py --target . --force')
