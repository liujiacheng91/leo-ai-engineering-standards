# Test - ic-trans-upload-rule-config

## Test Scope
IcTransactionServiceImpl.getReportUploadStation 方法的 DCL 缓存逻辑.

## Test Matrix

| # | Case | Input | Expected | Related AC |
|---|---|---|---|---|
| 1 | version 为 null | version=null | Collections.emptyList() | AC-4 |
| 2 | 首次调用，version 有值 | version=1L, 缓存为空 | 查询 DB，返回结果拷贝 | AC-1, AC-2 |
| 3 | 相同 version 再次调用 | version=1L, 缓存已有 | 直接返回缓存拷贝，不查 DB | AC-1, AC-5 |
| 4 | version 变化 | version=2L, 缓存 version=1L | 重新查询 DB，更新缓存 | AC-2 |
| 5 | DB 无 enabled 记录 | version=1L, DB 空 | Collections.emptyList() | AC-2 |
| 6 | 返回列表为拷贝 | 修改返回列表 | 不影响内部缓存 | AC-5 |

## Notes
仓库无 src/test 结构，以静态代码审查 + AC 追溯为主要验证手段.
