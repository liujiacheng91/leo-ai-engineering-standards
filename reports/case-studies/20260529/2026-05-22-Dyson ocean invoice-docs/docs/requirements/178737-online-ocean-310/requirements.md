edi接收LL业务系统推送的费用信息，将费用信息转换为发送给Dyson

### 业务流程：
1. EDI API接收LL业务系统推送的OceanShipment数据，每个shipment会有多张费用(oc_rate)信息
2. EDI API依据逻辑进行数据转换，生成Dyson的数据1
3. EDI 将生成的数据推送至EDI Core，推送时，文件名规则：`LL_DYSON_310_#{invoiceNo}_#{controlNumber}.txt`，invoiceNo 去除非文件名字符，controlNumber 参考序列号服务生成（9位，前缀310）。（原描述 `Dyson_OnlineOcean_310_%s_%s.x12` 已废弃，以 mapping.csv 注意事项5为准）
4. 在推送完成后用Logger输出日志信息
5. 在推送完成后用ToolService写入日志信息
6. 在推送完成后用ToolService发送邮件信息(带附件: 原始文件内容, 转换后X12报文)

### 全局变量定义:  

| 参数名                | 映射字段                                      | 类型     | 说明                                                |
|:-------------------|:------------------------------------------|:-------|:--------------------------------------------------|
| `controlNumber`    | 参考"序列号服务"生成Dyson Control Number                 | String | 邮件告警路由                                            |
| `alertRouterName`  | "ediDysonService"                         | String | 邮件告警路由                                            |
| `env`              | 从@Value("${spring.profiles.active}")注入    | String | 运行环境，如：`dev, uat, prod`                           |
| `logPrefix`        | `logPrefix`                               | String | 日志前缀，格式：`[project_no][trace_id前8位][business_key]` |
| `projectNo`        | "DYSON"                                   | String | 项目编号，如：`DYSON`                                    |
| `ediNo`            | "BILLING_310"                             | String | 消息接口                                              |
| `ediPhase`         | "DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS" | String | 阶段标识                                              |
| `traceId`          | `trace_id`                                | String | 跟踪ID，取完整 trace_id 的前8位字符                          |
| `businessKey`      | `business_key`                            | String | 业务键，标识业务类型，如：`ORDER_SYNC`                         |
| `status`           | `status`                                  | String | 处理状态：成功:`1` / 失败:`0`                              |
| `message`          | `message`                                 | String | 处理消息，简要描述处理结果                                     |
| `bookingNo`        | `booking_no`                              | String | 订单号                                               |
| `businessContent`  | `businessContent`                         | String | 原始报文                                              |
| `invoiceNo`        | `invoice_no`                              | String | 发票号, 原始报文中的OceanShipment.oc_rate.invoice_no       |
| `output_filename`  | `output_filename`                         | String | 转换后的报文文件名                                         |
| `timestamp`        | `timestamp`                               | String | 时间戳, 格式为yyyyMMddHHmmss                            |
| `now`              | `now`                                     | String | 当前时间 格式为yyyy-MM-dd HH:mm:ss                       |

#### 序列号服务
1. 服务说明:  
根据定义生成一个唯一的序列号
服务位置: com.pobing.commonservice.builduniqueid.EdiIncrementSequenceService  
接口: getIncrementByCustomize(String group, String strategy, String prefix, String supplement, String symbol, int length)  
参数说明:  

| 参数名 | 类型 | 说明                                  |
|---|---|-------------------------------------|
| group | String | 分组，用于区分不同场景在redis上的序号               |
| strategy | String | 策略，按什么策略来生成场景key，Y-年，M-月，D-日，A-永久有效 |
| prefix | String | 前缀，用于构建好不同业务场景下的要求                  |
| supplement | String | 补充策略，是前补位还是后补位，还是后补位，还是不补位，1是后补，2是前补 |
| symbol | String | 补充符号,如果不给值，则默认是0  |
| length | int |  长度，用于计算最终补位后的长度  |

2. Dyson Control Number生成参数

| 参数名 | 类型 | 值       |
|---|---|---------|
| group | String | "DYSON" |
| strategy | String | "A"     |
| prefix | String | "310"   |
| supplement | String | "2"     |
| symbol | String | ""      |
| length | int | 9       |
例如:
```java
String controlNumber = sequenceService.getIncrementByCustomize("DYSON", "A", "315", "2", "", 9).getData().toString();
```

### 记录日志处理：  
1. 整个处理过程中成功和异常都需要写入到日志表, 通过com.pobing.edibusiness.common.service.ToolService.inertLog写入日志, logPrefix定义为[project_no][trace_id(前八位)][business_key], EdiRunCycleLogRequestVo参数mapping如下

| 参数名                | 映射字段(参考全局变量)                                            |
|:-------------------|:-------------------------------------------------------------|
| `project_no`       | `projectNo`                                                  |
| `edi_no`           | `ediNo`                                                      |
| `project_no`       | `projectNo`                                                  |
| `trace_id`         | `traceId`                                                    |
| `business_key`     | `businessKey`                                                |
| `biz_key_one`      | `output_filename`                                            |
| `biz_key_two`      | `invoice_no`                                                 |
| `biz_key_three`    | `output_filename`                                            |
| `content_str`      | JSON字符串 `{"input_body": "原始报文", "output_body": "转换后的报文内容"}` |
| `status`           | 初始为0, 推送EDI Core成功为1                                     |
| `response_result`  | 初始为空, 处理成功为Success, 失败写失败的消息, 截取前255字符                       |
| `transaction_time` | 当前时间 Now                                                     |
| `transaction_no`   | 时间戳                                                          |
2. 在推送至EDI Core后，得到返回结果后，依据结果记录日志. 

### 邮件通知处理:
1. 邮件模板: 模板对象com.pobing.edibusiness.common.service.vo.EmailTemplate, 内容如下 (其中 #{}占位符按照全局变量替换为对应的值)  
邮件标题: [#{env}] [#{project_no}] MSG310 SEND [#{status}] - #[#{invoice_no}]  
邮件内容:
```
   Dear All,

   Env: #{env}
   Trace ID: #{trace_id}
   Business Key: #{business_key}
   Invoice No: #{invoice_no}
   Shipment Number: #{hawb}
   Master Number: #{mawb}
   Filename: #{output_filename}
   Message: #{response_message}
   
   Thanks
 ```
邮件附件: (在处理过程中收集这两个信息, 最后发邮件使用) 

| 附件名称 | 映射字段（参考全局变量） |
| :--- | :--- |
| `input_body_[timestamp]` | 原始报文内容 |
| `output_body_[timestamp]` | 转换后的报文内容 |
通过com.pobing.edibusiness.common.utils.EdiToolUtils.generatedFiles, 返回List<File>, 用于发邮件使用

3. 邮件处理
在转换过程中记录全局变量中的字段信息, 最后用于记录日志和发送邮件. 调用com.pobing.edibusiness.common.service.ToolService.sendMail(String alertRouterName, EmailTemplate emailTemplate, Map<String, String> messages, List<File> files)参数如下

| 参数类型                | 参数名 | 参数描述   | 参数说明          |
|:--------------------| :--- |:-------|:--------------|
| String              | alertRouterName | 邮件路由名称 | 说明1           |
| EmailTemplate       | emailTemplate | 邮件模板   | 参考邮件模板对象定义    |
| Map<String, String> | messages | 邮件参数 | 参考邮件模板的占位符Map |
| List< File >        | files | 邮件附件   | 参考邮件附件处理结果    |

### 代码约束
1. 方法独立实现, 包括主流程方法, 转换mapping方法, 推送edi core方法和人工转换处理方法分四个方法分开编写, 除了主流程方法, 其他方法第一个参数必须是logPrefix
2. 主流程方法里面要有try catch , 最后记录log和发送邮件.
3. 人工转换处理用统一的方法mapFrom304(String logPrefix, Msg310 msg310, OceanShipment oceanShipment)放到转换完成后调用
4. 方法开始和结束需要用logger输出info log, log以logPrefix开头.
5. 处理过程中, 如果遇到重要的信息用logger输出info
6. 可能为null导致抛空的的对象, 需要做判断, 并用logger输出提示信息.
7. businessContent里面的原始报文是一个数组对象,元素类型为OceanShipment

### 原始报文格式: OceanShipment信息说明：
格式：Json  
参考：edi-public-struct-desc/standDefine/OceanShipment.md  
group: 'com.pobing.edi.platform', name: 'edi-standard-structure', version: "0.0.66"  

### 转换后的报文格式: Dyson数据格式  
格式：X12  
参考：edi-public-struct-desc/standDefine/Msg310X12.md  
Msg310的工具类，参考edi-public-struct-desc/spec/EDI-X12接入技术文档.md  

**SDK 依赖（需在 build.gradle 新增）：**
```gradle
implementation 'com.pobing.edi.platform:edi-x12:0.0.4'
```

**Factory 类：**
- `com.pobing.edi.platform.x12.v4010.factory.Msg310X12Factory`
- 序列化：`String edi = Msg310X12Factory.getInstance().toEDI(msg310x12)`
- GS01 功能标识码：`"IO"`
- SE01 段计数：`toEDI()` 自动计算，构建时填 `"0"` 即可
- Factory 建议用 static block 初始化为单例，避免重复加载耗时

### 转换映射定义
参考: mapping.csv
注意:  
1. 分组1 oc_rate分组 按照: oc_rate.client_id, oc_rate.invoice_no 分组后统计
2. 分组2 oc_container分组 按照: oc_container.serial_no, oc_container.ctnr
3. 分组3 oc_container分组 按照: oc_container.serial_no
4. 按分组1生成独立的X12 MSG310文件
5. 换后的报文文件名规则LL_DYSON_310_#{invoiceNo}_#{controlNumber}.txt, #{invoiceNo}去除不是文件名称的字符
6. source列如果有"转换占位处理"请忽略此行Mapping, 这样标识的需要人工处理, 将会在"人工转换处理方法"中处理.
7. logic列是"Control Number(9位)", 请参考"controlNumber"方式实现
8. Hardcode, Hard Code开头的, 后面的部分作为值直接写入(去除前后空格,前后双引号)
9. 10个空格 标识生成10个空格
10. PROD: KERRY, TEST: KERRYTEST 类似这种, 通过com.pobing.dyson.common.config.DysonConfig中getEnv()方法获取环境, 值等于prod就是PROD, 值等于其他就是TEST; 其他的"PROD：RBTWTMC，TEST：RBTWTMCTEST", "PROD：P，TEST：T"都是同样的理解
11. 分组1 oc_rate后备注的都是按照: oc_rate.client_id, oc_rate.invoice_no 分组后统计
12. 分组2 oc_container后备注都是按照: oc_container.serial_no, oc_container.ctnr
13. 分组3 oc_container后备注都是按照: oc_container.serial_no
14. 物流状态理解: ocean_milestone[code=IFFDEP].act_date标识ocean_milestone列表里面code=IFFDEP的对象act_date的值
15. DTM里面的是需要DTM01,DTM02, DTM03一组一起理解, DTM如果有多组, 会在前面标识DTM01=139标识一组, DMT01=140标识第二组

### 场景定义
#### 转换报文场景:  
服务类名：DysonOnlineOceanBillingSendProcess 扩展自 EdiSendCustomizeBaseProcessAbstract, 实现如下:
| 字段 | 值 |
| :--- | :--- |
| `secenCode` | `DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS` |
| `SceneVersion` | `0.0.1` |
| `CustomerCode` | `DYSON` |
| `CustomerScope` | `ONLINE` |
| `EdiCode` | `DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS` |
| `EdiCustomer` | `DYSON` |

#### 推送给EDI Core场景
参数定义：
| 字段 | 值 |
| :--- | :--- |
| `secenCode` | `SEND_DYSON_TO_SFTP` |
| `SceneVersion` | `0.0.1` |
| `CustomerCode` | `DYSON` |
| `CustomerScope` | `OCEAN_RATE` |
| `requestDirectionType` | `1` |
| `requestHandleStrategyType` | `2` |
| `requestServiceType` | `1` |

EDI Core参数类型：CommonRequest，请参考CommonRequest.md  
CommonRequest 额外字段说明：
- `traceId`：取 sendData 参数 dispatcherRequest 中的 traceId
- `businessKey`：取 sendData 参数 dispatcherRequest 中的 businessKey

推送edi core参考方法：Revert pushRevert = ediCoreServiceUtils.pushContentTo(request);使用EdiCoreServiceUtils工具

### 已确认的模糊问题 (2026-05-20)

| 问题 | 确认结果 |
|---|---|
| 文件名格式 | 使用 mapping.csv 注意事项5：`LL_DYSON_310_#{invoiceNo}_#{controlNumber}.txt`，invoiceNo 去除非文件名字符 |
| B3/B304 兜底（ocean.terms 既非 COLLECT 也非 PREPAID）| 给空字符串；待 BA 最终确认 |
| mapping.csv L1/L108 字段名 `oc_rate.customer_code` | 实际使用 `oc_rate.x_customer_code`（OceanRate 实体字段名） |
| mapping.csv `oc_rate.x_client_address1/2` 下划线 | 实际使用 `oc_rate.x_client_address_1` / `oc_rate.x_client_address_2`（OceanRate 实体字段名） |
| V1 段（mapping.csv 无映射）| 保留 V1，归入 mapFrom304 占位范围，由人工实现 |
| Msg310X12Factory SDK 版本 | `edi-x12:0.0.4` 支持 MSG310；GS01=`"IO"`；SE01 自动计算；Factory 用 static block 初始化单例 |
| 日志/邮件 API | 使用新版 `ToolService`（非旧版 CommonUtils）：`inertLog(logPrefix, EdiRunCycleLogRequestVo)` + `sendMail(alertRouterName, EmailTemplate, Map, List<File>)` |
| 日志 VO 构建 | `EdiToolUtils.newLogVo("DYSON", "BILLING_310", "DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS")` 初始化；用 `EdiToolUtils.setEdiRunCycleLogRequestVo` 更新字段 |
| messageFormat 值 | `TXT`（非 TEXT） |
| 邮件附件生成 | `EdiToolUtils.generatedFiles(fileMap)`；key 为 `input_body`（原始报文）和 `output_body1`、`output_body2`……（每组 invoice 一个）；ediText 为 null 时用空字符串替代 |
| invoiceNo 文件名清洗 | `EdiToolUtils.cleanFilename(invoiceNo)` 去除非法字符 |
| EmailTemplate status 占位符 | `#{status}`：status=1 替换为 `"Success"`，status=0 替换为 `"Fail"` |
| trace_id 兜底 | trace_id 为空时默认 `UUID.randomUUID().toString()` |
| sendData 返回值 | 成功：`status=true, code=200, data=[{"invoiceNo":..., "filename":..., "status":true/false, "stage":"Mapping"/"upload", "message":"..."}, ...]`；失败：`status=false, code=500, message=错误描述`；data 每项字段说明：`status`(true=成功/false=失败)、`stage`(Mapping=转换过程/upload=推送EDI Core过程)、`message`(处理错误信息) |

### 阅读提示
1. 遇到模糊的情况请等待给出结果确认, 确认后请更新到需求中, 并建议requirements.md如何调整  