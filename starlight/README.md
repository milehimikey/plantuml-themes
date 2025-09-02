# Starlight PlantUML Theme

Dark, color‑blind–friendly theme using an Okabe–Ito–inspired palette.

## Usage

Local theme reference from another diagram file:

```
!theme starlight from /absolute/or/relative/path/to/starlight
```

In this repo’s examples (sibling folder):

```
!theme starlight from ..
```

Remote usage from GitHub (recommended)
- Latest from main:
```
!theme starlight from https://raw.githubusercontent.com/milehimikey/plantuml-themes/main/starlight
```
- Pinned to a tag (stable):
```
!theme starlight from https://raw.githubusercontent.com/milehimikey/plantuml-themes/v1.0.0/starlight
```
- Pinned to a commit:
```
!theme starlight from https://raw.githubusercontent.com/milehimikey/plantuml-themes/<commit-sha>/starlight
```

Fallback for older PlantUML versions (direct include):
```
!includeurl https://raw.githubusercontent.com/milehimikey/plantuml-themes/main/starlight/puml-theme-starlight.puml
```

## Emphasis helpers

- $emph("<msg>") — blue accent + bold + star icon
- $success("<msg>") — green accent + bold
- $warning("<msg>") — yellow accent + bold
- $failure("<msg>") — red accent + bold

Example use:

```
Bob -> Alice : $emph("Important step")
```

## Palette

- Background: #0E1116
- Surface: #111827
- Border: #334155
- Text: #E6EDF3 (muted: #B6C2CF)
- Accents: blue #56B4E9, orange #E69F00, green #009E73, yellow #F0E442, red #D55E00, purple #CC79A7, gray #999999, cyan #00BFC4

## Accessibility notes

- High contrast against dark backgrounds
- Accent colors chosen for common color‑vision deficiencies
- Non‑color redundancy (bold, star icon) in $emph()

## Examples

See the examples folder and render with your PlantUML setup. Each example includes `!theme starlight from ..`.

