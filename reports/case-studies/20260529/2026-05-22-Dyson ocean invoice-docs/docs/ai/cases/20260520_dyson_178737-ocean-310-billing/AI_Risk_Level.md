# AI_Risk_Level.md

## Risk Level

```text
Yellow
```

## Risk Decision Summary

本案例为新增功能类，不修改任何已有类，隔离性高。但存在以下中等风险因素：

1. **映射复杂度高**：100+ 字段，3 种分组聚合逻辑，任意一处分组或字段映射出错会导致 Dyson 收到错误账单 EDI 文件，影响业务对账。
2. **外部 EDI 文件输出**：生成的 X12 文件直接推送给 Dyson，一旦格式错误无法自动回滚，需人工介入补发。
3. **多服务调用**：涉及 EdiCoreServiceUtils（推送）、EdiIncrementSequenceService（序列号）、ToolService（日志/邮件），任一服务异常需在主流程 try-catch 内正确处理。
4. **mapFrom304 占位**：V1 / R4*R / R4*E / N9 非标准段由人工补充，存在遗漏风险，需 Tech Lead review。
5. **Q2 B3/B304 兜底为空字符串**：待 BA 最终确认，若后续 BA 改动则需补改。

降低风险的因素：
- 不修改现有类，无回归风险
- 不涉及生产配置、敏感数据、数据库结构、鉴权逻辑
- 存在同类参考实现（DysonOnlineOceanMlestoneSendProcessImpl）
- mapFrom304 为占位方法，范围明确，不影响主流程

判定为 **Yellow**：AI 可实现，但 Solution.md 需要 Tech Lead 确认后方可生成 Task.md 和 Test.md，最终代码须人工 review。

## Risk Factors

- [ ] Production config involved
- [ ] Production data involved
- [ ] Customer sensitive data involved
- [ ] Auth / Authorization involved
- [ ] Encryption / Security involved
- [ ] Audit involved
- [ ] DB schema involved
- [x] Core business rules involved（oc_rate 分组 + 金额 sum 逻辑）
- [x] Mapping / transformation involved（100+ 字段，3 种分组）
- [ ] SQL / reporting involved
- [x] Multi-service call involved（EdiCoreServiceUtils / EdiIncrementSequenceService / ToolService）

## Allowed AI Actions

- [x] Analysis only
- [x] Generate documents
- [x] Generate test cases
- [x] Implement code
- [x] Run verification
- [x] Generate PR summary

> 注：以上均在 Solution.md 经 Tech Lead 确认后方可执行。

## Required Human Confirmation

| Role | Required | Confirmed By | Date |
|---|---|---|---|
| Business Owner | No | — | — |
| Tech Lead | Yes | | |
| Security | No | — | — |
| DBA | No | — | — |

> Tech Lead 需在 Solution.md `## Human Approval` 签字后，AI 方可生成 Task.md 和 Test.md。

## Stop Conditions

本案例触发停止的条件：

1. Solution.md 未获 Tech Lead 签字，AI 不生成 Task.md / Test.md / 代码。
2. mapFrom304 内部实现被要求由 AI 完成（超出 In Scope）。
3. 需求变更导致 B3/B304 逻辑与当前确认结果不一致，需重新评估。
4. 主流程自修复超过 3 次。
5. 推送 EDI Core 接口签名与现有实现不一致（需重新确认）。
6. 涉及生产配置或生产数据读写。

## Final Approval

- Approved by: Sundy Sun
- Date: 2026-05-20
- Notes:
