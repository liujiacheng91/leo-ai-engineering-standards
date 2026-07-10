# AI_Risk_Level.md

## Risk Level

```text
Yellow
```

## Risk Decision Summary

This is a multi-file feature spanning DDL, DML, domain entities, mappers (with complex CTE-based SQL), services, controllers, DTOs, mail integration, and permission-based access control. While no production data is accessed and the feature is self-contained within a new bounded context, the complexity of the SQL queries, status workflow business rules, and role-based permission enforcement warrant human review of the solution and results.

## Risk Factors

- [ ] Production config involved
- [ ] Production data involved
- [ ] Customer sensitive data involved
- [x] Auth / Authorization involved
- [ ] Encryption / Security involved
- [ ] Audit involved
- [x] DB schema involved
- [x] Core business rules involved
- [ ] Mapping / transformation involved
- [x] SQL / reporting involved
- [ ] Multi-service call involved

## Allowed AI Actions

- [x] Analysis only
- [x] Generate documents
- [x] Generate test cases
- [x] Implement code
- [x] Run verification
- [x] Generate PR summary

## Required Human Confirmation

| Role | Required | Confirmed By | Date |
|---|---|---|---|
| Business Owner | Yes |  |  |
| Tech Lead | Yes |  |  |
| Security | No |  |  |
| DBA | Yes |  |  |

## Stop Conditions

1. Complex SQL query logic deviates from ticket-provided SQL
2. Status workflow rules are ambiguous or contradictory
3. Permission model conflicts with existing Sa-Token setup
4. Email configuration requires production SMTP credentials
5. Self-repair exceeds 3 attempts on any single task

## Final Approval

- Approved by:
- Date:
- Notes:
