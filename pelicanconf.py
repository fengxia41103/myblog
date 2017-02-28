#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Feng Xia'
SITENAME = u'PY'
#SITEURL = 'http://fengxia.co'
SITEURL = ''

PATH = 'content'
STATIC_PATHS = ['images', 'downloads', 'app', 'data']

TIMEZONE = 'America/New_York'

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
#FEED_ALL_ATOM = None
#CATEGORY_FEED_ATOM = None
#TRANSLATION_FEED_ATOM = None
#AUTHOR_FEED_ATOM = None
#AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

# pagination
DEFAULT_PAGINATION = 5


# Theme
THEME = 'feng'
EMAIL_ADDRESS = 'feng_xia41103@hotmail.com'
GITHUB_ADDRESS = 'http://github.com/fengxia41103'
LINKEDIN_ADDRESS = 'https://www.linkedin.com/in/fengxia41103'

LOAD_CONTENT_CACHE = True  # for development use

#SUMMARY_MAX_LENGTH = 300
IGNORE_FILES = ["README.*", "readme.*", "Readme.*"]
