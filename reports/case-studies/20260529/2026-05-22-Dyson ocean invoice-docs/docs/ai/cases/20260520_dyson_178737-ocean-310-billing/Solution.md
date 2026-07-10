# Solution.md

## Solution Overview

新增 `DysonOnlineOceanBillingSendProcess`（Process 注册类）和 `DysonOnlineOceanBillingSendProcessImpl`（实现类），接收 LL 业务系统推送的 `OceanShipment`（含 `oc_rate` 列表），按 `oc_rate.client_id + invoice_no` 分组，每组生成一份 X12 MSG310 文件，推送至 EDI Core，记录日志，发送邮件。

## Impact Analysis

### Affected Modules

- `edi-business-realization/edi-dyson-realization`（新增文件）

### Affected Files

| 文件 | 变更类型 | 说明 |
|---|---|---|
| `src/main/java/com/pobing/dyson/send/process/DysonOnlineOceanBillingSendProcess.java` | 新增 | Process 注册类（6 个 override） |
| `src/main/java/com/pobing/dyson/send/process/impl/DysonOnlineOceanBillingSendProcessImpl.java` | 新增 | 主实现类（4 个方法） |
| `build.gradle` | 修改 | 新增 `edi-x12:0.0.4` 依赖 |

### Affected APIs

- 无现有 API 修改，仅新增 `EdiCode = DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS` 的 Send Adapter

### Affected Database Objects

- 只读/写 `edi_run_cycle_log` 表（通过 ToolService）

### Affected Configurations

- 无 Spring 配置变更；`@Value("${spring.profiles.active}")` 沿用现有机制

---

## Recommended Solution

### 1. build.gradle 变更

在 `edi-dyson-realization/build.gradle` 新增：

```gradle
implementation 'com.pobing.edi.platform:edi-x12:0.0.4'
```

> Msg310X12Factory 位于 `com.pobing.edi.platform.x12.v4010.factory`，仅在 0.0.4 版本中支持 MSG310。

### 2. Process 注册类

```
DysonOnlineOceanBillingSendProcess extends EdiSendCustomizeBaseProcessAbstract
```

| Override | 值 |
|---|---|
| getSceneCode() | `"DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS"` |
| getSceneVersion() | `"0.0.1"` |
| getCustomerCode() | `"DYSON"` |
| getCustomerScope() | `"ONLINE"` |
| getEdiCode() | `"DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS"` |
| getEdiCustomer() | `"DYSON"` |

### 3. 实现类结构

```
@Component
@EdiSendAdapter(EdiCode = "DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS", EdiCustomer = "DYSON")
DysonOnlineOceanBillingSendProcessImpl implements EdiSendStrategy<Object>
```

**注入依赖：**

| 依赖 | 类型 | 说明 |
|---|---|---|
| `toolService` | `ToolService` | 新版日志/邮件 API |
| `sequenceService` | `EdiIncrementSequenceService` | 控制号生成 |
| `ediCoreServiceUtils` | `EdiCoreServiceUtils` | 推送 EDI Core |
| `env` | `@Value("${spring.profiles.active}")` | 环境变量 |

**Factory 初始化（static block）：**

```java
private static final Msg310X12Factory FACTORY;
static {
    try {
        FACTORY = Msg310X12Factory.getInstance();
    } catch (Exception e) {
        throw new ExceptionInInitializerError(e);
    }
}
```

### 4. 四个方法设计

#### 4.1 sendData（主流程）

```
sendData(DispatcherRequest dispatcherRequest)
  ├─ 解析 businessContent → List<OceanShipment>
  ├─ for each OceanShipment:
  │   ├─ 初始化 logVo = EdiToolUtils.newLogVo("DYSON", "BILLING_310", "DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS")
  │   ├─ 构建 logPrefix = "[DYSON][traceId前8位][businessKey]"
  │   ├─ 按 oc_rate.client_id + invoice_no 分组 → Map<String, List<OceanRate>>
  │   ├─ for each rateGroup:
  │   │   ├─ controlNumber = sequenceService.getIncrementByCustomize("DYSON","A","310","2","",9)
  │   │   ├─ msg310x12 = buildMsg310(logPrefix, shipment, rateGroup, controlNumber)
  │   │   ├─ ediText = FACTORY.toEDI(msg310x12)
  │   │   ├─ invoiceNo = min(rateGroup.invoice_no)，EdiToolUtils.cleanFilename 去除非法字符
  │   │   ├─ filename = "LL_DYSON_310_" + cleanInvoiceNo + "_" + controlNumber + ".txt"
  │   │   ├─ pushToCore(logPrefix, filename, ediText, logVo)
  │   │   └─ 收集 sourceContent / outputContent
  │   └─ 发送邮件 (EmailTemplate + EdiToolUtils.generatedFiles)
  └─ catch: 记录失败日志 + 发送失败邮件
```

**全局变量（每次循环刷新）：**

| 变量 | 值 |
|---|---|
| projectNo | "DYSON" |
| ediNo | "BILLING_310" |
| ediPhase | "DYSON_ONLINE_OCEAN_BILLING_SEND_PROCESS" |
| alertRouterName | "ediDysonService" |
| traceId | dispatcherRequest 的 trace_id 前 8 位；若 trace_id 为空则 `UUID.randomUUID().toString()` |
| businessKey | dispatcherRequest 的 business_key |

#### 4.2 buildMsg310

```
buildMsg310(String logPrefix, OceanShipment shipment, List<OceanRate> rateGroup, String controlNumber)
```

- 构造 `Msg310X12`（ISA/GS/GE/IEA + 一个 Msg310）
- 完整字段见 Mapping_Rules.md
- 调用 `mapFrom304(logPrefix, msg310, shipment)` 在 return 前执行

**ISA/GS 关键字段：**

| 字段 | PROD 值 | TEST 值 |
|---|---|---|
| ISA06（发送方） | `KERRY` 右补空格至15位 | `KERRYTEST` 右补空格至15位 |
| ISA08（接收方） | `RBTWTMC` 右补空格至15位 | `RBTWTMCTEST` 右补空格至15位 |
| ISA15 | `P` | `T` |
| GS01 | `IO` | `IO` |
| GS02 | `KERRY` | `KERRYTEST` |
| GS03 | `RBTWTMC` | `RBTWTMCTEST` |

环境判断：`env.equalsIgnoreCase("prod")` → PROD；否则 TEST。

**SE01 计数**：由 `Msg310X12Factory.toEDI()` 自动计算，构建时填 `"0"` 即可。

#### 4.3 pushToCore

```
String pushToCore(String logPrefix, String filename, String content, EdiRunCycleLogRequestVo logVo, String traceId, String businessKey)
```

- 返回值：null = 推送成功；非 null 字符串 = 推送失败的错误信息
- 构建 `CommonRequest`：
  - sceneCode: `SEND_DYSON_TO_SFTP`
  - sceneVersion: `0.0.1`
  - customerCode: `DYSON`
  - customerScope: `OCEAN_RATE`
  - requestDirectionType: `1`
  - requestHandleStrategyType: `2`
  - requestServiceType: `1`
  - traceId: `traceId`（来自 dispatcherRequest）
  - businessKey: `businessKey`（来自 dispatcherRequest）
  - fileName: `filename`
  - businessContent: `content`
  - messageFormat: `TXT`
- 调用：`Revert revert = ediCoreServiceUtils.pushContentTo(request)`
- 推送成功 → `logVo.setStatus("1")`，return null；失败/异常 → `logVo.setStatus("0")`，return 错误信息
- 调用 `toolService.inertLog(logPrefix, logVo)`

#### 4.4 mapFrom304（占位）

```
mapFrom304(String logPrefix, Msg310 msg310, OceanShipment shipment)
```

- 方法体为空（// TODO: 人工实现）
- 覆盖范围：N9 非标准类型、R4*R、R4*E、N7/N722、V1

### 5. 邮件模板

**EmailTemplate 构建：**

```
subject = "[#{env}] [DYSON] MSG310 SEND [#{status}] - #[#{invoiceNo}]"
content（模板，#{} 占位符运行时替换）：
  Env: #{env}
  Trace ID: #{trace_id}
  Business Key: #{business_key}
  Invoice No: #{invoice_no}
  Shipment Number: #{hawb}
  Master Number: #{mawb}
  Filename: #{output_filename}
  Message: #{response_message}
```

占位符替换说明：
- `#{status}`：推送成功 → `"Success"`；失败 → `"Fail"`
- `#{env}`：注入值直接使用

**附件构建（多组 invoice 时）：**

每个分组1的 ediText 作为独立附件，Key 格式为 `output_body1`、`output_body2`……以此类推：

```java
Map<String, String> fileMap = new LinkedHashMap<>();
fileMap.put("input_body", rawJson);   // 原始报文（唯一）
// for 循环中按序号追加
fileMap.put("output_body" + (index + 1), ediText);  // 每组一个
```

注意：`ediText` 可能因转换异常为 null，放入 `fileMap` 前必须做 null 判断，为 null 时用空字符串替代，避免 `Map.of` / `generatedFiles` NPE。

### 6. 返回值规范

`sendData` 方法返回 `Revert` 对象：

| 情况 | status | code | message | data |
|---|---|---|---|---|
| 正常处理完成（含部分推送失败） | `true` | `200` | `null` | JSON 数组字符串（见下） |
| 处理失败（解析异常 / 未知异常） | `false` | `500` | 错误描述字符串 | `null` |

data 为 JSON 数组字符串，每个元素对应一组 invoice，字段如下：

| 字段 | 类型 | 说明 |
|---|---|---|
| `invoiceNo` | String | 该分组最小 invoice_no |
| `filename` | String | 转换后报文文件名 |
| `status` | Boolean | true=成功，false=失败 |
| `stage` | String | 失败发生阶段："Mapping"（转换）/ "upload"（推送 EDI Core）；成功时为空字符串 |
| `message` | String | 失败错误信息；成功时为空字符串 |

示例（成功）：
```json
[{"invoiceNo":"INV001","filename":"LL_DYSON_310_INV001_310000001.txt","status":true,"stage":"","message":""}]
```

示例（推送失败）：
```json
[{"invoiceNo":"INV001","filename":"LL_DYSON_310_INV001_310000001.txt","status":false,"stage":"upload","message":"sftp error"}]
```

### 7. 分组逻辑实现

```java
Map<String, List<OceanRate>> groups = shipment.getOc_rate().stream()
    .collect(Collectors.groupingBy(r -> r.getClient_id() + "_" + r.getInvoice_no()));
```

### 8. LX/N7/L0/L1 嵌套结构

- 一个 `LxGroup`（LX01 = "1"）
- `LxGroup.n7Group`：按分组2（serial_no + ctnr）生成，仅在 `ocean.loadterm != "LCL"` 时填充
- `LxGroup.l0Group`：按分组2生成，每个 L0Group 包含所有 L1 charge 项（L1Group 列表）
- L1 序号从 1 开始递增

---

## Security Considerations

- 无鉴权/加密逻辑变更
- 不读取/写入敏感数据；businessContent 为内部业务 JSON，不含密钥或凭证
- EDI 文件通过 EdiCore SFTP 通道传输，通道安全由平台层保证

---

## Test Strategy

- 单元测试（Mockito）：
  - 正路径：两组 invoice → 生成两个 MSG310
  - 边界：空 oc_rate 列表 → 不生成文件
  - 边界：ocean.loadterm = LCL → 无 N7 节点
  - 边界：ocean.terms 非 COLLECT/PREPAID → B3/B304 为空字符串
  - 异常：JSON 解析失败 → 捕获并记录失败日志
  - 环境：env=prod → ISA06=KERRY, ISA15=P
- 测试类：`DysonOnlineOceanBillingSendProcessImplTest`（已有骨架在 src/test/）

---

## Rollback Plan

- 新增文件，不修改现有类，回滚仅需删除两个新文件
- `@EdiSendAdapter` 注解绑定通过 Spring Bean 注册，删除 Bean 即解除路由
- build.gradle 新增依赖无破坏性影响，可单独回退版本号

---

## Method Signature Confirmation

按 Retrospective 要求，在 Solution 阶段确认所有外部方法签名：

| 方法 | 签名（已验证） |
|---|---|
| `EdiIncrementSequenceService.getIncrementByCustomize` | `(String,String,String,String,String,int) → Revert` |
| `EdiCoreServiceUtils.pushContentTo` | `(CommonRequest) → Revert` |
| `ToolService.inertLog` | `(String logPrefix, EdiRunCycleLogRequestVo) → void` |
| `ToolService.sendMail` | `(String, EmailTemplate, Map<String,String>, List<File>) → Revert` |
| `EdiToolUtils.newLogVo` | `(String projectNo, String ediNo, String ediPhase) → EdiRunCycleLogRequestVo` |
| `EdiToolUtils.setEdiRunCycleLogRequestVo` | `(EdiRunCycleLogRequestVo, Map<String,String>) → void` |
| `EdiToolUtils.generatedFiles` | `(Map<String,String>) → List<File>` |
| `EdiToolUtils.cleanFilename` | `(String) → String` |
| `Msg310X12Factory.getInstance` | `() → Msg310X12Factory (throws IOException, SAXException)` |
| `Msg310X12Factory.toEDI` | `(Msg310X12) → String` |

---

## Human Approval

- Approved by: Sundy Sun  
- Date: 2025-05-20  
- Notes:  
  1. 构建 `CommonRequest` 的时候 messageFormat: TEXT改为TXT  
  2. ediText可能因为处理出错导致为null, 邮件模板附件中用Map.of会出错  
  3. EmailTemplate 构建 构建里面的{env}改为#{env}, {status}改为 #{status},  注意status=1 这里用Success替换, status=0, 用Fail替换  
  4. 如果group by oc_rate之后, 有多组, 生成的output_body就会有多个文件, 附件Map中的Key可用output_body1, output_body2, 这个key会作为附件的文件名, 以此类推  
  5. 最终的返回Revert对象, 成功: status=true, code=200, message=null, data=[{"invoiceNo": #{invoiceNo}, "filename": 转换后的报文文件名}];  失败的时候: status=false, code=500, message=错误描述;
  6. trace_id为空的时候, 默认给UUID.randomUUID().toString(), 是不是漏掉了?
  7. 已上更改请也更新到需求文档
