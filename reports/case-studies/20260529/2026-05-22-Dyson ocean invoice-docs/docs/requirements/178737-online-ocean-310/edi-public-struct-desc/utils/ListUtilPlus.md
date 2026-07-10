# ListUtilPlus 工具类说明文档

## 1. 概述
`ListUtilPlus` 是一个增强的列表与集合操作工具类，基于 Java 8 Stream API 提供了列表去重、分割、取值、转换及快速构建 Map 等功能。该工具类旨在简化日常开发中对集合操作的代码编写，提升代码的简洁性与可读性。

## 2. 基本信息
- **类名**: `ListUtilPlus`
- **包路径**: `com.pobing.list`

## 3. 方法说明

### 3.1 列表去重

| 方法签名 | 说明 |
|--------|------|
| `static <T> List<T> removeRepeat(List<T> list, Function<? super T, ?> keyExtractor)` | 根据对象的属性值删除列表中的重复数据，保留首次出现的元素。底层使用 `ConcurrentHashMap` 保证去重判断的线程安全。 |

### 3.2 列表分割

| 方法签名 | 说明 |
|--------|------|
| `static <T> List<List<T>> splitList(List<T> list, int size)` | 将原始列表按照指定的大小分割成多个子列表。如果 `size` 小于等于 0 则返回 `null`。 |

### 3.3 列表取值

| 方法签名 | 说明 |
|--------|------|
| `static <T> T getFirstItem(List<T> list)` | 安全地获取列表的第一个元素。如果列表为空或为 `null`，则返回 `null`。 |

### 3.4 列表转 Map

| 方法签名 | 说明 |
|--------|------|
| `static <T, K, V> Map<K, V> convertListToMap(List<T> list, Function<T, K> keyMapper, Function<T, V> valueMapper)` | 通用转换方法，将列表转为 `Map<K, V>`。需自定义生成 Key 和 Value 的函数。 |
| `static <T, K, V> Map<K, List<V>> groupToList(List<T> list, Function<T, K> keyMapper, Function<T, V> valueMapper)` | 通用转换方法，将列表按 Key 分组，转为 `Map<K, List<V>>` 结构。 |

### 3.5 快速构建 Map

| 方法签名 | 说明 |
|--------|------|
| `static Map<String, String> mapOf(String... keyValues)` | 根据传入的键值对数组快速生成 `HashMap`。奇数位为 Key，偶数位为 Value。允许 Value 为 `null`（会自动转为空字符串 `""`）。 |
| `static Map<String, String> mapOrderOf(String... keyValues)` | 根据传入的键值对数组快速生成有序的 `LinkedHashMap`，保证插入顺序。适用于对顺序有要求的场景（如生成 X12 结构）。 |

## 4. 使用场景
1. **数据清洗去重**: 处理从接口或数据库获取的批量数据时，使用 `removeRepeat` 根据业务主键快速去重。
2. **批量分片处理**: 在批量插入数据库或批量调用外部接口时，使用 `splitList` 将大集合分片，防止超出报文或SQL长度限制。
3. **数据结构转换**: 将 `List` 形式的实体集合转换为以某属性为 Key 的 `Map` 索引结构，便于后续快速查找（`convertListToMap`）。
4. **有序报文组装**: 构建 EDI X12 等对字段顺序有严格要求的报文时，使用 `mapOrderOf` 保证字段顺序。

## 5. 注意事项
1. **去重逻辑**: `removeRepeat` 是基于 `ConcurrentHashMap.putIfAbsent` 实现的，属于基于过滤的去重，会保留重复元素中首次出现的对象。
2. **分割大小**: 调用 `splitList` 时，`size` 参数必须大于 0，否则将返回 `null`，调用方需做防空判断。
3. **Map 构建参数**: 使用 `mapOf` 或 `mapOrderOf` 时，传入的可变参数长度必须为偶数。若为奇数，方法内部仅打印日志并返回空 Map，不会抛出异常，调用时需注意排查参数问题。
4. **Null 值处理**: `mapOf` 和 `mapOrderOf` 会自动将 `null` 值的 Value 转换为空字符串 `""`，规避了 `Map.of` 不允许 Null 值的问题。
