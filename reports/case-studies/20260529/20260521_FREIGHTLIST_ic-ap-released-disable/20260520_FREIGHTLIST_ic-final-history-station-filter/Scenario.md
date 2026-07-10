# Scenario - ic-final-history-station-filter

## Background

上一个 case (ic-final-history-globalinterlink) 将历史查询提到循环外并改用 globalInterlink 查询，但 historyTotal 是全量累加。实际业务需要按站点(stationCode)过滤：每条 transaction_final 只应累加与自己相同站点的历史金额。

## Acceptance Criteria

- AC-1: calcHistoryTotal 返回 List<IcTransactionFinalEntity> 而非 BigDecimal
- AC-2: buildFinalEntity 签名从 BigDecimal historyTotal 改为 List<IcTransactionFinalEntity> historyList
- AC-3: calcAmount 中遍历 historyList，使用 meta.isStationsEqual 比较 stationCode，只累加相同站点的 amount
- AC-4: calcAmount 签名增加 IcTransMetaItem meta 参数和 List<IcTransactionFinalEntity> historyList 参数，去掉 BigDecimal historyTotal
- AC-5: buildIcTransFinal 中传历史列表代替 historyTotal
