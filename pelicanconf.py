#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

import sys

AUTHOR = u"Feng Xia"
SITENAME = u"Be Care Free'"
#SITEURL = "http://fengxia.co"
SITEURL = "https://fengxia41103.github.io/myblog/"

PATH = "content"

IGNORE_FILES = ["[.#].*"]

# These folders will be copied to `/output` without pelican modification
STATIC_PATHS = ["images", "downloads", "app", "data", "slides"]  # "extra/CNAME"
# EXTRA_PATH_METADATA = {'extra/CNAME': {'path': 'CNAME'}, }

# must have this to copy `/slides` to output
# and skip processor complaining about formatting error
# in .html and .md in this folder
ARTICLE_EXCLUDES = ["slides", "downloads", "images", "data"]
TIMEZONE = "America/New_York"

DEFAULT_LANG = u"en"

# Feed generation is usually not desired when developing
#FEED_ALL_ATOM = None
#CATEGORY_FEED_ATOM = None
#TRANSLATION_FEED_ATOM = None
#AUTHOR_FEED_ATOM = None
#AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (("Pelican", "http://getpelican.com/"),
         ("Python.org", "http://python.org/"),
         ("Jinja2", "http://jinja.pocoo.org/"),
         ("You can modify those links in your config file", "#"),)

# Social widget
SOCIAL = (("You can add links in your config file", "#"),
          ("Another social link", "#"),)

# pagination
DEFAULT_PAGINATION = 20


# Theme
THEME = "theme/feng"
EMAIL_ADDRESS = "feng_xia41103@hotmail.com"
GITHUB_ADDRESS = "http://github.com/fengxia41103"
LINKEDIN_ADDRESS = "https://www.linkedin.com/in/fengxia41103"

LOAD_CONTENT_CACHE = False  # for development use

#SUMMARY_MAX_LENGTH = 300
IGNORE_FILES = ["README.*", "readme.*", "Readme.*"]

# plugins
PLUGIN_PATHS = ["plugins"]
PLUGINS = ["tipue_search"]


##############################
#
# Custom filters
#
##############################


def tags_contain(test_list, item):
    return item in [t.name for t in test_list]


JINJA_FILTERS = {"tags_contain": tags_contain}
