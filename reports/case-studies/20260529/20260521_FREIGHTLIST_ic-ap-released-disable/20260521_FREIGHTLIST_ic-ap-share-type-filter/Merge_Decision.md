# Merge Decision - 20260521_FREIGHTLIST_ic-ap-share-type-filter

## TL;DR
- Risk Level: Yellow
- 单测本地执行状态: 未执行（原因: worktree + JGit/versioning 不兼容; 合并后计划: `gradle :expand:business-freightlist-summary:compileJava`, LiangWB 负责, 合并后立即执行）
- 改动文件数: 1
- diff 行数: +2 / -2
- 涉及 LiteFlow 节点: ic_trigger_v2 (Node1Trigger 调用链)
- 涉及 DB 表: 无（仅改触发判断逻辑，不改落库）
- worktree 分支起点: develop_1.1.0

## 关键改动（1 处）
- IcTriggerConfigServiceImpl.java:251 -- isAllApChargeReleased 方法 AP 判断追加 `&& "P".equals(linkedCharge.getCdlShareType())` 条件，仅检查 share_type=P 的 AP 费用

## red-lines 绝对禁忌自查
- [x] 未处理密钥 / token / 证书
- [x] 未触及生产数据 / 未脱敏数据
- [x] 未修改 *-prod.yml / 生产 Nexus / 生产 Consul
- [x] 未删除测试 / 降低断言强度
- [x] 未绕过认证 / 授权 / 加密 / 审计
- [x] 未自动合并 Red 风险变更

## TA(code-review) 评审摘要
路径 B（/ll-dev Skill 流），无独立 TA code-review 角色。改动由主 Claude 逐行审查：1 处条件追加，最小必要修改，逻辑正确。

## 建议
合并到 develop_1.1.0（推荐）

## 用户决策（Step 5 持久化）
- 用户决定: 合并
- 时间: 2026-05-21
- 理由: 改动最小必要，逻辑正确
- 合并执行记录: merge commit via ort strategy, feat branch commit 905bcdb 合入 develop_1.1.0
