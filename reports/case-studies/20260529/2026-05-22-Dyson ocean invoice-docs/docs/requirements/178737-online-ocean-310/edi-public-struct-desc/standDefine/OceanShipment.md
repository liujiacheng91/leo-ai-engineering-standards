# Online Ocean - OceanShipment 及相关类说明文档

## 概述

`OceanShipment` 是 Online Ocean 场景下的核心数据结构。由于该业务在数据结构层不区分 Booking 与 Shipment，因此使用单一结构体承载订单/提单、航线、参与方、箱信息、里程碑、附件、费用等信息。

## 类结构图

```text
OceanShipment
├─ (大量基础字段：String/Long)
├─ ocean_ls : List<OceanLs>
├─ positions : List<OceanPositions>
├─ container_no : List<OceanShipmentContainer>
│  └─ oc_container_item : List<OceanShipmentContainerItem>
├─ oc_container_dest : List<OceanShipmentContainerDest>
├─ ocean_reference : List<OceanReference>
├─ ocean_extend : OceanExtend
├─ ocean_milestone : List<OceanMilestone>
├─ ra_online_container_status : List<RaOnlineContainerStatus>
├─ ocean_booking_container : List<OceanBookingContainer>
│  └─ ocean_booking_container_item : List<OceanBookingContainerItem>
├─ ra_online_doc_upload : List<RaOnlineDocUpload>
├─ ocean_ams : OceanAms
├─ edi_change_logs : List<OceanEdiChangeLogs>
├─ ocean_notes : List<OceanNotes>
├─ oc_rate : List<OceanRate>
└─ response : OceanShipmentResponse
```

## 结构关系

- 一对多：`OceanShipment.ocean_ls` → `OceanLs`
- 一对多：`OceanShipment.positions` → `OceanPositions`
- 一对多：`OceanShipment.container_no` → `OceanShipmentContainer`
- 一对多：`OceanShipmentContainer.oc_container_item` → `OceanShipmentContainerItem`
- 一对多：`OceanShipment.oc_container_dest` → `OceanShipmentContainerDest`
- 一对多：`OceanShipment.ocean_reference` → `OceanReference`
- 一对一：`OceanShipment.ocean_extend` → `OceanExtend`
- 一对多：`OceanShipment.ocean_milestone` → `OceanMilestone`
- 一对多：`OceanShipment.ra_online_container_status` → `RaOnlineContainerStatus`
- 一对多：`OceanShipment.ocean_booking_container` → `OceanBookingContainer`
- 一对多：`OceanBookingContainer.ocean_booking_container_item` → `OceanBookingContainerItem`
- 一对多：`OceanShipment.ra_online_doc_upload` → `RaOnlineDocUpload`
- 一对一：`OceanShipment.ocean_ams` → `OceanAms`
- 一对多：`OceanShipment.edi_change_logs` → `OceanEdiChangeLogs`
- 一对多：`OceanShipment.ocean_notes` → `OceanNotes`
- 一对多：`OceanShipment.oc_rate` → `OceanRate`
- 一对一：`OceanShipment.response` → `OceanShipmentResponse`

---

## 1. OceanShipment

### 子对象字段（重点）

| 字段 | 类型 | 说明 |
|---|---|---|
| ocean_ls | List\<OceanLs> | 物流计划/提派信息列表 |
| positions | List\<OceanPositions> | 轨迹/定位坐标列表 |
| container_no | List\<OceanShipmentContainer> | 运输箱信息列表（含箱内明细） |
| oc_container_dest | List\<OceanShipmentContainerDest> | 箱的目的地交付/预约信息列表 |
| ocean_reference | List\<OceanReference> | 参考号列表 |
| ocean_extend | OceanExtend | 扩展信息（客户、货物、截关等） |
| ocean_milestone | List\<OceanMilestone> | 里程碑（节点/事件）列表 |
| ra_online_container_status | List\<RaOnlineContainerStatus> | 箱动态/事件状态列表 |
| ocean_booking_container | List\<OceanBookingContainer> | 订舱层箱/货物信息列表 |
| ra_online_doc_upload | List\<RaOnlineDocUpload> | 文档/附件上传记录列表 |
| ocean_ams | OceanAms | AMS 发送信息 |
| edi_change_logs | List\<OceanEdiChangeLogs> | EDI 变更日志列表 |
| response | OceanShipmentResponse | 接口处理结果/回执 |
| ocean_notes | List\<OceanNotes> | 备注信息列表 |
| oc_rate | List\<OceanRate> | 费用/费率信息列表 |

### 基础字段（全量）

| 字段 | 类型 | 说明 |
|---|---|---|
| scene_code | String | string - max(30) |
| id | Long | int4 |
| bol_type | String | string - max(30) |
| cargo_control_no | String | string - max(30) |
| consignee_id | String | string - max(30) |
| consignee_name | String | string - max(100) |
| consignee_address_1 | String | string - max(100) |
| consignee_address_2 | String | string - max(100) |
| consignee_address_3 | String | string - max(100) |
| consignee_address_4 | String | string - max(100) |
| consignee_phone | String | string - max(50) |
| consignee_email | String | string |
| consignee_city_code | String | string - max(50) |
| consignee_city | String | string - max(50) |
| consignee_state | String | string - max(30) |
| consignee_zipcode | String | string - max(60) |
| consignee_country_code | String | string - max(80) |
| consignee_country | String | string - max(80) |
| contract | String | string - max(150) |
| created_time | String | timestamp without time zone |
| ex_im | String | string - max(10) |
| f_eta | String | date |
| f_etd | String | date |
| file_date | String | timestamp without time zone |
| file_no | String | string - max(30) |
| final_desination | String | string - max(30) |
| final_desination_ctry | String | string - max(10) |
| final_desination_exp | String | string - max(50) |
| fport_of_discharge | String | character varying(30) |
| fport_of_discharge_ctry | String | string - max(10) |
| fport_of_discharge_exp | String | string - max(50) |
| fport_of_loading | String | string - max(30) |
| fport_of_loading_ctry | String | string - max(10) |
| fport_of_loading_exp | String | string - max(50) |
| f_vessel | String | string - max(50) |
| f_voyage | String | string - max(30) |
| h_bol | String | string - max(30) |
| k3_house_unid | String | string - max(40) |
| k3_master_unid | String | string - max(40) |
| last_user | String | string - max(50) |
| manifest_type | String | string - max(15) |
| m_bol | String | string - max(30) |
| m_carrier | String | string - max(30) |
| origin_input_eta | String | date |
| m_eta | String | date |
| final_eta | String | date |
| m_etd | String | date |
| modify_time | String | timestamp without time zone |
| mport_of_loading | String | character varying(30) |
| mport_of_discharge | String | string - max(30) |
| mport_of_discharge_ctry | String | "string- max(10)" |
| mport_of_discharge_exp | String | string - max(50) |
| m_voyage | String | string - max(30) |
| notify_party_id | String | string - max(30) |
| notify_party_name | String | string - max(100) |
| notify_party_address_1 | String | string - max(100) |
| notify_party_address_2 | String | string - max(100) |
| notify_party_address_3 | String | string - max(100) |
| notify_party_address_4 | String | string - max(100) |
| notify_party_phone | String | string - max(50) |
| notify_party_email | String | string |
| notify_party_city_code | String | string - max(50) |
| notify_party_city | String | string - max(50) |
| notify_party_state | String | string - max(30) |
| notify_party_zipcode | String | string - max(60) |
| notify_party_country_code | String | string - max(50) |
| notify_party_country | String | string - max(80) |
| origin_station | String | string - max(30) |
| place_of_delivery | String | string - max(30) |
| place_of_delivery_ctry | String | string - max(10) |
| place_of_delivery_exp | String | string - max(50) |
| place_of_receipt | String | string - max(30) |
| place_of_receipt_ctry | String | string - max(50) |
| place_of_receipt_exp | String | string - max(50) |
| project_no | String | string - max(30) |
| serial_no | String | string - max(40) |
| shipper_id | String | string - max(30) |
| shipper_name | String | string - max(100) |
| shipper_address_1 | String | string - max(100) |
| shipper_address_2 | String | string - max(100) |
| shipper_address_3 | String | string - max(100) |
| shipper_address_4 | String | string - max(100) |
| shipper_phone | String | string - max(50) |
| shipper_email | String | string |
| shipper_city_code | String | string - max(50) |
| shipper_city | String | string - max(50) |
| shipper_state | String | string - max(30) |
| shipper_zipcode | String | string - max(60) |
| shipper_country_code | String | string - max(80) |
| shipper_country | String | string - max(80) |
| source_user | String | string - max(50) |
| status | String | string - max(30) |
| from_station | String | string - max(30) |
| destination_station | String | string - max(30) |
| service | String | string - max(30) |
| m_vessel | String | string - max(50) |
| booking_no | String | string - max(30) |
| created_by | String | character varying(50) |
| job_no | String | character varying(30) |
| atd | String | date |
| ata | String | date |
| f_carrier | String | character varying(30) |
| port_of_transshipment | String | character varying(15) |
| port_of_transshipment_name | String | character varying(50) |
| delivery_to_id | String | string - max(30) |
| delivery_to_name | String | string - max(100) |
| delivery_to_address_1 | String | string - max(100) |
| delivery_to_address_2 | String | string - max(100) |
| delivery_to_address_3 | String | string - max(100) |
| delivery_to_address_4 | String | string - max(100) |
| delivery_to_phone | String | string - max(50) |
| delivery_to_email | String | string |
| delivery_to_city | String | string - max(50) |
| delivery_to_state | String | string - max(30) |
| delivery_to_zipcode | String | string - max(60) |
| delivery_to_country | String | string - max(80) |
| carrier_booking | String | string - max(100) |
| vsl_code | String | string - max(100) |
| m_flag | String | string - max(100) |
| f_flag | String | string - max(100) |
| manifest_type_2 | String | string - max(100) (原 manifest_type 重复，这里用 manifest_type_2 表示第二个) |
| is_vessel_direct | String | string - max(100) |
| on_board_date | String | date |
| terms | String | string - max(30) |
| description | String | string |
| marks | String | string |
| x_port_of_discharge_state | String | character varying(30) |
| x_port_of_loading_state | String | character varying(30) |
| x_port_of_receipt_state | String | character varying(30) |
| x_port_of_delivery_state | String | character varying(30) |
| ams_port_of_discharge | String |  |
| ams_port_of_discharge_ctry | String |  |
| ams_port_of_discharge_exp | String |  |
| si_place_of_delivery | String |  |
| si_place_of_delivery_ctry | String | 注意：原始字段名中没有下划线 |
| si_place_of_delivery_exp | String |  |
| si_cutoff_date | String |  |
| si_cutoff_time | String |  |
| si_port_of_loading | String |  |
| si_port_of_loading_ctry | String |  |
| si_port_of_loading_exp | String |  |
| ams_voyage | String |  |
| eta_dest | String |  |
| so_no | String |  |
| sales_terms | String |  |
| obl_change_date | String |  |
| x_origin_timezone | String |  |
| x_destination_timezone | String |  |
| x_m_carrier_name | String | string - max(150) |
| f_imo | String |  |
| m_imo | String |  |

---

## 相关类结构

### OceanShipmentContainer

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | int4 |
| cbm | BigDecimal | numeric |
| cft | BigDecimal | numeric |
| ctnr | String | string - max(15) |
| cvalue | Integer | integer |
| description | String | string |
| grs_kgs | BigDecimal | numeric |
| grs_lbs | BigDecimal | numeric |
| invoice_no | String | string |
| marks | String | string |
| net_kgs | BigDecimal | numeric |
| net_lbs | BigDecimal | numeric |
| po_no | String | string |
| qty | Integer | integer |
| seal_no | String | string - max(20) |
| seal_no_2 | String | string - max(20) |
| serial_no | String | string - max(40) |
| service | String | string - max(30) |
| size | String | string - max(10) |
| unit | String | string - max(20) |
| is_changed | Boolean | boolean- true/false |
| pickup_date | String |  |
| pickup_time | String |  |
| x_tare_wgt | BigDecimal |  |
| lp_no | String |  |
| pickup_no | String |  |
| oc_container_item | List\<OceanShipmentContainerItem> | 箱内货物明细列表 |

### OceanShipmentContainerItem

#### 字段说明

| 字段 | 类型 |
|---|---|
| id | Long |
| from_id | Long |
| from_station | String |
| serial_no | String |
| oc_container_id | Long |
| quantity | Integer |
| unit | String |
| grs_kgs | BigDecimal |
| grs_lbs | BigDecimal |
| net_kgs | BigDecimal |
| net_lbs | BigDecimal |
| vol_cbm | BigDecimal |
| vol_cft | BigDecimal |
| dim_height | BigDecimal |
| dim_width | BigDecimal |
| dim_length | BigDecimal |
| dim_unit | String |
| description | String |
| create_user | String |
| create_date | String |
| modify_user | String |
| modify_date | String |
| grs_unit | String |
| net_unit | String |
| vol_unit | String |
| inner_pcs | Integer |
| inner_pcs_unit | String |
| product_code | String |
| po_no | String |
| sku_no | String |
| sn | String |
| edi_container_serial_no | String |
| marks | String |
| un_numbers | String |
| dg_description | String |
| dg_class | String |
| is_auto | Boolean |
| sub_sn | String |
| sub_id | Long |
| hs_code | String |
| factory_name | String |
| cargo_ready_date | String |
| item_no | String |

### OceanShipmentContainerDest

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | int4 |
| serial_no | String | character varying(40) |
| ctnr | String | string- max(15) |
| actual_delivery_date | String | date yyyy-MM-dd |
| actual_delivery_time | String | HH:mm |
| appt_date | String | date yyyy-MM-dd |
| appt_time | String | HH:mm |

### OceanReference

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| ref_code | String | string - max(50) |
| ref_value | String | string - max(512) |
| remark | String | string |
| serial_no | String | string - max(40) |

### OceanExtend

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| customer_code | String | string - max(30) |
| customer_name | String | string - max(150) |
| loadterm | String | string - max(10) |
| consol_type | String | string - max(30) |
| sales_type | String | string - max(30) |
| commodity_code | String | string - max(30) |
| commodity_description | String | string - max(100) |
| coloader | String | string - max(10) |
| serial_no | String | string - max(40) |
| booking_remark | String | text |
| order_remark | String | text |
| cargo_ready_date | String | date |
| est_cargo_delivery_date | String | date |
| cy_closing_date | String |  |
| cy_closing_time | String |  |
| cutoff_date | String |  |
| cutoff_time | String |  |

### OceanMilestone

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| serial_no | String | character varying(40) |
| stage_code | String | character varying(20) |
| code | String | character varying(10) |
| description | String | character varying(200) |
| act_date | String | date |
| act_time | String | character varying(5) |
| est_date | String | date |
| est_time | String | character varying(5) |
| create_by | String | character varying(80) |
| create_date | String | timestamp without time zone |
| update_by | String | character varying(80) |
| update_date | String | timestamp without time zone |
| timezone | String | character varying(50) |
| is_send | Boolean | boolean |
| remark | String | text |
| reason_code | String | character varying(50) |
| reason_description | String | character varying(100) |
| action_time | String | timestamp with time zone |
| is_act_broadcast | Boolean | boolean |
| is_est_broadcast | Boolean | boolean |
| is_no_edi | Boolean | boolean |
| act_update_by | String | character varying(80) |
| act_update_date | String | timestamp without time zone |
| est_update_by | String | character varying(80) |
| est_update_date | String | timestamp without time zone |
| sync_date | String | timestamp with time zone |
| changed_type | String | act,est |

### RaOnlineContainerStatus

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | int4 |
| status_id | Integer | int4 |
| m_bol | String | character varying(80) |
| h_bol | String | character varying(80) |
| container_no | String | character varying(80) |
| event_base | String | character varying(80) |
| event_date | String | date |
| event_time | String | character varying(5) |
| event_timezone | String | character varying(50) |
| event_code | String | character varying(80) |
| event_city | String | character varying(80) |
| insert_date | String | character varying(80) |
| is_changed | Boolean | boolean- true/false |
| event_countrycode | String | character varying(10) |
| event_country | String | character varying(100) |
| event_type | String | character varying(20) |
| x_description | String | character varying(30) |
| vessel | String | character varying(30) |
| voyage_number | String | character varying(30) |
| eq_initial | String | character varying(20) |
| bn | String | character varying(20) |
| eta | String | character varying(10) |
| estimated_date | String | date |
| estimated_time | String | character varying(5) |
| estimated_date_timezone | String |  |

### OceanBookingContainer

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| cbm | BigDecimal | numeric(30, 3) |
| description | String | string |
| is_lcl | Boolean | boolean |
| kgs | BigDecimal | numeric(30, 3) |
| marks | String | string |
| pono | String | character varying(30) |
| qty | Integer | int4 |
| serial_no | String | character varying(40) |
| size | String | character varying(40) |
| unit | String | character varying(20) |
| cvalue | Integer | int4 |
| sch_b | String | character varying(120) |
| lp_no | String | character varying(30) |
| ocean_booking_container_item | List\<OceanBookingContainerItem> | 订舱箱内明细列表 |

### OceanBookingContainerItem

#### 字段说明

| 字段 | 类型 |
|---|---|
| id | Long |
| from_id | Long |
| serial_no | String |
| oc_container_id | Long |
| quantity | Integer |
| unit | String |
| grs_kgs | BigDecimal |
| grs_lbs | BigDecimal |
| net_kgs | BigDecimal |
| net_lbs | BigDecimal |
| vol_cbm | BigDecimal |
| vol_cft | BigDecimal |
| dim_height | BigDecimal |
| dim_width | BigDecimal |
| dim_length | BigDecimal |
| dim_unit | String |
| description | String |
| create_user | String |
| create_date | String |
| modify_user | String |
| modify_date | String |
| grs_unit | String |
| net_unit | String |
| vol_unit | String |
| inner_pcs | Integer |
| inner_pcs_unit | String |
| product_code | String |
| po_no | String |
| sku_no | String |
| sn | String |
| edi_container_serial_no | String |
| marks | String |
| un_numbers | String |
| dg_description | String |
| dg_class | String |
| is_auto | Boolean |
| sub_sn | String |
| sub_id | Long |
| hs_code | String |
| factory_name | String |
| cargo_ready_date | String |
| item_no | String |

### RaOnlineDocUpload

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | int4 |
| serial_no | String | character varying(40) |
| bol | String | character varying(150) |
| file_path | String | character varying(150) |
| file_name | String | character varying(150) |
| doc_type | String | character varying(30) |
| upload_date | String | datetime |
| upload_by | String | character varying(150) |
| document_id | String | character varying(150) |
| download_url | String | character varying(150) |
| file_size | Integer | int4 |
| file_content_base64 | String | base64 string |
| doc_id | String |  |
| from_station | String | character varying(20) |
| source_filename | String | character varying(150) |

### OceanAms

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | int4 |
| serial_no | String | character varying(40) |
| send_time | String | timestamp without time zone |

### OceanEdiChangeLogs

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | int4 |
| project_no | String | string |
| log_time | String | datetime |
| action_type | String | string |
| ref_code | String | string |
| ref_value | String | string |
| table_name | String | string |
| serial_no | String | ocean.serial_no |
| pk_id | Long | int4 |

### OceanShipmentResponse

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| order_status | String | 处理状态 |
| processed_time | String | 处理时间 |
| error_code | String | 错误码 |
| error_message | String | 错误信息 |

### OceanNotes

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | int4 |
| serial_no | String | character varying(40) |
| note_type | String | character varying(80) |
| type_code | String | character varying(20) |
| notes | String | text |
| create_by | String | character varying(30) |
| modify_by | String | character varying(30) |
| create_time | String | timestamp |
| modify_time | String | timestamp |
| reference_no | String | character varying(40) |

### OceanRate

#### 字段说明

| 字段 | 类型 | 说明 |
|---|---|---|
| id | Long | integer(32) |
| file_no | String | character varying(20) |
| serial_no | String | character varying(40) |
| release_status | String | character varying(10) |
| post_status | String | character varying(10) |
| rate_type | String | character varying(10) |
| ar_ap | String | character varying(10) |
| client_id | String | character varying(15) |
| client_name | String | character varying(100) |
| code | String | character varying(20) |
| description | String | character varying(150) |
| invoice_no | String | character varying(50) |
| customer_reference | String | character varying(50) |
| our_reference_no | String | character varying(50) |
| invoice_date | String | timestamp without time zone |
| unit | String | character varying(50) |
| quantity | BigDecimal | numeric(30,4) |
| unit_price | BigDecimal | numeric(30,4) |
| amount | BigDecimal | numeric(30,4) |
| terms | String | character varying(20) |
| currency | String | character varying(10) |
| ex_rate | BigDecimal | numeric(30,8) |
| payment_terms | String | character varying(20) |
| sales_rep | String | character varying(20) |
| active | Boolean | boolean |
| h_bol | String | character varying(30) |
| carrier | String | character varying(20) |
| fee_type | Long | integer(32) |
| op_rate_code | String | character varying(20) |
| tax_invoice_no | String | character varying(50) |
| tax_invoice_date | String | timestamp without time zone |
| is_vat | Boolean | boolean |
| is_tax | Boolean | boolean |
| origin_amount | BigDecimal | numeric(30,4) |
| basic_amount | BigDecimal | numeric(30,4) |
| print_currency | String | character varying(10) |
| print_ex_rate | BigDecimal | numeric(30,8) |
| container_no | String | character varying(50) |
| vat_type | String | character varying(20) |
| vat_amount | BigDecimal | numeric(20,4) |
| basic_vat_amount | BigDecimal | numeric(20,4) |
| invoice_type | String | character varying(30) |
| from_station | String | character varying(20) |
| container_size | String | character varying(10) |
| x_client_address_1 | String | string - max(55) |
| x_client_address_2 | String | string - max(55) |
| x_client_city | String | string |
| x_client_country | String | string |
| x_client_state | String | string |
| x_client_zipcode | String | string |
| x_customer_code | String | 客户的 code |
| x_customer_description | String | 客户的描述 |
