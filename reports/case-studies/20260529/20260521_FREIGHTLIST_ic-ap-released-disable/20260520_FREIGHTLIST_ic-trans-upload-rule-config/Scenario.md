# Scenario - ic-trans-upload-rule-config

## Background
IC_TRANS 链的 buildMeta 阶段调用 getReportUploadStation 获取报表上传规则配置，但该方法当前返回 null（带 todo 注释），导致 IcTransMetaItem.reportUploadRuleConfigEntityList 始终为空。

ShipmentHeaderInterLinkServiceImpl 中已有成熟的 DCL 缓存实现（getReportUploadRule 方法），查询 fl_aggregation_report_upload_rule_config 表中 enabled=1 的记录。IC 侧需要复制同样的模式。

## Acceptance Criteria
- AC-1: getReportUploadStation 方法使用 DCL（双重检查锁）缓存模式，version 不变时返回缓存拷贝
- AC-2: version 变化时重新查询 FlAggregationReportUploadRuleConfigEntity（flArurcRuleEnabled=1）
- AC-3: 构造器注入 IFlAggregationReportUploadRuleConfigService
- AC-4: version 为 null 时返回 Collections.emptyList()
- AC-5: 返回 List 拷贝，不暴露内部缓存引用

## Assumptions
- IcTransMetaItem.reportUploadRuleConfigEntityList 字段已存在，setter 可用
- buildMeta 中已有调用点（line 111），只需填充方法体
- 与 ShipmentHeaderInterLinkServiceImpl.getReportUploadRule 查询同一张表、同一过滤条件
