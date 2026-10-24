# Spec: <short title>

- **Slug:** `<slug>`  (filename: `docs/specs/<slug>.md`)
- **Status:** Draft | Approved | Implemented
- **Author:** <name>
- **Date:** <YYYY-MM-DD>

> Copy this file to `docs/specs/<slug>.md` and fill it in. A spec is reviewed
> and approved **before** implementation. When the work ships, move this file
> to `docs/archive/` and add a row to `docs/archive/INDEX.md`.

## 1. Intent

One or two sentences: what are we changing and why? What problem does it solve
for readers of the blog or for the build/publish workflow?

## 2. Scope

- **In scope:** …
- **Out of scope:** …

## 3. Acceptance Criteria (EARS)

Write testable criteria using the **EARS** patterns. Each must be verifiable by
a build run, a file check, or an inspection of the generated `output/`.

**EARS keywords:**
- *Ubiquitous* — "The system SHALL …"
- *Event-driven* — "WHEN <trigger>, the system SHALL …"
- *State-driven* — "WHILE <state>, the system SHALL …"
- *Unwanted* — "IF <condition>, THEN the system SHALL …"
- *Optional* — "WHERE <feature is present>, the system SHALL …"

Examples (image-optimization feature):

- **AC-1 (Ubiquitous):** The build SHALL produce a `gh-pages` payload whose
  `images/` directory is ≤ 300 MB.
- **AC-2 (Event-driven):** WHEN `make github` runs, the system SHALL execute
  `optimize_images` after `publish` and before deploy.
- **AC-3 (Unwanted):** IF an image is already smaller than the target, THEN the
  optimizer SHALL leave the original file unchanged.
- **AC-4 (Optional):** WHERE a file is a GIF, SVG, or video, the optimizer
  SHALL skip it.
- **AC-5 (State-driven):** WHILE source images live under `content/images/`,
  the system SHALL NOT modify them (optimization applies to `output/` only).

## 4. Constraints

- Must not break `make publish` or the `publish.yml` workflow.
- Must respect existing conventions in `AGENTS.md` / `CODE_CONDUCT.md`.
- Pin any new dependency to an exact version compatible with `pelican`.

## 5. Verification Plan

How each acceptance criterion is checked (command, file, or inspection).

| AC | How verified |
|----|--------------|
| AC-1 | `du -sh output/images` after `make publish && make optimize_images` |
| AC-2 | Inspect `Makefile` `github` target dependency order |
| …  | … |

## 6. Rollback

How to undo if it goes wrong (usually: revert the commit and rebuild — the
site is regenerated from source, so most changes are reversible).
