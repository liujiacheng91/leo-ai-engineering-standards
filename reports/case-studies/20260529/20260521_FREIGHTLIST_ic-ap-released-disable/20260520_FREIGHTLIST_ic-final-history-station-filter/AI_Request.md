# AI_Request.md

## Task Metadata

- Case ID: 20260520_FREIGHTLIST_ic-final-history-station-filter
- Owner: Liangwb
- Team: FREIGHTLIST
- Project: bus-freightlist-handler-service
- AI Tool: Claude Code
- Entry Check: follow-up of ic-final-history-globalinterlink

## Input

- Node3IcTransFinalCalc.java (ic_trans_final_calc_v2)

## Expected Output

- calcHistoryTotal 返回历史记录列表而非总金额
- buildFinalEntity 接收历史列表，按站点过滤后计算 historyTotal
- 站点比较使用 meta.isStationsEqual 方法

## Branch Info

- Task Type: feature
- Base Branch: develop_1.1.0
