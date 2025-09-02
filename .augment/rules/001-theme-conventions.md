# Augment Rules: PlantUML Theme Conventions

These rules document how themes should be structured and implemented in this repository, and how examples are organized so future Augment sessions can act consistently.

## Theme directory layout

Each theme lives in its own top-level directory:

- <theme-name>/
  - puml-theme-<theme-name>.puml  (the theme file; follows PlantUML local theme naming)
  - README.md                     (palette, usage, accessibility notes)
  - examples/                     (runnable .puml examples for core diagrams)

## Theme file naming and usage

- File must be named: puml-theme-<name>.puml
- To use locally from another file:
  - Prefer: `!theme <name> from /absolute/or/relative/path/to/<name>`
  - For broader compatibility: `!include ../puml-theme-<name>.puml`
- Avoid PlantUML color function assignments into variables in themes (older versions may error). Prefer literal hex colors or function calls directly in skinparam where known to work.

## Accessibility and dark-mode guidance

- Default canvas background should be explicit (avoid transparent unless required by embedding).
- Provide a palette that:
  - Is legible on a dark background
  - Uses colors distinguishable under common color vision deficiencies (Okabe–Ito recommended)
- Provide non-color redundancy where emphasis is needed (e.g., icon + bold in `$emph()`)
- Test major diagram types: sequence, usecase, class, activity, component, state, object, deployment, timing

## Procedures

- Common helpers are encouraged for consistent labeling:
  - `$emph("<msg>")` – emphasis accent + bold + icon
  - `$success("<msg>")`, `$warning("<msg>")`, `$failure("<msg>")`
- Keep procedures simple; prefer plain `<font color=...><b>...</b></font>` constructs for wide compatibility.

## Skinparam expectations

- For each diagram family (sequence, usecase, class, activity, component, state, object, node/deployment, database, artifact, package/frame/rectangle):
  - Set BackgroundColor, BorderColor, FontColor explicitly
  - Avoid relying on PlantUML defaults (often white) that may break dark themes
- Title, legend, and note should be styled to match background (no white boxes)

## Example diagrams

- Place examples under `<theme>/examples/*.puml`
- Each example should include the theme using a relative path so it can render in isolation:
  - `!theme <name> from ..` or `!include ../puml-theme-<name>.puml`
- Examples should compile on commonly installed PlantUML versions (avoid cutting-edge syntax unless noted in README)

## Git hygiene

- Generated outputs must not be committed. `_out` is ignored repo-wide.
- Also ignore PlantUML cache folders/files (see repo .gitignore).


