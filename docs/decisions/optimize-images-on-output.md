# Optimize images on build output, not source

- **Status:** Accepted
- **Date:** 2026-10-24

## Context

The published `gh-pages` payload had grown to ~1 GB, dominated by ~800 MB of
full-resolution camera photos under `content/images/` that Pelican copies
verbatim via `STATIC_PATHS`. GitHub Pages has a soft 1 GB repo limit, so the
site was approaching the cap. We wanted to shrink the published site without
losing source quality or rewriting hundreds of Markdown image references.

Two mechanisms were considered:

1. A Pelican image-processing plugin (e.g. `pelican-image-process`) — requires
   tagging every `<img>` with CSS classes and changes derivative URLs, i.e.
   editing hundreds of existing `.md` files.
2. A post-build script that recompresses images in place in `output/`.

## Decision

Use a **post-build Pillow script** (`tools/optimize-images.py`) that downscales
and recompresses JPEG/PNG **in the generated `output/` tree only** (longest edge
≤ 1920px, JPEG q82). Source images under `content/images/` are never touched.
Wire it into the `Makefile` `github` target and the `publish.yml` workflow so it
runs on every deploy. GIF/SVG/video are left untouched; a file is replaced only
if the result is smaller.

## Consequences

- Published `output/` dropped from ~996 MB to ~479 MB (images 801 → 266 MB).
- Filenames and paths are preserved, so **no content edits** were needed.
- Fully reversible: sources are intact, so a rebuild regenerates everything.
- Remaining bulk is video (~61 MB), intentionally left alone; a future ADR can
  revisit video transcoding if needed.
- The optimizer depends on Pillow, which must stay in `requirements.txt` and
  be compatible with the pinned `pelican`.
