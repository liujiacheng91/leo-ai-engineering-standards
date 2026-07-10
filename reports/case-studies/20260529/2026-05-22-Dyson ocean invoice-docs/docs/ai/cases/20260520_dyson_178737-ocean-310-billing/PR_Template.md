# Pull Request Template

## Summary

**#178737 DYSON | Ocean 310 EDI: 新增 Billing Send Process（MSG310）**

接收 LL 业务系统推送的 OceanShipment（含 oc_rate 费用列表），按 `oc_rate.client_id + invoice_no` 分组转换为 X12 MSG310 文件，推送至 EDI Core，记录日志，发送邮件通知。

**核心变更：**
- 新增 `DysonOnlineOceanBillingSendProcess`（Process 注册类）
- 新增 `DysonOnlineOceanBillingSendProcessImpl`（实现类，4 个方法）
- 新增单元测试 22 个，全部通过
- 升级根 `build.gradle`: `ediStandardStructVersion` 0.0.59 → 0.0.66（OceanRate 新字段）
- `edi-dyson-realization/build.gradle`: 新增 `edi-x12:0.0.4`（Msg310X12Factory）

**不涉及：**
- 现有类无修改，无回归风险
- 不涉及生产配置、数据库、鉴权、加密

---

## Related Documents

| 文档 | 路径 |
|---|---|
| AI_Request.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/AI_Request.md` |
| Scenario.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/Scenario.md` |
| AI_Risk_Level.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/AI_Risk_Level.md` |
| Solution.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/Solution.md` |
| Mapping_Rules.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/Mapping_Rules.md` |
| Task.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/Task.md` |
| Test.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/Test.md` |
| Verify.md | `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/Verify.md` |
| requirements.md | `docs/requirements/178737-online-ocean-310/requirements.md` |

---

## Files Changed

| 文件 | 变更 |
|---|---|
| `build.gradle`（根） | `ediStandardStructVersion` 0.0.59 → 0.0.66 |
| `edi-dyson-realization/build.gradle` | 新增 edi-x12:0.0.4，新增测试依赖 |
| `send/process/DysonOnlineOceanBillingSendProcess.java` | 新增 |
| `send/process/impl/DysonOnlineOceanBillingSendProcessImpl.java` | 新增 |
| `test/.../DysonOnlineOceanBillingSendProcessImplTest.java` | 新增 |
| `docs/ai/cases/20260520_dyson_178737-ocean-310-billing/` | 新增 AI 过程文档（8 份）|
| `docs/requirements/178737-online-ocean-310/requirements.md` | 更新已确认问题、SDK 信息 |

---

## AI Assistance

- Tool: Claude Code (claude.ai/code)
- Model: claude-sonnet-4-6 (1M context)
- Risk Level: Yellow（新增功能，分组聚合逻辑中等复杂度，Solution.md 经 Sundy Sun 审核签字）
- Self-Fix: 2 次（loadterm 字段名、testImplementation 依赖缺失）
- Case ID: `20260520_dyson_178737-ocean-310-billing`

---

## Validation

- [x] Build（`compileJava` BUILD SUCCESSFUL, 19s）
- [x] Unit Test（22/22 通过，0 失败，4.024s）
- [ ] Integration Test（需测试环境 EDI Core + SFTP，由 BA/QA 执行）
- [x] Lint（`-Xlint:all` 编译无 warning，无 Checkstyle 配置）
- [ ] Security Scan（项目无自动扫描配置）
- [x] Secrets Scan（代码无硬编码密钥/Token/证书）

---

## Security Checklist

- [x] No secrets exposed（无密钥、token、证书硬编码）
- [x] No production data used（测试数据为构造的 OceanShipment mock 对象）
- [x] No production config changed（无 application.yml 修改）
- [x] No auth / audit bypassed（不涉及鉴权、加密、审计逻辑）

---

## Reviewer Notes

**必须确认的事项：**

1. **`mapFrom304` 占位范围**：N9 非标准类型、R4*R（Place of Receipt）、R4*E（Place of Delivery）、N7/N722（Equipment Type）、V1（船舶信息）均为人工实现占位，当前方法体为空。请确认这些字段是否需要在本 PR 中实现，或作为后续 ticket。

2. **`ediStandardStructVersion` 0.0.59 → 0.0.66 全局升级**：影响所有依赖 edi-standard-structure 的模块。已验证 edi-dyson-realization 编译通过，其他模块未单独验证。建议 merge 后在 CI 环境做全量编译确认。

3. **L1 位置设计**：L1 charge items 放在每个 L0Group（container）内的 L1Group 列表中。若 Dyson 期望 L1 在 Msg310 级别（非 LxGroup 内），请告知，实现可调整。

4. **B3/B304 兜底**：当 `ocean.terms` 既非 COLLECT 也非 PREPAID 时，B3/B304 为空字符串（已与 BA 确认为临时方案，待 BA 最终确认）。

**测试建议：**
- UAT 准备含有多个 oc_rate（不同 client_id + invoice_no）的 OceanShipment 数据
- 验证生成的 MSG310 文件能被 Dyson 系统正确解析
- 验证 SFTP 推送路径和文件名格式符合约定
