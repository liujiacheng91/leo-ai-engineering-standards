# Solution - ic-final-history-globalinterlink

## Technical Constraints
- Java 21, LiteFlow NodeComponent
- `IcTransactionFinalEntity` 有 `globalInterlink` 字段（entity line 53）
- `IcTransactionEntity` 有 `getGlobalInterlink()` 方法（entity line 53）
- Worktree 构建受 JGit/versioning 插件限制 -> Track B

## Recommended Solution (Mode 1)

改动文件：仅 `Node3IcTransFinalCalc.java`

### 1. 新增 `calcHistoryTotal` 方法
- 从 `calcDiffAmount` 中拆出 DB 查询 + 累加逻辑
- 查询条件改为 `globalInterlink` eq + `version` ge actVersion
- 返回 `BigDecimal historyTotal`

### 2. 修改 `buildIcTransFinal`
- 循环前判断 `isDiffAmount = meta.getFirstActualIcHeader() != null`
- 循环前调用 `calcHistoryTotal(globalInterlink, actVersion)` 预计算
- `globalInterlink` 从 `icTransactionList.get(0).getGlobalInterlink()` 取

### 3. 修改 `buildFinalEntity` 签名
- 新增 `boolean isDiffAmount` 和 `BigDecimal historyTotal` 参数
- 传递给 `calcAmount`

### 4. 修改 `calcAmount` 签名
- 去掉 `IcTransMetaItem meta` 参数，改为 `boolean isDiffAmount` + `BigDecimal historyTotal`
- 差额模式：`amount = psAmount - historyTotal`
- 非差额模式：`amount = psAmount`

### 5. 删除 `calcDiffAmount` 方法
- 逻辑已拆分到 `calcHistoryTotal` 和 `calcAmount`

## Post-Merge Test Plan
- Command: `gradle :expand:business-freightlist-summary:test`
- Owner: developer
- Timing: 合并到 develop_1.1.0 后立即执行
