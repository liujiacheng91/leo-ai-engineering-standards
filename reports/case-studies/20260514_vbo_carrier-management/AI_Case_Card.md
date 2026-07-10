# AI_Case_Card.md

## Basic Info

- Case ID: 20260514_vbo_carrier-management
- Team: vbo
- Project: vbo-plus
- Scenario: Carrier Management — MSO Follow Up (Sea Freight Quotation & Confirmation)
- Risk Level: Yellow
- AI Tool: Claude Code
- Model: Claude Opus 4.6
- Owner: dara.heng@transpeed.com.sg

## Outcome

- Original Estimate: 3-4 days (manual development)
- Actual Time: ~1 hour (AI-assisted)
- Saved Time: ~25 hours
- Token Cost: See Token_Usage_Report.md
- Result: Pass — BUILD SUCCESS, 39/39 unit tests pass
- Reusable: Yes — MailService utility, DDD-lite pattern, status workflow template

## Human Intervention

| Point | Reason | Decision | Owner |
|---|---|---|---|
| Solution review | Yellow risk requires human confirmation | Approved | User |
| User entity field | `getUserName()` not found, entity uses `getUserId()` | Fixed to `getUserId()` | AI |
| Java 11 compat | `String.repeat()` not available in compile target | Replaced with loop | AI |

## Lessons Learned

- What worked: Ticket-provided SQL queries were directly usable in MyBatis XML with minimal adaptation. DDD-lite layered pattern from existing codebase made new domain module structure predictable. MapStruct assembler + Lombok reduced boilerplate significantly.
- What failed: Assumed `String.repeat()` available (Java 11 method but compile target may restrict). Assumed User entity had `userName` field — needed to verify entity structure first.
- What to improve: Always read target entity classes before referencing their fields. Check Java language level compatibility for string utility methods in tests.
