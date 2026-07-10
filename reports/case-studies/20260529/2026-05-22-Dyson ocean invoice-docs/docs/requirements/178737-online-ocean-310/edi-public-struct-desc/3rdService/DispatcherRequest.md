
# DispatcherRequest 说明文档

## 1. 概述

`DispatcherRequest` 是 EDI 平台调度请求的顶层接口，定义了调度请求的核心数据结构。一个调度请求由 **请求头部信息（RequestHeader）** 和 **请求主体（RequestBody）** 两部分组成。

- **包路径**：`com.pobing.basic.request`
- **类型**：接口（Interface）
- **序列化方式**：使用 Jackson 的 `@JsonTypeInfo(use = JsonTypeInfo.Id.DEDUCTION)` 注解，基于类型推导（Deduction）进行多态反序列化，无需显式类型标识字段，根据 JSON 属性自动推断具体子类型。

---

## 2. 类图结构

```
DispatcherRequest (接口)
└── DispatcherRequestActualize (实现类)
    ├── RequestHeaderActualize (请求头部实现)
    │   └── RequestScope (请求作用域接口)
    │       └── RequestScopeActualize (作用域实现)
    └── RequestBodyActualize (请求主体实现)
```

---

## 3. DispatcherRequest 接口

### 定义

```java
@JsonTypeInfo(use = JsonTypeInfo.Id.DEDUCTION)
@JsonSubTypes({@JsonSubTypes.Type(DispatcherRequestActualize.class)})
public interface DispatcherRequest
```

### 方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getRequestHeader()` | `RequestHeader` | 获取请求头部信息 |
| `getRequestBody()` | `RequestBody` | 获取请求主体 |

### 注解说明

- **@JsonTypeInfo(use = JsonTypeInfo.Id.DEDUCTION)**：Jackson 类型推导机制，反序列化时根据 JSON 中存在的字段自动推断具体子类型，无需在 JSON 中包含 `@type` 等类型标识字段。
- **@JsonSubTypes**：声明可能的子类型为 `DispatcherRequestActualize`。

---

## 4. 子类：DispatcherRequestActualize

### 定义

```java
public class DispatcherRequestActualize implements DispatcherRequest
```

- **包路径**：`com.pobing.basic.request`

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `requestHeader` | `RequestHeaderActualize` | 请求头部信息 |
| `requestBody` | `RequestBodyActualize` | 请求主体 |

### 构造方法

| 构造方法 | 说明 |
|---------|------|
| `DispatcherRequestActualize()` | 无参构造 |
| `DispatcherRequestActualize(RequestHeaderActualize requestHeader, RequestBodyActualize requestBody)` | 全参构造 |

### 方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getRequestHeader()` | `RequestHeader` | 获取请求头部信息（实现接口方法） |
| `getRequestBody()` | `RequestBody` | 获取请求主体（实现接口方法） |
| `setRequestHeader(RequestHeaderActualize)` | `void` | 设置请求头部信息 |
| `setRequestBody(RequestBodyActualize)` | `void` | 设置请求主体 |

---

## 5. 关联类：RequestHeader（请求头部接口）

### 定义

```java
@JsonTypeInfo(use = JsonTypeInfo.Id.DEDUCTION)
@JsonSubTypes({@JsonSubTypes.Type(RequestHeaderActualize.class)})
public interface RequestHeader
```

- **包路径**：`com.pobing.basic.request.definition`

### 方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getRequestScope()` | `RequestScope` | 获取请求作用域 |
| `getRequestDirectionType()` | `Integer` | 获取请求的数据方向类型（参考 `DispatcherRequestDirectionType`） |
| `getRequestServiceType()` | `Integer` | 获取请求服务类型（参考 `DispatcherRequestServiceType`） |
| `getRequestHandleStrategyType()` | `Integer` | 获取请求处理策略类型（参考 `DispatcherHandleStrategyType`） |
| `getAppKey()` | `String` | 获取应用标识 |
| `getSignature()` | `String` | 获取签名 |
| `getBusinessKey()` | `String` | 获取业务标识 |
| `getTraceId()` | `String` | 获取链路追踪ID |
| `getStation()` | `String` | 获取站点 |
| `getRegion()` | `String` | 获取区域 |
| `getFileName()` | `String` | 获取文件名 |
| `getTimestamp()` | `Long` | 获取时间戳 |

---

## 6. 关联类：RequestHeaderActualize（请求头部实现）

### 定义

```java
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class RequestHeaderActualize implements RequestHeader
```

- **包路径**：`com.pobing.basic.request.realization`

### 注解说明

- **@JsonIgnoreProperties(ignoreUnknown = true)**：反序列化时忽略未知属性，增强兼容性。
- **@JsonInclude(JsonInclude.Include.NON_NULL)**：序列化时忽略 null 值字段。

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `requestScope` | `RequestScope` | 请求作用域 |
| `requestServiceType` | `Integer` | 请求服务类型 |
| `requestDirectionType` | `Integer` | 请求方向类型 |
| `requestHandleStrategyType` | `Integer` | 请求处理策略类型 |
| `appKey` | `String` | 应用标识 |
| `signature` | `String` | 签名 |
| `businessKey` | `String` | 业务标识 |
| `traceId` | `String` | 链路追踪ID |
| `station` | `String` | 站点 |
| `region` | `String` | 区域 |
| `fileName` | `String` | 文件名 |
| `timestamp` | `Long` | 时间戳 |

---

## 7. 关联类：RequestBody（请求主体接口）

### 定义

```java
@JsonTypeInfo(use = JsonTypeInfo.Id.DEDUCTION)
@JsonSubTypes({@JsonSubTypes.Type(RequestBodyActualize.class)})
public interface RequestBody
```

- **包路径**：`com.pobing.basic.request.definition`

### 方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getBusinessContent()` | `String` | 获取业务数据内容 |
| `getMessageFormat()` | `String` | 获取消息格式 |

---

## 8. 关联类：RequestBodyActualize（请求主体实现）

### 定义

```java
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class RequestBodyActualize implements RequestBody
```

- **包路径**：`com.pobing.basic.request.realization`

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `businessContent` | `String` | 业务数据体 |
| `messageFormat` | `String` | 消息格式 |

---

## 9. 关联类：RequestScope（请求作用域接口）

### 定义

```java
@JsonTypeInfo(use = JsonTypeInfo.Id.DEDUCTION)
@JsonSubTypes({@JsonSubTypes.Type(RequestScopeActualize.class)})
public interface RequestScope
```

- **包路径**：`com.pobing.basic.request.scope`

### 方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getSceneCode()` | `String` | 获取场景编码 |
| `getSceneVersion()` | `String` | 获取场景版本 |
| `getCustomerCode()` | `String` | 获取客户编码 |
| `getCustomerScope()` | `String` | 获取客户作用域 |

---

## 10. JSON 示例

```json
{
  "requestHeader": {
    "requestScope": {
      "sceneCode": "SCENE_001",
      "sceneVersion": "1.0",
      "customerCode": "CUST_001",
      "customerScope": "GLOBAL"
    },
    "requestServiceType": 1,
    "requestDirectionType": 1,
    "requestHandleStrategyType": 1,
    "appKey": "app_key_123",
    "signature": "abc123def456",
    "businessKey": "BIZ_001",
    "traceId": "trace-uuid-001",
    "station": "SHANGHAI",
    "region": "CN-EAST",
    "fileName": "order_20240101.xml",
    "timestamp": 1704067200000
  },
  "requestBody": {
    "businessContent": "<Order><Item>...</Item></Order>",
    "messageFormat": "XML"
  }
}
```

---

## 11. 设计说明

1. **接口与实现分离**：`DispatcherRequest`、`RequestHeader`、`RequestBody`、`RequestScope` 均采用接口定义，具体实现分别放在 `realization` 包中，便于扩展不同的实现方式。

2. **Jackson 多态推导**：所有接口均使用 `@JsonTypeInfo(use = JsonTypeInfo.Id.DEDUCTION)` 注解，实现基于属性的类型推导反序列化，JSON 中无需包含类型标识字段，保持数据结构简洁。

3. **容错设计**：实现类均使用 `@JsonIgnoreProperties(ignoreUnknown = true)` 忽略未知属性，`@JsonInclude(JsonInclude.Include.NON_NULL)` 忽略空值，增强了前后端数据交互的兼容性。

4. **模块职责**：
   - `definition` 包：定义接口契约
   - `realization` 包：提供默认实现
   - `scope` 包：定义请求作用域
