# Scenario - upload-station-logic

## Background

FL 链 Node3 (section_pom) 生成 PDF 上传规则时，需要确定每个分利方的上传站点。当前 `BusFreightSummaryMetaV1.getUploadStations` 返回 `List<String>`（所有匹配站点列表），Node3 需循环遍历列表逐个放入 uploadMap。

IC 链的 `IcTransMetaItem.getUploadStations` 已采用更简洁的模式：返回 `String`（首个匹配站点或 agentCode 兜底）。本次将 FL 版本对齐 IC 版本。

## Assumptions

- 每个 agentCode 在 `reportUploadStationConfigEntityList` 中最多只有一条有效配置（或取首条即可满足业务需求）
- `getUploadStations` 在 `BusFreightSummaryMetaV1` 上的唯一调用方是 Node3（已通过 Grep 验证）
- IC 版本的模式已在线上稳定运行，FL 对齐不引入新风险

## Acceptance Criteria

- AC-1: 当 agentCode 有配置上传站点时，应返回该配置站点字符串（非列表）
- AC-2: 当 agentCode 无配置上传站点时，应返回 agentCode 本身作为兜底
- AC-3: 当 agentCode 为空时，应返回 null
- AC-4: Node3 调用 getUploadStations 后，将非空结果以 first-wins 方式写入 uploadMap
