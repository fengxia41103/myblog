#!/usr/bin/env python
"""Downscale and recompress images in the Pelican *output* tree.

This is a post-publish step. It rewrites images **in place** inside
``output/`` only -- the source originals under ``content/images/`` are
never touched, so the operation is fully reversible: just rebuild.

Because filenames and paths are preserved, no HTML/Markdown references
need to change.

Rules
-----
* JPEG/PNG: resize so the longest edge is at most ``--max-dim`` px
  (only ever shrinks, never upscales), then recompress.
    - JPEG  -> quality 82, progressive, optimized.
    - PNG   -> optimized; palette/transparency preserved.
* GIF, SVG, WEBP, and video (mp4/webm) are left untouched by default
  (animated GIF resizing with Pillow is lossy/fragile, SVG is vector).
* Files are only replaced if the result is actually smaller.

Usage
-----
    python tools/optimize-images.py output/images
    python tools/optimize-images.py output/images --max-dim 1600 --quality 80
"""

from __future__ import annotations

import argparse
import io
import sys
from pathlib import Path

try:
    from PIL import Image, ImageOps
except ImportError:  # pragma: no cover
    sys.exit("Pillow is required: pip install Pillow")

JPEG_EXTS = {".jpg", ".jpeg"}
PNG_EXTS = {".png"}
# Everything else under images/ is deliberately left alone.


def human(num_bytes: int) -> str:
    size = float(num_bytes)
    for unit in ("B", "KB", "MB", "GB"):
        if size < 1024 or unit == "GB":
            return f"{size:.1f}{unit}"
        size /= 1024
    return f"{size:.1f}GB"


def optimize_one(path: Path, max_dim: int, quality: int) -> int:
    """Optimize a single image in place. Return bytes saved (>= 0)."""
    ext = path.suffix.lower()
    original_size = path.stat().st_size

    try:
        with Image.open(path) as img:
            # Respect EXIF orientation, then drop EXIF to save bytes.
            img = ImageOps.exif_transpose(img)
            fmt = img.format or ("JPEG" if ext in JPEG_EXTS else "PNG")

            # Downscale only if larger than the cap.
            width, height = img.size
            longest = max(width, height)
            if longest > max_dim:
                scale = max_dim / float(longest)
                new_size = (round(width * scale), round(height * scale))
                img = img.resize(new_size, Image.LANCZOS)

            buf = io.BytesIO()
            if ext in JPEG_EXTS:
                rgb = img.convert("RGB")
                rgb.save(
                    buf,
                    format="JPEG",
                    quality=quality,
                    optimize=True,
                    progressive=True,
                )
            elif ext in PNG_EXTS:
                img.save(buf, format="PNG", optimize=True)
            else:
                return 0
    except Exception as exc:  # noqa: BLE001 - never fail the whole build
        print(f"  skip (error): {path} ({exc})", file=sys.stderr)
        return 0

    new_bytes = buf.getvalue()
    if len(new_bytes) < original_size:
        path.write_bytes(new_bytes)
        return original_size - len(new_bytes)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "target",
        type=Path,
        help="Directory to process (e.g. output/images).",
    )
    parser.add_argument("--max-dim", type=int, default=1920,
                        help="Max longest-edge in px (default 1920).")
    parser.add_argument("--quality", type=int, default=82,
                        help="JPEG quality 1-95 (default 82).")
    args = parser.parse_args()

    if not args.target.is_dir():
        sys.exit(f"Not a directory: {args.target}")

    exts = JPEG_EXTS | PNG_EXTS
    files = [p for p in args.target.rglob("*") if p.suffix.lower() in exts]

    total_before = sum(p.stat().st_size for p in files)
    total_saved = 0
    changed = 0
    for path in files:
        saved = optimize_one(path, args.max_dim, args.quality)
        if saved:
            changed += 1
            total_saved += saved

    print(
        f"Optimized {changed}/{len(files)} images: "
        f"{human(total_before)} -> {human(total_before - total_saved)} "
        f"(saved {human(total_saved)})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
