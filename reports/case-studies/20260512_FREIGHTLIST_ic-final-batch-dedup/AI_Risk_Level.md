# AI_Risk_Level - 20260512_FREIGHTLIST_ic-final-batch-dedup

## 风险等级

🟡 **Yellow**

## 判定依据

### 命中本仓库默认值表的条目

参照 `.claude/rules/ll-standards.md` "本仓库的风险默认值"小表：

| 改动维度 | 命中条目 | 默认风险 |
|---|---|---|
| 修改 service 层方法（非 LiteFlow 节点） | 表中无直接条目，但靠近"修改 LiteFlow 链上某节点的非算法部分"行的语义（service 是节点的上游编排层）| 🟡 Yellow |
| 影响"链路输入数据"正确性（决定有多少 metaItem 进入 chain）| 等价于"非算法但影响数据正确性" | 🟡 Yellow |
| 不动 entity / mapper / 普通 service 的字段或 DDL | 不命中 Red 中 schema 变更项 | 不上调 |
| 不动 application-prod.yml / bootstrap.yml | 不命中 Red 中生产配置项 | 不上调 |
| 不动 Kafka topic / busType / chainId | 不命中 Red 中跨服务影响项 | 不上调 |
| 不动 Node5 / Node10 / Node11 / Node3FinalSave 等"共享果子 / 唯一落库节点" | 不命中 Red 中"共享果子"项 | 不上调 |
| 不影响 PDF 团队（字段、表结构、schema 全部不变） | 不命中 Yellow 加码项"新增字段（影响 PDF 团队）"| 不上调 |

### 综合判定

- **下行约束（为什么不能降到 Green）**：本次改动**直接决定有多少 metaItem 进入 chain**，进而决定 IC_TRANS_FINAL 落库的行数和正确性。即便代码量小（5-8 行）、改动面窄（1 个方法），其语义对生产数据的可见性不属于 Green 范畴的"文档补齐 / 注释 / 简单 CRUD"。Green 的典型例子是"不动业务结果的纯样板代码"，本 case 不属于。
- **上行约束（为什么不需升到 Red）**：
  - 不动 chain 节点（Node1 / Node2 / Node3FinalSave 全部保持原样）
  - 不动 entity / mapper / DB schema
  - 不动事务边界 / 不引入 `@Transactional` / 不加分布式锁 / 不加唯一索引
  - 不动生产配置（任何 `*-prod.yml`）
  - 不动 Kafka topic / busType / chainId
  - 不属于"红冲蓝补 / ProfitShareTotal 等共享果子算法"
  - 不属于"Node11Save 等唯一落库节点改造"

- **结论**：稳定落 Yellow，**不**上调到 Red，**不**下调到 Green。与 RA 初判（AI_Request.md L64-65、Scenario.md §初步风险等级建议 L96-104）一致。

## 适用规则（Yellow 等级下 AI 允许 / 禁止的动作）

参照 `.claude/rules/ll-standards.md` 二、风险三级判定 表与 `.claude/rules/agent-workflow.md`：

### ✅ AI 允许

- 由 `tech-architect`（architecture 模式）产出 `Solution.md`，含选型、影响面、回滚方案
- 由 `java-backend-engineer` 在 **Solution.md 经用户人工确认后**实现代码，落到独立分支 `feat/ic-final-batch-dedup`（worktree 隔离）
- 由 `qa-engineer` 设计 `Test.md`（normal / boundary / negative 三类够用，regression / data comparison 视需要）+ 执行 `Verify.md`
- 由 `tech-architect`（code-review 模式）评审实现，产出 `code-review.md`
- Mockito 单元测试可由 AI 自主编写并运行

### ❌ AI 禁止

- **未经用户人工确认 Solution.md 就开始改代码** —— Yellow 铁律
- **未经用户 sign-off 就合并 PR** —— Yellow 铁律
- **越界改动**：超出 `IcTransactionFinalServiceImpl.start(...)` 方法 dedup 段的任何代码改动（含构造器签名、cnHkStationMap 缓存逻辑、`startSingle`、Node1/2/3FinalTrigger 等）须停下来重新评估范围
- **绕过 Stop Conditions**：自修复 ≥ 3 次（编译 / 单测反复失败）必须停下汇报，不允许在循环里堆 token

### 调用 Agent 时的 Model Selection

参照 `.claude/rules/ll-standards.md` "Model Selection"：

| 阶段 | Agent | 建议 model |
|---|---|---|
| Scenario 评审（本阶段） | tech-architect (review) | sonnet（已在用，简单评审无需 opus）|
| Solution 设计 | tech-architect (architecture) | opus（架构决策标准） |
| Task 拆解 + 编码 | java-backend-engineer | sonnet（标准 Yellow 多文件改造，此处实际只 1 文件） |
| code-review | tech-architect (code-review) | sonnet 起步（改动面极小，可不升 opus） |
| Test 设计 + Verify | qa-engineer | sonnet（验证卡 ≥2 次再升 opus） |

## 最低文档集（Yellow 等级必填）

参照 `docs/ai/cases/README.md` "风险等级最低文档集"：

```text
AI_Request.md          ✅ 已就绪
Scenario.md            ✅ 已就绪（待 finalize）
AI_Risk_Level.md       ✅ 本文档
Solution.md            ⏳ 待 TA(architecture) 产出
Task.md                ⏳ 待 java-backend-engineer 产出
Test.md                ⏳ 待 qa-engineer 产出
Verify.md              ⏳ 待 qa-engineer 产出
AI_Case_Card.md        ⏳ 待主 Claude 收尾产出
Token_Usage_Report.md  ⏳ 待主 Claude 收尾产出
```

不需要的（针对本 case）：

- `Business_Rules.md`：本 case 不涉及业务规则的新增 / 修订（去重逻辑是技术补丁，业务结果保持"原本就应该产生 6 行而不是 12 行"的预期，不是新业务规则）
- `Mapping_Rules.md`：本 case 不涉及字段映射 / XML / JSON 转换 / 报表 SQL

## 红线检查（参照 `.claude/rules/red-lines.md`）

| 红线项 | 命中？ | 备注 |
|---|---|---|
| 处理密钥 / Token / 证书 | ❌ | 无 |
| 处理生产数据 / 未脱敏客户数据 | ❌ | 仅修改代码逻辑，不接触生产数据 |
| 访问生产环境 / 生产 DB | ❌ | 无 |
| 修改生产配置（`*-prod.yml` 等） | ❌ | 不动任何 YAML |
| 删除测试 / 降低断言强度 | ❌ | 反而要新增 Mockito 测试 |
| 绕过认证 / 授权 / 加密 / 审计 | ❌ | 无 |
| 自动合并 Red 变更 | ❌（非 Red） | — |
| 改 `@LiteflowComponent` 字符串值 | ❌ | 不动 LiteFlow 节点 |
| 改节点数字编号 | ❌ | 不动 LiteFlow 节点 |
| `process()` rethrow 异常 | ❌ | 不动 LiteFlow 节点 |
| 字段前缀新造缩写 | ❌ | 不动字段 |
| 字段 `@Autowired` 取代构造器注入 | ❌ | 不动构造器 |
| 业务节点直写 `*_history` 表 | ❌ | 不动 |
| 用遗留版 `BusFreightListMeta`（不带 V1） | ❌ | 与本 case 无交集（IC 链不用 V1 Meta） |

全部不命中红线。

## 风险等级铁律自检

> **No Risk Level, No AI Execution.**

本文档已产出，主 Claude 可据此推进下一阶段（TA architecture）。Yellow 等级下，TA(architecture) 产出的 `Solution.md` **必须由用户人工确认**后才能派 java-backend-engineer 实现。

---

Token usage: 由主 Claude 收尾时根据本次评审的实际消耗汇总到 `Token_Usage_Report.md`。
