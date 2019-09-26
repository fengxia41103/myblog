Title: Pandoc workflow
Date: 2019-04-30 09:23
Tags: dev
Slug: pandoc workflow
Author: Feng Xia

<figure class="col s12">
  <img src="/images/peppa.jpg"/>
</figure>


[Pandoc](https://pandoc.org/MANUAL.html) is awesome. I have been using
it for the last six months now writing a reference architecture
document for work. Here is some tips of how I'm using it.


# doc header

Things that are specific to that document. This, thus, is context
sensitive &mdash; `title`, `subtitle`, `author`, `bibliography`,
`abstract`, `keywords`.

Example:

```yaml
title: Open Cloud  Reference Architecture
subtitle: Version 1.0
author:
  - Feng Xia

bibliography: feng.bib
keywords: [Open Cloud]
abstract: |

  Anything goes here.
```

One catch is semicolon in `title`! Unbelievably, which I haven't
figured out why, that including a ":" in the title string will mess
up export to PDF. The symptom you will see is that all your
reference in `.bib` will not be found!!
  
# LaTex setting

A universal setting to latex export. This is additional to the LaTex
template file I use. Supposedly I can set all these in the template
also.
   
But if I'm using multiple template, this can be looked as the common
settings for all the PDF I write.
   
Here is [current version][1]. It looks like this:

```yaml

---
documentclass: scrreprt
papersize: a4
mainfont: Ubuntu
monofont: DejaVu Sans Condensed
fontsize: 12pt
geometry: margin=1in
linkstyle: slanted
linkcolor: #d52349
titlepage: true
titlepage-color: "FFFFFF"
titlepage-text-color: "5C68C0"
titlepage-rule-color: "5C68C0"
logo: "../diagrams/company-logo.png"
toc: true
toc-depth: 5
toc-own-page: true
lof: true
lot: true
link-citations: true
header-includes:
  - \usepackage{quotchap}
  - \usepackage{fvextra}
  - \usepackage{parskip}
  - \usepackage{fancyhdr}
  - \pagestyle{fancy}
  - \fancyhead{}
  - \fancyfoot{}
  - \fancyhead[L]{\leftmark}
  - \fancyhead[R]{\today}
  - \fancyfoot[R]{\thepage}
  - \renewcommand{\headrulewidth}{0.4pt}
  - \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
  - \lstset{breaklines=true}
  - \lstset{language=[Motorola68k]Assembler}
  - \lstset{basicstyle=\small\ttfamily}
  - \lstset{extendedchars=true}
  - \lstset{tabsize=2}
  - \lstset{columns=fixed}
  - \lstset{showstringspaces=false}
  - \lstset{frame=trbl}
  - \lstset{frameround=tttt}
  - \lstset{framesep=4pt}
  - \lstset{numbers=left}
  - \lstset{numberstyle=\tiny\ttfamily}
  - \lstset{postbreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\color{red}\hookrightarrow\space}}}
---

```

# LaTex template

A massive LaTex writing that will be used to generate LaTex and
PDF. As of writing, there are two templates I like:
1. [eisvogel.tex][2], found [here][4].
2. [feng.tex][3], modified based on `eisvogel`, and modified to my favourate
   title page.

# BibTex

Lesson learned, though late, is still useful, is the BibTex. **Don't
be lazy** by using direct Markdown links to reference as hyperlink
&larr; it doesn't cut it. Instead, use the `.bib`, it's much better,
and is **incremental**, meaning your collection will grow, and it
benefits to any follow up docs you will write and want to use the same
source for reference! and to generate a bibliography now at the end of
your doc is a snap, and it looks, beautiful!


<figure class="col l6 m6 s12">
  <img src="/images/bibliography.png"/>
  <figcaption>Example of .bib result in PDF</figcaption>
</figure>

Use the [MIT's guide][9] for format references.

## emacs + RefTex

Found it [here][8]:

```lisp
;; reftex in markdown mode

;; if this isn't already set in your .emacs
(setq reftex-default-bibliography '("/path/to/library.bib"))

;; define markdown citation formats
(defvar markdown-cite-format)
(setq markdown-cite-format
      '(
        (?\C-m . "[@%l]")
        (?p . "[@%l]")
        (?t . "@%l")
        )
      )

;; wrap reftex-citation with local variables for markdown format
(defun markdown-reftex-citation ()
  (interactive)
  (let ((reftex-cite-format markdown-cite-format)
        (reftex-cite-key-separator "; @"))
    (reftex-citation)))

;; bind modified reftex-citation to C-c[, without enabling reftex-mode
;; https://www.gnu.org/software/auctex/manual/reftex/Citations-Outside-LaTeX.html#SEC31
(add-hook
 'markdown-mode-hook
 (lambda ()
   (define-key markdown-mode-map "\C-c[" 'markdown-reftex-citation)))
```

Once restarted emacs, use `C-c[` then `C-M` to select a citation
style, and type in a regex, eg. `redhat-` and ENTER. Viola, a list of
matched entries to select, and ENTER again &rarr;
`[@redhat-rhhi-guide]`. Nice ~~


## Styles

Wow, I never knew there are so many styles to choose from. The list
I'm going by is [here][6]. For web URLs, I found the [ieee with
url][7] is the only one that works.

The biggest problem I see, is that web page does not have date (well,
I guess they do, probably in its meta section, but I didn't bother to
look into it). So other styles will render it as "Red Hat, n.d" &rarr;
`n.d` for "no date"? Doesn't look nice.

# Makefile

I can't remember all the pandoc CLI switches. Use `make` to compile
multiple versions in one bang. Here is [current version][5].

Define macros at the beginning:
```make
latex_template := feng.tex
rhhi_ra_pdf := feng\ ra.pdf # espace white space!
rhhi_ra_md := feng\ ra.md
```

To compile to PDF:

```shell
pandoc latex.yaml $(rhhi_ra_md) \
	--number-sections \
	--from markdown \
	-o $(rhhi_ra_pdf) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--pdf-engine xelatex \
	--template $(latex_template) \
	-M date="`date "+%B %e, %Y"`" \
	--filter pandoc-citeproc \
	--csl $(csl)
```

To compile to DOCX:

```shell
pandoc $(rhhi_ra_md) \
	--from markdown \
	-o $(rhhi_ra_docx) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--columns 10 \
	--filter pandoc-citeproc \
	--csl $(csl)

```

# Workflow

Quite simple: write &rarr; make <whatever> &rarr; view &rarr; repeat.

## Cursed by WORD, and coworkers

The pain, comes in when you need **collaboration** &mdash; ppl insist
to use DOC and change tracking. Unbelievable. I think the biggest
curse I have had in my professional training, is that I was introduced
to the LaTex so early that I simply could not stand the WORD, which
makes me the super minority in corporate world. I have been battling
this all my career. I thought pandoc is gonna save the day, since I'm
now dealing with _technical_ people now.

No avail. When it comes down to writing a _paper_, this generation, is
trained to think of WORD, only. You see emails with attachment, and
filename with a timestamp "_0409", then "_0410" as the next version
&mdash; for me who uses SVN then git as the life line of work, this,
is purely disaster &larr; **every single time**, somebody will do one
the two things:

1. Forgot to change the filename after an edit, thus now we have two
   files of the same name, but different contents.
   
2. Forgot to send out the latest, review the latest, for, oh well, how
   would s/he know which is the latest!!? The convention is, of
   course, the last email attachment you received.
   
   Good luck.

I give up this battle now at this point. Like teaching a kid &mdash;
you can't really teach them. You just have to wait for them to grow
up, if ever. 

[1]: /downloads/pandoc/latex.yaml
[2]: /downloads/pandoc/eisvogel.tex
[3]: /downloads/pandoc/feng.tex
[4]: https://github.com/Wandmalfarbe/pandoc-latex-template/blob/master/eisvogel.tex
[5]: /downloads/pandoc/Makefile
[6]: https://github.com/citation-style-language/styles
[7]: https://github.com/citation-style-language/styles/blob/master/ieee-with-url.csl
[8]: https://gist.github.com/kleinschmidt/5ab0d3c423a7ee013a2c01b3919b009a#file-reftex-markdown-el
[9]: http://web.mit.edu/rsi/www/pdfs/bibtex-format.pdf
