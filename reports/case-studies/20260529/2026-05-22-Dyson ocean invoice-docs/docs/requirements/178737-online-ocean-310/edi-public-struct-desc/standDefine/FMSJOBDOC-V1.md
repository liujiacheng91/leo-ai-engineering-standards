# AirBooking - FMSJOBDOC 及相关类说明文档

## 概述

`FMSJOBDOC` 是空运订舱（Air Booking）场景的一份“作业单数据”聚合对象，由 `HEADER`（报文头/传输头）与 `JOB`（业务主体）组成，用于承载一次订舱/作业的完整数据结构。

## 类结构图

```text
FMSJOBDOC
├─ header : HEADER
│  ├─ format : FORMAT
│  ├─ transmission : TRANSMISSION
│  ├─ SCENE_CODE : String
│  └─ ACTIONCODE : String
└─ job : JOB
   ├─ (基础字段：大量 String 字段)
   ├─ TB_COMPANYS : List<TB_COMPANY>
   │  └─ TB_COMPANY_VARIANTS : List<TB_COMPANY_VARIANT>
   ├─ tb_awb : TB_AWB
   ├─ TB_JOB_DOCS : List<TB_JOB_DOC>
   ├─ tb_job_pickup_delivery : TB_JOB_PICKUP_DELIVERY
   ├─ TB_CHILD_JOBS : List<TB_CHILD_JOB>
   ├─ TB_JOB_EVENTS : List<TB_JOB_EVENT>
   ├─ TB_JOB_DIMS : List<TB_JOB_DIM>
   ├─ TB_JOB_REFS : List<TB_JOB_REF>
   └─ TB_JOB_REMARKS : List<TB_JOB_REMARK>
```

## 结构关系

- 一对一：`FMSJOBDOC.header` → `HEADER`
- 一对一：`FMSJOBDOC.job` → `JOB`
- 一对多：`JOB.TB_COMPANYS` → `TB_COMPANY`
- 一对多：`TB_COMPANY.TB_COMPANY_VARIANTS` → `TB_COMPANY_VARIANT`
- 一对一：`JOB.tb_awb` → `TB_AWB`
- 一对多：`JOB.TB_JOB_DOCS` → `TB_JOB_DOC`
- 一对一：`JOB.tb_job_pickup_delivery` → `TB_JOB_PICKUP_DELIVERY`
- 一对多：`JOB.TB_CHILD_JOBS` → `TB_CHILD_JOB`
- 一对多：`JOB.TB_JOB_EVENTS` → `TB_JOB_EVENT`
- 一对多：`JOB.TB_JOB_DIMS` → `TB_JOB_DIM`
- 一对多：`JOB.TB_JOB_REFS` → `TB_JOB_REF`
- 一对多：`JOB.TB_JOB_REMARKS` → `TB_JOB_REMARK`

---

## 1. FMSJOBDOC

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| header | HEADER | 报文头/格式与传输信息 |
| job | JOB | 业务主体（订舱/作业单数据） |

---

## 2. HEADER

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| format | FORMAT | 报文格式标识（标识符/版本） |
| transmission | TRANSMISSION | 发送方与发送时间等传输信息 |
| SCENE_CODE | String | 场景码 |
| ACTIONCODE | String | 动作码（具体语义由上下游约定） |

---

## 3. FORMAT

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| IDENTIFIER | String | 报文格式标识 |
| VERSION | String | 报文版本 |

---

## 4. TRANSMISSION

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| SENDER | String | 发送方 |
| SENDEREMAIL | String | 发送方邮箱 |
| TRANSMISSIONDATETIME | String | 发送时间 |
| TRANSMISSONTIMEZONE | String | 发送时区 |

---

## 5. JOB

`JOB` 是业务主体对象，字段命名大量采用全大写，常用于与外部报文（如 JSON 字段）直接对齐。除了大量基础字段（String）外，还包含多个子对象/子表集合用于描述参与方、运单、单证、事件、尺寸、参考号、备注等信息。

### 子对象/子表（重点）

| 字段名 | 类型 | 说明 |
|---|---|---|
| TB_COMPANYS | List\<TB_COMPANY> | 公司/参与方信息集合 |
| tb_awb | TB_AWB | 运单/航班/重量体积/计费相关信息 |
| TB_JOB_DOCS | List\<TB_JOB_DOC> | 单证/附件清单 |
| tb_job_pickup_delivery | TB_JOB_PICKUP_DELIVERY | 提派信息 |
| TB_CHILD_JOBS | List\<TB_CHILD_JOB> | 子作业/子单集合 |
| TB_JOB_EVENTS | List\<TB_JOB_EVENT> | 事件/里程碑集合 |
| TB_JOB_DIMS | List\<TB_JOB_DIM> | 件重尺/尺寸体积明细集合 |
| TB_JOB_REFS | List\<TB_JOB_REF> | 参考号集合 |
| TB_JOB_REMARKS | List\<TB_JOB_REMARK> | 备注集合 |

### 核心基础字段（常用）

| 字段名 | 类型 | 说明 |
|---|---|---|
| JOB_NO | String | 作业号 |
| SHIPMENT_TYPE | String | 货运类型 |
| BIZTYPE | String | 业务类型 |
| BOOKING_NO | String | 订舱号 |
| BOOKING_TYPE | String | 订舱类型 |
| SHIPMENT_NO | String | 运单/运单相关编号（语义由约定） |
| MASTER_NO | String | 主单号 |
| HOUSE_NO | String | 分单号 |
| JOB_DATE | String | 作业日期 |
| STATION_CODE | String | 站点代码 |
| SERVICE_TYPE | String | 服务类型 |
| INCOTERMS | String | 贸易条款 |
| ORIGIN_LOCATION_CODE | String | 起运地代码 |
| POL_LOCATION_CODE | String | 装货港/起飞港代码 |
| POD_LOCATION_CODE | String | 卸货港/到达港代码 |
| DESTINATION_LOCATION_CODE | String | 目的地代码 |
| ETD_DATE | String | 预计起运时间 |
| ETA_DATE | String | 预计到达时间 |
| FINAL_ETA_DATE | String | 最终预计到达时间 |
| CURRENCY_CODE | String | 币种 |
| FREIGHT_PAYMENT_TYPE | String | 运费付款方式 |
| OTHER_CHARGES_PAYMENT_TYPE | String | 其他费用付款方式 |
| IS_LOCKED | String | 是否锁定 |
| IS_CLOSED | String | 是否关闭 |
| IS_ACTIVE | String | 是否有效 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |

### 基础字段清单（全量）

| 字段名 | 类型 |
|---|---|
| JOB_NO | String |
| SHIPMENT_TYPE | String |
| BIZTYPE | String |
| BOOKING_NO | String |
| BOOKING_TYPE | String |
| SHIPMENT_NO | String |
| MASTER_NO | String |
| HOUSE_NO | String |
| JOB_DATE | String |
| STATION_CODE | String |
| SALES_TYPE | String |
| COLOAD_TYPE | String |
| COLOAD_COMPANY_CODE | String |
| CUSTOMER_COMPANY_CODE | String |
| OVERSEAS_AGENT_CODE | String |
| PROJECT_CODE | String |
| PROJECT_CODE_DESC | String |
| SERVICE_TYPE | String |
| INCOTERMS | String |
| SHIPPER_COMPANY_CODE | String |
| SHIPPER_NAME | String |
| SHIPPER_ADDRESS | String |
| SHIPPER_CITY_CODE | String |
| SHIPPER_COUNTRY_CODE | String |
| CONSIGNEE_COMPANY_CODE | String |
| CONSIGNEE_NAME | String |
| CONSIGNEE_ADDRESS | String |
| CONSIGNEE_CITY_CODE | String |
| CONSIGNEE_COUNTRY_CODE | String |
| NOTIFY_COMPANY_CODE | String |
| NOTIFY_COUNTRY_CODE | String |
| NOTIFY_LOCATION_CODE | String |
| NOTIFY_COMPANY_NAME | String |
| NOTIFY_COMPANY_ADDRESS | String |
| NOTIFY2_COMPANY_CODE | String |
| NOTIFY2_COMPANY_ADDRESS | String |
| LOCAL_AGENT_CODE | String |
| DOC_TURNOVER_COMPANY_CODE | String |
| PAYMENT_INFORMATION_DESCRIPTION | String |
| POR_LOCATION_CODE | String |
| ORIGIN_LOCATION_CODE | String |
| ORIGIN_COUNTRY_CODE | String |
| ORIGIN_DESCRIPTION | String |
| POL_LOCATION_CODE | String |
| POL_COUNTRY_CODE | String |
| POL_DESCRIPTION | String |
| POD_LOCATION_CODE | String |
| POD_COUNTRY_CODE | String |
| POD_DESCRIPTION | String |
| DESTINATION_LOCATION_CODE | String |
| DESTINATION_COUNTRY_CODE | String |
| DESTINATION_DESCRIPTION | String |
| CARGO_READY_DAY | String |
| ATA_DATE | String |
| ATD_DATE | String |
| ETD_DATE | String |
| ETA_DATE | String |
| FINAL_ETA_DATE | String |
| CURRENCY_CODE | String |
| FREIGHT_PAYMENT_TYPE | String |
| OTHER_CHARGES_PAYMENT_TYPE | String |
| LAST_LOCKED | String |
| LAST_UNLOCKED | String |
| CREATE_BY | String |
| CREATE_TIMESTAMP | String |
| CREATE_BY_EMAIL | String |
| IATA_CODE | String |
| PIMA_CODE | String |
| UPDATE_BY | String |
| UPDATE_TIMESTAMP | String |
| UPDATE_BY_EMAIL | String |
| IS_LOCKED | String |
| IS_CONSOL_CLOSED | String |
| IS_CLOSED | String |
| IS_ACTIVE | String |
| IS_LL | String |
| GLOBAL_SHIPMENT_ID | String |
| SERVICE_LEVEL | String |
| THIRD_PARTY_COMPANY_CODE | String |
| THIRD_PARTY_COMPANY_ADDRESS | String |
| EVENT_TYPE_CODE | String |
| TB_REVENUES | String |
| TB_COSTS | String |

---

## 6. TB_COMPANY

用于承载参与方/公司信息（如客户、代理、承运相关公司等），并可包含多个变体（地址/联系方式等）。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| LOCATION_CODE | String | 地点代码 |
| LOCATION_DESCRIPTION | String | 地点描述 |
| COMPANY_CODE | String | 公司代码 |
| COUNTRY_CODE | String | 国家代码 |
| COMPANY_NAME_ENG | String | 公司英文名 |
| COMPANY_NAME_LOCAL | String | 公司本地名 |
| SHORT_NAME | String | 公司简称 |
| COMPANY_DUPKEY | String | 公司去重键/唯一键（语义由约定） |
| SALES_USER_CODE | String | 销售用户代码 |
| STATUS | String | 状态 |
| LOCAL_CURRENCY | String | 本位币 |
| REMARK | String | 备注 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |
| TB_COMPANY_VARIANTS | List\<TB_COMPANY_VARIANT> | 公司变体信息集合 |
| COMPANY_TYPE | String | 公司类型 |

---

## 7. TB_COMPANY_VARIANT

公司变体信息（常用于描述同一公司在不同业务类型/不同联系信息下的地址、联系人、电话等）。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| COMPANY_CODE | String | 公司代码 |
| COMPANY_VARIANT_TYPE_CODE | String | 变体类型代码 |
| BIZTYPE | String | 业务类型 |
| COMPANY_VAR_NAME | String | 变体名称 |
| ADDR | String | 地址 |
| LOCATION_CODE | String | 地点代码 |
| COUNTRY_CODE | String | 国家代码 |
| STATE_PROVINCE | String | 州/省 |
| POSTAL_CODE | String | 邮编 |
| TEL | String | 电话 |
| FAX | String | 传真 |
| CTC | String | 联系人 |
| ctcEmail | String | 联系人邮箱 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |

---

## 8. TB_AWB

用于承载航段（如 FLIGHT1/2/3）、重量体积、计费口径、货描、费用合计等与运单/订舱紧密相关的信息。字段较多，主要用于与外部报文对齐。

### 常用字段（示例）

| 字段名 | 类型 | 说明 |
|---|---|---|
| FLIGHT_NO | String | 航班号 |
| FLIGHT_DATE | String | 航班日期 |
| BOOKED_QTY / BOOKED_QTY_UNIT | String | 订舱件数/单位 |
| BOOKED_WEIGHT / BOOKED_WEIGHT_UNITS | String | 订舱重量/单位 |
| BOOKED_VOLUME / BOOKED_VOLUME_UNITS | String | 订舱体积/单位 |
| GROSS_WEIGHT | String | 毛重 |
| CHARGEABLE_WEIGHT / CHARGEABLE_WEIGHT_UNITS | String | 计费重量/单位 |
| GOODS_DESC | String | 货物描述 |

---

## 9. TB_JOB_DOC

用于承载作业的单证/附件信息（文件名、路径、上传状态、收发记录等）。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| DOC_NO | String | 单证号 |
| DOC_TYPE | String | 单证类型 |
| HOUSE_NO | String | 分单号 |
| NAME | String | 文件名 |
| PATH | String | 文件路径 |
| UPLOAD_STATUS | String | 上传状态 |
| RECEIVED_BY | String | 接收人 |
| RECEIVED_TIMESTAMP | String | 接收时间 |
| DELIVERY_BY | String | 交付人 |
| DELIVERY_TIMESTAMP | String | 交付时间 |
| RETURNED_BY | String | 退回人 |
| RETURNED_TIMESTAMP | String | 退回时间 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |
| DMS_ID | String | 外部文档系统标识 |
| S3_ID | String | 外部存储标识 |

---

## 10. TB_JOB_PICKUP_DELIVERY

用于承载提货/派送相关信息（提货地址、预计时间、车辆与联系人信息、总量信息等）。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| TB_ORDER_TYPE | String | 订单/提派类型 |
| PICKUP_ADDRESS | String | 提货地址 |
| EST_DATE | String | 预计日期 |
| PD_TOTAL_WEIGHT / PD_TOTAL_WEIGHT_UNITS | String | 总重/单位 |
| PD_TOTAL_VOLUME / PD_TOTAL_VOLUME_UNITS | String | 总体积/单位 |
| PD_TOTAL_ITEM | String | 总件数 |
| PD_REMARK | String | 备注 |
| PD_VEHICLE_TYPE | String | 车辆类型 |
| PD_VEHICLE_DRIVER | String | 司机 |
| PD_VEHICLE_DRIVER_CONTACT | String | 司机联系方式 |
| PD_CONTACT | String | 联系人 |
| PD_COMPANY_NAME | String | 公司名称 |

---

## 11. TB_CHILD_JOB

用于描述主作业下的子作业/子单拆分数据。其字段结构与 `JOB` 类似，同样包含基础字段与子表集合。

### 子对象/子表

| 字段名 | 类型 | 说明 |
|---|---|---|
| TB_COMPANYS | List\<TB_COMPANY> | 公司/参与方信息集合 |
| TB_AWB | TB_AWB | 运单/航班/重量体积/计费相关信息 |
| TB_JOB_DOCS | List\<TB_JOB_DOC> | 单证/附件清单 |
| TB_JOB_EVENTS | List\<TB_JOB_EVENT> | 事件/里程碑集合 |
| TB_JOB_DIMS | List\<TB_JOB_DIM> | 件重尺/尺寸体积明细集合 |
| TB_JOB_REFS | List\<TB_JOB_REF> | 参考号集合 |
| TB_JOB_REMARKS | List\<TB_JOB_REMARK> | 备注集合 |
| TB_JOB_PICKUP_DELIVERY | TB_JOB_PICKUP_DELIVERY | 提派信息 |
| TB_REVENUES | String | 收入信息（语义由约定） |
| TB_COSTS | String | 成本信息（语义由约定） |

### 核心基础字段（常用）

| 字段名 | 类型 | 说明 |
|---|---|---|
| JOB_NO | String | 作业号 |
| SHIPMENT_TYPE | String | 货运类型 |
| BIZTYPE | String | 业务类型 |
| BOOKING_NO | String | 订舱号 |
| BOOKING_TYPE | String | 订舱类型 |
| SHIPMENT_NO | String | 运单/运单相关编号（语义由约定） |
| MASTER_NO | String | 主单号 |
| HOUSE_NO | String | 分单号 |
| ORIGIN_LOCATION_CODE | String | 起运地代码 |
| DESTINATION_LOCATION_CODE | String | 目的地代码 |
| ETD_DATE | String | 预计起运时间 |
| ETA_DATE | String | 预计到达时间 |
| FINAL_ETA_DATE | String | 最终预计到达时间 |

### 基础字段清单（全量）

| 字段名 | 类型 |
|---|---|
| JOB_NO | String |
| SHIPMENT_TYPE | String |
| BIZTYPE | String |
| BOOKING_NO | String |
| BOOKING_TYPE | String |
| SHIPMENT_NO | String |
| MASTER_NO | String |
| HOUSE_NO | String |
| JOB_DATE | String |
| STATION_CODE | String |
| SALES_TYPE | String |
| COLOAD_TYPE | String |
| COLOAD_COMPANY_CODE | String |
| CUSTOMER_COMPANY_CODE | String |
| OVERSEAS_AGENT_CODE | String |
| PROJECT_CODE | String |
| PROJECT_CODE_DESC | String |
| SERVICE_TYPE | String |
| INCOTERMS | String |
| SHIPPER_COMPANY_CODE | String |
| SHIPPER_NAME | String |
| SHIPPER_ADDRESS | String |
| SHIPPER_CITY_CODE | String |
| SHIPPER_COUNTRY_CODE | String |
| SHIPPER_CONTACT | String |
| SHIPPER_TEL | String |
| SHIPPER_FAX | String |
| SHIPPER_GOVT_REF_TYPE | String |
| SHIPPER_GOVT_REF_NO | String |
| CONSIGNEE_COMPANY_CODE | String |
| CONSIGNEE_NAME | String |
| CONSIGNEE_ADDRESS | String |
| CONSIGNEE_CITY_CODE | String |
| CONSIGNEE_COUNTRY_CODE | String |
| CONSIGNEE_CONTACT | String |
| CONSIGNEE_TEL | String |
| CONSIGNEE_FAX | String |
| CONSIGNEE_GOVT_REF_TYPE | String |
| CONSIGNEE_GOVT_REF_NO | String |
| NOTIFY_COMPANY_CODE | String |
| NOTIFY_COUNTRY_CODE | String |
| NOTIFY_COMPANY_NAME | String |
| NOTIFY_COMPANY_ADDRESS | String |
| NOTIFY_CONTACT | String |
| NOTIFY_TEL | String |
| NOTIFY_FAX | String |
| NOTIFY_GOVT_REF_TYPE | String |
| NOTIFY_GOVT_REF_NO | String |
| LOCAL_AGENT_CODE | String |
| PAYMENT_INFORMATION_DESCRIPTION | String |
| ORIGIN_LOCATION_CODE | String |
| ORIGIN_COUNTRY_CODE | String |
| ORIGIN_DESCRIPTION | String |
| DESTINATION_LOCATION_CODE | String |
| DESTINATION_COUNTRY_CODE | String |
| DESTINATION_DESCRIPTION | String |
| ETD_DATE | String |
| ETA_DATE | String |
| FINAL_ETA_DATE | String |
| CURRENCY_CODE | String |
| FREIGHT_PAYMENT_TYPE | String |
| OTHER_CHARGES_PAYMENT_TYPE | String |
| LAST_LOCKED | String |
| LAST_UNLOCKED | String |
| CREATE_BY | String |
| CREATE_TIMESTAMP | String |
| CREATE_BY_EMAIL | String |
| UPDATE_BY | String |
| UPDATE_TIMESTAMP | String |
| UPDATE_BY_EMAIL | String |
| IS_LOCKED | String |
| IS_CONSOL_CLOSED | String |
| IS_CLOSED | String |
| IS_ACTIVE | String |
| IS_LL | String |
| GLOBAL_SHIPMENT_ID | String |
| STOCK_OUT_DATE | String |
| STOCK_IN_DATE | String |
| SERVICE_LEVEL | String |
| THIRD_PARTY_COMPANY_CODE | String |
| THIRD_PARTY_COMPANY_ADDRESS | String |

---

## 12. TB_JOB_EVENT

用于承载作业事件/里程碑信息（事件码、事件时间、备注、原因码等）。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| SNO | String | 序号 |
| EVENT_CODE | String | 事件码 |
| EVENT_CODE_DESC | String | 事件描述 |
| EVENT_TIMESTAMP | String | 事件时间 |
| EST_EVENT_TIMESTAMP | String | 预计事件时间 |
| REMARKS | String | 备注 |
| reasonCode | String | 原因码 |
| reasonRemark | String | 原因备注 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |

---

## 13. TB_JOB_DIM

用于承载件重尺/尺寸体积明细。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| STAGE | String | 阶段 |
| SNO | String | 序号 |
| ITEM_COUNT | String | 件数 |
| ITEM_TYPE | String | 件型 |
| LENGTH / WIDTH / HEIGHT | String | 长/宽/高 |
| LEN_UNITS | String | 长度单位 |
| WEIGHT | String | 重量 |
| WEIGHT_UNITS | String | 重量单位 |
| VOLUME | String | 体积 |
| VOLUME_UNITS | String | 体积单位 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |

---

## 14. TB_JOB_REF

用于承载参考号信息（类型 + 编号），可用于关联外部系统单号或业务参考号。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| REF_TYPE | String | 参考号类型 |
| REF_NO | String | 参考号 |
| REMARKS | String | 备注 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |

---

## 15. TB_JOB_REMARK

用于承载作业备注信息。

### 基本信息

| 字段名 | 类型 | 说明 |
|---|---|---|
| REMARK_TYPE | String | 备注类型 |
| REMARK | String | 备注内容 |
| REMARK_DATE | String | 备注日期 |
| CREATE_BY | String | 创建人 |
| CREATE_TIMESTAMP | String | 创建时间 |
| UPDATE_BY | String | 更新人 |
| UPDATE_TIMESTAMP | String | 更新时间 |

