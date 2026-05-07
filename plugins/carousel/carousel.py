"""
Carousel plugin: extracts the first image from each article in the
"thoughts" category and exposes it as CAROUSEL_IMAGES in templates.
Each entry is a dict with 'image' (URL) and 'url' (article URL).
"""

import re
from pelican import signals


def extract_carousel_images(generator):
    carousel = []
    img_re = re.compile(r'<img[^>]+src=["\']([^"\']+)["\']', re.IGNORECASE)

    for article in generator.articles:
        if article.category.name.lower() != "thoughts":
            continue
        match = img_re.search(article.content)
        if match:
            carousel.append({
                "image": match.group(1),
                "url": article.url,
            })

    generator.context["CAROUSEL_IMAGES"] = carousel


def register():
    signals.article_generator_finalized.connect(extract_carousel_images)
