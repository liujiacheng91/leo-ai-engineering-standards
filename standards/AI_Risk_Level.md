# AI Risk Level Standard

## Green

AI 可自主实现、测试、验证。

适合：文档补齐、测试用例生成、简单 CRUD、代码解释、旧代码梳理、接口参数提取、非核心功能迭代。

## Yellow

AI 可实现，但必须人工确认方案和结果。

适合：字段 Mapping、XML / JSON 转换、报表 SQL、客户差异化逻辑、多服务调用、历史系统迁移辅助。

## Red

AI 只允许分析和建议，不允许自主修改或合并。

适合：认证、授权、加密、审计、生产配置、生产数据、DB schema、核心业务规则。

## Rule

```text
No Risk Level, No AI Execution.
```
