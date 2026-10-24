;;; early-init.el --- loaded before package.el and the GUI -*- lexical-binding: t; -*-
;;
;; Source of truth lives in the myblog repo:
;;   content/downloads/emacs/early-init.el
;; and is symlinked to ~/.emacs.d/early-init.el.
;;
;; Emacs 27+ loads this file very early, before `package-initialize' and
;; before the first frame is created, which makes it the right place for
;; startup-performance tuning.

;; --- Garbage collection: relax during startup, restore afterward --------
;; A huge GC threshold during init avoids repeated collections while loading
;; the config; we drop it back to a sane runtime value on `emacs-startup-hook'.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024)   ; 64 MB at runtime
                  gc-cons-percentage 0.1)))

;; --- Skip file-name-handler regexps during startup ----------------------
;; Restoring the original alist afterward so TRAMP/archive handlers work.
(defvar my--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist my--file-name-handler-alist)))

;; --- Larger subprocess read buffer --------------------------------------
;; Big win for LSP servers (lsp-java/lsp-ui) which emit large JSON payloads.
(setq read-process-output-max (* 3 1024 1024))  ; 3 MB

;; --- Package system ------------------------------------------------------
;; The main init (emacs_setup) calls `package-initialize' explicitly, so we
;; leave Emacs' automatic early init enabled (default) but note it here.
;; Set to nil only if you later switch to an explicit-only bootstrap.
;; (setq package-enable-at-startup nil)

;; --- Reduce early UI work / flicker -------------------------------------
;; These frames params are applied before the first frame; the main config
;; also disables these bars, but doing it here avoids a momentary flash.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t
      frame-inhibit-implied-resize t)

;;; early-init.el ends here
