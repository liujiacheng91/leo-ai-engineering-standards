下面是把 **BizDB / EDI / VBO** 三类案例综合起来后的分析。我的判断是：**LL V4.0 标准的迭代方向已经被多个案例验证有效，尤其在 Token 可视化、模型选择、SubAgent 治理、QA 质量增强、异常成本复盘方面已经形成了可落地的工程治理闭环。**  
但 VBO 的第一个 issue version 因为混合了其他 skill，对流程和报告口径有污染，**不建议作为标准效果评估基准，只适合作为“局部数据采样”和“异常报告样例”参考**。

***

# 1. 综合结论

## 1.1 V4.0 标准的主要成果

从几个案例看，LL V4.0 的优化成果可以归纳为 5 点：

1.  **Token 从不可见变成可审计**  
    第一版 BizDB 只统计了员工/SubAgent Token，主 Claude 编排没有单独统计；第二版开始补充主 Claude pre-merge / post-merge rework，并区分 Task-Level、Stage-Level、SubAgent 明细。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

2.  **模型使用从“偏重模型”转向“Sonnet-first / 按风险升级”**  
    BizDB 第一版使用 Opus 4.7 / 4.6，第二版逐步转为 Sonnet + Opus，再到 second\_2th 中 Sonnet-only；EDI 案例也使用 claude-sonnet-4-6 并完成 17/17 unit tests green。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

3.  **SubAgent 使用从默认调用转向受控调用**  
    BizDB 第一版有 8 次员工/SubAgent 调用，第二版 first run 有 7 个 SubAgent，BizDB second\_2th 进入 LL-only 模式但误用了 2 次 Explore Agent，VBO issue version 则暴露出 subagent 分组统计和 0 token 上报不完整的问题。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

4.  **QA 价值明显提升**  
    EDI 案例完成 17 个单元测试并通过；VBO 重跑版本完成 39 个单元测试，覆盖 status workflow、validation、CRUD，并最终 Pass。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

5.  **异常成本治理开始生效，但还需要更严格执行**  
    BizDB second\_2th 报告中明确判断未触发异常：Retry=0、单阶段最高 35.4% < 40%、未用 Opus、Total 约 172K < 500K；EDI 案例 Code Implementation 达到 56%，VBO 重跑版本 Code Implementation 达到 54%，都说明 Stage >40% 的规则需要强制落入 Abnormal Cost Review。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

***

# 2. 多案例横向对比

| 案例                    |       版本/状态 |   Token |     成本 | Retry / Self-Fix | 主要特点                                                                                                                                                                                                                                                                  |
| --------------------- | ----------: | ------: | -----: | ---------------: | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BizDB 第一版             |        初始流程 | 774,649 |  未完整统计 |                1 | 多 Agent、Opus、主 Claude 未单独统计，成本口径不完整。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)                |
| BizDB 第二版 first       |      严格口径补算 | 400,254 |  $5.49 |                2 | 开始补算主 Claude 编排和 rework，模型使用 Sonnet + Opus。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)      |
| BizDB 第二版 second\_2th |         优化后 | 171,725 |  $0.89 |                0 | Sonnet-only，LL-only，但误用 Explore Agent ×2，已如实计入 56,325 tokens。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md) |
| EDI second\_2th       |         优化后 |  67,500 | $0.512 |            2 / 3 | Sonnet-only，17/17 单测通过，节省约 7.7 小时。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)                  |
| VBO issue version     | 混合 skill 版本 |  50,731 |  $1.52 |                0 | 流程受污染，不适合作为标准评估基准；但 SubAgent 分组数据有参考价值。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)          |
| VBO second\_2th       |        重跑版本 | 225,000 |  $4.50 |                1 | 16-task、31 新文件、39 单测，节省约 25 小时，属于大范围功能型案例。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)          |

***

# 3. 对 VBO 两个版本的判断

## 3.1 VBO issue version：只能参考数据，不能作为标准评估基准

VBO issue version 的总 Token 为 **50,731**，其中 SubAgent token 合计 **40,981**，主 agent 编排差值约 **9,750 tokens**；报告还说明 Group E、F、G 有 agent 执行任务但没有返回 token breakdown。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

这个版本的问题是：

*   你已经说明它混合了其他 skill，这会影响流程执行和报告结构；
*   报告中 Group E、F 出现 0 token，但备注又说明这些 agents processed their task，这说明 Token 上报口径不完整； [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)
*   Stage-Level 中 Code Implementation 占 **83.0%**，但 Abnormal Cost Review 只分析 Group B 和 post-agent fixes，没有充分解释为何整个 Code 阶段占比极高； [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)
*   Group B PO entities 单项 **32,064 tokens**，占整个 issue version 的主要部分，原因是读取 existing MsoPo reference 1246 lines。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

所以我建议：  
**VBO issue version 不纳入 V4.0 成果统计基线，只纳入“异常样本库 / 口径校验样本库”。**

它的价值是帮助我们发现三类治理问题：

1.  **混合 skill 会污染标准流程**；
2.  **SubAgent 必须强制上报 token，否则成本不可审计**；
3.  **大参考文件读取，例如 1246 行 MsoPo，会造成局部 Token 激增。**

***

## 3.2 VBO second\_2th：更适合作为正式评估样本

VBO second\_2th 是重跑版本，总 Token 约 **225,000**，成本约 **$4.50**，Retry Count 为 **1**，Saved Hours 为 **25**，最终结果为 Pass。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

这个版本的价值比 issue version 更高，因为它更符合完整功能开发场景：

*   涉及 **T-001 到 T-014**，包括 SQL、enums、POs、entities、mappers、XML、services、DTOs、controller、mail utility、YAML config； [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)
*   Test Generation 阶段产出 **39 unit tests**，覆盖 status workflow、validation、CRUD； [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)
*   Rework / Retry 仅 1 次，主要修复 String.repeat Java 11 兼容性和 User.getUserId() 字段问题； [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)
*   Code Implementation 占 **54%**，报告已按 Stage >40% 纳入 Abnormal Cost Review，并判断 16-task / 31 new files 的范围下属于合理消耗。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

因此，VBO second\_2th 说明：  
**对于大范围功能型需求，V4.0 标准并不一定把 Token 压到最低，而是把 Token 消耗变得可解释、可审计、可复盘，并用 QA 测试覆盖换取交付质量。**

***

# 4. V4.0 在不同类型案例中的表现

## 4.1 小中型代码修改：BizDB second\_2th

BizDB second\_2th 总量 **171,725 tokens / $0.89**，Retry 为 0，Result 为 Pass。  
该案例的主要问题是 LL-only 模式下误用了 2 次 Explore Agent，合计 **56,325 tokens**，但报告已经如实记录并计入 Scenario Analysis。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md)

这说明 V4.0 对中小型任务已经有效，但仍需要强化：

*   LL-only 模式下禁止默认 Explore Agent；
*   只允许 Grep / Read / Glob 定向读取；
*   Explore Agent 必须有使用理由和 Token cap。

***

## 4.2 映射/规则密集型开发：EDI second\_2th

EDI 案例总量 **67,500 tokens / $0.512**，完成 MSG110 X12 40+ 字段映射、5 个新文件、17 个测试用例，并通过 17/17 unit tests。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

它证明：  
**如果需求边界清晰、映射目标明确，Sonnet-only 可以非常高效地完成 Yellow 风险任务。**

但 EDI 报告也暴露出优化方向：

*   Code Implementation 占 **56%**，应触发 Stage-Level 异常复盘； [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)
*   Impl 类占比 27%，测试文件占比 19%，2 次自修复占比 12%； [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)
*   报告建议将映射规则提前固化为 Mapping\_Rules.md，以减少模型推断映射的 Token 消耗。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

这类任务建议在 V4.0 标准中补充 EDI / Mapping 专用模板。

***

## 4.3 大范围功能型开发：VBO second\_2th

VBO second\_2th 总量 **225,000 tokens / $4.50**，看起来高于 EDI 和 BizDB second\_2th，但它的范围也明显更大：16-task、31 new files、39 unit tests、25 saved hours。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

从 ROI 看，这个案例反而很有价值：

*   VBO second\_2th 每节省 1 小时约 **$0.18**；
*   EDI 每节省 1 小时约 **$0.066**；
*   BizDB second\_2th 每节省 1 小时约 **$0.59**。

因此，**不能只看 Token 总量，要看 Token / Saved Hours、Cost / Saved Hours、测试覆盖和业务复杂度。**

VBO second\_2th 是一个典型结论：  
**大功能的 Token 总量高是合理的，但必须有清晰的任务拆分、QA 覆盖、Retry 控制和异常成本解释。**

***

# 5. LL V4.0 标准迭代成果总结

## 5.1 已经证明有效的机制

### A. Token Accounting 模板有效

现在报告可以覆盖：

*   Task-Level Token；
*   Stage-Level Token；
*   Retry / Rework Token；
*   SubAgent Token；
*   Abnormal Cost Review；
*   Saved Hours；
*   Reusable Assets。

BizDB second\_1th 明确补充了主 Claude pre-merge 和 post-merge rework 的估算；VBO issue version 也体现了 SubAgent token summary 与 main orchestration overhead 的拆分。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

***

### B. Model Strategy 有效，但需要更严格执行

EDI 使用 Sonnet-only，完成 17/17 tests；BizDB second\_2th 使用 Sonnet，Retry=0；VBO issue version 也标注所有 subagents 使用 sonnet model per Yellow path selection。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

但 VBO second\_2th 使用了 **Opus 4.6 + Haiku**，且主要阶段都标记为 Opus 4.6。  
如果这是因为 QA 多轮处理和复杂功能范围，可以接受；但建议报告中必须解释： [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

*   为什么 Yellow 任务需要 Opus；
*   哪些阶段必须 Opus；
*   是否可以改成 Sonnet-first + Opus escalation；
*   Haiku 是否只用于低风险 Explore / classification。

***

### C. QA 增强非常有价值

EDI 案例 17/17 unit tests green；VBO second\_2th 有 39 unit tests；BizDB 第一版中 QA 阶段虽然 Token 最高，但产出了 13 单测并全 PASSED。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

从质量角度看，V4.0 的最大收益不只是省 Token，而是：

*   让 QA 变成标准流程的一部分；
*   每个 case 都有 Test.md / Verify.md；
*   Retry 的原因可以被沉淀成下次规则；
*   单测样例可以复用。

你提到 VBO 第二版 QA 多轮处理效果很好，这一点与报告中 39 unit tests 和最终 Pass 是一致的。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

***

### D. Abnormal Cost Review 开始形成治理闭环

VBO second\_2th 中 Code Implementation >40% 被明确列入 Abnormal Cost Review，并解释为 16-task / 31 new files 下的合理消耗。  
BizDB second\_2th 中也用 Retry、阶段占比、Opus 使用、Total Token 四类规则判断未触发异常。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md) [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md)

这是 V4.0 的关键成果：  
**高 Token 不一定是问题，但必须能解释；不能解释的 Token 才是治理问题。**

***

# 6. 使用方面的建议

## 6.1 按任务类型选择执行模式

### 模式一：轻量 LL-only 模式

适用于：

*   小改动；
*   单服务逻辑调整；
*   Bug fix；
*   明确输入输出；
*   不需要跨模块探索。

建议规则：

*   默认 Sonnet；
*   禁止 Explore Agent；
*   使用 Grep / Read / Glob 定向读取；
*   Token 目标：50K–150K；
*   Retry 目标：0–1。

BizDB second\_2th 和 EDI second\_2th 都可以作为参考样例。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

***

### 模式二：Mapping / EDI 专用模式

适用于：

*   EDI X12；
*   字段映射；
*   客户化格式转换；
*   Billing / invoice / cargo milestone 等字段规则密集场景。

建议前置文档：

```text
Mapping_Rules.md
Segment_Definition.md
Sample_Input_Output.md
Test_Data_Matrix.md
Customer_Constants.md
```

原因是 EDI 报告已经指出，MSG110 X12 字段多，ISA / GS / B3 / N1 / LX / L3 逐段映射会造成上下文重复读取，建议提前固化 Mapping\_Rules.md。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

***

### 模式三：大功能分组 SubAgent 模式

适用于：

*   多文件新增；
*   多层架构改动；
*   SQL + Mapper + Service + Controller + Test；
*   需要并行拆分任务；
*   预计超过 15 个任务或 20 个文件。

VBO second\_2th 属于这个类型，涉及 16-task、31 new files 和 39 unit tests。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md)

建议规则：

*   SubAgent 可以使用，但必须强制上报 token；
*   每个 Group 必须有输入范围和输出清单；
*   禁止 Group E/F/G 这类执行了任务但 token 为 0 的情况；
*   Stage >40% 必须进入 Abnormal Cost Review；
*   大参考文件读取必须先摘要再定向读取。

***

## 6.2 强化 QA 标准

建议在 V4.0 后续版本中增加 QA 强制规则：

```markdown
QA Rules:
1. Test.md must include test scope, test data, mock strategy, boundary cases.
2. Verify.md must include actual command, result, failed cases, fix history.
3. If Self-Fix Count >= 2, mark as Near Threshold.
4. If Retry reaches 3, stop and require human review.
5. Every fix must be converted into a reusable convention or checklist item.
```

原因是 EDI 出现 2 次 Self-Fix，VBO second\_2th 出现 1 次 Retry，BizDB second\_1th 出现 2 次 Retry，这些都说明 QA 和验证阶段是最容易产生返工的地方。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

***

## 6.3 强化模型路由策略

建议使用以下策略：

| 场景                  | 默认模型          | 升级条件                |
| ------------------- | ------------- | ------------------- |
| 文档生成 / 简单需求分析       | Sonnet        | 不升级                 |
| Green / Yellow 普通开发 | Sonnet        | 连续 2 次失败或复杂架构争议     |
| QA 测试生成             | Sonnet        | 测试框架不明、连续失败、mock 复杂 |
| 架构评审 / 高风险设计        | Opus          | 仅 Yellow 高复杂或 Red   |
| 大范围代码探索             | Sonnet + 定向读取 | 禁止默认 Explore Agent  |
| 简单分类 / 摘要           | Haiku         | 只允许低风险辅助任务          |

VBO second\_2th 使用 Opus 4.6 + Haiku，而 EDI 和 BizDB second\_2th 证明 Sonnet-only 在多数 Yellow 场景下已经可行。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/VBO_Token_Usage_Report_Second_2th.md), [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/EDI_Token_Usage_Report.md)

***

## 6.4 改进 Token Report 口径

建议 V4.0 后续版本把 Token Report 改成强校验格式：

```markdown
Required Checks:
- Total Token = Task-Level sum = Stage-Level sum ± accepted orchestration overhead
- SubAgent Token must be included or explicitly marked as missing
- Any missing SubAgent token must be listed as data-quality issue
- Any stage >40% must be listed in Abnormal Cost Review
- Any single file read >100KB or >1000 lines must be listed
- Any Retry >=2 must be marked Near Threshold
- Any Opus usage in Yellow must explain why Sonnet is insufficient
```

这个规则可以直接解决 VBO issue version 中 Group E/F/G token 0、混合 skill、SubAgent 上报不完整的问题。 [\[kerryoffic...epoint.com\]](https://kerryoffice365us-my.sharepoint.com/personal/wxiaof_ll_com/Documents/Microsoft%20Copilot%20Chat%20%E6%96%87%E4%BB%B6/Token_Usage_Report_VBO_issue_version.md)

***

# 7. 建议沉淀到 V4.1 / V4.5 的增强项

我建议把这轮案例沉淀为 4 个 case study：

```text
reports/case-studies/
├── BizDB_Token_Optimization_Case.md
├── EDI_Mapping_Sonnet_Only_Case.md
├── VBO_Mixed_Skill_Report_Quality_Issue.md
└── VBO_Large_Feature_QA_Enhanced_Case.md
```

并增加以下标准文件：

```text
templates/
├── Mapping_Rules.md
├── Segment_Definition.md
├── Test_Data_Matrix.md
├── QA_Retry_Root_Cause.md
└── SubAgent_Token_Report.md
```

同时建议在 `CLAUDE.md` 或 `.claude/rules/token-governance.md` 中追加：

```markdown
For LL V4.x execution:
- Do not mix unrelated skills in one case execution.
- For Yellow tasks, use Sonnet-first unless explicit escalation reason exists.
- For LL-only mode, do not use Explore Agent by default.
- For large feature mode, SubAgent is allowed but token reporting is mandatory.
- If any stage exceeds 40%, add Abnormal Cost Review.
- If Self-Fix Count >= 2, mark as Near Threshold and write prevention rule.
- If a reference file exceeds 1000 lines, summarize first, then read targeted sections.
```

***

# 8. 最终建议给管理层的表述

可以这样总结给管理层：

> 基于 BizDB、EDI、VBO 三类案例验证，LL V4.0 AI Engineering Standard 已经从“过程模板化”进入“成本可审计、质量可验证、模型可治理”的阶段。  
> 第二版标准显著改善了 Token 消耗、模型选择和 QA 交付质量；其中 EDI 案例以约 67.5K tokens 完成 17 个单测，VBO 重跑案例以约 225K tokens 完成 16-task、31 新文件和 39 个单测，说明标准在小型变更、映射型开发和大功能开发中均具备落地价值。  
> 下一步应重点加强 SubAgent token 强制上报、Stage >40% 异常复盘、Sonnet-first 模型路由、QA Retry 根因沉淀和混合 skill 隔离，以支撑团队规模化推广。

***

## 一句话结论

**LL V4.0 的迭代成果已经比较明确：它不只是降低 Token，而是把 AI 开发过程变成可度量、可审计、可复盘、可治理的工程流程；后续重点不是继续单纯压低 Token，而是在不同任务类型下选择合适执行模式，并把 QA、SubAgent、模型路由和异常成本规则固化成强制标准。**
