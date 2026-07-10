# Test.md

## Test Objective

验证 `IcTriggerConfigServiceImpl.matchOriginCountry` 方法在各种输入条件下返回正确的匹配结果，覆盖 Scenario.md AC-1 至 AC-7。

---

## Test Scope

- In scope: `matchOriginCountry` 方法、`getOriginCountryFromParties` 辅助方法、`matchRule` 中对 `matchOriginCountry` 的调用传参
- Out of scope: 其他 8 个 match 维度方法、LiteFlow 节点逻辑、Kafka 消息解析

---

## Test Data

| Case | Input | Expected |
|---|---|---|
| 通配符 | originCountry="*" | return true |
| 国家配置为空 | originCountry="CN", countryConfigList=[] | return false |
| origin匹配成功 | originCountry="CN", countryConfigList=[CN,HK], parties.country=CN | return true |
| origin匹配失败 | originCountry="CN", countryConfigList=[HK,SG], parties.country=JP | return false |
| keyShipment为空 | keyShipment=null | return false |
| shOrigin为空 | shOrigin=null/blank | return false |
| parties查无结果 | parties=[] | return false |

---

## Mock Strategy

- Mock framework: Mockito
- Objects to mock: `IIcTriggerCountryConfigService`, `IMdAutoProgramPartiesService`
- Stub setup location: inline in each test
- Strictness setting: LENIENT (多个 stub 不一定每个 test 都用到)

---

## Test Types

- [x] Unit Test
- [x] Manual Verification (静态代码审查)

---

## Test Matrix

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-01 | Unit | originCountry="*" | true | High | AC-1 |
| TC-02 | Unit | countryConfigList=empty | false + triggerLog | High | AC-2, AC-3 |
| TC-03 | Unit | countryConfigList=[CN], parties.country=CN | true | High | AC-4, AC-5, AC-6 |
| TC-04 | Unit | countryConfigList=[HK,SG], parties.country=JP | false + triggerLog | High | AC-6 |
| TC-05 | Unit | keyShipment=null | false + triggerLog | Medium | AC-4 |
| TC-06 | Unit | shOrigin=blank | false + triggerLog | Medium | AC-4 |
| TC-07 | Unit | parties=empty | false + triggerLog | Medium | AC-5 |
| TC-08 | Unit | configId=null | 查询不报错 | Low | AC-2 |

---

## Boundary Cases

| Scenario | Input | Expected Behavior |
|---|---|---|
| configId为null | configId=null | LambdaQueryWrapper eq(null) 不抛异常 |
| parties返回多行 | parties=[{country:CN},{country:HK}] | 取第一行CN |
| originCountry为空字符串 | originCountry="" | 不等于"*"，走正常匹配流程 |

---

## Fix History

| # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
| (empty) | | | | |
