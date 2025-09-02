# Augment Rules: Releases and CI

This repository uses GitHub Actions (release-please) to automate semantic releases based on Conventional Commits.

## Triggers

- The workflow runs on push to `main`
- It scans commits since the last release tag and computes the next version:
  - `feat` → MINOR, `fix` → PATCH, `type!` or `BREAKING CHANGE:` footer → MAJOR
- If a release is warranted, a PR titled `chore: release vX.Y.Z` is opened/updated
- Merge the release PR to create the tag and GitHub Release

## Requirements

- Repo Settings → Actions → General:
  - Workflow permissions: enable "Read and write permissions"
  - Check "Allow GitHub Actions to create and approve pull requests"
- Default branch is `main`

## Forcing a release

If you need to publish a release without `feat` or `fix` commits, add a footer to the commit body:

```
Release-As: 1.0.0
```

This instructs release-please to cut a release at that version.

## Commit and PR guidance

- With squash-and-merge, the PR title becomes the commit analyzed by release please.
- Always title PRs with a Conventional Commit, e.g.:
  - `feat(theme): introduce starlight dark theme`
  - `fix(sequence): correct participant backgrounds`
- Use `!` and a `BREAKING CHANGE:` footer for breaking changes.

## Local verification

- Render all examples for a theme locally before merging:
  - `scripts/render-all.sh -t <theme>`
  - `python scripts/render_all.py --theme <theme>`

## Do not tag manually

- Tags and releases are created by the workflow when the release PR is merged.

