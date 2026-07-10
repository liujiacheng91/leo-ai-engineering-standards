# Task.md

## Case ID
20260522_FREIGHTLIST_ic-trigger-origin-country

## Tasks

### T1: 新增 IIcTriggerCountryConfigService 依赖注入
- 文件: `IcTriggerConfigServiceImpl.java`
- 在构造器中添加 `IIcTriggerCountryConfigService` 参数和 `final` 字段

### T2: 修改 matchOriginCountry 方法签名
- 增加 `Integer configId` 参数
- 更新 `matchRule` 中的调用：`matchOriginCountry(meta, config.getOriginCountry(), config.getId())`

### T3: 实现 matchOriginCountry 方法体
- 通配符 `*` 判断
- 查询 `ic_trigger_country_config`（LambdaQueryWrapper: ruleId + countryType='ORG' + deleted=0）
- 空列表返回 false
- 调用 `getOriginCountryFromParties` 获取 origin country
- 空 country 返回 false
- 遍历 country config 列表匹配

### T4: 抽取 getOriginCountryFromParties 私有方法
- 查询条件: `md_app_party_id = keyShipment.shOrigin` 且 `md_app_join_date <= keyShipment.shJobDate`
- 返回第一行的 `md_app_country`，无匹配返回 null
