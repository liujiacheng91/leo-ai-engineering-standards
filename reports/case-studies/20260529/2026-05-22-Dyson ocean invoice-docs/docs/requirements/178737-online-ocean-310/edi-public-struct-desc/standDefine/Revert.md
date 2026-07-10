# Revert

## 概述
`Revert` 是一个通用的接口响应封装类，用于标准化 API 的返回数据结构。它包含了请求的状态、返回的数据、提示信息以及状态码，使得前后端交互的数据格式保持一致。该类实现了 Builder 模式，支持链式调用，使得对象的创建更加清晰和优雅。

## 属性说明

| 属性名 | 类型 | 说明 |
| :--- | :--- | :--- |
| `status` | `boolean` | 请求处理状态。通常 `true` 表示成功，`false` 表示失败。 |
| `data` | `Object` | 响应体数据。泛化的对象类型，可以承载任意结构的业务数据。 |
| `message` | `String` | 提示信息。通常用于返回错误描述或操作成功的提示。 |
| `code` | `int` | 状态码。用于更细粒度地标识响应状态（如：200 表示成功，400 表示参数错误等）。 |

## Builder 模式

该类提供了 Builder 设计模式的实现，允许通过链式调用的方式逐步构建 `Revert` 对象，避免了构造器参数过多导致的可读性差的问题。

### 使用示例

```java
// 构建一个成功的响应
Revert successRevert = Revert.builder()
    .status(true)
    .code(200)
    .message("操作成功")
    .data(userInfo)
    .build();

// 构建一个失败的响应
Revert errorRevert = Revert.builder()
    .status(false)
    .code(404)
    .message("资源未找到")
    .data(null)
    .build();
