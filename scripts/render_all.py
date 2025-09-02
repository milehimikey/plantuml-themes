#!/usr/bin/env python3
"""
Render all examples for every theme directory in this repo.
Supports either:
 - plantuml on PATH
 - PLANTUML env var pointing to a PlantUML CLI
 - PLANTUML_JAR env var pointing to plantuml.jar (requires 'java')

Usage:
  python scripts/render_all.py                     # render PNG and SVG
  python scripts/render_all.py --format png        # only PNG
  python scripts/render_all.py --theme starlight   # only one theme

Outputs per theme example directory under examples/_out/<format>.
"""
from __future__ import annotations
import argparse
import subprocess
import sys
import os
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent


def find_renderer() -> list[str] | None:
    # Priority: PLANTUML, 'plantuml' on PATH, PLANTUML_JAR
    env_cmd = os.environ.get("PLANTUML")
    if env_cmd:
        return [env_cmd]
    try:
        subprocess.run(["plantuml", "-version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
        return ["plantuml"]
    except FileNotFoundError:
        pass
    jar = os.environ.get("PLANTUML_JAR")
    if jar:
        # Ensure java exists
        try:
            subprocess.run(["java", "-version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
        except FileNotFoundError:
            print("java not found; required with PLANTUML_JAR", file=sys.stderr)
            return None
        return ["java", "-jar", jar]
    return None


def render_file(renderer: list[str], fmt: str, example_dir: Path, infile: Path) -> int:
    outdir_rel = Path("_out") / fmt
    outdir_abs = example_dir / outdir_rel
    outdir_abs.mkdir(parents=True, exist_ok=True)

    cmd = renderer + [f"-t{fmt}", "-charset", "UTF-8", "-o", str(outdir_rel), infile.name]
    try:
        proc = subprocess.run(cmd, cwd=str(example_dir), capture_output=True, text=True)
        if proc.returncode != 0:
            sys.stderr.write(proc.stderr)
        return proc.returncode
    except Exception as e:
        print(f"error running {' '.join(cmd)}: {e}", file=sys.stderr)
        return 1


def render_theme_examples(renderer: list[str], theme_dir: Path, theme_name: str, formats: list[str]) -> None:
    examples_dir = theme_dir / "examples"
    if not examples_dir.is_dir():
        print(f"[skip] {theme_name}: no examples/ directory")
        return
    files = sorted(examples_dir.glob("*.puml"))
    if not files:
        print(f"[skip] {theme_name}: no .puml under examples/")
        return
    print(f"[info] Rendering theme '{theme_name}' examples ({len(files)} files) ...")
    total = ok = fail = 0
    for f in files:
        for fmt in formats:
            total += 1
            rc = render_file(renderer, fmt, examples_dir, f)
            if rc == 0:
                ok += 1
                print(f"  [ok] {f.name} -> {fmt}")
            else:
                fail += 1
                print(f"  [fail] {f.name} -> {fmt}", file=sys.stderr)
    print(f"[done] {theme_name}: {ok}/{total} succeeded ({fail} failed)")


def find_theme_dirs() -> list[Path]:
    # Theme dir = any directory (max depth 2) that contains puml-theme-*.puml
    results: list[Path] = []
    for p in REPO_ROOT.glob("*/*"):
        if not p.is_dir():
            continue
        matches = list(p.glob("puml-theme-*.puml"))
        if matches:
            results.append(p)
    # Also check top-level dirs (depth 1) like 'starlight' which we've already covered via */*
    for p in REPO_ROOT.glob("*"):
        if not p.is_dir():
            continue
        matches = list(p.glob("puml-theme-*.puml"))
        if matches and p not in results:
            results.append(p)
    return results


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--format", "-f", default="both", choices=["png", "svg", "both", "all"])
    ap.add_argument("--theme", "-t", default=None)
    args = ap.parse_args(argv)

    formats = ["png", "svg"] if args.format in ("both", "all") else [args.format]

    renderer = find_renderer()
    if not renderer:
        print("PlantUML not found. Install 'plantuml' or set PLANTUML or PLANTUML_JAR.", file=sys.stderr)
        return 1

    theme_dirs = find_theme_dirs()
    if not theme_dirs:
        print("No themes found (no puml-theme-*.puml files).", file=sys.stderr)
        return 1

    for d in theme_dirs:
        name = d.name
        if args.theme and name != args.theme:
            continue
        render_theme_examples(renderer, d, name, formats)

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))

