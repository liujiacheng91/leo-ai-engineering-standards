# AI_Case_Card.md

## Basic Info

- Case ID: 20260520_dyson_178737-ocean-310-billing
- Team: Dyson
- Project: edi-dyson-realization
- Scenario: Dyson Online Ocean Billing Send - MSG310 EDI Generation
- Risk Level: Yellow
- AI Tool: Claude Code (claude.ai/code)
- Model: claude-sonnet-4-6 (1M context)
- Owner: dara.heng@transpeed.com.sg

## Outcome

- Original Estimate: 2~3 人天（手工实现 100+ 字段映射 + 3 种分组逻辑 + 日志/邮件）
- Actual Time: ~4 小时（含文档审核、Q&A 确认、Solution 签核）
- Saved Time: ~1.5~2 人天
- Token Cost: 见 Token_Usage_Report.md
- Result: 成功 — 22/22 单元测试通过，compileJava 通过，Ready for Review
- Reusable: Yes

## Human Intervention

| Point | Reason | Decision | Owner |
|---|---|---|---|
| Q1–Q5 确认 | 文件名格式冲突、B3/B304 兜底、字段名不一致、V1 占位 | 文件名用 mapping.csv 格式；B304 给空字符串（待 BA）；x_customer_code；x_client_address_1；V1 归 mapFrom304 | Sundy Sun |
| Solution.md 审核（7 条修正）| messageFormat 错误、ediText null 安全、EmailTemplate 格式、多组附件、trace_id 兜底、返回值规范 | 全部修正后签字 | Sundy Sun |
| AI_Risk_Level.md 签核 | Yellow 路径要求 Tech Lead 确认 | Approved（2026-05-20） | Sundy Sun |
| mapFrom304 范围确认 | N9 非标准、R4*R/R4*E、V1、N7/N722 来自 MSG304，AI 不实现 | 归入人工实现占位，生成空方法体 | Sundy Sun |

## Lessons Learned

**What worked:**
- 预先读取现有实现（DysonOnlineOceanMlestoneSendProcessImpl）和 API JAR（`javap`）作为参考，避免了大部分假设错误
- 按 Retrospective 建议在 Solution.md 增加"方法签名确认清单"，Self-Fix 次数控制在 2 次
- Mode 2（Mapping/EDI）流程有效：先产出 Mapping_Rules.md，再实现，映射错误率低
- Q&A 明确区分了 mapping.csv 和 requirements.md 的矛盾，避免实现时猜测

**What failed:**
- `loadterm` 字段名推断错误（OceanShipment.md 写 `loadterm`，实际 JAR 中无此字段，应为 `manifest_type`）
  - Fix #1 根因：依赖文档而非 `javap` 验证
- 测试依赖 testImplementation 遗漏，导致 compileTestJava 失败
  - Fix #2 根因：build.gradle 无测试依赖声明，未在 Task.md 中列为前置检查

**What to improve:**
- 凡使用新字段前，用 `javap` 或 grep 源码确认；文档描述只作为参考，不作为实现依据
- 新建测试文件时，在 Task.md 中加入"testImplementation 依赖已声明"作为 DONE 标准
- Air Billing 测试文件（预先存在但引用缺失的 Impl）应在实现阶段被早期识别并排除，避免阻塞测试阶段

## Related Cases

| Case ID | 关系 | 说明 |
|---|---|---|
| 20260513_dyson_online-air-billing-send | 前序案例 | Air Billing（MSG110）同类实现，Retrospective 提供了关键改进建议 |
