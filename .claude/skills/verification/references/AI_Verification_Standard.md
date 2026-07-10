# AI Verification Standard

## Required Verification Items

- Build
- Unit Test
- Integration Test
- Lint
- Type Check
- Coverage
- Security Scan
- Secrets Scan
- UAT
- Log Analysis
- Data Comparison

## Rule

AI 代码是否可接受，不看"是否生成"，而看"是否有验证证据"。

## Stop Condition

同一问题自修复最多 3 次。超过 3 次必须停止并升级人工判断。

## Worktree Build Limitation Exemption

When a worktree build is not feasible due to JGit / versioning plugin incompatibility (`net.nemerosa.versioning` throws `NoHeadException` on worktree `.git` file pointers), Track B verification applies under all of the following conditions:

1. `Solution.md Technical Constraints` explicitly declares the worktree build limitation.
2. `Solution.md Technical Constraints` contains a post-merge test plan (command + owner + timing).
3. `Verify.md Post-Merge Test Plan` is filled before merge.
4. Post-merge test results are backfilled into `Verify.md Post-Merge Test Results` after merge.

When all four conditions are met: worktree build failure does not count as a Retry. If the case is reviewed for cost, record the root cause as `[Toolchain]` in the Abnormal Cost Review -- not `[Logic]`.

If any condition is not met, the standard Stop Condition applies and the failure counts as a Retry.
