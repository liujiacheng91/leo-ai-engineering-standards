
# constant 常量定义包说明文档

## 1. 概述

`com.pobing.basic.constant` 包定义了 EDI 平台调度请求中使用的核心常量枚举。所有枚举均实现 `BaseTypeSource` 接口，以 `int` 值作为枚举标识，便于序列化和跨系统传递。

### 包结构

```
com.pobing.basic.constant
├── BaseTypeSource.java                        // 枚举基础接口
├── DispatcherRequestDirectionType.java        // 请求方向类型
├── DispatcherRequestServiceType.java          // 请求服务类型
└── DispatcherHandleStrategyType.java          // 请求处理策略类型
```

---

## 2. BaseTypeSource（枚举基础接口）

### 定义

```java
public interface BaseTypeSource
```

所有常量枚举的统一基础接口，定义了枚举值的标准访问方式，并提供通用的枚举查找工具方法。

### 方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getValue()` | `int` | 获取枚举的整型值 |

### 静态工具方法

| 方法 | 说明 |
|------|------|
| `getEnmuByName(String name, Class<E> clazz)` | 根据枚举名称获取枚举实例 |
| `getEnmu(Integer value, Class<E> clazz)` | 根据枚举整型值获取枚举实例 |

### 使用示例

```java
// 根据值获取枚举实例
DispatcherRequestDirectionType type = BaseTypeSource.getEnmu(1, DispatcherRequestDirectionType.class);
// type == DispatcherRequestDirectionType.SEND

// 根据名称获取枚举实例
DispatcherRequestDirectionType type2 = BaseTypeSource.getEnmuByName("RECEIVE", DispatcherRequestDirectionType.class);
// type2 == DispatcherRequestDirectionType.RECEIVE
```

---

## 3. DispatcherRequestDirectionType（请求方向类型）

### 定义

```java
public enum DispatcherRequestDirectionType implements BaseTypeSource
```

定义调度请求的数据传输方向，用于 `RequestHeader.requestDirectionType` 字段。

### 枚举值

| 枚举名 | 值 | 说明 |
|--------|---|------|
| `SEND` | 1 | 发送方向 |
| `RECEIVE` | 2 | 接收方向 |

### 使用示例

```java
// 设置请求方向为发送
header.setRequestDirectionType(DispatcherRequestDirectionType.SEND.getValue());

// 根据整型值解析方向类型
DispatcherRequestDirectionType direction = BaseTypeSource.getEnmu(1, DispatcherRequestDirectionType.class);
```

---

## 4. DispatcherRequestServiceType（请求服务类型）

### 定义

```java
public enum DispatcherRequestServiceType implements BaseTypeSource
```

定义调度请求的服务处理模式（同步/异步），用于 `RequestHeader.requestServiceType` 字段。

> **注意**：当前仅支持同步模式（`Sync`），异步模式（`Async`）为预留扩展。

### 枚举值

| 枚举名 | 值 | 说明 |
|--------|---|------|
| `Sync` | 1 | 同步处理（当前仅支持同步，为异步预留入参） |
| `Async` | 2 | 异步处理（预留，暂未实现） |

### 使用示例

```java
// 设置请求服务类型为同步
header.setRequestServiceType(DispatcherRequestServiceType.Sync.getValue());

// 根据整型值解析服务类型
DispatcherRequestServiceType serviceType = BaseTypeSource.getEnmu(1, DispatcherRequestServiceType.class);
```

---

## 5. DispatcherHandleStrategyType（请求处理策略类型）

### 定义

```java
public enum DispatcherHandleStrategyType implements BaseTypeSource
```

定义调度请求的处理策略，用于 `RequestHeader.requestHandleStrategyType` 字段。

### 枚举值

| 枚举名 | 值 | 说明 |
|--------|---|------|
| `Standard` | 1 | 标准实现 |
| `Customize` | 2 | 定制处理 |

### 使用示例

```java
// 设置处理策略为标准实现
header.setRequestHandleStrategyType(DispatcherHandleStrategyType.Standard.getValue());

// 设置处理策略为定制处理
header.setRequestHandleStrategyType(DispatcherHandleStrategyType.Customize.getValue());

// 根据整型值解析处理策略
DispatcherHandleStrategyType strategy = BaseTypeSource.getEnmu(2, DispatcherHandleStrategyType.class);
```

---

## 6. 常量与 RequestHeader 字段映射关系

| RequestHeader 字段 | 常量枚举类 | 说明 |
|-------------------|-----------|------|
| `requestDirectionType` | `DispatcherRequestDirectionType` | 请求方向（SEND=1 / RECEIVE=2） |
| `requestServiceType` | `DispatcherRequestServiceType` | 服务类型（Sync=1 / Async=2） |
| `requestHandleStrategyType` | `DispatcherHandleStrategyType` | 处理策略（Standard=1 / Customize=2） |

---

## 7. 常量值汇总

| 值 | DispatcherRequestDirectionType | DispatcherRequestServiceType | DispatcherHandleStrategyType |
|----|-------------------------------|----------------------------|----------------------------|
| 1  | SEND（发送） | Sync（同步） | Standard（标准） |
| 2  | RECEIVE（接收） | Async（异步） | Customize（定制） |

---

## 8. 设计说明

1. **统一接口**：所有枚举实现 `BaseTypeSource` 接口，保证枚举值访问方式的一致性，并提供通用的枚举查找能力。

2. **整型标识**：枚举值使用 `int` 类型而非字符串，减少传输数据量，提升序列化/反序列化效率。

3. **预留扩展**：`DispatcherRequestServiceType.Async` 为异步模式预留，体现了前瞻性设计。

4. **类型安全**：通过枚举替代魔法数字，增强代码可读性和类型安全性。
