# Mapping_Rules.md

## 说明

- 源对象：`OceanShipment`（含 `oc_rate: List<OceanRate>`、`container_no: List<OceanShipmentContainer>`、`ocean_milestone: List<OceanMilestone>`、`ocean_reference: List<OceanReference>`）
- 目标：X12 MSG310（`Msg310X12` / `Msg310`）
- 按**分组1**（`oc_rate.client_id + invoice_no`）生成独立文件
- `转换占位处理` 行跳过，在 `mapFrom304` 中人工实现

---

## 信封段（ISA / GS / ST / SE / GE / IEA）

| 目标字段 | 来源 / 规则 | 空值处理 |
|---|---|---|
| ISA01 | `"00"` | 固定 |
| ISA02 | 10个空格 | 固定 |
| ISA03 | `"00"` | 固定 |
| ISA04 | 10个空格 | 固定 |
| ISA05 | `"ZZ"` | 固定 |
| ISA06 | env=prod → `"KERRY"` padRight(15)；其他 → `"KERRYTEST"` padRight(15) | 固定 |
| ISA07 | `"ZZ"` | 固定 |
| ISA08 | env=prod → `"RBTWTMC"` padRight(15)；其他 → `"RBTWTMCTEST"` padRight(15) | 固定 |
| ISA09 | 当前日期 `yyMMdd` | 自动 |
| ISA10 | 当前时间 `HHmm` | 自动 |
| ISA11 | `"U"` | 固定 |
| ISA12 | `"00401"` | 固定 |
| ISA13 | `controlNumber`（9位，前缀310，序列服务） | 必填 |
| ISA14 | `"1"` | 固定 |
| ISA15 | env=prod → `"P"`；其他 → `"T"` | 固定 |
| ISA16 | `">"` | 固定 |
| GS01 | `"IO"` | 固定 |
| GS02 | 同 ISA06（未补位） | 固定 |
| GS03 | 同 ISA08（未补位） | 固定 |
| GS04 | 当前日期 `yyyyMMdd` | 自动 |
| GS05 | 当前时间 `HHmm` | 自动 |
| GS06 | `controlNumber` | 必填 |
| GS07 | `"X"` | 固定 |
| GS08 | `"004010"` | 固定 |
| ST01 | `"310"` | 固定 |
| ST02 | `"0001"` | 固定 |
| SE01 | `Msg310X12Factory.toEDI()` 自动计算 | 自动 |
| SE02 | `"0001"` | 固定 |
| GE01 | `"1"` | 固定 |
| GE02 | `controlNumber` | 必填 |
| IEA01 | `"1"` | 固定 |
| IEA02 | `controlNumber` | 必填 |

---

## B3 段（运费发票头）

| 源字段 | 目标字段 | 规则 | 空值处理 |
|---|---|---|---|
| `oc_rate.invoice_no` | B3.b302 | 分组1后 `min(invoice_no)` | 空则留空 |
| `ocean.booking_no` | B3.b303 | 直传 | 空则留空 |
| `ocean.terms` | B3.b304 | `"COLLECT"` → `"PP"`；`"PREPAID"` → `"CC"`；其他 → `""` | 空字符串（待BA确认） |
| `oc_rate.invoice_date` | B3.b306 | 分组1后 `min(invoice_date)`，`yyyy-MM-dd` → `yyyyMMdd` | 空则留空 |
| `oc_rate.amount + vat_amount` | B3.b307 | 分组1后 `sum(amount + vat_amount)` by `client_id + invoice_no` | 0 |
| `ocean_milestone` | B3.b309 | 优先取 `ocean_milestone[code=IFFDEP].act_date`（yyyyMMdd）；为空取 `est_date`（yyyyMMdd） | 空则留空 |
| — | B3.b310 | `"011"` | 固定 |
| — | B3.b311 | `"LLL"` | 固定 |
| `ocean.sales_terms` | B3.b314 | 直传 | 空则留空 |

## B2A 段

| 目标字段 | 规则 |
|---|---|
| B2A.b2a01 | `"00"` |

---

## N9 段（参考号）

| 目标 N901 | 源字段 | 规则 |
|---|---|---|
| `"BM"` | `ocean.h_bol` | 直传 |
| `"MB"` | `ocean.m_bol` | 直传 |
| `"BN"` | `ocean.m_bol` | 直传 |
| `"CN"` | `ocean.m_bol` | 直传 |
| `"FN"` | `ocean.h_bol` | 直传 |
| 其他类型 | — | `mapFrom304` 占位处理 |

## C3 段（货币）

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| `oc_rate.print_currency` | C3.c301 | 分组1后取第一条 `print_currency` | 空则留空 |

---

## N1 Loop（参与方，4组）

### N1(BT) - 账单收款方

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| — | N1.n101 | `"BT"` |
| `oc_rate.client_name` | N1.n102 | 分组1后取第一条 `client_name` |
| `oc_rate.x_client_address_1` + `x_client_address_2` | N3.n301 | 合并（空不参与），截取前55字符 |
| `oc_rate.x_client_city` | N4.n401 | 分组1后直传 |
| `oc_rate.x_client_state` | N4.n402 | 分组1后直传 |
| `oc_rate.x_client_zipcode` | N4.n403 | 分组1后直传 |
| `oc_rate.x_client_country` | N4.n404 | 分组1后直传 |

### N1(SF) - 发货方

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| — | N1.n101 | `"SF"` |
| `ocean.shipper_name` | N1.n102 | 直传 |
| `ocean.shipper_address_1..4` | N3.n301 | 合并（空不参与），截取前55字符 |
| `ocean.shipper_city` | N4.n401 | 直传 |
| `ocean.shipper_state` | N4.n402 | 直传 |
| `ocean.shipper_zipcode` | N4.n403 | 直传 |
| `ocean.shipper_country` | N4.n404 | 直传 |

### N1(ST) - 收货方

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| — | N1.n101 | `"ST"` |
| `ocean.consignee_name` | N1.n102 | 直传 |
| `ocean.consignee_address_1..4` | N3.n301 | 合并（空不参与），截取前55字符 |
| `ocean.consignee_city` | N4.n401 | 直传 |
| `ocean.consignee_state` | N4.n402 | 直传 |
| `ocean.consignee_zipcode` | N4.n403 | 直传 |
| `ocean.consignee_country` | N4.n404 | 直传 |

### N1(PR) - 付款方

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| — | N1.n101 | `"PR"` |
| `oc_rate.client_name` | N1.n102 | 分组1后取第一条 |
| `oc_rate.x_client_address_1` + `x_client_address_2` | N3.n301 | 合并，截取前55字符 |
| `oc_rate.x_client_city` | N4.n401 | 分组1后直传 |
| `oc_rate.x_client_state` | N4.n402 | 分组1后直传 |
| `oc_rate.x_client_zipcode` | N4.n403 | 分组1后直传 |
| `oc_rate.x_client_country` | N4.n404 | 分组1后直传 |

---

## R4 Loop（港口）

### R4(L) - 装货港 + DTM

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| — | R4.r401 | `"L"` |
| — | R4.r402 | `"UN"` |
| `ocean.fport_of_loading` | R4.r403 | 直传 |
| `ocean.fport_of_loading_exp` | R4.r404 | 截取第一个逗号前的值 |
| `ocean.fport_of_loading_ctry` | R4.r405 | 直传 |
| DTM01 | — | `"139"` |
| `ocean_milestone[code=IFFDEP].est_date` | DTM02 | `yyyy-MM-dd` → `yyyyMMdd`；为空则整组 DTM 不生成 |
| `ocean_milestone[code=IFFDEP].est_time` | DTM03 | `HH:MM` → `HHmm`；DTM02 为空则空；DTM03 为空则 `"0000"` |

### R4(D) - 卸货港 + DTM

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| — | R4.r401 | `"D"` |
| — | R4.r402 | `"UN"` |
| `ocean.fport_of_discharge` | R4.r403 | 直传 |
| `ocean.fport_of_discharge_exp` | R4.r404 | 截取第一个逗号前的值 |
| `ocean.fport_of_discharge_ctry` | R4.r405 | 直传 |
| DTM01 | — | `"139"` |
| `ocean.m_eta` | DTM02 | `DDMMYYYY` → `yyyyMMdd`（注意源格式） |
| — | DTM03 | `"0000"` |

### DTM（B3/R4(L) 前的独立 DTM）

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| DTM01 | — | `"139"` |
| `ocean_reference[ref_code="Dyson Earliest Pickup"].ref_value` | DTM02 | 直传 |
| — | DTM03 | `"0000"` |

### R4(R) 和 R4(E)

> 转换占位处理，在 `mapFrom304` 中人工实现。

---

## LX Loop（明细）

### LX 段

| 目标字段 | 规则 |
|---|---|
| LX.lx01 | `"1"`（固定，仅一个 LX 组） |

### N7Group（每个分组2 container，仅当 `ocean.loadterm != "LCL"` 时生成）

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| `oc_container.ctnr` | N7.n701 | 分组2后截取前4字符（Equipment Initial） |
| `oc_container.ctnr` | N7.n702 | 分组2后截取第5字符起（Equipment Number） |
| N7.n722 | — | 转换占位，`mapFrom304` 人工实现 |

> `oc_container` = `ocean.container_no`（`List<OceanShipmentContainer>`）

### L0Group（每个分组2 container）

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| 序号 | L0.l001 | 从1递增 |
| `oc_container.grs_kgs` | L0.l004 | 分组2后 `sum(grs_kgs)` by `serial_no + ctnr` |
| — | L0.l005 | `"G"` |
| `oc_container.cbm` | L0.l006 | 分组2后 `sum(cbm)` by `serial_no + ctnr` |
| — | L0.l007 | `"X"` |
| `oc_container.qty` | L0.l008 | 分组2后 `sum(qty)` by `serial_no + ctnr` |
| `oc_container.unit` | L0.l009 | 分组2后 `max(unit)`；若 null 或非 CTN/PKG 则用 `"PCS"` |
| — | L0.l011 | `"K"` |

### L1Group（在每个 L0Group 内，每个 oc_rate 一条）

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| 序号 | L1.l101 | 从1递增 |
| `oc_rate.unit_price` | L1.l102 | 直传（BigDecimal → String） |
| — | L1.l103 | `"KG"` |
| `oc_rate.amount + vat_amount` | L1.l104 | `amount + vat_amount` |
| `oc_rate.x_customer_code` | L1.l108 | 直传 |
| — | L1.l112 | `"Freight"` |

---

## L3 段（汇总）

| 源字段 | 目标字段 | 规则 |
|---|---|---|
| `oc_container.grs_kgs` | L3.l301 | 分组3后 `sum(grs_kgs)` by `serial_no` |
| — | L3.l302 | `"G"` |
| `oc_rate.amount + vat_amount` | L3.l305 | 分组1后 `sum(amount + vat_amount)` by `invoice_no + client_id` |
| `oc_container.cbm` | L3.l309 | 分组3后 `sum(cbm)` by `serial_no` |
| — | L3.l310 | `"X"` |
| `oc_container.qty` | L3.l311 | 分组1后 `sum(qty)` by `client_id + invoice_no` |
| — | L3.l312 | `"K"` |

---

## Transformation Rules

| Rule ID | 规则 | 输入示例 | 输出示例 | 异常处理 |
|---|---|---|---|---|
| TR-001 | 日期格式 `yyyy-MM-dd` → `yyyyMMdd` | `2026-04-11` | `20260411` | 空则留空 |
| TR-002 | 日期格式 `DDMMYYYY` → `yyyyMMdd`（m_eta） | `25032026` | `20260325` | 空则留空 |
| TR-003 | 时间格式 `HH:MM` → `HHmm` | `09:30` | `0930` | 空则 `0000` |
| TR-004 | ISA06/ISA08 补位至15字符 | `"KERRY"` | `"KERRY          "` | String.format `%-15s` |
| TR-005 | ctnr 截取 Equipment Initial（前4位） | `"OOLU1234567"` | `"OOLU"` | 不足4位取全部 |
| TR-006 | ctnr 截取 Equipment Number（第5位起） | `"OOLU1234567"` | `"1234567"` | 空则空 |
| TR-007 | 地址合并（空字段不参与，空格分隔），截取前55字符 | `["203 ROUTE","CS 80097","",""]` | `"203 ROUTE CS 80097"` | 全空则空字符串 |
| TR-008 | 港口名截取第一个逗号前的值 | `"ROTTERDAM, ZH, NL"` | `"ROTTERDAM"` | 无逗号则原值 |
| TR-009 | invoiceNo 文件名清洗 | `"INV/100#001"` | `"INV100001"` | `EdiToolUtils.cleanFilename` |
| TR-010 | ocean.terms 映射 B3/B304 | `"COLLECT"` | `"PP"` | 其他值 → `""` |
| TR-011 | oc_container.unit 兜底 | `"BOX"` | `"PCS"` | 非 CTN/PKG → `"PCS"` |
| TR-012 | 控制号生成 | — | `"310000001"` | `group="DYSON","A","310","2","",9` |

---

## Complex Structure Mapping

| 结构 | 规则 |
|---|---|
| 每个 `oc_rate.client_id + invoice_no` 分组生成一份 Msg310X12 文件 | 分组1 |
| `N7Group` 按 `container_no[serial_no + ctnr]` 分组，一组一个 N7Group | 分组2 |
| `L0Group` 按 `container_no[serial_no + ctnr]` 分组，一组一个 L0Group | 分组2 |
| `L1Group`（L1 列表）放在每个 `L0Group` 内，包含当前分组1内所有 `oc_rate` 条目 | 分组1 x 分组2 |
| `L3` 汇总：grs_kgs/cbm 按分组3（serial_no），qty/amount 按分组1 | 分组1 / 分组3 |
| `ocean_milestone[code=IFFDEP]` | 取 `ocean_milestone` 列表中 `code == "IFFDEP"` 的第一条 |
| `ocean_reference[ref_code="Dyson Earliest Pickup"]` | 取 `ocean_reference` 列表中 `ref_code == "Dyson Earliest Pickup"` 的第一条 `ref_value` |

---

## 占位（mapFrom304 范围）

以下字段 AI 不实现，由人工在 `mapFrom304` 中补充：

| 目标 | 说明 |
|---|---|
| N9（非 BM/MB/BN/CN/FN 类型） | 从 MSG304 原始报文透传所有其他 N9 |
| R4(R)（Place of Receipt） | 从 MSG304 R401=R 取 R403/404/405 |
| R4(E)（Place of Delivery） | 从 MSG304 R401=E 取 R403/404/405 及 DTM |
| N7.n722（Equipment Type） | 从 MSG304 N722 透传 |
| V1（船舶信息） | 人工实现 |
