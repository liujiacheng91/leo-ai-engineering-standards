# Test

## P0 Cases

- T1: lastIcHeader.generatedPendingReleaseFlag=1 时进入 AP 处理分支
- T2: lastIcHeader.generatedPendingReleaseFlag=0 时进入 AR 处理分支
- T3: lastIcHeader=null 时进入 AR 处理分支（不报错）
