# Scenario

## Requirement

补充 IcAutoModeServiceImpl.processApCharges 方法逻辑：
1. 先调用 isAllArChargesReleased 判断所有AR费用是否已release
2. 未全部release时调用 processArCharges 处理AR费用并返回
3. 全部release后调用 executeApChargesProcessing 处理AP费用
4. isAllArChargesReleased 和 executeApChargesProcessing 均为占位函数

## Acceptance Criteria

- AC-1: processApCharges 先调用 isAllArChargesReleased 判断
- AC-2: isAllArChargesReleased 返回 false 时调用 processArCharges 并 return
- AC-3: isAllArChargesReleased 返回 true 时调用 executeApChargesProcessing
- AC-4: isAllArChargesReleased 为占位方法，默认返回 false，带 TODO
- AC-5: executeApChargesProcessing 为占位方法，带 TODO
