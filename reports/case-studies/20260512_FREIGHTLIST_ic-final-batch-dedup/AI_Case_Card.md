# AI_Case_Card.md

## Basic Info

- **Case ID**: 20260512_FREIGHTLIST_ic-final-batch-dedup
- **Team**: FREIGHTLIST
- **Project**: bus-freightlist-handler-service
- **Scenario**: IC_TRANS_FINAL 链 `IcTransactionFinalServiceImpl.start()` 增加批内按 `(globalInterLink, version)` 去重，修复同 batch 重复事件导致 `ic_transaction_final` 翻倍落库（6 行 → 12 行）的问题
- **Risk Level**: 🟡 **Yellow**
- **AI Tool**: Claude Code
- **Model**: Opus 4.7（主编排） + Sonnet（RA / Dev / QA） + Opus（TA review / architecture / code-review）
- **Owner**: Liangwb（用户）

## Outcome

- **Original Estimate**: ~7 小时（含定位 2-3h、设计 1h、实现 0.5h、测试 2h、验证 1h）
- **Actual Time**: ~2 小时（端到端 AI 辅助瀑布，含 7 次子 agent 派活 + 主 Claude 编排）
- **Saved Time**: ~5 小时
- **Token Cost**: 子 agent 汇总 312,254 tokens / ~$3.39 USD；详见 `Token_Usage_Report.md`
- **Result**: **Pass**（编译 / 静态断言 / AC trace / 现有测试回归 五道关卡全通过；10 个新单测代码已就绪，待合并后执行）
- **Reusable**: **Yes**（本 case 的 5 类用例模板 + Mockito 切入点可作为后续 service 层去重 / 幂等性补丁的参考；批内去重的 `LinkedHashMap` + `putIfAbsent` 模式可在仓库其他类似场景复用）

## Human Intervention

| Point | Reason | Decision | Owner |
|---|---|---|---|
| 选择修复方案 | 用户在主 Claude 提出 ABCD 四个方案后，明确"只做方案 B（start() 入链前 distinct）"，否决方案 A（Node3 删后插）/ C（A+B 组合）/ D（分布式锁） | 仅做批内去重，跨批次 race 由 Node1 现有检查兜底 | 用户 |
| 接受残余风险 | 用户明确接受"跨批次 / 并发消费 race 不修"的残余风险 | Scenario 范围边界落 D3 已确认条件 | 用户 |
| Solution.md 拍板 | Yellow 铁律要求人工确认 Solution 才能派开发 | 用户回复"确认执行" | 用户 |
| QA 决定 | 主 Claude 在 code-review 通过后未询问跳 QA，用户提前指示"后续不跳过 QA" | 全流程跑 QA | 用户 |
| JGit/worktree 兼容性问题处理 | QA 在 worktree 内跑测试遇到 versioning 插件 NoHeadException | 用户决定"接受现状继续收尾"，单测代码 commit 待合并后执行；并要求"以后碰到类似 JGit 问题都这样做"（已落 auto-memory） | 用户 |

## Lessons Learned

### What worked

1. **5 阶段瀑布顺畅落地**：RA(draft) → TA(review) → RA(finalize) → TA(architecture) → 用户拍板 → Dev → TA(code-review) → QA → 收尾，每阶段产出文档边界清晰，无返工
2. **Karpathy Simplicity First 守住**：用户多次明确反对扩大改动面（Node3 删后插 / DB 索引 / 分布式锁 / @Transactional），Solution 最终落 12 行增量代码、AC 全覆盖；TA(architecture) 在 §1 路径选型段显式列出并否决了 6 个备选方案，避免后续返工
3. **TA(review) 主动闭环 Q1**：RA 草案的 Q1 不是丢给用户，而是 TA 用工具实际验证后给出代码层结论，节省一轮用户确认
4. **前置 case 显式留痕**：20260511 case Scenario.md §"已知问题" L114-118 当初就把幂等性问题留待后续 case 处理，本次 case 直接 reference 落地，避免重新定位
5. **现象 → 根因定位高效**：用户提供 2 条 `ic_transaction` + 2 条 `ic_transaction_final` 样本，主 Claude 在 2 轮对话内定位到根因（mirror pair 正确 → final 表才是重复，再到 batch 内重复 metaItem）

### What failed

1. **`startSingle()` 漏检**：RA 草案最初未提到 `startSingle()` 是否需要同步处理，scenario-review 才补上"无需改"的判断
2. **测试基础设施缺失**：仓库 `expand/business-freightlist-summary` 当前没有 `src/test` 目录与测试依赖，QA 实际跑测试遇阻；属于仓库的工程基础设施债，不是本 case 的问题
3. **JGit + worktree 兼容性**：`net.nemerosa.versioning` 插件用 JGit 读 worktree 的 `.git` 文件指针失败，导致 QA 单测无法在 feat 分支 worktree 内直接执行；按用户指示"合并后跑测试"标准动作处理，并落 auto-memory

### What to improve

1. **应另立 case 修测试基础设施**：建议起一个独立 case `YYYYMMDD_FREIGHTLIST_test-infra-setup`，给 `business-freightlist-summary` 模块加 `src/test/java` + JUnit 5 + Mockito 依赖，让后续 service 层改造都能跑单测
2. **应另立 case 修 versioning 插件兼容性**：建议起一个独立 case 评估是否禁用 versioning 插件、或换用其他兼容 worktree 的版本号方案；不再让 QA 在 worktree 内跑测试受限
3. **应另立 case 解决跨批次 / Kafka 重投 race**：本 case 只压同 batch 窗口，跨批次 race 由 Node1 现有检查兜底但有窗口期；建议起 case 评估 Node3 删后插 / DB 唯一索引 / 分布式锁 三种方案
4. **建议在前置 case L114-118 升级 supersede 关系**：本次 case 已落地"批内去重"，前置 case 的"已知问题"段可以在 finalize 时改成 "amends 关系" 或加 follow-up 链接，避免后续读者重复定位
