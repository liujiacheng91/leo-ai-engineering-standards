# PR：IC Trans Final internalTransNo 改造 —— 同交易三条费用共用编号

**风险等级：🟡 Yellow**

## Summary

- IC_TRANS_FINAL 链 `Node2IcTransFinalCalc` 的 `internalTransNo` 赋值逻辑从"每行 `++index` 累加 4 位"改为"每条 IC 交易调一次 `GlobalMonotonicService.nextEpoch("INTERNAL_TRANS_NO")`，3 行 Final（H/P0005/OTH-PS）共用"
- 新增 `IGlobalMonotonicService` 接口及 `GlobalMonotonicServiceImpl` 实现（从 `bus-task-control-handler-service` 复制，改包路径 + 构造器注入）
- `CustomTypeConvertUtils.toFourDigits` 标 `@Deprecated`，方法体保留
- 异常策略：`nextEpoch` 失败时 `log.error + continue`，该交易 3 行 Final 不入 list

## Risk Level

🟡 **Yellow** — LiteFlow 节点改动 + 引入新外部调用（Redis 发号），但不触及 Node5/Node10/Node11 共享果子，不动 schema/配置/EL chain DSL。

详见 `docs/ai/cases/20260511_FREIGHTLIST_ic-final-shared-trans-no/AI_Risk_Level.md`

## Validation

- **构建**：`gradle build` 通过
- **单测**：39 个（13 新增 + 26 既有），全部 PASSED，0 回归
- **code-review**：TA 评审通过，0 must-fix
- **AC 覆盖**：AC-1 ~ AC-6 全部验证通过

详见 `docs/ai/cases/20260511_FREIGHTLIST_ic-final-shared-trans-no/Verify.md`

## Reviewer Notes

- PDF 团队已对齐：`internal_trans_no` 不做行级唯一键，不依赖排序展示，跳号/变长可接受
- Kafka 重放重复行问题（已知历史问题）不在本 PR 修复，建议另起 case
- 需求池修订案：REQ-202605110001（amends REQ-202604300018 §"字段值固定/派生规则"第 30 行）

## Changed Files

| 文件 | 操作 |
|---|---|
| `service/IGlobalMonotonicService.java` | 新增 |
| `service/impl/GlobalMonotonicServiceImpl.java` | 新增 |
| `node/ic/transfinal/Node2IcTransFinalCalc.java` | 修改 |
| `utils/CustomTypeConvertUtils.java` | 修改 |

## Case Reference

`docs/ai/cases/20260511_FREIGHTLIST_ic-final-shared-trans-no/`
