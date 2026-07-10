# Token_Usage_Report.md

## Case Info

| Field | Value |
|---|---|
| Case ID | `20260513_dyson_online-air-billing-send` |
| Date | 2026-05-13 |
| Model | claude-sonnet-4-6 |
| Risk Level | Yellow |
| Result | PASS — 17/17 unit tests green |
| Self-Fix Count | 2 / 3 |

---

## Task-Level Token Usage

> 注：Token 数为基于输出体积和上下文读取量的合理估算值。Claude API 不向模型暴露精确 Token 计数，实际账单以 Anthropic Console 为准。

| Task | Description | Input Tokens (est.) | Output Tokens (est.) | Total (est.) | Cost (est. USD) |
|---|---|---:|---:|---:|---:|
| Scenario / Risk / Request | 需求分析、风险定级、Scenario.md / AI_Risk_Level.md | 4,000 | 2,500 | 6,500 | $0.049 |
| Solution + Task + Test | Solution.md、Task.md、Test.md 生成 | 6,000 | 4,000 | 10,000 | $0.078 |
| T-000 build.gradle | 新增 edi-x12 + test 依赖 | 1,500 | 300 | 1,800 | $0.013 |
| T-001 Models | DysonAirBillingInput / DysonAirBillingDetail | 2,000 | 1,500 | 3,500 | $0.026 |
| T-002 Process 入口类 | DysonOnlineAirBillingSendProcess.java | 1,000 | 400 | 1,400 | $0.010 |
| T-003~T-011 Impl 实现类 | DysonOnlineAirBillingSendProcessImpl.java (~360 行) | 12,000 | 6,000 | 18,000 | $0.138 |
| Test Generation | DysonOnlineAirBillingSendProcessImplTest.java (17 cases) | 8,000 | 5,000 | 13,000 | $0.099 |
| Verification Fix #1 | spring-test import → java.lang.reflect.Field | 3,000 | 800 | 3,800 | $0.028 |
| Verification Fix #2 | anyInt() + insertLog when/thenReturn | 3,500 | 1,000 | 4,500 | $0.033 |
| Verify.md + PR Summary | 更新验证报告、生成 PR 描述 | 3,000 | 2,000 | 5,000 | $0.038 |
| **Total** | | **44,000** | **23,500** | **67,500** | **$0.512** |

> 定价参考：claude-sonnet-4-6 Input $3/1M tokens，Output $15/1M tokens

---

## Stage-Level Token Usage

| Stage | Tokens (est.) | Percentage | Notes |
|---|---:|---:|---|
| Scenario Analysis | 6,500 | 10% | 需求阅读 + 风险定级 |
| Solution Design | 10,000 | 15% | Solution + Task + Test 文档生成 |
| Code Implementation | 37,700 | 56% | 5 个新文件 + 17 个测试用例 |
| Verification | 8,300 | 12% | 2 次自修复 + 测试运行 + Verify.md |
| Documentation (PR/Report) | 5,000 | 7% | PR 描述 + Token Report |
| **Total** | **67,500** | **100%** | |

---

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Impl 类 Token 占比较高 (27%) | MSG110 X12 字段多（40+），ISA/GS/B3/N1/LX/L3 逐段映射，上下文重复读取 | 可考虑将映射规则提前固化为 Mapping_Rules.md，减少模型推断映射的 Token 消耗 |
| 测试文件 Token 占比 (19%) | 17 个测试用例含 ArgumentCaptor / RETURNS_DEEP_STUBS / reflection，上下文复杂 | 可将测试模板（mock setUp 样板）写入 Test.md，减少生成摘要 |
| 2 次自修复 (12%) | Fix #1: spring-test classpath 未预判；Fix #2: Mockito primitive int 未预判 | 在 Solution.md 中预先标注 Mockito primitive 陷阱，避免下次重复 |

---

## Saved Hours Estimate

| Work Item | Manual Estimate | AI Actual | Saving |
|---|---|---|---|
| MSG110 X12 40+ 字段映射实现 | 3.5 h | 0.5 h (review+approve) | 3.0 h |
| 17 个单元测试编写 | 2.5 h | 0.3 h | 2.2 h |
| 过程文档（Scenario/Risk/Task/Test/Verify/PR） | 2.0 h | 0.2 h | 1.8 h |
| Debug（Mockito primitive + spring-test） | 1.0 h | 0.3 h (prompt+review) | 0.7 h |
| **Total** | **9.0 h** | **1.3 h** | **7.7 h** |

---

## Reusability

| Asset | Reusable By | Notes |
|---|---|---|
| `DysonAirBillingInput` / `DysonAirBillingDetail` 模型 | 其他 Dyson air billing 场景 | 字段已覆盖 ata_date / other_charges / air_milestone |
| `buildMsg110X12` 骨架 | 其他需要 MSG110 的客户 | ISA/GS 参数化后可复用 |
| Test 中 `captureEdi` + `parseSegment` 工具方法 | 同类 X12 EDI 测试 | 可提取为测试工具类 |
| `anyInt()` Mockito 注意事项 | 所有含 primitive 参数的 mock 场景 | 已记录在 Fix #2 |

---

## Summary

```text
Model:         claude-sonnet-4-6
Total Tokens:  ~67,500 (est.)
Total Cost:    ~$0.51 (est.)
Self-Fixes:    2 / 3
Result:        PASS — 17/17 unit tests green
Saved Hours:   ~7.7 h
Risk:          Yellow — 需 Business Owner + Tech Lead 人工确认
```
