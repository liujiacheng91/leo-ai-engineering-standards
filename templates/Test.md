# Test.md

## Test Objective

[简述本次测试目标，与 Task.md 中的验收条件对应]

---

## Test Scope

[说明测试覆盖范围：哪些类 / 方法 / 流程被测试，哪些明确排除]

- In scope:
- Out of scope:

---

## Test Data

[列出测试所需的输入数据、边界值、异常值，与 Boundary Cases 配合使用]

| Case | Input | Expected |
|---|---|---|

---

## Mock Strategy

[明确 Mock 框架、Mock 对象、Stub 设置方式。在写任何测试代码前填写此节。]

- Mock framework: [Mockito / MockK / other]
- Objects to mock: [列出需要 mock 的依赖类]
- Stub setup location: [@BeforeEach / inline in each test]
- Strictness setting: [STRICT_STUBS (default) / LENIENT — 说明选择理由]

**Mockito 引入前必读：**

1. primitive 类型参数（`int` / `long` / `boolean`）必须用 `anyInt()` / `anyLong()` / `anyBoolean()`，不能用 `any()`
2. `@BeforeEach` 中设置的共享 stub，若并非所有测试都用到，须在类上标注 `@MockitoSettings(strictness = Strictness.LENIENT)`；否则 strict 模式会抛 `UnnecessaryStubbingException`
3. 仓库内无 Mockito 先例时，在 `Solution.md` 中预先记录 strictness 设置，避免合并后才暴露问题

---

## Test Types

- [ ] Unit Test
- [ ] Integration Test
- [ ] API Contract Test
- [ ] UI Test
- [ ] E2E Test
- [ ] Regression Test
- [ ] Security Test
- [ ] Manual Verification

---

## Test Matrix

| Case ID | Type | Input | Expected Result | Priority | Related AC |
|---|---|---|---|---|---|

---

## Boundary Cases

[列出空值、最大值、并发、重复提交等边界场景]

| Scenario | Input | Expected Behavior |
|---|---|---|

---

## API Test Cases

> 涉及 REST API 的场景必填此节。API 测试可以发现单元测试无法暴露的接口异常、状态流转错误和权限缺失。

| API | Method | Auth | Request Body | Expected Status | Expected Response | Related AC |
|---|---|---|---|---|---|---|

### Error Code Coverage

| Error Scenario | Request | Expected Status | Expected Error Code / Message |
|---|---|---|---|

---

## Permission & Security Checklist

> 涉及权限控制、多角色、敏感数据的场景必填此节。

| Check Item | Test Method | Result |
|---|---|---|
| 未授权用户访问受保护 API | 不带 Token 请求 → 401 | |
| 低权限用户访问高权限功能 | 用低权限角色请求高权限 API → 403 | |
| 跨租户 / 跨组织数据隔离 | 用 A 租户凭证访问 B 租户数据 → 403 或空 | |
| SQL 注入测试 | 注入常见 payload → 无异常执行 | |
| XSS 测试（若有前端） | 注入 script 标签 → 被转义 | |
| 敏感数据脱敏 | 检查日志和响应体 → 无明文密码/身份证/银行卡 | |

### Permission Matrix Test (if applicable)

| Role | Create | Read | Update | Delete | Special Operations |
|---|---|---|---|---|---|

---

## Commands

```bash
# Build
# Unit Test
# Integration Test
# API Test
# Lint
# Coverage
```

---

## Pass Criteria

- [ ] All new tests passed
- [ ] Related existing tests passed
- [ ] Build passed
- [ ] Lint passed
- [ ] API key paths tested (if applicable)
- [ ] Permission matrix verified (if applicable)
- [ ] No high-risk security issue
- [ ] No sensitive data exposed

---

## Fix History

> 每次 Self-Fix 完成后必须在此追加一行。目标：将每次失败转化为可复用的 convention，避免同类问题在下个案例重复出现。

| Fix # | Symptom | Root Cause | Fix Action | Prevention Rule |
|---|---|---|---|---|
