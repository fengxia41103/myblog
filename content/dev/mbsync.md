Title: You got mail
Date: 2017-04-24 10:15
Tags: dev
Slug: mbsync mu4e email
Author: Feng Xia
Modified: 2019-05-21 10:27

<figure class="col l5 m6 s12">
  <img src="images/hahn.png"
       class="center img-responsive">
</figure>

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

Its [man page][2] is worth a read. It looks intimidating at first
glance, but it isn't really. In a nutshell, it defines three things:

1. **A remote store**: this also links to an **Account**, which of
   course holds your email credentials.
2. **A local store**: this defines local file structure where you want
   to emails to be downloaded to.
3. **A channel**: a link that connects the a remote store with a local
   store.
   
<figure class="col s12">
  <img src="images/mbsync.png"
       class="center img-responsive">
  <figcaption>mbsync components</figcaption>
</figure>

# Account

**Acount** sections define your email accounts:

1. for hotmail: `imap.outlook.com`
2. for gmail:`imap.gmail.com`

```shell
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
```


## certs

Whiling setting up corporate one, for which you are likely looking at
a outlook server on the other end, I ran into an error cert is not
matching the server's.  To solve this, we actually need to pull down a
new cert (from the mail server itself) and config `CertificateFile` to
that file. I followed the steps [here][3].

[3]: https://wiki.archlinux.org/index.php/Isync#Step_.231:_Get_the_certificates

1. Create a bash script, [`get_certs.sh`][4], to facilitate the
   command line:
   
        ```shell
        #!/bin/sh
        SERVER=${1:-my.server.com}
        PORT=${2:-993}
        CERT_FOLDER=${3:-~/certs}
        openssl s_client -connect ${SERVER}:${PORT} -showcerts 2>&1 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'| sed -ne '1,/-END CERTIFICATE-/p' > ${CERT_FOLDER}/${SERVER}.pem
        ```

[4]: {filename}/downloads/emacs/get_certs.sh

2. Create a `~/.cert` directory, then run:

        ```shell
        sh get_certs.sh some.imap.server port ~/.cert/
        eg:
        sh get_certs.sh outlookae.<your company>.com 993 ~/.cert/
        ```
   
   Cert file will have a name `some.imap.server.pem`. Use that in
   `CertificateFile`.
   
Alternatively, run the cmd manually:

```shell
$ openssl s_client -connect <your server.com>:993

Example output:

---
Server certificate
-----BEGIN CERTIFICATE-----
MIIGljCCBX6gAwIBAgIQCdcdxK7NPHWJoI9zDG7qUDANBgkqhkiG9w0BAQsFADBe
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMR0wGwYDVQQDExRHZW9UcnVzdCBSU0EgQ0EgMjAxODAe
Fw0xODA0MjgwMDAwMDBaFw0xODEwMTcxMjAwMDBaMG4xCzAJBgNVBAYTAkNOMRAw
DgYDVQQIEwdiZWlqaW5nMRAwDgYDVQQHEwdiZWlqaW5nMSEwHwYDVQQKExhMZW5v
dm8gKEJlaWppbmcpIExpbWl0ZWQxGDAWBgNVBAMTD21haWwubGVub3ZvLmNvbTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAIX5GrFQTPLxep6rWrvqUmX3
+qHCVQYZDE7lXGvI+cqZSRXeYH5PE3BHoH/45u620lYvu9zcKCImeyS8klZi8ZX9
5KxFlssl6qn8kiCx/pEZbwy1XXquvIplqvCG5SN074736Pin1X1w6mSujItAdXhh
2S959hg+Vdu//b6EktMVUq1smmjtG9V4YMXPtL5Dhf744AGuuFLTMmtuJxrajQQ/
1LOI7VVgu99KLuJ4p6zpNv4Oqx9YVZE8n9iJbBBVql60VQ7nWJBTx0tMoK6S0h/B
FUdsbk3L3GV4RRGBPfj0NC4+zRLjzzvzFRePhjizBWOCAaQfkK96nw+QLXz6lT0C
AwEAAaOCAz4wggM6MB8GA1UdIwQYMBaAFJBY/7CcdahRVHex7fKjQxY4nmzFMB0G
A1UdDgQWBBTjHVASVMSS5vbUq7OaL/aZsWOMMjCBsAYDVR0RBIGoMIGlgg9tYWls
Lmxlbm92by5jb22CEW1haWx1cy5sZW5vdm8uY29tghlhdXRvZGlzY292ZXIubW90
b3JvbGEuY29tggxtb3Rvcm9sYS5jb22CEW1haWxhcC5sZW5vdm8uY29tghFtYWls
YWUubGVub3ZvLmNvbYIXYXV0b2Rpc2NvdmVyLm5lY3AuY28uanCCF2F1dG9kaXNj
b3Zlci5sZW5vdm8uY29tMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEF
BQcDAQYIKwYBBQUHAwIwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NkcDEuZGln
aWNlcnQuY29tL0dlb1RydXN0UlNBQ0EyMDE4LmNybDBMBgNVHSAERTBDMDcGCWCG
SAGG/WwBATAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20v
Q1BTMAgGBmeBDAECAjB0BggrBgEFBQcBAQRoMGYwJQYIKwYBBQUHMAGGGWh0dHA6
Ly9vY3NwMS5kaWdpY2VydC5jb20wPQYIKwYBBQUHMAKGMWh0dHA6Ly9jYWNlcnRz
Lmdlb3RydXN0LmNvbS9HZW9UcnVzdFJTQUNBMjAxOC5jcnQwCQYDVR0TBAIwADCC
AQQGCisGAQQB1nkCBAIEgfUEgfIA8AB1ALvZ37wfinG1k5Qjl6qSe0c4V5UKq1Lo
GpCWZDaOHtGFAAABYwr7gWoAAAQDAEYwRAIgBBogB6jO59BheNJs2iCL8xYZdXqW
JbP+6WTrHLptQ3wCIDZZzf0bwPNfn+nJQFf16tui94evPkb2OQysfro8lVLzAHcA
b1N2rDHwMRnYmQCkURX/dxUcEdkCwQApBo2yCJo32RMAAAFjCvuCVQAABAMASDBG
AiEA/1ncX/FX8by4rQDg5uyIXTciZBcZoySzQ1gZl9kTNggCIQCfaCniFF4cdTMK
SXCfffl3N5AwuMyr/Js35+o4dRsffjANBgkqhkiG9w0BAQsFAAOCAQEAeMf6y/dz
oEuQNV4EEdH/afHX/3Ttr9uuJ9TER7kQas5ri9e1KjZy37LpgotyspufHHPp/X2S
D5hltCLxiQg98ZOybtBeiCixKB3MTDxtGDWdYg6MfDMYx+tLeqEBLuDJ3DKg6vtj
EK6wbkJbt+fEWUz/dWVqOf/Z/ZfpFXvmKVGplxxNLJVowl2RJhXzW6XXg22ZsOXi
FB2e/JTWHrUyZAyStDDuce/BmmRMImlvCo0LdWGx5hu0ggnAq6MSOJu/m5CyVOuc
+jXvW64RwfzUVMnfCgly9pf3wkINeRQDHVtn7pnbg0fIk1xPgT5YOOrjSXZK7xwT
h4Dw9xNfks5zyQ==
-----END CERTIFICATE-----
```

Then copy and paste it to `.cert/<your cert file>.pem`.

# Stores
## Remote store

Use `IMAPStore` to pair email account with a remote. The name of
remote store is user defined.

```shell
IMAPStore gmail-remote # <-- user defined name
Account gmail # <-- the account name defined in Account section
```

## Local store

Don't quite understand this one. Default local maildir is set to
`~/Maildir` (seems to be the default).

```shell
MaildirStore gmail-local
Path ~/Maildir/Gmail/
Inbox ~/Maildir/Gmail/inbox/
```

# Channels

Defines a channel to link a `remote store` with a `local store`:
```shell
Channel gmail-inbox
Master :gmail-remote: # <-- remote store
Slave :gmail-local:inbox # <-- local dir
Create Both
Expunge Both
SyncState *
```

# Groups

This is just a batch command mode where you group a list of `channels` into
one blog which can then be evoked using command line `mbsync group-name-xyz`:

```shell
Group gmail
Channel gmail-trash
Channel gmail-inbox
Channel gmail-sent
Channel gmail-all
Channel gmail-starred
```

# mbsync config

Follow these steps to set up your local folders:

1. Copy and paste this config to `~/.mbsyncrc`.
2. Create these folders: `~/Maildir`, `~/Maildir/Hotmail`, and
   `~/Maildir/Gmail`.
3. Run command `mbsync -a`, sit back, and watch your remote emails got
   pull down and backed up locally.
4. Clear old index `rm -r ~/.mu`.
5. Run `mu index` to index local emails.

```shell
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
```

# How to list remote folders

Well, to design your pull, you need to know what is on the remote
IMAP. It turned out that each IMAP server structures things
differently, eg. using `Inbox` vs. `INBOX`, how confusing. Helped by
[this blog][5], it turned out we can _login_ into the IMAP server
(manually) and investigate what we are looking at:

[5]: https://delog.wordpress.com/2011/05/10/access-imap-server-from-the-command-line-using-openssl/

```shell
openssl s_client -crlf -connect [your company IMAP server]:993
```

Once you see something like this `* OK Gimap ready for requests from
200.199.23.105 o16if3544685ybc.1111`, you are in. There won't be any
_commandline prompt_, it just sits there. So keep going:

```shell
tag login user@company.com password
tag LIST "" "*"
```

Viol la! Look what we have got! 

```shell
tag login fxia1@company.com password
tag OK LOGIN completed.
tag LIST "" "*"
* LIST (\HasChildren) "/" Archives
* LIST (\HasNoChildren) "/" Archives/2017
* LIST (\HasNoChildren) "/" "Archives/juju mailing list"
* LIST (\HasNoChildren) "/" Calendar
* LIST (\HasNoChildren) "/" Contacts
* LIST (\Marked \HasNoChildren) "/" "Conversation History"
* LIST (\Marked \HasNoChildren) "/" "Deleted Items"
* LIST (\HasNoChildren) "/" Drafts
* LIST (\Marked \HasChildren) "/" INBOX
* LIST (\HasChildren) "/" INBOX/administration
* LIST (\HasNoChildren) "/" INBOX/administration/something
* LIST (\HasNoChildren) "/" INBOX/administration/hr
* LIST (\HasNoChildren) "/" INBOX/administration/akjd
* LIST (\HasNoChildren) "/" INBOX/administration/wow
* LIST (\HasNoChildren) "/" INBOX/administration/workday
* LIST (\HasChildren) "/" INBOX/Canonical
* LIST (\HasNoChildren) "/" INBOX/Canonical/juju
* LIST (\HasNoChildren) "/" "INBOX/home improvement"
* LIST (\HasNoChildren) "/" INBOX/miro
* LIST (\HasNoChildren) "/" "INBOX/no need to read"
* LIST (\HasChildren) "/" INBOX/team

............
```

So the key to notice here is that this
IMAP server uses capitalized **INBOX**. Therefore, to pull all
sub-folders into, we need to setup mbsync as such:

```shell
Channel your-inbox-sub
Master :your-remote:"INBOX/" <<-- must match what you saw from server, case-sensitive
Slave :your-local:inbox/
Pattern *
Create Both
Expunge Both
SyncState *
```

Now if you issue `mbsync your-inbox-sub` will pull in all `INBOX` and
**its subfolders**. Awesome.

# gmail &mdash; less secured

Sending username and pwd to login in Gmail will be blocked. A couple
things you need to do:

1. Go to `settings` and **enable** IMAP.
2. Go to https://www.google.com/settings/security/lesssecureapps to
   enable `Less secured app` setting.
3. Make sure the folder defined in `Account` section for local store
   actually exists (`mbsync` will not create `~/Maildir/Hotmail` for you!)

# Outlook webmail

<figure class="col l6 m6 s12">
  <img src="images/davmail.png"
       class="center img-responsive">
  <figcaption>davmail settings</figcaption>
</figure>


Working outlook/exchange server is tough. The company's server changes
configuration all the time, and it completly messed up w/ IMAP login
when one server allows `PLAIN` while another requires `NTLM`, and so
on. It has been a nightmare, because it worked for weeks, months, and
will suddenly decided to stop working, and you don't get emails
anymore! Fall back is Thunderbird, but then, once you are used to
`mu4e`, going back to anything looked like outlook is a pain.

Finally, here is a savior,
[davmail](http://davmail.sourceforge.net/)[^1]. It works a gateway between
your computer and outlook web mail (aka. OWA &mdash; outlook web
access). So you can now point your `mbsync` to a local port (default
`1143`, and davmail will route mbsync's IMAP requests to the remote
OWA server, nice!

The `mbsync` config is quite straightforward:

```bash

IMAPAccount company-name
Host localhost <-- using davmail as gateway
User xxx
Pass xxx
Port 1143 <-- default davmail IMAP port
SSLType None
AuthMech LOGIN
```

and here is the `davmail` [settings][1] (copy it to
`~/.davmail.properties`). The best way to run it is to use a tmux,
then run it as background process `davmail &`. Alternatively, you can
set `davmail.server=true`, then use `nohup`. But w/ tmux running
dettached session., I really don't see any benefit of doing this
anymore.

<figure class="col s12">
  <img src="images/mbsync%20setup.png"
       class="center img-responsive">
  <figcaption>My mbsync setup for retrieving and sending mails</figcaption>
</figure>


[1]: {filename}/downloads/davmail.properties
[^1]: Btw, I was having issue w/ v5.3.1. Downgrade it to 5.2 (released
    in Aug 2019) worked out better.

