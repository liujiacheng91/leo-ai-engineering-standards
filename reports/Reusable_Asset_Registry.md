# Reusable Asset Registry

> 跨案例可复用资产的集中索引。每次案例完成后，若 AI_Case_Card.md 标注 `Reusable: Yes`，须在此追加一行。
> Asset Type 应使用 AI_Case_Card.md `## Reusable Assets` 中最高价值的维度：Code / Pattern / Checklist / Process / Business Knowledge。
> 目标：让团队成员在开始新案例时快速查找可复用的模式、模板、测试策略和映射规则。

## Asset Index

| Asset Type | Case ID | File / Path | Description | Reuse Scenario |
|---|---|---|---|---|
| Token Optimization Pattern | 20260512_FREIGHTLIST | reports/case-studies/BizDB_Token_Optimization_Case.md | LL-only vs multi-SubAgent, 2.3x token reduction | 中小型任务 Sonnet-only 成本基准 |
| Mapping Rules Pattern | 20260512_FREIGHTLIST_edi | reports/case-studies/EDI_Mapping_Sonnet_Only_Case.md | MSG110 X12 40+ field mapping, Sonnet-only, 17/17 tests | 同类 EDI/X12 报文映射 |
| Mixed Skill Governance | 20260514_vbo_issue | reports/case-studies/VBO_Mixed_Skill_Report_Quality_Issue.md | Skill 混用导致 token 上报不完整的治理案例 | Skill 组合使用的反面教材 |
| Large Feature QA Pattern | 20260514_vbo_carrier | reports/case-studies/VBO_Large_Feature_QA_Enhanced_Case.md | 16 tasks, 31 files, 39 unit tests, status workflow + permission + CRUD | 多状态实体大功能的测试设计参考 |
| Token Report Annotation | N/A | examples/token-usage/FREIGHTLIST_Token_Usage_Report_Annotated.md | Token Report 逐字段阅读指南 | 新团队成员理解 Token Report |
| Cost Benchmark (LL-only) | 20260513_FREIGHTLIST | examples/token-usage/BizDB_Token_Usage_Report_Second_2th_V4.0.md | 171K tokens, $0.89, Retry=0, Sonnet-only | LL-only 模式成本基准 |
| Cost Benchmark (EDI) | 20260512_FREIGHTLIST_edi | examples/token-usage/EDI_Token_Usage_Report_V4.0.md | 67.5K tokens, $0.51, 17/17 tests | Mapping/EDI 模式成本基准 |
| Cost Benchmark (Large Feature) | 20260514_vbo | examples/token-usage/VBO_Token_Usage_Report_Second_2th_V4.0.md | 225K tokens, $4.50, 39 tests, 25 saved hours | 大功能 SubAgent 模式成本基准 |
| Cost Benchmark (Batch) | 20260529_FREIGHTLIST | reports/case-studies/20260529/BizDB_Totally_Summary.md | 21 cases, 2.096M tokens, $39.88, $2.44/hr, 90% zero-retry | FREIGHTLIST 批量案例成本基准 |
| Cost Benchmark (EDI Mode 2) | 20260529_Dyson_ocean-310 | reports/case-studies/20260529/ | 232K tokens, $1.38, 24/24 tests, 14h saved, $0.10/hr | EDI Mode 2 映射成本基准 |
| Rule Framework Pattern | 20260520_FREIGHTLIST_ic-trigger-rule-match | reports/case-studies/20260529/ | IC Trigger 9-field matching framework, stub-based extensibility | 规则框架搭建 + 后续字段补齐 |
| Field Chain Pattern | 20260521_FREIGHTLIST_ic-section-header-ic-type | reports/case-studies/20260529/ | Entity + Mapper XML + Node complete field addition chain | 字段新增完整链路模板 |
| Human-in-the-loop Bug Fix | 20260521_FREIGHTLIST_ic-trans-system-type-null | reports/case-studies/20260529/ | Business semantic correction by owner, fallback rejected | Bug Fix 业务纠偏参考案例 |
| Calculation Logic Pattern | 20260519_FREIGHTLIST_node5-calc-gp | reports/case-studies/20260529/ | AgentType-based GP allocation, 205K tokens, 2h saved, zero retry | 业务计算逻辑实现参考 |
| Trigger Control Pattern | 20260521_FREIGHTLIST_ic-ap-share-type-filter | reports/case-studies/20260529/ | Condition filter on AP share type, minimal code change | Trigger 条件过滤参考 |
| Interface Simplification Pattern | 20260519_FREIGHTLIST_upload-station-logic | reports/case-studies/20260529/ | FL aligned to IC upload station pattern, compile-verified | 接口简化 / 模式对齐参考 |
| Field Completion (Single) Pattern | 20260521_FREIGHTLIST_ic-trans-final-shipment-number | reports/case-studies/20260529/ | Single field setter addition, Yellow with minimal diff | 单字段补齐参考 |
| Engineering Value Deck | N/A | LL_AI_Engineering_Standards_Deck.md | 17-slide V4.1-V4.6 evolution, 27-case audit data | 管理层汇报 / 新团队 onboarding |

## How to Use

1. **开始新案例前**：按 Asset Type 或 Reuse Scenario 搜索本表，查看是否有可复用的模式
2. **案例完成后**：若 AI_Case_Card.md 标注 `Reusable: Yes`，在此追加一行
3. **周报复盘时**：检查本周完成的案例是否有资产值得登记
