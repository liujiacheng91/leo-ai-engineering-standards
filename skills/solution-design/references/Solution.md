# Solution.md

## Solution Overview

## Technical Constraints

在开始实现前必须验证并填写以下内容。未填写此表视为 Stop Condition — 不允许进入 Task.md / Test.md 阶段。

| 约束项 | 验证方式 | 结论 |
|---|---|---|
| Java 语言级别 / compile target | 读 `build.gradle` `sourceCompatibility` 或 `pom.xml` `<java.version>` / `<maven.compiler.source>` | |
| 运行环境 JAVA_HOME / 构建工具版本 | 执行 `java -version`、`mvn -version` 或 `gradle -version`，与项目要求对比 | |
| 关键实体字段名（本次改动引用的） | 读目标实体类源码，列出将引用的字段名 -- 不得假设字段存在 | |
| 可用工具方法（JDK / 框架 / 第三方依赖相关） | 读依赖版本及其 API 源码，确认方法签名存在 -- 不得假设方法可用 | |
| 跨模块 / 跨服务依赖声明 | 读引用方 `pom.xml` / `build.gradle`，确认目标模块已显式声明为 dependency | |
| Mockito strictness 设置 | 读现有测试类或 `build.gradle` | |
| Worktree 构建可行性 | 执行 `gradle compileJava` 或 `mvn compile` 验证 | |

### Post-Merge Test Plan (Track B Declaration)

> 若 Worktree 构建不可行（JGit/versioning 插件限制，如 `net.nemerosa.versioning` 抛 `NoHeadException`），填写以下三项以激活 Track B 验证模式。未填写则 worktree 构建失败计入 Retry。

- Command:
- Owner:
- Timing:

## Impact Analysis

### Affected Modules

### Affected Files

### Affected APIs

### Affected Database Objects

### Affected Configurations

## Recommended Solution

## Security Considerations

## Test Strategy

## Rollback Plan

## Human Approval

- Approved by:
- Date:
