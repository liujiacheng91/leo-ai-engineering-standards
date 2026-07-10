# Solution.md

## Solution Overview

Implement a Carrier Management (MSO Follow Up) module under the IFF function area. The module provides sea freight quotation creation by SZ Team, review/confirmation by Customers, with full status workflow, email notifications, Excel export, and role-based permission control.

## Impact Analysis

### Affected Modules

| Module | Change Type | Description |
|---|---|---|
| vbo-plus-service | New code | Controller, DTOs, services, domain entities, mappers |
| vbo-plus-service | Config update | Mail configuration in application YAML files |

### Affected Files (New)

**Domain Layer** (`domain/mso/followup/`):
- `repository/po/MsoFollowUpPo.java` — PO mapping TB_MSO_FOLLOW_UP
- `repository/po/MsoFollowUpLogPo.java` — PO mapping TB_LOG_MSO_FOLLOW_UP
- `repository/mapper/MsoFollowUpMapper.java` — MyBatis mapper interface
- `repository/mapper/MsoFollowUpLogMapper.java` — Log mapper interface
- `entity/MsoFollowUp.java` — Domain entity
- `entity/MsoFollowUpLog.java` — Log domain entity
- `service/MsoFollowUpDomainService.java` — Domain service interface
- `service/impl/MsoFollowUpDomainServiceImpl.java` — Domain service implementation

**Application Layer** (`application/`):
- `service/MsoFollowUpApplicationService.java` — Application service interface
- `service/impl/MsoFollowUpApplicationServiceImpl.java` — Application service implementation
- `assembler/MsoFollowUpAssembler.java` — MapStruct assembler

**Interface Layer** (`interfaces/mso/followup/`):
- `controller/MsoFollowUpController.java` — REST controller
- `dto/MsoFollowUpCreateDto.java` — Create request DTO
- `dto/MsoFollowUpUpdateDto.java` — Update request DTO
- `dto/MsoFollowUpConfirmRejectDto.java` — Confirm/Reject request DTO
- `query/MsoFollowUpQuery.java` — Main search query
- `query/MsoBookingQuery.java` — Booking lookup query
- `vo/MsoFollowUpListVo.java` — Search result list VO
- `vo/MsoFollowUpDetailVo.java` — Detail view VO
- `vo/MsoFollowUpStatusCountVo.java` — Status count statistics VO
- `vo/MsoBookingListVo.java` — Booking lookup result VO

**Common** (`common/`):
- `enums/MsoFollowUpStatus.java` — Status enum (DRAFT, PENDING_TO_CONFIRM, CONFIRMED, REJECTED)
- `util/MailService.java` — Reusable SMTP mail utility

**Config** (`config/`):
- `MailConfig.java` — Spring mail configuration

**Resources**:
- `mapper/mso/MsoFollowUpMapper.xml` — MyBatis XML with complex CTE queries
- `mapper/mso/MsoFollowUpLogMapper.xml` — Log mapper XML

**SQL Scripts**:
- `sql/ticket/175956/010-175956-DDL.sql` — Tables, sequences
- `sql/ticket/175956/020-175956-DML.sql` — Menu, function, domain label registrations

**Tests**:
- `src/test/java/.../MsoFollowUpDomainServiceImplTest.java`

### Affected APIs

| Method | Path | Description | Permission |
|---|---|---|---|
| POST | /mso-follow-up/search | Paginated search with status counts | IFF:CARRIER_MGMT:CARRIER_SELECT |
| GET | /mso-follow-up/{id} | Get detail by ID | IFF:CARRIER_MGMT:CARRIER_SELECT |
| POST | /mso-follow-up/create | Create new follow-up | IFF:CARRIER_MGMT:CARRIER_CREATE |
| PUT | /mso-follow-up/update | Update existing follow-up | IFF:CARRIER_MGMT:CARRIER_UPDATE |
| POST | /mso-follow-up/confirm | Confirm (Customer) | IFF:CARRIER_MGMT:CARRIER_CONFIRM |
| POST | /mso-follow-up/reject | Reject (Customer) | IFF:CARRIER_MGMT:CARRIER_REJECT |
| POST | /mso-follow-up/export | Export to Excel | IFF:CARRIER_MGMT:CARRIER_EXPORT |
| POST | /mso-follow-up/booking/search | Booking lookup for create | IFF:CARRIER_MGMT:CARRIER_SELECT |
| GET | /mso-follow-up/currency | Currency list from VW_CURRENCY | IFF:CARRIER_MGMT:CARRIER_SELECT |

### Affected Database Objects

| Object | Type | Action |
|---|---|---|
| TB_MSO_FOLLOW_UP | Table | CREATE |
| TB_LOG_MSO_FOLLOW_UP | Table | CREATE |
| SQ_MSO_FOLLOW_UP | Sequence | CREATE |
| SQ_LOG_MSO_FOLLOW_UP | Sequence | CREATE |
| TB_MENU (row) | Data | INSERT (Carrier Management menu) |
| TB_FUNCTION (rows) | Data | INSERT (4 function codes) |
| TB_DOMAIN_LABEL (rows) | Data | INSERT (multi-language labels) |

### Affected Configurations

| File | Change |
|---|---|
| application.yml | Add `spring.mail` SMTP configuration block |
| application-local.yml | Add local SMTP settings |

## Recommended Solution

### 1. Database Schema

Create TB_MSO_FOLLOW_UP with all quotation fields (booking no, contract, vessel, voyage, ETD/ETA, 3 container type groups with cost/unit, email, status, remarks) plus audit columns. Create TB_LOG_MSO_FOLLOW_UP for confirm/reject action logging. Use Oracle sequences for ID generation.

### 2. Status Workflow

```
[Create] --save as draft--> DRAFT --edit & save--> PENDING_TO_CONFIRM
[Create] --save---------->  PENDING_TO_CONFIRM
DRAFT    --edit & save--->  PENDING_TO_CONFIRM
PENDING  --SZ edit------->  PENDING_TO_CONFIRM
PENDING  --Customer Confirm--> CONFIRMED (terminal, read-only)
PENDING  --Customer Reject-->  REJECTED
REJECTED --SZ edit & draft--> DRAFT
REJECTED --SZ edit & save-->  PENDING_TO_CONFIRM
```

### 3. Search Query Strategy

Use the ticket-provided CTE SQL directly in MyBatis XML. The main search joins TB_MSO_FOLLOW_UP with TB_MSO (via BOOKING_NO = MSO_NO), then to WEIGHT_VOL, CONTAINER, PO CTEs. Booking lookup uses the same SQL but filters `WHERE tm.TRANSPORT_MODE='SEA' AND tm.OP_STATUS='FINALIZED'` and excludes records already in TB_MSO_FOLLOW_UP.

### 4. Permission Model

Register under IFF module:
- FUNCTION_AREA_CODE: `CARRIER_MGMT`
- FUNCTION_GROUP_CODE: `CARRIER_MGMT`
- FUNCTION_CODEs: `CARRIER_SELECT`, `CARRIER_EXPORT`, `CARRIER_CREATE` (covers Add/Update for SZ Team), `CARRIER_CONFIRM` (covers Confirm/Reject for Customer)

### 5. Mail Utility

Create a reusable `MailService` configured via `spring.mail.*` properties. Method signature: `send(String from, List<String> toList, List<String> ccList, List<String> bccList, String subject, String text)`. Log success/failure.

## Security Considerations

- Quotation costs are sensitive — enforce Sa-Token permission checks on all endpoints
- Confirmed records are immutable — service layer must reject updates to CONFIRMED status
- Email addresses validated before sending
- No production credentials in code — SMTP config via YAML profiles

## Test Strategy

- Unit tests: Domain service (status transitions, validation rules, CRUD logic)
- Mock SMTP for email tests
- Integration: Manual Swagger API testing for search, create, export flows
- Build verification: `mvn clean package` must pass

## Rollback Plan

All changes are additive (new files, new tables). Rollback:
1. Drop TB_MSO_FOLLOW_UP, TB_LOG_MSO_FOLLOW_UP, sequences
2. Delete menu/function/domain_label rows
3. Revert code changes (git revert)

## Human Approval

- Approved by:
- Date:
