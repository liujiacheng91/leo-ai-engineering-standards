# Scenario Benefit Matrix

## Risk-Benefit Quadrant

```
                        High Benefit
                            |
     Rule Framework         |         Calculation Logic
     Field Chain            |         Bug Fix (complex)
     EDI Mapping            |         DB / Node Chain
                            |
  Low Risk ─────────────────┼───────────────────── High Risk
                            |
     Green Small Change     |         Temporary Disable
     Documentation          |
     Code Explanation        |
                            |
                        Low Benefit
```

Prioritization:
- **Top-left (high benefit, low-medium risk)**: prioritize for AI adoption and asset reuse
- **Top-right (high benefit, high risk)**: apply with strong verification gates and human-in-the-loop
- **Bottom-left (low benefit, low risk)**: apply Green Minimal Path to minimize overhead
- **Bottom-right (low benefit, high risk)**: exception-only, requires business governance (scope boundary)

## Scenario Detail

| 场景 | 收益 | 风险 | Quadrant | Git / Skill 要求 | 参考案例 / 成本基准 |
|---|---|---|---|---|---|
| 文档补齐 / PR 描述 | 高 | 低 | Top-left | pr-summary / templates | -- |
| 代码解释 / 旧代码梳理 | 高 | 低 | Top-left | Code_Understanding Prompt | -- |
| 测试用例生成 | 高 | 中 | Top-left | test-design + Verify.md | VBO: 39 tests, $0.18/hr |
| 简单 CRUD / 非核心功能 | 高 | 低/中 | Top-left | ll-dev Green Path (Green Minimal Path for <50 lines) | Green Minimal Path: 20-50K tokens |
| SQL 初版 / 报表转换 | 中/高 | 中/高 | Top-right | Business_Rules + Solution | -- |
| 字段 Mapping / XML JSON 转换 | 中 | 高 | Top-right | Mapping_Rules + Yellow Path | EDI: $0.07/hr, Dyson: $0.10/hr |
| 客户差异化 / 复杂业务规则 | 中 | 高 | Top-right | Business_Rules + Human Confirm | -- |
| 规则框架搭建 + 字段批量补齐 | 高 | 中 | Top-left | ll-dev Yellow Path (Mode 1) | FREIGHTLIST: 100-135K tokens, $1.17-$3.00/hr |
| 字段链路补齐 (Entity + Mapper + Node) | 中/高 | 中 | Top-left | ll-dev Yellow Path (Mode 1) | ic-section-header-ic-type: 80K, $1.07/hr |
| 业务计算逻辑实现 | 高 | 中/高 | Top-right | ll-dev Yellow Path + Bug Fix pre-check | node5-calc-gp: 205K, $2.29/hr |
| Bug Fix (根因定位) | 中/高 | 中 | Top-right | ll-dev + Behavior item 10 (pre-check) | system-type-null: Human-in-the-loop 纠偏 |
| Trigger 条件过滤 / 临时关闭 | 低/中 | 中/高 | Bottom-right | ll-dev Green/Yellow Path | 临时关闭类需恢复计划 (scope boundary) |
| 认证/授权/加密/审计/生产配置 | 低/中 | 高 | Bottom-right | Red Path，仅分析 | -- |
