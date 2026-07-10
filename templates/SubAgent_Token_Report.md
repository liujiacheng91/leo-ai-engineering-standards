# SubAgent_Token_Report.md

> 使用场景：Mode 3（大功能 SubAgent 分组模式）中，每个 SubAgent Group 完成后填写。
> 最终由主 Claude 汇总进 `Token_Usage_Report.md` Stage-Level 表和 Task-Level 合计行。

---

## Case Info

| Field | Value |
|---|---|
| Case ID | |
| Group / SubAgent Name | |
| Parent Task | |
| Execution Mode | Mode 3 — Large Feature SubAgent |
| Date | |

---

## Input Scope

[本 SubAgent 被分配的输入范围：读取的文件、输入 Prompt 的内容摘要]

- Files read:
- Context provided (summary):

---

## Output Deliverables

[本 SubAgent 产出的文件 / 代码 / 文档清单]

| Deliverable | Output Path | Status |
|---|---|---|

---

## Token Detail

| Layer | Input Token | Output Token | Total Token | Model | Cost (USD) |
|---|---|---|---|---|---|
| SubAgent self-reported | | | | | |

> SubAgent 必须在最终输出的最后一行追加：
> ```
> Token usage: input=<n>, output=<n>, total=<n>
> ```
> 如未追加，主 Claude 须在 `Token_Usage_Report.md` Memory/Sub Agent 列记录 `subAgent tokens not included`，并在 Abnormal Cost Review 中补一行 `subAgent tokens not reconciled`。

---

## Quality Check

- [ ] Output matches deliverable list above
- [ ] `Token usage:` line appended to final output
- [ ] No files read outside declared input scope
- [ ] Model used matches Model Selection matrix (see `skills/ll-dev/SKILL.md`)
- [ ] Reference files >1,000 lines were summarized before targeted reading
