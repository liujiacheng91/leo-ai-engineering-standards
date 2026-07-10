# QA_Retry_Root_Cause.md

> 使用场景：每次 Self-Fix（自修复）完成后，填写此模板并存档至 `docs/ai/cases/<case-id>/`，或追加到 `Test.md` Fix History 表。
> 目标：将每次失败转化为可复用的 convention，避免下次案例重复同类错误。

---

## Retry 编号

Fix #[N] — Case: [案例 ID]

---

## 触发现象

[测试 / 构建 / 验证失败时的报错信息或症状，粘贴原始错误输出]

```
[paste error output here]
```

---

## 根本原因

[为什么会失败？具体到类 / 方法 / 配置项层面。避免"代码有问题"等模糊描述。]

---

## 修复动作

[实际修改了什么。文件 + 行数 + 前后对比。]

| File | Line | Before | After |
|---|---|---|---|

---

## 预防规则

[下次可加入哪个文件的具体条目，使该类问题不再出现。每条规则必须具体到可直接粘贴的文本，而不是"增加注意事项"。]

| 落地文件 | 具体条目（可直接粘贴的文本） |
|---|---|
| `templates/Test.md` Mock Strategy | |
| `templates/CLAUDE.md` Section 2.5 | |
| `docs/ai/cases/<case-id>/Solution.md` | |

---

## 可复用资产

[本次修复产生了哪些可在其他案例中复用的代码 / 规则 / 模板片段]

| 资产类型 | 内容 | 适用场景 |
|---|---|---|
