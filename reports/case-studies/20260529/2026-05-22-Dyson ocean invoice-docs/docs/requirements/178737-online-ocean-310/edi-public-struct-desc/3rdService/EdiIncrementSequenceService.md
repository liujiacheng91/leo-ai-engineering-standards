# EdiIncrementSequenceService 接口说明文档

## 1. 概述
`EdiIncrementSequenceService` 是 EDI 平台唯一递增序列生成的核心服务接口，主要用于构建全局唯一的递增序列 ID。该接口定义了默认的永久递增 ID 生成以及基于自定义策略（如按年、月、日、前缀、补位等）的定制化 ID 生成规范，为分布式环境下的业务数据提供唯一标识保障。

## 2. 基本信息
- **类名**: `EdiIncrementSequenceService`
- **包路径**: `com.pobing.commonservice.builduniqueid`
- **核心实现类**: `EdiIncrementSequenceServiceImpl`

## 3. 方法说明

### 3.1 getIncrementId
- **方法签名**: `Revert getIncrementId()`
- **功能说明**: 按默认策略生成一个顺序递增的数字 ID，不进行任何业务前缀或补位处理，永久有效。
- **参数说明**: 无
- **返回说明**: `Revert` 通用响应对象，包含生成的递增 ID。

### 3.2 getIncrementByCustomize
- **方法签名**: `Revert getIncrementByCustomize(String group, String strategy, String prefix, String supplement, String symbol, int length)`
- **功能说明**: 根据指定的分组、策略、前缀、补位方式等参数，构建符合业务场景的唯一 ID。
- **参数说明**:
    - `group` (String): 分组标识，用于区分不同业务场景在 Redis 上的序号空间。
    - `strategy` (String): 生成策略，用于构建 Key 的周期维度。`Y`-按年，`M`-按月，`D`-按日，`A`-永久有效。
    - `prefix` (String): 业务前缀，用于拼接在 ID 前面以标识不同业务场景。
    - `supplement` (String): 补充策略，决定序号不足长度时是前补位、后补位还是不补位。
    - `symbol` (String): 补位符号，若不提供则默认使用 `0`。
    - `length` (int): 最终补位后的 ID 总长度。
- **返回说明**: `Revert` 通用响应对象，包含生成的自定义唯一 ID。

## 4. 使用场景
1. **EDI报文全局唯一标识**: 在 EDI 报文接入时，生成全局唯一的跟踪号。
2. **业务单号生成**: 针对不同租户或项目，按年/月/日周期生成带有业务前缀的流水号（如：`TENANT20231100001`）。
3. **分布式序列协调**: 在微服务集群环境下，通过统一的接口规范获取自增序列，保证 ID 的唯一性与递增性。

## 5. 注意事项
1. **网络依赖**: 实现类底层依赖远程 REST 接口，调用方需做好网络异常或服务不可用时的降级与重试处理。
2. **参数校验**: 调用 `getIncrementByCustomize` 时，需确保 `group`、`strategy` 等参数符合底层服务的校验规则，否则可能导致生成失败。
3. **补位长度**: 传入的 `length` 需要合理评估业务峰值，避免因序号自增超过指定长度导致补位截断或异常。
4. **并发安全**: 底层依赖 Redis 等中间件的自增机制，服务端保证了高并发下的 ID 唯一性，调用方无需额外加锁。
