# Scenario - ic-trans-stations-equal

## Background
BusFreightSummaryMetaV1.isStationsEqual 已增加 reportUploadStationConfigEntityList 站点映射判断（case 20260520_FREIGHTLIST_stations-equal-upload-config），但 IcTransMetaItem.isStationsEqual 仍是旧逻辑，两者不一致。

## Acceptance Criteria
- AC-1: station1==agentCode && station2==uploadStation 时 return true
- AC-2: station2==agentCode && station1==uploadStation 时 return true
- AC-3: 新逻辑插入在步骤2（直接相等）之后、步骤4（cnHkStationMap）之前
- AC-4: reportUploadStationConfigEntityList 为 null 或空时跳过该步骤
- AC-5: 循环内匹配即 return true
