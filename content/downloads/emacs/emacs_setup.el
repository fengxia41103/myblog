;; ===== this file was auto-tangled, only edit the emacs_setup.org =====

(require 'package)
(when (< emacs-major-version 27)
  (package-initialize))

(setq package-archives '(("org" . "https://orgmode.org/elpa/")
                         ("stable-melpa" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ; ("marmalade" . "https://marmalade-repo.org/packages/")
                        ))

;; make sure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(eval-when-compile (require 'use-package))

(defun tangle-init ()
  "If the current buffer is 'init.org' the code-blocks are
tangled, and the tangled file is compiled."
  (when (equal (buffer-file-name)
               (expand-file-name "~/Emacs/emacs_setup.org"))
    ;; Avoid running hooks when tangling.
    (let ((prog-mode-hook nil))
      (org-babel-tangle)
      (byte-compile-file "~/Emacs/emacs_setup.el"))))

(add-hook 'after-save-hook 'tangle-init)

(global-set-key (kbd "C-M-x") nil)

(defmacro add-hook-run-once (hook function &optional append local)
  "Like add-hook, but remove the hook after it is called"
  (let ((sym (make-symbol "#once")))
    `(progn
       (defun ,sym ()
         (remove-hook ,hook ',sym ,local)
         (funcall ,function))
       (add-hook ,hook ',sym ,append ,local))))

(setq browse-url-generic-program (executable-find "google-chrome")
  browse-url-browser-function 'browse-url-generic)

(use-package unicode-escape
  :ensure t
  :init
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))
(set-language-environment "UTF-8")

(defun no-junk-please-we-are-unixish ()
  (let ((coding-str (symbol-name buffer-file-coding-system)))
    (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
      (set-buffer-file-coding-system 'unix))))

(add-hook 'find-file-hook 'no-junk-please-we-are-unixish)

(setq desktop-path (list "~/.emacs.d/savehist"))
(setq desktop-dirname "~/.emacs.d/savehist")
(setq desktop-restore-eager 5)
(setq desktop-load-locked-desktop t)
(desktop-save-mode 1)

(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

(setq desktop-buffers-not-to-save
     (concat "\\("
             "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
             "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
             "\\)$"))
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

(global-auto-revert-mode 1)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package
  exec-path-from-shell
  :ensure
  :config
  (exec-path-from-shell-initialize))

(global-display-line-numbers-mode)

(winner-mode 1)

(use-package eyebrowse
    :ensure t)
(eyebrowse-mode t)

(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))

(global-set-key [M-f8] 'toggle-maximize-buffer)

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

(use-package dash
  :ensure
  :config)

(use-package dired-hacks-utils
  :ensure
  :config)

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

(use-package dired-narrow
  :ensure
  :config)

(use-package dired-collapse
  :ensure
  :config)

(use-package dired-filter
  :ensure
  :config)

(use-package sublime-themes
    :ensure
    :config)
(add-hook 'after-init-hook (lambda () (load-theme 'spolsky t)))

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)

(setq ring-bell-function
      '(lambda ()
         (message "The answer is 42...")))
(setq echo-keystrokes 0.1 use-dialog-box nil visible-bell t)

(global-font-lock-mode t)

(when (display-graphic-p)
  (set-background-color "#ffffff")
  (set-foreground-color "#141312"))

(setq frame-title-format "emacs @ %b - %f")
(when window-system
  (mouse-wheel-mode)  ;; enable wheelmouse support by default
  (set-selection-coding-system 'compound-text-with-extensions))

(use-package uniquify
  :init
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

(column-number-mode t)
(setq visible-bell t)
(setq scroll-step 1)
(setq-default transient-mark-mode t)  ;; highlight selection

(use-package nyan-mode
  :ensure t
  :bind ("C-M-x n" . 'nyan-mode))

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

;; faces for general region highlighting zenburn is too low-key.
(custom-set-faces
 '(highlight ((t (:background "forest green"))))
 '(region ((t (:background "forest green")))))

(use-package delight
  :ensure t)

(use-package eldoc
  :delight)

(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-j") 'newline)
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

(global-set-key [f3] 'start-kbd-macro)
(global-set-key [f4] 'end-kbd-macro)
(global-set-key [f5] 'call-last-kbd-macro)

(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

(global-set-key (kbd "C-M-i") 'iedit-mode)

(global-set-key (kbd "C-c <C-left>")  'windmove-left)
(global-set-key (kbd "C-c <C-right>") 'windmove-right)
(global-set-key (kbd "C-c <C-up>")    'windmove-up)
(global-set-key (kbd "C-c <C-down>")  'windmove-down)
(global-set-key (kbd "C-c C-g") 'goto-line)

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . 'mc/edit-lines)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)
         ("C-c C->" . 'mc/mark-all-like-this)))

(use-package hydra
  :ensure t)

(use-package dimmer
:ensure
:config
 (dimmer-configure-which-key)
 (dimmer-configure-helm))
 (dimmer-mode t)

(use-package highlight-indent-guides
:ensure
:config
(setq highlight-indent-guides-method 'character))
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

(use-package ace-jump-mode
  :ensure t
  :bind (("C-c C-SPC" . 'ace-jump-mode)
         ("C-c C-DEL" . 'ace-jump-mode-pop-mark)))

(setq-default indent-tabs-mode nil)
(setq require-final-newline t)
(setq next-line-add-newlines nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package column-enforce-mode
  :ensure t
  :config
  (setq column-enforce-column 80)
  :bind ("C-c m" . 'column-enforce-mode))
;; column-enforce-face

(use-package browse-kill-ring
:ensure
:config
(setq browse-kill-ring-highlight-current-entry t)
(setq browse-kill-ring-highlight-inserted-item t))

(browse-kill-ring-default-keybindings)

(show-paren-mode t)
(set-face-attribute 'region nil
                    :background "#666"
                    :foreground "#d52349")
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#d52349")
(set-face-attribute 'show-paren-match nil
                    :weight 'extra-bold)

(use-package rainbow-delimiters
  :ensure
  :config
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :background "GhostWhite"))
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(use-package smartparens
  :ensure
  :config
  (require 'smartparens-config))
(add-hook 'prog-mode-hook #'smartparens-mode)

(use-package annotate
  :ensure t
  :bind ("C-c C-A" . 'annotate-annotate)  ;; for ledger-mode, as 'C-c C-a' is taken there.
  :config
  (add-hook 'org-mode 'annotate-mode)
  (add-hook 'csv-mode 'annotate-mode)
  (add-hook 'c-mode 'annotate-mode)
  (add-hook 'c++-mode 'annotate-mode)
  (add-hook 'sh-mode 'annotate-mode)
  (add-hook 'ledger-mode 'annotate-mode)
;;;  (define-globalized-minor-mode global-annotate-mode annotate-mode
;;;    (lambda () (annotate-mode 1)))
;;;  (global-annotate-mode 1)
  )

(use-package protobuf-mode
  :ensure t
  :mode "\\.proto\\'")

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

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))

(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-mini-default-sources '(helm-source-buffers-list
                                  helm-source-recentf
                                  helm-source-bookmarks
                                  helm-source-buffer-not-found))

(use-package emmet-mode
:ensure t)

(use-package rainbow-mode
  :ensure t)

(use-package writeroom-mode
  :ensure t
  :init
  (global-set-key (kbd "C-M-x w") 'writeroom-mode))

(use-package wgrep
  :ensure t)

(defun single-lines-only ()
  "replace multiple blank lines with a single one"
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward "\\(^\\s-*$\\)\n" nil t)
    (replace-match "\n")
    (forward-char 1)))

(defun paf/cleanup-ledger-buffer ()
  "Cleanup the ledger file"
  (interactive)
  (delete-trailing-whitespace)
  (single-lines-only)
  (ledger-mode-clean-buffer)
  (ledger-sort-buffer))

(use-package ledger-mode
  :ensure nil
  :pin manual
  :mode "\\.ledger\\'"
  :bind ("<f6>" . 'paf/cleanup-ledger-buffer)
  :config
  (setq ledger-reconcile-default-commodity "CHF"))

(use-package hyperbole
  :ensure t
  :config
  (bind-key "C-c C-/" 'hui-search-web)  ;; bind before calling require
  (require 'hyperbole))

(use-package
  anzu

  :ensure
  :config)
(global-anzu-mode +1)

(use-package
  whitespace

  :ensure
  :config (setq whitespace-style '(face empty tabs lines-tail trailing))
  :config (global-whitespace-mode t))

(use-package move-text
    :ensure
    :config)
(move-text-default-bindings)

(use-package string-inflection
  :ensure
  :config)
(add-hook 'elpy-mode-hook
            '(lambda ()
               (local-set-key (kbd "C-q C-u") 'string-inflection-python-style-cycle)))
(add-hook 'org-mode-hook
            '(lambda ()
               (local-set-key (kbd "C-q C-u") 'string-inflection-python-style-cycle)))
(add-hook 'mu4e-compose-mode-hook
            '(lambda ()
               (local-set-key (kbd "C-q C-u") 'string-inflection-python-style-cycle)))

(use-package telephone-line
    :ensure
    :config)
(telephone-line-mode t)

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

(use-package monky
  :ensure t
  :defer
  :bind ("C-x m" . 'monky-status))

(defun paf/vcs-status ()
     (interactive)
     (condition-case nil
         (magit-status-setup-buffer)
       (error (monky-status))))

(global-set-key (kbd "C-M-x v") 'paf/vcs-status)

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

(use-package helm-ag
  :ensure t
  :config)

(global-set-key (kbd "M-?") 'helm-ag)

(use-package google-c-style
  :ensure t
  :config
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent))

(use-package flymake-google-cpplint
  :ensure t)

(use-package ag
  :ensure
  :config
  (setq ag-highlight-search t)
  (setq ag-reuse-buffers t))

(setq helm-ag-insert-at-point 'symbol)
(setq helm-ag-use-temp-buffer t)

(use-package xref
  :ensure
  :config)

(use-package dumb-jump
  :ensure
  :config
  (setq dumb-jump-prefer-searcher 'ag))

(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(use-package ripgrep
  :ensure t)
(use-package projectile-ripgrep
  :ensure t
  :requires (ripgrep projectile))

(autoload 'comment-out-region "comment" nil t)
(global-set-key (kbd "C-c q") 'comment-out-region)

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

(global-set-key (kbd "C-M-x s") 'paf/sort-and-uniquify-region)

(use-package vdiff
  :ensure t
  :config
  ; This binds commands under the prefix when vdiff is active.
  (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map))

(defun set-selective-display-dlw (&optional level)
  "Fold text indented more than the cursor.
   If level is set, set the indent level to level.
   0 displays the entire buffer."
  (interactive "P")
  (set-selective-display (or level (current-column))))

(global-set-key "\C-x$" 'set-selective-display-dlw)

(use-package git-gutter-fringe+
  :ensure t
  :defer
  :if window-system
  :bind ("C-c g" . 'git-gutter+-mode))

(defvar locate-dominating-stop-dir-regexp
  "\\`\\(?:[\\/][\\/][^\\/]+\\|/\\(?:net\\|afs\\|\\.\\.\\.\\)/\\)\\'")

(use-package shift-number
  :ensure t
  :bind (("M-+" . shift-number-up)
         ("M-_" . shift-number-down)))

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

(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

(use-package web-mode
  :ensure t
  :mode "\\.html\\'"
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-comment-style 2))

(use-package csv-mode
  :ensure t
  :mode "\\.csv\\'")

(use-package tj3-mode
  :ensure t
  :after org-plus-contrib
  :config
  (require 'ox-taskjuggler)
  (custom-set-variables
   '(org-taskjuggler-process-command "/usr/local/bin/tj3 --silent --no-color --output-dir %o %f")
   '(org-taskjuggler-project-tag "PRJ")))

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

(use-package elpy
  :ensure
  :init
  :init
  (elpy-enable))

(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

(use-package
  py-autopep8

  :ensure t
  :config
  (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
  (setq py-autopep8-options '("--max-line-length=80")))

(use-package
  py-isort

  :ensure
  :config
  (add-hook 'before-save-hook 'py-isort-before-save)
  (setq py-isort-options '("-sl")))

(add-hook 'python-mode-hook #'smartparens-mode)

(use-package js2-mode
  :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.js[x]\\'" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . js2-mode)))
(add-hook 'js-mode-hook #'smartparens-mode)

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

(use-package js-doc
  :ensure
  :config
  (setq js-doc-mail-address "fxia1@lenovo.com")
  (setq js-doc-author (format "Feng Xia <%s>" js-doc-mail-address))
  (setq js-doc-url "http://www.lenovo.com")
  (setq js-doc-license "Lenovo License")
)
(add-hook 'js2-mode-hook
          #'(lambda ()
              (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
              (define-key js2-mode-map "@" 'js-doc-insert-tag)))

(use-package org
  :ensure nil
  :delight org-mode
  :config
  (setq org-startup-indented t)
  (if (not (boundp 'org-directory))
      (setq org-directory "~/org"))
  (add-hook 'org-mode-hook #'(lambda ()
                               (visual-line-mode)
                               (org-indent-mode))))

(defcustom remote-org-directory "~/OrgFiles"
  "Location of remove OrgFile directory, should you have one."
  :type 'string
  :group 'paf)
(defun paf/open-remote-org-directory ()
  (interactive)
  (find-file remote-org-directory))

(global-set-key (kbd "C-M-x r o") 'paf/open-remote-org-directory)

(require 'org-protocol)

(defun org-relative-file (filename)
  "Compute an expanded absolute file path for org files"
  (expand-file-name filename org-directory))

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

(defun my-org-inherited-no-file-tags ()
  (let ((tags (org-entry-get nil "ALLTAGS" 'selective))
        (ltags (org-entry-get nil "TAGS")))
    (mapc (lambda (tag)
            (setq tags
                  (replace-regexp-in-string (concat tag ":") "" tags)))
          (append org-file-tags (when ltags (split-string ltags ":" t))))
    (if (string= ":" tags) nil tags)))

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

(defun paf/org-agenda-get-location()
  "Gets the value of the LOCATION property"
  (let ((loc (org-entry-get (point) "LOCATION")))
    (if (> (length loc) 0)
        loc
      "")))

(use-package request
  :ensure t)
(load-file "~/Emacs/org-gtasks.el")

(use-package org-super-agenda
  :ensure t
  :config
  (org-super-agenda-mode t))

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

(use-package org-clock-convenience
  :ensure t
  :bind (:map org-agenda-mode-map
           ("<S-right>" . org-clock-convenience-timestamp-up)
           ("<S-left>" . org-clock-convenience-timestamp-down)
           ("[" . org-clock-convenience-fill-gap)
           ("]" . org-clock-convenience-fill-gap-both)))

;;(use-package org-kanban
;;  :ensure t)

(use-package org-board
  :ensure t
  :config
  (global-set-key (kbd "C-c o") org-board-keymap))

(use-package ox-reveal
  :ensure t
  :after (htmlize)
  :config
  (setq org-reveal-root (expand-file-name "~/reveal.js")))

(use-package htmlize
  :ensure t)

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

(load-file "~/Emacs/org-collector.el")

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

(setq org-hide-leading-stars t)
(setq org-log-done t)
(setq org-startup-indented t)
(setq org-startup-folded t)
(setq org-ellipsis "...")
(setq org-hide-emphasis-markers t)

(use-package org-bullets
  :ensure
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-habit
  :delight
  :config
  (setq org-habit-graph-column 38)
  (setq org-habit-preceding-days 35)
  (setq org-habit-following-days 10)
  (setq org-habit-show-habits-only-for-today nil))

(setq org-babel-sh-command "bash")

(setq org-clock-into-drawer t)
(setq org-log-into-drawer t)
(setq org-clock-int-drawer "CLOCK")

(defun org-get-first-agenda-file ()
  (interactive)
  (find-file (elt org-agenda-files 0)))
(global-set-key [f12] 'org-get-first-agenda-file)
; F12 on Mac OSX displays the dashboard....
(global-set-key [C-f12] 'org-get-first-agenda-file)

(setq org-link-abbrev-alist
      '(("b" . "http://b/")
        ("go" . "http://go/")
        ("cl" . "http://cr/")))

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

(setq org-enforce-todo-dependencies t)
(setq org-agenda-dim-blocked-tasks 'invisible)

(setq org-global-properties
      '(("Effort_ALL". "0 0:10 0:30 1:00 2:00 4:00 8:00 16:00")))
(setq org-columns-default-format
      "%TODO %30ITEM %3PRIORITY %6Effort{:} %10DEADLINE")

(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n!)" "STARTED(s!)" "WAITING(w!)" "AI(a!)" "|" "DONE(d!)" "CANCELLED(C@)" "DEFERRED(D@)" "SOMEDAY(S!)" "FAILED(F!)" "REFILED(R!)")
        (sequence "APPLIED(A!)" "WAITING(w!)" "ACCEPTED" "|" "REJECTED" "PUBLISHED")
        (sequence "TASK(m!)" "ACTIVE" "|" "DONE(d!)" "CANCELLED(C@)" )))

(setq org-tags-exclude-from-inheritance '("PRJ" "REGULAR")
      org-use-property-inheritance '("PRIORITY")
      org-stuck-projects '("+PRJ/-DONE-CANCELLED"
                           ;; it is considered stuck if there is no next action
                           (;"TODO"
                            "NEXT" "STARTED" "TASK") ()))

(setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "purple" :weight bold))
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

(delight 'org-agenda-mode)

;; Faces to make the calendar more colorful.
(custom-set-faces
 '(org-agenda-current-time ((t (:inherit org-time-grid :foreground "yellow" :weight bold))))
 '(org-agenda-date ((t (:inherit org-agenda-structure :background "pale green" :foreground "black" :weight bold))))
 '(org-agenda-date-weekend ((t (:inherit org-agenda-date :background "light blue" :weight bold)))))

(setq org-agenda-current-time-string ">>>>>>>>>> NOW <<<<<<<<<<")

;; will refresh it only if already visible
(run-at-time nil 180 'update-agenda-if-visible)
;;(add-hook 'org-mode-hook
;;          (lambda () (run-at-time nil 180 'kiwon/org-agenda-redo-in-other-window)))

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

(setq org-default-notes-file (org-relative-file "Inbox.org"))

(setq org-capture-templates
      `(("t" "Task"
         entry (file+headline ,(org-relative-file "Inbox.org") "Tasks")
         "* TODO %?\n%U\n\n%x"
         :clock-resume t)
        ;;
        ("i" "Idea"
         entry (file+headline ,(org-relative-file "Inbox.org") "Ideas")
         "* SOMEDAY %?\n%U\n\n%x"
         :clock-resume t)
        ;;
        ("m" "Meeting"
         entry (file+headline ,(org-relative-file "Inbox.org") "Meetings")
         "* %?  :MTG:\n%U\n%^{with}p"
         :clock-in t
         :clock-resume t)
        ;;
        ("s" "Stand-up"
         entry (file+headline ,(org-relative-file "Inbox.org") "Meetings")
         "* Stand-up  :MTG:\n%U\n\n%?"
         :clock-in t
         :clock-resume t)
        ;;
        ("1" "1:1"
         entry (file+headline ,(org-relative-file "Inbox.org") "Meetings")
         "* 1:1 %^{With}  :MTG:\n%U\n:PROPERTIES:\n:with: %\\1\n:END:\n\n%?"
         :clock-in t
         :clock-resume t)
        ;;
        ("p" "Talking Point"
         entry (file+headline ,(org-relative-file "refile.org") "Talking Points")
         "* %?  :TALK:\n%U\n%^{dowith}p"
         :clock-keep t)
        ;;
        ("j" "Journal"
         entry (file+olp+datetree ,(org-relative-file "journal.org"))
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

(setq org-roam-capture-templates
      `(("m" "Meeting" entry (function org-roam--capture-get-point)
             "* %?\n%U\n%^{with}\n"
             :file-name "meeting/%<%Y%m%d%H%M%S>-${slug}"
             :head "#+title: ${title}\n#+roam_tags: %^{with}\n\n"
             )))

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

(use-package ox-odt
  :defer)
(use-package ox-taskjuggler
  :defer)
(use-package ox-impress-js
  :defer)

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

(use-package yankpad
  :ensure t
  :defer
  :init
  (setq yankpad-file (org-relative-file "yankpad.org"))
  :config
  (bind-key "C-M-x y m" 'yankpad-map)
  (bind-key "C-M-x y e" 'yankpad-expand))

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

(org-reload)

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

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'mu4e)

(use-package mu4e-maildirs-extension
  :ensure
  :config)
(mu4e-maildirs-extension)

(setq mail-user-agent 'mu4e-user-agent)

(setq mu4e-maildir (expand-file-name "~/Maildir"))

(setq mu4e-get-mail-command "mbsync -a")

(setq mu4e-update-interval 600)

(setq mu4e-drafts-folder "/drafts"
      mu4e-sent-folder   "/sent"
      mu4e-trash-folder  "/trash")

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

(setq mu4e-headers-date-format "%b-%d %a"
      mu4e-headers-fields '((:date . 10)
                            (:flags . 5)
                            (:recipnum . 3)
                            (:from-or-to . 10)
                            (:thread-subject . nil)))

(setq mu4e-headers-skip-duplicates t)

(setq mu4e-headers-include-related t)

(add-to-list 'mu4e-header-info-custom
             '(:recipnum .
                         ( :name "Number of recipients"  ;; long name, as seen in the message-view
                                 :shortname "R#"           ;; short name, as seen in the headers view
                                 :help "Number of recipients for this message" ;; tooltip
                                 :function (lambda (msg)
                                             (format "%d"
                                                     (+ (length (mu4e-message-field msg :to))
                                                        (length (mu4e-message-field msg :cc))))))))

(setq mu4e-attachment-dir "~/Downloads")

(add-to-list 'mu4e-view-actions
             '("ViewInBrowser" . mu4e-action-view-in-browser)
             t)

(setq mu4e-view-show-images t)

(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

(setq mu4e-compose-signature
      (concat
       "Best regards,\n\n"
       "Feng Xia\n"
       "W: http://www.lenovo.com\n"))

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

(setq smtpmail-queue-mail nil
      smtpmail-queue-dir "~/Maildir/queue/cur")

(setq mu4e-compose-reply-to-address "fxia1@lenovo.com"
      user-mail-address "fxia1@lenovo.com"
      user-full-name "Feng Xia"
      message-signature  (concat
                          "Feng Xia\n"
                          "http://snapshots.world.s3-website.ap-northeast-2.amazonaws.com/\n")
      message-citation-line-format "On %Y-%m-%d %H:%M:%S, %f wrote:"
      message-citation-line-function 'message-insert-formatted-citation-line
      mu4e-headers-results-limit 500)

(setq message-kill-buffer-on-exit t)

(use-package org-mime
  :ensure
  :config
  (setq org-mime-export-ascii 'utf-8))

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

(use-package elfeed
  :ensure
  :config)
(setq elfeed-feeds
      '(("http://rss.slashdot.org/Slashdot/slashdotMain" dev)
        ("https://fengxia41103.github.io/myblog/feeds/all.atom.xml" me)
        ("https://www.reddit.com/r/aww+jokes.rss" fun)))
(use-package elfeed-goodies
  :ensure
  :config)
(elfeed-goodies/setup)
