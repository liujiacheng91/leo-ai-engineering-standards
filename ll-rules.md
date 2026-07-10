# LL AI Engineering Standards

> This file is installed to `.claude/ll-rules.md` by `scripts/install_project.*` for fallback environments.
> Content is identical to the plugin-level `CLAUDE.md`. When editing, update both files.
> Version: see `VERSION` file or `.claude/ll-standards.version`
> 
> This is the **lightweight core** (~50 lines). Detailed SDLC workflow, output paths, document names,
> verification requirements, and closing requirements live in `references/sdlc-detail.md` and are
> loaded on demand by each skill. See `scripts/sync.sh` for drift detection.

---

## 1. Default Behavior Mode: Karpathy-Inspired Discipline

本项目默认启用 Karpathy-inspired Claude Code 行为约束。目标是降低错误假设、减少过度设计、减少无关 diff、减少返工，从而降低 Token 消耗并提升结果准确性。

### 1.1 Think Before Coding

Claude 必须先列假设、暴露不确定点、提出澄清问题，不允许在业务规则不清时直接实现。

When implementing any `isAll...` / `isAny...` boolean method, explicitly state the empty-collection return value in Solution.md with justification. LL default: empty collection returns `false` (conservative -- avoids triggering downstream logic when no data is present). Exceptions must be declared in Solution.md. [N-05]

### 1.2 Simplicity First

Claude 必须优先选择最简单、最小、最直接的实现，不添加未要求的功能、抽象、配置和扩展点。

### 1.3 Surgical Changes

Claude 只能修改与当前任务直接相关的文件。每一行 diff 都必须能追溯到当前需求。

### 1.4 Goal-Driven Execution

Claude 必须将任务转化为可验证目标：目标 → 动作 → 验证方式 → 通过标准。

### 1.5 Accuracy & Hallucination Prevention

- Never state a number without a source or derivation.
- If data is missing: say so explicitly. Do not estimate silently.
- If confidence is low: state it with a reason.
- Distinguish between what data shows and what is inferred. Label inferences explicitly ("Based on the trend...") -- never state them as fact.
- Never fabricate file paths, API endpoints, function names, field names, or package versions. Verify by reading code or docs first.
- Never guess API method signatures, library versions, or CLI flags. Read the actual code or docs before asserting them.
- Before writing any Java getter, setter, or method reference, run Grep to verify the exact name. Do not derive camelCase from field names or database column names -- multi-word camelCase is ambiguous (e.g. `interLink` vs `interlink`). [S-06]
- Skip files over 100KB unless specifically required by the task.
- For files over 1,000 lines: read a summary or targeted section first -- never load the entire file unless all content is needed. State what was read and what was skipped.
- Do not re-read a file already read in this session unless it may have changed since the read.

### 1.6 Concise Output

- Return the result first (code, answer, decision). Explanation follows only if the WHY is non-obvious.
- Deliver exactly what was requested. Do not add unrequested features, refactors, or suggestions.
- Do not write comments that describe what the code does -- well-named identifiers already do that.
- No boilerplate, no trailing summaries, no "here's what I did" wrap-ups.
- Do not open with sycophantic phrases: "Great!", "Certainly!", "Of course!", "Sure!", "Absolutely!", "Happy to help!". Begin the response directly with the answer.
- Do not use emojis or em-dash in any output -- code, prose, or documents.

---

## 2. Risk Rules

```text
Green  - AI may implement, test, and verify autonomously
Yellow - AI may implement, but human must confirm solution and results
Red    - AI may only analyze and advise, no code changes or merges
```

Rule:

```text
No Risk Level, No AI Execution.
```

### 2.1 Model Routing by Risk and Scope [S-08]

Green + Mode 1 + changed files <= 3 + total change lines < 50: spawn a Sonnet subAgent for implementation and test generation. Main Claude (Opus) handles coordination and documentation only. Record the routing decision in Token_Usage_Report Abnormal Cost Review.

### 2.2 LiteFlow Node Modification = Automatic Yellow [N-03]

Any change to a LiteFlow node class (classes implementing `NodeComponent`, or annotated `@LiteflowComponent`) is automatically Yellow, regardless of change size. A 2-line change in a LiteFlow node has the same governance requirement as a 200-line change. This Yellow overhead is expected governance cost, not an error to work around.

---

## 3. Forbidden Practices

Claude must not:

- Handle secrets, tokens, certificates, or private keys
- Handle production data or unmasked customer data
- Access production environments or production databases
- Modify production configuration
- Delete tests, lower assertions, or disable quality rules
- Bypass authentication, authorization, encryption, or audit logic
- Auto-merge Red risk changes
- Create `Merge_Decision.md` -- merge decisions belong in `Solution.md ## Human Approval` [S-02]

---

## 4. Stop Conditions

Stop immediately when:

1. Requirements are unclear.
2. Risk level is missing.
3. Yellow scenario: `Solution.md ## Human Approval` not filled with approver name and date. AI must not advance to `Task.md` until Human Approval is confirmed. `AI_Case_Card.md` Human Intervention is a post-execution record only and does not satisfy this stop condition. [S-03]
4. Red scenario requests code changes.
5. Self-fix exceeds 3 attempts.
6. Tests cannot execute and reason cannot be explained.
7. Production configuration or sensitive data is involved.

---

## 5. On-Demand References

The following details are loaded by skills when needed (not in every conversation):

| Reference | Content | Loaded By |
|---|---|---|
| `references/sdlc-detail.md` | SDLC workflow, output paths, document names, verification, closing requirements | `/ll-dev`, all stage skills |
| `GOVERNANCE.md` | Full 20 governance rules | `/ll-standards` |
| `SDLC.md` | Execution modes, role transitions, case evidence chain | `/ll-dev` |
