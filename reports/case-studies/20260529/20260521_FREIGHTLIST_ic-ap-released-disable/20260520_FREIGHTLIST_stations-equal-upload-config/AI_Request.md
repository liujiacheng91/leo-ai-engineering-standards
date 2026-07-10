# AI Request

## Meta
- **Case ID**: 20260520_FREIGHTLIST_stations-equal-upload-config
- **Owner**: Liangwb
- **Team**: FREIGHTLIST
- **Project**: bus-freightlist-handler-service
- **Created**: 2026-05-20

## Task
调整 `BusFreightSummaryMetaV1.isStationsEqual` 方法, 在直接相等判断与 cnHkStationMap 映射判断之间, 增加 `reportUploadStationConfigEntityList` 的站点映射判断逻辑.

## Expected Output
- 修改 `BusFreightSummaryMetaV1.java` 的 `isStationsEqual` 方法

## Input
- 用户描述的 5 条逻辑规则

## Branch Info
- **Task Type**: feature
- **Base Branch**: develop_1.1.0

## Entry Check
- [x] 需求明确
- [x] 风险可评估
- [x] 涉及文件已知
