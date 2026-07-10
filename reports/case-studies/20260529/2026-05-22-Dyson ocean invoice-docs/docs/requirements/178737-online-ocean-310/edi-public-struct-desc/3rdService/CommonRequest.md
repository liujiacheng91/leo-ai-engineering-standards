
# CommonRequest 说明文档

## 1. 概述

`CommonRequest` 是 EDI 平台通用请求模型，封装了请求的头部信息和请求主体。与 `DispatcherRequest`（基于接口+多态推导的设计）不同，`CommonRequest` 采用纯类（Class）设计，提供 **Builder 构建者模式**，使用更加简洁直观，适合 SDK 外部调用方直接使用。

- **包路径**：`com.pobing.basic.common`
- **类型**：类（Class）
- **设计模式**：Builder 构建者模式

---

## 2. 类图结构

```
CommonRequest
├── RequestHeader (请求头部)
│   └── RequestScope (请求作用域)
└── RequestBody (请求主体)
```

---

## 3. CommonRequest 类

### 定义

```java
public class CommonRequest
```

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `requestHeader` | `RequestHeader` | 请求头部信息 |
| `requestBody` | `RequestBody` | 请求主体 |

### 构造方法

| 构造方法 | 说明 |
|---------|------|
| `CommonRequest()` | 无参构造 |
| `CommonRequest(RequestHeader requestHeader, RequestBody requestBody)` | 全参构造 |
| `CommonRequest(Builder builder)` | Builder 构造 |

### 方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getRequestHeader()` | `RequestHeader` | 获取请求头部信息 |
| `setRequestHeader(RequestHeader)` | `void` | 设置请求头部信息 |
| `getRequestBody()` | `RequestBody` | 获取请求主体 |
| `setRequestBody(RequestBody)` | `void` | 设置请求主体 |

### Builder 内部类

`CommonRequest` 提供了静态内部类 `Builder`，支持链式调用构建对象。

| Builder 方法 | 返回类型 | 说明 |
|-------------|---------|------|
| `requestHeader(RequestHeader)` | `Builder` | 设置请求头部信息 |
| `requestBody(RequestBody)` | `Builder` | 设置请求主体 |
| `build()` | `CommonRequest` | 构建 CommonRequest 实例 |

### 使用示例

```java
// 方式一：Builder 构建（推荐）
CommonRequest request = new CommonRequest.Builder()
    .requestHeader(header)
    .requestBody(body)
    .build();

// 方式二：Setter 设置
CommonRequest request = new CommonRequest();
request.setRequestHeader(header);
request.setRequestBody(body);

// 方式三：全参构造
CommonRequest request = new CommonRequest(header, body);
```

---

## 4. 关联类：RequestHeader（请求头部）

### 定义

```java
@JsonIgnoreProperties(ignoreUnknown = true)
public class RequestHeader
```

- **包路径**：`com.pobing.basic.common`

### 注解说明

- **@JsonIgnoreProperties(ignoreUnknown = true)**：反序列化时忽略未知属性，增强前后端兼容性。

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `requestScope` | `RequestScope` | 请求作用域 |
| `requestServiceType` | `Integer` | 请求服务类型（参考 `DispatcherRequestServiceType`） |
| `requestDirectionType` | `Integer` | 请求方向类型（参考 `DispatcherRequestDirectionType`） |
| `requestHandleStrategyType` | `Integer` | 请求处理策略类型（参考 `DispatcherHandleStrategyType`） |
| `appKey` | `String` | 应用标识 |
| `signature` | `String` | 签名 |
| `businessKey` | `String` | 业务标识 |
| `traceId` | `String` | 链路追踪ID |
| `station` | `String` | 站点 |
| `region` | `String` | 区域 |
| `fileName` | `String` | 文件名 |
| `timestamp` | `Long` | 时间戳 |

### Builder 内部类

| Builder 方法 | 返回类型 | 说明 |
|-------------|---------|------|
| `requestScope(RequestScope)` | `Builder` | 设置请求作用域 |
| `requestServiceType(Integer)` | `Builder` | 设置请求服务类型 |
| `requestDirectionType(Integer)` | `Builder` | 设置请求方向类型 |
| `requestHandleStrategyType(Integer)` | `Builder` | 设置请求处理策略类型 |
| `appKey(String)` | `Builder` | 设置应用标识 |
| `signature(String)` | `Builder` | 设置签名 |
| `businessKey(String)` | `Builder` | 设置业务标识 |
| `traceId(String)` | `Builder` | 设置链路追踪ID |
| `region(String)` | `Builder` | 设置区域 |
| `station(String)` | `Builder` | 设置站点 |
| `fileName(String)` | `Builder` | 设置文件名 |
| `timestamp(Long)` | `Builder` | 设置时间戳 |
| `build()` | `RequestHeader` | 构建 RequestHeader 实例 |

### 使用示例

```java
RequestHeader header = new RequestHeader.Builder()
    .requestScope(scope)
    .requestServiceType(1)
    .requestDirectionType(1)
    .requestHandleStrategyType(1)
    .appKey("app_key_123")
    .signature("abc123def456")
    .businessKey("BIZ_001")
    .traceId("trace-uuid-001")
    .station("SHANGHAI")
    .region("CN-EAST")
    .fileName("order_20240101.xml")
    .timestamp(1704067200000L)
    .build();
```

---

## 5. 关联类：RequestBody（请求主体）

### 定义

```java
public class RequestBody
```

- **包路径**：`com.pobing.basic.common`

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `businessContent` | `String` | 业务数据体 |
| `messageFormat` | `String` | 消息格式 |

### 构造方法

| 构造方法 | 说明 |
|---------|------|
| `RequestBody()` | 无参构造 |
| `RequestBody(String businessContent, String messageFormat)` | 全参构造 |
| `RequestBody(Builder builder)` | Builder 构造 |

### Builder 内部类

| Builder 方法 | 返回类型 | 说明 |
|-------------|---------|------|
| `businessContent(String)` | `Builder` | 设置业务数据体 |
| `messageFormat(String)` | `Builder` | 设置消息格式 |
| `build()` | `RequestBody` | 构建 RequestBody 实例 |

### 使用示例

```java
RequestBody body = new RequestBody.Builder()
    .businessContent("<Order><Item>...</Item></Order>")
    .messageFormat("XML")
    .build();
```

---

## 6. 关联类：RequestScope（请求作用域）

### 定义

```java
public class RequestScope
```

- **包路径**：`com.pobing.basic.common`

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `sceneCode` | `String` | 场景编码 |
| `sceneVersion` | `String` | 场景版本 |
| `customerCode` | `String` | 客户编码 |
| `customerScope` | `String` | 客户作用域 |

### 构造方法

| 构造方法 | 说明 |
|---------|------|
| `RequestScope()` | 无参构造 |
| `RequestScope(String sceneCode, String sceneVersion, String customerCode, String customerScope)` | 全参构造 |
| `RequestScope(Builder builder)` | Builder 构造 |

### Builder 内部类

| Builder 方法 | 返回类型 | 说明 |
|-------------|---------|------|
| `sceneCode(String)` | `Builder` | 设置场景编码 |
| `sceneVersion(String)` | `Builder` | 设置场景版本 |
| `customerCode(String)` | `Builder` | 设置客户编码 |
| `customerScope(String)` | `Builder` | 设置客户作用域 |
| `build()` | `RequestScope` | 构建 RequestScope 实例 |

### 使用示例

```java
RequestScope scope = new RequestScope.Builder()
    .sceneCode("SCENE_001")
    .sceneVersion("1.0")
    .customerCode("CUST_001")
    .customerScope("GLOBAL")
    .build();
```

---

## 7. 完整使用示例

```java
// 构建请求作用域
RequestScope scope = new RequestScope.Builder()
    .sceneCode("SCENE_001")
    .sceneVersion("1.0")
    .customerCode("CUST_001")
    .customerScope("GLOBAL")
    .build();

// 构建请求头部
RequestHeader header = new RequestHeader.Builder()
    .requestScope(scope)
    .requestServiceType(1)
    .requestDirectionType(1)
    .requestHandleStrategyType(1)
    .appKey("app_key_123")
    .signature("abc123def456")
    .businessKey("BIZ_001")
    .traceId("trace-uuid-001")
    .station("SHANGHAI")
    .region("CN-EAST")
    .fileName("order_20240101.xml")
    .timestamp(1704067200000L)
    .build();

// 构建请求主体
RequestBody body = new RequestBody.Builder()
    .businessContent("<Order><Item>...</Item></Order>")
    .messageFormat("XML")
    .build();

// 构建完整请求
CommonRequest request = new CommonRequest.Builder()
    .requestHeader(header)
    .requestBody(body)
    .build();
```

---

## 8. JSON 示例

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

## 9. 子类说明

经代码库全量搜索，**`CommonRequest` 当前没有任何子类**。该类为叶子类，直接实例化使用。

---

## 10. 与 DispatcherRequest 的对比

| 特性 | CommonRequest | DispatcherRequest |
|------|--------------|-------------------|
| 类型 | 类（Class） | 接口（Interface） |
| 设计模式 | Builder 构建者模式 | Jackson 多态推导 |
| 头部类型 | `common.RequestHeader`（类） | `definition.RequestHeader`（接口） |
| 主体类型 | `common.RequestBody`（类） | `definition.RequestBody`（接口） |
| 作用域类型 | `common.RequestScope`（类） | `scope.RequestScope`（接口） |
| 多态支持 | 不支持 | 支持（@JsonSubTypes） |
| 适用场景 | SDK 外部调用方，简单直接 | 内部调度系统，需多态扩展 |
| 容错注解 | 仅 RequestHeader 有 @JsonIgnoreProperties | 所有实现类均有 @JsonIgnoreProperties 和 @JsonInclude |

两者数据结构完全一致，`CommonRequest` 是面向 SDK 用户的简化版，省去了接口和多态的复杂性，提供 Builder 模式方便链式构建；`DispatcherRequest` 是面向内部框架的扩展版，支持 Jackson 多态反序列化，便于框架内部扩展不同的请求实现。
