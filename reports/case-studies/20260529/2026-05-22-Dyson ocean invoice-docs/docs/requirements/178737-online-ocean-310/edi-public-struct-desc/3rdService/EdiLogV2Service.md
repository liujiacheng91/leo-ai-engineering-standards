# EdiLogV2Service 接口说明文档

## 1. 概述
`EdiLogV2Service` 是 EDI 平台 V2 版本的核心日志服务接口，主要负责 EDI 运行周期日志的记录、修改、查询与报文内容获取。该服务通过规范化的值对象（VO）进行交互，实现了接口运行状态监控、业务数据追踪、报文存储校验及问题排查等核心能力。

## 2. 基本信息
- **类名**: `EdiLogV2Service`
- **包路径**: `com.pobing.commonservice.edilogservice`
- **作者**: wenhz
- **创建日期**: 2026-02-03

## 3. 核心依赖值对象
- **EdiRunCycleLogRequestVo**: EDI运行周期日志请求值对象，用于封装EDI接口运行过程中的日志信息，包括接口状态、业务数据、跟踪信息等关键内容。
  - **基本信息**:
    - **类名**: `EdiRunCycleLogRequestVo`
    - **包路径**: `com.pobing.servicevo`
    - **实现接口**: `Serializable`
  - **结构属性**:
    - **基础字段**:
      - `id` (Long): 主键ID。
      - `status` (String): 接口状态（1成功，2失败，3异常或其它）。
      - `tenantCode` (String): 租户编码。
      - `projectNo` (String): 项目号。
      - `createTime` (LocalDateTime): 日志的创建时间。
    - **业务标识字段**:
      - `ediNo` (String): EDI编号，用以识别接口。
      - `traceId` (String): 跟踪唯一号，为接口在报文接入时生成的一串号，用于EDI平台日志跟踪。
      - `businessKey` (String): 业务关键字，为业务主键，利于从业务上跟踪数据。
      - `ediPhase` (String): EDI流程阶段。
    - **辅助业务关键字**:
      - `bizKeyOne` (String): 业务关键字，用于辅助识别业务数据（第1个字段）。
      - `bizKeyTwo` (String): 业务关键字，用于辅助识别业务数据（第2个字段）。
      - `bizKeyThree` (String): 业务关键字，用于辅助识别业务数据（第3个字段）。
      - `bizKeyFour` (String): 业务关键字，用于辅助识别业务数据（第4个字段）。
      - `bizKeyFive` (String): 业务关键字，用于辅助识别业务数据（第5个字段）。
    - **内容相关字段**:
      - `verifyStr` (String): 报文指纹串，用于校验报文是否变化。如不需要，该列可不填，由指定业务字段生成或是业务报文串生成。
      - `contentPath` (String): 报文内存存储于S3的ID号。
      - `contentStr` (String): 报文内容字符串。
    - **交易与结果字段**:
      - `responseResult` (String): 执行的返回结果消息。
      - `transactionTime` (String): 交易时间，指接口数据的发生时间，可为业务时间，也可为系统时间。
      - `transactionNo` (Long): 交易号，取当前行处理的时间串，在程序中，可能多个业务的交易号为同一批。
  - **使用场景**:
    1. **EDI接口日志记录**: 当EDI接口执行时，使用此对象记录接口的执行状态和相关信息。
    2. **业务数据跟踪**: 通过businessKey和bizKey系列字段，可以方便地追踪业务数据。
    3. **问题排查**: 通过traceId可以完整追踪一个EDI请求的整个生命周期。
    4. **报文管理**: 支持报文内容的存储和校验，便于后续分析和问题定位。
  - **注意事项**:
    1. **状态值规范**: status字段应遵循规范（1: 成功, 2: 失败, 3: 异常或其它）。
    2. **时间字段**: `transactionTime`可以是业务时间或系统时间；`createTime`是日志记录的创建时间，由系统自动生成。
    3. **业务关键字**: `businessKey`是主要的业务标识；`bizKeyOne`至`bizKeyFive`是辅助标识，可根据实际业务需要使用。
    4. **报文存储**: `contentPath`用于存储大报文（S3路径）；`contentStr`用于存储小报文（直接存储字符串）；`verifyStr`用于报文校验，确保数据完整性。
- **EdiRunCycleLogUpdateVo**: EDI运行周期日志更新值对象，用于封装EDI运行周期日志的更新操作所需的数据，包含更新条件（WHERE条件）和更新内容（SET内容）两部分。
  - **基本信息**:
    - **类名**: `EdiRunCycleLogUpdateVo`
    - **包路径**: `com.pobing.servicevo`
  - **结构属性**:
    - `setEntity` (EdiRunCycleLogQueryResponseVo): 更新实体，包含需要更新的字段和值。
    - `whereEntiy` (EdiRunCycleLogQueryResponseVo): 条件实体，包含更新操作的条件（WHERE条件）。
  - **使用场景**:
    1. **日志更新操作**: 当需要更新EDI运行周期日志时，使用此对象封装更新条件和更新内容。
    2. **批量更新**: 支持根据条件批量更新符合条件的日志记录。
    3. **条件更新**: 通过 `whereEntiy` 指定更新条件，`setEntity` 指定更新内容，实现精确的条件更新。
  - **注意事项**:
    1. **字段拼写**: `whereEntiy` 字段中的 "Entiy" 是历史拼写错误，应为 "Entity"，但为保持代码兼容性，当前版本保留此拼写。
    2. **更新条件**: `whereEntiy` 用于指定更新条件，如果不设置，可能会更新所有记录，请谨慎使用。
    3. **更新内容**: `setEntity` 中只设置需要更新的字段，未设置的字段不会被修改。
    4. **关联对象**: 该类依赖于 `EdiRunCycleLogQueryResponseVo`，使用前需要确保该类可用。
- **EdiRunCycleLogSelectVo**: EDI运行周期日志查询条件对象，用于封装多维度（如租户、项目、时间范围、业务标识等）的查询条件。
  - **结构属性**:
    - `selectColumns` (String): 查询字段，指定需要查询的列名，多个字段用逗号分隔。
    - `lastSql` (String): 自定义SQL条件，用于追加到SQL语句末尾的额外条件。
    - `whereEntiy` (EdiRunCycleLogQueryResponseVo): WHERE条件实体，包含查询条件的字段和值。
  - **使用场景**:
    1. **自定义字段查询**: 当只需要查询日志表中的部分字段时，通过 `selectColumns` 指定。
    2. **复杂条件查询**: 通过 `lastSql` 可以添加自定义的SQL条件，实现复杂的查询逻辑。
    3. **标准条件查询**: 通过 `whereEntiy` 设置查询条件，实现基于字段的精确查询。
    4. **组合查询**: 可以同时使用 `selectColumns`、`lastSql` 和 `whereEntiy` 实现灵活的组合查询。
  - **注意事项**:
    1. `whereEntiy` 字段中的 "Entiy" 是历史拼写错误，应为 "Entity"，但为保持代码兼容性，当前版本保留此拼写。
    2. `selectColumns` 中的字段名应与数据库表中的列名保持一致，如果不设置则默认查询所有字段。
    3. `lastSql` 中的SQL条件会直接追加到SQL语句末尾，需确保语法正确性，建议使用参数化查询以避免SQL注入风险。
    4. `whereEntiy` 中设置的字段会自动转换为WHERE条件，未设置的字段不会作为条件，支持多个条件的AND组合。
- **EdiRunCycleLogQueryResponseVo**: EDI运行周期日志查询响应值对象，用于封装EDI运行周期日志查询返回的数据。该对象包含了EDI接口运行过程中的完整日志信息，包括接口状态、业务数据、跟踪信息等关键内容。
  - **基本信息**:
    - **类名**: `EdiRunCycleLogQueryResponseVo`
    - **包路径**: `com.pobing.servicevo`
    - **实现接口**: `Serializable`
  - **结构属性**:
    - **基础字段**:
      - `id` (Long): 主键ID。
      - `status` (String): 接口状态（1成功，2失败，3异常或其它）。
      - `tenantCode` (String): 租户编码。
      - `projectNo` (String): 项目号。
      - `createTime` (LocalDateTime): 日志的创建时间。
    - **业务标识字段**:
      - `ediNo` (String): EDI编号，用以识别接口。
      - `traceId` (String): 跟踪唯一号，为接口在报文接入时生成的一串号，用于EDI平台日志跟踪。
      - `businessKey` (String): 业务关键字，为业务主键，利于从业务上跟踪数据。
      - `ediPhase` (String): EDI流程阶段。
    - **辅助业务关键字**:
      - `bizKeyOne` (String): 业务关键字，用于辅助识别业务数据（第1个字段）。
      - `bizKeyTwo` (String): 业务关键字，用于辅助识别业务数据（第2个字段）。
      - `bizKeyThree` (String): 业务关键字，用于辅助识别业务数据（第3个字段）。
      - `bizKeyFour` (String): 业务关键字，用于辅助识别业务数据（第4个字段）。
      - `bizKeyFive` (String): 业务关键字，用于辅助识别业务数据（第5个字段）。
    - **内容相关字段**:
      - `verifyStr` (String): 报文指纹串，用于校验报文是否变化。如不需要，该列可不填，由指定业务字段生成或是业务报文串生成。
      - `contentPath` (String): 报文内存存储于S3的ID号。
    - **交易与结果字段**:
      - `responseResult` (String): 执行的返回结果消息。
      - `transactionTime` (String): 交易时间，指接口数据的发生时间，可为业务时间，也可为系统时间。
      - `transactionNo` (Long): 交易号，取当前行处理的时间串，在程序中，可能多个业务的交易号为同一批。
  - **使用场景**:
    1. **EDI接口日志查询**: 查询EDI接口执行日志时，返回该对象包含完整的日志信息。
    2. **业务数据跟踪**: 通过businessKey和bizKey系列字段，可以方便地追踪业务数据。
    3. **问题排查**: 通过traceId可以完整追踪一个EDI请求的整个生命周期。
    4. **报文管理**: 支持报文内容的存储路径和校验，便于后续分析和问题定位。
    5. **日志更新操作**: 该对象也被用于`EdiRunCycleLogUpdateVo`中，作为更新条件和更新内容的载体。
  - **注意事项**:
    1. **状态值规范**: status字段应遵循规范（1: 成功, 2: 失败, 3: 异常或其它）。
    2. **时间字段**: `transactionTime`可以是业务时间或系统时间；`createTime`是日志记录的创建时间，由系统自动生成。
    3. **业务关键字**: `businessKey`是主要的业务标识；`bizKeyOne`至`bizKeyFive`是辅助标识，可根据实际业务需要使用。
    4. **报文存储**: `contentPath`用于存储大报文（S3路径）；`verifyStr`用于报文校验，确保数据完整性。
    5. **与RequestVo的区别**: QueryResponseVo主要用于查询响应和更新操作，不包含contentStr字段（报文内容字符串），仅包含contentPath（S3存储路径）。

## 4. 接口方法说明

### 4.1 insertLogInfo
- **方法签名**: `Revert insertLogInfo(EdiRunCycleLogRequestVo logEntity)`
- **功能说明**: 接收 EDI 接口运行过程中的日志信息，将其持久化存储。
- **参数说明**:
  - `logEntity`: 日志请求对象，需按要求填充业务标识与报文内容。
- **返回说明**: `Revert` 通用响应对象，标识插入操作是否成功。
- **处理逻辑**:
  - 校验 `status` 字段，规范状态值（1:成功，2:失败，3:异常或其它）。
  - 判断报文大小，若为大报文则将内容上传至 S3 并将 ID 存入 `contentPath`；若为小报文则直接存入 `contentStr`。
  - 若未提供 `verifyStr`，则根据指定业务字段或报文串自动生成指纹以校验数据完整性。
  - 若未指定 `createTime`，则由系统自动生成当前时间。

### 4.2 updateLogInfo
- **方法签名**: `Revert updateLogInfo(EdiRunCycleLogUpdateVo logVo)`
- **功能说明**: 根据 ID 或跟踪号更新指定日志的执行状态及返回结果。
- **参数说明**:
  - `logVo`: 日志更新对象，包含待更新的主键/跟踪号及需要变更的状态与结果字段。
- **返回说明**: `Revert` 通用响应对象，标识更新操作是否成功。
- **处理逻辑**:
  - 通过 `traceId` 或 `id` 精准定位日志记录。
  - 更新 `status` 为最终状态（1成功/2失败/3异常）。
  - 记录接口的 `responseResult` 返回结果消息。

### 4.3 selectLogInfoByParams
- **方法签名**: `Revert selectLogInfoByParams(EdiRunCycleLogSelectVo selectVo)`
- **功能说明**: 根据多维度条件查询日志列表，支持分页及业务追踪。
- **参数说明**:
  - `selectVo`: 查询条件对象，可包含租户编码、项目号、EDI编号、业务关键字、时间范围等筛选条件。
- **返回说明**: `Revert` 通用响应对象，其数据部分包含 `EdiRunCycleLogQueryResponseVo` 查询响应结果（含分页数据及日志详情列表）。

### 4.4 getLogContentInfo
- **方法签名**: `Revert getLogContentInfo(EdiRunCycleLogRequestVo selectVo)`
- **功能说明**: 根据条件获取单条日志的完整报文内容详情。
- **参数说明**:
  - `selectVo`: 日志请求对象（复用作为查询条件），通常包含 `id`、`traceId` 或 `contentPath` 等定位信息。
- **返回说明**: `Revert` 通用响应对象，其数据部分包含具体的报文内容字符串或 S3 存储路径信息。

## 5. 使用场景
1. **接口执行拦截**: 在 EDI 接口接入、处理、响应等各阶段拦截，调用 `insertLogInfo` 记录 `ediPhase` 及相关数据。
2. **异常捕获处理**: 当接口发生异常时，调用 `updateLogInfo` 记录状态为 3 的日志，并写入异常信息至 `responseResult`。
3. **业务问题排查**: 调用 `selectLogInfoByParams` 通过 `businessKey` 及辅助业务关键字从业务维度追踪数据。
4. **报文内容审查**: 调用 `getLogContentInfo` 获取完整的请求或响应报文，用于问题定位与数据核对。

## 6. 注意事项
1. **状态值规范**: 调用服务写入 `status` 时，必须严格遵循规范（1: 成功, 2: 失败, 3: 异常或其它）。
2. **交易时间区分**: 注意区分 `transactionTime`（业务发生时间）与 `createTime`（系统记录时间），确保时间维度统计的准确性。
3. **报文存储策略**: 建议大报文必须使用 `contentPath` 存储至 S3，避免数据库字段溢出；小报文使用 `contentStr` 提升查询效率。
4. **辅助业务关键字**: 建议在调用时尽可能填充 `bizKeyOne` 至 `bizKeyFive`，以提供更丰富的业务数据追踪维度。

## 7. 示例代码

```java
// 注入服务
@Autowired
private EdiLogV2Service ediLogV2Service;

public void processEdiInterface() {
    // 1. 创建并保存EDI运行日志请求对象
    EdiRunCycleLogRequestVo logRequest = new EdiRunCycleLogRequestVo();
    logRequest.setTenantCode("TENANT001");
    logRequest.setProjectNo("PROJECT001");
    logRequest.setEdiNo("EDI001");
    logRequest.setTraceId("TRACE123456");
    logRequest.setBusinessKey("BIZKEY001");
    logRequest.setEdiPhase("RECEIVE");
    logRequest.setTransactionTime("2026-02-03 10:00:00");
    logRequest.setContentStr("{\"data\": \"sample\"}");
    
    try {
        // 执行业务逻辑...
        logRequest.setStatus("1");
        logRequest.setResponseResult("处理成功");
        ediLogV2Service.insertLogInfo(logRequest);
    } catch (Exception e) {
        // 2. 异常时更新日志状态
        EdiRunCycleLogUpdateVo updateVo = new EdiRunCycleLogUpdateVo();
        updateVo.setTraceId("TRACE123456");
        updateVo.setStatus("3");
        updateVo.setResponseResult("处理异常: " + e.getMessage());
        ediLogV2Service.updateLogInfo(updateVo);
    }
    
    // 3. 查询日志列表
    EdiRunCycleLogSelectVo selectVo = new EdiRunCycleLogSelectVo();
    selectVo.setTenantCode("TENANT001");
    selectVo.setEdiNo("EDI001");
    Revert queryResult = ediLogV2Service.selectLogInfoByParams(selectVo);
    
    // 4. 获取报文内容
    EdiRunCycleLogRequestVo contentSelect = new EdiRunCycleLogRequestVo();
    contentSelect.setContentPath("/path/to/content");
    Revert contentResult = ediLogV2Service.getLogContentInfo(contentSelect);
}
