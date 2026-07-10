# Karpathy-Inspired Behavior Principles

## 1. Think Before Coding

不要在需求不清时直接动手。必须显式列出假设、暴露不确定点、给出可能解释分支、必要时提问。

## 2. Simplicity First

不要过度设计。只实现明确要求的功能，不为一次性逻辑创建抽象，不添加未要求的配置或扩展点。

## 3. Surgical Changes

只改必要内容。不要顺手重构无关代码，不修改无关格式、注释和命名。每一行 diff 都应能追溯到当前需求。

## 4. Goal-Driven Execution

将任务转化为可验证目标。每个步骤都要有验证方式和通过标准。

## 5. Token Reduction Rationale

- 先澄清，减少返工；
- 简单优先，减少无效代码和无效 diff；
- 手术式修改，减少上下文扫描和 Review 成本；
- 目标驱动，减少反复试错。
