# Scenario.md

## Scenario Name

Carrier Management — MSO Follow Up (Sea Freight Quotation & Confirmation)

## Business Background

For sea freight business, the SZ Team handles quotation and vessel schedule entry. Customers review and confirm/reject quotations. Quotation data is sensitive and must be access-controlled.

## Current Problem

No carrier management quotation workflow exists in vbo-plus. SZ Team has no system to enter quotations linked to MSO bookings, and customers have no way to confirm/reject them with audit trails.

## Expected Outcome

A complete Carrier Management module under the IFF function module that:
1. Allows SZ Team to create/edit quotations linked to MSO bookings
2. Allows Customers to confirm/reject quotations
3. Supports status workflow: Draft -> Pending to Confirm -> Confirmed / Rejected
4. Sends email notifications on submit and confirm/reject
5. Provides paginated search with status count statistics
6. Supports Excel export of search results

## In Scope

- DDL: TB_MSO_FOLLOW_UP, TB_LOG_MSO_FOLLOW_UP tables + sequences
- DML: Menu, function, domain label registration under IFF module
- Backend API: Search (with status counts), Create, Update, View detail, Export, Booking lookup
- Domain layer: MsoFollowUp entity, PO, mapper, service
- Application layer: MsoFollowUpApplicationService
- Interface layer: Controller, DTOs, Query objects
- Mail utility: Configurable SMTP mail sender
- Unit tests for domain service

## Out of Scope

- Frontend/UI implementation
- Production database execution of DDL/DML
- Custom email templates (placeholder content for now)
- Integration with external notification systems

## Acceptance Criteria

| AC ID | Acceptance Criteria | Verification Method |
|---|---|---|
| AC-001 | SZ Team can create a follow-up linked to an MSO booking with Draft or Pending status | Unit test + API test via Swagger |
| AC-002 | SZ Team can edit Draft/Pending/Rejected follow-ups; Confirmed is read-only | Unit test |
| AC-003 | Customer can Confirm or Reject a Pending follow-up with audit log | Unit test |
| AC-004 | Paginated search returns results with correct status count statistics | Unit test + Swagger |
| AC-005 | Excel export downloads all matching records (not just current page) | Swagger manual test |
| AC-006 | Booking lookup returns only SEA/FINALIZED MSOs not already in TB_MSO_FOLLOW_UP | Unit test |
| AC-007 | Email notification triggers on submit (Pending) and on Confirm/Reject | Unit test (mock SMTP) |
| AC-008 | Permission checks enforce SZ Team vs Customer function boundaries | Sa-Token annotation test |
| AC-009 | At least one container type quotation is required; container types cannot repeat | Unit test |
| AC-010 | ETA must be >= ETD; costs must be >= 0 | Unit test |
| AC-011 | Maven build succeeds with all tests passing | `mvn clean package` |

## Suggested Risk Level

```text
Yellow
```

## Required Additional Documents

- [ ] Business_Rules.md
- [ ] Mapping_Rules.md
- [x] Solution.md
- [x] Test.md
