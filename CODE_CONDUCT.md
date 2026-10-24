# Code Conduct

Best practices to observe when working on this repository.

## Verification

1. **Build before you claim done.** After any change to content, config,
   theme, or tooling, run a production build and confirm it succeeds:
   ```bash
   make publish
   ```
   For changes that touch images or the optimizer, also run
   `make optimize_images` and spot-check a sample image still opens.

2. **Prefer the dev server while iterating.** Use `make devserver` (autoreload)
   for fast feedback on content/theme edits; reserve `make publish` for the
   final check.

3. **No broken links or missing assets.** When adding an article that
   references an image or download, confirm the referenced file exists under
   `content/images/` or `content/downloads/` with the exact name (spaces are
   URL-encoded as `%20` by the renderer).

4. **Tooling scripts carry tests or a smoke-run.** `tools/optimize-images.py`
   and any future helper must be exercised against the real `output/` (or a
   small fixture) before commit — it must only ever shrink files and must leave
   GIF/SVG/video untouched.

## Commit Discipline

1. **Conventional commits.** Format: `type(scope): message`
   - `feat:` — new content, page, or capability
   - `fix:` — correction (typo, broken link, build error)
   - `refactor:` — restructure without output change
   - `perf:` — build/output size/speed improvement
   - `docs:` — repo docs only (AGENTS/README/docs/)
   - `chore(deps):` — dependency bumps
   - `ci:` — CI/CD changes

2. **One logical change per commit.** Don't mix an article edit with a theme
   refactor or a dependency bump.

3. **Stage specific files**, not `git add .`, to avoid committing build
   artifacts (`output/`, `*.el.bak.*`, caches) or secret-bearing files
   (`.pta.tmp` is gitignored — never commit it or echo its token).

4. **Never force push** to `main`. Let CI own `gh-pages`.

## Documentation Discipline

Keep the active tree lean and scannable for humans and AI agents.

1. **Specs live in `docs/specs/`** during design; plans/notes for in-flight
   work live in `docs/`. When work ships, **move the spec/plan to
   `docs/archive/`** and add a row to `docs/archive/INDEX.md`.

2. **Durable "why" decisions go to `docs/decisions/`** as short ADRs (see
   `docs/decisions/README.md`).

3. **Prefer the PR description over in-tree status notes.** Don't commit
   `*_SUMMARY.md` write-ups; put implementation notes in the PR.

## Python (tooling, config)

- Python 3.10+, type hints on function signatures.
- `ruff` enforces lint + format (line-length 100, double quotes, isort) — see
  `pyproject.toml`.
- Keep helper scripts dependency-light; reuse what's already in
  `requirements.txt` (Pillow, PyYAML) before adding anything new.
- Pin new dependencies to an exact version in `requirements.txt`, and confirm
  the pin is compatible with `pelican` (e.g. Pygments `<2.19`) before merging a
  bump.

## Content (Markdown)

- Every article starts with Pelican metadata (`Title:`, `Date:`, `Category:`,
  `Tags:`, optional `Slug:`).
- Put essays in `thoughts/`, technical posts in `dev/`, PM notes in `pm/`.
- Reference images as `images/<name>` and downloads as `downloads/<name>`.
- Use `Status: draft` metadata for work-in-progress; drafts render to
  `output/drafts/` and are stripped before deploy.

## Theme / Frontend

- Theme JS/CSS lives under `theme/feng/static/` (npm + bower managed).
- `prettier` formats JS/CSS/HTML templates (see `.prettierrc`).
- Don't hand-edit generated lockfiles; bump via `npm`/`yarn` and commit the
  regenerated lock.

## Images & Assets

- **Source images stay full-quality** in `content/images/`. Size optimization
  happens only on `output/` via `tools/optimize-images.py`.
- Large binaries that are genuinely linked from an article (PDF, mp4) are
  valid and belong in `content/downloads/` — they are not junk.

## PR Process

1. Create a feature branch from `main`: `feat/<slug>` or `docs/<slug>`.
2. Implement; `make publish` must succeed.
3. Push and open a PR via `gh pr create`.
4. PR description: summary, what changed, what was verified.
5. Merge via **rebase** (repo setting); the deploy workflow publishes `main`.
6. After merge: `git checkout main && git pull`.

## Lifecycle every change follows

```
1. SPEC     docs/specs/<slug>.md — intent + EARS acceptance criteria + constraints
            (for non-trivial features/tooling; a typo fix skips this)
2. PLAN     approach + task breakdown (AI-drafted, human-approved)
3. BUILD    implement against the spec; verify with make publish / devserver
4. VERIFY   production build succeeds; links/assets resolve; optimizer smoke-run
            if images touched
5. PR       small, single-purpose; links which criteria it satisfies
6. SHIP     merge to main → publish.yml deploys to gh-pages
7. ARCHIVE  spec/plan → docs/archive/ (+ INDEX row);
            durable decision → docs/decisions/ (ADR)
```
