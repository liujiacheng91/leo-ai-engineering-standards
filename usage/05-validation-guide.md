# 使用方式 5：案例校验

## Green

```bash
./scripts/validate_ai_case.sh docs/ai/cases/<case-id> --risk green
```

## Yellow Strict

```bash
./scripts/validate_ai_case.sh docs/ai/cases/<case-id> --risk yellow --strict --require-case-card --require-token-report
```

## Red

```bash
./scripts/validate_ai_case.sh docs/ai/cases/<case-id> --risk red --require-case-card
```
