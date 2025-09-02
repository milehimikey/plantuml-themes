# Augment Rules: Rendering Themes and Examples

Guidelines for using the rendering scripts added to this repository.

## Renderer detection

The scripts support multiple ways to locate PlantUML:
- `plantuml` on PATH
- `PLANTUML` env var pointing to an executable CLI
- `PLANTUML_JAR` env var pointing to `plantuml.jar` (requires `java`)

If none are found, scripts exit with a clear message.

## Scripts

- Bash: `scripts/render-all.sh`
- Python: `scripts/render_all.py`

Both scripts:
- Discover all theme directories in the repo by finding `puml-theme-*.puml`
- For each theme, render all `.puml` files in `<theme>/examples/`
- Write results into `<theme>/examples/_out/<format>/`
- Support formats: `png`, `svg` (both by default)
- Support filtering to a single theme via `-t/--theme`

Examples:
```
# Render all themes (PNG+SVG)
scripts/render-all.sh
python scripts/render_all.py

# Only PNG
scripts/render-all.sh -f png
python scripts/render_all.py --format png

# Only one theme
scripts/render-all.sh -t starlight
python scripts/render_all.py --theme starlight

# Using a jar
PLANTUML_JAR=/path/plantuml.jar scripts/render-all.sh
PLANTUML_JAR=/path/plantuml.jar python scripts/render_all.py
```

## Output and git

- Outputs go to `<theme>/examples/_out/{png,svg}` and are ignored by git.
- Do not commit generated artifacts.

## Troubleshooting

- If a diagram renders blank or errors with "no such color":
  - Prefer `!include` to include the theme directly: `!include ../puml-theme-<name>.puml`
  - Avoid declaring variables assigned from color functions (e.g., `%lighten(...)` into a variable)
  - Pin colors to literal hex in theme skinparams
- Online PlantUML servers cannot access local themes; render locally.
- If a preview forces a white canvas, ensure the theme sets a dark `BackgroundColor` for the diagram (avoid `transparent` unless required).


