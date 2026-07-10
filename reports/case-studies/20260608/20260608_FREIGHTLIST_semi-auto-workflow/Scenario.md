# Scenario

## Requirement

补充 `IcAutoModeServiceImpl.semiAutoWorkflow` 方法逻辑：
1. 从 meta 获取上一次 ic_section_header（`lastIcHeader`）的 `generatedPendingReleaseFlag`
2. flag=1 表示上一次已发送过待 release 的 AR 费用，进入 AP 费用处理流程（空函数占位）
3. flag=0 或无记录表示未发送过待 release 的 AR 费用，进入 AR 费用处理流程（空函数占位）

## Acceptance Criteria

- AC-1: semiAutoWorkflow 读取 meta.lastIcHeader.generatedPendingReleaseFlag 作为分支判断依据
- AC-2: flag=1 时调用 AP 费用处理占位方法
- AC-3: flag=0 或 lastIcHeader 为 null 时调用 AR 费用处理占位方法
- AC-4: 两个占位方法为空实现，带 TODO 标记
