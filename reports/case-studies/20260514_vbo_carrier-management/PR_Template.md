# Pull Request Template

## Summary

Implement Carrier Management (MSO Follow Up) feature for sea freight quotation workflow under the IFF module.

- SZ Team creates/edits quotations linked to MSO bookings (Draft / Pending to Confirm)
- Customer confirms or rejects quotations with audit logging
- Paginated search with status count statistics, Excel export, booking lookup
- Email notifications on submit, confirm, and reject
- Sa-Token permission control (CARRIER_SELECT, CARRIER_CREATE, CARRIER_EXPORT, CARRIER_CONFIRM)
- 2 new Oracle tables (TB_MSO_FOLLOW_UP, TB_LOG_MSO_FOLLOW_UP) with sequences
- Menu and function registration under IFF module (4 languages)
- Reusable MailService utility with SMTP configuration

## Related Documents

- [AI_Request.md](docs/ai/cases/20260514_vbo_carrier-management/AI_Request.md)
- [Scenario.md](docs/ai/cases/20260514_vbo_carrier-management/Scenario.md)
- [AI_Risk_Level.md](docs/ai/cases/20260514_vbo_carrier-management/AI_Risk_Level.md)
- [Solution.md](docs/ai/cases/20260514_vbo_carrier-management/Solution.md)
- [Task.md](docs/ai/cases/20260514_vbo_carrier-management/Task.md)
- [Test.md](docs/ai/cases/20260514_vbo_carrier-management/Test.md)
- [Verify.md](docs/ai/cases/20260514_vbo_carrier-management/Verify.md)

## AI Assistance

- Tool: Claude Code
- Model: Claude Opus 4.6
- Risk Level: Yellow
- Token Cost: See Token_Usage_Report.md

## Validation

- [x] Build
- [x] Unit Test (39 tests, 0 failures)
- [ ] Integration Test (pending API test)
- [ ] Lint (not configured)
- [ ] Security Scan (not configured)
- [x] Secrets Scan (no secrets in code)

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

- DDL/DML scripts in `sql/ticket/175956/` — require DBA review before execution
- Mail SMTP config uses environment variables (`MAIL_HOST`, `MAIL_PORT`, etc.) with defaults from ticket spec
- Complex CTE search queries in `MsoFollowUpMapper.xml` are directly from ticket-provided SQL
- Status workflow enforced at domain service level; Confirmed records are immutable
- `@Autowired(required = false)` on MailService — gracefully degrades if mail not configured
