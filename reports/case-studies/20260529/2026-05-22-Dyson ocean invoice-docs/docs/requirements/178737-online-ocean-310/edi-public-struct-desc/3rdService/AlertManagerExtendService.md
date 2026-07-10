
## 概述

`AlertManagerExtendService` 是告警服务的扩展版本接口，支持多种告警信息推送方式，包括：
- 基于配置的告警推送
- 自定义参数的告警推送
- 配置+自定义参数组合的告警推送

该接口主要用于邮件告警通知的发送，支持模板化邮件内容、自定义收件人和抄送人，以及附件发送等功能。

**作者**: wenhz  
**创建时间**: 2025-03-13

## 接口方法

### 1. sendMail4Template

```java
public Revert sendMail4Template(String routerCode, Map<String,String> params)
```

**功能说明**:  
依据配置代码进行邮件发送，仅支持配置，不带文件。系统会依据配置代码查询配置的模板、收件人、抄送人，并用params中的参数对邮件模板进行值替换，然后发送邮件。

**参数说明**:
- `routerCode`: 配置代码，用于查询邮件模板和收件人配置
- `params`: 参数Map，用于替换邮件模板中的变量。注意：参数名必须与配置的邮件模板中的参数名一致

**返回值**: `Revert` - 发送结果对象

**注意事项**:
- 模板是固定格式，包含subject和content的定义
- params中的参数名必须与邮件模板中的参数名完全一致

---

### 2. sendMail4TemplateExtend

```java
public Revert sendMail4TemplateExtend(String routerCode, Map<String,String> params, String mailTo, String copyTo)
```

**功能说明**:  
依据配置代码+自定义的接收人、抄送人进行邮件发送，但不带文件。系统会依据配置代码查询配置的模板，并使用自定义的收件人和抄送人发送邮件。

**参数说明**:
- `routerCode`: 配置代码，允许为空。为空时，使用传入的收件人和抄送人
- `params`: 参数Map，用于替换邮件模板中的变量
- `mailTo`: 收件人，允许为空。为空时，使用配置中的收件人
- `copyTo`: 抄送人，允许为空。为空时，使用配置中的抄送人

**返回值**: `Revert` - 发送结果对象

**注意事项**:
- routerCode、mailTo和copyTo不能同时为空
- params中的参数名必须与邮件模板中的参数名完全一致
- 模板是固定格式，包含subject和content的定义

---

### 3. sendMail4TemplateWithFile

```java
public Revert sendMail4TemplateWithFile(String routerCode, Map<String,String> params, List<File> files)
```

**功能说明**:  
依据配置代码进行带附件的邮件通知发送。系统会依据配置代码查询配置的模板、收件人、抄送人，并用params中的参数对邮件模板进行值替换，然后发送带附件的邮件。

**参数说明**:
- `routerCode`: 配置代码，用于查询邮件模板和收件人配置
- `params`: 参数Map，用于替换邮件模板中的变量
- `files`: 附件文件列表

**返回值**: `Revert` - 发送结果对象

**注意事项**:
- params中的参数名必须与邮件模板中的参数名完全一致
- 模板是固定格式，包含subject和content的定义
- 支持发送多个附件文件

---

### 4. sendMail4TemplateWithFileExtend

```java
public Revert sendMail4TemplateWithFileExtend(String routerCode, Map<String,String> params, String mailTo, String copyTo, List<File> files)
```

**功能说明**:  
依据配置代码+自定义的接收人、抄送人，进行带附件的邮件通知发送。系统会依据配置代码查询配置的模板，并使用自定义的收件人和抄送人发送带附件的邮件。

**参数说明**:
- `routerCode`: 配置代码，允许为空。为空时，使用传入的收件人和抄送人
- `params`: 参数Map，用于替换邮件模板中的变量
- `mailTo`: 收件人，允许为空。为空时，使用配置中的收件人
- `copyTo`: 抄送人，允许为空。为空时，使用配置中的抄送人
- `files`: 附件文件列表

**返回值**: `Revert` - 发送结果对象

**注意事项**:
- routerCode、mailTo和copyTo不能同时为空
- params中的参数名必须与邮件模板中的参数名完全一致
- 模板是固定格式，包含subject和content的定义
- 支持发送多个附件文件

## 使用示例

### 示例1: 使用模板发送简单邮件

```java
Map<String, String> params = new HashMap<>();
params.put("subject", "主题");
params.put("content", "邮件正文内容");

Revert result = alertManagerExtendService.sendMail4Template("ORDER_NOTIFY", params);
```

### 示例2: 自定义收件人发送邮件

```java
Map<String, String> params = new HashMap<>();
params.put("subject", "主题");
params.put("content", "邮件正文内容");

Revert result = alertManagerExtendService.sendMail4TemplateExtend(
    "ALERT_NOTIFY", 
    params, 
    "lisi@example.com", 
    "manager@example.com"
);
```

### 示例3: 发送带附件的邮件

```java
Map<String, String> params = new HashMap<>();
params.put("subject", "主题");
params.put("content", "邮件正文内容");

List<File> files = new ArrayList<>();
files.add(new File("D:/reports/daily_report.xlsx"));

Revert result = alertManagerExtendService.sendMail4TemplateWithFile(
    "REPORT_NOTIFY", 
    params, 
    files
);
```

### 示例4: 自定义收件人发送带附件的邮件

```java
Map<String, String> params = new HashMap<>();
params.put("subject", "主题");
params.put("content", "邮件正文内容");

List<File> files = new ArrayList<>();
files.add(new File("D:/documents/contract.pdf"));

Revert result = alertManagerExtendService.sendMail4TemplateWithFileExtend(
    "CONTRACT_NOTIFY", 
    params, 
    "wangwu@example.com", 
    "legal@example.com", 
    files
);
```

## 通用说明

### 模板格式
邮件模板采用固定格式，必须包含以下两个部分：
- `subject`: 邮件主题
- `content`: 邮件内容

模板中的参数使用 `${paramName}` 格式进行占位，例如：
```
subject: 订单${orderNo}通知
content: 尊敬的${userName}，您的订单${orderNo}已处理完成。
```

### 参数替换规则
- params中的参数名必须与模板中的占位符名称完全一致
- 参数值会自动替换模板中对应的占位符
- 未提供参数值的占位符将保持原样或替换为空字符串（取决于具体实现）

### 返回值说明
所有方法均返回 `Revert` 对象，包含以下信息：
- 发送状态（成功/失败）
- 错误信息（如果发送失败）
- 其他相关信息

## 版本历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0.0 | 2025-03-13 | wenhz | 初始版本 |
