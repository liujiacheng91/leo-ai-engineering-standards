# Bug Fix Short Flow

> Workflow composition for bug fixes. Use when the primary task is fixing a confirmed bug.  
> Not for: new feature development, mixed feature + bug fix, or Red risk security vulnerabilities.

## Trigger

Start with `/ll-dev` and declare the case type as "Bug Fix" in AI_Request.md.

## Flow (5 steps)

```text
AI_Request.md -> Solution.md (root cause + fix) -> Implementation -> Verify.md (regression check) -> AI_Case_Card.md
```

## Step Details

### Step 1: AI_Request.md
- Declare case type: `Bug Fix`
- Include: bug description, reproduction steps, expected vs actual behavior
- If root cause is already known: state it with evidence

### Step 2: Solution.md (Root Cause + Fix)
Required sections beyond standard Solution.md:
- **Root Cause Analysis**: what caused the bug, why existing tests didn't catch it
- **Fix Description**: minimal change to correct the behavior
- **Regression Prevention**: what test or check proves this won't recur
- Standard technical constraints still apply

### Step 3: Implementation
- Hard Enforcement Layer applies (read-before/write-before/response-before gates)
- Self-fix limit: 3 attempts

### Step 4: Verify.md (Regression Check)
Key focus areas:
- [ ] Root cause is addressed (not just symptom)
- [ ] Regression test exists or existing test was updated
- [ ] No behavior change to unrelated code paths
- [ ] If the bug was in production: assess blast radius

### Step 5: AI_Case_Card.md
Standard AI_Case_Card.md requirements apply (§5.1).

## Omitted Documents

The following are intentionally omitted from Bug Fix flow:
- Scenario.md (bug is already scoped)
- Task.md (single fix, no decomposition needed)
- Test.md (regression test is documented in Verify.md)
- PR_Template.md (verify serves as PR description)
- Token_Usage_Report.md (optional for Green + < 50 line changes)

## When NOT to Use This Flow

- **New feature + bug fix mixed**: use standard 9-stage flow
- **Red risk security vulnerability**: use Red analysis-only path
- **Bug requires > 3 files changed**: use standard 9-stage flow (architecture risk)
- **Bug requires data migration**: use standard flow (add Mapping_Rules.md)
- **Unknown root cause**: use standard flow (needs Scenario.md for investigation)

## Token Budget

Target: 30K-80K (vs 50K-150K for standard Mode 1).
Retry target: 0-1.
