# AI Request

- **Case ID**: 20260522_FREIGHTLIST_match-destination-station
- **Owner**: dara.heng@transpeed.com.sg
- **Team**: FREIGHTLIST
- **Project**: bus-freightlist-handler-service
- **Task Type**: feature
- **Created**: 2026-05-22

## Description

补充 matchRule 中 destination 字段的匹配逻辑，与 origin 逻辑对称，查询 ic_trigger_station_config 表 station_type='DST' 的记录进行匹配。同时将 origin 和 destination 的公共逻辑抽取为独立方法。

## Expected Deliverables

- matchDestination 方法实现（station_type='DST'）
- matchOrigin 和 matchDestination 共用的 matchStationConfig 方法
- matchRule 调用签名更新

## Branch Info

- **Base Branch**: develop_1.1.0
- **Task Type**: feature
- **New Branch Name**: N/A（路径 B Mode 1，直接 commit 到 develop_1.1.0）

## Entry Check

- [x] 需求明确
- [x] 涉及文件已定位
- [x] 风险等级已评估：Green
