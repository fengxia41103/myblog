Title: Reveal slides
Date: 2018-11-27 09:26
Tags: thoughts
Slug: reveal slides
Author: Feng Xia

<div class="iframe-container">
  <iframe src="https://fengxia41103.github.io/moment/1236/"
          allowfullscreen></iframe>

</div>

[reveal.js][1] is pretty awesome. I have been using it for the last 9
months now and love it. It was a bit of hassle to set it up
initially. Once you have an example, yo can replicate and be
productive by copying and pasting existing one, and getting a
consistent look and workflow. And the results? amazing.

- as photo album: [momoent][2]
- as for work: [netbox][3]

# To create a new presentation

The easiest way to create a new slides for your topic is to copy an
existing folder, eg. `netbox`, and make modifications to your
contents.

Each folder should have the following contents:

```shell
.
├── images
├── index.html
├── my.css
└── slides.md
```

Only `index.html` and `.md` are essential. `index.html` is the overall
HTML shell that will be loaded by browser, and `.md` are slide
contents that will be converted from Markdown into HTML and included
in `index.html`. You can split your contents into multiple `.md`
files, which we will cover in more details next.

`my.css` is used to make customized CSS change per each deck. There is
also a common which determines the overall look (as default
look). Both are included in `index.html`. Of course you can
include/modify other CSS as your wish in `index.html`, just like any
other web page programming.

```html
<!-- My css -->
<link rel="stylesheet"
      href="../css/my.css">
<link rel="stylesheet"
      href="my.css">
```

# index.html

`index.html` is the entry point for browser. There are a few places
you would like to update to match your topic and contents:

1. `<title>`: the text shown as page title on a browser.
2. `<meta name="description" content="<>">`: description text is
   useful when page is picked up by search engine.
3. `<meta name="autho" content="<>">`: author names
4. `<p class="copyright">...</p>`: your copyright text.

# slide contents

Slide contents are written in Markdown in separate files,
eg. `slides.md`. To include a markdown file into slides:

```html
<section data-markdown="slides.md"  
         data-separator="^---"
         data-vertical="^--"
         data-notes="^Note:"
         data-charset="utf-8">
</section>
```

You can include multiple `.md` files in a single presentation. This
gives you flexibility to organize contents into reusable chunks and
present them in different combinations based on audience.

1. `data-markdown`: Markdown file to include.
2. `data-separator`: this is essentially a page break in Markdown
   file.
3. `data-vertical`: contents separated by this will be included on the
   same page, but will be showns as vertically stacked contents, **one
   at a time** (like a sub-page).
4. `data-notes`: mark the start of presenter notes. These notes are
   visible to presenter, but not to audience.

# Export

1. You can follow the [official guide][4] by `reveal.js`.
2. Or, using the [desktape][5]: `decktape reveal <url> <filename>.pdf`



[1]: https://github.com/hakimel/reveal.js/
[2]: https://fengxia41103.github.io/moment/1236/
[3]: https://fengxia41103.github.io/moment/netbox/
[4]: https://github.com/hakimel/reveal.js#pdf-export
[5]: https://github.com/astefanutti/decktape
