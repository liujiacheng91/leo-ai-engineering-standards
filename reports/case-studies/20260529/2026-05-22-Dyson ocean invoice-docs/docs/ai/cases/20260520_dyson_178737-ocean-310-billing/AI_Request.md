# AI_Request.md

## Basic Info

- Case ID: 20260520_dyson_178737-ocean-310-billing
- Request Name: Dyson Ocean Billing 310 EDI Send Process
- Team: Dyson
- Project: edi-dyson-realization
- Owner: dara.heng@transpeed.com.sg
- Date: 2026-05-20
- Output Path: docs/ai/cases/20260520_dyson_178737-ocean-310-billing/

## Request Type

- [ ] Code Understanding
- [ ] Documentation
- [ ] Test Generation
- [ ] CRUD / Interface
- [ ] SQL / Report
- [x] Mapping / Transformation
- [ ] Refactoring
- [ ] CI Failure Analysis
- [ ] Other:

## Expected AI Output

- [x] Scenario.md
- [x] AI_Risk_Level.md
- [x] Solution.md
- [x] Task.md
- [x] Test.md
- [x] Verify.md
- [x] Code Change
- [x] PR Summary
- [x] AI_Case_Card.md
- [x] Token_Usage_Report.md

## Required Human Input

- Business Rules: docs/requirements/178737-online-ocean-310/requirements.md
- Sample Data: docs/requirements/178737-online-ocean-310/mapping.csv
- Acceptance Criteria: X12 MSG310 文件生成正确，按 oc_rate.client_id + invoice_no 分组生成，推送成功，日志和邮件通知正常
- Technical Constraints: 继承 EdiSendCustomizeBaseProcessAbstract；4 个独立方法（主流程、mapping、push、mapFrom304）；mapFrom304 为占位方法（人工实现）；edi-x12:0.0.4 依赖新增
- Risk Level: Yellow（新增功能，分组聚合逻辑中等复杂度，需 Tech Lead 确认 Solution.md）

## Entry Check

- [x] Scenario.md 完成
- [x] Risk level 完成（Yellow，Sundy Sun 2026-05-20 签核）
- [x] Required input available
- [x] No sensitive data included
