# AirBookingV2 - FMSJOBDOC 及相关类说明文档

## 概述

`FMSJOBDOC` 是空运订舱（Air Booking）场景的一份“作业单数据”聚合对象，由 `HEADER`（报文头/传输头）与 `JOB`（业务主体）组成，用于承载一次订舱/作业的完整数据结构。

本版本（V2）的字段在 Java 中采用 camelCase 命名，并通过 Jackson 注解兼容多种入参字段名形式（如全大写、下划线、小写、首字母大写等）。

## 类结构图

```text
FMSJOBDOC
├─ header : HEADER
│  ├─ format : FORMAT
│  ├─ transmission : TRANSMISSION
│  ├─ sceneCode : String
│  └─ actionCode : String
└─ job : JOB
   ├─ (基础字段：大量 String 字段)
   ├─ tbCompanys : List<TB_COMPANY>
   │  └─ tbCompanyVariants : List<TB_COMPANY_VARIANT>
   ├─ tbAwb : TB_AWB
   ├─ tbJobDocs : List<TB_JOB_DOC>
   ├─ tbJobPickupDelivery : TB_JOB_PICKUP_DELIVERY
   ├─ tbChildJobs : List<TB_CHILD_JOB>
   ├─ tbJobEvents : List<TB_JOB_EVENT>
   ├─ tbJobDims : List<TB_JOB_DIM>
   ├─ tbJobRefs : List<TB_JOB_REF>
   └─ tbJobRemarks : List<TB_JOB_REMARK>
```

## 结构关系

- 一对一：`FMSJOBDOC.header` → `HEADER`
- 一对一：`FMSJOBDOC.job` → `JOB`
- 一对多：`JOB.tbCompanys` → `TB_COMPANY`
- 一对多：`TB_COMPANY.tbCompanyVariants` → `TB_COMPANY_VARIANT`
- 一对一：`JOB.tbAwb` → `TB_AWB`
- 一对多：`JOB.tbJobDocs` → `TB_JOB_DOC`
- 一对一：`JOB.tbJobPickupDelivery` → `TB_JOB_PICKUP_DELIVERY`
- 一对多：`JOB.tbChildJobs` → `TB_CHILD_JOB`
- 一对多：`JOB.tbJobEvents` → `TB_JOB_EVENT`
- 一对多：`JOB.tbJobDims` → `TB_JOB_DIM`
- 一对多：`JOB.tbJobRefs` → `TB_JOB_REF`
- 一对多：`JOB.tbJobRemarks` → `TB_JOB_REMARK`

---

## 1. FMSJOBDOC

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| HEADER | header | HEADER | 报文头/格式与传输信息 |
| JOB | job | JOB | 业务主体（订舱/作业单数据） |

---

## 2. HEADER

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| FORMAT | format | FORMAT | 报文格式标识（标识符/版本） |
| TRANSMISSION | transmission | TRANSMISSION | 发送方与发送时间等传输信息 |
| SCENE_CODE | sceneCode | String | 场景码 |
| ACTIONCODE | actionCode | String | 动作码（具体语义由上下游约定） |

---

## 3. FORMAT

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| IDENTIFIER | identifier | String | 报文格式标识 |
| VERSION | version | String | 报文版本 |

---

## 4. TRANSMISSION

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| SENDER | sender | String | 发送方 |
| SENDEREMAIL | senderEmail | String | 发送方邮箱 |
| TRANSMISSIONDATETIME | transmissionDateTime | String | 发送时间 |
| TRANSMISSONTIMEZONE | transmissionTimeZone | String | 发送时区 |

---

## 5. JOB

`JOB` 是业务主体对象。除大量基础字段（String）外，还包含多个子对象/子表集合用于描述参与方、运单、单证、提派、子单、事件、尺寸、参考号、备注等信息。

### 子对象/子表（重点）

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| TB_COMPANYS | tbCompanys | List\<TB_COMPANY> | 公司/参与方信息集合 |
| TB_AWB | tbAwb | TB_AWB | 运单/航班/重量体积/计费相关信息 |
| TB_JOB_DOCS | tbJobDocs | List\<TB_JOB_DOC> | 单证/附件清单 |
| TB_JOB_PICKUP_DELIVERY | tbJobPickupDelivery | TB_JOB_PICKUP_DELIVERY | 提派信息 |
| TB_CHILD_JOBS | tbChildJobs | List\<TB_CHILD_JOB> | 子作业/子单集合 |
| TB_JOB_EVENTS | tbJobEvents | List\<TB_JOB_EVENT> | 事件/里程碑集合 |
| TB_JOB_DIMS | tbJobDims | List\<TB_JOB_DIM> | 件重尺/尺寸体积明细集合 |
| TB_JOB_REFS | tbJobRefs | List\<TB_JOB_REF> | 参考号集合 |
| TB_JOB_REMARKS | tbJobRemarks | List\<TB_JOB_REMARK> | 备注集合 |
| TB_REVENUES | tbRevenues | String | 收入信息（语义由约定） |
| TB_COSTS | tbCosts | String | 成本信息（语义由约定） |

### 核心基础字段（常用）

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| JOB_NO | jobNo | String | 作业号 |
| SHIPMENT_TYPE | shipmentType | String | 货运类型 |
| BIZTYPE | biztype | String | 业务类型 |
| BOOKING_NO | bookingNo | String | 订舱号 |
| BOOKING_TYPE | bookingType | String | 订舱类型 |
| SHIPMENT_NO | shipmentNo | String | 运单/运单相关编号（语义由约定） |
| MASTER_NO | masterNo | String | 主单号 |
| HOUSE_NO | houseNo | String | 分单号 |
| JOB_DATE | jobDate | String | 作业日期 |
| STATION_CODE | stationCode | String | 站点代码 |
| SERVICE_TYPE | serviceType | String | 服务类型 |
| INCOTERMS | incoterms | String | 贸易条款 |
| ORIGIN_LOCATION_CODE | originLocationCode | String | 起运地代码 |
| POL_LOCATION_CODE | polLocationCode | String | 装货港/起飞港代码 |
| POD_LOCATION_CODE | podLocationCode | String | 卸货港/到达港代码 |
| DESTINATION_LOCATION_CODE | destinationLocationCode | String | 目的地代码 |
| ETD_DATE | etdDate | String | 预计起运时间 |
| ETA_DATE | etaDate | String | 预计到达时间 |
| FINAL_ETA_DATE | finalEtaDate | String | 最终预计到达时间 |
| CURRENCY_CODE | currencyCode | String | 币种 |
| FREIGHT_PAYMENT_TYPE | freightPaymentType | String | 运费付款方式 |
| OTHER_CHARGES_PAYMENT_TYPE | otherChargesPaymentType | String | 其他费用付款方式 |
| IS_LOCKED | isLocked | String | 是否锁定 |
| IS_CLOSED | isClosed | String | 是否关闭 |
| IS_ACTIVE | isActive | String | 是否有效 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |

### 基础字段清单（全量）

| 字段名（JSON） | Java 属性 | 类型 |
|---|---|---|
| JOB_NO | jobNo | String |
| SHIPMENT_TYPE | shipmentType | String |
| BIZTYPE | biztype | String |
| BOOKING_NO | bookingNo | String |
| BOOKING_TYPE | bookingType | String |
| SHIPMENT_NO | shipmentNo | String |
| MASTER_NO | masterNo | String |
| HOUSE_NO | houseNo | String |
| JOB_DATE | jobDate | String |
| STATION_CODE | stationCode | String |
| SALES_TYPE | salesType | String |
| COLOAD_TYPE | coloadType | String |
| COLOAD_COMPANY_CODE | coloadCompanyCode | String |
| CUSTOMER_COMPANY_CODE | customerCompanyCode | String |
| OVERSEAS_AGENT_CODE | overseasAgentCode | String |
| PROJECT_CODE | projectCode | String |
| PROJECT_CODE_DESC | projectCodeDesc | String |
| SERVICE_TYPE | serviceType | String |
| INCOTERMS | incoterms | String |
| SHIPPER_COMPANY_CODE | shipperCompanyCode | String |
| SHIPPER_NAME | shipperName | String |
| SHIPPER_ADDRESS | shipperAddress | String |
| SHIPPER_CITY_CODE | shipperCityCode | String |
| SHIPPER_COUNTRY_CODE | shipperCountryCode | String |
| CONSIGNEE_COMPANY_CODE | consigneeCompanyCode | String |
| CONSIGNEE_NAME | consigneeName | String |
| CONSIGNEE_ADDRESS | consigneeAddress | String |
| CONSIGNEE_CITY_CODE | consigneeCityCode | String |
| CONSIGNEE_COUNTRY_CODE | consigneeCountryCode | String |
| NOTIFY_COMPANY_CODE | notifyCompanyCode | String |
| NOTIFY_COUNTRY_CODE | notifyCountryCode | String |
| NOTIFY_LOCATION_CODE | notifyLocationCode | String |
| NOTIFY_COMPANY_NAME | notifyCompanyName | String |
| NOTIFY_COMPANY_ADDRESS | notifyCompanyAddress | String |
| NOTIFY2_COMPANY_CODE | notify2CompanyCode | String |
| NOTIFY2_COMPANY_ADDRESS | notify2CompanyAddress | String |
| LOCAL_AGENT_CODE | localAgentCode | String |
| DOC_TURNOVER_COMPANY_CODE | docTurnoverCompanyCode | String |
| PAYMENT_INFORMATION_DESCRIPTION | paymentInformationDescription | String |
| POR_LOCATION_CODE | porLocationCode | String |
| ORIGIN_LOCATION_CODE | originLocationCode | String |
| ORIGIN_COUNTRY_CODE | originCountryCode | String |
| ORIGIN_DESCRIPTION | originDescription | String |
| POL_LOCATION_CODE | polLocationCode | String |
| POL_COUNTRY_CODE | polCountryCode | String |
| POL_DESCRIPTION | polDescription | String |
| POD_LOCATION_CODE | podLocationCode | String |
| POD_COUNTRY_CODE | podCountryCode | String |
| POD_DESCRIPTION | podDescription | String |
| DESTINATION_LOCATION_CODE | destinationLocationCode | String |
| DESTINATION_COUNTRY_CODE | destinationCountryCode | String |
| DESTINATION_DESCRIPTION | destinationDescription | String |
| CARGO_READY_DAY | cargoReadyDay | String |
| ATA_DATE | ataDate | String |
| ATD_DATE | atdDate | String |
| ETD_DATE | etdDate | String |
| ETA_DATE | etaDate | String |
| FINAL_ETA_DATE | finalEtaDate | String |
| CURRENCY_CODE | currencyCode | String |
| FREIGHT_PAYMENT_TYPE | freightPaymentType | String |
| OTHER_CHARGES_PAYMENT_TYPE | otherChargesPaymentType | String |
| LAST_LOCKED | lastLocked | String |
| LAST_UNLOCKED | lastUnlocked | String |
| CREATE_BY | createBy | String |
| CREATE_TIMESTAMP | createTimestamp | String |
| CREATE_BY_EMAIL | createByEmail | String |
| IATA_CODE | iataCode | String |
| PIMA_CODE | pimaCode | String |
| UPDATE_BY | updateBy | String |
| UPDATE_TIMESTAMP | updateTimestamp | String |
| UPDATE_BY_EMAIL | updateByEmail | String |
| IS_LOCKED | isLocked | String |
| IS_CONSOL_CLOSED | isConsolClosed | String |
| IS_CLOSED | isClosed | String |
| IS_ACTIVE | isActive | String |
| IS_LL | isKln | String |
| GLOBAL_SHIPMENT_ID | globalShipmentId | String |
| SERVICE_LEVEL | serviceLevel | String |
| THIRD_PARTY_COMPANY_CODE | thirdPartyCompanyCode | String |
| THIRD_PARTY_COMPANY_ADDRESS | thirdPartyCompanyAddress | String |
| EVENT_TYPE_CODE | eventTypeCode | String |
| TB_REVENUES | tbRevenues | String |
| TB_COSTS | tbCosts | String |

---

## 6. TB_COMPANY

用于承载参与方/公司信息，并可包含多个变体（地址/联系方式等）。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| LOCATION_CODE | locationCode | String | 地点代码 |
| LOCATION_DESCRIPTION | locationDescription | String | 地点描述 |
| COMPANY_CODE | companyCode | String | 公司代码 |
| COUNTRY_CODE | countryCode | String | 国家代码 |
| COMPANY_NAME_ENG | companyNameEng | String | 公司英文名 |
| COMPANY_NAME_LOCAL | companyNameLocal | String | 公司本地名 |
| SHORT_NAME | shortName | String | 公司简称 |
| COMPANY_DUPKEY | companyDupkey | String | 公司去重键/唯一键（语义由约定） |
| SALES_USER_CODE | salesUserCode | String | 销售用户代码 |
| STATUS | status | String | 状态 |
| LOCAL_CURRENCY | localCurrency | String | 本位币 |
| REMARK | remark | String | 备注 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |
| TB_COMPANY_VARIANTS | tbCompanyVariants | List\<TB_COMPANY_VARIANT> | 公司变体信息集合 |
| COMPANY_TYPE | companyType | String | 公司类型 |

---

## 7. TB_COMPANY_VARIANT

公司变体信息（同一公司在不同业务类型/不同联系信息下的地址、联系人、电话等）。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| COMPANY_CODE | companyCode | String | 公司代码 |
| COMPANY_VARIANT_TYPE_CODE | companyVariantTypeCode | String | 变体类型代码 |
| BIZTYPE | biztype | String | 业务类型 |
| COMPANY_VAR_NAME | companyVarName | String | 变体名称 |
| ADDR | addr | String | 地址 |
| LOCATION_CODE | locationCode | String | 地点代码 |
| COUNTRY_CODE | countryCode | String | 国家代码 |
| STATE_PROVINCE | stateProvince | String | 州/省 |
| POSTAL_CODE | postalCode | String | 邮编 |
| TEL | tel | String | 电话 |
| FAX | fax | String | 传真 |
| CTC | ctc | String | 联系人 |
| CTC_EMAIL | ctcEmail | String | 联系人邮箱 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |

---

## 8. TB_AWB

用于承载航段（如 FLIGHT1/2/3）、重量体积、计费口径、货描、费用合计等与运单/订舱紧密相关的信息。字段较多，主要用于与外部报文对齐。

### 常用字段（示例）

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| FLIGHT_NO | flightNo | String | 航班号 |
| FLIGHT_DATE | flightDate | String | 航班日期 |
| BOOKED_QTY | bookedQty | String | 订舱件数 |
| BOOKED_WEIGHT | bookedWeight | String | 订舱重量 |
| BOOKED_VOLUME | bookedVolume | String | 订舱体积 |
| GROSS_WEIGHT | grossWeight | String | 毛重 |
| CHARGEABLE_WEIGHT | chargeableWeight | String | 计费重量 |
| GOODS_DESC | goodsDesc | String | 货物描述 |

---

## 9. TB_JOB_DOC

用于承载作业的单证/附件信息（文件名、路径、上传状态、收发记录等）。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| DOC_NO | docNo | String | 单证号 |
| DOC_TYPE | docType | String | 单证类型 |
| HOUSE_NO | houseNo | String | 分单号 |
| NAME | name | String | 文件名 |
| PATH | path | String | 文件路径 |
| UPLOAD_STATUS | uploadStatus | String | 上传状态 |
| RECEIVED_BY | receivedBy | String | 接收人 |
| RECEIVED_TIMESTAMP | receivedTimestamp | String | 接收时间 |
| DELIVERY_BY | deliveryBy | String | 交付人 |
| DELIVERY_TIMESTAMP | deliveryTimestamp | String | 交付时间 |
| RETURNED_BY | returnedBy | String | 退回人 |
| RETURNED_TIMESTAMP | returnedTimestamp | String | 退回时间 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |
| DMS_ID | dmsId | String | 外部文档系统标识 |
| S3_ID | s3Id | String | 外部存储标识 |

---

## 10. TB_JOB_PICKUP_DELIVERY

用于承载提货/派送相关信息（提货地址、预计时间、车辆与联系人信息、总量信息等）。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| TB_ORDER_TYPE | tbOrderType | String | 订单/提派类型 |
| PICKUP_ADDRESS | pickupAddress | String | 提货地址 |
| EST_DATE | estDate | String | 预计日期 |
| PD_TOTAL_WEIGHT | pdTotalWeight | String | 总重 |
| PD_TOTAL_WEIGHT_UNITS | pdTotalWeightUnits | String | 总重单位 |
| PD_TOTAL_VOLUME | pdTotalVolume | String | 总体积 |
| PD_TOTAL_VOLUME_UNITS | pdTotalVolumeUnits | String | 总体积单位 |
| PD_TOTAL_ITEM | pdTotalItem | String | 总件数 |
| PD_REMARK | pdRemark | String | 备注 |
| PD_VEHICLE_TYPE | pdVehicleType | String | 车辆类型 |
| PD_VEHICLE_DRIVER | pdVehicleDriver | String | 司机 |
| PD_VEHICLE_DRIVER_CONTACT | pdVehicleDriverContact | String | 司机联系方式 |
| PD_CONTACT | pdContact | String | 联系人 |
| PD_COMPANY_NAME | pdCompanyName | String | 公司名称 |

---

## 11. TB_CHILD_JOB

用于描述主作业下的子作业/子单拆分数据。其字段结构与 `JOB` 相近，同样包含基础字段与子表集合。子单中的字段别名同样用于兼容多种入参字段名形式（其中 `SALES_TYPE` 存在兼容别名 `SALS_TYPE`）。

### 子对象/子表

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| TB_COMPANYS | tbCompanys | List\<TB_COMPANY> | 公司/参与方信息集合 |
| TB_AWB | tbAwb | TB_AWB | 运单/航班/重量体积/计费相关信息 |
| TB_JOB_DOCS | tbJobDocs | List\<TB_JOB_DOC> | 单证/附件清单 |
| TB_JOB_EVENTS | tbJobEvents | List\<TB_JOB_EVENT> | 事件/里程碑集合 |
| TB_JOB_DIMS | tbJobDims | List\<TB_JOB_DIM> | 件重尺/尺寸体积明细集合 |
| TB_JOB_REFS | tbJobRefs | List\<TB_JOB_REF> | 参考号集合 |
| TB_JOB_REMARKS | tbJobRemarks | List\<TB_JOB_REMARK> | 备注集合 |
| TB_JOB_PICKUP_DELIVERY | tbJobPickupDelivery | TB_JOB_PICKUP_DELIVERY | 提派信息 |
| TB_REVENUES | tbRevenues | String | 收入信息（语义由约定） |
| TB_COSTS | tbCosts | String | 成本信息（语义由约定） |

### 核心基础字段（常用）

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| JOB_NO | jobNo | String | 作业号 |
| SHIPMENT_TYPE | shipmentType | String | 货运类型 |
| BIZTYPE | biztype | String | 业务类型 |
| BOOKING_NO | bookingNo | String | 订舱号 |
| BOOKING_TYPE | bookingType | String | 订舱类型 |
| SHIPMENT_NO | shipmentNo | String | 运单/运单相关编号（语义由约定） |
| MASTER_NO | masterNo | String | 主单号 |
| HOUSE_NO | houseNo | String | 分单号 |

### 基础字段清单（全量）

| 字段名（JSON） | Java 属性 | 类型 |
|---|---|---|
| JOB_NO | jobNo | String |
| SHIPMENT_TYPE | shipmentType | String |
| BIZTYPE | biztype | String |
| BOOKING_NO | bookingNo | String |
| BOOKING_TYPE | bookingType | String |
| SHIPMENT_NO | shipmentNo | String |
| MASTER_NO | masterNo | String |
| HOUSE_NO | houseNo | String |
| JOB_DATE | jobDate | String |
| STATION_CODE | stationCode | String |
| SALES_TYPE | salesType | String |
| COLOAD_TYPE | coloadType | String |
| COLOAD_COMPANY_CODE | coloadCompanyCode | String |
| CUSTOMER_COMPANY_CODE | customerCompanyCode | String |
| OVERSEAS_AGENT_CODE | overseasAgentCode | String |
| PROJECT_CODE | projectCode | String |
| PROJECT_CODE_DESC | projectCodeDesc | String |
| SERVICE_TYPE | serviceType | String |
| INCOTERMS | incoterms | String |
| SHIPPER_COMPANY_CODE | shipperCompanyCode | String |
| SHIPPER_NAME | shipperName | String |
| SHIPPER_ADDRESS | shipperAddress | String |
| SHIPPER_CITY_CODE | shipperCityCode | String |
| SHIPPER_COUNTRY_CODE | shipperCountryCode | String |
| SHIPPER_CONTACT | shipperContact | String |
| SHIPPER_TEL | shipperTel | String |
| SHIPPER_FAX | shipperFax | String |
| SHIPPER_GOVT_REF_TYPE | shipperGovtRefType | String |
| SHIPPER_GOVT_REF_NO | shipperGovtRefNo | String |
| CONSIGNEE_COMPANY_CODE | consigneeCompanyCode | String |
| CONSIGNEE_NAME | consigneeName | String |
| CONSIGNEE_ADDRESS | consigneeAddress | String |
| CONSIGNEE_CITY_CODE | consigneeCityCode | String |
| CONSIGNEE_COUNTRY_CODE | consigneeCountryCode | String |
| CONSIGNEE_CONTACT | consigneeContact | String |
| CONSIGNEE_TEL | consigneeTel | String |
| CONSIGNEE_FAX | consigneeFax | String |
| CONSIGNEE_GOVT_REF_TYPE | consigneeGovtRefType | String |
| CONSIGNEE_GOVT_REF_NO | consigneeGovtRefNo | String |
| NOTIFY_COMPANY_CODE | notifyCompanyCode | String |
| NOTIFY_COUNTRY_CODE | notifyCountryCode | String |
| NOTIFY_COMPANY_NAME | notifyCompanyName | String |
| NOTIFY_COMPANY_ADDRESS | notifyCompanyAddress | String |
| NOTIFY_CONTACT | notifyContact | String |
| NOTIFY_TEL | notifyTel | String |
| NOTIFY_FAX | notifyFax | String |
| NOTIFY_GOVT_REF_TYPE | notifyGovtRefType | String |
| NOTIFY_GOVT_REF_NO | notifyGovtRefNo | String |
| LOCAL_AGENT_CODE | localAgentCode | String |
| PAYMENT_INFORMATION_DESCRIPTION | paymentInformationDescription | String |
| ORIGIN_LOCATION_CODE | originLocationCode | String |
| ORIGIN_COUNTRY_CODE | originCountryCode | String |
| ORIGIN_DESCRIPTION | originDescription | String |
| DESTINATION_LOCATION_CODE | destinationLocationCode | String |
| DESTINATION_COUNTRY_CODE | destinationCountryCode | String |
| DESTINATION_DESCRIPTION | destinationDescription | String |
| ETD_DATE | etdDate | String |
| ETA_DATE | etaDate | String |
| FINAL_ETA_DATE | finalEtaDate | String |
| CURRENCY_CODE | currencyCode | String |
| FREIGHT_PAYMENT_TYPE | freightPaymentType | String |
| OTHER_CHARGES_PAYMENT_TYPE | otherChargesPaymentType | String |
| LAST_LOCKED | lastLocked | String |
| LAST_UNLOCKED | lastUnlocked | String |
| CREATE_BY | createBy | String |
| CREATE_TIMESTAMP | createTimestamp | String |
| CREATE_BY_EMAIL | createByEmail | String |
| UPDATE_BY | updateBy | String |
| UPDATE_TIMESTAMP | updateTimestamp | String |
| UPDATE_BY_EMAIL | updateByEmail | String |
| IS_LOCKED | isLocked | String |
| IS_CONSOL_CLOSED | isConsolClosed | String |
| IS_CLOSED | isClosed | String |
| IS_ACTIVE | isActive | String |
| IS_LL | isKln | String |
| GLOBAL_SHIPMENT_ID | globalShipmentId | String |
| STOCK_OUT_DATE | stockOutDate | String |
| STOCK_IN_DATE | stockInDate | String |
| SERVICE_LEVEL | serviceLevel | String |
| THIRD_PARTY_COMPANY_CODE | thirdPartyCompanyCode | String |
| THIRD_PARTY_COMPANY_ADDRESS | thirdPartyCompanyAddress | String |

---

## 12. TB_JOB_EVENT

用于承载作业事件/里程碑信息（事件码、事件时间、备注、原因码等）。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| SNO | sno | String | 序号 |
| EVENT_CODE | eventCode | String | 事件码 |
| EVENT_CODE_DESC | eventCodeDesc | String | 事件描述 |
| EVENT_TIMESTAMP | eventTimestamp | String | 事件时间 |
| EST_EVENT_TIMESTAMP | estEventTimestamp | String | 预计事件时间 |
| REMARKS | remarks | String | 备注 |
| REASON_CODE | reasonCode | String | 原因码 |
| REASON_REMARK | reasonRemark | String | 原因备注 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |

---

## 13. TB_JOB_DIM

用于承载件重尺/尺寸体积明细。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| STAGE | stage | String | 阶段 |
| SNO | sno | String | 序号 |
| ITEM_COUNT | itemCount | String | 件数 |
| ITEM_TYPE | itemType | String | 件型 |
| LENGTH | length | String | 长 |
| WIDTH | width | String | 宽 |
| HEIGHT | height | String | 高 |
| LEN_UNITS | lenUnits | String | 长度单位 |
| WEIGHT | weight | String | 重量 |
| WEIGHT_UNITS | weightUnits | String | 重量单位 |
| VOLUME | volume | String | 体积 |
| VOLUME_UNITS | volumeUnits | String | 体积单位 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |

---

## 14. TB_JOB_REF

用于承载参考号信息（类型 + 编号），可用于关联外部系统单号或业务参考号。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| REF_TYPE | refType | String | 参考号类型 |
| REF_NO | refNo | String | 参考号 |
| REMARKS | remarks | String | 备注 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |

---

## 15. TB_JOB_REMARK

用于承载作业备注信息。

### 基本信息

| 字段名（JSON） | Java 属性 | 类型 | 说明 |
|---|---|---|---|
| REMARK_TYPE | remarkType | String | 备注类型 |
| REMARK | remark | String | 备注内容 |
| REMARK_DATE | remarkDate | String | 备注日期 |
| CREATE_BY | createBy | String | 创建人 |
| CREATE_TIMESTAMP | createTimestamp | String | 创建时间 |
| UPDATE_BY | updateBy | String | 更新人 |
| UPDATE_TIMESTAMP | updateTimestamp | String | 更新时间 |

