# EdiRunCycleLogQueryResponseVo 对象说明文档

## 概述
`EdiRunCycleLogQueryResponseVo` 是EDI运行周期日志查询响应值对象（Value Object），用于封装EDI运行周期日志查询返回的数据。该对象包含了EDI接口运行过程中的完整日志信息，包括接口状态、业务数据、跟踪信息等关键内容。

## 基本信息
- **类名**: `EdiRunCycleLogQueryResponseVo`
- **包路径**: `com.pobing.servicevo`
- **作者**: wenhz
- **创建日期**: 2026-02-03
- **实现接口**: `Serializable`

## 字段说明

### 基础字段

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | Long | 主键ID |
| status | String | 接口状态，1成功，2失败，3异常或其它 |
| tenantCode | String | 租户编码 |
| projectNo | String | 项目号 |
| createTime | LocalDateTime | 日志的创建时间 |

### 业务标识字段

| 字段名 | 类型 | 说明 |
|--------|------|------|
| ediNo | String | EDI编号，用以识别接口 |
| traceId | String | 跟踪唯一号，为接口在报文接入时生成的一串号，用于EDI平台日志跟踪 |
| businessKey | String | 业务关键字，为业务主键，利于从业务上跟踪数据 |
| ediPhase | String | EDI流程阶段 |

### 辅助业务关键字

| 字段名 | 类型 | 说明 |
|--------|------|------|
| bizKeyOne | String | 业务关键字，用于辅助识别业务数据（第1个字段） |
| bizKeyTwo | String | 业务关键字，用于辅助识别业务数据（第2个字段） |
| bizKeyThree | String | 业务关键字，用于辅助识别业务数据（第3个字段） |
| bizKeyFour | String | 业务关键字，用于辅助识别业务数据（第4个字段） |
| bizKeyFive | String | 业务关键字，用于辅助识别业务数据（第5个字段） |

### 内容相关字段

| 字段名 | 类型 | 说明 |
|--------|------|------|
| verifyStr | String | 报文指纹串，用于校验报文是否变化。如不需要，该列可不填，由指定业务字段生成或是业务报文串生成 |
| contentPath | String | 报文内存存储于S3的ID号 |

### 交易与结果字段

| 字段名 | 类型 | 说明 |
|--------|------|------|
| responseResult | String | 执行的返回结果消息 |
| transactionTime | String | 交易时间，指接口数据的发生时间，可为业务时间，也可为系统时间 |
| transactionNo | Long | 交易号，取当前行处理的时间串，在程序中，可能多个业务的交易号为同一批 |

## 使用场景

1. **EDI接口日志查询**: 查询EDI接口执行日志时，返回该对象包含完整的日志信息
2. **业务数据跟踪**: 通过businessKey和bizKey系列字段，可以方便地追踪业务数据
3. **问题排查**: 通过traceId可以完整追踪一个EDI请求的整个生命周期
4. **报文管理**: 支持报文内容的存储路径和校验，便于后续分析和问题定位
5. **日志更新操作**: 该对象也被用于`EdiRunCycleLogUpdateVo`中，作为更新条件和更新内容的载体

## 注意事项

1. **状态值规范**: status字段应遵循以下规范
   - 1: 成功
   - 2: 失败
   - 3: 异常或其它

2. **时间字段**: 
   - transactionTime可以是业务时间或系统时间
   - createTime是日志记录的创建时间，由系统自动生成

3. **业务关键字**:
   - businessKey是主要的业务标识
   - bizKeyOne至bizKeyFive是辅助标识，可根据实际业务需要使用

4. **报文存储**:
   - contentPath用于存储大报文（S3路径）
   - verifyStr用于报文校验，确保数据完整性

5. **与RequestVo的区别**:
   - QueryResponseVo主要用于查询响应和更新操作
   - 不包含contentStr字段（报文内容字符串），仅包含contentPath（S3存储路径）

## 使用示例

### 查询示例
```java
// 创建查询条件
EdiRunCycleLogQueryRequestVo queryRequest = new EdiRunCycleLogQueryRequestVo();
queryRequest.setTraceId("TRACE123456");

// 执行查询
List<EdiRunCycleLogQueryResponseVo> logList = ediRunCycleLogService.queryLogs(queryRequest);

// 遍历查询结果
for (EdiRunCycleLogQueryResponseVo log : logList) {
    System.out.println("EDI编号: " + log.getEdiNo());
    System.out.println("接口状态: " + log.getStatus());
    System.out.println("业务关键字: " + log.getBusinessKey());
}
```

### 更新示例
```java
// 创建更新请求
EdiRunCycleLogUpdateVo updateVo = new EdiRunCycleLogUpdateVo();

// 设置更新条件
EdiRunCycleLogQueryResponseVo whereCondition = new EdiRunCycleLogQueryResponseVo();
whereCondition.setTraceId("TRACE123456");
updateVo.setWhereEntiy(whereCondition);

// 设置更新内容
EdiRunCycleLogQueryResponseVo updateContent = new EdiRunCycleLogQueryResponseVo();
updateContent.setStatus("1");
updateContent.setResponseResult("处理成功");
updateVo.setSetEntity(updateContent);

// 执行更新
ediRunCycleLogService.updateLog(updateVo);
```
