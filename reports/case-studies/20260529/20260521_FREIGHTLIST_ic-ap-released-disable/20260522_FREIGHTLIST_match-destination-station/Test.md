# Test - match-destination-station

## Test Scope

matchDestination 方法逻辑验证 + matchOrigin 重构后行为不变验证

## Test Matrix

| # | Case | Type | Related AC | Expected |
|---|---|---|---|---|
| T-1 | destination 配置为 * | normal | AC-1 | matchDestination 返回 true |
| T-2 | DST 站点配置存在且 station 匹配 shDestination | normal | AC-2 | matchDestination 返回 true |
| T-3 | DST 站点配置存在但无 station 匹配 | negative | AC-3 | matchDestination 返回 false，触发日志含"destination不匹配" |
| T-4 | DST 站点配置为空（无记录） | boundary | AC-3 | matchDestination 返回 false，触发日志含"未找到DST站点配置" |
| T-5 | origin 配置为 *（重构后） | regression | AC-4 | matchOrigin 返回 true |
| T-6 | ORG 站点配置存在且匹配（重构后） | regression | AC-4 | matchOrigin 返回 true |
| T-7 | ORG 站点配置不匹配（重构后） | regression | AC-4 | matchOrigin 返回 false |

## Mock Strategy

- 仓库无 src/test，单测暂不编写
- 验证依赖代码静态审查 + 与 matchOrigin 的对称性比对

## Fix History

（无）
