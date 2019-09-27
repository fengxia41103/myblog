Title: DIY Pelican theme
Date: 2016-09-04 11:00
Tags: dev
Slug: pelican theme
Author: Feng Xia

As a Python house, [Pelican][] is definitely a winner for our blog
site. But like any software engineer who hold a high standard to his
work, I got turned off by all the [available themes][].  "Ugly",
"Where is the document?", "Why my translation is not shown?", I felt
running in a maze where there were reflections of exit everywhere, but
none was real. "Well, if it's in Python, we can make one." Solution is
that simple.  Besides, we love [Jinja2][] template systems, and
Pelican has spelled out [everything][] we need.

[pelican]: http://blog.getpelican.com
[available themes]: http://www.pelicanthemes.com/)
[jinja2]: http://jinja.pocoo.org/docs/dev/
[everything]: http://docs.getpelican.com/en/3.6.3/themes.html#templates-and-variables


Quickly we wrote down a few on wish list:

1. The design must be based on [Bootstrap][]
2. Includes [Fontawesome][], [Datatable][], [Lightbox2][], and [SyntaxHighlighter][].
3. Reuse elements I have designed for [showcases][], such as layout, CSS and images.
4. Colors we like: <font color="#337ab7">blue(#337ab7)</font> and <span class="myhighlight">red(#d52349)</span>.
5. [Google fonts][]

[bootstrap]: http://getbootstrap.com/components/
[showcases]: {category}demo
[fontawesome]: http://fontawesome.io/icons/
[datatable]: https://datatables.net/
[lightbox2]: http://lokeshdhakar.com/projects/lightbox2/
[syntaxhighlighter]: http://alexgorbatchev.com/SyntaxHighlighter/
[google fonts]: https://fonts.google.com/

The actual work was pretty straightforward. Follow Pelican official document
to set up a working directory:

```shell
├── static
│   ├── bower_components
│   ├── css
│   │   └── my.css
│   └── js
│       ├── html5shiv.min.js
│       └── respond.min.js
└── templates
    ├── article.html
    ├── author.html
    ├── category.html
    ├── index.html
    ├── layout.html
    ├── page.html
    └── tag.html
```

`bower_components` has all the third party libraries.  The key is the
`layout.html` which is the root template of all others.  Once this is
set up, creating an individual page is simple. Just replace the `{%
block content %}` with relevant content and you are done.  

Like what you see? Roll up your sleeves and make a new theme. 1,2,3, Go!
