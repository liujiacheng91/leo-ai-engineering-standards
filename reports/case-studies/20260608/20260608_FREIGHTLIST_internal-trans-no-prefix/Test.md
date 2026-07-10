# Test

## P0 Cases

- T1: 首次交易（无 lastIcHeader）生成的 internalTransNo 以 "B_" 开头
- T2: 最后一次交易是 ACT 时重新生成的 internalTransNo 以 "B_" 开头
- T3: 复用历史交易号时保持原值不加前缀
