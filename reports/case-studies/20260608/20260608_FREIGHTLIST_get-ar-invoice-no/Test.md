# Test

## P0 Cases

- T1: 存在 AR+source=B+released 费用且 cdlTransNo 非空时返回该 transNo
- T2: 多条符合条件费用，第一条 transNo 为空第二条非空时返回第二条
- T3: 所有符合条件费用 cdlTransNo 都为空时返回 null
- T4: 无符合条件费用时返回 null
- T5: linkedCharges 为 null 或空列表时返回 null
