# AI Risk Level

## Case
20260521_FREIGHTLIST_ic-node1-shipment-detail-fix

## Risk Level: Yellow

## Rationale
- 改动涉及 IC v2 chain 的两个 LiteFlow 节点 (Node1Trigger, Node2IcTransCalc)
- 修复 bug 不改算法逻辑, 只修复数据传递缺失和 NPE
- 不涉及 DB schema / Kafka topic / 生产配置
- 不涉及 Node5(ProfitShareTotal) / Node10(Exception) / Node11(Save) 等 Red 节点
- 影响范围: ic_transaction 表写入成功率, 不影响 PDF 团队

## Impact
- ic_transaction / ic_transaction_final 表从写入失败恢复为正常写入
- serial_no / master_job_no / house_job_no / system_type 字段从 null 恢复为正确值
