# AI_Case_Card.md

## Basic Info

- Case ID: 20260521_FREIGHTLIST_ic-trans-system-type-null
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- Scenario: ic_transaction.system_type 为 null 修复
- Risk Level: Yellow
- AI Tool: Claude Code
- Model: Opus
- Owner: Liangwb

## Outcome

- Original Estimate: 1.5h (人工定位 + 分析 + 修复 + 走读验证)
- Actual Time: 0.3h (用户提供方向 + review + 两次决策)
- Saved Hours: 1.2
- Token Cost: $4.28 (estimated)
- Result: Pass
- Reusable: No (bug fix, 逻辑改动特定于 systemType 赋值)

## Quality Metrics

| Metric | Value | Notes |
|---|---|---|
| Retry Count | 1 [Logic] | 初次方案用 shipmentDetailList 做 fallback，用户指正统一用 keyShipment |
| Retry Root Cause | [Logic] | 未充分理解业务：同一票 sourceSystem 一致，不需要按 station 匹配 |
| RA Quality | Normal | 路径 B 主 Claude 亲自执行，无独立 RA |
| RA Deviation Root Cause | N/A | |

## Related Cases

| Relationship | Case ID | Notes |
|---|---|---|
| - | 20260521_FREIGHTLIST_ic-trans-ps-amount-var | 同日 IC 链修复（ps_amount 精度） |
| - | 20260521_FREIGHTLIST_ic-ap-released-disable | 同日 IC 链修复（AP released 校验关闭） |

## Human Intervention

| Point | Reason | Decision | Owner |
|---|---|---|---|
| 返工 #1 | 初次方案用 shipmentDetailList 做 else fallback | 统一从 keyShipment 取，旧逻辑注释保留 | Liangwb |
| 合并决策 | 用户 review Merge_Decision | 合并到 develop_1.1.0 | Liangwb |

## Lessons Learned

- What worked: 路径 B / Mode 1 适合此类单文件 Yellow 修复；用户两次精确纠偏高效
- What failed: 初次方案未充分理解"同一票 sourceSystem 一致"的业务规则，导致一轮返工
- What to improve: IC 链修改前先确认 keyShipment 是否已覆盖所需字段，避免走按 station 匹配的复杂路径
