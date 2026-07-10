# Merge Decision - 20260520_FREIGHTLIST_ic-final-history-station-filter

## TL;DR
- Risk Level: Yellow
- 单测本地执行状态: 未执行（worktree + JGit/versioning 不兼容；合并后在主分支执行 `gradle :expand:business-freightlist-summary:test`）
- 改动文件数: 1
- diff 行数: +26 / -21
- 涉及 LiteFlow 节点: ic_trans_final_calc_v2 (Node3IcTransFinalCalc)
- 涉及 DB 表: ic_transaction_final (查询，未改 schema)
- worktree 分支起点: develop_1.1.0

## 关键改动（3 处）
- `Node3IcTransFinalCalc.java:queryHistoryList` -- 返回历史记录列表替代总金额
- `Node3IcTransFinalCalc.java:calcAmount` -- 遍历历史列表按站点过滤累加，使用 meta.isStationsEqual
- `Node3IcTransFinalCalc.java:buildIcTransFinal` -- 循环外预查询历史列表传入 buildFinalEntity

## red-lines 绝对禁忌自查
- [x] 未处理密钥 / token / 证书
- [x] 未触及生产数据 / 未脱敏数据
- [x] 未修改 *-prod.yml / 生产 Nexus / 生产 Consul
- [x] 未删除测试 / 降低断言强度
- [x] 未绕过认证 / 授权 / 加密 / 审计
- [x] 未自动合并 Red 风险变更

## TA(code-review) 评审摘要
路径 B（/ll-dev Skill 流），无独立 TA code-review 环节。代码改动经主 Claude 静态断言审查通过。

## 建议
合并到 develop_1.1.0（推荐）

## 用户决策（Step 5 持久化）
- 用户决定: 合并
- 时间: 2026-05-20
- 理由: 改动范围小，静态断言通过，red-lines 全 Pass
- 返工清单（若选返工）: N/A
- 合并执行记录: feat/ic-final-history-station-filter 已合并到 develop_1.1.0，代码 commit ca19a74
