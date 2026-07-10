# Merge Decision - 20260521_FREIGHTLIST_ic-trans-system-type-null

## TL;DR
- Risk Level: Yellow
- 单测本地执行状态: 未执行（worktree + JGit/versioning 不兼容；合并后执行 `gradle :expand:business-freightlist-summary:compileJava`）
- 改动文件数: 1
- diff 行数: +10 / -9
- 涉及 LiteFlow 节点: ic_trans_calc_v2 (Node2IcTransCalc)
- 涉及 DB 表: ic_transaction (system_type 字段赋值逻辑)
- worktree 分支起点: develop_1.1.0

## 关键改动（1 处）
- `Node2IcTransCalc.java:784-795` createIcTrans() -- systemType 统一从 keyShipment.shSourceSystem 取值，不再按 station 匹配 ext/shipmentDetail；旧逻辑注释保留

## red-lines 绝对禁忌自查
- [x] 未处理密钥 / token / 证书
- [x] 未触及生产数据 / 未脱敏数据
- [x] 未修改 *-prod.yml / 生产 Nexus / 生产 Consul
- [x] 未删除测试 / 降低断言强度
- [x] 未绕过认证 / 授权 / 加密 / 审计
- [x] 未自动合并 Red 风险变更

## TA(code-review) 评审摘要
路径 B（主 Claude 亲自执行），无独立 TA code-review。代码走读确认：systemType 统一从 keyShipment 取值，与 Node3ShipmentPom.java:390 用法一致；uploadStation 仍从 ext 取，不受影响；旧 systemType 逻辑注释保留供后续调整。

## 建议
合并到 develop_1.1.0（推荐）

## 用户决策
- 用户决定: 合并
- 时间: 2026-05-21
- 理由: 返工后逻辑符合预期，统一从 keyShipment 取 systemType
- 合并执行记录: git merge feat/ic-trans-system-type-null --no-ff to develop_1.1.0
