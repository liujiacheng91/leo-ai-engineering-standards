# Verify - ic-trans-upload-rule-config

## Summary
- Risk: Green
- Track: A
- Files Changed: 1

## Files Changed

| File | Change |
|---|---|
| `expand/.../service/impl/IcTransactionServiceImpl.java` | 注入 IFlAggregationReportUploadRuleConfigService，增加 DCL 缓存字段，实现 getReportUploadStation 方法 |

## Acceptance Criteria Mapping

| AC | Covered | Evidence |
|---|---|---|
| AC-1 | Yes | DCL 模式: 外层 version.equals(currentRuleConfigVersion) 快速返回缓存拷贝，内层 synchronized 二次检查 |
| AC-2 | Yes | version 变化时执行 reportUploadRuleConfigService.list(LambdaQueryWrapper eq flArurcRuleEnabled=1) |
| AC-3 | Yes | 构造器新增 IFlAggregationReportUploadRuleConfigService 参数，final 字段赋值 |
| AC-4 | Yes | 方法首行 version == null 检查，返回 Collections.emptyList() |
| AC-5 | Yes | 所有返回路径均 new ArrayList<>(reportUploadRuleConfigEntityList) |

## Static Analysis
- null 安全: version null 检查在最前; volatile 字段初始化 -1L/null 确保首次进入 synchronized
- 线程安全: synchronized(IcTransactionServiceImpl.class) 与已有 getCnHkStationMap/getTriggerConfigList 模式一致
- 无副作用: 只读查询，不修改业务状态
- 与 ShipmentHeaderInterLinkServiceImpl.getReportUploadRule 模式完全一致

## Final Status
Ready for Merge
