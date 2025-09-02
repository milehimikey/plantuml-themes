# Conventional Commits

Format:
```
<type>(optional scope)!: <short summary>

[optional body]
[optional footer(s)]
```

Types:
- feat: new feature (minor)
- fix: bug fix (patch)
- docs, style, refactor, perf, test, chore: no version bump unless marked breaking

Breaking changes:
- Add `!` after type/scope and include a `BREAKING CHANGE:` footer
- Triggers a major version

Examples:
- `feat(theme): introduce starlight dark theme`
- `fix(sequence): correct white box background`
- `chore(ci): add release automation`

