# Solution

## Case
20260521_FREIGHTLIST_ic-ap-share-type-filter

## Recommended Solution
Mode 1 (LL-only). 在 IcTriggerConfigServiceImpl.isAllApChargeReleased 方法的 AP 类型判断条件中追加 cdlShareType="P" 过滤。

## Technical Constraints
- Java 21
- ChargeDetailLinkedEntity.cdlShareType: String, 值 P/I/N（来源: entity line 522-524）
- isAllApChargeReleased 签名不变: boolean isAllApChargeReleased(IcTransMetaItem meta)
- 构造器注入、中文注释

## Change Summary
- IcTriggerConfigServiceImpl.java line 251: 在 TransType.AP 判断后追加 `&& "P".equals(linkedCharge.getCdlShareType())`

## Post-Merge Test Plan (Track B)
- Command: `gradle :expand:business-freightlist-summary:compileJava`
- Owner: LiangWB
- Timing: 合并后立即执行
