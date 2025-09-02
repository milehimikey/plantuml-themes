# Contributing

This repo uses trunk-based development with Conventional Commits and automated semantic versioning.

- Default branch: `main`
- Prefer small PRs targeting `main`
- Use squash merge and ensure the PR title follows Conventional Commits

## Conventional Commits

Format:
```
<type>(optional scope)!: <short summary>

[optional body]
[optional footer(s)]
```
Common types:
- feat: a new feature (may bump minor)
- fix: a bug fix (may bump patch)
- docs: docs-only changes
- style: formatting, missing semicolons, etc; no code change
- refactor: code change that neither fixes a bug nor adds a feature
- perf: a code change that improves performance
- test: adding missing tests or correcting existing tests
- chore: other changes (tooling, build, CI)

A breaking change adds `!` after the type/scope and includes a `BREAKING CHANGE:` footer; it bumps major.

## Releases

GitHub Actions (release-please) creates a release PR based on commit history. When you merge that PR, a tag and GitHub Release are created using semantic versioning.

## Local development

- Themes should follow `.augment/rules/001-theme-conventions.md`
- Examples should compile with common PlantUML versions; see `.augment/rules/002-rendering.md`
- Generated outputs under `**/_out/**` are ignored; do not commit them

