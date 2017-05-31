Title: You got mail
Date: 2017-04-24 10:15
Tags: dev, emacs
Slug: mbsync mu4e email
Author: Feng Xia

After becoming an Emacs user for the last few months, I acquired a
burning desire to migrate as much as my daily text editing activities
into Emacs environment, in particular, emails.

Having tried [offlineimap][1] for a bit, I ended up battling its
configuration to make it work (sort of) with Hotmail's IMAP. Gmail
worked flawlessly, but boy, Microsoft, get a grip. No wonder hotmail
is dying. But in the end I'm just one guy who holds on something
linking my youth days, for sentimental purpose. So without being able
to win the battle with offlineimap, I started searching for
alternatives, then I found [mbsync][2].

[1]: https://github.com/OfflineIMAP/offlineimap
[2]: http://isync.sourceforge.net/mbsync.html

Its [man page][2] is worth a read. It looking intimating at first
glance, but it isn't really. In a nutshell, it defines three things:

1. <span class="myhighlight">A remote store</span>: this also links to
   an **Account**, which of course
   holds your email credentials.
2. <span class="myhighlight">A local store</span>: this defines local
   file structure where you want to
   emails to be downloaded to.
3. <span class="myhighlight">A channel</span>: a link that connects
   the a remote store with a local store.
   
<figure class="col-md-8 col-sm-8">
  <img src="/images/mbsync.png"
       class="center-block img-responsive">
  <figcaption>mbsync components</figcaption>
</figure>

# Account

**Acount** sections define your email accounts:

1. for <span class="myhighlight">hotmail</span>: `imap.outlook.com`
2. for <span class="myhighlight">gmail</span>:`imap.gmail.com`

<pre class="brush:plain;">
# Hotmail account
IMAPAccount hotmail # <-- user defined name
Host imap.outlook.com # or imap.gmail.com
User yours email address
Pass xxxx

# These settings work for both gmail and hotmail
UseIMAPS yes
RequireSSL yes

# This might be Ubuntu 16.04 specific
CertificateFile /etc/ssl/certs/ca-certificates.crt
</pre>

# Stores
## Remote store

Use `IMAPStore` to pair email account with a remote. The name of
remote store is user defined.

<pre class="brush:plain;">
IMAPStore gmail-remote # <-- user defined name
Account gmail # <-- the account name defined in Account section
</pre>

## Local store

Don't quite understand this one. Default local maildir is set to
`~/Maildir` (seems to be the defaul).

<pre class="brush:plain;">
MaildirStore gmail-local
Path ~/Maildir/Gmail/
Inbox ~/Maildir/Gmail/inbox/
</pre>

# Channels

Defines a channel to link a `remote store` with a `local store`:
<pre class="brush:plain;">
Channel gmail-inbox
Master :gmail-remote: # <-- remote store
Slave :gmail-local:inbox # <-- local dir
Create Both
Expunge Both
SyncState *
</pre>

# Groups

This is just a batch command mode where you group a list of `channels` into
one blog which can then be evoked using command line `mbsync group-name-xyz`:

<pre class="brush:plain;">
Group gmail
Channel gmail-trash
Channel gmail-inbox
Channel gmail-sent
Channel gmail-all
Channel gmail-starred
</pre>

# mbsync config

Follow these steps to set up your local folders:

1. Copy and paste this config to `~/.mbsyncrc`.
2. Create these folders: `~/Maildir`, `~/Maildir/Hotmail`, and
   `~/Maildir/Gmail`.
3. Run command `mbsync -a`, sit back, and watch your remote emails got
pull down and backed up locally.
4. Clear old index `rm -r ~/.mu`.
5. Run `mu index` to index local emails.

<pre class="brush:plain;">
# mbsyncrc based on
# http://www.ict4g.net/adolfo/notes/2014/12/27/EmacsIMAP.html
# ACCOUNT INFORMATION

############################################
#
#       Accounts
#
###########################################
# Hotmail account
IMAPAccount hotmail
# Address to connect to
Host imap.outlook.com
User yours@hotmail.com
Pass xxxx
UseIMAPS yes
RequireSSL yes
CertificateFile /etc/ssl/certs/ca-certificates.crt


# Gmail account
IMAPAccount gmail
# Address to connect to
Host imap.gmail.com
User yours@gmail.com
Pass xxxx
UseIMAPS yes
RequireSSL yes
CertificateFile /etc/ssl/certs/ca-certificates.crt

############################################
#
#       IMAP stores
#
###########################################

# THEN WE SPECIFY THE LOCAL AND REMOTE STORAGE
# - THE REMOTE STORAGE IS WHERE WE GET THE MAIL FROM (E.G., THE
#   SPECIFICATION OF AN IMAP ACCOUNT)
# - THE LOCAL STORAGE IS WHERE WE STORE THE EMAIL ON OUR COMPUTER

# REMOTE STORAGE (USE THE IMAP ACCOUNT SPECIFIED ABOVE)
IMAPStore gmail-remote
Account gmail

# LOCAL STORAGE (CREATE DIRECTORIES with mkdir -p Maildir/gmail)
MaildirStore gmail-local
Path ~/Maildir/Gmail/
Inbox ~/Maildir/Gmail/inbox/

IMAPStore hotmail-remote
Account hotmail

MaildirStore hotmail-local
Path ~/Maildir/Hotmail/
Inbox ~/Maildir/Hotmail/inbox/

############################################
#
#       gmail channels
#
###########################################

# CONNECTIONS SPECIFY LINKS BETWEEN REMOTE AND LOCAL FOLDERS
#
# CONNECTIONS ARE SPECIFIED USING PATTERNS, WHICH MATCH REMOTE MAIl
# FOLDERS. SOME COMMONLY USED PATTERS INCLUDE:
#
# 1 "*" TO MATCH EVERYTHING
# 2 "!DIR" TO EXCLUDE "DIR"
# 3 "DIR" TO MATCH DIR
Channel gmail-inbox
Master :gmail-remote:
Slave :gmail-local:inbox
Create Both
Expunge Both
SyncState *

Channel gmail-trash
Master :gmail-remote:"[Gmail]/Trash"
Slave :gmail-local:trash
Create Both
Expunge Both
SyncState *

Channel gmail-all
Master :gmail-remote:"[Gmail]/All Mail"
Slave :gmail-local:all
Create Both
Expunge Both
SyncState *

Channel gmail-sent
Master :gmail-remote:"[Gmail]/Sent Mail"
Slave :gmail-local:sent
Create Both
Expunge Both
SyncState *

Channel gmail-allChannel gmail-starred
Master :gmail-remote:"[Gmail]/Starred"
Slave :gmail-local:starred
Create Both
Expunge Both
SyncState *


############################################
#
#       hotmail channels
#
###########################################

Channel hotmail-trash
Master :hotmail-remote:"Trash"
Slave :hotmail-local:trash
Create Both
Expunge Both
SyncState *

Channel hotmail-inbox
Master :hotmail-remote:"Inbox"
Slave :hotmail-local:inbox
Create Both
Expunge Both
SyncState *

# This will pull subfolders in /Inbox/
# and create ".sth" for each subdir
Channel hotmail-inbox-sub
Master :hotmail-remote:"Inbox/"
Slave :hotmail-local:inbox/
Pattern *
Create Both
Expunge Both
SyncState *


Channel hotmail-chat
Master :hotmail-remote:"cHAT"
Slave :hotmail-local:chat
Create Both
Expunge Both
SyncState *

Channel hotmail-sent
Master :hotmail-remote:"Sent"
Slave :hotmail-local:sent
Create Both
Expunge Both
SyncState *



############################################
#
#       groups -- they are batch commands
#
###########################################

# GROUPS PUT TOGETHER CHANNELS, SO THAT WE CAN INVOKE
# MBSYNC ON A GROUP TO SYNC ALL CHANNELS
#
# FOR INSTANCE: "mbsync hotmail" GETS MAIL FROM
# "hotmail-inbox", "hotmail-sent", and "hotmail-trash"

Group gmail
Channel gmail-trash
Channel gmail-inbox
Channel gmail-sent
Channel gmail-all
Channel gmail-starred

Group hotmail
Channel hotmail-trash
Channel hotmail-inbox
Channel hotmail-inbox-sub
Channel hotmail-chat
Channel hotmail-sent
</pre>

