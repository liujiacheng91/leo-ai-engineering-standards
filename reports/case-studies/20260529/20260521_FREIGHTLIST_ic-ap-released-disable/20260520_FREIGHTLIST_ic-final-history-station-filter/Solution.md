# Solution - ic-final-history-station-filter

## Technical Constraints

- Java 21
- IcTransactionFinalEntity.stationCode (line 74) 是站点字段
- IcTransMetaItem.isStationsEqual(String, String) 是站点比较方法（支持 Map 成对匹配）
- IcTransactionEntity.getStationCode() 是当前 transaction 的站点

## Recommended Solution (Mode 1)

4 步改动，全部在 Node3IcTransFinalCalc.java：

1. calcHistoryTotal 改名 queryHistoryList，返回 List<IcTransactionFinalEntity>，去掉累加逻辑
2. buildIcTransFinal：historyTotal 变量改为 historyList，传入 buildFinalEntity
3. buildFinalEntity：签名 BigDecimal historyTotal 改为 List<IcTransactionFinalEntity> historyList，透传到 calcAmount
4. calcAmount：签名加 IcTransMetaItem meta + List<IcTransactionFinalEntity> historyList，内部遍历 historyList 按 meta.isStationsEqual 过滤累加

## Track B Declaration

worktree + JGit/versioning 插件不兼容，gradle build/test 无法在 worktree 执行。

### Post-Merge Test Plan

| Item | Detail |
|---|---|
| Command | gradle :expand:business-freightlist-summary:compileJava |
| Owner | Liangwb |
| Timing | 合并后立即执行 |
