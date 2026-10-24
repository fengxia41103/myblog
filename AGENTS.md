# Agents.md

## AI Agent Guidance for myblog

This document provides context for AI agents working on this repository.
Keep it in sync with the code; it reflects the current state of the site.

## Project Summary

**myblog** — "Be Care Free", the personal static blog of Feng Xia, published
to GitHub Pages. It is a [Pelican](https://getpelican.com/) site: Markdown
content is rendered to static HTML with a custom theme, and the generated
`output/` is deployed to the `gh-pages` branch.

Content is a mix of long-form essays (`content/thoughts/`), technical write-ups
(`content/dev/`), project-management notes (`content/pm/`), portfolio/workspace
pages, and downloadable assets (resumes, PDFs, configs) under
`content/downloads/`.

## Repository Structure

```
myblog/
├── content/                  # All source content (Pelican PATH)
│   ├── thoughts/             # Personal essays (*.md)
│   ├── dev/                  # Technical articles (*.md)
│   ├── pm/                   # Project-management notes (*.md)
│   ├── pages/                # Standalone pages (about, resume, search, …)
│   ├── workspace/            # Portfolio sections (stock, gkp, lucidum, …)
│   ├── images/               # Image assets (STATIC_PATHS; served verbatim)
│   ├── downloads/            # Downloadable assets referenced from .md
│   │   ├── pandoc/           # Resume/letter sources + generated PDFs
│   │   │                     #   (LaTeX intermediaries are build-only)
│   │   ├── emacs/            # Emacs config (org source + tangled .el)
│   │   └── euler/            # Project Euler solutions
│   ├── app/                  # Demo JS app assets (STATIC_PATHS)
│   ├── data/                 # Data files (STATIC_PATHS)
│   └── slides/               # Slide decks (STATIC_PATHS)
├── theme/feng/               # Custom Pelican theme (templates + static)
│   └── static/               # Theme JS/CSS (npm + bower managed)
├── plugins/                  # Pelican plugins (tipue_search, carousel, neighbors)
├── tools/
│   └── optimize-images.py    # Post-build image downscaler (see Build & Publish)
├── pelicanconf.py            # Dev Pelican settings (SITEURL="")
├── publishconf.py            # Production settings (imports pelicanconf; real SITEURL)
├── Makefile                  # Build/serve/publish targets
├── develop_server.sh         # Local autoreload dev server
├── requirements.txt          # Python deps (pinned)
├── .github/workflows/        # CI: publish.yml (build → optimize → deploy)
├── docs/                     # Planning, specs, and decision records
│   ├── specs/                # Feature specs (EARS acceptance criteria)
│   ├── decisions/            # Architecture Decision Records (ADRs)
│   └── archive/              # Shipped specs/plans (INDEX.md catalog)
├── AGENTS.md                 # This file
└── CODE_CONDUCT.md           # Agent working rules (READ THIS)
```

## Architecture

```
┌────────────────────────┐      make publish        ┌──────────────────┐
│  content/*.md + theme  │ ───────────────────────▶ │  output/ (HTML)  │
│  (Markdown + Jinja2)   │   pelican -s publishconf  │  static site     │
└────────────────────────┘                           └────────┬─────────┘
                                                               │ make optimize_images
                                                               ▼
                                                     ┌──────────────────┐
                                                     │ output/ (slim)   │
                                                     └────────┬─────────┘
                                                              │ ghp-import / pages-deploy
                                                              ▼
                                                     gh-pages branch → GitHub Pages
                                                     https://fengxia41103.github.io/myblog/
```

There is **no runtime backend** — the deliverable is static HTML/CSS/JS/assets.

## Build & Publish

All commands run from the repo root inside the Python virtualenv (`.venv`).

| Command | Purpose |
|---------|---------|
| `make html` | Build to `output/` with dev settings (`pelicanconf.py`). |
| `make serve` | Serve `output/` locally at http://localhost:8000. |
| `make devserver` | Autoreload dev server (`develop_server.sh`). |
| `make publish` | Build with production settings (`publishconf.py`). |
| `make optimize_images` | Downscale/recompress images in `output/images/` (Pillow). Overridable via `MAX_DIM` / `JPEG_QUALITY`. |
| `make github` | `publish` → `optimize_images` → deploy `output/` to `gh-pages`. |

Automated publish: `.github/workflows/publish.yml` runs on push to `main`:
build → `optimize_images` → remove `output/drafts` → deploy to `gh-pages`.

### Image handling (important)

Source images in `content/images/` are kept at full quality and committed as-is.
Downscaling happens **only on the generated `output/`** via
`tools/optimize-images.py` (longest edge ≤ 1920px, JPEG q82). Never downscale
sources — the optimizer is reversible by rebuilding. GIF/SVG/video are left
untouched.

## Content Conventions

- **Articles** are Markdown with Pelican metadata headers (`Title:`, `Date:`,
  `Category:`, `Tags:`, `Slug:`). Place by topic: essays → `thoughts/`,
  technical → `dev/`, PM → `pm/`.
- **Flat URL structure** — pages/categories/authors save as `{slug}.html`,
  tags as `tag-{slug}.html` (see `pelicanconf.py`).
- **Images** are referenced by relative path (`images/<name>`); spaces in
  filenames are URL-encoded (`%20`) by the renderer.
- **Downloads** (PDFs, docx, config dotfiles) live under `content/downloads/`
  and are linked from articles. They are valid, published assets — do **not**
  treat them as junk. Only build intermediaries (LaTeX `.tex/.aux/.log/.toc/…`,
  editor backups, caches, emacs tangle artifacts) are excluded via
  `IGNORE_FILES` in `pelicanconf.py`.
- **Drafts** render to `output/drafts/` and are stripped before deploy.

## Key Files

| File | Role |
|------|------|
| `pelicanconf.py` | Dev settings: `PATH`, `STATIC_PATHS`, `IGNORE_FILES`, theme, plugins, flat-URL scheme, custom Jinja filter. |
| `publishconf.py` | Production overrides: real `SITEURL`, feeds, `DELETE_OUTPUT_DIRECTORY`. |
| `Makefile` | Canonical build/serve/publish entry points. |
| `tools/optimize-images.py` | Post-build image optimizer (Pillow). |
| `theme/feng/` | Templates + static assets for the site's look. |
| `plugins/` | `tipue_search` (client-side search), `carousel`, `neighbors`. |

## What NOT to Do

- Don't downscale or edit `content/images/` originals for size — optimize the
  build output instead.
- Don't add non-site files to `content/downloads/` expecting them to be
  filtered; only the explicit intermediary/backup patterns in `IGNORE_FILES`
  are skipped.
- Don't commit `output/`, `.venv/`, `__pycache__/`, or `*.el.bak.*` — they are
  gitignored.
- Don't push directly to `gh-pages` by hand; let `make github` / the workflow
  manage it.
- Don't hardcode the production URL in content; rely on `SITEURL` + Pelican's
  relative link syntax.
