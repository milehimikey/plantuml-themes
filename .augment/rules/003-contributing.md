# Augment Rules: Contributing New Themes

Steps and checks for adding a new theme.

## 1) Scaffold

- Create `<theme-name>/` at repo root
- Add `puml-theme-<theme-name>.puml`
- Add `README.md` summarizing palette and accessibility goals
- Add `examples/` with at least the core diagrams:
  - sequence, usecase, class, activity, component, state, object, deployment, timing

## 2) Implementation tips

- Prefer literal hex colors for BackgroundColor/BorderColor/FontColor
- Avoid assigning `%lighten/%darken` results to variables; if used, apply inline and be prepared to pin hex values for compatibility
- Provide procedures `$emph`, `$success`, `$warning`, `$failure` for consistent labeling
- Style title, legend, note, and common containers (package/frame/rectangle) to avoid white boxes

## 3) Examples

- Reference the theme using a relative path so examples render standalone:
  - `!theme <name> from ..` or `!include ../puml-theme-<name>.puml`
- Demonstrate non-color redundancy (icons, bold, shapes) in at least one example

## 4) Render and verify

- Run `scripts/render-all.sh -t <theme-name>` (or the Python equivalent)
- Inspect outputs in `<theme>/examples/_out/{png,svg}`
- Check for:
  - Readable text on dark backgrounds
  - No white boxes for titled sections, notes, containers
  - Arrow visibility and lifelines (sequence)
  - Legibility with color-blind simulators (optional but recommended)

## 5) Conventional Commits and releases

- Use Conventional Commit titles on PRs; with squash merge the PR title becomes the commit analyzed by release automation
  - `feat(scope): ...` → minor, `fix(scope): ...` → patch, `type(scope)!: ...` + BREAKING CHANGE footer → major
- Do not tag releases manually; GitHub Action (release-please) opens a release PR on push to `main` when there are release-worthy commits
- To force a release (docs/chore only), add a commit footer: `Release-As: X.Y.Z`

## 6) Git hygiene

- Do not commit outputs in `_out/`
- Keep `.gitignore` entries for PlantUML caches


