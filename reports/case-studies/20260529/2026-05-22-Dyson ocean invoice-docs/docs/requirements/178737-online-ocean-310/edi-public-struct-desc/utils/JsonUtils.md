# JsonUtils 工具类说明文档

## 1. 概述
`JsonUtils` 是基于 Jackson 封装的 JSON 处理工具类，提供了对象与 JSON 字符串之间的序列化与反序列化能力。该工具类内置了单例模式获取方式，并针对日期、空值、特殊字符等常见场景进行了默认配置优化，旨在简化 JSON 转换操作。

## 2. 基本信息
- **类名**: `JsonUtils`
- **包路径**: `com.pobing.json`

## 3. 核心设计
- **单例模式**: 通过内部静态类 `JsonUtilsHolder` 实现懒加载单例，调用 `getInstance()` 即可获取全局唯一实例。
- **定制化 ObjectMapper**: 在构造函数中对 `ObjectMapper` 进行了全面配置，以适应复杂的业务场景。

## 4. 默认配置说明
| 配置项 | 说明 |
|--------|------|
| 时间戳格式 | 关闭默认时间戳格式 (`WRITE_DATES_AS_TIMESTAMPS`)，注册 `JavaTimeModule` 支持Java 8时间API。 |
| 时区 | 设置为中国上海时区 (`GMT+8`)。 |
| 日期格式化 | 统一日期序列化格式为 `yyyy-MM-dd HH:mm:ss`。 |
| 空值处理 | 序列化时忽略 `null` 值属性 (`NON_NULL`)。 |
| 未知属性 | 反序列化时忽略 JSON 中存在但 Java 对象中不存在的属性 (`FAIL_ON_UNKNOWN_PROPERTIES=false`)。 |
| 空对象 | 允许将空字符串视为 `null` 对象 (`ACCEPT_EMPTY_STRING_AS_NULL_OBJECT=true`)。 |
| 空Bean | 序列化时不因对象无属性而报错 (`FAIL_ON_EMPTY_BEANS=false`)。 |
| 特殊字符 | 允许单引号、注释、无引号字段名、反斜杠转义及未转义的控制字符等。 |
| 非ASCII字符 | 取消对非ASCII字符的转码，正常显示中文等字符。 |

## 5. 方法说明

### 5.1 获取实例
| 方法签名 | 说明 |
|--------|------|
| `static JsonUtils getInstance()` | 获取 `JsonUtils` 单例实例。 |

### 5.2 序列化方法 (对象 -> JSON)
| 方法签名 | 说明 |
|--------|------|
| `String toJson(Object object) throws Exception` | 将对象序列化为 JSON 字符串，转换失败抛出异常。 |
| `String toJsonNonEx(Object object)` | 将对象序列化为 JSON 字符串，转换失败返回 `null` 并记录错误日志。 |
| `String toJsonP(String functionName, Object object) throws Exception` | 将对象序列化为 JSONP 格式字符串，转换失败抛出异常。 |
| `String toJsonPNonEx(String functionName, Object object)` | 将对象序列化为 JSONP 格式字符串，转换失败返回 `null` 并记录错误日志。 |

### 5.3 反序列化方法 (JSON -> 对象)
| 方法签名 | 说明 |
|--------|------|
| `<T> T fromJson(String jsonString, Class<T> clazz) throws Exception` | 将 JSON 字符串反序列化为指定 Class 对象，转换失败抛出异常。 |
| `<T> T fromJsonNonEx(String jsonString, Class<T> clazz)` | 将 JSON 字符串反序列化为指定 Class 对象，转换失败返回 `null` 并记录错误日志。 |
| `<T> T fromJson(String jsonString, TypeReference<T> typeReference) throws Exception` | 将 JSON 字符串反序列化为带泛型的对象（通过 TypeReference），转换失败抛出异常。 |
| `<T> T fromJsonNonEx(String jsonString, TypeReference<T> typeReference)` | 将 JSON 字符串反序列化为带泛型的对象，转换失败返回 `null` 并记录错误日志。 |

### 5.4 集合转换方法
| 方法签名 | 说明 |
|--------|------|
| `<T> List<T> fromJsonToList(String jsonString, Class<T> clazz) throws Exception` | 将 JSON 数组字符串反序列化为指定类型的 List 集合。 |
| `<T> List<T> fromMapToList(List<Map<String, Object>> mapList, Class<T> clazz) throws Exception` | 将 `List<Map>` 结构直接转换为指定类型的 List 集合对象。 |

### 5.5 其他方法
| 方法签名 | 说明 |
|--------|------|
| `ObjectMapper getMapper()` | 获取内部底层使用的 `ObjectMapper` 实例，便于进行更灵活的自定义操作。 |
| `void setMapper(ObjectMapper mapper)` | 设置/替换内部使用的 `ObjectMapper` 实例。 |

## 6. 使用场景
1. **接口报文解析**: 在 EDI 或 HTTP 接口调用后，将 JSON 响应体直接反序列化为业务 VO 对象。
2. **日志记录**: 将复杂业务对象序列化为 JSON 字符串进行存储或打印。
3. **Map 与 Bean 转换**: 利用 `fromMapToList` 实现 Map 结构数据到实体 Bean 的快速转换。

## 7. 注意事项
1. **异常处理选择**: 在业务关键链路中建议使用 `toJson` 或 `fromJson`，通过捕获异常进行针对性处理；在非关键链路（如日志打印）建议使用 `toJsonNonEx` 或 `fromJsonNonEx` 避免因转换异常导致主流程中断。
2. **泛型擦除**: 对于带泛型的复杂对象（如 `List<User>`），由于 Java 泛型擦除机制，必须使用 `TypeReference` 版本的方法进行反序列化。
3. **线程安全**: 内部的 `ObjectMapper` 在配置完成后是线程安全的，但若通过 `setMapper` 动态修改配置则需注意并发问题。
4. **日期格式**: 默认全局日期格式为 `yyyy-MM-dd HH:mm:ss`，如有个别字段格式不同，需在实体类属性上使用 `@JsonFormat` 注解覆盖全局配置。
