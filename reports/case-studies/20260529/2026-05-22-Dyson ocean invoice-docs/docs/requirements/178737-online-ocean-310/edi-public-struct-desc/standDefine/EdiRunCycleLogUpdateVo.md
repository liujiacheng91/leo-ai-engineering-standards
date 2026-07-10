# EdiRunCycleLogUpdateVo 对象说明文档

## 概述
`EdiRunCycleLogUpdateVo` 是EDI运行周期日志更新值对象（Value Object），用于封装EDI运行周期日志的更新操作所需的数据，包含更新条件（WHERE条件）和更新内容（SET内容）两部分。

## 基本信息
- **类名**: `EdiRunCycleLogUpdateVo`
- **包路径**: `com.pobing.servicevo`

## 字段说明

| 字段名 | 类型 | 说明 |
|--------|------|------|
| setEntity | EdiRunCycleLogQueryResponseVo | 更新实体，包含需要更新的字段和值 |
| whereEntiy | EdiRunCycleLogQueryResponseVo | 条件实体，包含更新操作的条件（WHERE条件） |

## 使用场景

1. **日志更新操作**: 当需要更新EDI运行周期日志时，使用此对象封装更新条件和更新内容
2. **批量更新**: 支持根据条件批量更新符合条件的日志记录
3. **条件更新**: 通过whereEntiy指定更新条件，setEntity指定更新内容，实现精确的条件更新

## 使用示例

```java
// 创建更新请求对象
EdiRunCycleLogUpdateVo updateVo = new EdiRunCycleLogUpdateVo();

// 设置更新条件
EdiRunCycleLogQueryResponseVo whereCondition = new EdiRunCycleLogQueryResponseVo();
whereCondition.setEdiNo("EDI001");  // 更新条件：ediNo为EDI001的记录
updateVo.setWhereEntiy(whereCondition);

// 设置更新内容
EdiRunCycleLogQueryResponseVo updateContent = new EdiRunCycleLogQueryResponseVo();
updateContent.setStatus("1");  // 更新内容：将状态设置为成功
updateContent.setResponseResult("处理成功");  // 更新结果信息
updateVo.setSetEntity(updateContent);

// 执行更新操作
// ediRunCycleLogService.updateLog(updateVo);
```

## 注意事项

1. **字段拼写**: 注意whereEntiy字段中的"Entiy"是拼写错误，应为"Entity"，但为保持代码兼容性，当前版本保留此拼写
2. **更新条件**: whereEntiy用于指定更新条件，如果不设置，可能会更新所有记录，请谨慎使用
3. **更新内容**: setEntity中只设置需要更新的字段，未设置的字段不会被修改
4. **关联对象**: 该类依赖于EdiRunCycleLogQueryResponseVo，使用前需要确保该类可用
