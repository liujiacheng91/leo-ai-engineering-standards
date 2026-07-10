# AirShipment 结构说明

## 概述
AirShipment 是空运业务的核心数据结构类，对应数据库表 `air`，用于表示空运货物的完整信息。该类包含了空运货物的基本信息、承运人信息、货物详情、收发货人信息、运输路线、重量体积等全方位数据。

## 类结构图

```
AirShipment
├── AirShipmentContainer
├── AirShipmentReference
├── AirShipmentExtend
├── AirShipmentMilestone
├── AirRate
├── AirShipmentDocUpload
└── AirShipmentDoc (已废弃)
```

## 结构关系
AirShipment 作为空运业务的核心实体，与多个关联对象形成完整的数据结构关系：
- **一对多关系**：AirShipment 包含多个 AirShipmentContainer（容器信息），用于记录货物的不同包装和容器详情
- **一对多关系**：AirShipment 包含多个 AirShipmentReference（参考信息），用于记录与货物相关的各种参考编号
- **一对一关系**：AirShipment 包含一个 AirShipmentExtend（扩展信息），用于存储额外的业务属性
- **一对多关系**：AirShipment 包含多个 AirShipmentMilestone（里程碑信息），记录货物运输过程中的关键事件
- **一对多关系**：AirShipment 包含多个 AirRate（费率信息），记录货物的各项费用明细
- **一对多关系**：AirShipment 包含多个 AirShipmentDocUpload（文档上传信息），用于管理货物相关的各类文档

这种结构设计使得 AirShipment 既能作为独立实体使用，又能通过关联对象实现更复杂的业务场景支持，满足空运业务中货物跟踪、信息管理和业务处理的需求。

## 主要属性分类

### 1. 基础标识信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| scene_code | String | 场景代码 |
| id | Integer | 主键ID |
| serial_no | String | 序列号 |
| file_no | String | 文件号 |
| file_date | String | 文件日期 |
| status | String | 状态 |

### 2. 承运人信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| airline_1 | String | 航空公司代码1 |
| airline_2 | String | 航空公司代码2 |
| airline_3 | String | 航空公司代码3 |
| airline_4 | String | 航空公司代码4 |
| by_carrier_1 | String | 承运人信息1 |
| by_carrier_2 | String | 承运人信息2 |
| by_carrier_3 | String | 承运人信息3 |
| by_carrier_4 | String | 承运人信息4 |
| to_carrier_1 | String | 目的地承运人信息1 |
| to_carrier_2 | String | 目的地承运人信息2 |
| to_carrier_3 | String | 目的地承运人信息3 |
| to_carrier_4 | String | 目的地承运人信息4 |

### 3. 运单信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| awb_body | String | 空运提单主体 |
| awb_type | String | 空运提单类型 |
| mawb | String | 主运单号 |
| hawb | String | 分运单号 |
| booking_no | String | 预订号 |
| house_link_no | String | 分运单链接号 |
| manifest_hbol | String | 清单分运单号 |

### 4. 收发货人信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| **发货人(Shipper)** | | |
| shipper_id | String | 发货人ID |
| shipper_name | String | 发货人名称 |
| shipper_address_1 | String | 发货人地址1 |
| shipper_address_2 | String | 发货人地址2 |
| shipper_address_3 | String | 发货人地址3 |
| shipper_address_4 | String | 发货人地址4 |
| shipper_phone | String | 发货人电话 |
| shipper_email | String | 发货人邮箱 |
| shipper_city_code | String | 发货人城市代码 |
| shipper_city | String | 发货人城市 |
| shipper_state | String | 发货人州/省 |
| shipper_zipcode | String | 发货人邮编 |
| shipper_country_code | String | 发货人国家代码 |
| shipper_country | String | 发货人国家 |
| **收货人(Consignee)** | | |
| consignee_id | String | 收货人ID |
| consignee_name | String | 收货人名称 |
| consignee_address_1 | String | 收货人地址1 |
| consignee_address_2 | String | 收货人地址2 |
| consignee_address_3 | String | 收货人地址3 |
| consignee_address_4 | String | 收货人地址4 |
| consignee_phone | String | 收货人电话 |
| consignee_email | String | 收货人邮箱 |
| consignee_city_code | String | 收货人城市代码 |
| consignee_city | String | 收货人城市 |
| consignee_state | String | 收货人州/省 |
| consignee_zipcode | String | 收货人邮编 |
| consignee_country_code | String | 收货人国家代码 |
| consignee_country | String | 收货人国家 |
| **通知方(Notify Party)** | | |
| notify_party_id | String | 通知方ID |
| notify_party_name | String | 通知方名称 |
| notify_party_address_1 | String | 通知方地址1 |
| notify_party_address_2 | String | 通知方地址2 |
| notify_party_address_3 | String | 通知方地址3 |
| notify_party_address_4 | String | 通知方地址4 |
| notify_party_phone | String | 通知方电话 |
| notify_party_email | String | 通知方邮箱 |
| notify_party_city_code | String | 通知方城市代码 |
| notify_party_city | String | 通知方城市 |
| notify_party_state | String | 通知方州/省 |
| notify_party_zipcode | String | 通知方邮编 |
| notify_party_country_code | String | 通知方国家代码 |
| notify_party_country | String | 通知方国家 |

### 5. 运输路线信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| departure_airport | String | 出发机场代码 |
| departure_airport_ctry | String | 出发机场国家 |
| departure_airport_name | String | 出发机场名称 |
| destination_airport | String | 目的地机场代码 |
| destination_airport_ctry | String | 目的地机场国家 |
| destination_airport_name | String | 目的地机场名称 |
| origin_station | String | 始发站 |
| destination_station | String | 目的站 |
| from_station | String | 来自站点 |
| eta_date | String | 预计到达日期 |
| eta_time | String | 预计到达时间 |
| etd_date | String | 预计起飞日期 |
| etd_time | String | 预计起飞时间 |
| ata_date | String | 实际到达日期 |
| ata_time | String | 实际到达时间 |
| port_of_discharge | String | 卸货港 |
| port_of_discharge_ctry | String | 卸货港国家 |
| port_of_discharge_name | String | 卸货港名称 |
| port_of_entry | String | 入境港 |
| port_of_entry_name | String | 入境港名称 |
| place_of_receipt | String | 收货地点 |
| place_of_receipt_ctry | String | 收货地点国家 |
| place_of_receipt_name | String | 收货地点名称 |
| place_of_dilivery | String | 交货地点 |
| delivery_to | String | 交货至 |
| delivery_to_name | String | 交货至名称 |
| pickup_from | String | 取货自 |
| pickup_from_name | String | 取货自名称 |
| x_delivery_to_country_code | String | 交货至国家代码 |
| x_pickup_from_country_code | String | 取货自国家代码 |
| x_port_of_discharge_state | String | 卸货港州/省 |
| x_port_of_entry_state | String | 入境港州/省 |
| x_origin_station_country_code | String | 始发站国家代码 |
| x_destination_station_country_code | String | 目的站国家代码 |

### 6. 货物信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| description_of_goods | String | 货物描述 |
| name_of_goods | String | 货物名称 |
| marks | String | 标记 |
| pcs | Integer | 件数 |
| pcs_uom | String | 件数单位 |
| qty | Integer | 数量 |
| qty_uom | String | 数量单位 |
| total_qty | Integer | 总数量 |
| total_qty_uom | String | 总数量单位 |
| weight_valuation | String | 重量估值 |
| customs_value | String | 海关价值 |
| carriage_value | String | 运费价值 |
| item | String | 货物项目 |
| minimum | String | 最低费用 |
| terms | String | 条款 |
| export_reference | String | 出口参考 |
| project_no | String | 项目号 |
| project_description | String | 项目描述 |
| trade_terms | String | 贸易条款 |
| ex_im | String | 进出口标志 |
| source_user | String | 来源用户 |
| statistics_year | Integer | 统计年份 |
| week | Integer | 周 |

### 7. 重量体积信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| kgs | BigDecimal | 千克 |
| lbs | BigDecimal | 磅 |
| lbs_kgs | String | 磅/千克标志 |
| cbm | BigDecimal | 立方米 |
| cbi | BigDecimal | 立方英寸 |
| volume | BigDecimal | 体积 |
| volume_cubic_feet | BigDecimal | 立方英尺体积 |
| chrgwt | BigDecimal | 计费重量 |
| chrgwt_cc | BigDecimal | 计费重量(公斤) |
| chrgwt_lbs | BigDecimal | 计费重量(磅) |
| chrgwt_pp | BigDecimal | 计费重量(磅) |
| dim_weight | BigDecimal | 体积重量 |
| dim_factor | BigDecimal | 尺寸系数 |
| in_cm_ft | String | 英寸/厘米/英尺标志 |

### 8. 费用信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| currency_cc | String | 货币代码 |
| currency_pp | String | 货币符号 |
| total | BigDecimal | 总金额 |
| rate | BigDecimal | 费率 |
| unit_price | BigDecimal | 单价 |
| other_charges | String | 其他费用 |
| sel_currency_cc | String | 销售货币代码 |
| sel_currency_pp | String | 销售货币符号 |
| unit_cc | String | 单位代码 |
| unit_pp | String | 单位符号 |

### 9. 其他业务信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| sales_rep | String | 销售代表 |
| location_type | String | 位置类型 |
| h_setby_system | Boolean | 分运单系统设置标志 |
| m_setby_system | Boolean | 主运单系统设置标志 |
| rc | Integer | 费率代码 |
| edi_other_station | String | EDI其他站点 |
| origin_of_cargo | String | 货物原产地 |
| origin_of_cargo_name | String | 货物原产地名称 |
| destination_1 | String | 目的地1 |
| destination_2 | String | 目的地2 |
| destination_3 | String | 目的地3 |
| destination_4 | String | 目的地4 |
| dest_op | String | 目的地操作 |
| final_destination | String | 最终目的地 |
| final_destination_ctry | String | 最终目的地国家 |
| final_destination_name | String | 最终目的地名称 |
| flight_no_1 | String | 航班号1 |
| flight_no_2 | String | 航班号2 |
| flight_no_3 | String | 航班号3 |
| flight_no_4 | String | 航班号4 |
| flight_date_1 | String | 航班日期1 |
| flight_date_2 | String | 航班日期2 |
| flight_date_3 | String | 航班日期3 |
| flight_date_4 | String | 航班日期4 |
| cargo_receive_date | String | 货物接收日期 |
| cargo_receive_time | String | 货物接收时间 |
| mawb_name | String | 主运单名称 |
| k3_house_unid | String | K3分运单唯一标识 |
| k3_master_unid | String | K3主运单唯一标识 |

### 10. 系统信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| create_time | String | 创建时间 |
| create_user | String | 创建用户 |
| modify_time | String | 修改时间 |
| edi_created_by | String | EDI创建人 |
| edi_created_by_email | String | EDI创建人邮箱 |
| edi_last_by | String | EDI最后修改人 |
| edi_last_by_email | String | EDI最后修改人邮箱 |

## 关联对象

### 1. AirShipmentContainer (容器信息)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| commodity | String | 商品 |
| description | String | 描述 |
| height | BigDecimal | 高度 |
| height_i | BigDecimal | 高度(英寸) |
| in_cm | String | 厘米标志 |
| is_each_item_d | Boolean | 是否每项单独描述 |
| is_each_item_w | Boolean | 是否每项单独称重 |
| is_need_calc | Boolean | 是否需要计算 |
| kgs | BigDecimal | 千克 |
| lbs | BigDecimal | 磅 |
| length | BigDecimal | 长度 |
| length_i | BigDecimal | 长度(英寸) |
| modify_time | String | 修改时间 |
| modify_user | String | 修改用户 |
| pallet_id | String | 托盘ID |
| perishable_name | String | 易腐品名称 |
| qty | Integer | 数量 |
| sch_b | String | B类计划 |
| serial_no | String | 序列号 |
| total_value | Integer | 总价值 |
| uom | String | 单位 |
| volume | BigDecimal | 体积 |
| width | BigDecimal | 宽度 |
| width_i | BigDecimal | 宽度(英寸) |

### 2. AirShipmentReference (参考信息)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| ref_code | String | 参考代码 |
| ref_value | String | 参考值 |
| remark | String | 备注 |
| serial_no | String | 序列号 |

### 3. AirShipmentExtend (扩展信息)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| customer_code | String | 客户代码 |
| customer_name | String | 客户名称 |
| commodity_code | String | 商品代码 |
| commodity_description | String | 商品描述 |
| service_level | String | 服务级别 |
| service_type | String | 服务类型 |
| coloader | String | 联运商 |
| serial_no | String | 序列号 |

### 4. AirShipmentMilestone (里程碑信息)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| serial_no | String | 序列号 |
| stage_code | String | 阶段代码 |
| code | String | 事件代码 |
| description | String | 描述 |
| act_date | String | 实际日期 |
| act_time | String | 实际时间 |
| est_date | String | 预计日期 |
| est_time | String | 预计时间 |
| create_by | String | 创建人 |
| create_date | String | 创建日期 |
| update_by | String | 更新人 |
| update_date | String | 更新日期 |
| timezone | String | 时区 |
| is_send | Boolean | 是否已发送 |
| remark | String | 备注 |
| reason_code | String | 原因代码 |
| reason_description | String | 原因描述 |
| action_time | String | 操作时间 |
| is_act_broadcast | Boolean | 是否已广播实际时间 |
| is_est_broadcast | Boolean | 是否已广播预计时间 |
| is_no_edi | Boolean | 是否不EDI |
| act_update_by | String | 实际时间更新人 |
| act_update_date | String | 实际时间更新日期 |
| est_update_by | String | 预计时间更新人 |
| est_update_date | String | 预计时间更新日期 |
| sync_date | String | 同步日期 |
| changed_type | String | 变更类型 |

### 5. AirRate (费率信息)

对应数据库表 `air_rate`。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | Integer | 主键ID |
| serial_no | String | 序列号 |
| code | String | 费率代码 |
| description | String | 费率描述 |
| amount | BigDecimal | 金额 |
| currency | String | 货币 |
| quantity | BigDecimal | 数量 |
| rate_type | String | 费率类型 |
| ex_rate | BigDecimal | 汇率 |
| vat_amount | BigDecimal | 增值税金额 |
| invoice_no | String | 发票号 |
| invoice_date | String | 发票日期 |
| from_station | String | 来源站点 |
| customer_code | String | 客户代码 |
| customer_description | String | 客户描述 |
| client_id | String | 客户ID |
| client_name | String | 客户名称 |
| client_address_1 | String | 客户地址1 |
| client_address_2 | String | 客户地址2 |
| client_city | String | 客户城市 |
| client_state | String | 客户州/省 |
| client_zipcode | String | 客户邮编 |
| client_country | String | 客户国家 |
| bill_to_account | String | 账单账户 |

### 6. AirShipmentDoc (文档信息) - 已过时

> **已废弃** (`@Deprecated since="0.0.52"`)，请使用 AirShipmentDocUpload。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| serial_no | String | 序列号 |
| doc_type | String | 文档类型 |
| doc_name | String | 文档名称 |
| doc_content | String | 文档内容 |
| doc_size | String | 文档大小 |

### 7. AirShipmentDocUpload (文档上传信息)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | Long | 主键ID |
| serial_no | String | 序列号 |
| bol | String | 提单号 |
| file_path | String | 文件路径 |
| file_name | String | 文件名 |
| doc_type | String | 文档类型 |
| upload_date | String | 上传日期 |
| upload_by | String | 上传人 |
| document_id | String | 文档ID |
| download_url | String | 下载链接 |
| file_size | Integer | 文件大小 |
| file_content_base64 | String | Base64文件内容 |
| doc_id | String | 文档标识 |
| from_station | String | 来源站点 |
| source_filename | String | 源文件名 |

## 数据关系
- AirShipment 是主实体，包含多个容器(AirShipmentContainer)
- AirShipment 包含多个参考信息(AirShipmentReference)
- AirShipment 包含一个扩展信息对象(AirShipmentExtend)
- AirShipment 包含多个里程碑事件(AirShipmentMilestone)
- AirShipment 包含多个费率明细(AirRate)
- AirShipment 包含多个文档上传记录(AirShipmentDocUpload)

## 应用场景
AirShipment 类主要用于空运业务系统的数据建模，支持空运货物的全程跟踪、信息管理和业务处理。通过与其他关联类的配合，可以实现对空运货物的全方位管理和监控。

## 阅读规则
对于AirShipment各对像，在Mapping文档中的理解原则：
- air 应理解为 airshipment，表示整个集合对像。示例：air.ata_date 应理解为 airshipment.ata_date 。
- container 应理解为 airshipment的container集合中的AirShipmentContainer对像，表示单个容器信息，container在airshipment中是一个集合。
- air_reference 应理解为 airshipment的air_reference集合中的AirShipmentReference对像，表示单个参考信息，air_reference在airshipment中是一个集合。
- air_extend 应理解为 airshipment的air_extend 一个AirShipmentExtend对像，表示单个扩展信息。
- air_milestone 应理解为 airshipment的air_milestone集合中的AirShipmentMilestone对像，表示单个里程碑信息，air_milestone在airshipment中是一个集合。
- air_rate 应理解为 airshipment的air_rate集合中的AirRate对像，表示单个费用信息，air_rate在airshipment中是一个集合。
- air_doc_upload 应理解为 airshipment的air_doc_upload集合中的AirShipmentDocUpload对像，表示单个文档上传信息，air_doc_upload在airshipment中是一个集合。
- air_doc 应理解为 airshipment的air_doc集合中的AirShipmentDoc对像，表示单个文档信息，air_doc在airshipment中是一个集合。