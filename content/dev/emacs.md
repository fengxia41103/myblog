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

;;; for more customization options, check here:
;;; https://www.djcbsoftware.nl/code/mu/mu4e/HV-Overview.html#HV-Overview
(setq mu4e-headers-date-format "%b-%d %a"
      mu4e-headers-fields '((:date . 10)
			    (:flags . 5)
			    (:from-or-to . 10)
			    (:thread-subject . nil))) 

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

# Jira

If you use Jira, say the url is `https://jira.<company>.com:8443/`
(port 8443 is the common configuration for Jira), chances are it is
also using a self-signed cert. 

1. Get the cert (see [here][4]): `openssl s_client -showcerts
   -servername jira.company.com -connect jira1.company.com:8443 >
   <your jira>.crt`.

2. Copy it to `/usr/local/share/ca-certificates`, change mode to 644.
3. `sudo update-ca-certificates`, you should see sth like this:

        ```shell
        Updating certificates in /etc/ssl/certs...
        rehash: warning: skipping jira1.pem,it does not contain exactly one certificate or CRL
        1 added, 0 removed; done.
        Running hooks in /etc/ca-certificates/update.d...

        Adding debian:jira1.pem
        done.
        done.
        ```
4. Install [org-jira][3], and get all your issues! 


Here are things I put in `init.el` as global configurations:

```lisp
;; org-jira
(use-package 
  org-jira  

  :ensure 
  :config (setq org-jira-working-dir "~/org")
  :config (setq jiralib-url "https://jira1.labs.<company>.com:8443")
  :config (setq org-jira-use-status-as-todo t))

;; (setq request-message-level 'debug)
;; (setq request-log-level 'debug)

(setq org-jira-custom-jqls
      '(
        (:jql "'Epic Link' in (OL-318) AND Type = BUG and status not in (DONE, CANCELLED) ORDER BY cf[10001] ASC, Status"
              :limit 50
              :filename "CP bugs")
        (:jql "'Epic Link' in (OL-318) AND status not in (CANCELED) AND assignee WAS IN (currentUser(), aoprin, amilitaru) ORDER BY ID,status DESC"
              :limit 100
              :filename "CP")
        ))

(defconst org-jira-progress-issue-flow
  '(("Todo" . "Selected for Development")
    ("Selected for Development" . "In Progress")
    ("In Progress" . "In Review")
    ("In Review" . "In Testing")
    ("In Testing" . "Done")
    ))
```

The most useful one is to set `org-jira-use-status-as-todo`, so now a
ticket will show up as below &mdash; notice the word `BACKLOG` is a
status defined in my Jira, and it's taking place of the `TODO` in
default org-mode:

```org
** BACKLOG QA_1910: Invalid port range error message displayed, although the range is correct :OL_3205:
```

## what is not working

### workflow does not change status

```lisp
(defconst org-jira-progress-issue-flow
  '(("Todo" . "Selected for Development")
    ("Selected for Development" . "In Progress")
    ("In Progress" . "In Review")
    ("In Review" . "In Testing")
    ("In Testing" . "Done")
    ))
```

The workflow defined above actually does not change the `status` of
the Jira ticket because the `status` is shown as a property in
org-mode. So defining them here is only to make it **visually
consistent** when you move ticket in org-mode itself as if the
ticket's status is moving. You still need to use `C-c iw` to change
the status, and it will post to Jira server to actually change the
ticket.

Further, I add this header to the org file itself:

```org
#+TODO: BACKLOG(b) SELECTED-FOR-DEVELOPMENT(f) IN-PROGRESS(p) IN-REVIEW(r) IN-TESTING(t) | DONE(d)
```

### priority has no effect

org-mode priority has no effect on Jira ticket. It will be overwritten
when you pull issues again (`C-c ij` or `C-c ig`). This is one bump I
haven't figured out because it means I'll be losing info/history upon
a pull.

### multi-line comment

You can add a comment `C-c cc`, but it gives you a mini buffer of a
single line space, thus making it impossible to write multi line
comment.

However, once you add the comment, you can update the org using `C-c
ir` or `C-c iR`, which will pull jira again and update org file, thus
pulling down the new comment. Now go to the comment to add more txt,
then `C-c cu` to update comment. So even as a 2-step process, you can
write comment w/o leaving org-mode. So this is not too bad.


Happy coding.

[1]: {static}/downloads/emacs/init.el
[2]: {filename}/dev/mbsync.md
[3]: https://github.com/ahungry/org-jira
[4]: https://curl.haxx.se/docs/sslcerts.html
