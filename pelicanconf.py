#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Feng Xia'
SITENAME = u'PY'
#SITEURL = 'http://fengxia.co'
SITEURL = ''

PATH = 'content'
STATIC_PATHS = ['images', 'downloads', 'app']

TIMEZONE = 'America/New_York'

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

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
# PAGINATION_PATTERNS = (
#    (1, '{base_name}/', '{base_name}/index.html'),
#    (2, '{base_name}/page/{number}/', '{base_name}/page/{number}/index.html'),
#)

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

# Theme
THEME = 'feng'
EMAIL_ADDRESS = 'feng_xia41103@hotmail.com'
GITHUB_ADDRESS = 'http://github.com/fengxia41103'
LINKEDIN_ADDRESS = 'https://www.linkedin.com/in/fengxia41103'

# Plugins
LOAD_CONTENT_CACHE = False  # for development use
PLUGIN_PATHS = ['../pelican-plugins']
PLUGINS = ['pin_to_top']
