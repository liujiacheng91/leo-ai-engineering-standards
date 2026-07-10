---
name: risk-assessment
description: Generate AI_Risk_Level.md and assess Green Yellow Red risk before AI execution.
---

# Risk Assessment Skill

Generate `AI_Risk_Level.md` under `docs/ai/cases/<case-id>/`.

Rules:

1. No Risk Level, No AI Execution.
2. Red scenarios are analysis-only.
3. Yellow requires human confirmation.
4. Green requires clear input and runnable verification.
5. Output allowed AI actions and required human approvals.
