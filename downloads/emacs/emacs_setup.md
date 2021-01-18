
# Table of Contents

1.  [the idea](#org4b32832)
2.  [deps](#orgf3b21ee)
    1.  [what I want to use](#org255509f)
3.  [clean start](#orga1791fc)
    1.  [.emacs](#org8418937)
    2.  [bootstrap .el](#org6db2b4f)
4.  [reset](#orga702bab)
    1.  [reset config](#org12a4c01)
    2.  [recompile all packages](#recompile-packages)
5.  [initialize emacs](#org6713fba)
    1.  [info header](#orgf241b29)
    2.  [melpa](#org25cadfe)
    3.  [use-package](#org6288e70)
    4.  [tangle this config](#orgf46393a)
        1.  [manual tangle](#orgd4eb4b7)
        2.  [auto tangle](#org9c4e803)
6.  [base packages](#orgb385c12)
    1.  [all-the-icons](#org26ce78a)
    2.  [rainbow-mode](#orgca61a3d)
    3.  [Hydra](#hydra)
    4.  [whichkey](#org05b1449)
7.  [global stuff](#org452810d)
    1.  [by packages](#org8d4b233)
        1.  [UTF-8](#orgefd1d55)
        2.  [shell env](#org53799af)
    2.  [UTF-8 env](#org72737c5)
    3.  [browser (default: chrome)](#org119e215)
    4.  [emacs server (default: off)](#orgd73a9cd)
    5.  [newline (only Unix wanted)](#org2b326fb)
    6.  [auto revert](#org59e0e2d)
    7.  [yes-or-no](#org7421de4)
    8.  [hide menu bar & toolbar](#org31cccb9)
    9.  [alternate key mappings](#org5ff3a10)
    10. [macros (default: off)](#orgcb2c4e9)
    11. [linum](#org8af5eca)
8.  [font, theme](#orgc09598b)
    1.  [by packages](#org6f24e04)
        1.  [sublime themes (default: spolsky)](#orga820120)
        2.  [mode lines](#orgc5601d1)
        3.  [delight](#orga60804c)
        4.  [multiple-cursors](#org31b6f8f)
        5.  [dimmer](#org41ea32e)
        6.  [highlight indent](#org10397a3)
    2.  [fontlock](#org8acc0af)
    3.  [faces](#org0df667f)
    4.  [be quiet](#org9c8a9ff)
    5.  [In terminal mode](#orga91ca22)
    6.  [In X11 mode: mouse and window title](#orgb050ebd)
    7.  [dynamic cursor colors](#org9e6334c)
9.  [the big Org](#orgd57e812)
    1.  [init](#orgae38f0a)
        1.  [NEXT This does not seem to work, check out doc about defcustom](#org8829424)
    2.  [others](#orgc672f1c)
        1.  [snippets found online](#orgb6393b9)
        2.  [by packages](#org82e9710)
    3.  [key mappings](#orga302ced)
    4.  [display settings](#orgf5ffb53)
        1.  [org-bullets](#orgccf0121)
    5.  [writing stuff](#org950d47b)
        1.  [by packages](#org543f3d5)
        2.  [org-link-abbrev](#org76aa0d4)
    6.  [export](#org81091bf)
        1.  [org-babel](#org5891629)
        2.  [markdown](#org05ed9f2)
        3.  [beamer](#org9d603c7)
        4.  [org-reveal](#orgf3c62bb)
        5.  [odt](#orgaf9e1a4)
        6.  [taskjuggler](#org71a16be)
        7.  [confluence](#org69f0da4)
    7.  [managing life (aka. agenda/todo)](#org8e5d2ba)
        1.  [by packages](#orgcb1693a)
        2.  [keywords & status state machine](#org4dd4f7e)
        3.  [priorities](#org5c0c981)
        4.  [capture & refile](#org654da4d)
        5.  [task tracking](#org4813934)
        6.  [effort & columns mode](#org231157e)
        7.  [shortcut to open first agenda file](#org8928c85)
        8.  [org-agenda](#org71ba5d3)
        9.  [org-clock properties](#orga407701)
    8.  [LAST step: reload org](#orga1c02a0)
10. [buffers](#org0ff08f6)
    1.  [by packages](#orgf2594e0)
        1.  [multi desktops: eyebrowse](#orge091e88)
        2.  [select buffer](#orga26c9a3)
        3.  [buffer naming](#orgf8783d5)
    2.  [save & restore buffers](#orga7dd8b4)
    3.  [switch window config: winner-mode](#orgb9037ba)
    4.  [toggle maximize buffer](#orga6c65bc)
    5.  [buffer decorations](#org05b329d)
11. [editing](#org2f26edd)
    1.  [by packages](#orgc13aa1f)
        1.  [auto company](#org0ff90f8)
        2.  [undo tree](#orgd1bbb1a)
        3.  [search & jump](#org515357d)
        4.  [max 80 cols wide](#org257e13b)
        5.  [highlight whitespace & lines > 80 long](#orgb473146)
        6.  [browse kill ring](#org344928f)
        7.  [parenthesis](#org3974253)
        8.  [string inflection (default: some modes)](#org9a292d2)
        9.  [annotate-mode (default: some modes)](#org7436bf8)
        10. [writeroom-mode (default: off)](#orgc99414a)
        11. [anzu](#org1344b8e)
        12. [move-text](#org95189c4)
    2.  [no trailing spaces](#org440f798)
    3.  [iedit mode](#org9a85410)
12. [navigate file & dir](#org47b975d)
    1.  [dir hack](#orgd2f098f)
    2.  [dired-rainbow](#orgf4ab030)
    3.  [dired-narrow](#org60571b8)
    4.  [dired-collapse](#orgaf412a4)
    5.  [dired-filter](#org89bf026)
    6.  [treemacs (default: off)](#treemacs)
13. [Helm](#orgab27b15)
14. [Write chinese](#org5b5fd21)
15. [Office stuff](#orgef98b3a)
    1.  [mu4e email](#org53b6037)
        1.  [install & minimal setup](#org891e86c)
        2.  [how to get mails](#orgbdd32c3)
        3.  [list view](#org6e40743)
        4.  [read & attachment](#org5ca88ce)
        5.  [write new](#orgc8c2168)
        6.  [send](#org640c722)
        7.  [reply](#orga77aaa7)
        8.  [kill all buffer upon exit](#orgd88d981)
        9.  [write html](#org2b441d1)
16. [Hobbies](#org9331925)
    1.  [elfeed](#org317526a)
    2.  [taskjuggler](#org8ebf227)
17. [Coding](#org7986672)
    1.  [taskjuggler-mode (tj3-mode)](#org11dee66)
    2.  [Version control](#orgedc3e6c)
        1.  [magit](#org1406540)
        2.  [monky](#orgb9042f8)
        3.  [git informations in gutter](#org10f6131)
        4.  [speedup VCS](#orga8c123a)
        5.  [global caller](#orgb6debf4)
    3.  [Projectile](#orgd1c79fa)
    4.  [debug w/ GDB](#org8c2b332)
        1.  [Make it so that the source frame placement is forced only when using gdb.](#org5a50b6c)
    5.  [editing](#org783d42f)
        1.  [diffing](#org17b09fd)
        2.  [yasnippet](#org2cb9c13)
        3.  [commenting out](#org88f0120)
        4.  [deduplicate and sort](#org7d3f631)
        5.  [selective display (default: off)](#org8718ff7)
    6.  [IRC](#orgf9e555d)
    7.  [languages](#org2741bdd)
        1.  [markdown](#org2dbb895)
        2.  [C/C++](#org64b1c6b)
        3.  [python](#orge87d7fc)
        4.  [web-mode](#org305e5f6)
        5.  [web-beautify](#orgf41697a)
        6.  [emmet-mode](#orgf74c73b)
        7.  [javascript family: .js .ts .jsx](#org354c97a)
        8.  [csv](#org960a39d)
        9.  [json](#orgf8bbb82)
        10. [yaml](#org666d653)
    8.  [LAST: enforce my tab style](#orgae52d46)
18. [My doc writing](#orgd8941cc)
    1.  [pandoc](#org37eee9d)

I have seen others using org-mode to mangae emacs config, and they
came out very nicely. Finally, after 4 years of using emacs, I ran
into [Pascal Fleury](https://github.com/pascalfleury/emacs-config) portal emacs config, and it makes sense to me!!
After trying it out for a couple weeks now, I really like it! So now
after the configs are stable to my taste, and is also growing slowly
when I add new packages and custom stuff, I find the original sections
a bit, confusing. So I'm to take his copy and rearrange it so it fits
my way of thinking. I will not change the fundamental things such as
`tangle`, but will clarify what the packages and configs are about.


<a id="org4b32832"></a>

# the idea

This idea is actually a bit chicken-egg: in order to tangle, you must
first fire up emacs, then convert this org to `.el`, then load it back
into emacs to take effect.

The key here are relying on two things:

1.  There are two version of the `emacs_setup.el` file, one is a dummy
    short version that gets loaded for the very first time. This is the
    same stuff you can recreate using the [5.4.1](#orgd4eb4b7): `C-c C-v t`.
2.  In the default `.emacs, write one line: to load this =.el` file. Then,
    it short version will tangle this org file, and write over itself
    (on disk), thus literally replaced itself w/ more contents. At this
    point, it will tangle all the code blocks in this file, and at the
    end of it, it will call to [recompile packages](#recompile-packages), thus kicking off the
    entire download, compiling, installation and configuration.


<a id="orgf3b21ee"></a>

# deps

There are some host packages/tools you need to install. These are not
hard dependencies, but really, it works better that way if they are there.

I have been thinking how to handle them. The original author uses
tangle to create a bash file. So the idea is to run this `.sh`
first. But then, I think there are two problems:

1.  host package manager is different, eg. `apt` for Ubuntu, and `yum` for Cent.
2.  package name changes sometimes, and not mention, the packages are
    completely different among distributions.

    So all in all, I think it's much better to simply list what I want
    to have, and then let some offline research/google to handle how to
    install them. Another idea is to build a Docker image w/ all thest
    inside. Hmm&#x2026; I may try that someday.


<a id="org255509f"></a>

## what I want to use

I'll simply keep a list:

1.  [silver searcher, aka. ag](https://github.com/ggreer/the_silver_searcher)
2.  [nvm](https://github.com/nvm-sh/nvm): needed for Node
3.  [prettier](https://prettier.io/docs/en/install.html): require Node first
4.  sqlite3: needed by org-roam
5.  [reveal.js](https://github.com/hakimel/reveal.js/): needed to enable org-export to reveal slides
6.  [plantuml.jar](https://plantuml.com/download)
7.  [mu4e](https://packages.ubuntu.com/search?keywords=mu4e) & [isync](https://packages.ubuntu.com/search?keywords=isync) (this give you `mbsync`)
8.  [davmail](https://github.com/mguessan/davmail)


<a id="orga1791fc"></a>

# clean start

**ASSUMPTION**:

1.  you have installed emacs. Using v26.3 as of writing.
2.  determine where to put this org file. Throughout this doc, we are
    assuming `~/Emacs/` as the folder.

Once you are here, starting from a clean sheet is pretty easy:

1.  delete all your old `.emacs`, `.emacs.d`, or back them up somewhere.
2.  tangle this org file into a `.el` file. To make things easier, I'm
    going to include the `.el` in the repo. So just copy it.
3.  create a `.emacs` file, and write one line `(load-file
       "~/Emacs/emacs_setup.el")`, essentially tells emacs where to find
    the initial config file.
4.  make sure Emacs re-interprets its init (you could restart it).

That's it. Just sit back and watch emacs download and compile things,
and after it's done, you will be given the power of this beautiful
editor, all configured and ready to go! Now to think of it, isn't this
what LOC is trying to achieve!?


<a id="org8418937"></a>

## .emacs

I have my config in directory `~/Emacs` which is where I clone this
repository. The config setup is maintained purely in the
`~/Emacs/emacs_setup.org` file.

In your `~/.emacs` file, all you need to add is

    ;; Loads Feng's emacs setup with bootstrap
    (load-file "~/Emacs/emacs_setup.el")


<a id="org6db2b4f"></a>

## bootstrap .el

Put this in the `~/Emacs/emacs_setup.el`, and viola, it will regnerate itself!


    ;; This is the initial state of the file to be loaded.
    ;; It will replace itself with the actual configuration at first run.

    (require 'org) ; We can't tangle without org!

    (setq config_base (expand-file-name "emacs_setup"
                (file-name-directory
                 (or load-file-name buffer-file-name))))
    (find-file (concat config_base ".org"))        ; Open the configuration
    (org-babel-tangle)                             ; tangle it
    (load-file (concat config_base ".el"))         ; load it
    (byte-compile-file (concat config_base ".el")) ; finally byte-compile it


<a id="orga702bab"></a>

# reset

Reset takes two steps, but you can do either or both, depending on
what you are trying to reset.


<a id="org12a4c01"></a>

## reset config

If you have made a change to this org and what's to test drive it, you
need to either [5.4.1](#orgd4eb4b7) or just save this file to trigger [5.4.2](#org9c4e803). Sometimes, I found I have to go the [5.4.1](#orgd4eb4b7) route
because the hook is not fired. This is understandable that when I'm
changing this file, it may render a broken config, thus the hook and
all others can be in a comprised state when you start emacs.


<a id="recompile-packages"></a>

## recompile all packages

This is the **RESET** button. This will force-recompile everything in
`~/.emacs.d/elpa/...` Just run `M-:` and then enter this:

    (byte-recompile-directory package-user-dir nil 'force)

or simply `C-x C-e` at the end of that line.

**Note** that by setting `:tangle no`, this piece of code will be included
into the `.el` file. So it stays inside this org. Nice.


<a id="org6713fba"></a>

# initialize emacs


<a id="orgf241b29"></a>

## info header

Just to add a little information in the tangled file so you don't
**manually** mess with the generated `.el` file.

    ;; ===== this file was auto-tangled, only edit the emacs_setup.org =====


<a id="org25cadfe"></a>

## melpa

Make sure we have the package system initialized before we load anything.

    (require 'package)
    (when (< emacs-major-version 27)
      (package-initialize))

Adding my choice of packages repositories.

\#+NAME melpa-setup

    (setq package-archives '(("org" . "https://orgmode.org/elpa/")
                             ("stable-melpa" . "https://stable.melpa.org/packages/")
                             ("melpa" . "https://melpa.org/packages/")
                             ("gnu" . "https://elpa.gnu.org/packages/")
                             ; ("marmalade" . "https://marmalade-repo.org/packages/")
                            ))


<a id="org6288e70"></a>

## use-package

I use `use-package` for most configuration, and that needs to be at the
top of the file.  `use-package` verifies the presence of the requested
package, otherwise installs it, and presents convenient sections for
configs of variables, key bindings etc. that happen only if the
package is actually loaded.

First, make sure it gets installed if it is not there yet.

    ;; make sure use-package is installed
    (unless (package-installed-p 'use-package)
      (package-refresh-contents)
      (package-install 'use-package))
    (require 'use-package)

    (eval-when-compile (require 'use-package))


<a id="orgf46393a"></a>

## tangle this config


<a id="orgd4eb4b7"></a>

### manual tangle

I have setup auto tangle in the header as `:tangle yes`. So upon save,
this org file will be tangled into an `.el` file, and that is the file
emacs should load.

Alternatively, use the `C-c C-v t` [org-babel-tangle] to do this
manually.


<a id="org9c4e803"></a>

### auto tangle

I set this up to tangle the init org-mode file into the actual Emacs
init file as soon as I save it.

    (defun tangle-init ()
      "If the current buffer is 'init.org' the code-blocks are tangled,
    and the tangled file is compiled."
      (when (equal (buffer-file-name)
                   (expand-file-name "~/Emacs/fengxia.org"))
        ;; Avoid running hooks when tangling.
        (let ((prog-mode-hook nil))
          (org-babel-tangle)
          (byte-compile-file "~/Emacs/fengxia.el"))))

    ;; auto-tangle hook
    (add-hook 'after-save-hook 'tangle-init)


<a id="orgb385c12"></a>

# base packages

There are some packages you'd better load prior to everything else, so
that when other packages are being configured, they are already
available. For example, the .


<a id="org26ce78a"></a>

## all-the-icons

Want fancy [icons](https://github.com/domtronn/all-the-icons.el#installation):

    (use-package all-the-icons
      :ensure)

You would have to run `M-x all-the-icons-install-fonts=` manually at
least once to install fonts to your system.


<a id="orgca61a3d"></a>

## rainbow-mode

Colorize color names and codes in the correct color.

    (use-package rainbow-mode
      :ensure t
      :delight)


<a id="hydra"></a>

## Hydra

    (use-package hydra
      :ensure t)


<a id="org05b1449"></a>

## whichkey

Give me a hint when I'm entering a keybinding:

    (use-package which-key
      :ensure
      :config
      (which-key-setup-side-window-right))
    (which-key-mode)


<a id="org452810d"></a>

# global stuff

Some global settings such as line number. Well, just about everything
of emacs are global in a sense, say, a package, will affect the look
and behavior when loaded. Even though the mode could be refined to be
loaded only for some file pattern, but hey, the fun is about loading
these funky modes, and with them, a million funky keybinding combos to
remember.

So here, just some obvious value settings. If I find some to be more
topic specific, I will move them into that topic's section instead.


<a id="org8d4b233"></a>

## by packages

These are achieved by using someone's package.


<a id="orgefd1d55"></a>

### UTF-8

Make Emacs request UTF-8 first when pasting stuff

    (use-package unicode-escape
      :ensure t
      :init
      (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))
    (set-language-environment "UTF-8")


<a id="org53799af"></a>

### shell env

    (use-package exec-path-from-shell
      :ensure
      :config
      (exec-path-from-shell-initialize))


<a id="org72737c5"></a>

## UTF-8 env

    (prefer-coding-system 'utf-8)

    (setenv "LANG" "en_US.UTF-8")
    (setenv "LC_ALL" "en_US.UTF-8")
    (setenv "LC_CTYPE" "en_US.UTF-8")


<a id="org119e215"></a>

## browser (default: chrome)

I like Chrome. Period.

    (setq browse-url-generic-program (executable-find "google-chrome")
      browse-url-browser-function 'browse-url-generic)


<a id="orgd73a9cd"></a>

## emacs server (default: off)

Start the background server, so we can use emacsclient.

    (server-start)


<a id="org2b326fb"></a>

## newline (only Unix wanted)

This should automatically convert any files with dos or Mac line
endings into Unix style ones. Code found [here](https://www.emacswiki.org/emacs/EndOfLineTips).

    (defun no-junk-please-we-are-unixish ()
      (let ((coding-str (symbol-name buffer-file-coding-system)))
        (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
          (set-buffer-file-coding-system 'unix))))

    (add-hook 'find-file-hook 'no-junk-please-we-are-unixish)


<a id="org59e0e2d"></a>

## auto revert

Use `auto-revert`, which reloads a file if it's updated on disk and not
modified in the buffer.

    (global-auto-revert-mode 1)
    (put 'upcase-region 'disabled nil)
    (put 'narrow-to-region 'disabled nil)


<a id="org7421de4"></a>

## yes-or-no

Change all prompts to y or n:

    (fset 'yes-or-no-p 'y-or-n-p)


<a id="org31cccb9"></a>

## hide menu bar & toolbar

Using i3 is forcing me to use keyboard.

    (menu-bar-mode -1)
    (toggle-scroll-bar -1)
    (tool-bar-mode -1)
    (blink-cursor-mode -1)


<a id="org5ff3a10"></a>

## alternate key mappings

Letting one enter chars that are otherwise difficult in e.g. the
minibuffer.

    (global-set-key (kbd "C-m") 'newline-and-indent)
    (global-set-key (kbd "C-j") 'newline)
    (global-set-key [delete] 'delete-char)
    (global-set-key [kp-delete] 'delete-char)


<a id="orgcb2c4e9"></a>

## macros (default: off)

    (global-set-key [f3] 'start-kbd-macro)
    (global-set-key [f4] 'end-kbd-macro)
    (global-set-key [f5] 'call-last-kbd-macro)


<a id="org8af5eca"></a>

## linum

For now, I'm doing it globally.

    (global-display-line-numbers-mode t)

Yes I like having line numbers, but turnning it on globally makes some
buffers look strange. So let's limit it to the ones that I think
brings value. **Note** that the ones I skip are:

1.  mu4e-compose-mode: when writing email, it's better not to count for line num.
2.  markdown: for the same reason. I'm writing.

    (add-hook 'c-mode-common-hook 'display-line-numbers-mode)
    (add-hook 'org-mode-hook 'display-line-numbers-mode)
    (add-hook 'elpy-mode-hook 'display-line-numbers-mode)
    (add-hook 'web-mode-hook 'display-line-numbers-mode)
    (add-hook 'js2-mode-hook 'display-line-numbers-mode)
    (add-hook 'yaml-mode-hook 'display-line-numbers-mode)
    (add-hook 'json-mode-hook 'display-line-numbers-mode)
    (add-hook 'java-mode-hook 'display-line-numbers-mode)


<a id="orgc09598b"></a>

# font, theme

The whole point of using emacs is that I like the user experience, and
a big part of it is the color and look. There are too many ways to
tweak it. So I'll try not to run wild on this one. Most are inherited
from the original post, and I added some while playing with this
setting. Enjoy ~~


<a id="org6f24e04"></a>

## by packages


<a id="orga820120"></a>

### sublime themes (default: spolsky)

Loading a theme I like.

      (use-package sublime-themes
        :ensure
        :config)
    (add-hook 'after-init-hook (lambda () (load-theme 'spolsky t)))


<a id="orgc5601d1"></a>

### mode lines

1.  doom-modeline

        (use-package doom-modeline
          :ensure t
          :init (doom-modeline-mode 1))

2.  remove some modelines

        (use-package eldoc
          :delight)

3.  nyan-mode

        (use-package nyan-mode
          :ensure t
          :bind ("C-M-x n" . 'nyan-mode))


<a id="orga60804c"></a>

### delight

Package to remove some info from the mode-line for minor-modes.

    (use-package delight
      :ensure t)


<a id="org31b6f8f"></a>

### multiple-cursors

Configure the shortcuts for multiple cursors.

    (use-package multiple-cursors
      :ensure t
      :bind (("C-S-c C-S-c" . 'mc/edit-lines)
             ("C->" . 'mc/mark-next-like-this)
             ("C-<" . 'mc/mark-previous-like-this)
             ("C-c C->" . 'mc/mark-all-like-this)))


<a id="org41ea32e"></a>

### dimmer

This will dim the buffer that is not the current. Sort of a visual
cue. However, I found that it can be ugly depending the theme.

    (use-package dimmer
      :ensure
      :config
      (dimmer-configure-which-key)
      (dimmer-configure-helm))
    (dimmer-mode t)


<a id="org10397a3"></a>

### highlight indent

    (use-package highlight-indent-guides
    :ensure
    :config
    (setq highlight-indent-guides-method 'character))
    (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)


<a id="org8acc0af"></a>

## fontlock

This gets the font coloring switched on for all buffers.

I have encountered a strange case when a mal-formatted Java file
caused Emacs to crash. After many research, the remedy is to use
[prettier-java](https://github.com/jhipster/prettier-java) to reformat this file first, then emacs is happy.

    (global-font-lock-mode t)


<a id="org0df667f"></a>

## faces

This makes some of the faces a bit more contrasted.

    ;; faces for general region highlighting zenburn is too low-key.
    (custom-set-faces
     '(highlight ((t (:background "forest green"))))
     '(region ((t (:background "forest green")))))


<a id="org9c8a9ff"></a>

## be quiet

Remove bell and dings.

    (setq ring-bell-function
          '(lambda ()
             (message "The answer is 42...")))
    (setq echo-keystrokes 0.1 use-dialog-box nil visible-bell t)


<a id="orga91ca22"></a>

## In terminal mode

    (when (display-graphic-p)
      (set-background-color "#ffffff")
      (set-foreground-color "#141312"))


<a id="orgb050ebd"></a>

## In X11 mode: mouse and window title

    (setq frame-title-format "emacs @ %b - %f")
    (when window-system
      (mouse-wheel-mode)  ;; enable wheelmouse support by default
      (set-selection-coding-system 'compound-text-with-extensions))


<a id="org9e6334c"></a>

## dynamic cursor colors

The cursor is displayed in different colors, depending on overwrite or
insert mode.

    (setq hcz-set-cursor-color-color "")
    (setq hcz-set-cursor-color-buffer "")

    (defun hcz-set-cursor-color-according-to-mode ()
      "change cursor color according to some minor modes."
      ;; set-cursor-color is somewhat costly, so we only call it when needed:
      (let ((color
             (if buffer-read-only "orange"
               (if overwrite-mode "red"
                 "green"))))
        (unless (and
                 (string= color hcz-set-cursor-color-color)
                 (string= (buffer-name) hcz-set-cursor-color-buffer))
          (set-cursor-color (setq hcz-set-cursor-color-color color))
          (setq hcz-set-cursor-color-buffer (buffer-name)))))

    (add-hook 'post-command-hook 'hcz-set-cursor-color-according-to-mode)


<a id="orgd57e812"></a>

# the big Org

Org-mode is, overwhelming! It can do a lot, and it takes a long time
for me to understand what it does (and what it doesn't). Part of this
config in org mode is just the way to force myself to learn org mdoe
and write things in org mode. I haven't yet taken full advantage of
its TODO capability. Well, one day.


<a id="orgae38f0a"></a>

## init

If variable `org-directory` is not set yet, map it to my home's
files. You may set this in the `~/.emacs` to another value,
e.g. `(setq org-directory "/ssh:fleury@machine.site.com:OrgFiles")`


<a id="org8829424"></a>

### NEXT This does not seem to work, check out doc about [defcustom](https://stackoverflow.com/questions/3806423/how-can-i-get-a-variables-initial-value-in-elisp)

    (use-package org
      :ensure nil
      :delight org-mode
      :config
      :hook ((org-mode . visual-line-mode)
           (org-mode . org-indent-mode)))


<a id="orgc672f1c"></a>

## others

Don't know what they belong to. Just stuck them here. There are some functions used by the following code. So unfortunately this section must comes in early.


<a id="orgb6393b9"></a>

### snippets found online

Some helper snippets found online.

1.  Open remote org dir

    In your `.emacs` just add this to configure the location:

        (setq remote-org-directory "/ssh:fleury@my.hostname.com:OrgFiles")

    Then you can use the keyboard shortcut to open that dir.

        (defcustom remote-org-directory "~/OrgFiles"
          "Location of remove OrgFile directory, should you have one."
          :type 'string
          :group 'paf)
        (defun paf/open-remote-org-directory ()
          (interactive)
          (find-file remote-org-directory))

        (global-set-key (kbd "C-M-x r o") 'paf/open-remote-org-directory)

2.  Org-relative file function

        (defun org-relative-file (filename)
          "Compute an expanded absolute file path for org files"
          (expand-file-name filename org-directory))

3.  Adjust tags on the right

    Dynamically adjust tag position [source on worg](https://orgmode.org/worg/org-hacks.html#org0560357)

        (defun ba/org-adjust-tags-column-reset-tags ()
          "In org-mode buffers it will reset tag position according to
        `org-tags-column'."
          (when (and
                 (not (string= (buffer-name) "*Remember*"))
                 (eql major-mode 'org-mode))
            (let ((b-m-p (buffer-modified-p)))
              (condition-case nil
                  (save-excursion
                    (goto-char (point-min))
                    (command-execute 'outline-next-visible-heading)
                    ;; disable (message) that org-set-tags generates
                    (cl-letf (((symbol-function 'message) #'format))
                      (org-set-tags 1 t))
                    (set-buffer-modified-p b-m-p))
                (error nil)))))

        (defun ba/org-adjust-tags-column-now ()
          "Right-adjust `org-tags-column' value, then reset tag position."
          (set (make-local-variable 'org-tags-column)
               (- (- (window-width) (length org-ellipsis))))
          (ba/org-adjust-tags-column-reset-tags))

        (defun ba/org-adjust-tags-column-maybe ()
          "If `ba/org-adjust-tags-column' is set to non-nil, adjust tags."
          (when ba/org-adjust-tags-column
            (ba/org-adjust-tags-column-now)))

        (defun ba/org-adjust-tags-column-before-save ()
          "Tags need to be left-adjusted when saving."
          (when ba/org-adjust-tags-column
             (setq org-tags-column 1)
             (ba/org-adjust-tags-column-reset-tags)))

        (defun ba/org-adjust-tags-column-after-save ()
          "Revert left-adjusted tag position done by before-save hook."
          (ba/org-adjust-tags-column-maybe)
          (set-buffer-modified-p nil))

        ;; between invoking org-refile and displaying the prompt (which
        ;; triggers window-configuration-change-hook) tags might adjust,
        ;; which invalidates the org-refile cache
        (defadvice org-refile (around org-refile-disable-adjust-tags)
          "Disable dynamically adjusting tags"
          (let ((ba/org-adjust-tags-column nil))
            ad-do-it))
        (ad-activate 'org-refile)

        ;; Now set it up
        (setq ba/org-adjust-tags-column t)
        ;; automatically align tags on right-hand side
        ;; TODO(fleury): Does not seem to work as of 2017/12/18
        ;; Seems to work again 2018/11/01
        (add-hook 'window-configuration-change-hook
                  'ba/org-adjust-tags-column-maybe)
        (add-hook 'before-save-hook 'ba/org-adjust-tags-column-before-save)
        (add-hook 'after-save-hook 'ba/org-adjust-tags-column-after-save)
        (add-hook 'org-agenda-mode-hook (lambda ()
                                          (setq org-agenda-tags-column (- (window-width)))))

    1.  TODO Update `org-set-tags-to`

        [`org-set-tags-to`](https://orgmode.org/worg/doc.html#org-set-tags-to) is gone, and `org-set-tags` with > 1 args is not working.
        Not sure what to replace it with though&#x2026;

4.  Preserve structure in archives

    Make sure archiving preserves the same tree structure, including when
    archiving subtrees.  [source on worg](https://orgmode.org/worg/org-hacks.html#org4265b4c)

        (defun my-org-inherited-no-file-tags ()
          (let ((tags (org-entry-get nil "ALLTAGS" 'selective))
                (ltags (org-entry-get nil "TAGS")))
            (mapc (lambda (tag)
                    (setq tags
                          (replace-regexp-in-string (concat tag ":") "" tags)))
                  (append org-file-tags (when ltags (split-string ltags ":" t))))
            (if (string= ":" tags) nil tags)))

    This used to work, but `org-extract-archive-file` is no longer defined.

        (defadvice org-archive-subtree
            (around my-org-archive-subtree-low-level activate)
          (let ((tags (my-org-inherited-no-file-tags))
                (org-archive-location
                 (if (save-excursion (org-back-to-heading)
                                     (> (org-outline-level) 1))
                     (concat (car (split-string org-archive-location "::"))
                             "::* "
                             (car (org-get-outline-path)))
                   org-archive-location)))
            ad-do-it
            (with-current-buffer (find-file-noselect (org-extract-archive-file))
              (save-excursion
                (while (org-up-heading-safe))
                (org-set-tags tags)))))

5.  Properties collector (default: off)

    Collect properties into tables. See documentation in the file.

        (load-file "~/Emacs/org-collector.el")

6.  access org file remotely via SSH

    Let's bind this to a key, so I can open remote dirs. I suually put
    this in my `.emacs` as it is host- and user-specific.

        (defun paf/open-remote-org-dir ()
          (interactive)
          (dired "/ssh:remote.host.com:org"))

        (global-set-key (kbd "C-M-x r o") 'paf/open-remote-org-dir)

7.  bash command

        (setq org-babel-sh-command "bash")

8.  OrgRoam templates

        (setq org-roam-capture-templates
              `(("m" "Meeting" entry (function org-roam--capture-get-point)
                     "* %?\n%U\n%^{with}\n"
                     :file-name "meeting/%<%Y%m%d%H%M%S>-${slug}"
                     :head "#+title: ${title}\n#+roam_tags: %^{with}\n\n"
                     )))


<a id="org82e9710"></a>

### by packages

1.  org-protocol

    Let other tools use emacs client to interact

        (require 'org-protocol)

2.  org-roam

    My cheat sheet for `org-roam`

    All keys prefixed with `C-c n`

    <table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


    <colgroup>
    <col  class="org-left" />

    <col  class="org-center" />
    </colgroup>
    <thead>
    <tr>
    <th scope="col" class="org-left">Function</th>
    <th scope="col" class="org-center">`C-c n <key>`</th>
    </tr>
    </thead>

    <tbody>
    <tr>
    <td class="org-left">Toggle side panel</td>
    <td class="org-center">l</td>
    </tr>
    </tbody>

    <tbody>
    <tr>
    <td class="org-left">Find/create</td>
    <td class="org-center">f</td>
    </tr>


    <tr>
    <td class="org-left">Insert link</td>
    <td class="org-center">i</td>
    </tr>


    <tr>
    <td class="org-left">Capture</td>
    <td class="org-center">c</td>
    </tr>
    </tbody>

    <tbody>
    <tr>
    <td class="org-left">Graph</td>
    <td class="org-center">g</td>
    </tr>


    <tr>
    <td class="org-left">Switch to buffer</td>
    <td class="org-center">b</td>
    </tr>
    </tbody>
    </table>

        (use-package org-roam
          :ensure t
          :hook (after-init . org-roam-mode)
          :init (setq org-roam-directory
                      (org-relative-file "OrgRoam"))
          :bind (:map org-roam-mode-map
                      (("C-c n l" . org-roam)
                       ("C-c n b" . org-roam-switch-to-buffer)
                       ("C-c n f" . org-roam-find-file)
                       ("C-c n c" . org-roam-capture)
                       ("C-c n g" . org-roam-graph))
                 :map org-mode-map
                      (("C-c n i" . org-roam-insert))))

        (use-package company-org-roam
          :ensure t
          :after org-roam)

    EmacSQL will need to get its C-binary compiled, and needs supporting
    tools. Note that 'tcc' for Termux seems not complete enough for the
    job.

3.  org-board

    Archive entire sites locally with \`wget\`.

        (use-package org-board
          :ensure t
          :config
          (global-set-key (kbd "C-c o") org-board-keymap))

4.  iimage (M-I)

    Make the display of images a simple key-stroke away.

        (defun paf/org-toggle-iimage-in-org ()
          "display images in your org file"
          (interactive)
          (if (face-underline-p 'org-link)
              (set-face-underline 'org-link nil)
            (set-face-underline 'org-link t))
          (iimage-mode 'toggle))

        (use-package iimage
          :config
          (add-to-list 'iimage-mode-image-regex-alist
                       (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex
                                     "\\)\\]")  1))
          (add-hook 'org-mode-hook (lambda ()
                                     ;; display images
                                     (local-set-key "\M-I" 'paf/org-toggle-iimage-in-org)
                                    )))


<a id="orga302ced"></a>

## key mappings

    (global-set-key (kbd "C-c l") 'org-store-link)
    (global-set-key (kbd "C-c c") 'org-capture)
    (global-set-key (kbd "C-c a") 'org-agenda)
    (global-set-key (kbd "C-c b") 'org-iswitchb)

    (add-hook 'org-mode-hook
              (lambda ()
                (local-set-key (kbd "C-<up>") 'org-move-subtree-up)
                (local-set-key (kbd "C-<down>") 'org-move-subtree-down)
                (local-set-key (kbd "C-c l") 'org-store-link)
                (local-set-key (kbd "C-c C-l") 'org-insert-link)))


<a id="orgf5ffb53"></a>

## display settings

Some config for display. Some of these are borrowed from [here](https://zzamboni.org/post/beautifying-org-mode-in-emacs/):

    (setq org-hide-leading-stars t)
    (setq org-log-done t)
    (setq org-startup-indented t)
    (setq org-startup-folded t)
    (setq org-ellipsis "...")
    (setq org-hide-emphasis-markers t)


<a id="orgccf0121"></a>

### org-bullets

    (use-package org-bullets
      :ensure
      :hook (org-mode . org-bullets-mode))


<a id="org950d47b"></a>

## writing stuff

Part 1, writing stuff such as taking notes.


<a id="org543f3d5"></a>

### by packages

1.  Zetteldeft

    This is a note-taking packages inspired by the principles of the
    [Zettelkasten.](https://zettelkasten.de/)

        (use-package deft
          :ensure t)
        (use-package avy
          :ensure t)

        (use-package zetteldeft
          :ensure t
          :after (org deft avy)

          :config
          (setq deft-extensions '("org" "md" "txt"))
          (setq deft-directory (org-relative-file "Zettelkasten"))
          (setq deft-recursive t)

          :bind (("C-c z d" . deft)
                 ("C-c z D" . zetteldeft-deft-new-search)
                 ("C-c z R" . deft-refresh)
                 ("C-c z s" . zetteldeft-search-at-point)
                 ("C-c z c" . zetteldeft-search-current-id)
                 ("C-c z f" . zetteldeft-follow-link)
                 ("C-c z F" . zetteldeft-avy-file-search-ace-window)
                 ("C-c z l" . zetteldeft-avy-link-search)
                 ("C-c z t" . zetteldeft-avy-tag-search)
                 ("C-c z T" . zetteldeft-tag-buffer)
                 ("C-c z i" . zetteldeft-find-file-id-insert)
                 ("C-c z I" . zetteldeft-find-file-full-title-insert)
                 ("C-c z o" . zetteldeft-find-file)
                 ("C-c z n" . zetteldeft-new-file)
                 ("C-c z N" . zetteldeft-new-file-and-link)
                 ("C-c z r" . zetteldeft-file-rename))
        )

2.  plant-uml

    Tell where PlantUML is to be found. This needs to be downloaded and
    installed separately, see the [PlantUML website](http://plantuml.com/).

        (use-package plantuml-mode
         :ensure t
         :config
          (setq plantuml-jar-path "~/workspace/me/myblog/content/downloads/plantuml.jar")
          (setq org-plantuml-jar-path "~/workspace/me/myblog/content/downloads/plantuml.jar")
          ;; Let us edit PlantUML snippets in plantuml-mode within orgmode
          (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
          ;; make it load this language (for export ?)
          (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))
          ;; Enable plantuml-mode for PlantUML files
          (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode)))


<a id="org76aa0d4"></a>

### org-link-abbrev

This lets one write links as e.g. [ [b:123457] ]

    (setq org-link-abbrev-alist
          '(("b" . "http://b/")
            ("go" . "http://go/")
            ("cl" . "http://cr/")))


<a id="org81091bf"></a>

## export

Part 2, exporting.

This is big deal. It took me a while to learn org, and even right now
I still don't know how to use it for schedule management. This feels
like latex, it's wonderful, but not common among non-org-mode folks.

Add a few formats to the export functionality of org-mode.


<a id="org5891629"></a>

### org-babel

What kind of code block languages do I need

    (setq org-confirm-babel-evaluate 'nil) ; Don't ask before executing

    (org-babel-do-load-languages
     'org-babel-load-languages
     '(
       (R . t)
       (dot . t)
       (emacs-lisp . t)
       (gnuplot . t)
       (python . t)
       (ledger . t)
       ;;(sh . t)
       (latex . t)
       (shell . t)
      ))


<a id="org05ed9f2"></a>

### markdown

    (use-package ox-md
      :defer)


<a id="org9d603c7"></a>

### beamer

    (use-package ox-beamer
      :defer)


<a id="orgf3c62bb"></a>

### org-reveal

You need to install `reveal.js` offline, then specify its path here.

    (use-package ox-reveal
      :ensure t
      :after (htmlize)
      :config
      (setq org-reveal-root (expand-file-name "~/reveal.js")))

    (use-package htmlize
      :ensure t)


<a id="orgaf9e1a4"></a>

### odt

    (use-package ox-odt
      :defer)


<a id="org71a16be"></a>

### taskjuggler

    (use-package ox-taskjuggler
      :defer)


<a id="org69f0da4"></a>

### confluence

    (use-package ox-confluence
      :defer)


<a id="org8e5d2ba"></a>

## managing life (aka. agenda/todo)

Part 3 of org, managing TODOs.


<a id="orgcb1693a"></a>

### by packages

1.  org-super-agenda

    This enables a more fine-grained filtering of the agenda items.

        (use-package org-super-agenda
          :ensure t
          :config
          (org-super-agenda-mode t))

2.  org-clock-convenience

        (use-package org-clock-convenience
          :ensure t
          :bind (:map org-agenda-mode-map
                   ("<S-right>" . org-clock-convenience-timestamp-up)
                   ("<S-left>" . org-clock-convenience-timestamp-down)
                   ("[" . org-clock-convenience-fill-gap)
                   ("]" . org-clock-convenience-fill-gap-both)))

3.  org-habit

        (use-package org-habit
          :delight
          :config
          (setq org-habit-graph-column 38)
          (setq org-habit-preceding-days 35)
          (setq org-habit-following-days 10)
          (setq org-habit-show-habits-only-for-today nil))

4.  org-secretary

    This package is good, but it does not do it simply. I re-modeled it
    somewhat below.

        (use-package org-secretary
          :ensure org-plus-contrib
          :config
          (setq org-sec-me "feng")
          (setq org-tag-alist '(("PRJ" . ?p)
                                ("DESIGNDOC" . ?D)
                                ("Milestone" . ?m)
                                ("DESK" . ?d)
                                ("HOME" . ?h)
                                ("VC" . ?v))))

    This is my version of the org-secretary

        (use-package paf-secretary
          :load-path "~/Emacs"
          :bind (("\C-cw" . paf-sec-set-with)
                 ("\C-cW" . paf-sec-set-where)
                 ("\C-cj" . paf-sec-tag-entry))
          :config
          (setq paf-sec-me "paf")
          (setq org-tag-alist '(("PRJ" . ?p)
                                ("DESIGNDOC" . ?D)
                                ("Milestone" . ?m)
                                ("DESK" . ?d)
                                ("HOME" . ?h)
                                ("VC" . ?v))))

5.  org-duration

        (use-package org-duration
          :config
          (setq org-duration-units
                `(("min" . 1)
                  ("h" . 60)
                  ("d" . ,(* 60 8))
                  ("w" . ,(* 60 8 5))
                  ("m" . ,(* 60 8 5 4))
                  ("y" . ,(* 60 8 5 4 10)))
                )
          (org-duration-set-regexps))


<a id="org4dd4f7e"></a>

### keywords & status state machine

TODO doesn't have to have a special keyword. However, once you have a
list, you can enjoy things like color coded font, status transition
timestamp, and kinda of query report such as "give me the list of my
<meetings>". Just convenient.

The state machine is essentially your workflow, how you want to take a
task through its stages, eg. from ready to in-progress to in-review to
done. So really, develop a workflow of your own that fits your way of
thinking, and it should feel natural how you handle a todo in daily
life.

I think this is the single most challenging point to adopt Org because
people, myself included, are hardly capable to analyze your own task
handling habit to abstract such workflow. Company hires consulting
firms to do that for them; an individual, unlikely. We coast along
life everyday, but who can write down "here is how I get a TODO off my
list, each time!?".

Anyway, I think adopting Org is essentially to force yourself into a
**routine** that is codified. It sounds rigid, IT-ish. But for efficiency,
it's a necessary evil.

    (setq org-todo-keywords
          '((sequence "TODO(t!)" "WORKING(w!)" "|" "DONE(d!)" "CANCELLED(C@)" "DEFERRED(D@)" "SOMEDAY(S!)" "FAILED(F!)" "REFILED(R!)")
            (sequence "TASK(m!)" "ACTIVE" "|" "DONE(d!)" "CANCELLED(C@)" )))

    (setq org-tags-exclude-from-inheritance '("PRJ" "REGULAR")
          org-use-property-inheritance '("PRIORITY")
          org-stuck-projects '("+PRJ/-DONE-CANCELLED"
                               ;; it is considered stuck if there is no next action
                               (;"TODO"
                                "WORKING" "ACTIVE" "TASK") ()))

    (setq org-todo-keyword-faces
          '(
            ("TODO" . (:foreground "GhostWhite" :weight bold))
            ("TASK" . (:foreground "steelblue" :weight bold))
            ("NEXT" . (:foreground "red" :weight bold))
            ("STARTED" . (:foreground "green" :weight bold))
            ("WAITING" . (:foreground "orange" :weight bold))
            ("FLAG_GATED" . (:foreground "orange" :weight bold))
            ("SOMEDAY" . (:foreground "steelblue" :weight bold))
            ("MAYBE" . (:foreground "steelblue" :weight bold))
            ("AI" . (:foreground "red" :weight bold))
            ("NEW" . (:foreground "orange" :weight bold))
            ("RUNNING" . (:foreground "orange" :weight bold))
            ("WORKED" . (:foreground "green" :weight bold))
            ("FAILED" . (:foreground "red" :weight bold))
            ("REFILED" . (:foreground "gray"))
            ;; For publications
            ("APPLIED" . (:foreground "orange" :weight bold))
            ("ACCEPTED" . (:foreground "orange" :weight bold))
            ("REJECTED" . (:foreground "red" :weight bold))
            ("PUBLISHED" . (:foreground "green" :weight bold))
            ;; Other stuff
            ("ACTIVE" . (:foreground "darkgreen" :weight bold))
            ))


<a id="org5c0c981"></a>

### priorities

Set color for priorities based on [this](http://pragmaticemacs.com/emacs/org-mode-basics-vi-a-simple-todo-list/).

    (setq org-priority-faces '((?A . (:foreground "#F0DFAF" :weight bold))
                               (?B . (:foreground "LightSteelBlue"))
                               (?C . (:foreground "OliveDrab"))))


<a id="org654da4d"></a>

### capture & refile

Capture and refile stuff, with some templates that I think are useful.

Very nice post on how to get capture templats from a file: [Org-capture
in Files](https://joshrollinswrites.com/help-desk-head-desk/org-capture-in-files/).

    (setq org-default-notes-file (org-relative-file "~/org/tasks.org"))

    (setq org-capture-templates
          `(("t" "Task"
             entry (file+headline ,(org-relative-file "~/org/tasks.org") "Tasks")
             "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n"
             :clock-resume t)
            ;;
            ("i" "Idea"
             entry (file+headline ,(org-relative-file "~/org/tasks.org") "Ideas")
             "* SOMEDAY %?\n%U\n\n%x"
             :clock-resume t)
            ;;
            ("m" "Meeting"
             entry (file+headline ,(org-relative-file "~/org/tasks.org") "Meetings")
             "* %?  :MTG:\n%U\n%^{with}p"
             :clock-in t
             :clock-resume t)
            ;;
            ("s" "Stand-up"
             entry (file+headline ,(org-relative-file "~/org/tasks.org") "Meetings")
             "* Stand-up  :MTG:\n%U\n\n%?"
             :clock-in t
             :clock-resume t)
            ;;
            ("1" "1:1"
             entry (file+headline ,(org-relative-file "~/org/tasks.org") "Meetings")
             "* 1:1 %^{With}  :MTG:\n%U\n:PROPERTIES:\n:with: %\\1\n:END:\n\n%?"
             :clock-in t
             :clock-resume t)
            ;;
            ("p" "Talking Point"
             entry (file+headline ,(org-relative-file "~/org/refile.org") "Talking Points")
             "* %?  :TALK:\n%U\n%^{dowith}p"
             :clock-keep t)
            ;;
            ("j" "Journal"
             entry (file+olp+datetree ,(org-relative-file "~/org/journal.org"))
             "* %?\n%U"
             :clock-in t
             :clock-resume t
             :kill-buffer t)))

    ;; show up to 2 levels for refile targets, in all agenda files
    (setq org-refile-targets '((org-agenda-files . (:maxlevel . 2))))
    (setq org-log-refile t)  ;; will add timestamp when refiled.

    ;; from: http://doc.norang.ca/org-mode.html
    ;; Exclude DONE state tasks from refile targets
    (defun bh/verify-refile-target ()
      "Exclude todo keywords with a done state from refile targets"
      (not (member (nth 2 (org-heading-components)) org-done-keywords)))
    (setq org-refile-target-verify-function 'bh/verify-refile-target)


<a id="org4813934"></a>

### task tracking

Track task dependencies, and dim them in the agenda.

    (setq org-enforce-todo-dependencies t)
    (setq org-agenda-dim-blocked-tasks 'invisible)


<a id="org231157e"></a>

### effort & columns mode

    (setq org-global-properties
          '(("Effort_ALL". "0 0:10 0:30 1:00 2:00 4:00 8:00 16:00")))
    (setq org-columns-default-format
          "%TODO %30ITEM %3PRIORITY %6Effort{:} %10DEADLINE")


<a id="org8928c85"></a>

### shortcut to open first agenda file

F12 open the first agenda file

    (defun org-get-first-agenda-file ()
      (interactive)
      (find-file (elt org-agenda-files 0)))
    (global-set-key [f12] 'org-get-first-agenda-file)
    ; F12 on Mac OSX displays the dashboard....
    (global-set-key [C-f12] 'org-get-first-agenda-file)


<a id="org71ba5d3"></a>

### org-agenda

1.  views

        (setq org-agenda-custom-commands
              '(("t" "Hot Today" ((agenda "" ((org-agenda-span 'day)))
                                  (tags-todo "-with={.+}/WAITING")
                                  (tags-todo "-with={.+}+TODO=\"STARTED\"")
                                  (tags-todo "/NEXT")))
                ("T" "Team Today" ((agenda "" ((org-agenda-span 'day)))
                                   (tags-todo "with={.+}"
                                            ((org-super-agenda-groups
                                              '((:auto-property "with"))))
                                            )))
                ("r" "Recurring" ((tags "REGULAR")
                                  (tags-todo "/WAITING")
                                  (tags-todo "TODO=\"STARTED\"")
                                  (tags-todo "/NEXT")))
                ("n" "Agenda and all TODO's" ((agenda "")
                                              (alltodo "")))
                ("N" "Next actions" tags-todo "-dowith={.+}/!-TASK-TODO"
                 ((org-agenda-todo-ignore-scheduled t)))
                ("h" "Work todos" tags-todo "-dowith={.+}/!-TASK"
                 ((org-agenda-todo-ignore-scheduled t)))
                ("H" "All work todos" tags-todo "-personal/!-TASK-CANCELLED"
                 ((org-agenda-todo-ignore-scheduled nil)))
                ("A" "Work todos with doat or dowith" tags-todo
                 "dowith={.+}/!-TASK"
                 ((org-agenda-todo-ignore-scheduled nil)))

                ("p" "Tasks with current WITH and WHERE"
                 ((tags-todo (paf-sec-replace-with-where "with={$WITH}" ".+")
                             ((org-agenda-overriding-header
                               (paf-sec-replace-with-where "Tasks with $WITH in $WHERE" "anyone" "any place"))
                              (org-super-agenda-groups
                               '((:name "" :pred paf-sec-limit-to-with-where)
                                 (:discard (:anything t)))))
                             )))
                ("j" "TODO dowith and TASK with"
                 ((org-sec-with-view "TODO dowith")
                  (org-sec-stuck-with-view "TALK with")
                  (org-sec-where-view "TODO doat")
                  (org-sec-assigned-with-view "TASK with")
                  (org-sec-stuck-with-view "STUCK with")
                  (todo "STARTED")))
                ("J" "Interactive TODO dowith and TASK with"
                 ((org-sec-who-view "TODO dowith")))))

        (setq org-agenda-skip-deadline-prewarning-if-scheduled 2)

2.  delight

        (delight 'org-agenda-mode)

3.  colors and faces

    Make the calendar day info a bit more visible and contrasted.

        ;; Faces to make the calendar more colorful.
        (custom-set-faces
         '(org-agenda-current-time ((t (:inherit org-time-grid :foreground "yellow" :weight bold))))
         '(org-agenda-date ((t (:inherit org-agenda-structure :background "pale green" :foreground "black" :weight bold))))
         '(org-agenda-date-weekend ((t (:inherit org-agenda-date :background "light blue" :weight bold)))))

4.  now marker

    A more visible current-time marker in the agenda

        (setq org-agenda-current-time-string ">>>>>>>>>> NOW <<<<<<<<<<")

5.  auto-refresh

        ;; will refresh it only if already visible
        (run-at-time nil 180 'update-agenda-if-visible)
        ;;(add-hook 'org-mode-hook
        ;;          (lambda () (run-at-time nil 180 'kiwon/org-agenda-redo-in-other-window)))

    This would open the agenda if any org file was opened. In the end, I
    don't like this feature, so it is disabled by not tangling it.

        ;; Make this happen only if we open an org file.
        (add-hook 'org-mode-hook
                  (lambda () (run-with-idle-timer 600 t 'jump-to-org-agenda)))

6.  auto-save org files when idle

    This will save them regularly when the idle for more than a minute.

        (add-hook 'org-mode-hook
                  (lambda () (run-with-idle-timer 600 t 'org-save-all-org-buffers)))

7.  export

    That's the export function to update the agenda view.

        (setq org-agenda-exporter-settings
              '((ps-number-of-columns 2)
                (ps-portrait-mode t)
                (org-agenda-add-entry-text-maxlines 5)
                (htmlize-output-type 'font)))

        (defun dmg-org-update-agenda-file (&optional force)
          (interactive)
          (save-excursion
            (save-window-excursion
              (let ((file "~/www/agenda/agenda.html"))
                (org-agenda-list)
                (org-agenda-write file)))))

8.  Auto-Refresh Agenda

    Refresh org-mode agenda regularly.  [source on worg](https://orgmode.org/worg/org-hacks.html#orgab827a7) There are two
    functions that supposedly do the same.

        (defun kiwon/org-agenda-redo-in-other-window ()
          "Call org-agenda-redo function even in the non-agenda buffer."
          (interactive)
          (let ((agenda-window (get-buffer-window org-agenda-buffer-name t)))
            (when agenda-window
              (with-selected-window agenda-window (org-agenda-redo)))))

        (defun update-agenda-if-visible ()
          (interactive)
          (let ((buf (get-buffer "*Org Agenda*"))
                wind)
            (if buf
                (org-agenda-redo))))

9.  Display Agenda when idle

    Show the agenda when emacs left idle.  [source on worg](https://orgmode.org/worg/org-hacks.html#orgaea636d)

        (defun jump-to-org-agenda ()
          (interactive)
          (let ((buf (get-buffer "*Org Agenda*"))
                wind)
            (if buf
                (if (setq wind (get-buffer-window buf))
                    (select-window wind)
                  (if (called-interactively-p 'any)
                      (progn
                        (select-window (display-buffer buf t t))
                        (org-fit-window-to-buffer)
                        (org-agenda-redo)
                        )
                    (with-selected-window (display-buffer buf)
                      (org-fit-window-to-buffer)
                      ;;(org-agenda-redo)
                      )))
              (call-interactively 'org-agenda-list)))
          ;;(let ((buf (get-buffer "*Calendar*")))
          ;;  (unless (get-buffer-window buf)
          ;;    (org-agenda-goto-calendar)))
          )

10. Display location in agenda

    From some help on [this page](https://emacs.stackexchange.com/questions/26249/customize-text-after-task-in-custom-org-agenda-view) I think this could work:

        (defun paf/org-agenda-get-location()
          "Gets the value of the LOCATION property"
          (let ((loc (org-entry-get (point) "LOCATION")))
            (if (> (length loc) 0)
                loc
              "")))

    Also, to set this after org-mode has loaded ([see here](https://emacs.stackexchange.com/questions/19091/how-to-set-org-agenda-prefix-format-before-org-agenda-starts)):

        (with-eval-after-load 'org-agenda
          (add-to-list 'org-agenda-prefix-format
                       '(agenda . "  %-12:c%?-12t %(paf/org-agenda-get-location)% s"))


<a id="orga407701"></a>

### org-clock properties

clock stuff into a drawer.

    (setq org-clock-into-drawer t)
    (setq org-log-into-drawer t)
    (setq org-clock-int-drawer "CLOCK")


<a id="orga1c02a0"></a>

## LAST step: reload org

Ran into a [strange error](https://github.com/seagle0128/.emacs.d/issues/129), and reloading org at the end is the
solution:

    (org-mode-restart)


<a id="org0ff08f6"></a>

# buffers

There are three concepts seem to me: desktop, window config, and buffers.

-   desktop: is like virtual desktop, and you can have many, like i3.
-   window config: think of it like a look you have created using
    buffers, eg. stack them this way or that way, on the same
    desktop. So switching a window config will switch the buffer layout
    within your current desktop.
-   buffer: is the building block.


<a id="orgf2594e0"></a>

## by packages


<a id="orge091e88"></a>

### multi desktops: eyebrowse

Awesome window manager. It's like using i3m but inside emacs. Use the
`C-c C-w <0..9>` key to switch to so called desktop. On each desktop,
you can have different buffers open and so on, so I don't have to
close buffers, or `C-x b` a lot anymore. Look for details [here](https://depp.brause.cc/eyebrowse/).

      (use-package eyebrowse
        :ensure t)
    (eyebrowse-mode t)


<a id="orga26c9a3"></a>

### select buffer

    (use-package ace-window
      :ensure
      :config
      (setq aw-ignore-current t)
      (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
      (setq aw-background nil)
      (global-set-key (kbd "M-o") 'ace-window)
      (custom-set-faces
       '(aw-leading-char-face
         ((t (:inherit ace-jump-face-foreground
                       :background "GhostWhite"
                       :box nil)))))
    )


<a id="orgf8783d5"></a>

### buffer naming

    (use-package uniquify
      :init
      (setq uniquify-buffer-name-style 'post-forward-angle-brackets))


<a id="orga7dd8b4"></a>

## save & restore buffers

First, you need to create a folder `~/.emacs.d/savehist`. If not, upon
existing emacs, it will complain, asking you whether you want to
`ignore` it, answer `yes` will be fine. No harm. It's just the session
will not then be saved.


    (setq desktop-path (list "~/.emacs.d/savehist"))
    (setq desktop-dirname "~/.emacs.d/savehist")
    (setq desktop-restore-eager 5)
    (setq desktop-load-locked-desktop t)
    (desktop-save-mode 1)

      (setq history-length t)
    (setq history-delete-duplicates t)
    (setq savehist-save-minibuffer-history 1)
    (setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

But skip the followings:

    (setq desktop-buffers-not-to-save
         (concat "\\("
                 "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
                 "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
                 "\\)$"))
    (add-to-list 'desktop-modes-not-to-save 'dired-mode)
    (add-to-list 'desktop-modes-not-to-save 'Info-mode)
    (add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
    (add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

See [here](https://github.com/thierryvolpiatto/psession):

    (use-package psession
      :ensure)
    (psession-mode 1)
    (psession-savehist-mode 1)
    (psession-autosave-mode 1)


<a id="orgb9037ba"></a>

## switch window config: winner-mode

Read [here](https://www.emacswiki.org/emacs/WinnerMode). A config is essentially a look of buffers, and there can be
many, say, a config has two windows side by side, while another is 3
stacked. This mode will let you switch between them on the same desktop.

Enables `winner-mode`. Navigate buffer-window configs with `C-c left` and
`C-c right`.

    (winner-mode 1)

However, with eyebrowse, I think this is redundant function. Maybe I should skip this?


<a id="orga6c65bc"></a>

## toggle maximize buffer

Temporarily maximize a buffer.  [found here](https://gist.github.com/mads379/3402786)

    (defun toggle-maximize-buffer () "Maximize buffer"
      (interactive)
      (if (= 1 (length (window-list)))
          (jump-to-register '_)
        (progn
          (window-configuration-to-register '_)
          (delete-other-windows))))

Map it to a key.

    (global-set-key [M-f8] 'toggle-maximize-buffer)


<a id="org05b329d"></a>

## buffer decorations

Setup the visual cues about the current editing buffer

    (column-number-mode t)
    (setq visible-bell t)
    (setq scroll-step 1)
    (setq-default transient-mark-mode t)  ;; highlight selection


<a id="org2f26edd"></a>

# editing

The heart of editor is, well, editing. Many things are determining the
experience. Here are the ones I use to make editing quicker, easier,
less typing essentially.


<a id="orgc13aa1f"></a>

## by packages


<a id="org0ff90f8"></a>

### auto company

A good auto completion thing. See details [here](https://company-mode.github.io/).

    (use-package company
      :ensure t
      :config)
    (add-hook 'prog-mode-hook 'global-company-mode)


<a id="orgd1bbb1a"></a>

### undo tree

More [undos](https://elpa.gnu.org/packages/undo-tree.html)?

    (use-package undo-tree
      :ensure t
      :config
      (setq undo-tree-visualizer-timestamps t)
      (setq undo-tree-visualizer-diff t))
    (global-undo-tree-mode)


<a id="org515357d"></a>

### search & jump

1.  ag

    Use the silversearcher.

        (use-package ag
          :ensure
          :config
          (setq ag-highlight-search t)
          (setq ag-reuse-buffers t))

    Follow the [helm-ag manual](https://github.com/emacsorphanage/helm-ag), "Insert thing at point as default search
    pattern, if this value is non nil":

        (setq helm-ag-insert-at-point 'symbol)
        (setq helm-ag-use-temp-buffer t)

2.  dumb-jump

    First, let's make sure we have `xref` because we will hook into the
    xref backend:

        (use-package xref
          :ensure
          :config)

    Now install `dumb-jump`:

        (use-package dumb-jump
          :ensure
          :config
          (setq dumb-jump-prefer-searcher 'ag))

    Some hydra:

        (defhydra dumb-jump-hydra (:color blue :columns 3)
            "Dumb Jump"
            ("j" dumb-jump-go "Go")
            ("o" dumb-jump-go-other-window "Other window")
            ("e" dumb-jump-go-prefer-external "Go external")
            ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
            ("i" dumb-jump-go-prompt "Prompt")
            ("l" dumb-jump-quick-look "Quick look")
            ("b" dumb-jump-back "Back"))

    Last, hook to `xref` to use `M.` bind:

        (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

3.  ripgrep

    This enables searching recursively in projects.

        (use-package ripgrep
          :ensure t)
        (use-package projectile-ripgrep
          :ensure t
          :requires (ripgrep projectile))


<a id="org257e13b"></a>

### max 80 cols wide

    (use-package column-enforce-mode
      :ensure t
      :config
      (setq column-enforce-column 80)
      :bind ("C-c m" . 'column-enforce-mode))
    ;; column-enforce-face


<a id="orgb473146"></a>

### highlight whitespace & lines > 80 long

Highlight unnecessary chars and lines over 80.

    (use-package whitespace
      :ensure
      :config (setq whitespace-style '(face empty tabs lines-tail trailing))
      :config (global-whitespace-mode t))


<a id="org344928f"></a>

### browse kill ring

Don't use `popup-kill-ring` as it's dead. Use the [browse-kill-ring](https://github.com/browse-kill-ring/browse-kill-ring):

    (use-package browse-kill-ring
      :ensure
      :config
      (setq browse-kill-ring-highlight-current-entry t)
      (setq browse-kill-ring-highlight-inserted-item t))

    (browse-kill-ring-default-keybindings)


<a id="org3974253"></a>

### parenthesis

Borrowing from old init.el:

    (show-paren-mode t)
    (set-face-attribute 'region nil
                        :background "#666"
                        :foreground "#d52349")
    (set-face-background 'show-paren-match (face-background 'default))
    (set-face-foreground 'show-paren-match "#d52349")
    (set-face-attribute 'show-paren-match nil
                        :weight 'extra-bold)

1.  show matching delimiters (default: on)

    Use [rainbow-delimiter](https://github.com/Fanael/rainbow-delimiters). Do not set the
    `rainbow-delimiters-mismatched-face` because it will raise alarm all all
    the following brackets when there is a mismatch, like a xmas lights,
    and it's distracting to find out the actual mismatch!

        (use-package rainbow-delimiters
          :ensure
          :config
          (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                              :background "GhostWhite"))
        (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

2.  type using smartparens (default: on)

    Well, who wants to type parenthesis.

        (use-package smartparens
          :ensure
          :config
          (require 'smartparens-config))
        (add-hook 'prog-mode-hook #'smartparens-mode)


<a id="org9a292d2"></a>

### string inflection (default: some modes)

This is useful in coding to change a string to snake, camel and so on.

    (use-package string-inflection
      :ensure
      :config)
    (add-hook 'elpy-mode-hook
                '(lambda ()
                   (local-set-key (kbd "C-q C-u")
                                  'string-inflection-python-style-cycle)))
    (add-hook 'org-mode-hook
                '(lambda ()
                   (local-set-key (kbd "C-q C-u")
                                  'string-inflection-python-style-cycle)))
    (add-hook 'mu4e-compose-mode-hook
                '(lambda ()
                   (local-set-key (kbd "C-q C-u")
                                  'string-inflection-python-style-cycle)))
    (add-hook 'js2-mode-hook
                '(lambda ()
                   (local-set-key (kbd "C-q C-u")
                                  'string-inflection-python-style-cycle)))


<a id="org7436bf8"></a>

### annotate-mode (default: some modes)

The file-annotations are store externally. Seems to fail with
`args-out-of-range` and then Emacs is confused. (filed issue for this)

Also, it seems to interfere with colorful modes like `magit` or
`org-agenda-mode` so that I went with a whitelist instead of the wish of
a blacklist of modes.

Read more [here](https://github.com/bastibe/annotate.el).

    (use-package annotate
      :ensure t

      ;; for ledger-mode, as 'C-c C-a' is taken there.
      :bind ("C-c C-A" . 'annotate-annotate)

      :config
      (add-hook 'org-mode 'annotate-mode)
      (add-hook 'csv-mode 'annotate-mode)
      (add-hook 'c-mode 'annotate-mode)
      (add-hook 'c++-mode 'annotate-mode)
      (add-hook 'sh-mode 'annotate-mode)
    ;;;  (define-globalized-minor-mode global-annotate-mode annotate-mode
    ;;;    (lambda () (annotate-mode 1)))
    ;;;  (global-annotate-mode 1)
      )


<a id="orgc99414a"></a>

### writeroom-mode (default: off)

It seems to be a particular way of changing the buffer look so the
writer can focus on, writing. Read [more here](https://github.com/joostkremers/writeroom-mode).

    (use-package writeroom-mode
      :ensure t
      :config)


<a id="org1344b8e"></a>

### anzu

Show number of search matches.

    (use-package
      anzu

      :ensure
      :config)
    (global-anzu-mode +1)


<a id="org95189c4"></a>

### move-text

Looks convenient [here](https://github.com/emacsfodder/move-text):

-   `Meta-up` move-text-up (line or active region)
-   `Meta-down` move-text-down (line or active region)

      (use-package move-text
        :ensure
        :config)
    (move-text-default-bindings)

t\*\* tabs to 2

These are global tab settings. Since TAB is such a sensitive thing,
each coding mode may have a different style/preference that will
override this.

    (setq-default indent-tabs-mode nil)
    (setq require-final-newline t)
    (setq indent-line-function 'insert-tab)
    (setq-default tab-width 2)


<a id="org440f798"></a>

## no trailing spaces

    (setq next-line-add-newlines nil)
    (add-hook 'before-save-hook 'delete-trailing-whitespace)


<a id="org9a85410"></a>

## iedit mode

Instead of using the string replacement, use this edit mode will
highlight all the occurances in the buffer, and now your editing will
take effect on all of them.

    (global-set-key (kbd "C-M-i") 'iedit-mode)


<a id="org47b975d"></a>

# navigate file & dir

I'm not quite used to using emacs as file manager yet. To me, it's
much easier to just start a shell and type.

Nonetheless, navigating code tree is necessary, and the one like CP is
so deeply buried that having a good navigator is probably a good
thing.

The most dramatic thing is [treemacs](#treemacs), which I need some time to get
used to. It looks nice, but feels a bit, exaggerated to my taste.


<a id="orgd2f098f"></a>

## dir hack

    (use-package dash
      :ensure
      :config)

    (use-package dired-hacks-utils
      :ensure
      :config)


<a id="orgf4ab030"></a>

## dired-rainbow

Make the dired coloful. Copied from [dired-hacks](https://github.com/Fuco1/dired-hacks).

    (use-package dired-rainbow
      :ensure
      :config
      (progn
        (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
        (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
        (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
        (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
        (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
        (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
        (dired-rainbow-define media "#de751f" ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
        (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
        (dired-rainbow-define log "#c17d11" ("log"))
        (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
        (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
        (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
        (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
        (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
        (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
        (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
        (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
        (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
        (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
        (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")
        ))


<a id="org60571b8"></a>

## dired-narrow

    (use-package dired-narrow
      :ensure
      :config)


<a id="orgaf412a4"></a>

## dired-collapse

    (use-package dired-collapse
      :ensure
      :config)


<a id="org89bf026"></a>

## dired-filter

    (use-package dired-filter
      :ensure
      :config)


<a id="treemacs"></a>

## treemacs (default: off)

Copied from [here](https://github.com/Alexander-Miller/treemacs#installation). I'm leaving this mode off by default. `C-c t t` to
enable it.

    (use-package treemacs
      :ensure t
      :defer t
      :init
      (with-eval-after-load 'winum
        (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
      :config
      (progn
        (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
              treemacs-deferred-git-apply-delay      0.5
              treemacs-directory-name-transformer    #'identity
              treemacs-display-in-side-window        t
              treemacs-eldoc-display                 t
              treemacs-file-event-delay              5000
              treemacs-file-extension-regex          treemacs-last-period-regex-value
              treemacs-file-follow-delay             0.2
              treemacs-file-name-transformer         #'identity
              treemacs-follow-after-init             t
              treemacs-git-command-pipe              ""
              treemacs-goto-tag-strategy             'refetch-index
              treemacs-indentation                   2
              treemacs-indentation-string            " "
              treemacs-is-never-other-window         nil
              treemacs-max-git-entries               5000
              treemacs-missing-project-action        'ask
              treemacs-move-forward-on-expand        nil
              treemacs-no-png-images                 nil
              treemacs-no-delete-other-windows       t
              treemacs-project-follow-cleanup        nil
              treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
              treemacs-position                      'left
              treemacs-recenter-distance             0.1
              treemacs-recenter-after-file-follow    nil
              treemacs-recenter-after-tag-follow     nil
              treemacs-recenter-after-project-jump   'always
              treemacs-recenter-after-project-expand 'on-distance
              treemacs-show-cursor                   nil
              treemacs-show-hidden-files             t
              treemacs-silent-filewatch              nil
              treemacs-silent-refresh                nil
              treemacs-sorting                       'alphabetic-asc
              treemacs-space-between-root-nodes      t
              treemacs-tag-follow-cleanup            t
              treemacs-tag-follow-delay              1.5
              treemacs-user-mode-line-format         nil
              treemacs-user-header-line-format       nil
              treemacs-width                         35
              treemacs-workspace-switch-cleanup      nil)

        ;; The default width and height of the icons is 22 pixels. If you are
        ;; using a Hi-DPI display, uncomment this to double the icon size.
        ;;(treemacs-resize-icons 44)

        (treemacs-follow-mode t)
        (treemacs-filewatch-mode t)
        (treemacs-fringe-indicator-mode t)
        (pcase (cons (not (null (executable-find "git")))
                     (not (null treemacs-python-executable)))
          (`(t . t)
           (treemacs-git-mode 'deferred))
          (`(t . _)
           (treemacs-git-mode 'simple))))
      :bind
      (:map global-map
            ("M-0"       . treemacs-select-window)
            ("C-x t 1"   . treemacs-delete-other-windows)
              ("C-x t t"   . treemacs)
              ("C-x t B"   . treemacs-bookmark)
              ("C-x t C-t" . treemacs-find-file)
              ("C-x t M-t" . treemacs-find-tag)))


      (use-package treemacs-icons-dired
        :after treemacs dired
        :ensure t
          :config (treemacs-icons-dired-mode))

      (use-package treemacs-projectile
        :after treemacs projectile
        :ensure t)
      (use-package treemacs-magit
        :after treemacs magit
        :ensure t)

Add some files to ignore, eg. ~.pyc\`:

    (with-eval-after-load 'treemacs
      (defun treemacs-ignore-gitignore (file _)
        (string= file ".pyc"))
      (push #'treemacs-ignore-gitignore treemacs-ignored-file-predicates))


<a id="orgab27b15"></a>

# Helm

Helm should really has its own section because it touches everything!

I just took over the config described in this [helm intro](https://tuhdo.github.io/helm-intro.html).

    (use-package helm
     :ensure t
     :delight helm-mode
     :config
      (require 'helm-config)
      ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
      ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
      ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
      (global-set-key (kbd "C-c h") 'helm-command-prefix)
      (global-unset-key (kbd "C-x c"))

      (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
      (define-key helm-map (kbd "C-M-x") 'helm-execute-persistent-action) ; make TAB work in terminal
      (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

      (when (executable-find "curl")
        (setq helm-google-suggest-use-curl-p t))

      (setq helm-split-window-inside-p            t ; open helm buffer inside current window, not occupy whole other window
            helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
            helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
            helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
            helm-ff-file-name-history-use-recentf t
            helm-echo-input-in-header-line t)

      (setq helm-autoresize-max-height 50)
      (setq helm-autoresize-min-height 0)
      (helm-autoresize-mode 1)

      (setq helm-M-x-fuzzy-match t)
      (setq helm-buffers-fuzzy-matching t
            helm-recentf-fuzzy-match    t)
      (setq helm-semantic-fuzzy-match t
            helm-imenu-fuzzy-match    t)
    (setq helm-locate-fuzzy-match t)
    (setq helm-apropos-fuzzy-match t)
    (setq helm-lisp-fuzzy-completion t)
    (helm-mode 1)

      (global-set-key (kbd "M-x") 'helm-M-x))

Found [this reddit post](https://www.reddit.com/r/emacs/comments/30yer0/helm_and_recentf_tips/) of using `helm-mini`:

    (setq helm-mini-default-sources '(helm-source-buffers-list
                                      helm-source-recentf
                                      helm-source-bookmarks
                                      helm-source-buffer-not-found))


<a id="org5b5fd21"></a>

# Write chinese

I have been using this one w/ reasonable success.

    (use-package pyim
      :ensure
      :defer 10
      :config
      ;; 激活 basedict 拼音词库
      (use-package pyim-basedict
        :ensure nil
        :config (pyim-basedict-enable))

      ;; 五笔用户使用 wbdict 词库
      ;; (use-package pyim-wbdict
      ;;   :ensure nil
      ;;   :config (pyim-wbdict-gbk-enable))

      (setq default-input-method "pyim")

      ;; 我使用全拼
      (setq pyim-default-scheme 'quanpin)

      ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
      ;; 我自己使用的中英文动态切换规则是：
      ;; 1. 光标只有在注释里面时，才可以输入中文。
      ;; 2. 光标前是汉字字符时，才能输入中文。
      ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
      (setq-default pyim-english-input-switch-functions
                    '(pyim-probe-dynamic-english
                      pyim-probe-isearch-mode
                      pyim-probe-program-mode
                      pyim-probe-org-structure-template))

      (setq-default pyim-punctuation-half-width-functions
                    '(pyim-probe-punctuation-line-beginning
                      pyim-probe-punctuation-after-punctuation))

      ;; 开启拼音搜索功能
      ;; (pyim-isearch-mode 1)

      ;; 使用 pupup-el 来绘制选词框
      (setq pyim-page-tooltip 'popup)

      ;; 选词框显示5个候选词
      (setq pyim-page-length 5)

      ;; 让 Emacs 启动时自动加载 pyim 词库
      (add-hook 'emacs-startup-hook
                #'(lambda () (pyim-restart-1 t)))
      :bind
      (;与 pyim-probe-dynamic-english 配合
      ("M-j" . pyim-convert-code-at-point)

       ("C-;" . pyim-delete-word-from-personal-buffer)))
       (setq default-input-method "pyim")
       (global-set-key (kbd "C-\\") 'toggle-input-method)


<a id="orgef98b3a"></a>

# Office stuff

Using emacs in a corporate env can be daunting.


<a id="org53b6037"></a>

## mu4e email

mu4e only a emac client. The workhorse are davmail, isync and mu. You need to install these offline and hook them up using the config below.


<a id="org891e86c"></a>

### install & minimal setup

First thing first, load the package. As you can see, I have used `apt-get` install mu4e.

    (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
    (require 'mu4e)

Then we load `maildirs-extension`:

    (use-package mu4e-maildirs-extension
      :ensure
      :config)
    (mu4e-maildirs-extension)

Now, we tell emacs I want to use `mu4e` as email client:

    (setq mail-user-agent 'mu4e-user-agent)

Link to a couple modes to help me writing good emails:

    (add-hook 'mu4e-compose-mode-hook
                  (lambda ()
                    (visual-line-mode t)
                    (writegood-mode t)
                    (flyspell-mode t)))


<a id="orgbdd32c3"></a>

### how to get mails

Setup location of my maildir.

    (setq mu4e-maildir (expand-file-name "~/Maildir"))

Sync email by calling `mbsync`:

    (setq mu4e-get-mail-command "mbsync -a")

How often should I check? Value in seconds:

    (setq mu4e-update-interval 600)

Setup some common folders:

    (setq mu4e-drafts-folder "/drafts"
          mu4e-sent-folder   "/sent"
          mu4e-trash-folder  "/trash")

Setup some shortcuts as bookmarks:

    (add-to-list
     'mu4e-bookmarks
     '("flag:attach"
       "Messages with attachment"
       ?a) t)

    (add-to-list
     'mu4e-bookmarks
     '("size:5M..500M"
       "Big messages"
       ?b) t)

    (add-to-list
     'mu4e-bookmarks
     '("flag:flagged"
       "Flagged messages"
       ?f) t)


<a id="org6e40743"></a>

### list view

Customize the list view header:

    (setq mu4e-headers-date-format "%b-%d %a"
          mu4e-headers-fields '((:date . 10)
                                (:flags . 5)
                                (:recipnum . 3)
                                (:from-or-to . 10)
                                (:thread-subject . nil)))

Skip duplicates:

    (setq mu4e-headers-skip-duplicates t)

Showing related in a tree fashion so I know the context:

    (setq mu4e-headers-include-related t)

Here is a fun one. I noticed that the email thread grows like that greedy snake game, a pretty good sign that the team is malfunctioning :) So we add a displayed number on the number of recipients, and just watch it grow:

    (add-to-list 'mu4e-header-info-custom
                 '(:recipnum .
                             ( :name "Number of recipients"  ;; long name, as seen in the message-view
                                     :shortname "R#"           ;; short name, as seen in the headers view
                                     :help "Number of recipients for this message" ;; tooltip
                                     :function (lambda (msg)
                                                 (format "%d"
                                                         (+ (length (mu4e-message-field msg :to))
                                                            (length (mu4e-message-field msg :cc))))))))


<a id="org5ca88ce"></a>

### read & attachment

Save attachment to:

    (setq mu4e-attachment-dir "~/Downloads")

To open HTML in browser:

    (add-to-list 'mu4e-view-actions
                 '("ViewInBrowser" . mu4e-action-view-in-browser)
                 t)

Attempt to show images when viewing messages:

    (setq mu4e-view-show-images t)

Use imagemagick, if available:

    (when (fboundp 'imagemagick-register-types)
      (imagemagick-register-types))


<a id="orgc8c2168"></a>

### write new

My signature line:

    (setq mu4e-compose-signature
          (concat
           "Best regards,\n\n"
           "Feng Xia\n"
           "W: http://www.lenovo.com\n"))


<a id="org640c722"></a>

### send

Sending email is to use SMTP. Here I'm showing to use the company one
through `davmail` which runs smtp listen on port `1025`. You can also
use Gmail/hotmail:

    (use-package smtpmail
      :ensure t
      :config
      (setq send-mail-function 'smtpmail-send-it
            user-mail-address "fxia1@lenovo.com"
            smtpmail-debug-info t
            smtpmail-smtp-user "fxia1@lenovo.com"
            smtpmail-default-smtp-server "localhost"
            smtpmail-auth-credentials (expand-file-name "~/.authinfo")
            smtpmail-smtp-service 1025
            smtpmail-stream-type nil
            starttls-use-gnutls nil
            starttls-extra-arguments nil))

There is a toggle where you can queue the sending email first instead
of sending to server immediately. This is useful for travel when you
just write, then queue, then when reconnected to the internect, send.

    (setq smtpmail-queue-mail nil
          smtpmail-queue-dir "~/Maildir/queue/cur")


<a id="orga77aaa7"></a>

### reply

When replying an email, auto fill in my info:

    (setq mu4e-compose-reply-to-address "fxia1@lenovo.com"
          user-mail-address "fxia1@lenovo.com"
          user-full-name "Feng Xia"
          message-signature  (concat
                              "Feng Xia\n"
                              "http://snapshots.world.s3-website.ap-northeast-2.amazonaws.com/\n")
          message-citation-line-format "On %Y-%m-%d %H:%M:%S, %f wrote:"
          message-citation-line-function 'message-insert-formatted-citation-line
          mu4e-headers-results-limit 500)


<a id="orgd88d981"></a>

### kill all buffer upon exit

mu4e can open a lot of writing buffers. Just kill them all when we exit mu4e:

    (setq message-kill-buffer-on-exit t)


<a id="org2b441d1"></a>

### write html

Emacs doesn't like html email body. Nor do I. But one thing I found
out is that markdown mode table will look terrible as plain text on
receiving end. There are a couple ways to work around.

1.  write in org

    So we now write email in org mode, then call `M-x org-mime-htmlize` to
    convert either the whole buffer or a region to html before sending:

        (use-package org-mime
          :ensure
          :config
          (setq org-mime-export-ascii 'utf-8))

2.  write in markdown

    How about writing it in markdown? You don't need to do much. Switch to
    `markdown-mode` to write, then switch back to `mu4e-compose-mode` and
    then `C-c C-c` to send:

        (defun multipart-html-message (plain html)
          "Creates a multipart HTML email with a text part and an html part."
          (concat "<#multipart type=alternative>\n"
                  "<#part type=text/plain>"
                  plain
                  "<#part type=text/html>\n"
                  html
                  "<#/multipart>\n"))

        (defun convert-message-to-markdown ()
          "Convert the message in the current buffer to a multipart HTML email.

        The HTML is rendered by treating the message content as Markdown."
          (interactive)
          (unless (executable-find "pandoc")
            (error "Pandoc not found, unable to convert message"))
          (let* ((begin
                  (save-excursion
                    (goto-char (point-min))
                    (search-forward mail-header-separator)))
                 (end (point-max))
                 (html-buf (generate-new-buffer "*mail-md-output*"))
                 (exit-code
                  (call-process-region begin end "pandoc" nil html-buf nil
                                       "--quiet" "-f" "gfm" "-t" "html"))
                 (html (format "<html>\n<head></head>\n<body>\n%s\n</body></html>\n"
                        (with-current-buffer html-buf
                          (buffer-substring (point-min) (point-max)))))
                 (raw-body (buffer-substring begin end)))
            (when (not (= exit-code 0))
              (error "Markdown conversion failed, see %s" (buffer-name html-buf)))
            (with-current-buffer html-buf
              (set-buffer-modified-p nil)
              (kill-buffer))
            (undo-boundary)
            (delete-region begin end)
            (save-excursion
              (goto-char begin)
              (newline)
              (insert (multipart-html-message raw-body html)))))

        (defun message-md-send (&optional arg)
          "Convert the current buffer and send it.
        If given prefix arg ARG, skips markdown conversion."
          (interactive "P")
          (unless arg
            (convert-message-to-markdown))
          (message-send))

        (defun message-md-send-and-exit (&optional arg)
          "Convert the current buffer and send it, then exit from mail buffer.
        If given prefix arg ARG, skips markdown conversion."
          (interactive "P")
          (unless arg
            (convert-message-to-markdown))
          (message-send-and-exit))

        (with-eval-after-load 'message
         (define-key message-mode-map (kbd "C-c C-s") #'message-md-send)
         (define-key message-mode-map (kbd "C-c C-c") #'message-md-send-and-exit))


<a id="org9331925"></a>

# Hobbies


<a id="org317526a"></a>

## elfeed

Read news:

    (use-package elfeed
      :ensure
      :config)
    (setq elfeed-feeds
          '(("http://rss.slashdot.org/Slashdot/slashdotMain" dev)
            ("https://fengxia41103.github.io/myblog/feeds/all.atom.xml" me)))


<a id="org8ebf227"></a>

## taskjuggler

    (use-package tj3-mode
      :ensure t
      :after org-plus-contrib
      :config
      (require 'ox-taskjuggler)
      (custom-set-variables
       '(org-taskjuggler-process-command "/usr/local/bin/tj3 --silent --no-color --output-dir %o %f")
       '(org-taskjuggler-project-tag "PRJ")))


<a id="org7986672"></a>

# Coding

Big part of my life is taken by coding. So here it is, all the coding
related stuff.


<a id="org11dee66"></a>

## taskjuggler-mode (tj3-mode)

    (use-package tj3-mode
      :ensure t
      :after org-plus-contrib
      :config
      (require 'ox-taskjuggler)
      (custom-set-variables
       '(org-taskjuggler-process-command "/usr/local/bin/tj3 --silent --no-color --output-dir %o %f")
       '(org-taskjuggler-project-tag "PRJ")))


<a id="orgedc3e6c"></a>

## Version control


<a id="org1406540"></a>

### magit

Add the powerful Magit

    (use-package magit
      :ensure t
      :defer
      :config
      (add-hook 'after-save-hook 'magit-after-save-refresh-status t)
      :bind ("C-x g" . 'magit-status))
    (use-package magit-todos
      :ensure t
      :defer)
    (use-package
      magit-gitflow

      :ensure
      :config (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))


<a id="orgb9042f8"></a>

### monky

Add the Magit-copy for Mercurial 'monky'

    (use-package monky
      :ensure t
      :defer
      :bind ("C-x m" . 'monky-status))


<a id="org10f6131"></a>

### git informations in gutter

    (use-package git-gutter-fringe+
      :ensure t
      :defer
      :if window-system
      :bind ("C-c g" . 'git-gutter+-mode))


<a id="orga8c123a"></a>

### speedup VCS

Regexp matching directory names that are not under VC's control. The
default regexp prevents fruitless and time-consuming attempts to
determine the VC status in directories in which filenames are
interpreted as hostnames.

    (defvar locate-dominating-stop-dir-regexp
      "\\`\\(?:[\\/][\\/][^\\/]+\\|/\\(?:net\\|afs\\|\\.\\.\\.\\)/\\)\\'")


<a id="orgb6debf4"></a>

### global caller

Have a single binding to call the most appropriate tool given the repository.

    (defun paf/vcs-status ()
         (interactive)
         (condition-case nil
             (magit-status-setup-buffer)
           (error (monky-status))))

    (global-set-key (kbd "C-M-x v") 'paf/vcs-status)


<a id="orgd1c79fa"></a>

## Projectile

Start using projectile. It has the documentation [here](https://docs.projectile.mx/en/latest/).

    (use-package projectile
      :ensure t
      :config
      (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
      (setq projectile-completion-system 'helm)
      (projectile-mode +1))

    (use-package helm-projectile
      :ensure t
      :after projectile
      :requires projectile
      :delight projectile-mode
      :config
      (helm-projectile-on))

Search the entire project with `C-c p s s` for a regexp. This let's
you turn the matching results into an editable buffer using `C-c
C-e`. Other keys are listed [here](https://github.com/syohex/emacs-helm-ag#keymap).

    (use-package helm-ag
      :ensure t
      :config)

I havae used it by a `M-?` binding. It's just old habit:

    (global-set-key (kbd "M-?") 'helm-ag)


<a id="org8c2b332"></a>

## debug w/ GDB


<a id="org5a50b6c"></a>

### TODO Make it so that the source frame placement is forced only when using gdb.

    (setq gdb-many-windows t)
    (setq gdb-use-separate-io-buffer t)

    (defun easy-gdb-top-of-stack-and-restore-windows ()
      (interactive)
      (switch-to-buffer (gdb-stack-buffer-name))
      (goto-char (point-min))
      (gdb-select-frame)
      (gdb-restore-windows)
      (other-window 2))

    (global-set-key (kbd "C-x C-a C-t") 'easy-gdb-top-of-stack-and-restore-windows)

This should display the source code always in the same window when debugging.
Found on [Stack Overflow](https://stackoverflow.com/questions/39762833/emacsgdb-customization-how-to-display-source-buffer-in-one-window).

    ; This unfortunately also messes up the regular frame navigation of source code.
    ;(add-to-list 'display-buffer-alist
    ;             (cons 'cdb-source-code-buffer-p
    ;                   (cons 'display-source-code-buffer nil)))

    (defun cdb-source-code-buffer-p (bufName action)
      "Return whether BUFNAME is a source code buffer."
      (let ((buf (get-buffer bufName)))
        (and buf
             (with-current-buffer buf
               (derived-mode-p buf 'c++-mode 'c-mode 'csharp-mode 'nxml-mode)))))

    (defun display-source-code-buffer (sourceBuf alist)
      "Find a window with source code and set sourceBuf inside it."
      (let* ((curbuf (current-buffer))
             (wincurbuf (get-buffer-window curbuf))
             (win (if (and wincurbuf
                           (derived-mode-p sourceBuf 'c++-mode 'c-mode 'nxml-mode)
                           (derived-mode-p (current-buffer) 'c++-mode 'c-mode 'nxml-mode))
                      wincurbuf
                    (get-window-with-predicate
                     (lambda (window)
                       (let ((bufName (buffer-name (window-buffer window))))
                         (or (cdb-source-code-buffer-p bufName nil)
                             (assoc bufName display-buffer-alist)
                             ))))))) ;; derived-mode-p doesn't work inside this, don't know why...
        (set-window-buffer win sourceBuf)
        win))

Here is my cheatsheet for the keyboard commands:

All prefixed with `C-x C-a`

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-center" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Domain</th>
<th scope="col" class="org-left">Command</th>
<th scope="col" class="org-center">C-<key></th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">Breakpoint</td>
<td class="org-left">set</td>
<td class="org-center">b</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">temporary</td>
<td class="org-center">t</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">delete</td>
<td class="org-center">d</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">Execute</td>
<td class="org-left">Next</td>
<td class="org-center">n</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">Step Into</td>
<td class="org-center">s</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">Return / Finish</td>
<td class="org-center">f</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">Continue (run)</td>
<td class="org-center">r</td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">Stack</td>
<td class="org-left">Up</td>
<td class="org-center"><</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">Down</td>
<td class="org-center">></td>
</tr>
</tbody>

<tbody>
<tr>
<td class="org-left">Execute</td>
<td class="org-left">Until current line</td>
<td class="org-center">u</td>
</tr>


<tr>
<td class="org-left">(rarer)</td>
<td class="org-left">Single instruction</td>
<td class="org-center">i</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">Jump to current line</td>
<td class="org-center">j</td>
</tr>
</tbody>
</table>


<a id="org783d42f"></a>

## editing


<a id="org17b09fd"></a>

### diffing

[
vdiff](https://github.com/justbur/emacs-vdiff) let's one compare buffers or files.

    (use-package vdiff
      :ensure t
      :config
      ; This binds commands under the prefix when vdiff is active.
      (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map))


<a id="org2cb9c13"></a>

### yasnippet

Let's first see how far I get with file-based capture templates and yankpad.

      (use-package yasnippet
        :ensure t)
      (use-package auto-yasnippet
        :ensure t
    :after yasnippet
        :config
        (bind-key "C-M-x C-s c" 'aya-create)
        (bind-key "C-M-x C-s e" 'aya-expand))


<a id="org88f0120"></a>

### commenting out

Easy commenting out of lines.

    (autoload 'comment-out-region "comment" nil t)
    (global-set-key (kbd "C-c q") 'comment-out-region)


<a id="org7d3f631"></a>

### deduplicate and sort

Help cleanup the includes and using lists.
[found here](http://www.emacswiki.org/emacs/DuplicateLines)

    (defun uniquify-region-lines (beg end)
      "Remove duplicate adjacent lines in region."
      (interactive "*r")
      (save-excursion
        (goto-char beg)
        (while (re-search-forward "^\\(.*\n\\)\\1+" end t)
          (replace-match "\\1"))))

    (defun paf/sort-and-uniquify-region ()
      "Remove duplicates and sort lines in region."
      (interactive)
      (sort-lines nil (region-beginning) (region-end))
      (uniquify-region-lines (region-beginning) (region-end)))

Simplify cleanup of `#include` / `typedef` / `using` blocks.

    (global-set-key (kbd "C-M-x s") 'paf/sort-and-uniquify-region)


<a id="org8718ff7"></a>

### selective display (default: off)

Will fold all text indented more than the position of the cursor at
the time the keys are pressed.

    (defun set-selective-display-dlw (&optional level)
      "Fold text indented more than the cursor.
       If level is set, set the indent level to level.
       0 displays the entire buffer."
      (interactive "P")
      (set-selective-display (or level (current-column))))

    (global-set-key "\C-x$" 'set-selective-display-dlw)


<a id="orgf9e555d"></a>

## IRC

Use `circe`.

    (use-package
      circe
        :ensure
        :config(
                setq circe-network-options '((
                                              "Freenode" :tls t
                                              :nick "fengxia41103"
                                              :channels ("#emacs"
                                                         "#python"
                                                         "#odoo"
                                                         "#reactjs"
                                                         "#latex")))))
    (use-package
      helm-circe

      :ensure
      :config)


<a id="org2741bdd"></a>

## languages

These are minor modes to handle programming language specifics which
are often termed as development rules agreed by the team.


<a id="org2dbb895"></a>

### markdown

Enough to handle my Markdown needs.

    (use-package writegood-mode
      :ensure
      :config)

    (use-package
      markdown-mode

      :ensure
      :config
      (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)
      (add-hook 'markdown-mode-hook
                (lambda ()
                  (visual-line-mode t)
                  (writegood-mode t)
                  (flyspell-mode t)))))


<a id="org64b1c6b"></a>

### C/C++

1.  header/implementation toggle

    Switch from header to implementation file quickly.

        (add-hook 'c-mode-common-hook
                  (lambda ()
                    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

2.  no indentation of namespaces in C++

    Essentially, use the Google C++ style formatting.

        (use-package google-c-style
          :ensure t
          :config
          (add-hook 'c-mode-common-hook 'google-set-c-style)
          (add-hook 'c-mode-common-hook 'google-make-newline-indent))

        (use-package flymake-google-cpplint
          :ensure t)


<a id="orge87d7fc"></a>

### python

Setup an IDE:

    (use-package elpy
      :ensure
      :init
      (elpy-enable))

ELPY has its own indentation mode, which is overriding the one I use
globally, so disable this one:

    (add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

1.  py-autopep8

    Add hook to reformat python code based on pep8 spec. You need to
    install `pip install autopep8` offline.

        (use-package
          py-autopep8

          :ensure t
          :config
          (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
          (setq py-autopep8-options '("--max-line-length=80")))

2.  py-isort

    Sort python import. Need to install `pip install isort` offline.

        (use-package
          py-isort

          :ensure
          :config
          (add-hook 'before-save-hook 'py-isort-before-save)
          (setq py-isort-options '("-sl")))

3.  imenu-list

        (use-package imenu-list
        :ensure)

4.  smartparens

        (add-hook 'python-mode-hook #'smartparens-mode)


<a id="org305e5f6"></a>

### web-mode

web-mode with config for Polymer editing

    (use-package web-mode
      :ensure t
      :config
      (setq web-mode-enable-current-element-highlight t)
      (setq web-mode-enable-current-column-highlight t)
      (setq web-mode-enable-css-colorization t))

Who should use this mode:

    (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.ftl\\'" . web-mode))


<a id="orgf41697a"></a>

### web-beautify

This is actually depending on `js-beautify`. See [web-beautify](https://github.com/yasuyk/web-beautify) for
details.

    (use-package web-beautify
      :ensure
      :config)
    (add-hook 'js2-mode-hook
              (lambda ()
                (add-hook 'before-save-hook 'web-beautify-js-buffer t t)))
    (add-hook 'json-mode-hook
              (lambda ()
                (add-hook 'before-save-hook 'web-beautify-js-buffer t t)))
    (add-hook 'web-mode-hook
              (lambda ()
                (add-hook 'before-save-hook 'web-beautify-html-buffer t t)))
    (add-hook 'css-mode-hook
              (lambda ()
                (add-hook 'before-save-hook 'web-beautify-css-buffer t t)))
    (add-hook 'html-mode-hook
              (lambda ()
                (add-hook 'before-save-hook 'web-beautify-html-buffer t t)))


<a id="orgf74c73b"></a>

### [emmet-mode](https://github.com/smihica/emmet-mode)

Useful abbreviations when coding in HTML. See [zencoding](https://github.com/rooney/zencoding) for details.

    (use-package emmet-mode
      :ensure t
      :after(web-mode css-mode scss-mode)
      :config)
    (setq emmet-expand-jsx-className? t)
    (setq emmet-move-cursor-between-quotes t)
    (add-hook 'emmet-mode-hook (lambda () (setq emmet-indent-after-insert nil)))
    (add-hook 'sgml-mode-hook 'emmet-mode)
    (add-hook 'web-mode-hook 'emmet-mode)
    (add-hook 'css-mode-hook  'emmet-mode)
    (add-hook 'scss-mode-hook  'emmet-mode)


<a id="org354c97a"></a>

### javascript family: .js .ts .jsx

There are a couple packages for .js files.

1.  js2-mode

    First, use `js2-mode` to handle `.js` and `.jsx` files.

        (use-package js2-mode
            :ensure
            :config)

        (add-to-list 'auto-mode-alist '("\\.js[x]\\'" . js2-mode))
        (add-to-list 'auto-mode-alist '("\\.ts\\'" . js2-mode))
        (add-hook 'js2-mode-hook #'smartparens-mode)

2.  prettier-js

    Link js2-mode to prettier to beautify my code.

        (use-package prettier-js
          :ensure
          :config
          (setq prettier-js-args '(
                                   "--trailing-comma" "es5"
                                   "--single-quote" "false"
                                   "--print-width" "80"
                                   "--tab-width" "2"
                                   )));
        (add-hook 'js2-mode-hook 'prettier-js-mode)
        (add-hook 'json-mode-hook 'prettier-js-mode)
        (add-hook 'js-mode-hook 'prettier-js-mode)

3.  js-doc

    Nothing is complete without a doc solution.

        (use-package js-doc
          :ensure
          :config
          (setq js-doc-mail-address "fxia1@lenovo.com")
          (setq js-doc-author (format "Feng Xia <%s>" js-doc-mail-address))
          (setq js-doc-url "http://www.lenovo.com")
          (setq js-doc-license "Company License")
        )
        (add-hook 'js2-mode-hook
                  #'(lambda ()
                      (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
                      (define-key js2-mode-map "@" 'js-doc-insert-tag)))


<a id="org960a39d"></a>

### csv

mode to edit CSV files.

    (use-package csv-mode
      :ensure t
      :mode "\\.csv\\'")


<a id="orgf8bbb82"></a>

### json

This should be installed before the javascript stuff because I'll be
using the `prettier` as beautifier.

    (use-package json-mode
      :ensure
      :config)


<a id="org666d653"></a>

### yaml

Details are [here](https://github.com/yoshiki/yaml-mode).

    (use-package yaml-mode
      :ensure
      :config)
    (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
    (add-hook 'yaml-mode-hook
              '(lambda ()
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


<a id="orgae52d46"></a>

## LAST: enforce my tab style

Found this [here](https://github.com/syl20bnr/spacemacs/issues/5923), and I like it, to set my styles in a central
location. This was researched while battling the .js tab level. I
don't want to use the `customize` way since that will be a hidden
manual step after a fresh install.

First, define a func to include my indent settings. It takes an input
argument:

    (defun my-setup-indent (n)
      ;; java/c/c++
      (setq-local standard-indent n)
      (setq-local c-basic-offset n)

      ;; javascript family
      (setq-local javascript-indent-level n) ; javascript-mode
      (setq-local js-indent-level n) ; js-mode
      (setq-local js2-basic-offset n) ; js2-mode
      (setq-local js-switch-indent-offset n) ; js-mode
      (setq-local javascript-indent-level n) ; javacript-mode
      (setq-local react-indent-level n) ; react-mode
      (setq-local js2-basic-offset n)

      ;; html, css
      (setq-local web-mode-attr-indent-offset n) ; web-mode
      (setq-local web-mode-code-indent-offset n) ; web-mode, js code in html file
      (setq-local web-mode-css-indent-offset n) ; web-mode, css in html file
      (setq-local web-mode-markup-indent-offset n) ; web-mode, html tag in html file
      (setq-local web-mode-sql-indent-offset n) ; web-mode
      (setq-local web-mode-attr-value-indent-offset n) ; web-mode
      (setq web-mode-comment-style 2) ;; web-mode
      (setq-local css-indent-offset n) ; css-mode

      ;; shells
      (setq-local sh-basic-offset n) ; shell scripts
      (setq-local sh-indentation n))

Now set the tabs:

    (defun my-personal-code-style ()
      (interactive)
      (message "My personal code style!")
      ;; use space instead of tab
      (setq indent-tabs-mode nil)
      ;; indent 2 spaces width
      (my-setup-indent 2))

    ;; it would be lovely if this was enough, but it gets stomped on by modes.
    (my-personal-code-style)

So, to enfore this on some modes:

    (add-hook 'css-mode-hook 'my-personal-code-style)
    (add-hook 'js2-mode-hook 'my-personal-code-style)
    (add-hook 'react-mode-hook 'my-personal-code-style)
    (add-hook 'sh-mode-hook 'my-personal-code-style)


<a id="orgd8941cc"></a>

# My doc writing

Writing doc is painful, not because I don't like writing, but because
I hate WORD. So I have been trying all kinds of things to generate PDF
and have people accept my PDF. I used to write simply in LaTex,
plain. Then of course there is the big-org which can be converted. But
since I have been writing a lot of Markdown for my blogs, I don't feel
like converting all my writings into \`.org\` just fo the sake of org
mode. So instead, I have had success in writing the Pandoc version of
Markdown for my two Lenovo reference architecture papers, and I think
it gives me more control of the LaTex template, the CSS file I can
customize, and so on. So I'll stick to it for now.


<a id="org37eee9d"></a>

## pandoc

    (use-package pandoc-mode
      :ensure)
    (add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)
