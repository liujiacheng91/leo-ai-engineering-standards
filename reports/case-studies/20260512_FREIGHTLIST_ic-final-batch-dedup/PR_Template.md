# Pull Request Template

## Summary

修复 IC_TRANS_FINAL 链在同一 Kafka batch 内含重复 `(globalInterlink, version)` 事件时的"翻倍落库"问题。

**根因**：`IcTransactionFinalServiceImpl.start()` 凑 `metaItems` 时无去重逻辑；当上游同 batch 推送 2 条同业务键事件，链路对每条各跑一次完整的 Node2/Node3，导致同一笔 IC 交易在 `ic_transaction_final` 落 12 行（预期 6 行 = mirror 对 × 3 行 H+P0005+OTH-PS）。

**修复**：在 `start()` 方法的 `metaItems` 凑完之后、`dispatch(...)` 调用之前，使用 `LinkedHashMap<String, IcTransFinalMetaItem>` + `putIfAbsent` 按 `globalInterLink + "#" + version` 为键去重，FIFO 保留先到的 metaItem。仅命中去重时打 `log.info`，无重复不打日志（避免噪声）。

**范围**：仅 1 个文件 (`IcTransactionFinalServiceImpl.java`)、1 个方法 (`start`)、净增 12 行；不动 Node1 / Node2 / Node3、不动 entity 与表结构、不动事务、不引新依赖。

**关联前置 case**：[20260511_FREIGHTLIST_ic-final-shared-trans-no](../20260511_FREIGHTLIST_ic-final-shared-trans-no/Scenario.md) §"已知问题" L114-118 显式留待后续 case 处理，本次落地。

## Related Documents

完整 AI 辅助开发过程文档在 `docs/ai/cases/20260512_FREIGHTLIST_ic-final-batch-dedup/`：

- [AI_Request.md](AI_Request.md) — 任务元数据
- [Scenario.md](Scenario.md) — 业务背景 / 5 条 AC / 6 条已确认前置条件
- [AI_Risk_Level.md](AI_Risk_Level.md) — 🟡 Yellow
- [scenario-review.md](scenario-review.md) — TA(review) 评审，0 must-fix
- [Solution.md](Solution.md) — 路径选型 / 实现拆解 / 测试策略 / 回滚方案
- [Task.md](Task.md) — 开发实现拆解 + 验证证据
- [impl-notes.md](impl-notes.md) — 实现决策日志
- [code-review.md](code-review.md) — TA(code-review) 评审，通过
- [Test.md](Test.md) — 5 类测试用例设计（normal / boundary / negative / regression / data comparison）
- [Verify.md](Verify.md) — 执行证据（编译 / 静态断言 / AC trace / 现有测试回归）
- [AI_Case_Card.md](AI_Case_Card.md) — case 卡片
- [Token_Usage_Report.md](Token_Usage_Report.md) — token / cost 报告

## AI Assistance

- **Tool**: Claude Code
- **Model**: Opus 4.7 (主 Claude 编排) + Sonnet (RA / Dev / QA 子 agent) + Opus (TA 子 agent)
- **Risk Level**: 🟡 **Yellow**
- **Token Cost**: 总 ~312,254 tokens（子 agent 汇总），约 $3.39 USD（不含主 Claude 编排）；详见 `Token_Usage_Report.md`

## Validation

- [x] **Build**：`gradle :service:bus-freightlist-handler-service:bootJar` BUILD SUCCESSFUL（worktree 内 29s + QA 重验 14s）
- [x] **Static Assertion**：5 个关键代码断言点全部命中（`LinkedHashMap` / `putIfAbsent` / 拼接键 / 条件 `log.info` / `new ArrayList<>(map.values())`）
- [x] **AC 手工 trace**：AC-1 ~ AC-5 全部覆盖
- [x] **Regression**：主仓库 11 个现有测试 BUILD SUCCESSFUL 全 PASSED
- [x] **Other Chains 影响**：grep 确认 FREIGHT_LIST / IC_TRANS 链零影响
- [ ] **Unit Test 实际执行**：10 个新 Mockito 单测代码已 commit 到 `feat/ic-final-batch-dedup`（commit `e3693cb`），但因 `net.nemerosa.versioning` 插件与 git worktree `.git` 文件指针不兼容（JGit NoHeadException），无法在 worktree 内执行；**合并到 `develop_1.1.0` 后跑** `gradle :expand:business-freightlist-summary:test` 即可
- [ ] Integration Test — N/A，本 case 无集成测试
- [x] **Lint**：仓库无 lint 步骤；编译 warning 仅 4 个既有 rawtype/unchecked，与本次改动无关
- [ ] Security Scan — N/A，无 secret / 加密改动
- [ ] Secrets Scan — N/A，无敏感数据

## Security Checklist

- [x] **No secrets exposed**：无任何 token / key / 证书改动
- [x] **No production data used**：开发与 QA 全程基于代码静态分析与本地编译，未访问生产 / UAT DB
- [x] **No production config changed**：未动 `*-prod.yml`、未动 `bootstrap.yml`、未动任何环境配置
- [x] **No auth / audit bypassed**：本改动仅去重，不涉及认证 / 授权 / 审计逻辑

## Reviewer Notes

### 改动文件清单

- `expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/impl/IcTransactionFinalServiceImpl.java`（L74-84 新增 12 行）
- `expand/business-freightlist-summary/src/test/java/com/pobing/bus/freight/list/summary/service/impl/IcTransactionFinalServiceImplTest.java`（新增文件，10 个 Mockito 测试方法）

### 关注点

1. **去重键完整性**：TA(review) 已实际验证 `InterComTransFinalEvent` 仅 `globalInterlink + version` 两个字段、`IcTransactionEntity.version` 注释为"时间戳(version)"代表锁账周期；`(globalInterLink, version)` 在 IC_TRANS_FINAL 业务上等价于"同锁账周期同票货"，去重键无歧义
2. **保留先到**：使用 `putIfAbsent` 实现 FIFO，与 batch 内事件先后顺序一致；后到的同 key 事件被丢弃
3. **跨批次 race 未修**：本 case 边界明确仅覆盖"同 batch 内重复"；跨批次 / Kafka 重投 race 由 Node1 现有存在性检查兜底，用户已确认接受残余风险

### 合并后 follow-up（不阻塞合并）

合并到 `develop_1.1.0` 后**必跑一次** `gradle :expand:business-freightlist-summary:test`，确认 10 个新单测全部 PASS，结果回填到 `Verify.md` §"无法执行的验证项" 段作为补充证据。

### 风险等级与合并

🟡 Yellow 风险按 `.claude/rules/commit-branch.md` 必须由用户人工确认合并；AI 不得自动合并。
