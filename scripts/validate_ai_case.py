#!/usr/bin/env python3
import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('--case', required=True, help='AI case folder')
parser.add_argument('--risk', choices=['green','yellow','red'], default='green')
parser.add_argument('--strict', action='store_true')
parser.add_argument('--require-case-card', action='store_true')
parser.add_argument('--require-token-report', action='store_true')
args = parser.parse_args()

case = Path(args.case)
if not case.exists():
    print(f'[FAIL] Case folder not found: {case}')
    raise SystemExit(1)

required = ['AI_Request.md', 'Scenario.md', 'AI_Risk_Level.md']
if args.risk == 'green':
    required += ['Task.md', 'Test.md', 'Verify.md']
elif args.risk == 'yellow':
    required += ['Solution.md', 'Task.md', 'Test.md', 'Verify.md']
elif args.risk == 'red':
    required += ['Solution.md']

if args.strict:
    if args.risk in ['green','yellow']:
        required += ['PR_Template.md']
    required += ['AI_Case_Card.md', 'Token_Usage_Report.md']

if args.require_case_card and 'AI_Case_Card.md' not in required:
    required.append('AI_Case_Card.md')
if args.require_token_report and 'Token_Usage_Report.md' not in required:
    required.append('Token_Usage_Report.md')

missing = [f for f in required if not (case / f).exists()]
if missing:
    print('[FAIL] Missing required files:')
    for f in missing:
        print(f'  - {f}')
    raise SystemExit(1)
print(f'[OK] AI case validation passed: {case}')
