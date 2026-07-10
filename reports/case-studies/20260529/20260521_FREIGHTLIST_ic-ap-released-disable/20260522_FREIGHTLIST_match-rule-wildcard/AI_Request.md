# AI Request

- **Case ID**: 20260522_FREIGHTLIST_match-rule-wildcard
- **Owner**: Liangwb
- **Team**: FREIGHTLIST
- **Project**: bus-freightlist-handler-service
- **Task Type**: feature
- **Date**: 2026-05-22

## Description

IC 触发规则匹配方法 `matchRule` 中，`matchBizType`、`matchShipType`、`matchEntryMode` 三个方法需补充通配符 `*` 支持逻辑：当配置字段值为空或 `*` 时，直接返回 true（不做过滤）。

## Branch Info

- **Base Branch**: develop_1.1.0
- **Task Type**: feature
