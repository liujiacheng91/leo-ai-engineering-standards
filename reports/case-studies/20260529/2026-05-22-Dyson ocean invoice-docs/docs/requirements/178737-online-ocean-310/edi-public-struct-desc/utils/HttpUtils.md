# HttpUtils 工具类说明文档

## 1. 概述
`HttpUtils` 是基于 OkHttp 封装的 HTTP 客户端工具类，提供了便捷的 GET 和 POST 请求方法。该工具类内置了客户端连接池缓存机制与共享线程池，支持自定义超时时间、请求头、请求参数以及响应对象的泛型反序列化，旨在简化 HTTP 调用并统一返回结构 `Revert`。

## 2. 基本信息
- **类名**: `HttpUtils`
- **包路径**: `com.pobing.web`
- **作者**: wenhz
- **创建日期**: 2025-11-12

## 3. 核心设计
- **客户端缓存 (`CLIENT_CACHE`)**: 使用 `ConcurrentHashMap` 缓存 `OkHttpClient` 实例，以 `connectTimeout:readTimeout:writeTimeout` 作为 Key，避免重复创建连接池资源。
- **共享线程池 (`SHARED_POOL`)**: 初始化核心线程数为 16 的守护线程池，供所有 `OkHttpClient` 实例的 `Dispatcher` 共享，控制最大并发量。
- **统一响应处理 (`transformResponse`)**: 对 OkHttp 的 `Response` 进行统一处理，根据传入的 `Class<T>` 自动将响应体反序列化为指定对象，并封装为统一的 `Revert` 响应结构。

## 4. 构造方法

| 方法签名 | 说明 |
|--------|------|
| `HttpUtils()` | 默认构造方法，连接、读取、写入超时时间均默认为 60 秒。 |
| `HttpUtils(int connectTimeout, int readTimeout, int writeTimeout)` | 自定义超时时间（单位：秒），若缓存中存在相同配置的客户端则直接复用。 |

## 5. 方法说明

### 5.1 GET 请求

| 方法签名 | 说明 |
|--------|------|
| `Revert doGet(String url)` | 发起 GET 请求，不带请求头。 |
| `Revert doGet(String url, Map<String, String> headers)` | 发起 GET 请求，支持传入自定义请求头。 |

### 5.2 POST 请求 (JSON Body)

| 方法签名 | 说明 |
|--------|------|
| `Revert doPost(String url, String requestBody)` | 发起 POST 请求，默认 `application/json` 类型。 |
| `Revert doPost(String url, String requestBody, String contentType)` | 发起 POST 请求，指定 Content-Type。 |
| `<T> Revert doPost(String url, String requestBody, Class<T> clazz)` | 发起 POST 请求，并将响应体反序列化为指定类型 `T`。 |
| `<T> Revert doPost(String url, String requestBody, String contentType, Class<T> clazz)` | 发起 POST 请求，指定 Content-Type 并反序列化响应体。 |
| `Revert doPost(String url, String requestBody, Map<String, String> headers)` | 发起 POST 请求，带自定义请求头。 |
| `Revert doPost(String url, String requestBody, Map<String, String> headers, String contentType)` | 发起 POST 请求，带请求头与 Content-Type。 |
| `<T> Revert doPost(String url, String requestBody, Map<String, String> headers, Class<T> clazz)` | 发起 POST 请求，带请求头并反序列化响应体。 |
| `<T> Revert doPost(String url, String requestBody, Map<String, String> headers, String contentType, Class<T> clazz)` | 发起 POST 请求，带请求头、Content-Type 并反序列化响应体。 |

### 5.3 POST 请求 (带 Query Params)

| 方法签名 | 说明 |
|--------|------|
| `Revert doPostWithParams(String url, String requestBody, Map<String, Object> params)` | 发起 POST 请求，附带 URL Query 参数。 |
| `Revert doPostWithParams(String url, String requestBody, Map<String, Object> params, String contentType)` | 发起 POST 请求，附带 URL Query 参数并指定 Content-Type。 |
| `<T> Revert doPostWithParams(String url, String requestBody, Map<String, Object> params, Class<T> clazz)` | 发起 POST 请求，附带 URL Query 参数并反序列化响应体。 |
| `Revert doPost(String url, String requestBody, Map<String, Object> params, Map<String, String> headers)` | 发起 POST 请求，附带 URL Query 参数及请求头。 |
| `<T> Revert doPost(String url, String requestBody, Map<String, Object> params, Map<String, String> headers, Class<T> clazz)` | 发起 POST 请求，附带 URL Query 参数、请求头并反序列化响应体。 |
| `<T> Revert doPost(String url, String requestBody, Map<String, Object> params, Map<String, String> headers, String contentType, Class<T> clazz)` | 发起 POST 请求，全参数配置版本。 |

### 5.4 POST 请求 (Form 表单)

| 方法签名 | 说明 |
|--------|------|
| `Revert doPostFrom(String url, Map<String, Object> paramsMap)` | 发起表单 POST 请求，默认 `application/x-www-form-urlencoded`。 |
| `<T> Revert doPostFrom(String url, Map<String, Object> paramsMap, Class<T> clazz)` | 发起表单 POST 请求，并反序列化响应体。 |
| `Revert doPostFrom(String url, Map<String, Object> paramsMap, String contentType)` | 发起表单 POST 请求，指定 Content-Type。 |
| `<T> Revert doPostFrom(String url, Map<String, Object> paramsMap, String contentType, Class<T> clazz)` | 发起表单 POST 请求，指定 Content-Type 并反序列化响应体。 |
| `Revert doPostFrom(String url, Map<String, Object> paramsMap, Map<String, String> headers)` | 发起表单 POST 请求，带请求头。 |
| `Revert doPostFrom(String url, Map<String, Object> paramsMap, Map<String, String> headers, String contentType)` | 发起表单 POST 请求，带请求头与 Content-Type。 |
| `<T> Revert doPostFrom(String url, Map<String, Object> paramsMap, Map<String, String> headers, Class<T> clazz)` | 发起表单 POST 请求，带请求头并反序列化响应体。 |
| `<T> Revert doPostFrom(String url, Map<String, Object> paramsMap, Map<String, String> headers, String contentType, Class<T> clazz)` | 发起表单 POST 请求，全参数配置版本。 |

## 6. 响应解析逻辑 (transformResponse)
- 如果 `clazz` 为 `null`：将响应体字符串原样放入 `Revert.data` 中。
- 如果 `clazz` 为 `Revert.class`：直接将响应体 JSON 反序列化为 `Revert` 对象返回。
- 如果 `clazz` 为 `String.class`：将响应体字符串放入 `Revert.message` 中。
- 其他 `clazz` 类型：将响应体 JSON 反序列化为指定对象，放入 `Revert.data` 中。

## 7. 注意事项
1. **同步请求**: 当前提供的 `doGet`、`doPost` 等方法均为同步阻塞调用，请避免在 Web 容器的核心线程中直接使用导致线程阻塞，或在必要时使用异步封装。
2. **连接池配置**: 内部默认配置的连接池最大空闲连接数为 2，保持时间为 5 分钟，高并发场景下可能需要按需调整。
3. **异常处理**: 网络异常或解析异常会被统一捕获，返回 `Revert` 对象且 `status=false`、`code=0`，调用方需注意判断状态。
4. **字符集**: POST 请求默认使用 `UTF-8` 字符集。
