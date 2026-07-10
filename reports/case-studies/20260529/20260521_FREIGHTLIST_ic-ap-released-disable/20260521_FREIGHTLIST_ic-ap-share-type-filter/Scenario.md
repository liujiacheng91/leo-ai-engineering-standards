# Scenario

## Case
20260521_FREIGHTLIST_ic-ap-share-type-filter

## Background
IC v2 链 Node1Trigger 调用 IcTriggerConfigServiceImpl.isAllApChargeReleased 判断是否所有 AP 费用已 Released。当前逻辑检查 linkedCharges 中所有 TransType=AP 的费用，不区分 share_type。业务要求仅 share_type=P 的 AP 费用需要全部 Released 才触发后续计算。

## Root Cause
isAllApChargeReleased 方法缺少 share_type=P 的过滤条件，导致 share_type=I 或 N 的 AP 费用也被纳入 Released 判断，可能阻塞触发。

## Acceptance Criteria
- AC-1: isAllApChargeReleased 仅检查 cdlShareType="P" 且 cdlTransType=AP 的费用
- AC-2: share_type 非 P 的 AP 费用不影响触发判断（即使未 Released 也不返回 false）
- AC-3: 无 share_type=P 的 AP 费用时，方法返回 true（与当前无 AP 费用时行为一致）

## Assumptions
- cdlShareType 字段值为 P/I/N（来源: ChargeDetailLinkedEntity.java:520-524）
- 仅改 isAllApChargeReleased 方法内部逻辑，不改接口签名
- 不影响 isAllArChargePosted 等其他触发条件方法

## Impact
- 涉及文件: IcTriggerConfigServiceImpl.java（1 处）
- 涉及 LiteFlow 节点: ic_trigger_v2（Node1Trigger 调用链）
- 对 PDF 团队: 无影响（不改表结构、不改输出字段）
