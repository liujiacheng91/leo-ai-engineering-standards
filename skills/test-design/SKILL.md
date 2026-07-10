---
name: test-design
description: Generate Test.md with normal boundary negative regression and data comparison cases.
---

# Test Design Skill

Generate `Test.md`. Cover normal, boundary, negative, regression and manual/UAT cases as applicable.

## Mandatory Sections

`Test.md` must include all of the following sections before implementation begins. Missing any section is a stop condition.

| Section | Purpose | When Required |
|---|---|---|
| Test Scope | What is in scope and explicitly out of scope | Always |
| Test Data | Inputs, boundary values, abnormal values with expected outputs | Always |
| Mock Strategy | Mock framework, objects to mock, stub setup, Mockito strictness decision | Always |
| Boundary Cases | Empty / null / max values / concurrent / duplicate-submit scenarios | Always |
| API Test Cases | API endpoint, method, auth, request/response, error codes | When REST API is involved |
| Permission & Security Checklist | Auth bypass, role escalation, SQL injection, XSS, data masking | When permissions or sensitive data involved |
| Fix History | Populated after each Self-Fix — root cause + prevention rule | Always |

## Mock Strategy Rules

Fill the Mock Strategy section before writing any test code:

- primitive type parameters (`int`, `long`, `boolean`) → use `anyInt()` / `anyLong()` / `anyBoolean()`, never `any()`
- Shared stubs in `@BeforeEach` not used by all tests → add `@MockitoSettings(strictness = Strictness.LENIENT)` on the class
- No Mockito precedent in the repo → record the strictness decision in `Solution.md` before coding begins; do not discover it after merge

## API Test Rules

When the case involves REST API endpoints, fill the API Test Cases section before writing test code:

- Cover all CRUD endpoints + key business operations
- Include both success path (2xx) and error path (4xx/5xx) for each endpoint
- Test with valid auth, invalid auth, and no auth
- Fill the Error Code Coverage table for all documented error scenarios

## Permission & Security Rules

When the case involves role-based access or sensitive data, fill the Permission & Security Checklist:

- Test every role in the Permission Matrix against every operation
- Verify cross-tenant data isolation if multi-tenant
- SQL injection and XSS checks are mandatory for any user-facing input
- Check logs and API responses for sensitive data leakage

## AC Traceability Rule

Before finalizing Test.md, cross-check against Scenario.md:

- Every AC ID in Scenario.md must appear in at least one Test Matrix row's "Related AC" column
- If an AC has no corresponding test case, either add one or explicitly note it as "out of test scope" with reason
- This check costs zero extra tokens — both files are already in context during test design

## Fix History Rule

After every Self-Fix, complete these steps in order before proceeding:

1. Append a row to the Fix History table (Symptom, Root Cause, Fix Action, Prevention Rule)
2. **Immediately apply the Prevention Rule to the target file** — write the actual text into `CLAUDE.md` / `Test.md` / `Solution.md` as specified in the Prevention Rule column. Do not defer this to a later step.
3. If the prevention rule applies to a reference copy under `skills/*/references/`, sync that copy too (GOVERNANCE Rule 17)

The atomic cycle is: fix code → record Fix History → apply prevention rule → proceed. Skipping step 2 causes the same class of error to recur in the next case.

For detailed standalone root cause analysis, use `templates/QA_Retry_Root_Cause.md`.
