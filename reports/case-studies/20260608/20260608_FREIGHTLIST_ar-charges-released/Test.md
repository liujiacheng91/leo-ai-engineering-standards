# Test

## P0 Cases

- T1: AR+source=B 费用全部 POSTED/CAN_POST/RELEASED 时返回 true
- T2: AR+source=B 中有一条状态不在列表中返回 false
- T3: 没有 AR+source=B 的费用记录时返回 false
- T4: linkedCharges 为 null 或空列表时返回 false
- T5: AR+source 非 B 的记录不参与判断
