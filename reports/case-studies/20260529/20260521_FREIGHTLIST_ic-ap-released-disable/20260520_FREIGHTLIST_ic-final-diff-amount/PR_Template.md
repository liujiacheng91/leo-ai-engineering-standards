# Pull Request Template

## Summary

补充 `Node3IcTransFinalCalc.calcDiffAmount` 方法的差额计算逻辑：从 `ic_transaction_final` 表查询 serialNo 相同且 version>=actVersion 的历史记录，累加 amount 得到 historyTotal，差额 = psAmount - historyTotal。

## Related Documents

- AI_Request.md
- Scenario.md
- AI_Risk_Level.md
- Solution.md
- Task.md
- Test.md
- Verify.md

## AI Assistance

- Tool: Claude Code
- Model: Opus
- Risk Level: Yellow
- Token Cost: $2.40 (estimated)

## Validation

- [ ] Build（Track B：worktree + JGit 不兼容，合并后在主分支执行 `gradle :expand:business-freightlist-summary:compileJava`）
- [ ] Unit Test（Track B：同上，合并后执行 `gradle :expand:business-freightlist-summary:test`）
- [ ] Integration Test
- [ ] Lint
- [ ] Security Scan
- [ ] Secrets Scan

## Security Checklist

- [x] No secrets exposed
- [x] No production data used
- [x] No production config changed
- [x] No auth / audit bypassed

## Reviewer Notes

改动范围限于 `Node3IcTransFinalCalc.java` 单文件的三个点：
1. 构造器新增 `IIcTransactionFinalService` 注入
2. 新增 `LambdaQueryWrapper` 和 `IIcTransactionFinalService` 两个 import
3. `calcDiffAmount` 方法体从 `//todo` 替换为完整查询+计算逻辑

不改链定义、不改表结构、不改 Kafka 路由。
