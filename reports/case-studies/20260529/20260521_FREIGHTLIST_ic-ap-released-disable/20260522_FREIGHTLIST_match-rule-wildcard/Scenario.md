# Scenario - match-rule-wildcard

## Background

IC 触发规则配置表 `ic_trigger_config` 中，`biz_type`、`ship_type`、`entry_mode` 三个字段在 `matchOrigin` 等方法中已支持通配符 `*`（值为 `*` 时匹配所有），但 `matchBizType`、`matchShipType`、`matchEntryMode` 仅处理了空值（`StringUtils.isBlank`），未处理 `*`。

## Acceptance Criteria

- AC-1: 当 `ic_trigger_config.biz_type` 为 `*` 时，`matchBizType` 应返回 true
- AC-2: 当 `ic_trigger_config.ship_type` 为 `*` 时，`matchShipType` 应返回 true
- AC-3: 当 `ic_trigger_config.entry_mode` 为 `*` 时，`matchEntryMode` 应返回 true
- AC-4: 原有空值返回 true 的逻辑不受影响
- AC-5: 非空且非 `*` 的值仍走原有精确匹配逻辑
