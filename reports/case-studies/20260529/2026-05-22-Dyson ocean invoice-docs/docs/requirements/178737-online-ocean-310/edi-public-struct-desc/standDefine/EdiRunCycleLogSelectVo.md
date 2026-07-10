# EdiRunCycleLogSelectVo 对象说明文档

## 概述
`EdiRunCycleLogSelectVo` 是EDI运行周期日志查询选择值对象（Value Object），用于封装EDI运行周期日志的查询条件，支持自定义查询字段、自定义SQL条件和WHERE条件。该对象提供了灵活的查询方式，满足不同场景下的日志查询需求。

## 基本信息
- **类名**: `EdiRunCycleLogSelectVo`
- **包路径**: `com.pobing.servicevo`

## 字段说明

| 字段名 | 类型 | 说明 |
|--------|------|------|
| selectColumns | String | 查询字段，指定需要查询的列名，多个字段用逗号分隔 |
| lastSql | String | 自定义SQL条件，用于追加到SQL语句末尾的额外条件 |
| whereEntiy | EdiRunCycleLogQueryResponseVo | WHERE条件实体，包含查询条件的字段和值 |

## 使用场景

1. **自定义字段查询**: 当只需要查询日志表中的部分字段时，通过selectColumns指定
2. **复杂条件查询**: 通过lastSql可以添加自定义的SQL条件，实现复杂的查询逻辑
3. **标准条件查询**: 通过whereEntiy设置查询条件，实现基于字段的精确查询
4. **组合查询**: 可以同时使用selectColumns、lastSql和whereEntiy实现灵活的组合查询

## 使用示例

### 示例1：查询指定字段
```java
// 创建查询对象
EdiRunCycleLogSelectVo selectVo = new EdiRunCycleLogSelectVo();

// 指定查询字段
selectVo.setSelectColumns("id, ediNo, status, businessKey, create_time");

// 执行查询
List<EdiRunCycleLogQueryResponseVo> result = ediRunCycleLogService.selectLogs(selectVo);
```

### 示例2：使用WHERE条件查询
```java
// 创建查询对象
EdiRunCycleLogSelectVo selectVo = new EdiRunCycleLogSelectVo();

// 设置WHERE条件
EdiRunCycleLogQueryResponseVo whereCondition = new EdiRunCycleLogQueryResponseVo();
whereCondition.setEdiNo("EDI001");
whereCondition.setStatus("1");
selectVo.setWhereEntiy(whereCondition);

// 执行查询
List<EdiRunCycleLogQueryResponseVo> result = ediRunCycleLogService.selectLogs(selectVo);
```

### 示例3：使用自定义SQL条件
```java
// 创建查询对象
EdiRunCycleLogSelectVo selectVo = new EdiRunCycleLogSelectVo();

// 设置自定义SQL条件
selectVo.setLastSql("AND create_time >= '2026-02-01 00:00:00' AND create_time <= '2026-02-03 23:59:59'");

// 执行查询
List<EdiRunCycleLogQueryResponseVo> result = ediRunCycleLogService.selectLogs(selectVo);
```

### 示例4：组合查询
```java
// 创建查询对象
EdiRunCycleLogSelectVo selectVo = new EdiRunCycleLogSelectVo();

// 指定查询字段
selectVo.setSelectColumns("id, ediNo, status, businessKey, response_result, create_time");

// 设置WHERE条件
EdiRunCycleLogQueryResponseVo whereCondition = new EdiRunCycleLogQueryResponseVo();
whereCondition.setTenantCode("TENANT001");
whereCondition.setProjectNo("PROJECT001");
selectVo.setWhereEntiy(whereCondition);

// 设置自定义SQL条件（排序）
selectVo.setLastSql("ORDER BY create_time DESC LIMIT 100");

// 执行查询
List<EdiRunCycleLogQueryResponseVo> result = ediRunCycleLogService.selectLogs(selectVo);
```

## 注意事项

1. **字段拼写**: 注意whereEntiy字段中的"Entiy"是拼写错误，应为"Entity"，但为保持代码兼容性，当前版本保留此拼写

2. **selectColumns使用**:
   - 字段名应与数据库表中的列名保持一致
   - 多个字段之间用逗号分隔
   - 如果不设置，默认查询所有字段

3. **lastSql使用**:
   - lastSql中的SQL条件会直接追加到SQL语句末尾
   - 需要确保SQL语法的正确性
   - 建议使用参数化查询，避免SQL注入风险
   - 可以用于添加排序、分页、额外条件等

4. **whereEntiy使用**:
   - whereEntiy中设置的字段会自动转换为WHERE条件
   - 只设置需要查询条件的字段，未设置的字段不会作为条件
   - 支持多个条件的AND组合

5. **性能考虑**:
   - 使用selectColumns只查询需要的字段，可以减少数据传输量
   - 合理使用WHERE条件和索引，提高查询效率
   - 避免使用lastSql进行过于复杂的查询，可能影响性能
