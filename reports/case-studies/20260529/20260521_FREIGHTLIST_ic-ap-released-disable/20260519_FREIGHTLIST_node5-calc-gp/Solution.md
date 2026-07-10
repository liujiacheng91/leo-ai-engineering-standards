# Solution.md

## Case Info

- Case ID: 20260519_FREIGHTLIST_node5-calc-gp
- Risk Level: Yellow

## Technical Constraints

- Java 21
- BigDecimal 运算：add/subtract/compareTo，不用运算符
- 站点匹配：必须用 meta.isStationsEqual()（支持 CN-HK 映射），不能直接 HashMap.get()
- calcFlGpByStation() 返回 Map 的 key 是 cdflStationCode，POM 的 agentCode 是 flAspAgentCode，二者可能不同但通过 isStationsEqual 等价
- ThirdParty 字段保持现有注释/跳过状态
- 构造器注入，不用字段 @Autowired

## Recommended Solution

在 Node5ProfitShare.calcGp() 中：

1. 调用 `meta.calcFlGpByStation()` 获取各站点 GP（Map<String, BigDecimal>）
2. 遍历 `meta.sectionPomList`，对每个 POM 条目用 `isStationsEqual` 在 GP Map 中查找匹配站点的 GP 值
3. 按 AgentType 赋值到 freightListGpEntity 的对应字段（ORG -> Origin, DST -> Destination, SAL -> Sale1/Sale2）
4. 计算 Total = Origin + Destination + Sale1 + Sale2

新增私有辅助方法 `getGpByAgentCode(meta, gpByStation, agentCode)` 封装站点匹配逻辑。

新增 `import java.util.Map`。

## Track B Declaration

Worktree 构建预计受 JGit/versioning 兼容性影响，无法在 worktree 内执行 gradle test。

### Post-Merge Test Plan

- Command: `gradle :expand:business-freightlist-summary:test`
- Owner: Liangwb
- Timing: 合并到 develop_1.1.0 后第一时间执行
