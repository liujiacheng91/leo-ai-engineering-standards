# Merge Decision - 20260520_FREIGHTLIST_ic-final-history-globalinterlink

## TL;DR
- Risk Level: Yellow
- 单测本地执行状态: 未执行（worktree + JGit/versioning 插件不兼容；合并后在主分支执行 `gradle :expand:business-freightlist-summary:compileJava`）
- 改动文件数: 1
- diff 行数: +38 / -32
- 涉及 LiteFlow 节点: ic_trans_final_calc_v2 (Node3IcTransFinalCalc)
- 涉及 DB 表: ic_transaction_final (查询，未改表结构)
- worktree 分支起点: develop_1.1.0

## 关键改动（3 处）
- Node3IcTransFinalCalc.java:calcHistoryTotal -- 新方法，按 globalInterlink 替代 serialNo 查询历史总额
- Node3IcTransFinalCalc.java:buildIcTransFinal -- isDiffAmount 和 historyTotal 提到循环外预计算
- Node3IcTransFinalCalc.java:calcAmount -- 签名改为接收预计算参数，不再调用 meta

## red-lines 绝对禁忌自查
- [x] 未处理密钥 / token / 证书
- [x] 未触及生产数据 / 未脱敏数据
- [x] 未修改 *-prod.yml / 生产 Nexus / 生产 Consul
- [x] 未删除测试 / 降低断言强度
- [x] 未绕过认证 / 授权 / 加密 / 审计
- [x] 未自动合并 Red 风险变更

## TA(code-review) 评审摘要
路径 B（LL Skill 流），无 TA code-review 环节。静态断言全部通过，改动逻辑清晰。

## 建议
合并到 develop_1.1.0（推荐）

## 用户决策
- 用户决定: 合并
- 时间: 2026-05-20
- 理由: 改动明确，静态断言通过
- 返工清单（若选返工）: N/A
- 合并执行记录: merge commit `1201eb2`，code commit `6beeeca`
