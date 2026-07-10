# AI Request - ic-trans-upload-rule-config

## Case ID
20260520_FREIGHTLIST_ic-trans-upload-rule-config

## Owner
Liangwb

## Team
FREIGHTLIST

## Project
bus-freightlist-handler-service

## Task Type
feature

## Description
IcTransactionServiceImpl.getReportUploadStation 方法当前返回 null（带 todo），需补充 DCL 缓存逻辑，与 ShipmentHeaderInterLinkServiceImpl 中同名方法的模式保持一致。

## Input
- 用户需求：补充 IcTransactionServiceImpl 中的 getReportUploadStation 逻辑，与 ShipmentHeaderInterLinkServiceImpl 保持一致
- 参考实现：ShipmentHeaderInterLinkServiceImpl.getReportUploadRule（DCL 缓存 + 查询 FlAggregationReportUploadRuleConfigEntity enabled=1）

## Expected Output
- IcTransactionServiceImpl.getReportUploadStation 实现 DCL 缓存模式
- 注入 IFlAggregationReportUploadRuleConfigService

## Branch Info
- Base Branch: develop_1.1.0
- Task Type: feature
- New Branch Name: (direct commit, Green risk)
