# Task：IC Trans Final 内部交易号改造

> case-id：20260511_FREIGHTLIST_ic-final-shared-trans-no
> 分支：feat/ic-final-shared-trans-no
> 风险等级：🟡 Yellow（Solution.md 已用户 sign-off）

---

## 子任务列表

### T-1：新增 IGlobalMonotonicService 接口

**Input**：bus-task-control-handler-service 中的 GlobalMonotonicService 接口（`com.pobing.parent.dispatch.core.v1.service.GlobalMonotonicService`）

**Output**：`expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/IGlobalMonotonicService.java`

**改动内容**：
- 包名改为 `com.pobing.bus.freight.list.summary.service`
- 接口名加 `I` 前缀（本仓库命名惯例 `IXxxService`）
- 保留 4 个方法：`nextEpoch` / `parseDate` / `parseSequence` / `getStatus`
- 加类头 Javadoc（按 code_style.md 模板）

**完成标准**：文件编译无误，接口方法签名与源接口一致

**验证**：`gradle :expand:business-freightlist-summary:compileJava` 无报错

---

### T-2：新增 GlobalMonotonicServiceImpl 实现

**Input**：bus-task-control-handler-service 中的 GlobalMonotonicServiceImpl（`com.pobing.parent.dispatch.core.v1.service.impl.GlobalMonotonicServiceImpl`）

**Output**：`expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/service/impl/GlobalMonotonicServiceImpl.java`

**改动内容**：
- 包名改为 `com.pobing.bus.freight.list.summary.service.impl`
- `implements GlobalMonotonicService` 改为 `implements IGlobalMonotonicService`（本包接口）
- 删除字段 `@Autowired`，改为 `private final RedissonService redissonService;` + 构造器注入（红线要求）
- `RedissonService` import 路径：`com.pobing.bus.platform.redis.service.RedissonService`（本仓库已有依赖）
- 加类头 Javadoc
- 业务逻辑保持原样（Redis key 前缀 `global:monotonic:`、`synchronized` 方法、`formatEpoch` 等）

**完成标准**：文件编译无误，Spring 能注入（`@Service` 注解），Redis key 格式与源实现一致

**验证**：`gradle :expand:business-freightlist-summary:compileJava` 无报错

---

### T-3：修改 Node2IcTransFinalCalc.java — 注入 & 取 transNo

**Input**：`expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/node/ic/transfinal/Node2IcTransFinalCalc.java`（现有文件）

**改动内容**：
1. 新增 import：`com.pobing.bus.freight.list.summary.service.IGlobalMonotonicService`
2. 删除 import：`com.pobing.bus.freight.list.summary.utils.CustomTypeConvertUtils`（仅用于 `toFourDigits`，改造后无其他用途）
3. 新增字段：`private final IGlobalMonotonicService globalMonotonicService;`
4. 新增构造器：`public Node2IcTransFinalCalc(IGlobalMonotonicService globalMonotonicService) { this.globalMonotonicService = globalMonotonicService; }`
5. `buildIcTransFinal` 方法内：
   - 删除 `int index = 0;`
   - 循环体开头新增 try/catch 取 `internalTransNo`（调用 `nextEpoch("INTERNAL_TRANS_NO")`）
   - catch 内：`log.error + continue`
   - 三处 `buildFinalEntity(..., ++index)` 改为 `buildFinalEntity(..., internalTransNo)`
   - 三处 `meta.getIcTransactionFinalList().add(...)` 仅在 try 成功路径执行

**完成标准**：
- `@LiteflowComponent("ic_trans_final_calc")` 字符串未改
- `process()` 外层吞异常模板未动
- 循环内 try/catch 是 `log.error + continue`，不 rethrow

**验证**：`gradle :expand:business-freightlist-summary:compileJava` 无报错

---

### T-4：修改 Node2IcTransFinalCalc.java — buildFinalEntity 签名

**Input**：同上（与 T-3 同一文件，T-4 是 T-3 的延续）

**改动内容**：
- `buildFinalEntity` 签名：最后一个参数 `int index` → `String internalTransNo`
- 方法体内：`entity.setInternalTransNo(CustomTypeConvertUtils.toFourDigits(index));` → `entity.setInternalTransNo(internalTransNo);`

**完成标准**：`buildFinalEntity` 方法体内无 `CustomTypeConvertUtils` 引用，方法签名明确接受 `String internalTransNo`

**验证**：编译通过 + 无残留 `index` 引用

---

### T-5：验证 buildIcTransFinalChange 行为（无需代码改动）

**分析**：`buildIcTransFinalChange` 通过 `BeanUtils.copyProperties(finalEntity, change)` 把 `IcTransactionFinalEntity` 的所有字段（含 `internalTransNo`）拷贝到 `IcTransactionFinalChangeEntity`。改造后 `finalEntity.internalTransNo` 已是新格式的 `String`，`BeanUtils.copyProperties` 自然复制，无需任何代码改动。

**完成标准**：代码审查确认 `IcTransactionFinalChangeEntity` 有 `internalTransNo` 字段且 `BeanUtils.copyProperties` 覆盖该字段

**验证**：grep 确认 IcTransactionFinalChangeEntity 有 `internalTransNo` 字段

---

### T-6：修改 CustomTypeConvertUtils.java — 标记 @Deprecated

**Input**：`expand/business-freightlist-summary/src/main/java/com/pobing/bus/freight/list/summary/utils/CustomTypeConvertUtils.java`

**改动内容**：在 `toFourDigits` 方法上方新增：
```java
/** 已弃用：IC Final 编号改由 GlobalMonotonicService.nextEpoch 提供，仅保留备查。 */
@Deprecated
```

**完成标准**：方法体保留不动，工具类其他方法不动

**验证**：编译通过，`@Deprecated` 注解存在

---

### T-7：红线自检（贯穿所有子任务）

检查清单：
- [ ] `@LiteflowComponent("ic_trans_final_calc")` 字符串未改
- [ ] `Node2IcTransFinalCalc` 类名未改
- [ ] `process()` 外层吞异常模板未动
- [ ] 循环内 try/catch 是 `log.error + continue`，不 rethrow
- [ ] 所有新增字段用 `final` + 构造器注入（包括 GlobalMonotonicServiceImpl 的 RedissonService）
- [ ] 没动 `*-prod.yml` / `bootstrap.yml` / schema / mapper XML / Kafka 配置
- [ ] 中文注释 + 中文 Javadoc

---

## 测试矩阵概要

| 用例 | 类型 | 关键断言 |
|---|---|---|
| N-1：3 条 IC 交易正常 | Normal | `nextEpoch` 调 3 次，`finalList.size()==9`，每组 3 行同 transNo，跨组不同 |
| N-2：1 条 IC 交易 | Normal | `nextEpoch` 调 1 次，3 行同 transNo |
| N-3：发号顺序 | Normal | 第 i 条 transaction 的 3 行 transNo == `String.valueOf(i+1)` |
| B-1：空列表 | Boundary | `nextEpoch` 不被调用，`finalList` 为空 |
| B-2：metaList 为空 | Boundary | 节点直接返回 |
| B-3：0L / MAX_VALUE | Boundary | `String.valueOf` 正确处理 |
| NG-1：第 2 条抛异常 | Negative | `finalList.size()==6`，有 error log，节点不 rethrow |
| NG-2：全部抛异常 | Negative | `finalList` 为空，节点不中断 |
| R-1：Change 同步 transNo | Regression | `IcTransactionFinalChangeEntity.internalTransNo` 与对应 Final 一致 |
| R-3：Node3Save 6 行正常 | Regression | `saveBatch(6)` 正常执行 |
| DC-1：数据库比对 | Data Comparison | 同一 interlink 的 3 行 `internal_trans_no` 相同，跨 interlink 不同 |

详细用例由 qa-engineer 在 Test.md 中展开。

---

## 改动文件清单

| 文件 | 操作 | 说明 |
|---|---|---|
| `service/IGlobalMonotonicService.java` | 新增 | 全局单调递增序列号服务接口（复制自 bus-task-control） |
| `service/impl/GlobalMonotonicServiceImpl.java` | 新增 | 接口实现，构造器注入 RedissonService |
| `node/ic/transfinal/Node2IcTransFinalCalc.java` | 修改 | 注入 IGlobalMonotonicService，改造 buildIcTransFinal + buildFinalEntity |
| `utils/CustomTypeConvertUtils.java` | 修改 | `toFourDigits` 方法加 `@Deprecated` |
