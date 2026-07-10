# Test.md

## Test Objective

Verify the Carrier Management (MSO Follow Up) feature: status workflow correctness, validation rules, CRUD operations, permission boundaries, search/export logic, and email notification triggers.

## Test Types

- [x] Unit Test
- [ ] Integration Test
- [ ] API Contract Test
- [ ] UI Test
- [ ] E2E Test
- [ ] Regression Test
- [ ] Security Test
- [x] Manual Verification

## Test Matrix

### 1. Create Follow-Up (Normal)

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-001 | Unit | Valid create DTO, save as Draft | Status=DRAFT, record persisted, no email sent | P0 | AC-001 |
| TC-002 | Unit | Valid create DTO, save as Pending | Status=PENDING_TO_CONFIRM, email triggered | P0 | AC-001, AC-007 |
| TC-003 | Unit | Create with all 3 container types filled | All 3 groups saved correctly | P1 | AC-001 |
| TC-004 | Unit | Create with only container type 1 filled | Saved with 1 group, type 2/3 null | P1 | AC-001 |

### 2. Create Follow-Up (Boundary & Negative)

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-005 | Unit | Missing Contract (required field) | Validation error thrown | P0 | AC-010 |
| TC-006 | Unit | Missing Vessel Name | Validation error thrown | P0 | AC-010 |
| TC-007 | Unit | Missing Voyage | Validation error thrown | P0 | AC-010 |
| TC-008 | Unit | ETD is null | Validation error thrown | P0 | AC-010 |
| TC-009 | Unit | ETA < ETD | BusinessException: ETA must be >= ETD | P0 | AC-010 |
| TC-010 | Unit | ETA = ETD | Accepted (boundary) | P1 | AC-010 |
| TC-011 | Unit | No container type groups filled | BusinessException: at least 1 container type required | P0 | AC-009 |
| TC-012 | Unit | Container Type 1 = Container Type 2 (duplicate) | BusinessException: container types must be unique | P0 | AC-009 |
| TC-013 | Unit | Container Type 1 Cost < 0 | BusinessException: cost must be >= 0 | P0 | AC-010 |
| TC-014 | Unit | Container Type 1 Cost = 0 | Accepted (boundary) | P1 | AC-010 |
| TC-015 | Unit | Contract length > 50 chars | Validation error thrown | P1 | AC-010 |
| TC-016 | Unit | Email format invalid (no @) | BusinessException: invalid email format | P1 | AC-001 |
| TC-017 | Unit | Multiple emails separated by ; | Accepted, all parsed correctly | P1 | AC-001 |
| TC-018 | Unit | Booking No already in TB_MSO_FOLLOW_UP | BusinessException: duplicate booking | P0 | AC-001 |

### 3. Update Follow-Up (Status Workflow)

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-019 | Unit | Update Draft -> save as Draft | Status remains DRAFT | P0 | AC-002 |
| TC-020 | Unit | Update Draft -> save as Pending | Status=PENDING_TO_CONFIRM, email sent | P0 | AC-002, AC-007 |
| TC-021 | Unit | Update Pending -> save as Pending (SZ Team edit) | Status remains PENDING_TO_CONFIRM | P0 | AC-002 |
| TC-022 | Unit | Update Rejected -> save as Draft | Status=DRAFT | P0 | AC-002 |
| TC-023 | Unit | Update Rejected -> save as Pending | Status=PENDING_TO_CONFIRM, email sent | P0 | AC-002, AC-007 |
| TC-024 | Unit | Update Confirmed record | BusinessException: confirmed record is read-only | P0 | AC-002 |

### 4. Confirm / Reject (Customer Actions)

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-025 | Unit | Confirm a Pending record | Status=CONFIRMED, log record created, email sent | P0 | AC-003, AC-007 |
| TC-026 | Unit | Reject a Pending record with Remarks | Status=REJECTED, log with remarks created, email sent | P0 | AC-003, AC-007 |
| TC-027 | Unit | Reject a Pending record without Remarks | BusinessException: remarks required for reject | P0 | AC-003 |
| TC-028 | Unit | Confirm a Draft record | BusinessException: can only confirm Pending status | P0 | AC-003 |
| TC-029 | Unit | Confirm a Confirmed record | BusinessException: already confirmed | P1 | AC-003 |
| TC-030 | Unit | Confirm a Rejected record | BusinessException: can only confirm Pending status | P1 | AC-003 |
| TC-031 | Unit | Reject a Draft record | BusinessException: can only reject Pending status | P1 | AC-003 |
| TC-032 | Unit | Confirm with optional Remarks | Status=CONFIRMED, remarks saved in log | P1 | AC-003 |

### 5. Search & Status Count

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-033 | Unit | Search with customer ID only | Returns paginated results | P0 | AC-004 |
| TC-034 | Unit | Search with status filter = DRAFT | Only Draft records returned | P0 | AC-004 |
| TC-035 | Unit | Search with booking date range | Filtered by date range | P1 | AC-004 |
| TC-036 | Unit | Search with ETD range | Filtered by ETD range | P1 | AC-004 |
| TC-037 | Unit | Search with ETA range | Filtered by ETA range | P1 | AC-004 |
| TC-038 | Unit | Search with contract text | Filtered by contract like match | P1 | AC-004 |
| TC-039 | Unit | Status count matches search filters | Counts per status consistent with search criteria | P0 | AC-004 |
| TC-040 | Unit | Status count ALL = sum of individual statuses | ALL = Draft + Pending + Confirmed + Rejected | P0 | AC-004 |

### 6. Booking Lookup

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-041 | Unit | Booking lookup with customer ID | Returns SEA + FINALIZED MSOs | P0 | AC-006 |
| TC-042 | Unit | Booking already linked to follow-up | Excluded from results | P0 | AC-006 |
| TC-043 | Unit | Booking lookup without customer ID | Validation error: customer required | P0 | AC-006 |

### 7. Export

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-044 | Manual | Export with search filters applied | Excel contains all matching records (not just current page) | P0 | AC-005 |
| TC-045 | Manual | Export with no results | Empty Excel or appropriate message | P1 | AC-005 |

### 8. Email Notification

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-046 | Unit | Save as Pending (submit) | MailService.send() called with correct recipients | P0 | AC-007 |
| TC-047 | Unit | Confirm action | MailService.send() called | P0 | AC-007 |
| TC-048 | Unit | Reject action | MailService.send() called | P0 | AC-007 |
| TC-049 | Unit | Save as Draft | MailService.send() NOT called | P0 | AC-007 |
| TC-050 | Unit | SMTP failure | Error logged, no exception propagated to caller | P1 | AC-007 |

### 9. Permission & Security

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-051 | Manual | SZ Team calls Create endpoint | 200 OK | P0 | AC-008 |
| TC-052 | Manual | Customer calls Create endpoint | 403 Forbidden | P0 | AC-008 |
| TC-053 | Manual | Customer calls Confirm endpoint | 200 OK | P0 | AC-008 |
| TC-054 | Manual | SZ Team calls Confirm endpoint | 403 Forbidden | P0 | AC-008 |
| TC-055 | Manual | Unauthenticated user calls any endpoint | 401 Not Login | P0 | AC-008 |

### 10. View Detail

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-056 | Unit | Get detail by valid ID | Full detail VO returned | P0 | AC-001 |
| TC-057 | Unit | Get detail by non-existent ID | BusinessException: record not found | P0 | AC-001 |

### 11. Build Verification

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-058 | Unit | `mvn clean package` | Build succeeds, all tests pass | P0 | AC-011 |

## Commands

```bash
# Build
mvn clean package

# Run all unit tests
mvn -f vbo-plus-service/pom.xml test

# Run single test class
mvn -f vbo-plus-service/pom.xml test -Dtest=MsoFollowUpDomainServiceImplTest

# Skip tests for quick build
mvn clean package -DskipTests
```

## API Test Supplementary

Unit test completion triggers API-level testing via Swagger. Follow this flow, auto-fix bugs found, and update test feedback.

### Test Parameters

| Parameter | Value |
|---|---|
| Customer ID | 24310 |
| Login User | LuoNS01 |
| Login Password | abc@12345678 |
| Container Types | 40GP, 40HQ, 20GP |

### API Test Flow

1. **Login** — POST `/auth/login` with LuoNS01 / abc@12345678, obtain satoken
2. **Booking Lookup** — POST `/mso-follow-up/booking/search` with customerId=24310, pick any returned MSO_NO as bookingNo
3. **Create (Draft)** — POST `/mso-follow-up/create` with bookingNo from step 2, save as Draft
4. **View Detail** — GET `/mso-follow-up/{id}` to verify created record
5. **Update (Pending)** — PUT `/mso-follow-up/update` change status to Pending to Confirm
6. **Search** — POST `/mso-follow-up/search` with customerId=24310, verify record appears with correct status
7. **Status Count** — Verify status count statistics match search results
8. **Reject** — POST `/mso-follow-up/reject` with remarks, verify status = Rejected
9. **Update (Pending again)** — PUT `/mso-follow-up/update` re-submit to Pending
10. **Confirm** — POST `/mso-follow-up/confirm`, verify status = Confirmed and record is read-only
11. **Export** — POST `/mso-follow-up/export` with customerId=24310, verify Excel response
12. **Currency** — GET `/mso-follow-up/currency`, verify list returned

### Bug Fix Protocol

- If any API test fails, diagnose root cause, fix the code, re-run unit tests, then re-test the failing API
- Max 3 fix attempts per endpoint before escalating

## Pass Criteria

- [x] All new tests passed
- [x] Related existing tests passed
- [x] Build passed
- [ ] Lint passed
- [x] No high-risk security issue
- [x] No sensitive data exposed
- [ ] API test flow completed successfully
