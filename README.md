# myblog — "Be Care Free"

The personal static blog of Feng Xia, built with [Pelican](https://getpelican.com/)
and published to GitHub Pages:
<https://fengxia41103.github.io/myblog/>

Markdown content under `content/` is rendered to static HTML with a custom theme
(`theme/feng/`); the generated `output/` is deployed to the `gh-pages` branch.
There is no runtime backend.

## Prerequisites

- Python 3.10+ and a virtualenv.
- Node.js (via [nvm](https://github.com/nvm-sh/nvm)) — only needed to work on
  the theme's JS/CSS assets under `theme/feng/static/`.

## Setup

```bash
# 1. Python environment
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# 2. (Theme assets only) install JS deps
cd theme/feng/static && npm install   # or: yarn install
```

## Build & Serve

Run from the repo root inside the virtualenv:

| Command | Purpose |
|---------|---------|
| `make html` | Build to `output/` with dev settings (`pelicanconf.py`). |
| `make serve` | Serve `output/` at <http://localhost:8000>. |
| `make devserver` | Autoreload dev server (`develop_server.sh`). |
| `make publish` | Build with production settings (`publishconf.py`). |
| `make optimize_images` | Downscale/recompress images in `output/images/` (Pillow). Tunable via `MAX_DIM` / `JPEG_QUALITY`. |
| `make github` | `publish` → `optimize_images` → deploy `output/` to `gh-pages`. |

> Run `make github` inside the virtualenv (Pillow must be importable), or pass
> `make github PY=.venv/bin/python`.

## Publishing

Pushing to `main` triggers `.github/workflows/publish.yml`, which builds,
optimizes images, strips `output/drafts/`, and deploys to `gh-pages`
automatically. Manual deploys use `make github`.

### Images

Source images in `content/images/` are kept full-quality. Size optimization
happens **only on the generated `output/`** via `tools/optimize-images.py`
(longest edge ≤ 1920px, JPEG q82); GIF/SVG/video are left untouched. The step
is reversible — just rebuild.

## Writing content

Articles are Markdown with Pelican metadata (`Title:`, `Date:`, `Category:`,
`Tags:`, optional `Slug:`). Place by topic: essays → `content/thoughts/`,
technical → `content/dev/`, PM notes → `content/pm/`. Downloadable assets
(PDFs, configs) go under `content/downloads/` and are linked from articles.

### Resumes / letters

Resume and cover-letter PDFs are generated from Markdown with pandoc; sources
and a `Makefile` live under `content/downloads/pandoc/`.

## Repo conventions

- [`AGENTS.md`](./AGENTS.md) — structure, architecture, and build/publish
  reference (for humans and AI agents).
- [`CODE_CONDUCT.md`](./CODE_CONDUCT.md) — working rules: verification, commit
  and docs discipline, style, PR process, and change lifecycle.
- [`docs/`](./docs/) — specs (EARS acceptance criteria), decision records
  (ADRs), and an archive of shipped work.
