# MicrosoftEntraIdService 接口说明文档

## 1. 概述
`MicrosoftEntraIdService` 是用于获取 Microsoft Entra ID 授权 Token 的服务接口。该接口定义了登录 Microsoft Entra ID 系统及获取访问令牌的标准规范，支持设置重试次数以应对网络波动或服务端暂时不可用的情况，为集成 Microsoft 身份验证体系提供基础能力。

## 2. 基本信息
- **类名**: `MicrosoftEntraIdService`
- **包路径**: `com.pobing.commonservice.microsoftentraidservice`
- **作者**: sundy
- **创建日期**: 2026-04-29

## 3. 常量说明
| 常量名 | 类型 | 值 | 说明 |
|--------|------|-----|------|
| `MICROSOFT_ENTRA_ID_TOKEN` | String | `"microsoft_entra_id_token"` | Microsoft Entra ID 授权 Token 的缓存或标识键名。 |
| `MICROSOFT_ENTRA_ID_TOKEN_RETRIES` | int | `3` | 获取 Token 的默认重试次数。 |

## 4. 接口方法说明

### 4.1 getAccessToken
- **方法签名**: `MicrosoftEntraIdResponse getAccessToken(int retriesNum)`
- **功能说明**: 获取 Microsoft Entra ID 授权 Token。实现类通常会优先从缓存中获取，若缓存不存在或已过期，则触发登录逻辑重新获取。
- **参数说明**:
    - `retriesNum` (int): 获取失败时的重试次数。
- **返回说明**: `MicrosoftEntraIdResponse` 对象，包含授权 Token 等相关信息。

### 4.2 login
- **方法签名**: `MicrosoftEntraIdResponse login(int retriesNum)`
- **功能说明**: 直接调用 Microsoft Entra ID 系统的登录接口进行认证，并获取新的 Token。
- **参数说明**:
    - `retriesNum` (int): 登录失败时的重试次数。
- **返回说明**: `MicrosoftEntraIdResponse` 对象，包含登录成功后返回的 Token 等相关信息。

## 5. 核心依赖响应对象 (MicrosoftEntraIdResponse)

### 5.1 概述
`MicrosoftEntraIdResponse` 是用于封装 Microsoft Entra ID 授权认证接口返回数据的响应对象。该类同时包含了认证成功时的 Token 相关信息，以及认证失败时的错误详情与追踪信息，便于调用方进行结果判断与问题排查。

### 5.2 授权成功字段
| 字段名 | 类型 | JSON属性 | 说明 |
|--------|------|----------|------|
| accessToken | String | `access_token` | 访问令牌，用于调用受 Microsoft Entra ID 保护的资源 API。 |
| tokenType | String | `token_type` | 令牌类型，通常为 "Bearer"。 |
| expiresIn | String | `expires_in` | 令牌的有效时间（通常以秒为单位）。 |
| extExpiresIn | String | `ext_expires_in` | 扩展的令牌有效时间，用于在资源服务器暂时不可用时延长令牌的有效期。 |

### 5.3 授权失败/错误字段
| 字段名 | 类型 | JSON属性 | 说明 |
|--------|------|----------|------|
| error | String | `error` | 错误代码，描述发生的错误类型（如 "invalid_grant"）。 |
| errorDescription | String | `error_description` | 错误的可读描述信息，帮助开发者理解和修复错误。 |
| errorCodes | List\<String\> | `error_codes` | 错误代码列表，提供更具体的错误标识。 |
| errorUri | String | `error_uri` | 错误相关的帮助链接，指向解释该错误的文档页面。 |

### 5.4 请求追踪字段
| 字段名 | 类型 | JSON属性 | 说明 |
|--------|------|----------|------|
| timestamp | String | `timestamp` | 服务器发生错误时的时间戳。 |
| traceId | String | `trace_id` | 请求的跟踪 ID，用于分布式链路追踪。 |
| correlationId | String | `correlation_id` | 关联 ID，用于将相关日志和请求关联起来，便于问题排查。 |

## 6. 使用场景
1. **API 鉴权**: 调用受 Microsoft Entra ID 保护的第三方 API 前，通过此服务获取有效的 Access Token。
2. **单点登录 (SSO)**: 集成 Microsoft 企业账号体系，实现系统的单点登录认证。
3. **定时令牌刷新**: 在定时任务中定期调用 `login` 方法，确保系统长期持有有效的授权凭证。

## 7. 注意事项
1. **重试机制**: 传入的 `retriesNum` 应为正整数，建议使用常量 `MICROSOFT_ENTRA_ID_TOKEN_RETRIES` (3) 作为默认值，避免因重试次数过多导致线程阻塞。
2. **Token 缓存**: `getAccessToken` 与 `login` 的区别在于缓存机制的使用。业务调用应优先使用 `getAccessToken`，避免频繁调用 `login` 导致被 Microsoft 限流。
3. **安全性**: 获取到的 Token 属于敏感信息，应避免在日志中明文打印，传输过程建议使用 HTTPS。
4. **并发控制**: 在高并发场景下获取 Token 时，实现类需做好缓存击穿保护（如加锁），防止大量并发请求同时触发 `login` 操作。
5. **有效期管理**: 业务层需根据响应对象中的 `expiresIn` 合理设计 Token 的缓存与刷新策略，避免使用已过期的令牌。
