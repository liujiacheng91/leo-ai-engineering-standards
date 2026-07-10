---
name: scenario-analysis
description: Generate Scenario.md and clarify missing business input before solution or coding.
---

# Scenario Analysis Skill

Generate `Scenario.md` under `docs/ai/cases/<case-id>/`.

Rules:

1. Do not write code.
2. Ask questions if business rules, examples, or acceptance criteria are missing.
3. If mapping or SQL logic appears, require Mapping_Rules.md or Business_Rules.md.
4. Suggest initial Green / Yellow / Red risk level.
5. If the scenario involves state machine, permissions, multi-entity relationships, or notification rules, request the BA to fill the `## Business Model Input` section in Scenario.md before proceeding to Solution.md. This section is mandatory for complex business scenarios and optional for simple CRUD or bug fixes.

## RA Draft Quality Gate

Before handing off to TA review, all items in the following checklist must be explicitly confirmed. Do not hand off if any item is uncertain — resolve it first.

- [ ] All business rules have a clear data source (table / interface / document). No inference.
- [ ] Boundary conditions and exception paths are explicitly defined. No "TBD" or "to be confirmed".
- [ ] Each AC (acceptance criterion) maps to at least one requirement. No gaps.
- [ ] Known issues are listed with explicit in-scope / out-of-scope status for this case.
- [ ] Affected files / modules are listed. No guesses.

If TA returns > 5 must-fix items after handoff: record as "RA quality deviation" in `AI_Case_Card.md` Lessons Learned, and note the root cause (which assumption was not verified, which AC was ambiguous).

This gate exists because unresolved assumptions at the RA stage are amplified through Solution → Test → Verify, multiplying token cost and Retry count.
