# Merge Decision - 20260519_FREIGHTLIST_node5-calc-gp

## TL;DR
- Risk Level: Yellow
- 单测本地执行状态: 未执行（原因：worktree + JGit/versioning 插件不兼容；合并后执行 `gradle :expand:business-freightlist-summary:compileJava`）
- 改动文件数: 1
- diff 行数: +45 / -1
- 涉及 LiteFlow 节点: section_profit_share (Node5ProfitShare)
- 涉及 DB 表: 无新增（freightListGpEntity 已在 processIml 中创建并加入 sectionProfitShareList，由 Node11Save 落库到 fl_aggregation_section_profit_share）
- worktree 分支起点: develop_1.1.0

## 关键改动（3 处）
- Node5ProfitShare.java:calcGp -- 填充空方法体：调用 calcFlGpByStation 获取 GP，按 AgentType 分配到 Origin/Dest/Sale1/Sale2，求 Total
- Node5ProfitShare.java:getGpByAgentCode -- 新增辅助方法：遍历 gpByStation 用 isStationsEqual 匹配 agentCode 与站点编码
- Node5ProfitShare.java:import -- 新增 java.util.Map import

## red-lines 绝对禁忌自查
- [x] 未处理密钥 / token / 证书
- [x] 未触及生产数据 / 未脱敏数据
- [x] 未修改 *-prod.yml / 生产 Nexus / 生产 Consul
- [x] 未删除测试 / 降低断言强度
- [x] 未绕过认证 / 授权 / 加密 / 审计
- [x] 未自动合并 Red 风险变更
（全部 Pass）

## TA(code-review) 评审摘要
路径 B（/ll-dev Skill 流），无独立 TA code-review 环节。代码静态审查通过：复用已有 calcFlGpByStation/isStationsEqual/judgeSale/sumBigDecimal，无新增依赖，模式与 calcProfitShareDistribution 一致。

## 建议
合并到 develop_1.1.0（推荐）。改动局限在 calcGp 空方法体填充，不影响 ProfitShareTotal 计算链。

## 用户决策（Step 5 持久化）
- 用户决定: 合并
- 时间: 2026-05-19
- 理由: 改动局限在 calcGp 空方法体填充，编译通过，不影响 ProfitShareTotal
- 返工清单（若选返工）: N/A
- 合并执行记录: merge commit via `git merge feat/node5-calc-gp --no-ff`; 编译验证 `gradle compileJava` BUILD SUCCESSFUL
