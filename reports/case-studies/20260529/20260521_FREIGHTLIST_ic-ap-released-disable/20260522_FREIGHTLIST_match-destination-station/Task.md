# Task - match-destination-station

## Tasks

| # | Task | File | Status |
|---|---|---|---|
| 1 | 新增 matchStationConfig 公共方法 | IcTriggerConfigServiceImpl.java | Done |
| 2 | 重构 matchOrigin 委托 matchStationConfig | IcTriggerConfigServiceImpl.java | Done |
| 3 | 实现 matchDestination 委托 matchStationConfig（station_type='DST'） | IcTriggerConfigServiceImpl.java | Done |
| 4 | 更新 matchRule 中 matchDestination 调用签名（补传 config.getId()） | IcTriggerConfigServiceImpl.java | Done |
