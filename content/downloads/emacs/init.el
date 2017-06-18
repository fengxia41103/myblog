;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

(defvar current-user (getenv (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "Emacs is powering up... Be patient, Master %s!" current-user)


(let ((minver "23.3")) 
  (when (version<= emacs-version minver) 
    (error 
     "Your Emacs is too old -- this config requires v%s or higher"
     minver)))
(when (version<= emacs-version "24") 
  (message
   "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Temporarily reduce garbage collection during startup
;;----------------------------------------------------------------------------
(defconst sanityinc/initial-gc-cons-threshold gc-cons-threshold 
  "Initial value of `gc-cons-threshold' at start-up time.")
(setq gc-cons-threshold (* 128 1024 1024))
(add-hook 'after-init-hook 
          (lambda () 
            (setq gc-cons-threshold sanityinc/initial-gc-cons-threshold)))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa) ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-preload-local.el"
;;----------------------------------------------------------------------------
(require 'init-preload-local nil t)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require-package 'wgrep)
(require-package 'project-local-variables)
(require-package 'diminish)
(require-package 'scratch)
(require-package 'mwe-log-commands)

(require 'init-frame-hooks)
(require 'init-xterm)
(require 'init-themes)
(require 'init-osx-keys)
(require 'init-gui-frames)
(require 'init-dired)
(require 'init-isearch)
(require 'init-grep)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flycheck)

(require 'init-recentf)
(require 'init-smex)
;; If you really prefer ido to ivy, change the comments below. I will
;; likely remove the ido config in due course, though.
;; (require 'init-ido)
(require 'init-ivy)
(require 'init-hippie-expand)
(require 'init-company)
(require 'init-windows)
(require 'init-sessions)
(require 'init-fonts)
(require 'init-mmm)

(require 'init-editing-utils)
(require 'init-whitespace)
(require 'init-fci)

(require 'init-vc)
(require 'init-darcs)
(require 'init-git)
(require 'init-github)

;; (require 'init-projectile)

(require 'init-compile)
(require 'init-crontab)
(require 'init-textile)
(require 'init-markdown)
(require 'init-csv)
(require 'init-erlang)
(require 'init-javascript)
(require 'init-php)
(require 'init-org)
(require 'init-nxml)
(require 'init-html)
(require 'init-css)
(require 'init-haml)
(require 'init-python-mode)
(unless (version<= emacs-version "24.3") 
  (require 'init-haskell))
(require 'init-elm)
(require 'init-ruby-mode)
(require 'init-rails)
(require 'init-sql)

(require 'init-paredit)
(require 'init-lisp)
(require 'init-slime)
(unless (version<= emacs-version "24.2") 
  (require 'init-clojure) 
  (require 'init-clojure-cider))
(require 'init-common-lisp)

(when *spell-check-support-enabled* 
  (require 'init-spelling))

(require 'init-misc)

(require 'init-folding)
(require 'init-dash)
(require 'init-ledger)
;; Extra packages which don't require any configuration

(require-package 'gnuplot)
(require-package 'lua-mode)
(require-package 'htmlize)
(require-package 'dsvn)
(when *is-a-mac* (require-package 'osx-location))
(require-package 'regex-tool)

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p) 
  (server-start))


;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file) 
  (load custom-file))


;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
(require 'init-local nil t)


;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
(require 'init-locales)

;;----------------------------------------------------------------------------
;; nvm
;;----------------------------------------------------------------------------
(require-package 'nvm)
(defun do-nvm-use (version) 
  (interactive "sVersion: ") 
  (nvm-use version) 
  (exec-path-from-shell-copy-env "PATH"))

;;----------------------------------------------------------------------------
;; web-beautify
;;----------------------------------------------------------------------------
(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'json-mode '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'sgml-mode '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'web-mode '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'css-mode '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

(require 'js-auto-beautify)

(add-hook 'js2-mode-hook 'js-auto-beautify-mode)
(eval-after-load 'js2-mode '(add-hook 'js2-mode-hook 
                                      (lambda () 
                                        (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

(eval-after-load 'js-mode '(add-hook 'js-mode-hook 
                                     (lambda () 
                                       (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

(eval-after-load 'json-mode '(add-hook 'json-mode-hook 
                                       (lambda () 
                                         (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

(eval-after-load 'sgml-mode '(add-hook 'html-mode-hook 
                                       (lambda () 
                                         (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))

(eval-after-load 'css-mode '(add-hook 'css-mode-hook 
                                      (lambda () 
                                        (add-hook 'before-save-hook 'web-beautify-css-buffer t t))))

;;----------------------------------------------------------------------------
;; py-autopep8
;;----------------------------------------------------------------------------

(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(setq py-autopep8-options '("--max-line-length=100"))

;; Golang gofmt hook
(add-hook 'before-save-hook #'gofmt-before-save)
(add-hook 'go-mode-hook 
          (lambda () 
            (add-hook 'before-save-hook 'gofmt-before-save) 
            (setq tab-width 2) 
            (setq indent-tabs-mode 1)))

(provide 'init)

;; Borrowed from Rich's config
;; Useful restart and install package commands
(global-set-key (kbd "C-c C-r") 'restart-emacs)
(global-set-key (kbd "C-c C-p") 'package-install)


;; Save the current macro as reusable function. MOVE
(defun save-current-kbd-macro-to-dot-emacs (name) 
  "Save the current macro as named function definition inside
your initialization file so you can reuse it anytime in the
future." 
  (interactive "Save Macro as: ") 
  (name-last-kbd-macro name) 
  (save-excursion (find-file-literally user-init-file) 
                  (goto-char (point-max)) 
                  (insert "\n\n;; Saved macro\n") 
                  (insert-kbd-macro name) 
                  (insert "\n")))


;; Save the place in files
(require 'saveplace)
(setq-default save-place t)

;; Undentation and buffer cleanup
(defun untabify-buffer () 
  (interactive) 
  (untabify (point-min) 
            (point-max)))

(defun indent-buffer () 
  (interactive) 
  (indent-region (point-min) 
                 (point-max)))

(defun cleanup-buffer () 
  "Perform a bunch of operations on the whitespace content of a buffer." 
  (interactive) 
  (indent-buffer) 
  (untabify-buffer) 
  (delete-trailing-whitespace))

(defun cleanup-region (beg end) 
  "Remove tmux artifacts from region." 
  (interactive "r") 
  (dolist (re '("\\\\|\·*\n" "\W*|\·*")) 
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) 
  (package-install 'use-package))
(setq use-package-always-ensure t)

;; Great font on the mac
;; Display all the monospace fonts available to Emacs in a dedicated buffer

(defun font-is-mono-p (font-family)
  ;; with-selected-window
  (let ((wind (selected-window))
        m-width l-width)
    (with-current-buffer "asdf"
      (set-window-buffer (selected-window) (current-buffer))
      (text-scale-set 4)
      (insert (propertize "l l l l l" 'face `((:family ,font-family))))
      (goto-char (line-end-position))
      (setq l-width (car (posn-x-y (posn-at-point))))
      (newline)
      (forward-line)
      (insert (propertize "m m m m m" 'face `((:family ,font-family) italic)))
      (goto-char (line-end-position))
      (setq m-width (car (posn-x-y (posn-at-point))))
      (eq l-width m-width))))

(defun compare-monospace-fonts ()
  "Display a list of all monospace font faces."
  (interactive)
  (pop-to-buffer "*Monospace Fonts*")

  (erase-buffer)
  (dolist (font-family (font-family-list))
    (when (font-is-mono-p font-family)
      (let ((str font-family))
        (newline)
        (insert
         (propertize (concat "The quick brown fox jumps over the lazy dog 1 l; 0 O o ("
                             font-family ")\n") 'face `((:family ,font-family)))
         (propertize (concat "The quick brown fox jumps over the lazy dog 1 l; 0 O o ("
                             font-family ")\n") 'face `((:family ,font-family) italic)))))))

;;(set-face-attribute 'default nil :family "Bitstream Vera Sans Mono" :height 100)
;; (add-to-list 'default-frame-alist '(font . "Inconsolata"))
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono"))
(set-face-attribute 'default nil :family "DejaVu Sans Mono)" :height 120)
;; (set-face-attribute 'default nil 
;;                     :family "Inconsolata" 
;;                     :height 120)


;; Theme and font good for coding
(use-package 
  suscolors-theme 

  :ensure 
  :config)
;; (load-theme 'suscolors t)

(use-package 
  lush-theme 

  :ensure 
  :config)
;; (load-theme 'lush t)

(use-package 
  moe-theme 

  :ensure 
  :config)
;; (load-theme 'moe-dark t)


(use-package 
  alect-themes 

  :ensure 
  :config)
;; (load-theme 'alect-black t)

(use-package 
  metalheart-theme 

  :ensure 
  :config)
;; (load-theme 'metalheart t)

(use-package 
  paganini-theme 

  :ensure 
  :config)
;; (load-theme 'paganini t)

;; Smart Mode Line
(use-package 
  smart-mode-line
  :ensure 
  :config (progn 
            ;; (use-package 
            ;;   smart-mode-line-powerline-theme) 
            (sml/setup) 
            ;;(setq sml/apply-theme 'respectful)
            ))

(use-package 
  firecode-theme 

  :ensure 
  :config)
;; (load-theme 'firecode t)

(use-package 
  molokai-theme 

  :ensure 
  :config)
;; (load-theme 'molokai t)

(use-package 
  zenburn-theme 

  :ensure 
  :config)
;; (load-theme 'zenburn t)

(use-package 
  solarized-theme 

  :ensure 
  :config)
;; (load-theme 'solarized t)

(use-package 
  color-theme-modern 

  :ensure 
  :config)
(load-theme 'hober t)


;; Is this now removed by default?
(menu-bar-mode 1)

;; Get rid of slow tool-bar - adding back in to see what 24.4 does
(tool-bar-mode -1)


;; Remove bell and replace with message
(setq ring-bell-function 
      '(lambda () 
         (message "The answer is 42...")))

;; quiet, please! No dinging!
(setq echo-keystrokes 0.1 use-dialog-box nil visible-bell t)


(setq-default frame-title-format 
              '(:eval (format "%s@%s: %s %s" (or (file-remote-p default-directory 'user) 
                                                 user-real-login-name) 
                              (or (file-remote-p default-directory 'host) 
                                  system-name) 
                              (buffer-name) 
                              (cond (buffer-file-truename (concat "(" buffer-file-truename ")")) 
                                    (dired-directory (concat "{" dired-directory "}")) 
                                    (t "[no file]")))))

;; Auto decompress compressed files.
(auto-compression-mode 1)

;; No auto save.
;; (setq-default auto-save-default nil)
;; We don't want backup files - that's what .snapshot is for.
;; (setq make-backup-files nil)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Save history
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

;; Some pretty stuff
(setq font-lock-maximum-decoration t)
(setq query-replace-highlight t)
(setq search-highlight t)
(global-font-lock-mode 1)

;; Remove tabs
(setq tab-width 4 indent-tabs-mode nil)

;; Nothing over 80 characters
(setq fill-column 80)
(global-set-key "\C-xw" 'auto-fill-mode)

;; Replace "yes or no" with y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; Uncomment if you don't want a Scroll Bar
;; (scroll-bar-mode -1)

;; default shell command "history" length is just 32. Allocate
(setq comint-input-ring-size 500)

;; Cause the region to be highlighted when the mark is active
(transient-mark-mode 1)

;; Respond to the system clipboard
;;(setq x-select-enable-clipboard t)
(setq select-enable-clipboard t)

;; Want line number and column?
(setq column-number-mode t)

;; Show the current function in the mode line
(which-function-mode t)

;; Emacs could care less what character your file ends with.
(setq require-final-newline t)

(setq size-indication-mode t)

;; Pgup/dn will return exactly to the starting point.
(setq scroll-preserve-screen-position 1)

;; Scrolling:
(setq scroll-step 1)

(setq my-home-directory (getenv "HOME"))

;; Globally revert buffers changed by another process.
(global-auto-revert-mode 1)

;; eshell stop annoying save message.
(setq eshell-ask-to-save-history 'always)


;; Sets autofill on in text mode automatically
(setq text-mode-hook 'turn-on-auto-fill)

;; Set text rather than Lisp to be the default mode.
;; (setq default-major-mode 'text-mode)
(setq major-mode 'text-mode)

;; make grep-find follow links
;; (setq grep-find-command "find . -follow -type f -print0 | xargs -0 -e -P4 grep -n -e ")

;; Make eww default browser
(setq browse-url-browser-function 'eww-browse-url)

(setq auto-mode-alist (append '(("\\.[CH]$"    . c++-mode) 
                                ("\\.[ch]pp$"  . c++-mode) 
                                ("\\.cc$"      . c++-mode) 
                                ("\\.c$"       . c++-mode) 
                                ("\\.h$"       . c++-mode) 
                                ("\\.reg$"     . c++-mode) 
                                ("\\.c.gcov$"  . c++-mode) 
                                ("\\.my$"      . snmpv2-mode) 
                                ("\\.mib$"     . snmpv2-mode) 
                                ("\\.lib$"     . tcl-mode) 
                                ("\\.suite$"   . tcl-mode) 
                                ("\\.pdl$"     . quoted-lisp-mode) 
                                ("\\.yaml$"     . yaml-mode) 
                                ("\\.yml$"     . yaml-mode) 
                                ("\\.diff$"    . diff-mode)) auto-mode-alist))

;; open multiple unique eshells
(defun ushell () 
  "Open uniquely named eshell window." 
  (interactive) 
  (shell) 
  (rename-uniquely))

;; Swap the buffers around - intelligent
(defun swap-buffer-in-window () 
  "Switch display of buffer in window to next item in buffer list.
This actually picks the first 'interesting' buffer it finds in the
buffer list (see also the 'buffer-list' function), with preference
given to windows not already displayed in another window.

Executing this function repeatedly will just toggle back and forth
between the first two 'interesting' items in the 'buffer-list'." 
  (interactive) 
  (switch-to-buffer (other-buffer)))

(defun cycle-buffers-in-window () 
  "Cycles through the buffers in the current window.  'Uninteresting' buffers,
and buffers which are visible in other windows are normally skipped." 
  (interactive) 
  (bury-buffer))

;; Dired mode additions
(defun my-dired-mode-hook () 
  "Hook run when entering 'dired-mode'."
  (define-key dired-mode-map "X" 'dired-execute-file) 
  (define-key dired-mode-map [double-down-mouse-1] 'dired-mouse-execute-file))
(add-hook 'dired-mode-hook 'my-dired-mode-hook)

(add-hook 'c-mode-common-hook 'turn-on-auto-fill)
;; (add-hook 'c-mode-common-hook 'hc-highlight-tabs)
;; (add-hook 'c-mode-common-hook 'hc-highlight-trailing-whitespace)
;; (add-hook 'c-mode-common-hook 'hc-highlight-hard-spaces)

;; Try linux style indentation
(setq c-default-style "linux" c-basic-offset 4)

(add-hook 'c-mode-hook 
          (lambda () 
            (add-to-list 'ac-sources 'ac-source-c-headers) 
            (add-to-list 'ac-sources 'ac-source-c-header-symbols t)))

(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)

;; Turn off pesky tabs
(setq-default indent-tabs-mode nil)

;; snmp mode
(autoload `snmpv2-mode "snmp-mode" "Mode for editing SNMPv2 MIBs" t)

;; File of functions that save state over emacs session
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 1000)

;; Restores buffers
(desktop-save-mode 1)

;; Shortcuts
(global-set-key [f9] 'ibuffer)

;; Make control+pageup/down scroll the other buffer
(global-set-key [C-next] 'scroll-other-window)
(global-set-key [C-prior] 'scroll-other-window-down)

;; useful for centering.
(global-set-key "\M-l"     "\C-u0\C-l")

(require 'cc-mode)
(require 'cc-vars)

;; Enable up down keys in shell mode (M-x shell/ushell)
(require 'comint)
(define-key comint-mode-map (kbd "M-") 'comint-next-input)
(define-key comint-mode-map (kbd "M-") 'comint-previous-input)
(define-key comint-mode-map [down] 'comint-next-matching-input-from-input)
(define-key comint-mode-map [up] 'comint-previous-matching-input-from-input)


;; Ack
(setq ack-prompt-for-directory t)
(setq ack-executable (executable-find "ack-grep"))

(autoload 'mode-compile "mode-compile"
  "Command to compile current buffer file based on the major mode" t)
(global-set-key "\C-cc" 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
  "Command to kill a compilation launched by `mode-compile'" t)
(global-set-key "\C-ck" 'mode-compile-kill)

;; Setting Tab to indent region if anything is selected
(defun maybe-tab () 
  (interactive) 
  (if (and transient-mark-mode 
           mark-active) 
      (indent-region (region-beginning) 
                     (region-end) nil) 
    (c-indent-command)))
(defun tab-indents-region () 
  (local-set-key [(tab)] 'maybe-tab))

(add-hook 'c-mode-common-hook   'tab-indents-region)
(add-hook 'python-mode-hook   'tab-indents-region)

;; autoindent on newline (RET)
;;(add-hook 'c-mode-common-hook '(lambda ()
;;                                 (local-set-key (kbd "RET") 'newline-and-indent)))
(global-set-key (kbd "RET") 'newline-and-indent)

;; Auto indent pasted code
(dolist (command '(yank yank-pop)) 
  (eval 
   `(defadvice ,command (after indent-region activate) 
      (and (not current-prefix-arg) 
           (member major-mode '(emacs-lisp-mode lisp-mode clojure-mode    scheme-mode haskell-mode
                                                ruby-mode rspec-mode c-mode          c++-mode
                                                objc-mode       latex-mode plain-tex-mode)) 
           (let ((mark-even-if-inactive transient-mark-mode)) 
             (indent-region (region-beginning) 
                            (region-end) nil))))))

;; Hide Lines
(autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
(global-set-key (kbd "C-c /") 'hide-lines)


;; xrvr_ddts -i remote
(defun xrvr-ddts-info () 
  "Run xrvr_ddts -i across remote ssh." 
  (interactive) 
  (compilation-start (concat "ssh -Y -o LogLevel=Error rtp-ads-474 'xrvr_ddts -i'") nil 
                     '(lambda (mode-name) 
                        "*xrvr-ddts-info*")))
(global-set-key "\C-ci" 'xrvr-ddts-info)

;; Autoload diff mode
(autoload 'diff-mode "diff-mode" "Diff major mode" t)
(add-to-list 'auto-mode-alist '("\\.\\(diff\\|patch\\|rej\\)\\'" . diff-mode))

;; Always highlight parens or go mad
(show-paren-mode t)
(set-face-attribute 'region nil 
                    :background "#666" 
                    :foreground "#ffffff")
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#def")
(set-face-attribute 'show-paren-match nil 
                    :weight 'extra-bold)

;; Org mode
(unless (package-installed-p 'org) ;; Make sure the Org package is
  (package-install 'org))          ;; installed, install it if not

;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))

(setq org-todo-keywords (quote ((sequence "TODO(t)" "NEXT(n)" "WORKING(k@/!)" "|" "DONE(d@/!)") 
                                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

(setq org-todo-keyword-faces (quote (("TODO" :foreground "red" 
                                      :weight bold) 
                                     ("DONE" :foreground "forest green" 
                                      :weight bold) 
                                     ("WAITING" :foreground "orange" 
                                      :weight bold) 
                                     ("HOLD" :foreground "magenta" 
                                      :weight bold) 
                                     ("CANCELLED" :foreground "forest green" 
                                      :weight bold) 
                                     ("WORKING" :foreground "forest green" 
                                      :weight bold))))

(setq org-use-fast-todo-selection t)

(setq org-todo-state-tags-triggers (quote (("CANCELLED" ("CANCELLED" . t)) 
                                           ("WAITING" ("WAITING" . t)) 
                                           ("HOLD" ("WAITING") 
                                            ("HOLD" . t)) 
                                           ("TODO" ("WAITING") 
                                            ("CANCELLED") 
                                            ("HOLD")) 
                                           ("NEXT" ("WAITING") 
                                            ("CANCELLED") 
                                            ("HOLD")) 
                                           ("DONE" ("WAITING") 
                                            ("CANCELLED") 
                                            ("HOLD")))))

;; Org Capture mode
(setq org-directory "~/org/")
(setq org-default-notes-file "~/org/notes.org")

(setq org-capture-templates '(("t" "Todo" entry (file+headline "~/org/todo_mac.org" "Tasks")
                               "* TODO %?\n %i\n") 
                              ("n" "Note" entry (file+datetree "~/org/notes_mac.org")
                               "* NOTE %?\n %i\n ") 
                              ("o" "Tool" entry (file+datetree "~/org/tools.org")
                               "* TOOL %?\n %i\n ") 
                              ("j" "Journal" entry (file+datetree "~/org/journal.org")
                               "* %?\nEntered on %U\n  %i\n ") 
                              ("x" "XRv" entry (file+datetree "~/org/xrv.org") "* XRV %?\n %i\n ") 
                              ("a" "Agile" entry (file+datetree "~/org/agile.org") "* %?\n %i\n ") 
                              ("s" "Sunstone" entry (file+datetree "~/org/sunstone.org")
                               "* Sunstone %?\n %i\n ") 
                              ("d" "Devnet" entry (file+datetree "~/org/devnet.org")
                               "* Devnet %?\n %i\n ") 
                              ("p" "Puppet" entry (file+datetree "~/org/puppet.org")
                               "* PUPPET %?\n %i\n ")))

(setq header-line-format mode-line-format)

(setq org-publish-project-alist '(("org" :base-directory "~/org/" 
                                   :publishing-directory "/nfs/wwwPeople/fxia1/Notes" 
                                   :recursive t 
                                   :section-numbers t 
                                   :table-of-contents t 
                                   :publishing-function org-html-publish-to-html 
                                   :headline-levels 4 ; Just the default for this project.
                                   :auto-preamble t 
                                   :style "<link rel=\"stylesheet\"
                     href=\"../other/mystyle.css\"
                     type=\"text/css\"/>")))

;; diplay-theme
(setq display-theme-mode 1)

;; Better buffer cycling
;; f4-f5 for user buffers, f6, f7 for emacs buffers
(defun next-user-buffer () 
  "Switch to the next user buffer.
 (buffer name does not start with "
  *
  ".)" 
  (interactive) 
  (next-buffer) 
  (let ((i 0)) 
    (while (and (string-equal "*" (substring (buffer-name) 0 1)) 
                (< i 20)) 
      (setq i (1+ i)) 
      (next-buffer))))

(defun previous-user-buffer () 
  "Switch to the previous user buffer.
 (buffer name does not start with "
  *
  ".)" 
  (interactive) 
  (previous-buffer) 
  (let ((i 0)) 
    (while (and (string-equal "*" (substring (buffer-name) 0 1)) 
                (< i 20)) 
      (setq i (1+ i)) 
      (previous-buffer))))

(defun next-emacs-buffer () 
  "Switch to the next emacs buffer.
 (buffer name that starts with "
  *
  ")" 
  (interactive) 
  (next-buffer) 
  (let ((i 0)) 
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) 
                (< i 20)) 
      (setq i (1+ i)) 
      (next-buffer))))

(defun previous-emacs-buffer () 
  "Switch to the previous emacs buffer.
 (buffer name that starts with "
  *
  ")" 
  (interactive) 
  (previous-buffer) 
  (let ((i 0)) 
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) 
                (< i 20)) 
      (setq i (1+ i)) 
      (previous-buffer))))

(global-set-key (kbd "<f4>") 'previous-user-buffer)
(global-set-key (kbd "<f5>") 'next-user-buffer)

(global-set-key (kbd "<f6>") 'previous-emacs-buffer)
(global-set-key (kbd "<f7>") 'next-emacs-buffer)

;; Makes orgmode auto lists work better
(add-hook 'org-mode-hook 
          (lambda () 
            (org-autolist-mode)))

;; crontab editing
(add-to-list 'auto-mode-alist '("\\.cron\\(tab\\)?\\'" . crontab-mode))
(add-to-list 'auto-mode-alist '("cron\\(tab\\)?\\."    . crontab-mode))

;; Seems to be on by default and I hate it
(hl-line-mode 0)

;; tramp ssh
(setq tramp-default-method "ssh")

;; yaml mode indents new line
(add-hook 'yaml-mode-hook 
          (lambda () 
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; Org publish (org-publish-all)
(setq org-publish-project-alist '("org-notes" :base-directory "~/org" 
                                  :publishing-directory "/nfs/wwwPeople/fxia1/org_publish/" 
                                  :publishing-function org-twbs-publish-to-html 
                                  :with-sub-superscript nil))

(defun my-org-publish-buffer () 
  (interactive) 
  (save-buffer) 
  (save-excursion (org-publish-current-file)) 
  (let* ((proj (org-publish-get-project-from-filename buffer-file-name)) 
         (proj-plist (cdr proj)) 
         (rel (file-relative-name buffer-file-name (plist-get proj-plist 
                                                              :base-directory))) 
         (dest (plist-get proj-plist 
                          :publishing-directory))) 
    (browse-url (concat "file://" (file-name-as-directory (expand-file-name dest)) 
                        (file-name-sans-extension rel) ".html"))))

(add-hook 'org-mode-hook 
          (lambda () 
            (local-set-key (kbd "s-\\") 'my-org-publish-buffer)))

;; Add latin
(global-set-key (kbd "C-c C-l s") 'lorem-ipsum-insert-sentences)
(global-set-key (kbd "C-c C-l p") 'lorem-ipsum-insert-paragraphs)
(global-set-key (kbd "C-c C-l l") 'lorem-ipsum-insert-list)

;; Tiny system monitor is displayed in minibuffer, during idle.
;; (symon-mode)

;;;###autoload
(put 'cd-compile-directory 'safe-local-variable 'stringp)

;;;###autoload
(defun cd-compile (dir) 
  "Run compile in a specific directory.
Runs \\[compile] in the directory DIR.
Interactively, uses `cd-compile-directory' for the directory if
non-nil; otherwise prompts the user to enter the directory." 
  (interactive (list (or cd-compile-directory 
                         (read-directory-name "Compile directory: ")))) 
  (let ((compile-directory (file-name-as-directory dir))) 
    (if (not (file-directory-p compile-directory)) 
        (user-error 
         "%s: no such directory"
         compile-directory) 
      (let ((default-directory compile-directory)) 
        (call-interactively 'compile)))))


;;
;;
;;
;; Non-standard packages
;;
;;
;;

;; Useful for mac path issues and tools
(use-package 
  exec-path-from-shell 

  :ensure 
  :config (exec-path-from-shell-initialize))

;; take any buffer and turn it into an html file,
;; including syntax hightlighting
(use-package 
  htmlize 

  :ensure 
  :config)

;; ssh directly from emacs
(use-package 
  ssh 

  :ensure 
  :config)

;; xcscope package
(use-package 
  xcscope 

  :ensure 
  :config (cscope-setup))
(defvar cisco-cscope-inited nil 
  "Used to initialize the cisco extension only once.")

;; flycheck
(use-package 
  flycheck 

  :ensure 
  :config(add-hook 'after-init-hook #'global-flycheck-mode) 
  :config(setq-default flycheck-disabled-checkers '(ruby-rubylint)))

;; python-mode
;; (use-package python
;;   :ensure
;;   :config)
;; (setq python-shell-completion-native-enable nil)

;; elpy pEython mode
;; Note uses flake8 - pip install flake8
(use-package 
  elpy 

  :ensure 
  :config)
(elpy-enable)

;;  highlight
(use-package 
  highlight-chars 

  :ensure 
  :config)

;; autopair parens
(use-package 
  autopair 

  :ensure 
  :config)
(setq show-paren-style 'mixed)

;; (require 'exec-path-from-shell) ;; if not using the ELPA package
;; (exec-path-from-shell-initialize)

;; Sane term
(use-package 
  sane-term 

  :ensure 
  :config)
(global-set-key (kbd "C-x t") 'sane-term)
(global-set-key (kbd "C-x T") 'sane-term-create)

;; auto highlite symbol
(use-package 
  auto-highlight-symbol 

  :ensure 
  :config)
(global-auto-highlight-symbol-mode t)

;; Display number of matches in searches
(use-package 
  anzu 

  :ensure 
  :config)
(global-anzu-mode +1)

;; Unibox a string
(use-package 
  unicode-enbox 

  :ensure 
  :config)

;; helm - anything successor
;; http://tuhdo.github.io/helm-intro.html
(use-package 
  helm 

  :ensure 
  :config)
(helm-mode 1)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "M-x") 'helm-M-x)
;; (setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-c h x") 'helm-register)

(when (executable-find "ack-grep") 
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

(setq helm-buffers-fuzzy-matching t helm-recentf-fuzzy-match    t)
(when (executable-find "curl") 
  (setq helm-google-suggest-use-curl-p t))

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

;; Smartscan for symbols
(use-package 
  smartscan 

  :ensure 
  :config (global-smartscan-mode 1))
;; Simply type `smartscan-symbol-go-forward' (or press M-n) to go
;; forward; or `smartscan-symbol-go-backward' (M-p) to go
;; back. Additionally, you can replace all symbols point is on by
;; invoking M-' (that's "M-quote")

;; helm-swoop
(use-package 
  helm-swoop 

  :ensure 
  :config (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch))

;; Magit gitflow
(use-package 
  magit-gitflow 

  :ensure 
  :config (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))

;; Elfeed
(use-package 
  elfeed 

  :ensure 
  :config)

(use-package 
  elfeed-goodies 

  :ensure 
  :config (elfeed-goodies/setup))

;; git-gutter
(use-package 
  git-gutter-fringe 

  :ensure 
  :config (global-git-gutter-mode t))

;; Fuzzier helm logic
(use-package 
  helm-fuzzier 

  :ensure 
  :config (helm-fuzzier-mode 1))

;; Magit pull requests
(use-package 
  magit-gh-pulls 

  :ensure 
  :config (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

;; Make cursor show up
(use-package 
  beacon 

  :ensure 
  :config (beacon-mode 1) 
  :config (setq beacon-push-mark 35) 
  :config (setq beacon-color "#666600"))

;; diredful - colored dired
(use-package 
  diredful 

  :ensure 
  :config (diredful-mode 1))

;; ace-window
;; (use-package ace-window
;; :ensure
;; :bind (("M-a" . ace-window))
;; :config  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; Scratch-buffer improvements
;; Log file goes to ~/.scratch
(use-package 
  scratch-ext 

  :ensure 
  :config)

;; Highlite unnecessary chars and lines over 80
(use-package 
  whitespace 

  :ensure 
  :config (setq whitespace-style '(face empty tabs lines-tail trailing)) 
  :config (global-whitespace-mode t))

;; auto-complete
(use-package 
  auto-complete 

  :ensure 

  :config 
  :config (add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict") 
  :config (ac-config-default) 
  :config (setq ac-use-menu-map t) 
  :config (define-key ac-menu-map "\C-n" 'ac-next) 
  :config (define-key ac-menu-map "\C-p" 'ac-previous))

;; Bash completion
(use-package 
  bash-completion 

  :ensure 
  :config (bash-completion-setup))

;; Comment dwim2
(use-package 
  comment-dwim-2 

  :ensure 
  :bind (("M-;" . comment-dwim-2)))

;; magit find file
(use-package 
  magit-find-file 

  :ensure 
  :config)

;; restart emacs
(use-package 
  restart-emacs 

  :ensure 
  :config)

;; org auto
(use-package 
  org-autolist 

  :ensure 
  :config)

;; writegood-mode
(use-package 
  writegood-mode 

  :ensure 
  :config)

;; markdown mode
(use-package 
  markdown-mode 

  :ensure 
  :config (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode)) 
  :config (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode)) 
  :config (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)) 
  :config (add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode)) 
  :config (add-hook 'markdown-mode-hook 
                    (lambda () 
                      (visual-line-mode t) 
                      (writegood-mode t) 
                      (flyspell-mode t))))
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)

;;  big brother database
(use-package 
  bbdb 

  :ensure 
  :config (customize-set-variable 'bbdb-file "~/.emacs.d/bbdb") 
  :config (add-to-list 'after-init-hook 
                       (lambda () 
                         (bbdb-initialize 'gnus 'message))))


;; helm cscope interface
(use-package 
  helm-cscope 

  :ensure 
  :config)

;; f3 find
(use-package 
  f3 

  :ensure 
  :config)

;; f3 find
(use-package 
  py-autopep8 

  :ensure 
  :config (add-hook 'python-mode-hook 'py-autopep8-enable-on-save) 
  :config (setq py-autopep8-options '("--max-line-length=100")))

;; go-mode tab
(add-hook 'go-mode-hook 
          (lambda ()
                                        ; Use goimports instead of go-fmt
            (add-hook 'before-save-hook 'gofmt-before-save) 
            (setq-default) 
            (setq tab-width 4) 
            (setq standard-indent 4) 
            (setq indent-tabs-mode nil)))

;; go-eldoc
(defun go-mode-setup () 
  (go-eldoc-setup))

;;Format before saving
(defun go-mode-setup () 
  (go-eldoc-setup) 
  (add-hook 'before-save-hook 'gofmt-before-save))
(add-hook 'go-mode-hook 'go-mode-setup)

;; go-imports
;; (defun go-mode-setup ()
;;   (go-eldoc-setup)
;;   (setq gofmt-command "goimports")
;;   (add-hook 'before-save-hook 'gofmt-before-save))
;; (add-hook 'go-mode-hook 'go-mode-setup)

;;Godef, shows function definition when calling godef-jump
(defun go-mode-setup () 
  (go-eldoc-setup) 
  (add-hook 'before-save-hook 'gofmt-before-save) 
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'go-mode-setup)

;; go-autocomplete
(use-package 
  go-autocomplete 

  :ensure 
  :config)

;; w3m browser
;;change default browser for 'browse-url'  to w3m
(setq browse-url-browser-function 'w3m-goto-url-new-session)

;;change w3m user-agent to android
(setq w3m-user-agent
      "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.")

;;quick access hacker news
(defun hn () 
  (interactive) 
  (browse-url "http://news.ycombinator.com"))

;;quick access reddit
(defun reddit (reddit) 
  "Opens the REDDIT in w3m-new-session" 
  (interactive (list (read-string "Enter the reddit (default: psycology): " nil nil "psychology"
                                  nil))) 
  (browse-url (format "http://m.reddit.com/r/%s" reddit)))

;;i need this often
(defun wikipedia-search (search-term) 
  "Search for SEARCH-TERM on wikipedia" 
  (interactive (let ((term (if mark-active 
                               (buffer-substring 
                                (region-beginning) 
                                (region-end)) 
                             (word-at-point)))) 
                 (list (read-string (format "Wikipedia (%s):" term) nil nil term)))) 
  (browse-url (concat "http://en.m.wikipedia.org/w/index.php?search=" search-term)))

;;when I want to enter the web address all by hand
(defun w3m-open-site (site) 
  "Opens site in new w3m session with 'http://' appended" 
  (interactive (list (read-string "Enter website address(default: w3m-home):" nil nil w3m-home-page
                                  nil ))) 
  (w3m-goto-url-new-session (concat "http://" site)))

;; IRC client
(use-package 
  circe 

  :ensure 
  :config)

(setq circe-network-options '(("Freenode" :tls t 
                               :nick "fengxia41103"
                               ;; :sasl-username "my-nick"
                               ;; :sasl-password "my-password"
                               :channels ("#emacs" "#python" "#odoo" "#reactjs" "#latex"
                                          "#openstack-meeting-5" ; Heat weekly meeting
                                          "#openstack-meeting-3" ; Horizon weekly meeting
                                          "#openstack-horizon" "#openstack-heat"))))

(use-package 
  helm-circe 

  :ensure 
  :config)

;; py-isort
(use-package 
  py-isort 

  :ensure 
  :config)
(add-hook 'before-save-hook 'py-isort-before-save)
(setq py-isort-options '("-sl")) ;; One module per line

;; org-mode export
(eval-after-load "org" 
  '(require 'ox-md nil t))

;; web-mode
(use-package 
  web-mode 

  :ensure 
  :config(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  :config (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  :config (add-to-list 'auto-mode-alist '("\\.htm[l]\\'" . web-mode))
  :config (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  :config (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  :config (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  :config (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))     
  :config (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  :config (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  :config (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))   
  )

(defun my-web-mode-hook () 
  "Hooks for Web mode."

  ;; java/c/c++
  (setq c-basic-offset 2)

  ;; web development
  (setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset 2)    ; web-mode, css in html file
  (setq web-mode-code-indent-offset 2) ; web-mode, js code in html file
  (setq coffee-tab-width 2)            ; coffeescript
  (setq javascript-indent-level 2)     ; javascript-mode
  (setq js-indent-level 2)             ; js-mode
  (setq js2-basic-offset 2) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq css-indent-offset 2)            ; css-mode
  )
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; to format LISP code
(use-package 
  elisp-format 

  :ensure 
  :config)

;; undo-tree package
(use-package 
  undo-tree

  :ensure 
  :config)
(global-undo-tree-mode)

;; mu42 gmail setup
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'mu4e)
(mu4e-maildirs-extension)

;;location of my maildir
(setq mu4e-maildir (expand-file-name "~/Maildir"))

;;command used to get mail
;; use this for testing
(setq mu4e-get-mail-command "true")

(setq mu4e-view-prefer-html t)

;; use this to sync with mbsync
(setq mu4e-get-mail-command "mbsync -a")


(setq mu4e-drafts-folder "/drafts"
      mu4e-sent-folder   "/sent"
      mu4e-trash-folder  "/trash")
;; (setq mu4e-maildir-shortcuts
;;       '(("/INBOX"             . ?i)
;; 	("/sent"              . ?s)
;; 	("/trash"             . ?t)
;; 	("/drafts"            . ?d)
;; 	("/review"            . ?r)
;; 	("/cours"             . ?c)
;; 	("/private"           . ?p)
;; 	("/inserm"            . ?m)
;; 	("/aphp"              . ?a)
;; 	("/mailing"           . ?l)))
(add-to-list 'mu4e-bookmarks '("flag:attach"    "Messages with attachment"   ?a) t)
(add-to-list 'mu4e-bookmarks '("size:5M..500M"  "Big messages"               ?b) t)
(add-to-list 'mu4e-bookmarks '("flag:flagged"   "Flagged messages"           ?f) t)

(setq mu4e-headers-date-format "%Y-%m-%d %H:%M:%S"
      mu4e-headers-fields '((:date . 20)
			    (:flags . 5)
			    (:mailing-list . 10)
			    (:from-or-to . 25)
			    (:subject . nil))) 

(setq mu4e-reply-to-address "feng_xia41103@hotmail.com"
      user-mail-address "feng_xia41103@hotmail.com"
      user-full-name "Feng Xia"
      message-signature  (concat
                          "Feng Xia\n"
                          "http://fengxia.co\n")
      message-citation-line-format "On %Y-%m-%d %H:%M:%S, %f wrote:"
      message-citation-line-function 'message-insert-formatted-citation-line
      mu4e-headers-results-limit 250)


(require 'smtpmail)
;; (setq message-send-mail-function 'smtpmail-send-it
;;       starttls-use-gnutls t
;;       smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
;;       smtpmail-auth-credentials
;;       '(("smtp.gmail.com" 587 "fengxia41103@gmail.com" nil))
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587)
(setq message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials '(("smtp.live.com" 25 nil nil))
      smtpmail-auth-credentials
      '(("smtp.live.com" 25 "feng_xia41103@hotmail.com" nil))
      smtpmail-default-smtp-server "smtp.live.com"
      smtpmail-smtp-server "smtp.live.com"
      smtpmail-smtp-service 25)

(setq message-kill-buffer-on-exit t
      mu4e-sent-messages-behavior 'delete
      mu4e-headers-skip-duplicates t
      mu4e-headers-include-related t
      mail-user-agent 'mu4e-user-agent
      ;; mu4e-get-mail-command "offlineimap"
      mu4e-get-mail-command "mbsync -a"
      mu4e-update-interval 3600
      mu4e-attachment-dir  "~/Downloads"
      ;;set up queue for offline email
      ;;use mu mkdir  ~/Maildir/queue to set up first
      smtpmail-queue-mail  nil
      smtpmail-queue-dir   "~/Maildir/queue/cur")
(setq mu4e-html2text-command "html2text -utf8 -width 72")
(add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)

;; ;; chinese-pyim
;; (use-package chinese-pyim
;;   :ensure nil
;;   :config
;;   ;; 激活 basedict 拼音词库
;;   (use-package chinese-pyim-basedict
;;     :ensure nil
;;     :config (chinese-pyim-basedict-enable))

;;   ;; 五笔用户使用 wbdict 词库
;;   ;; (use-package chinese-pyim-wbdict
;;   ;;   :ensure nil
;;   ;;   :config (chinese-pyim-wbdict-gbk-enable))

;;   (setq default-input-method "chinese-pyim")

;;   ;; 我使用全拼
;;   (setq pyim-default-scheme 'quanpin)

;;   ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
;;   ;; 我自己使用的中英文动态切换规则是：
;;   ;; 1. 光标只有在注释里面时，才可以输入中文。
;;   ;; 2. 光标前是汉字字符时，才能输入中文。
;;   ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
;;   (setq-default pyim-english-input-switch-functions
;;                 '(pyim-probe-dynamic-english
;;                   pyim-probe-isearch-mode
;;                   pyim-probe-program-mode
;;                   pyim-probe-org-structure-template))

;;   (setq-default pyim-punctuation-half-width-functions
;;                 '(pyim-probe-punctuation-line-beginning
;;                   pyim-probe-punctuation-after-punctuation))

;;   ;; 开启拼音搜索功能
;;   (setq pyim-isearch-enable-pinyin-search t)

;;   ;; 使用 pupup-el 来绘制选词框
;;   (setq pyim-page-tooltip 'popup)

;;   ;; 选词框显示5个候选词
;;   (setq pyim-page-length 5)

;;   ;; 让 Emacs 启动时自动加载 pyim 词库
;;   (add-hook 'emacs-startup-hook
;;             #'(lambda () (pyim-restart-1 t)))
;;   :bind
;;   (("M-j" . pyim-convert-code-at-point) ;与 pyim-probe-dynamic-english 配合
;;    ("C-;" . pyim-delete-word-from-personal-buffer))

;;   (setq default-input-method "chinese-pyim")
;;   (global-set-key (kbd "C-\\") 'toggle-input-method))

(require 'chinese-fonts-setup)
;; 让 chinese-fonts-setup 随着 emacs 自动生效。
;; (chinese-fonts-setup-enable)
;; 让 spacemacs mode-line 中的 Unicode 图标正确显示。
;; (cfs-set-spacemacs-fallback-fonts)

;; artist
(use-package 
  artist  

  :ensure 
  :config)

(message "Emacs is ready to do thy bidding, Master %s!" current-user)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
