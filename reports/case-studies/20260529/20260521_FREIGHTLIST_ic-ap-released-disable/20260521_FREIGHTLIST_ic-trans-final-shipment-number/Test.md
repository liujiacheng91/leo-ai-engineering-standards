# Test.md

## Test Objective
验证 Node3IcTransFinalCalc.buildFinalEntity() 正确将 transaction.houseNo 赋值给 entity.shipmentNumber。

---

## Test Scope

- In scope: Node3IcTransFinalCalc.buildFinalEntity() 中 shipmentNumber 字段赋值
- Out of scope: IC_TRANS 链（IcTransactionEntity 无 shipmentNumber 字段）；Node4Save 落库逻辑；其他字段赋值

---

## Test Data

| Case | Input | Expected |
|---|---|---|
| houseNo 正常值 | transaction.houseNo = "SH12345" | entity.shipmentNumber = "SH12345" |
| houseNo 为 null | transaction.houseNo = null | entity.shipmentNumber = null |
| houseNo 为空串 | transaction.houseNo = "" | entity.shipmentNumber = "" |

---

## Mock Strategy

- Mock framework: N/A（本次为静态设计，Track B 验证模式）
- Objects to mock: IcTransFinalMeta, IcTransactionEntity, IIcTransactionFinalService 等依赖
- Stub setup location: @BeforeEach
- Strictness setting: STRICT_STUBS（默认）

---

## Test Types

- [x] Manual Verification（静态代码审查）
- [ ] Unit Test（Track B: 合并后执行）

---

## Test Matrix

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|
| TC-1 | Static | houseNo = "SH12345" | shipmentNumber = "SH12345" | High | AC-1 |
| TC-2 | Static | houseNo = null | shipmentNumber = null | Medium | AC-1 |
| TC-3 | Negative | IC_TRANS 链执行 | IcTransactionEntity 无 shipmentNumber 字段，不受影响 | High | AC-2 |

---

## Boundary Cases

| Scenario | Input | Expected Behavior |
|---|---|---|
| houseNo 为 null | transaction.houseNo = null | shipmentNumber = null，不报错（setter 接受 null） |
| houseNo 为空串 | transaction.houseNo = "" | shipmentNumber = ""，正常赋值 |

---

## API Test Cases

N/A - 本次改动不涉及 REST API。

---

## Permission & Security Checklist

N/A - 本次改动不涉及权限或敏感数据。

---

## Commands

```bash
# Build (Track B: 合并后在主分支执行)
gradle :expand:business-freightlist-summary:compileJava

# Unit Test (Track B: 合并后执行)
gradle :expand:business-freightlist-summary:test
```

---

## Pass Criteria

- [x] 静态审查确认 setShipmentNumber 紧跟 setHouseNo
- [x] 静态审查确认数据源为 transaction.getHouseNo()
- [x] IC_TRANS 链不受影响（IcTransactionEntity 无 shipmentNumber 字段）
- [ ] Build passed (Track B: 合并后)

---

## Fix History

| Fix # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
