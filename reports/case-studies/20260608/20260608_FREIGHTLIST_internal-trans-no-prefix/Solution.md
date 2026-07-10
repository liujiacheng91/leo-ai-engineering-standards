# Solution

## Technical Constraints

- Pre-verified Environment: worktree + JGit 不兼容，Track B
- 目标文件: Node30IcTransFinalCalc.java:175 和 :180（两处 String.valueOf(epoch)）
- 改动: `String.valueOf(epoch)` -> `"B_" + epoch`
- 复用历史交易号的路径（line 171）不改动

## Track B Declaration

worktree 构建受 JGit 限制，合并后执行测试。
