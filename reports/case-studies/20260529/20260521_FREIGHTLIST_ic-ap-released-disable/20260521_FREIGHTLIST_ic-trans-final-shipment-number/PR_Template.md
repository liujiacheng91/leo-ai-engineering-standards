# Pull Request Template

## Summary
ic_transaction_final.shipment_number 字段始终为 null，原因是 Node3IcTransFinalCalc.buildFinalEntity() 遗漏了 setShipmentNumber 赋值。本 PR 在 setHouseNo 之后添加 setShipmentNumber(transaction.getHouseNo())，使 shipment_number 与 house_no 保持一致。

## Related Documents

- docs/ai/cases/20260521_FREIGHTLIST_ic-trans-final-shipment-number/AI_Request.md
- docs/ai/cases/20260521_FREIGHTLIST_ic-trans-final-shipment-number/Scenario.md
- docs/ai/cases/20260521_FREIGHTLIST_ic-trans-final-shipment-number/AI_Risk_Level.md
- docs/ai/cases/20260521_FREIGHTLIST_ic-trans-final-shipment-number/Solution.md
- docs/ai/cases/20260521_FREIGHTLIST_ic-trans-final-shipment-number/Task.md
- docs/ai/cases/20260521_FREIGHTLIST_ic-trans-final-shipment-number/Test.md
- docs/ai/cases/20260521_FREIGHTLIST_ic-trans-final-shipment-number/Verify.md

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: ~$0.80 (estimated)

## Validation

- [ ] Build (Track B: 合并后执行 `gradle :expand:business-freightlist-summary:compileJava`)
- [ ] Unit Test (Track B: 仓库无 src/test)
- [x] Static Code Review
- [x] AC Trace (AC-1 + AC-2)

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes
1 行 setter 赋值，数据源与同方法中 setHouseNo 完全一致（transaction.getHouseNo()）。IC_TRANS 链不受影响（IcTransactionEntity 无 shipmentNumber 字段）。
