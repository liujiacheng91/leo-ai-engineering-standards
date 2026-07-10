# EDI-X12 SDK 接入技术文档

**SDK 坐标：** `com.pobing.edi.platform:edi-x12:0.0.4`
**支持标准：** X12 v4010
**文档日期：** 2026-05-20

---

## 目录

1. [接入依赖](#1-接入依赖)
2. [快速开始](#2-快速开始)
3. [核心概念](#3-核心概念)
4. [解析 EDI 报文（EDI → 对象）](#4-解析-edi-报文edi--对象)
5. [生成 EDI 报文（对象 → EDI）](#5-生成-edi-报文对象--edi)
6. [支持的报文类型](#6-支持的报文类型)
7. [信封字段说明](#7-信封字段说明)
8. [常见业务段字段说明](#8-常见业务段字段说明)
9. [自定义分隔符](#9-自定义分隔符)
10. [最佳实践与注意事项](#10-最佳实践与注意事项)
11. [常见问题](#11-常见问题)

---

## 1. 接入依赖

### Gradle

```gradle
dependencies {
    implementation 'com.pobing.edi.platform:edi-x12:0.0.4'
}
```

### Maven

```xml
<dependency>
    <groupId>com.pobing.edi.platform</groupId>
    <artifactId>edi-x12</artifactId>
    <version>0.0.4</version>
</dependency>
```

> **注意：** 该 SDK 发布于内网 Nexus（`arc-rep.keas.ll.cn:8081`），接入前确保项目已配置对应仓库地址，并且网络可达（需 VPN）。

---

## 2. 快速开始

以解析一份 EDI 210（货运发票）为例：

```java
import com.pobing.edi.platform.x12.v4010.factory.Msg210X12Factory;
import com.pobing.edi.platform.x12.v4010.MSG210.Msg210X12;

// 1. 获取 Factory（建议作为 Spring Bean 单例）
Msg210X12Factory factory = Msg210X12Factory.getInstance();

// 2. 解析 EDI 字符串
Msg210X12 message = factory.fromEDI(ediString);

// 3. 读取数据
String invoiceNo = message.getMsg210().get(0).getB3().getB302();
```

以生成一份 EDI 210 为例：

```java
// 1. 构建对象
Msg210X12 message = new Msg210X12()
    .setIsa(buildIsa())
    .setGs(buildGs())
    .setMsg210(Collections.singletonList(buildMsg210()))
    .setGe(new Ge().setGe01("1").setGe02("000000001"))
    .setIea(new Iea().setIea01("1").setIea02("000000001"));

// 2. 生成 EDI 字符串
String ediOutput = factory.toEDI(message);
```

---

## 3. 核心概念

### 3.1 报文结构

每条 X12 EDI 报文由以下四层结构组成：

```
MsgXXXX X12          ← 完整交换报文（含 ISA/GS/GE/IEA 信封）
└── MsgXXXX          ← 事务集（ST...SE，可包含多条）
    ├── St            ← 事务开始段
    ├── [业务段]      ← 如 B3（货运头）、Beg（采购头）等
    ├── [XxxGroup]    ← 可重复的段组，如 N1Group（收发货方）
    └── Se            ← 事务结束段
```

### 3.2 Factory 使用模式

每种报文类型对应一个独立的 Factory 类，提供统一的接口：

| 方法 | 说明 |
|------|------|
| `getInstance()` | 获取使用默认分隔符的 Factory |
| `getInstance(Delimiters)` | 获取使用自定义分隔符的 Factory |
| `fromEDI(String)` | EDI 字符串 → Java 对象 |
| `toEDI(MsgXXXX X12)` | Java 对象 → EDI 字符串 |

### 3.3 默认分隔符

| 名称 | 值 | 说明 |
|------|-----|------|
| Segment | `~` | 段结束符 |
| Field | `*` | 字段分隔符 |
| Component | `:` | 复合字段分隔符 |
| Escape | `?` | 转义字符 |

---

## 4. 解析 EDI 报文（EDI → 对象）

### 4.1 基本解析

```java
Msg210X12Factory factory = Msg210X12Factory.getInstance();

try {
    Msg210X12 message = factory.fromEDI(ediString);
    
    // 读取信封信息
    String senderId   = message.getIsa().getIsa06().trim();
    String receiverId = message.getIsa().getIsa08().trim();
    
    // 遍历事务集
    for (Msg210 msg : message.getMsg210()) {
        String controlNo = msg.getSt().getSt02();
        String invoiceNo = msg.getB3().getB302();
        
        // 遍历收发货方
        for (N1Group n1g : msg.getN1Group()) {
            String role = n1g.getN1().getN101(); // "SH"=发货方, "CN"=收货方
            String name = n1g.getN1().getN102();
        }
    }
} catch (Exception e) {
    // 报文格式不合法时抛出
    log.error("EDI 210 解析失败: {}", e.getMessage(), e);
}
```

### 4.2 各报文解析示例

**EDI 850 — 采购订单**

```java
Msg850X12Factory factory = Msg850X12Factory.getInstance();
Msg850X12 order = factory.fromEDI(ediString);

Msg850 po = order.getMsg850().get(0);

// 订单号（BEG03）
String poNumber = po.getBeg().getBeg03();
// 订单日期（BEG05）
String poDate = po.getBeg().getBeg05();

// 遍历行项目
for (Po1Group line : po.getPo1Group()) {
    String lineNo = line.getPo1().getPo101(); // 行号
    String qty    = line.getPo1().getPo102(); // 数量
    String uom    = line.getPo1().getPo103(); // 单位
    String price  = line.getPo1().getPo104(); // 单价
    String sku    = line.getPo1().getPo107(); // 商品编号（VP=供应商料号）
}

// 收货地址
for (N1Group n1g : po.getN1Group()) {
    if ("ST".equals(n1g.getN1().getN101())) { // ST = Ship To
        String shipToName = n1g.getN1().getN102();
        String city       = n1g.getN4().getN401();
        String state      = n1g.getN4().getN402();
    }
}
```

**EDI 214 — 运输状态**

```java
Msg214X12Factory factory = Msg214X12Factory.getInstance();
Msg214X12 status = factory.fromEDI(ediString);

Msg214 msg = status.getMsg214().get(0);

// 提单号（B1002）
String billOfLading = msg.getB10().getB1002();

// 状态事件
for (At7Group at7g : msg.getAt7Group()) {
    String statusCode = at7g.getAt7().getAt701(); // 状态码
    String statusDate = at7g.getAt7().getAt704(); // 日期
    String statusTime = at7g.getAt7().getAt705(); // 时间
}
```

**EDI 997 — 功能确认**

```java
Msg997X12Factory factory = Msg997X12Factory.getInstance();
Msg997X12 ack = factory.fromEDI(ediString);

Msg997 msg = ack.getMsg997().get(0);

// 确认状态
for (Ak2Group ak2g : msg.getAk2Group()) {
    String transactionType = ak2g.getAk2().getAk201(); // 报文类型
    String ackCode = ak2g.getAk5().getAk501();         // A=接受, R=拒绝, E=有错误
}
```

---

## 5. 生成 EDI 报文（对象 → EDI）

### 5.1 信封构建（公共部分）

所有报文类型共用相同的 ISA/GS/GE/IEA 信封结构：

```java
private Isa buildIsa(String senderId, String receiverId, String date, String time, String controlNo) {
    return new Isa()
        .setIsa01("00").setIsa02("          ")  // 授权信息（固定）
        .setIsa03("00").setIsa04("          ")  // 安全信息（固定）
        .setIsa05("ZZ").setIsa06(padRight(senderId, 15))    // 发送方 ID（右补空格至15位）
        .setIsa07("ZZ").setIsa08(padRight(receiverId, 15))  // 接收方 ID（右补空格至15位）
        .setIsa09(date)          // 日期 YYMMDD，如 "260428"
        .setIsa10(time)          // 时间 HHMM，如 "1420"
        .setIsa11("U")           // 标准 ID（固定）
        .setIsa12("00401")       // X12 v4010（固定）
        .setIsa13(controlNo)     // 交换控制号，如 "000000001"
        .setIsa14("0")           // 不需要 ACK
        .setIsa15("P")           // P=生产环境，T=测试环境
        .setIsa16(">");          // 复合分隔符（固定）
}

private Gs buildGs(String senderId, String receiverId, String date, String time, String groupNo) {
    return new Gs()
        .setGs01("IM")           // 功能标识码（IM=货运发票，PO=采购订单等）
        .setGs02(senderId)
        .setGs03(receiverId)
        .setGs04(date)           // 日期 CCYYMMDD，如 "20260428"
        .setGs05(time)           // 时间 HHMM
        .setGs06(groupNo)        // 组控制号
        .setGs07("X")            // 负责机构（X12）
        .setGs08("004010");      // 版本号（固定）
}
```

> **GS01 功能标识码参考：**
> `IM` = 货运发票(210), `QO` = 采购订单(850), `QM` = 货运装船(304), `QS` = 状态(214/315), `FA` = 功能确认(997)

### 5.2 EDI 210 — 货运发票

```java
Msg210X12Factory factory = Msg210X12Factory.getInstance();

// 构建运费明细（L1 段）
L1 l1 = new L1()
    .setL101("1")         // 运费条目序号
    .setL104("326155")    // 运费金额（分）
    .setL107("AFR")       // 费用类型代码
    .setL108("Air Freight");

// 构建收发货方（N1 段）
N1Group shipFrom = new N1Group()
    .setN1(new N1().setN101("SH").setN102("SUPPLIER NAME").setN103("ZZ").setN104("SUP001"))
    .setN4(new N4().setN401("HONG KONG").setN402("HK").setN403("999077"));

N1Group shipTo = new N1Group()
    .setN1(new N1().setN101("CN").setN102("CONSIGNEE NAME").setN103("ZZ").setN104("CON001"))
    .setN3(Collections.singletonList(new N3().setN301("123 MAIN ST")))
    .setN4(new N4().setN401("NEW YORK").setN402("NY").setN403("10001").setN404("US"));

// 构建事务集
Msg210 msg210 = new Msg210()
    .setSt(new St().setSt01("210").setSt02("000000001"))
    .setB3(new B3()
        .setB302("INVOICE-001")  // 发票号
        .setB303("CC")           // 预付费
        .setB309("20260428"))    // 发票日期
    .setN1Group(Arrays.asList(shipFrom, shipTo))
    .setSe(new Se().setSe01("0").setSe02("000000001")); // se01 自动更新，填 "0" 即可

// 组装完整报文
Msg210X12 message = new Msg210X12()
    .setIsa(buildIsa("SENDER", "RECEIVER", "260428", "1420", "000000001"))
    .setGs(buildGs("SENDER", "RECEIVER", "20260428", "1420", "000000001"))
    .setMsg210(Collections.singletonList(msg210))
    .setGe(new Ge().setGe01("1").setGe02("000000001"))
    .setIea(new Iea().setIea01("1").setIea02("000000001"));

String ediOutput = factory.toEDI(message);
```

### 5.3 EDI 850 — 采购订单

```java
Msg850X12Factory factory = Msg850X12Factory.getInstance();

// 构建行项目
List<Po1Group> lineItems = new ArrayList<>();
Po1Group line1 = new Po1Group()
    .setPo1(new Po1()
        .setPo101("1")        // 行号
        .setPo102("100")      // 数量
        .setPo103("EA")       // 单位（EA=个）
        .setPo104("25.00")    // 单价
        .setPo106("VP")       // 商品 ID 类型（VP=供应商料号）
        .setPo107("SKU-12345")); // 商品编号
lineItems.add(line1);

// 构建收货方
N1Group shipTo = new N1Group()
    .setN1(new N1().setN101("ST").setN102("BUYER WAREHOUSE"))
    .setN3(Collections.singletonList(new N3().setN301("456 WAREHOUSE RD")))
    .setN4(new N4().setN401("LOS ANGELES").setN402("CA").setN403("90001").setN404("US"));

// 构建事务集
Msg850 msg850 = new Msg850()
    .setSt(new St().setSt01("850").setSt02("000000001"))
    .setBeg(new Beg()
        .setBeg01("00")         // 事务目的（00=原始）
        .setBeg02("SA")         // 订单类型（SA=标准订单）
        .setBeg03("PO-20260001") // 采购订单号
        .setBeg05("20260428"))  // 订单日期
    .setPo1Group(lineItems)
    .setN1Group(Collections.singletonList(shipTo))
    .setSe(new Se().setSe01("0").setSe02("000000001"));

Msg850X12 message = new Msg850X12()
    .setIsa(buildIsa("BUYER", "SUPPLIER", "260428", "1420", "000000001"))
    .setGs(buildGs("BUYER", "SUPPLIER", "20260428", "1420", "000000001"))
    .setMsg850(Collections.singletonList(msg850))
    .setGe(new Ge().setGe01("1").setGe02("000000001"))
    .setIea(new Iea().setIea01("1").setIea02("000000001"));

String ediOutput = factory.toEDI(message);
```

### 5.4 EDI 997 — 功能确认

```java
Msg997X12Factory factory = Msg997X12Factory.getInstance();

// AK2 = 被确认的事务集
Ak2Group ak2 = new Ak2Group()
    .setAk2(new Ak2().setAk201("850").setAk202("000000001")) // 确认的是 850 报文
    .setAk5(new Ak5().setAk501("A")); // A=接受

// AK1/AK9 = 功能组头尾
Msg997 msg997 = new Msg997()
    .setSt(new St().setSt01("997").setSt02("000000001"))
    .setAk1(new Ak1().setAk101("PO").setAk102("000000001")) // PO=采购订单功能组
    .setAk2Group(Collections.singletonList(ak2))
    .setAk9(new Ak9()
        .setAk901("A")    // A=接受
        .setAk902("1")    // 收到事务集数
        .setAk903("1")    // 接受数
        .setAk904("0"))   // 拒绝数
    .setSe(new Se().setSe01("0").setSe02("000000001"));

Msg997X12 message = new Msg997X12()
    .setIsa(buildIsa("RECEIVER", "SENDER", "260428", "1420", "000000002"))
    .setGs(buildGs("RECEIVER", "SENDER", "20260428", "1420", "000000002"))
    .setMsg997(Collections.singletonList(msg997))
    .setGe(new Ge().setGe01("1").setGe02("000000002"))
    .setIea(new Iea().setIea01("1").setIea02("000000002"));

String ediOutput = factory.toEDI(message);
```

### 5.5 一个功能组包含多条事务

```java
// 在同一个功能组（GS...GE）内批量生成多条 210
List<Msg210> messages = new ArrayList<>();
for (int i = 1; i <= 3; i++) {
    messages.add(new Msg210()
        .setSt(new St().setSt01("210").setSt02(String.format("%09d", i)))
        .setB3(buildB3ForInvoice(i))
        .setSe(new Se().setSe01("0").setSe02(String.format("%09d", i))));
}

Msg210X12 batch = new Msg210X12()
    .setIsa(buildIsa(...))
    .setGs(buildGs(...))
    .setMsg210(messages)  // 多条事务集
    .setGe(new Ge().setGe01(String.valueOf(messages.size())).setGe02("000000001"))
    .setIea(new Iea().setIea01("1").setIea02("000000001"));
```

---

## 6. 支持的报文类型

| 报文 | Factory 类 | 消息根类 | GS01 | 备注 |
|------|-----------|---------|------|------|
| **110** Air Freight Way Bill | `Msg110X12Factory` | `Msg110X12` | `IM` | 空运提单 |
| **210** Motor Carrier Invoice | `Msg210X12Factory` | `Msg210X12` | `IM` | 陆运货运发票 |
| **214** Shipment Status | `Msg214X12Factory` | `Msg214X12` | `QS` | 运输状态 |
| **300** Shipping Information | `Msg300X12Factory` | `Msg300X12` | `SM` | 航运信息 |
| **301** Shipment Details | `Msg301X12Factory` | `Msg301X12` | `SM` | 装运明细 |
| **304** Bill of Lading | `Msg304X12Factory` | `Msg304X12` | `SM` | 提单 |
| **310** Freight Receipt and Invoice (Ocean) | `Msg310X12Factory` | `Msg310X12` | `IM` | 海运货运发票 |
| **315** Status Information | `Msg315X12Factory` | `Msg315X12` | `QS` | 状态信息 |
| **850** Purchase Order | `Msg850X12Factory` | `Msg850X12` | `PO` | 采购订单 |
| **861** Receiving Advice | `Msg861X12Factory` | `Msg861X12` | `RC` | 收货确认 |
| **997** Functional Acknowledgment | `Msg997X12Factory` | `Msg997X12` | `FA` | 功能确认 |

所有类均位于 `com.pobing.edi.platform.x12.v4010` 包下。

---

## 7. 信封字段说明

### ISA 段（16个字段）

| 字段 | 典型值 | 说明 |
|------|--------|------|
| isa01 | `"00"` | 授权信息限定符（固定） |
| isa02 | `"          "` | 授权信息（10个空格，固定） |
| isa03 | `"00"` | 安全信息限定符（固定） |
| isa04 | `"          "` | 安全信息（10个空格，固定） |
| isa05 | `"ZZ"` | 发送方 ID 类型（ZZ=自定义） |
| isa06 | `"SENDER         "` | 发送方 ID（**左对齐，右补空格至15位**） |
| isa07 | `"ZZ"` | 接收方 ID 类型 |
| isa08 | `"RECEIVER       "` | 接收方 ID（**左对齐，右补空格至15位**） |
| isa09 | `"260428"` | 交换日期（YYMMDD） |
| isa10 | `"1420"` | 交换时间（HHMM） |
| isa11 | `"U"` | 标准 ID（固定） |
| isa12 | `"00401"` | X12 版本号（固定） |
| isa13 | `"000000001"` | 交换控制号（唯一，9位数字） |
| isa14 | `"0"` | 确认请求（0=不需要） |
| isa15 | `"P"` | 环境（P=生产，T=测试） |
| isa16 | `">"` | 复合子元素分隔符（固定） |

> **重要：** isa06 和 isa08 必须补空格至 **15位**，否则 EDI 解析会失败。

### GS 段（8个字段）

| 字段 | 说明 |
|------|------|
| gs01 | 功能标识码（见上方表格） |
| gs02 | 应用发送方编码 |
| gs03 | 应用接收方编码 |
| gs04 | 日期（CCYYMMDD，如 `20260428`） |
| gs05 | 时间（HHMM） |
| gs06 | 组控制号（与 GE02 一致） |
| gs07 | `"X"`（固定） |
| gs08 | `"004010"`（固定） |

---

## 8. 常见业务段字段说明

### N1 段 — 参与方标识

| 字段 | 说明 | 常用代码 |
|------|------|---------|
| n101 | 参与方角色 | `SH`=发货方, `CN`=收货方, `ST`=收货地址, `BY`=买方, `SF`=发货地址, `BT`=账单地址 |
| n102 | 参与方名称 | |
| n103 | ID 类型 | `9`=DUNS, `ZZ`=自定义 |
| n104 | ID 值 | |

### B3 段 — 货运发票头（用于 MSG210）

| 字段 | 说明 |
|------|------|
| b302 | 提单号/发票号 |
| b303 | 费用支付方式（`CC`=到付, `PP`=预付） |
| b309 | 发票日期（CCYYMMDD） |

### Po1 段 — 采购行项目（用于 MSG850）

| 字段 | 说明 |
|------|------|
| po101 | 行号 |
| po102 | 数量 |
| po103 | 计量单位（`EA`=个, `CA`=箱, `DZ`=打） |
| po104 | 单价 |
| po105 | 价格基础（`PE`=每件） |
| po106 | 商品 ID 类型（`VP`=供应商料号, `BP`=买方料号, `UP`=UPC） |
| po107 | 商品 ID 值 |

### L1 段 — 运费明细（用于 MSG110/MSG210/MSG304）

| 字段 | 说明 |
|------|------|
| l101 | 运费条目序号 |
| l104 | 运费金额 |
| l107 | 费用类型代码 |
| l108 | 费用描述 |

---

## 9. 自定义分隔符

如果对方系统使用非标准分隔符，可通过以下方式指定：

```java
import com.pobing.edi.platform.x12.util.X12Util;
import org.milyn.edisax.model.internal.Delimiters;

// 使用 | 作为字段分隔符（非标准）
Delimiters delimiters = X12Util.createDelimiters("~", "|");
Msg210X12Factory factory = Msg210X12Factory.getInstance(delimiters);

// 解析和生成都会使用该分隔符
Msg210X12 parsed = factory.fromEDI(ediWithPipeDelimiters);
String output    = factory.toEDI(parsed);
```

标准 X12 分隔符（`~` + `*`）无需额外配置，直接调用无参 `getInstance()` 即可。

---

## 10. 最佳实践与注意事项

### Factory 单例管理

Factory 初始化耗时约 **200–500 ms**（加载 XML 配置、初始化解析引擎）。

**推荐做法（Spring 环境）：**

```java
@Configuration
public class X12FactoryConfig {

    @Bean
    public Msg210X12Factory msg210X12Factory() throws IOException, SAXException {
        return Msg210X12Factory.getInstance();
    }

    @Bean
    public Msg850X12Factory msg850X12Factory() throws IOException, SAXException {
        return Msg850X12Factory.getInstance();
    }

    // 按需注册其他 Factory
}
```

**非 Spring 环境：**

```java
// 使用静态成员或 enum 单例，避免重复初始化
private static final Msg210X12Factory FACTORY;
static {
    try {
        FACTORY = Msg210X12Factory.getInstance();
    } catch (Exception e) {
        throw new ExceptionInInitializerError(e);
    }
}
```

### SE 段计数

生成报文时，`Se.se01`（段计数）**无需手动计算**，SDK 会在 `toEDI()` 时自动更新为正确值。构建时填 `"0"` 或任意值均可。

### ISA06 / ISA08 补位

ISA 发送方/接收方 ID 必须是 **15 位**，不足时需右补空格：

```java
// 工具方法
private String padRight(String s, int length) {
    return String.format("%-" + length + "s", s);
}
// 示例: padRight("SENDER", 15) → "SENDER         "
```

### 空字段处理

- Java 对象中字段为 `null` → 生成 EDI 时该字段被**省略**（尾部截断）
- 如需保留占位，设为空字符串 `""` — 但注意 SDK 对尾部连续空字段仍会截断
- 业务必填字段请确保在生成前完成校验，SDK 不做强制约束

### 字段类型

所有字段均为 `String` 类型，**类型转换和合法性校验由接入方负责**：

```java
// 金额、数量等数值字段需自行解析
BigDecimal price = new BigDecimal(line.getPo1().getPo104());
int quantity = Integer.parseInt(line.getPo1().getPo102());
```

### 字符编码

SDK 内部统一使用 **UTF-8** 处理 EDI 字符串，接入方传入 `String` 时无需额外转码。

---

## 11. 常见问题

**Q: `getInstance()` 报 `SAXException`，怎么处理？**

通常是 classpath 中缺少 SDK 的资源文件（XML 配置）。确认 `edi-x12` JAR 已正确加入依赖，且 Smooks 相关依赖（`milyn-smooks-edi:1.7.0`、`milyn-smooks-javabean:1.7.0`）也已引入。

---

**Q: `fromEDI()` 解析后某些字段为 `null`，但 EDI 原文中有值？**

检查段分隔符是否匹配。对方系统可能使用了非标准分隔符，需通过 `X12Util.createDelimiters()` 指定正确分隔符后再获取 Factory 实例。

---

**Q: 生成的 EDI 字符串 SE 段计数不对？**

`toEDI()` 内部的 `postProcess` 会自动更新 SE01，**无需手动赋值**。若发现异常，检查是否直接调用了 `write()` 方法而绕过了 `toEDI()`。

---

**Q: 一条 EDI 报文中可以包含多条事务集吗？**

可以。将多个 `MsgXXXX` 对象放入 `List<MsgXXXX>` 即可，同时 `GE01` 需设置为事务集数量。参见 [5.5 节](#55-一个功能组包含多条事务)。

---

**Q: 如何区分同一段组中不同角色的 N1（发货方/收货方）？**

通过 `N1.n101` 字段的角色代码区分，常用值见 [8节 N1 段说明](#8-常见业务段字段说明)。

---

**Q: 测试环境和生产环境如何区分？**

通过 `ISA15` 字段：`"T"` = 测试环境，`"P"` = 生产环境。

---

*本文档基于 `edi-x12 v0.0.4`，分支 `develop/develop-v1.0.8`。如有字段或报文类型相关问题，请联系 EDI 平台团队。*
