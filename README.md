# PlantUML Themes

This repository hosts reusable PlantUML themes and examples. Themes are designed to be dark, high-contrast, and color‑blind–friendly.

## Themes

- starlight — dark theme with Okabe–Ito palette and accessible emphasis helpers

Each theme directory contains:
- `puml-theme-<name>.puml` — the theme file (local and remote usage)
- `README.md` — palette, usage, accessibility notes
- `examples/` — runnable .puml examples for core diagrams

## Remote usage from GitHub

Use themes directly from raw.githubusercontent.com.

- Latest from main (example for starlight):
```
!theme starlight from https://raw.githubusercontent.com/milehimikey/plantuml-themes/main/starlight
```
- Pin to a tagged release (stable):
```
!theme starlight from https://raw.githubusercontent.com/milehimikey/plantuml-themes/v1.0.0/starlight
```
- Pin to an exact commit (fully reproducible):
```
!theme starlight from https://raw.githubusercontent.com/milehimikey/plantuml-themes/<commit-sha>/starlight
```

Fallback for older PlantUML versions (direct include):
```
!includeurl https://raw.githubusercontent.com/milehimikey/plantuml-themes/main/starlight/puml-theme-starlight.puml
```

## Rendering locally

- Bash: `scripts/render-all.sh` (supports `-t <theme>` and `-f png|svg`)
- Python: `scripts/render_all.py`
- Outputs: `<theme>/examples/_out/{png,svg}` (ignored by git)

## Contributing and releases

- Trunk-based development on `main`
- Conventional Commits are required (see `.github/commit-convention.md` and `CONTRIBUTING.md`)
- Automated semantic versioning and GitHub Releases via release-please
  - A release PR will be opened automatically based on commit history
  - Merge the release PR to cut a new tag (e.g., `v1.0.0`) and publish a release

## Repo rules for Augment

See `.augment/rules/` for conventions on themes, rendering, and contributing.

