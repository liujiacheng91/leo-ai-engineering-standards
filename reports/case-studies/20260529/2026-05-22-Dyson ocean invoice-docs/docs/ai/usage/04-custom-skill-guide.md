# 使用方式 4：自定义 Skill

## 目录结构

```text
.claude/skills/my-custom-skill/
├── SKILL.md
├── references/
│   └── Template.md
├── examples/
│   └── sample.md
└── scripts/
    └── validate.sh
```

## 必须遵守

- 一个 Skill 解决一个可重复任务；
- description 写清楚触发场景；
- 大模板放 references；
- 输出必须使用标准文档名称；
- 输出必须落到标准 case folder；
- 自定义 Skill 不得绕过风险、验证和安全规则。
