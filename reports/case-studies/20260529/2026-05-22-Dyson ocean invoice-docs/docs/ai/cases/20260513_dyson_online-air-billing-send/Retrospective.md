# Retrospective.md

**Case:** `20260513_dyson_online-air-billing-send`
**日期:** 2026-05-13
**结果:** 17/17 单元测试通过，自修复 2 次，估算节省 7.7 小时

---

## 一、做得好的地方（保留）

| 项目 | 说明 |
|---|---|
| 分段构建逻辑清晰 | buildB3 / buildN1Groups / buildLxGroups / buildL3 各自独立，职责单一 |
| 测试覆盖完整 | 17 个用例覆盖正路径、边界（空 milestone、null ata_date）、异常（invalid JSON、空 air_rate） |
| 预存在问题正确隔离 | edi-business-common 编译失败定位准确，未错误归因于本次变更 |
| 静态工厂初始化 | `FACTORY` static block 正确处理 `IOException | SAXException`，避免每次调用开销 |
| Verify.md 有真实证据 | 最终报告含 XML testsuite 属性，非自我声明 |

---

## 二、做得不够好的问题（重点）

### 问题 1：SDK API 预调查不足 → 导致 2 次自修复

**现象：**
- Fix #1：`ReflectionTestUtils` 写进测试 → 编译报错（spring-test 不在 classpath）
- Fix #2：`any()` 用于 primitive `int` → Mockito NPE；`doNothing()` 用于有返回值的 `insertLog` → 运行失败

**根因：** 在写代码前没有先 grep/read 以下关键事实：

```
sendToCore(String, String, String, String, int, String, String)  ← 第 5 个是 primitive int
insertLog(Map<String, String>)                                   ← 返回 Revert，不是 void
test classpath 中没有 spring-test
```

**优化方向：**
在 Solution.md 中增加 **"方法签名确认清单"** 步骤。凡涉及 mock 的外部方法，必须先 grep 源码确认参数类型和返回类型，再写测试代码。

---

### 问题 2：Session 上下文耗尽，任务被迫中断

**现象：** 第一个 session 在 Fix #2 应用前被压缩，第二个 session 从摘要恢复时丢失了部分执行细节。

**根因：** 单次 session 承载了太多工作：文档生成 + 全量实现 + 测试生成 + 验证，上下文窗口无法承载。

**优化方向：**
按 SDLC 阶段拆分 session，每个 session 有明确的进入条件和退出条件：

```
Session A: Scenario + Risk + Solution 文档  → 人工确认后退出
Session B: Task + Test 文档                  → 人工确认后退出
Session C: 模型 + Impl 实现                  → compileJava 通过退出
Session D: 验证 + Verify.md                  → tests green 退出
Session E: PR Summary + Token Report         → 文档齐全退出
```

---

### 问题 3：Mapping_Rules.md 缺失

**现象：** CLAUDE.md 工作流要求生成 `Mapping_Rules.md`，实际 case 目录中没有。40+ 字段的映射规则分散在 Solution.md 里，没有独立的映射文档。

**根因：** AI 跳过了这个文档，直接进入代码实现。

**优化方向：**
字段数 ≥ 15 的 EDI 场景，**强制先产出 Mapping_Rules.md**，格式为：

| 源字段 | 目标 EDI 段/元素 | 转换规则 | 空值处理 |
|---|---|---|---|
| invoice_no | B3.b302 | 直传 | 必填，空则抛出 |
| invoice_date | B3.b306 | yyyy-MM-dd → yyyyMMdd | 必填 |
| ... | ... | ... | ... |

这样既是人工 review 的依据，也是 AI 实现的输入约束，可大幅减少字段映射错误。

---

### 问题 4：AI_Case_Card.md 未生成

**现象：** SDLC 工作流末尾要求 `AI_Case_Card.md`，本次未生成，SDLC 闭环不完整。

**优化方向：**
在 feature-dev skill 的工作流末端加 checklist 检查，确保每次结案前生成 Case Card。

---

### 问题 5：测试文件 XML 体积异常（2.5 MB）

**现象：** `TEST-*.xml` 为 2.5 MB，无法直接读取，被迫用 `head` 命令取摘要行。

**根因：** X12 EDI 全文被嵌入 JUnit XML 的 `<system-out>` 节点（因为实现类中有 `logger.info(ediText)` 输出）。

**优化方向：**
测试时对 `ediText` 日志输出做截断：

```java
logger.info("EDI preview: {}", ediText.length() > 500 ? ediText.substring(0, 500) + "..." : ediText);
```

或在测试环境将日志级别设置为 WARN。

---

### 问题 6：B3.b314 错误假设

**现象：** 最初实现尝试 `b3.setB314(trade_terms)`，SDK 中该字段不存在，导致编译错误后回退。

**根因：** 基于字段命名规律推断 SDK 结构，而非先读源码确认。

**优化方向：**
凡使用 edi-x12 SDK 的字段，必须先 Glob/Grep SDK 源码确认字段列表，不允许靠推断写代码。在 Solution.md 增加 **"SDK 字段确认"** 前置步骤。

---

## 三、优化优先级

| 优先级 | 问题 | 工作量 | 影响 |
|---|---|---|---|
| P0 | Solution.md 增加方法签名确认清单 | 低（模板改动） | 消灭 Fix #1/#2 类问题 |
| P0 | 字段 ≥ 15 强制先产出 Mapping_Rules.md | 低（文档规范） | 减少字段映射错误 |
| P1 | Session 按 SDLC 阶段拆分 | 中（习惯改变） | 避免上下文压缩中断 |
| P1 | SDK 字段必须先 grep 确认，不允许推断 | 低（检查习惯） | 消灭 b314 类错误 |
| P2 | 测试日志截断避免 XML 膨胀 | 低（1 行代码） | 减少测试产物体积 |
| P2 | feature-dev skill 末端加 Case Card checklist | 低（skill 改动） | 完整 SDLC 闭环 |

---

## 四、下一轮改进行动清单

- [ ] 在 `Solution.md` 模板中增加"外部方法签名确认"区块
- [ ] 在 `feature-dev` skill 中，字段映射场景强制输出 `Mapping_Rules.md`
- [ ] 将 session 拆分规则写入 `CLAUDE.md` 的工作流说明
- [ ] `DysonOnlineAirBillingSendProcessImpl` 中 `logger.info(ediText)` 改为截断输出
- [ ] 补齐本次缺失的 `AI_Case_Card.md`

---

## 五、一句话结论

> 本轮执行效率的主要损耗来自**预调查不足**（SDK 字段和方法签名靠推断而非确认）。下一轮最有效的改进只有一条：**先 grep，再写代码。**
