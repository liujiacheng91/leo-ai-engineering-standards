# Scenario

Node30IcTransFinalCalc 生成 internal_trans_no 时，在现有 epoch 数值前加上 "B_" 前缀。

## Acceptance Criteria

- AC-1: 新生成的 internalTransNo 格式为 "B_" + epoch（原先为纯 epoch 数字字符串）
- AC-2: 复用历史交易号（lastIcHeader.internalNumber）的场景不受影响，保持原值
- AC-3: 两处新生成交易号的代码路径都加上 B_ 前缀
