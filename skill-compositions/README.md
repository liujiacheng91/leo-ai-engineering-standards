# Skill Compositions

Skill 组合用于不同类型需求的推荐调用链。

## Available Compositions

| Composition | Use Case | Steps | Token Target |
|---|---|---|---|
| `simple-green-flow.md` | Green risk, new feature, single concern, < 30 lines | 5 steps (Minimal Path) | 50K-150K |
| `bug-fix-short-flow.md` | Bug fix, Green/Yellow, confirmed root cause | 5 steps | 30K-80K |
| `refactor-short-flow.md` | Rename, extract, move, behavior-preserving | 4 steps | 20K-60K |
| `mapping-yellow-flow.md` | Yellow risk, field mapping, EDI, customer rules | Full 9-stage with Mapping_Rules.md | 80K-200K |
| `verification-review-flow.md` | Post-implementation review, quality audit | Verification + PR + Case Card | 20K-40K |

## Flow Selection Guide

```text
Is this a new feature?
├── Yes → Is it Green + < 30 lines + single concern?
│   ├── Yes → simple-green-flow.md
│   └── No  → Standard /ll-dev (full 9-stage)
└── No  → Is it a bug fix?
    ├── Yes → bug-fix-short-flow.md
    └── No  → Is it a refactor?
        ├── Yes → refactor-short-flow.md
        └── No  → Is it field mapping / EDI?
            ├── Yes → mapping-yellow-flow.md
            └── No  → Standard /ll-dev (full 9-stage)
```
