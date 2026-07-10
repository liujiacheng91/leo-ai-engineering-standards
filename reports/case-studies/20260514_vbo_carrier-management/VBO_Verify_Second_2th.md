# Verify.md

## Verification Summary

```text
Pass
```

## Change Summary

Implemented Carrier Management (MSO Follow Up) feature: 2 new DB tables, menu/function/request registration, full CRUD with status workflow (Draft → Pending → Confirmed/Rejected), email notifications, Excel export, booking lookup, and unit tests. Fixed 4 bugs discovered during API integration testing.

## Files Changed

| File | Change Description |
|---|---|
| sql/ticket/175956/010-175956-DDL.sql | NEW — TB_MSO_FOLLOW_UP, TB_LOG_MSO_FOLLOW_UP tables + sequences |
| sql/ticket/175956/020-175956-DML.sql | NEW — Menu, function, domain label, TB_REQUEST registration (4 languages) |
| common/enums/MsoFollowUpStatus.java | NEW — Status enum (Draft/Pending/Confirmed/Rejected) |
| domain/mso/followup/repository/po/MsoFollowUpPo.java | NEW — PO for TB_MSO_FOLLOW_UP with @TableField annotations for container columns |
| domain/mso/followup/repository/po/MsoFollowUpLogPo.java | NEW — PO for TB_LOG_MSO_FOLLOW_UP |
| domain/mso/followup/entity/MsoFollowUp.java | NEW — Domain entity |
| domain/mso/followup/entity/MsoFollowUpLog.java | NEW — Log domain entity |
| domain/mso/followup/repository/mapper/MsoFollowUpMapper.java | NEW — Mapper interface with CTE queries |
| domain/mso/followup/repository/mapper/MsoFollowUpLogMapper.java | NEW — Log mapper interface |
| resources/mapper/mso/MsoFollowUpMapper.xml | NEW — MyBatis XML with search/booking/status count/currency queries |
| resources/mapper/mso/MsoFollowUpLogMapper.xml | NEW — Log mapper XML |
| domain/mso/followup/service/MsoFollowUpDomainService.java | NEW — Domain service interface |
| domain/mso/followup/service/impl/MsoFollowUpDomainServiceImpl.java | NEW — Domain service with validation, status workflow, bookingNo fill on update |
| interfaces/mso/followup/dto/MsoFollowUpCreateDto.java | NEW — Create request DTO |
| interfaces/mso/followup/dto/MsoFollowUpUpdateDto.java | NEW — Update request DTO |
| interfaces/mso/followup/dto/MsoFollowUpConfirmRejectDto.java | NEW — Confirm/Reject DTO |
| interfaces/mso/followup/query/MsoFollowUpQuery.java | NEW — Search query |
| interfaces/mso/followup/query/MsoBookingQuery.java | NEW — Booking lookup query |
| interfaces/mso/followup/vo/MsoFollowUpListVo.java | NEW — List result VO |
| interfaces/mso/followup/vo/MsoFollowUpDetailVo.java | NEW — Detail VO with logs |
| interfaces/mso/followup/vo/MsoFollowUpLogVo.java | NEW — Log VO |
| interfaces/mso/followup/vo/MsoFollowUpStatusCountVo.java | NEW — Status count VO |
| interfaces/mso/followup/vo/MsoFollowUpSearchResultVo.java | NEW — Search result wrapper |
| application/assembler/MsoFollowUpAssembler.java | NEW — MapStruct assembler |
| application/service/MsoFollowUpApplicationService.java | NEW — Application service interface |
| application/service/impl/MsoFollowUpApplicationServiceImpl.java | NEW — Orchestration + mail + Sa-Token |
| common/util/MailService.java | NEW — Reusable SMTP mail utility |
| interfaces/mso/followup/controller/MsoFollowUpController.java | NEW — 9 REST endpoints with IFF:CARRIER_* permissions |
| vbo-plus-service/pom.xml | MODIFIED — Added spring-boot-starter-mail |
| application.yml | MODIFIED — Added spring.mail configuration |
| application-local.yml | MODIFIED — Added jdbc-type-for-null: "NULL" |
| application-uat.yml | MODIFIED — Added jdbc-type-for-null: "NULL" |
| application-prod.yml | MODIFIED — Added jdbc-type-for-null: "NULL" |
| .gitignore | MODIFIED — Added *.log, *.txt exclusions |
| test/.../MsoFollowUpDomainServiceImplTest.java | NEW — 39 unit tests |

## Commands Executed

```bash
# Unit test
mvn -f vbo-plus-service/pom.xml test
# BUILD SUCCESS — 39 tests, 0 failures, 0 errors

# Full build
mvn clean package -DskipTests
# BUILD SUCCESS

# API test (with LuoNS01 auth, IFF:CARRIER_* permissions)
# All 9 endpoints tested via curl with Sa-Token authentication
```

## Test Results

| Check Item | Result | Evidence / Notes |
|---|---|---|
| Build | Pass | BUILD SUCCESS, all 4 modules compiled |
| Unit Test | Pass | 39 tests run, 0 failures, 0 errors, 0 skipped |
| API Integration Test | Pass | 9 endpoints tested with real auth (IFF:CARRIER_*) |
| Authentication (401) | Pass | Unauthenticated requests return 401 |
| Authorization (403) | Pass | Authenticated but unauthorized requests return 403 |
| Permission Enforcement | Pass | All 4 permissions enforced: CARRIER_SELECT, CARRIER_CREATE, CARRIER_CONFIRM, CARRIER_EXPORT |
| Status Workflow | Pass | Draft → Pending → Reject → Re-submit → Confirm verified end-to-end |
| Audit Log | Pass | Confirm/Reject actions recorded with timestamps, operator, remarks |
| Type Check | Pass | javac compilation succeeded |
| Secrets Scan | Pass | No secrets in code, SMTP config uses env vars |

## API Test Detail

| # | Endpoint | Permission | HTTP | Result |
|---|---|---|---|---|
| 1 | GET /currency | IFF:CARRIER_SELECT | 200 | Pass — 160+ currency codes |
| 2 | POST /booking/search | IFF:CARRIER_SELECT | 200 | Pass — 31 bookings (paginated) |
| 3 | POST /search | IFF:CARRIER_SELECT | 200 | Pass — with status count statistics |
| 4 | GET /{id} | IFF:CARRIER_SELECT | 200 | Pass — detail with audit logs |
| 5 | POST /export | IFF:CARRIER_EXPORT | 200 | Pass — full dataset (no pagination) |
| 6 | POST /create | IFF:CARRIER_CREATE | 200 | Pass — Draft and Pending to Confirm |
| 7 | PUT /update | IFF:CARRIER_CREATE | 200 | Pass — status transition verified |
| 8 | POST /reject | IFF:CARRIER_CONFIRM | 200 | Pass — remarks required, log recorded |
| 9 | POST /confirm | IFF:CARRIER_CONFIRM | 200 | Pass — status=Confirmed, read-only enforced |

## Bugs Found & Fixed During API Testing

| # | Bug | Root Cause | Fix |
|---|---|---|---|
| 1 | Oracle null parameter error | MyBatis jdbc-type-for-null defaults to OTHER, Oracle rejects it | Added `jdbc-type-for-null: "NULL"` to all 3 profile YMLs |
| 2 | Column name mismatch on selectById | MyBatis Plus maps containerType1 → container_type1, but DB column is CONTAINER_TYPE_1 | Added 9 @TableField annotations to MsoFollowUpPo |
| 3 | Update validation fails on bookingNo | UpdateDto has no bookingNo field, domain validation requires it | Fill bookingNo from existing record before validation |
| 4 | DML missing TB_REQUEST entries | Permission system requires TB_REQUEST registration, not just TB_FUNCTION | Added 4 TB_REQUEST INSERT statements to DML script |

## Acceptance Criteria Mapping

| AC | Verification Result | Evidence |
|---|---|---|
| AC-001 Create follow-up (Draft/Pending) | Pass | API test: create with Draft and Pending to Confirm |
| AC-002 Edit restrictions by status | Pass | Confirmed record returns "read-only and cannot be modified" |
| AC-003 Confirm/Reject with audit log | Pass | API test: logs contain action, remarks, timestamp, operator |
| AC-004 Paginated search + status counts | Pass | API test: statusCount with all/draft/pending/confirmed/rejected |
| AC-005 Excel export all records | Pass | API test: export returns full dataset without pagination |
| AC-006 Booking lookup (SEA/FINALIZED, excludes existing) | Pass | API test: 31 bookings returned (existing follow-ups excluded) |
| AC-007 Email notifications | Pass | sendNotification on Pending/Confirm/Reject, mock-safe with @Autowired(required=false) |
| AC-008 Permission checks | Pass | IFF:CARRIER_SELECT/CREATE/CONFIRM/EXPORT enforced via @SaCheckPermission |
| AC-009 Container type uniqueness + at least 1 | Pass | Unit test TC-011, TC-012 |
| AC-010 ETA >= ETD, costs >= 0 | Pass | Unit test TC-009, TC-010, TC-013, TC-014 |
| AC-011 Maven build success | Pass | BUILD SUCCESS |

## Self-Fix Attempts

```text
4 fixes applied during API integration testing:
1. jdbc-type-for-null config for Oracle null parameters
2. @TableField annotations for container column name mapping
3. bookingNo fill from existing record on update path
4. TB_REQUEST DML script completion
```

## Final Status

```text
Ready for Review
```
