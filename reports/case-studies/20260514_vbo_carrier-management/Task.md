# Task.md

## Task Goal

Implement the Carrier Management (MSO Follow Up) feature end-to-end: SQL scripts, domain layer, application layer, interface layer, mail utility, and unit tests.

## Related Documents

- AI_Request.md
- Scenario.md
- AI_Risk_Level.md
- Solution.md
- Test.md

## Task Breakdown

| Task ID | Task | Input | Output | Files | Done Criteria | Verification |
|---|---|---|---|---|---|---|
| T-001 | Create DDL script | Ticket spec | SQL script | `sql/ticket/175956/010-175956-DDL.sql` | Tables + sequences defined | SQL syntax review |
| T-002 | Create DML script | Ticket spec | SQL script | `sql/ticket/175956/020-175956-DML.sql` | Menu, function, labels registered | SQL syntax review |
| T-003 | Create status enum | Ticket spec | Java enum | `common/enums/MsoFollowUpStatus.java` | 4 statuses with code+description | Compiles |
| T-004 | Create PO classes | DDL | Java POs | `domain/mso/followup/repository/po/MsoFollowUpPo.java`, `MsoFollowUpLogPo.java` | Maps to DB columns | Compiles |
| T-005 | Create domain entities | Ticket spec | Java entities | `domain/mso/followup/entity/MsoFollowUp.java`, `MsoFollowUpLog.java` | Business fields defined | Compiles |
| T-006 | Create mapper interfaces | POs | Java mappers | `domain/mso/followup/repository/mapper/MsoFollowUpMapper.java`, `MsoFollowUpLogMapper.java` | CRUD + custom methods | Compiles |
| T-007 | Create mapper XMLs | Ticket SQL | MyBatis XML | `resources/mapper/mso/MsoFollowUpMapper.xml`, `MsoFollowUpLogMapper.xml` | CTE search queries, insert with sequence | XML valid |
| T-008 | Create domain service | Business rules | Java service | `domain/mso/followup/service/MsoFollowUpDomainService.java`, `impl/MsoFollowUpDomainServiceImpl.java` | Status workflow, validation, CRUD | Compiles |
| T-009 | Create DTOs and query objects | Ticket spec | Java DTOs | `interfaces/mso/followup/dto/*.java`, `query/*.java`, `vo/*.java` | All request/response models | Compiles |
| T-010 | Create MapStruct assembler | DTOs + entities | Java assembler | `application/assembler/MsoFollowUpAssembler.java` | DTO/Entity/PO conversions | Compiles |
| T-011 | Create application service | Solution design | Java service | `application/service/MsoFollowUpApplicationService.java`, `impl/MsoFollowUpApplicationServiceImpl.java` | Orchestrates domain + mail | Compiles |
| T-012 | Create mail utility | Ticket config | Java utility | `common/util/MailService.java`, `config/MailConfig.java` | Send method with logging | Compiles |
| T-013 | Update YAML configs | Ticket config | YAML updates | `application.yml`, `application-local.yml` | Mail properties added | App starts |
| T-014 | Create REST controller | APIs from Solution | Java controller | `interfaces/mso/followup/controller/MsoFollowUpController.java` | All 9 endpoints with permissions | Compiles |
| T-015 | Create unit tests | Test.md | Java test | `src/test/java/.../MsoFollowUpDomainServiceImplTest.java` | Status workflow + validation tests | Tests pass |
| T-016 | Build verification | All tasks | Build result | — | `mvn clean package` succeeds | Exit code 0 |

## Function-Level Design

| Function / API | Responsibility | Input | Output | Error Handling | Test Requirement |
|---|---|---|---|---|---|
| POST /mso-follow-up/search | Paginated search + status counts | MsoFollowUpQuery | PageInfo + StatusCounts | BusinessException on invalid query | Unit + Swagger |
| GET /mso-follow-up/{id} | Get detail by ID | Long id | MsoFollowUpDetailVo | 404 if not found | Unit |
| POST /mso-follow-up/create | Create new follow-up | MsoFollowUpCreateDto | Response<Void> | Validation errors, duplicate booking | Unit |
| PUT /mso-follow-up/update | Update existing | MsoFollowUpUpdateDto | Response<Void> | Cannot update CONFIRMED, validation | Unit |
| POST /mso-follow-up/confirm | Confirm quotation | MsoFollowUpConfirmRejectDto | Response<Void> | Must be PENDING status | Unit |
| POST /mso-follow-up/reject | Reject quotation | MsoFollowUpConfirmRejectDto | Response<Void> | Must be PENDING, remarks required | Unit |
| POST /mso-follow-up/export | Export to Excel | MsoFollowUpQuery | Response<ExportVo> | Empty result handling | Manual |
| POST /mso-follow-up/booking/search | Booking lookup | MsoBookingQuery | PageInfo<MsoBookingListVo> | Customer required | Unit |
| GET /mso-follow-up/currency | Currency dropdown | — | List<String> | — | Manual |
| MailService.send() | Send email | from, to, cc, bcc, subject, text | void | Log errors, no throw | Unit (mock) |
