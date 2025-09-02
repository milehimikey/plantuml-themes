#!/usr/bin/env bash
# Render all example diagrams for every theme in this repo.
# Works with either:
#   - plantuml on PATH
#   - PLANTUML env var pointing to a plantuml CLI
#   - PLANTUML_JAR env var pointing to a plantuml.jar (requires java)
#
# Usage:
#   scripts/render-all.sh                        # render PNG and SVG for all themes/examples
#   scripts/render-all.sh -f png                 # only PNG
#   scripts/render-all.sh -f svg                 # only SVG
#   scripts/render-all.sh -t starlight           # only the 'starlight' theme
#   PLANTUML_JAR=/path/plantuml.jar scripts/render-all.sh
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FORMATS=(png svg)
THEME_FILTER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--format)
      shift
      case "${1:-}" in
        png) FORMATS=(png) ;;
        svg) FORMATS=(svg) ;;
        both|all) FORMATS=(png svg) ;;
        *) echo "Unknown format: $1" >&2; exit 2 ;;
      esac
      ;;
    -t|--theme)
      shift
      THEME_FILTER="${1:-}"
      ;;
    -h|--help)
      sed -n '1,40p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
  shift || true
done

find_renderer() {
  if [[ -n "${PLANTUML:-}" ]]; then
    PLANTUML_CMD=("$PLANTUML")
    return 0
  fi
  if command -v plantuml >/dev/null 2>&1; then
    PLANTUML_CMD=(plantuml)
    return 0
  fi
  if [[ -n "${PLANTUML_JAR:-}" ]]; then
    if ! command -v java >/dev/null 2>&1; then
      echo "java not found; required when using PLANTUML_JAR=$PLANTUML_JAR" >&2
      return 1
    fi
    PLANTUML_CMD=(java -jar "$PLANTUML_JAR")
    return 0
  fi
  echo "PlantUML not found. Install 'plantuml' or set PLANTUML or PLANTUML_JAR env var." >&2
  return 1
}

render_file() {
  local format="$1"; shift
  local example_dir="$1"; shift
  local infile="$1"; shift

  local outdir_rel="_out/${format}"
  local outdir="${example_dir}/${outdir_rel}"
  mkdir -p "$outdir"

  # -charset for safety; -t<fmt>; -o is relative to input dir
  ( cd "$example_dir" && "${PLANTUML_CMD[@]}" -charset UTF-8 -t"$format" -o "$outdir_rel" "$(basename "$infile")" )
}

render_theme_examples() {
  local theme_dir="$1"
  local theme_name="$2"
  local examples_dir="$theme_dir/examples"
  if [[ ! -d "$examples_dir" ]]; then
    echo "[skip] $theme_name: no examples/ directory"
    return 0
  fi

  local total=0 ok=0 fail=0
  shopt -s nullglob
  local files=("$examples_dir"/*.puml)
  shopt -u nullglob
  if (( ${#files[@]} == 0 )); then
    echo "[skip] $theme_name: no .puml files under examples/"
    return 0
  fi
  echo "[info] Rendering theme '$theme_name' examples (${#files[@]} files) ..."
  for f in "${files[@]}"; do
    for fmt in "${FORMATS[@]}"; do
      ((total++))
      if render_file "$fmt" "$examples_dir" "$f"; then
        ((ok++))
        echo "  [ok] $(basename "$f") -> ${fmt}"
      else
        ((fail++))
        echo "  [fail] $(basename "$f") -> ${fmt}" >&2
      fi
    done
  done
  echo "[done] $theme_name: $ok/$total succeeded ($fail failed)"
}

main() {
  if ! find_renderer; then exit 1; fi

  local theme_dirs=()
  # A theme directory is any top-level directory containing puml-theme-*.puml
  while IFS= read -r -d '' p; do
    theme_dirs+=("$(dirname "$p")")
  done < <(find "$REPO_ROOT" -maxdepth 2 -type f -name 'puml-theme-*.puml' -print0)

  # Normalize unique list
  local uniq_theme_dirs=()
  local seen=""
  for d in "${theme_dirs[@]}"; do
    [[ -z "$d" ]] && continue
    if [[ ":$seen:" != *":$d:"* ]]; then
      seen+="${seen:+:}$d"
      uniq_theme_dirs+=("$d")
    fi
  done

  if (( ${#uniq_theme_dirs[@]} == 0 )); then
    echo "No themes found (no puml-theme-*.puml files)." >&2
    exit 1
  fi

  local overall_ok=0 overall_total=0 overall_fail=0
  for d in "${uniq_theme_dirs[@]}"; do
    local name
    name=$(basename "$d")
    if [[ -n "$THEME_FILTER" && "$name" != "$THEME_FILTER" ]]; then
      continue
    fi
    render_theme_examples "$d" "$name"
  done
}

main "$@"

