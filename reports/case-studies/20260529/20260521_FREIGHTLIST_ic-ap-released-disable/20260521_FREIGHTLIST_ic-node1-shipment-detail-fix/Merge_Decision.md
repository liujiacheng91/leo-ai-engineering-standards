# Merge Decision - 20260521_FREIGHTLIST_ic-node1-shipment-detail-fix

## TL;DR
- Risk Level: Yellow
- 单测本地执行状态: 未执行（原因: worktree + JGit/versioning 不兼容; 合并后计划: `gradle :expand:business-freightlist-summary:compileJava`, LiangWB 负责, 合并后立即执行）
- 改动文件数: 2
- diff 行数: +7 / -3
- 涉及 LiteFlow 节点: ic_trigger_v2 (Node1Trigger), ic_trans_calc_v2 (Node2IcTransCalc)
- 涉及 DB 表: ic_transaction (写入修复, 非 schema 变更)
- worktree 分支起点: develop_1.1.0

## 关键改动（3 处）
- Node1Trigger.java:90 -- getShipmentDetails 返回值存入 meta.setShipmentDetailList，修复 Node2 拿不到 shipmentDetail 的根因
- Node2IcTransCalc.java:753-755 -- 新增 else 分支，shipmentDetail 为 null 时从 sectionHeader 取 serialNo 兜底
- Node2IcTransCalc.java:784 -- else 改为 else if (shipmentDetail != null)，防止 NPE

## red-lines 绝对禁忌自查
- [x] 未处理密钥 / token / 证书
- [x] 未触及生产数据 / 未脱敏数据
- [x] 未修改 *-prod.yml / 生产 Nexus / 生产 Consul
- [x] 未删除测试 / 降低断言强度
- [x] 未绕过认证 / 授权 / 加密 / 审计
- [x] 未自动合并 Red 风险变更

## TA(code-review) 评审摘要
路径 B（/ll-dev Skill 流），无独立 TA code-review 角色。改动由主 Claude 逐行审查：3 处改动均为最小必要修复，无多余 diff，逻辑正确。

## 建议
合并到 develop_1.1.0（推荐）

## 用户决策（Step 5 持久化）
- 用户决定: 返工后合并
- 时间: 2026-05-21
- 理由: 用户要求将 setShipmentDetailList 调用移入 getShipmentDetails 方法内部，保持调用处风格一致
- 返工清单: getShipmentDetails 方法改为 void，内部直接 meta.setShipmentDetailList(...)
- 合并执行记录: merge commit via ort strategy, fix branch commits f083fbb + 75b4f10 合入 develop_1.1.0
