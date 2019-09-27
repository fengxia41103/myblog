Title: Emacs
Date: 2017-01-21 11:45
Tags: dev
Slug: emacs
Author: Feng Xia
Modified: 2019-09-26 13:40

What a wonderful editor!

I wouldn't even call it an editor because it can do so much beyond
text editing. Still on the learning curve to get a grasp of what it
can do in my daily development workflow. Here is to document the
[init.el][1] that I'm using. It's a work in progress of course since
I'm updating it all the time. Nonetheless, I'm already in love with
what I have so far.

# replace in files

Replacing a string match in multiple files is common, but
tricky. Emacs doesn't make this intuitive at all. Follow these steps
to get there:

1. `M-x find-grep-dired`
2. `Find-grep (directory)`: is to select the root folder for the scan
3. `Find-grep (grep regexp)`: is the regex for the string pattern you
   are searching, eg. `"images/` is to find anything starts with a
   double quote sign and `images/` after &larr; in my attempt to
   change image from relative path to absolute path.
4. A new buffer will open w/ the list of files that contains a match.
5. In that buffer, press `t` to select all (press `t` again will
   toggle it off).
6. Press `Q` (capital).
7. `Query replace regexp in marked files...`: 
  1. set the old string
  2. `with:`: set new string
  
    If you skip these two steps, it will use the default (the previous replacement).
8. A buffer will open showing the line that can be replaced:

  - `y`: replace it
  - `n`: skip
  - `Y`: replace all w/ YES &rarr; and watch the mini buffer showing
    "x occurance" flashing so you know replacement is happening.
  - `q`: quit
  
9. `C-x s`, then `!` to save all buffers.

I find that the easiest way to revert a mistake is to `git checkout
-f`, then start this exercise from beginning.

# email

Using Emacs for email is both awesome and tricky. Read [this][2] for
details of `mbsync` setups. On the emacs side, I'm using these in
`init.el` to link `mu4e` with `mbsync`. However, note that they are
actually two separate things, that you can run `mbsync -a` on a
terminal to get all the mails sync-ed, and `mu4e` is just an agent/UI
that displays them in emacs and giving you a couple key bindings to
manage the list. 

```lisp
;; mu42 gmail setup
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'mu4e)
(mu4e-maildirs-extension)

;;location of my maildir
(setq mu4e-maildir (expand-file-name "~/Maildir"))

;;command used to get mail
;; use this for testing
(setq mu4e-get-mail-command "true")

;;; (setq mu4e-view-prefer-html t)

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

(setq mu4e-reply-to-address "fxia1@mycompany.com"
      user-mail-address "fxia1@mycompany.com"
      user-full-name "Feng Xia"
      message-signature  (concat
                          "Feng Xia\n"
                          "http://fengxia.co\n")
      message-citation-line-format "On %Y-%m-%d %H:%M:%S, %f wrote:"
      message-citation-line-function 'message-insert-formatted-citation-line
      mu4e-headers-results-limit 500)

(setq mu4e-compose-signature
      (concat
       "Best regards,\n\n"
       "Feng Xia\n"
       "Advisory Engineer\n"
       "Datacenter Group (DCG), Mycompany US\n"
       "8000 Development Drive, Morrisville, NC 27560\n"
       "W: http://www.mycompany.com\n"))

;; save attachment to my desktop (this can also be a function)
(setq mu4e-attachment-dir "~/Downloads")

;; attempt to show images when viewing messages
(setq mu4e-view-show-images t)

(require 'smtpmail)
(setq send-mail-function 'smtpmail-send-it
      user-mail-address "fxia1@mycompany.com"
      smtpmail-debug-info t
      smtpmail-smtp-user "fxia1@mycompany.com"
      smtpmail-default-smtp-server "localhost"
      smtpmail-auth-credentials (expand-file-name "~/.authinfo")
      smtpmail-smtp-service 1025
      smtpmail-stream-type nil
      starttls-use-gnutls nil
      starttls-extra-arguments nil
      )

(setq message-kill-buffer-on-exit t
      ;; mu4e-sent-messages-behavior 'delete
      mu4e-headers-skip-duplicates t
      mu4e-headers-include-related t
      mail-user-agent 'mu4e-user-agent
      mu4e-get-mail-command "mbsync -a"
      mu4e-update-interval 300 ;; update every 5 min
      mu4e-attachment-dir  "~/Downloads"
      ;;set up queue for offline email
      ;;use mu mkdir  ~/Maildir/queue to set up first
      smtpmail-queue-mail  nil ;; queue sent mail
      smtpmail-queue-dir   "~/Maildir/queue/cur")
(setq mu4e-html2text-command "html2text -utf8 -width 72")
(add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)
```

Happy coding.

[1]: {attach}/downloads/emacs/init.el
[2]: {filename}/dev/mbsync.md
