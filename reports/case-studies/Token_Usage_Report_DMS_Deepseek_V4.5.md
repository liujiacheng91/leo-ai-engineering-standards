# Token_Usage_Report.md

## Task-Level Token Usage

| Task | Project | Team | Risk | Model | Input Token | Output Token | Total Token | Cost | Retry Count ([Logic]/[Toolchain]/[Assumption]) | Memory/Sub Agent | Saved Hours | Result | Reusable |
|---|---|---|---|---|---|---|---|---|---:|---:|---:|---:|---:|---|---|---|---|
| metacore 服务拆分实现 (Phase A-D) | LL DSMS | - | Yellow | deepseek-v4-pro | 640,000 (estimated) | 210,000 (estimated) | 850,000 (estimated) | N/A - DeepSeek pricing | 7 ([Logic]×2 / [Toolchain]×2 / [Assumption]×3) | No | 40 (estimated) | Partial | Yes — POM/CI/CD 模板可复用 |

## Stage-Level Token Usage

| Stage | Model | Token | Cost | Percentage | Notes |
|---|---|---|---:|---:|---:|---|
| Scenario Analysis | deepseek-v4-pro | 50,000 (estimated) | - | 5.9% | 回顾/修改已有 Scenario.md，更新 Scope/AC |
| Solution Design | deepseek-v4-pro | 160,000 (estimated) | - | 18.8% | Feign 架构、BOM 策略、SNAPSHOT/RELEASE、新建仓方案、4 轮澄清 |
| Code Implementation | deepseek-v4-pro | 520,000 (estimated) | - | 61.2% | Phase A-D 全量代码 + 配置 + CI/CD + Ops_Handoff |
| Test Generation | deepseek-v4-pro | 30,000 (estimated) | - | 3.5% | Test.md 确认/更新 |
| Verification | deepseek-v4-pro | 45,000 (estimated) | - | 5.3% | 4 仓库构建验证 + jar 内容检查 |
| Rework / Retry | deepseek-v4-pro | 45,000 (estimated) | - | 5.3% | 7 次编译修复 (JDK版本、路径、MyBatis依赖、字段缺失) |

## Retry Detail

| # | Category | Issue | Fix |
|---|---|---|---|
| 1 | [Toolchain] | JAVA_HOME 指向 JDK 11，项目需要 JDK 21 | 设置 JAVA_HOME 到 ms-21.0.10 |
| 2 | [Logic] | cp -r src/ 丢失 src 层级，文件在 main/java/ 而非 src/main/java/ | 删除错误目录，重新 cp -r src 到正确路径 |
| 3 | [Logic] | InternalController 引用 feign-client DTO，metacore-service 未依赖 metacore-feign-client | 在 pom.xml 添加模块间依赖 |
| 4 | [Assumption] | FifoMessageSender 使用 MyBatis-Plus StringUtils，adapter 无此依赖 | 替换为 Spring StringUtils.hasText() |
| 5 | [Assumption] | DocumentMetadataDto.getPolicy()/getToDestination() 不存在 | 使用默认值 (M/1)，标记 TODO |
| 6 | [Assumption] | Spring StringUtils 没有 isBlank() 方法 | 替换为 !StringUtils.hasText() |
| 7 | [Toolchain] | metacore-feign-client jar 的 parent pom (dms-metacore) 未安装到本地仓库 | mvn install 整个 metacore-service parent |

## Cost Efficiency

| Metric | Value |
|---|---|
| Cost / Saved Hours | N/A (DeepSeek pricing unknown) |
| Token / Saved Hours | ~21,250 |

> Reference benchmarks: EDI $0.07/hr, VBO $0.18/hr, BizDB $0.59/hr.

## Abnormal Cost Review

| Case | Reason | Action |
|---|---|---|
| Retry #1 [Toolchain] | 本地 JDK 版本与项目要求不一致 | 建议在 CLAUDE.md 或 pom.xml 中显式标注 JAVA_HOME 要求 |
| Retry #4-6 [Assumption]×3 | adapter 新建服务时未预先验证 MyBatis/StringUtils/字段可用性 | Hard Enforcement Layer 执行不到位：写代码前应先读 DTO 源码确认字段 |
| Code Implementation > 60% | 单阶段占比超标 (61.2%) | 正常——本 case 为多仓库拆分实现，代码量集中在实现阶段 |
