# AirBooking 及相关类说明文档

## 概述

`AirBooking` 是航空预订实例类，用于处理航空运输预订业务。该类位于 `com.pobing.edi.standard.structure.online.airbooking` 包中，由 wenhz 于 2025-10-15 创建。

## 类结构图

```
AirBooking
├── AirBookingContainer
├── AirBookingExtend
├── AirBookingMilestone
├── AirBookingNotes
└── AirBookingReference
```

---

## 结构关系

AirBooking 作为空运订舱业务的核心实体，与多个关联对象形成完整的数据结构关系：
- **一对多关系**：AirBooking 包含多个 AirBookingContainer（集装箱信息），用于记录货物的不同包装和容器详情
- **一对多关系**：AirBooking 包含多个 AirBookingReference（参考信息），用于记录与订舱相关的各种参考编号
- **一对一关系**：AirBooking 包含一个 AirBookingExtend（扩展信息），用于存储额外的业务属性
- **一对多关系**：AirBooking 包含多个 AirBookingMilestone（里程碑信息），记录订舱过程中的关键事件
- **一对多关系**：AirBooking 包含多个 AirBookingNotes（备注信息），用于记录订舱相关的各类备注内容

这种结构设计使得 AirBooking 既能作为独立实体使用，又能通过关联对象实现更复杂的业务场景支持，满足空运订舱业务中信息管理和业务处理的需求。

## 1. AirBooking

`AirBooking` 类是整个航空预订数据结构的核心，包含了运输过程中的各种信息，如发货人、收货人、通知方、运输细节、机场信息、航班信息等。

### 基本信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| ex_im | String | 进出口标识 |
| status | String | 状态 |
| location_type | String | 位置类型 |
| terms | String | 贸易条款 |
| serial_no | String | 序列号 |
| quote_no | String | 报价号 |
| file_no | String | 文件号 |
| file_date | String | 文件日期 |
| billto_party | String | 付款方 |
| iscts | boolean | 是否CTS |
| cts_stauts | String | CTS状态 |
| booking_no | String | 预订号 |
| is_booking_no_system_gen | Boolean | 预订号是否系统生成 |
| project_no | String | 项目号 |
| project_description | String | 项目描述 |
| job_no | String | 作业号 |
| job_period | String | 作业周期 |
| create_time | String | 创建时间 |
| create_user | String | 创建用户 |
| modify_time | String | 修改时间 |
| last_user | String | 最后用户 |
| lock_user | String | 锁定用户 |
| local_lock | Boolean | 本地锁定 |
| fl_lock | Boolean | FL锁定 |
| is_sales_lock | Boolean | 销售锁定 |
| is_op_lock | Boolean | 操作锁定 |

### 发货人信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| shipper | String | 发货人 |
| shipper_exp | String | 发货人扩展 |
| shipper_name | String | 发货人名称 |
| manufacture | String | 制造商 |
| manufacture_exp | String | 制造商扩展 |

### 收货人信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| consignee | String | 收货人 |
| consignee_exp | String | 收货人扩展 |
| consignee_name | String | 收货人名称 |

### 通知方信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| notify_party | String | 通知方 |
| notify_party_exp | String | 通知方扩展 |

### 其他方信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| forwarding_agent | String | 货运代理 |
| forwarding_agent_exp | String | 货运代理扩展 |
| principal | String | 委托方 |

### 提单信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| awb_type | String | 空运单类型 |
| mawb | String | 主空运单号 |
| mawb_name | String | 主空运单名称 |
| mawb_type | String | 主空运单类型 |
| hawb | String | 分空运单号 |
| h_setby_system | Boolean | 分空运单是否系统设置 |
| m_setby_system | Boolean | 主空运单是否系统设置 |
| f_setby_system | Boolean | 前缀是否系统设置 |
| manifest_hbol | String | 载货清单提单号 |
| export_reference | String | 出口参考号 |
| old_hawb | String | 旧分空运单号 |
| old_mawb | String | 旧主空运单号 |
| old_mawb_name | String | 旧主空运单名称 |
| old_file_no | String | 旧文件号 |

### 机场与地点信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| origin_station | String | 起始站点 |
| destination_station | String | 目的地站点 |
| origin_of_cargo | String | 货物来源地 |
| origin_of_cargo_name | String | 货物来源地名称 |
| place_of_receipt | String | 收货地点 |
| place_of_receipt_name | String | 收货地点名称 |
| place_of_receipt_ctry | String | 收货地点国家 |
| departure_airport | String | 出发机场 |
| departure_airport_name | String | 出发机场名称 |
| departure_airport_ctry | String | 出发机场国家 |
| port_of_discharge | String | 卸货港 |
| port_of_discharge_name | String | 卸货港名称 |
| port_of_discharge_ctry | String | 卸货港国家 |
| destination_airport | String | 目的地机场 |
| destination_airport_name | String | 目的地机场名称 |
| destination_airport_ctry | String | 目的地机场国家 |
| place_of_dilivery | String | 交货地点 |
| place_of_dilivery_name | String | 交货地点名称 |
| place_of_dilivery_ctry | String | 交货地点国家 |
| final_destination | String | 最终目的地 |
| final_destination_name | String | 最终目的地名称 |
| final_destination_ctry | String | 最终目的地国家 |
| port_of_entry | String | 入境港 |
| port_of_entry_name | String | 入境港名称 |
| port_of_entry_ctry | String | 入境港国家 |
| it_port | String | IT港口 |
| it_port_exp | String | IT港口扩展 |
| it_port_ctry | String | IT港口国家 |
| it_date | String | IT日期 |
| it_tacm | String | IT TACM |
| destination_1 | String | 目的地1 |
| destination_1_ctry | String | 目的地1国家 |
| destination_2 | String | 目的地2 |
| destination_2_ctry | String | 目的地2国家 |
| destination_3 | String | 目的地3 |
| destination_3_ctry | String | 目的地3国家 |
| destination_4 | String | 目的地4 |
| destination_4_ctry | String | 目的地4国家 |

### 航班信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| airline_1 | String | 航空公司1 |
| airline_2 | String | 航空公司2 |
| airline_3 | String | 航空公司3 |
| airline_4 | String | 航空公司4 |
| flight_no_1 | String | 航班号1 |
| flight_no_2 | String | 航班号2 |
| flight_no_3 | String | 航班号3 |
| flight_no_4 | String | 航班号4 |
| flight_date_1 | String | 航班日期1 |
| flight_date_2 | String | 航班日期2 |
| flight_date_3 | String | 航班日期3 |
| flight_date_4 | String | 航班日期4 |

### 时间信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| eta_date | String | 预计到达日期 |
| eta_time | String | 预计到达时间 |
| etd_date | String | 预计离港日期 |
| etd_time | String | 预计离港时间 |
| ata_date | String | 实际到达日期 |
| ata_time | String | 实际到达时间 |
| lfd | String | 最后飞行日期 |
| sed_date | String | SED日期 |
| cargo_ready_date | String | 货物准备日期 |
| cargo_ready_time | String | 货物准备时间 |
| cargo_receive_date | String | 货物接收日期 |
| cargo_receive_time | String | 货物接收时间 |
| warehousing_date | String | 入库日期 |
| issue_date | String | 签发日期 |

### 货物信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| consolidation | String | 拼箱 |
| po_no | String | 采购订单号 |
| name_of_goods | String | 货物名称 |
| description_of_goods | String | 货物描述 |
| marks | String | 唛头 |
| awb_body | String | 空运单正文 |
| in_cm_ft | String | 单位（厘米/英尺） |
| volume | BigDecimal | 体积 |
| volume_cubic_feet | BigDecimal | 体积（立方英尺） |
| lbs_kgs | String | 单位（磅/公斤） |
| dim_factor | BigDecimal | 体积因子 |
| dim_weight | BigDecimal | 体积重量 |
| pcs | BigDecimal | 件数 |
| lbs | BigDecimal | 磅 |
| kgs | BigDecimal | 公斤 |
| rc | BigDecimal | RC |
| item | String | 项目 |
| qty | BigDecimal | 数量 |
| other_qty | BigDecimal | 其他数量 |
| total_qty | BigDecimal | 总数量 |
| total_pcs | BigDecimal | 总件数 |
| qty_uom | String | 数量单位 |
| pcs_uom | String | 件数单位 |
| other_qty_uom | String | 其他数量单位 |
| total_qty_uom | String | 总数量单位 |
| total_pcs_uom | String | 总件数单位 |
| doc_qty | BigDecimal | 文档数量 |
| doc_print_qty | BigDecimal | 文档打印数量 |
| cbi | BigDecimal | CBI |
| cbm | BigDecimal | CBM |

### 费用信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| currency | String | 货币 |
| weight_valuation | String | 重量估值 |
| other_charges | String | 其他费用 |
| carriage_value | String | 运费价值 |
| customs_value | String | 海关价值 |
| insurance_amount | String | 保险金额 |
| chrgwt | BigDecimal | 计费重量 |
| rate | BigDecimal | 费率 |
| minimum | String | 最小值 |
| total | BigDecimal | 总计 |
| valuation_charge_pp | BigDecimal | 估值费用（预付） |
| valuation_charge_cc | BigDecimal | 估值费用（到付） |
| tax_pp | BigDecimal | 税费（预付） |
| tax_cc | BigDecimal | 税费（到付） |
| chrgwt_pp | BigDecimal | 计费重量（预付） |
| chrgwt_cc | BigDecimal | 计费重量（到付） |
| chrgwt_lbs | BigDecimal | 计费重量（磅） |
| chrgwt_lbs_pp | BigDecimal | 计费重量（磅，预付） |
| chrgwt_lbs_cc | BigDecimal | 计费重量（磅，到付） |
| rate_pp | BigDecimal | 费率（预付） |
| rate_cc | BigDecimal | 费率（到付） |
| total_pp | BigDecimal | 总计（预付） |
| total_cc | BigDecimal | 总计（到付） |
| ex_total_pp | BigDecimal | 汇总总计（预付） |
| ex_total_cc | BigDecimal | 汇总总计（到付） |
| minimum_pp | String | 最小值（预付） |
| minimum_cc | String | 最小值（到付） |
| unit_pp | String | 单位（预付） |
| unit_cc | String | 单位（到付） |
| ex_rate_pp | BigDecimal | 汇率（预付） |
| ex_rate_cc | BigDecimal | 汇率（到付） |
| currency_pp | String | 货币（预付） |
| currency_cc | String | 货币（到付） |
| sel_currency_pp | String | 选择货币（预付） |
| sel_currency_cc | String | 选择货币（到付） |
| cost_price | BigDecimal | 成本价格 |

### 运输信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| to_carrier_1 | String | 承运人1 |
| to_carrier_2 | String | 承运人2 |
| to_carrier_3 | String | 承运人3 |
| to_carrier_4 | String | 承运人4 |
| by_carrier_1 | String | 承运人1 |
| by_carrier_2 | String | 承运人2 |
| by_carrier_3 | String | 承运人3 |
| by_carrier_4 | String | 承运人4 |
| by_carrier_name_1 | String | 承运人名称1 |
| by_carrier_name_2 | String | 承运人名称2 |
| by_carrier_name_3 | String | 承运人名称3 |
| by_carrier_name_4 | String | 承运人名称4 |
| trucker | String | 卡车司机 |
| trucker_name | String | 卡车司机名称 |
| pickup_from | String | 提货地点 |
| pickup_from_name | String | 提货地点名称 |
| delivery_to | String | 交货地点 |
| delivery_to_name | String | 交货地点名称 |
| cargo_location | String | 货物位置 |
| cargo_location_name | String | 货物位置名称 |
| entry_location | String | 入境地点 |
| entry_location_name | String | 入境地点名称 |
| cargo_release | String | 货物放行 |
| cargo_release_exp | String | 货物放行扩展 |
| cargo_release_name | String | 货物放行名称 |
| driver_name | String | 司机名称 |
| driver_license | String | 司机执照 |

### 处理信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| handing_information_11 | String | 处理信息11 |
| handing_information_12 | String | 处理信息12 |
| handing_information_21 | String | 处理信息21 |
| handing_information_22 | String | 处理信息22 |
| handing_information_3 | String | 处理信息3 |
| edi_contact_id | String | EDI联系人ID |
| is_edi | Boolean | 是否EDI |
| edi_other_station | String | EDI其他站点 |
| edi_kerry_station | String | EDI Kerry站点 |
| edi_kerry_log | String | EDI Kerry日志 |
| edi_log | String | EDI日志 |
| is_processed | boolean | 是否已处理 |
| is_tonnage_report | Boolean | 是否吨位报告 |
| is_pre_alert | Boolean | 是否预提醒 |
| is_statistics | Boolean | 是否统计 |
| is_include_rate | Boolean | 是否包含费率 |
| is_op_setup_processed | Boolean | 是否操作设置已处理 |
| is_checkout | Boolean | 是否结账 |
| is_modify_log | Boolean | 是否修改日志 |
| is_print_run_report | Boolean | 是否打印运行报告 |
| chrgwt_as_cc | Boolean | 计费重量作为到付 |
| chrgwt_as_pp | Boolean | 计费重量作为预付 |
| print_flag | Boolean | 打印标志 |
| notify_accounting | Boolean | 通知会计 |

### 业务信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| title | String | 标题 |
| sales_rep | String | 销售代表 |
| following_sales | String | 后续销售 |
| dest_op | String | 目的操作 |
| control_user | String | 控制用户 |
| local_verify_user | String | 本地验证用户 |
| local_verify_time | String | 本地验证时间 |
| fl_verify_user | String | FL验证用户 |
| fl_verify_time | String | FL验证时间 |
| f_shipper | String | 前缀发货人 |
| f_consignee | String | 前缀收货人 |
| account_no | String | 账号 |
| invoice_no | String | 发票号 |
| packing_no | String | 包装号 |
| pick_remarks | String | 提货备注 |
| file_remarks | String | 文件备注 |
| price_remarks | String | 价格备注 |
| freight_remarks | String | 运费备注 |
| delivery_order_remarks | String | 交货单备注 |
| optional_shipping_info | String | 可选运输信息 |
| prepared_by | String | 准备人 |
| sub_link_no | String | 子链接号 |
| house_link_no | String | 分链接号 |
| combine_booking_no | String | 合并预订号 |
| kc_no | String | KC号 |
| booking_change_to_shipment_type | String | 预订变更到装运类型 |
| gtu_code | String | GTU代码 |
| trade_terms | String | 贸易条款 |
| accounting_information | String | 会计信息 |
| action_log | String | 操作日志 |
| routine_local | String | 常规本地 |
| operating_mode | String | 操作模式 |
| origin_op_id | String | 起源操作ID |
| origin_op | String | 起源操作 |
| origin_op_email | String | 起始操作邮箱 |
| location_id | String | 位置ID |
| location_name | String | 位置名称 |

### 其他信息

| 字段名 | 类型 | 说明 |
|--------|------|------|
| k3_house_unid | String | K3 House唯一标识 |
| k3_master_unid | String | K3 Master唯一标识 |
| week | Integer | 周 |
| statistics_year | Integer | 统计年份 |
| run_report_user | String | 运行报告用户 |
| run_report_time | String | 运行报告时间 |
| old_run_report_user | String | 旧运行报告用户 |
| old_run_report_time | String | 旧运行报告时间 |
| issue_company | String | 签发公司 |
| issue_address | String | 签发地址 |
| issue_city | String | 签发城市 |
| issue_state | String | 签发州/省 |
| issue_zipcode | String | 签发邮编 |
| issue_iata | String | 签发IATA |

### 关联对象

| 字段名 | 类型 | 说明 |
|--------|------|------|
| air_booking_extend | AirBookingExtend | 航空预订扩展信息 |
| air_booking_container | List\<AirBookingContainer\> | 航空预订集装箱列表 |
| air_reference | List\<AirBookingReference\> | 航空参考信息列表 |
| air_booking_milestone | List\<AirBookingMilestone\> | 航空预订里程碑列表 |
| air_booking_notes | List\<AirBookingNotes\> | 航空预订备注列表 |

---

## 2. AirBookingContainer

`AirBookingContainer` 类用于存储航空预订集装箱信息。由 wenhz 于 2025-10-15 创建。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| serial_no | String | 序列号 |
| qty | BigDecimal | 数量 |
| uom | String | 单位 |
| commodity | String | 商品 |
| length | BigDecimal | 长度 |
| height | BigDecimal | 高度 |
| width | BigDecimal | 宽度 |
| in_cm | String | 单位（厘米） |
| lbs | BigDecimal | 磅 |
| kgs | BigDecimal | 公斤 |
| pallet_id | String | 托盘ID |
| is_each_item_w | Boolean | 每项重量 |
| is_need_calc | Boolean | 需要计算 |
| is_each_item_d | Boolean | 每项尺寸 |
| sch_b | String | 调度B |
| total_value | BigDecimal | 总价值 |
| description | String | 描述 |
| create_user | String | 创建用户 |
| create_time | String | 创建时间 |
| modify_user | String | 修改用户 |
| modify_time | String | 修改时间 |
| perishable_name | String | 易腐品名称 |
| volume | BigDecimal | 体积 |
| length_i | BigDecimal | 长度（英寸） |
| width_i | BigDecimal | 宽度（英寸） |
| height_i | BigDecimal | 高度（英寸） |

---

## 3. AirBookingExtend

`AirBookingExtend` 类用于存储航空预订扩展信息。由 wenhz 于 2025-10-15 创建。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| serial_no | String | 序列号 |
| booking_remark | String | 预订备注 |
| sales_type | String | 销售类型 |
| customerservice_code | String | 客户服务代码 |
| customerservice_dept | String | 客户服务部门 |
| customer_code | String | 客户代码 |
| cargo_value | BigDecimal | 货物价值 |
| cargo_value_currency | String | 货物价值货币 |
| service_type | String | 服务类型 |
| service_level | String | 服务等级 |
| coloader | String | 联运方 |
| coloader_code | String | 联运方代码 |
| coloader_name | String | 联运方名称 |
| inventory_status | String | 库存状态 |
| create_user | String | 创建用户 |
| create_date | String | 创建日期 |
| modify_user | String | 修改用户 |
| modify_date | String | 修改日期 |
| action_time | String | 操作时间 |
| customer_approval_status | String | 客户审批状态 |
| customer_name | String | 客户名称 |
| rev | BigDecimal | 收入 |
| controlling_party | String | 控制方 |
| document_type | String | 文档类型 |
| print_type | String | 打印类型 |
| booking_commodity_code | String | 预订商品代码 |
| booking_commodity_description | String | 预订商品描述 |
| addr_desc_consign | String | 地址描述（收货人） |
| addr_desc_shipper | String | 地址描述（发货人） |
| addr_desc_notify | String | 地址描述（通知方） |
| addr_desc_manu | String | 地址描述（制造商） |
| addr_desc_forword | String | 地址描述（货运代理） |
| negative_profit_reason | String | 负利润原因 |
| negative_profit_reason_remark | String | 负利润原因备注 |
| cancel_reason | String | 取消原因 |
| cancel_definition | String | 取消定义 |

---

## 4. AirBookingMilestone

`AirBookingMilestone` 类用于存储航空预订里程碑信息。由 wenhz 于 2025-10-15 创建。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| serial_no | String | 序列号 |
| stage_code | String | 阶段代码 |
| code | String | 代码 |
| description | String | 描述 |
| act_date | String | 实际日期 |
| act_time | String | 实际时间 |
| est_date | String | 预计日期 |
| est_time | String | 预计时间 |
| create_by | String | 创建者 |
| create_date | String | 创建时间 |
| update_by | String | 更新者 |
| update_date | String | 更新时间 |
| timezone | String | 时区 |
| is_send | Boolean | 是否已发送 |
| remark | String | 备注 |
| reason_code | String | 原因代码 |
| reason_description | String | 原因描述 |

---

## 5. AirBookingNotes

`AirBookingNotes` 类用于存储航空预订备注信息。由 wenhz 于 2025-10-15 创建。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| serial_no | String | 序列号 |
| note_type | String | 备注类型 |
| type_code | String | 类型代码 |
| notes | String | 备注内容 |
| create_by | String | 创建者 |
| modify_by | String | 修改者 |
| create_time | String | 创建时间 |
| modify_time | String | 修改时间 |

---

## 6. AirBookingReference

`AirBookingReference` 类用于存储航空预订参考信息。由 wenhz 于 2025-10-15 创建。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| ref_code | String | 参考代码 |
| ref_value | String | 参考值 |
| remark | String | 备注 |
| serial_no | String | 序列号 |

---

## 数据关系
- AirBooking 是主实体，包含多个容器(AirBookingContainer)
- AirBooking 包含多个参考信息(AirBookingReference)
- AirBooking 包含一个扩展信息对象(AirBookingExtend)
- AirBooking 包含多个里程碑事件(AirBookingMilestone)
- AirBooking 包含多个备注信息(AirBookingNotes)

## 应用场景
AirBooking 类主要用于空运业务系统的数据建模，支持空运订舱业务。

## 阅读规则
对于AirBooking各对象，在Mapping文档中的理解原则：
- air 应理解为 airbooking，表示整个集合对象。示例：air.ata_date 应理解为 airbooking.ata_date 。
- container 应理解为 airbooking的air_booking_container集合中的AirBookingContainer对象，表示单个容器信息，air_booking_container在airbooking中是一个集合。
- air_reference 应理解为 airbooking的air_reference集合中的AirBookingReference对象，表示单个参考信息，air_reference在airbooking中是一个集合。
- air_extend 应理解为 airbooking的air_booking_extend，一个AirBookingExtend对象，表示单个扩展信息。
- air_milestone 应理解为 airbooking的air_booking_milestone集合中的AirBookingMilestone对象，表示单个里程碑信息，air_booking_milestone在airbooking中是一个集合。
- air_notes 应理解为 airbooking的air_booking_notes集合中的AirBookingNotes对象，表示单个备注信息，air_booking_notes在airbooking中是一个集合。