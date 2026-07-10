# Refactor Short Flow

> Workflow composition for behavior-preserving structural changes.  
> Use when: rename, extract method, move class, simplify conditional, or equivalent.  
> Not for: changes that alter behavior, add features, or fix bugs.

## Trigger

Start with `/ll-dev` and declare the case type as "Refactor" in AI_Request.md.

## Flow (4 steps)

```text
AI_Request.md (before/after behavior assertion) -> Solution.md (inline) -> Implementation -> Verify.md (diff review)
```

## Step Details

### Step 1: AI_Request.md
- Declare case type: `Refactor`
- Must include: **Behavior Unchanged Assertion** with before/after signatures
  ```text
  Before: `public List<Item> getItems(String filter)` returns filtered list
  After:  `public List<Item> getItems(String filter)` returns filtered list (unchanged)
  ```
- List files to be changed and the refactoring technique (rename, extract, move, inline)

### Step 2: Solution.md (Inline)
- No separate design phase — code changes are the solution
- Include: impact analysis (which callers are affected)
- Skip: Technical Constraints (unless toolchain/environment is changing)

### Step 3: Implementation
- Hard Enforcement Layer applies
- Key constraint: each commit/patch must be a single refactoring step
- Verify existing tests still pass after each step

### Step 4: Verify.md (Diff Review)
Key focus areas:
- [ ] All existing tests pass without modification (unless test was testing implementation detail)
- [ ] Diff is purely structural (no behavior logic added/removed)
- [ ] No new imports added (unless required by refactoring movement)
- [ ] Callers updated if signature changed
- [ ] No dead code left behind (old method after extract, old class after move)

## Omitted Documents

The following are intentionally omitted from Refactor flow:
- Scenario.md (no new business logic)
- AI_Risk_Level.md (always Green — if risk exists, it's not a refactor)
- Task.md (refactoring steps are self-documenting in diff)
- Test.md (existing tests serve as correctness check)
- PR_Template.md (verify serves as PR description)
- Token_Usage_Report.md

## When NOT to Use This Flow

- **Behavior is changing**: use standard flow or Bug Fix flow
- **Refactor + feature in same PR**: use standard 9-stage flow
- **Public API change**: use standard flow (needs Scenario.md for breaking change assessment)
- **Database schema refactor**: use standard flow (add Mapping_Rules.md)
- **Refactor touching > 10 files**: use standard flow with Mode 3

## Token Budget

Target: 20K-60K.
No retry expected — if the refactor fails existing tests, stop and re-assess.
