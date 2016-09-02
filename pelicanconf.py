#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Feng Xia'
SITENAME = u'C-x C-b'
SITEURL = ''

PATH = 'content'

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

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

# Theme
#THEME = 'html5-dopetrope'
THEME = 'alchemy'
PAGES_ON_MENU = True
TAGES_ON_MENU = True
ARCHIVES_ON_MENU = True
CATEGORIES_ON_MENU = True
GITHUB_ADDRESS = 'http://github.com/fengxia41103/'
EMAIL_ADDRESS = 'feng_xia41103@hotmail.com'

# Plugins
LOAD_CONTENT_CACHE = False  # for development use
PLUGIN_PATHS = ['../pelican-plugins']
PLUGINS = ['pin_to_top', ]
