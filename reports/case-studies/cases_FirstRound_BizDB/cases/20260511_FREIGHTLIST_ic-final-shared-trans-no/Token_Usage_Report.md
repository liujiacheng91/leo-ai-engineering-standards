# Token Usage Report

## 基本信息

| 项目 | 值 |
|---|---|
| **Case-ID** | `20260511_FREIGHTLIST_ic-final-shared-trans-no` |
| **模型** | Claude Opus 4.7 (1M context) → Opus 4.6 (1M context)（中途用户切换） |
| **自修复次数** | 1（QA 单测 InOrder 写法修正） |
| **员工总调用数** | 8 次 |
| **LL 文档** | 10/12（Mapping_Rules 和 Business_Rules 不适用） |

## 员工（subagent）Token 明细

| # | 员工 | 阶段/模式 | Token 数 | 工具调用次数 | 耗时 | 产出 |
|---|---|---|---|---|---|---|
| 1 | `requirement-analyst` | draft | 61,102 | 7 | 96s | Scenario.md |
| 2 | `tech-architect` | review | 79,738 | 15 | 161s | scenario-review.md + AI_Risk_Level.md |
| 3 | `requirement-analyst` | revise | 68,794 | 5 | 106s | Scenario.md（修订，11 条 must-fix） |
| 4 | `requirement-analyst` | finalize | 65,219 | 10 | 94s | REQ-202605110001 + index.md 更新 |
| 5 | `tech-architect` | architecture | 89,879 | 14 | 186s | Solution.md |
| 6 | `java-backend-engineer` | 实现 | 124,412 | 42 | 482s | 4 文件代码 + Task.md + git commit |
| 7 | `tech-architect` | code-review | 118,956 | 36 | 196s | code-review.md |
| 8 | `qa-engineer` | QA | 166,549 | 56 | 673s | Test.md + Verify.md + 13 单测 + git commit |

### 汇总

| 指标 | 数值 |
|---|---|
| **员工 Token 合计** | 774,649 |
| **员工工具调用合计** | 185 次 |
| **员工总耗时** | 1,994s（约 33 分钟） |
| **主 Claude Token** | 未单独统计（负责流程编排、用户对齐、文档 commit、收尾三件套） |

## Token 分布分析

| 阶段 | Token 占比 | 说明 |
|---|---|---|
| 需求阶段（RA×3 + TA review） | 274,853（35%） | 含评审循环：draft → review → revise → finalize |
| 架构阶段（TA architecture） | 89,879（12%） | Solution.md 产出 |
| 实现阶段（Dev + TA code-review） | 243,368（31%） | 开发是工具调用最密集的阶段（42 次） |
| QA 阶段 | 166,549（22%） | Token 最高的单次员工调用，接入测试基础设施 + 写 13 个用例 |

## ROI 备注

- **产出**：4 文件代码改动 + 13 单测（全 PASSED） + 11 份 LL 过程文档
- **效率**：从用户提出需求到合并 push，员工累计工作约 33 分钟（不含用户对齐等待时间）
- **质量**：code-review 0 must-fix 一次通过；QA 自修复仅 1 次
- **Token 热点**：QA 阶段消耗最高（166K），主因是仓库此前无 `src/test`，QA 需要从零接入 JUnit + Mockito 测试基础设施
