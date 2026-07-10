# Test

## P0 用例

| # | 场景 | 验证方式 | 预期 |
|---|---|---|---|
| 1 | partyList 为 null | 代码审查 | 返回 0 |
| 2 | partyList 为空列表 | 代码审查 | 返回 0 |
| 3 | 有一条匹配（partyId 相同、joinDate > now、stage > 0） | 代码审查 | 返回该 party 的 mdAppAutoMode |
| 4 | 多条匹配，joinDate 不同 | 代码审查 | 返回 joinDate 最大那条的 mdAppAutoMode |
| 5 | partyId 匹配但 joinDate <= now | 代码审查 | 不匹配，返回 0 |
| 6 | partyId 匹配但 stage = 0 | 代码审查 | 不匹配，返回 0 |
| 7 | 匹配 party 的 mdAppAutoMode 为 null | 代码审查 | 返回 0 |

## AC Traceability

| AC | Test # |
|---|---|
| AC-1 | 3, 5, 6 |
| AC-2 | 4 |
| AC-3 | 3 |
| AC-4 | 1, 2, 5, 6 |
| AC-5 | 接口 + 调用处同步修改，代码审查 |
