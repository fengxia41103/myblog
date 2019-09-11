Title: Rebranding
Date: 2019-09-11 16:15
Tags: lenovo
Slug: rebranding
Author: Feng Xia


Rebranding is a common task. The core of it is how to evaluate your
code base to pick up interested artifacts &larr; brand
indicator. Definition of these artifacts are highly contextual,
meaning that a string `feng` can mean a variable, or a string literal,
or something else. Think of it, how many programming languages in your
application stack, and how many different comment styles there are!?
Crazy.

So let's start w/ the most basic &mdash; string literal &mdash; if I
find a string `whatever` (old brand), replace it w/ `feng` (new
brand).

# the how

The script can be found [here][1]. The idea is to:

1. Walk through `root` folder and its subfolders and files.
2. File is selected by its extension &mdash;  an exclusion list and an inclusion
   list. Exclusion has a default list to exclude all binary formats,
   eg. `.png`.
3. Open the file as text file, search line by line whether interested
   pattern in found.
   
  1. If found, log down the file full path, line number, and original
     line text.
4. Identify `reference`, which is defined as `/<.....>` &mdash; this
   covers reference to a URL or an external file. This is important
   because it means the string has external dependency of some sort
   and requires further coordination.
   
5. Identify `emails`. Emails can be viewed as another form of external
   references, eg. `support@yourcompany.com`. You want to investigate
   what this email is for, and find an equivalent.

An example to use this tool:

```shell
python fancy_string_search.py check-brand-reference \
  --exclude-folders
  node_modules,fonts,contrib,.git,doc,output,bower_components,plugins \
  --search-for whatever \
  --include-extensions md \
  --no-split-target \
  ~/workspace/myblog
```

# example

Below is an example output (in [pandoc][2] .md format):

```markdown
---
title: Rebranding Analysis Report
---

# Search criteria


- root folder: 
    - /home/fengxia/workspace/myblog

- matching key words: 
    - cliche
    - gmail

- include extensions: 
    - .md

- exclude extensions: 
    - .
    - .bz2
    - .tar.gz
    - .bz
    - .gz
    - .xz
    - .ico
    - .png
    - .jpg
    - .pdf
    - .dia
    - .db
    - .exe
    - .war
    - .rpm
    - .sasldb
    - .der
    - .p12
    - .jar
    - .mmdb
    - .bak
    - .yml_example
    - .properties
    - .docx
    - .doc
    - .spec
    - .pyc
    - .jpeg
    - .mp4
    - .gif
    - .webm
    - .autosave
    - .ttf
    - .svg
    - .gzip
    - .woff
    - .eot

- exclude folder patterns: 
    - node_modules
    - fonts
    - contrib
    - .git
    - doc
    - output
    - bower_components
    - plugins

- exclude string patterns: 

# Swap needed


## External references

They seem to be some reference to externals such as URLs. Need a value to swap.

1. `[Gmail]/Starred`

1. `[Gmail]/All Mail`

1. `[Gmail]/Trash`

1. `[Gmail]/Sent Mail`

### AWS S3


## Emails


1. `yours@gmail.com`

1. `NARENDRA REDDY <bugbounty10378@gmail.com`

# Files skipped

# Matched by "cliche"


## File type: ".md":

- /home/fengxia/workspace/myblog/content/dev/rebranding.md

    1. on line #66: `- cliche`

    2. on line #139: `# Matched by "cliche"`

    3. on line #146: `1. on line #15: `criticized, hated (no I don't hate this program, just the cliche``

    4. on line #149: `1. on line #70: `be. This may sound like a cliche, typical middle age crisis, poor guy.``

    5. on line #152: `1. on line #68: `traditional political cliches. But now, I feel he is a total disaster,``

    6. on line #155: `1. on line #96: `The fundamental law here is the cliche that **there is no free``

    7. on line #158: `1. on line #33: `frustrated, even hatred. This can't be just a myth, a cliche that``

    8. on line #161: `1. on line #16: `It's a cliche when people talk about luck, and someone gets lucky, or``

    9. on line #164: `1. on line #32: `again, which is often a cliche to my education and my generation, when``

    10. on line #167: `1. on line #105: `matter, let's just use the cliche name, **progress**... then, what are``

    11. on line #170: `1. on line #17: `On one hand, the cliche is always that mid-age is a tough time because``

    12. on line #173: `1. on line #52: `becoming a cliche, and are being used freely without clarification nor``

    13. on line #176: `1. on line #153: `Even further, as we all know the cliche, hate and love are like twins``

    14. on line #179: `1. on line #91: `cliche in love scene, that if your relationships always go sore in the``

    15. on line #182: `1. on line #105: `it is an everyday cliche to have wifi and iPhone, but back to 500``
- /home/fengxia/workspace/myblog/content/thoughts/a vain debate pattern.md

    1. on line #15: `criticized, hated (no I don't hate this program, just the cliche`
- /home/fengxia/workspace/myblog/content/thoughts/city.md

    1. on line #70: `be. This may sound like a cliche, typical middle age crisis, poor guy.`
- /home/fengxia/workspace/myblog/content/thoughts/law.md

    1. on line #68: `traditional political cliches. But now, I feel he is a total disaster,`
- /home/fengxia/workspace/myblog/content/thoughts/lost job.md

    1. on line #96: `The fundamental law here is the cliche that **there is no free`
- /home/fengxia/workspace/myblog/content/thoughts/love life.md

    1. on line #33: `frustrated, even hatred. This can't be just a myth, a cliche that`
- /home/fengxia/workspace/myblog/content/thoughts/luck.md

    1. on line #16: `It's a cliche when people talk about luck, and someone gets lucky, or`
- /home/fengxia/workspace/myblog/content/thoughts/mind.md

    1. on line #32: `again, which is often a cliche to my education and my generation, when`
- /home/fengxia/workspace/myblog/content/thoughts/mob.md

    1. on line #105: `matter, let's just use the cliche name, **progress**... then, what are`
- /home/fengxia/workspace/myblog/content/thoughts/must do.md

    1. on line #17: `On one hand, the cliche is always that mid-age is a tough time because`
- /home/fengxia/workspace/myblog/content/thoughts/reflection on technology.md

    1. on line #52: `becoming a cliche, and are being used freely without clarification nor`
- /home/fengxia/workspace/myblog/content/thoughts/society.md

    1. on line #153: `Even further, as we all know the cliche, hate and love are like twins`
- /home/fengxia/workspace/myblog/content/thoughts/technology responsibility.md

    1. on line #91: `cliche in love scene, that if your relationships always go sore in the`
- /home/fengxia/workspace/myblog/content/thoughts/the wrong elite.md

    1. on line #105: `it is an everyday cliche to have wifi and iPhone, but back to 500`

## Is a reference

We think they are file reference or URL link. Changing a value needs cross check.


None

## Is an email address


None

# Matched by "gmail"


## File type: ".md":

- /home/fengxia/workspace/myblog/content/dev/mbsync.md

    1. on line #18: `configuration to make it work (sort of) with Hotmail's IMAP. Gmail`

    2. on line #49: `2. for gmail:`imap.gmail.com``

    3. on line #54: `Host imap.outlook.com # or imap.gmail.com`

    4. on line #58: `# These settings work for both gmail and hotmail`

    5. on line #159: `IMAPStore gmail-remote # <-- user defined name`

    6. on line #160: `Account gmail # <-- the account name defined in Account section`

    7. on line #169: `MaildirStore gmail-local`

    8. on line #170: `Path ~/Maildir/Gmail/`

    9. on line #171: `Inbox ~/Maildir/Gmail/inbox/`

    10. on line #178: `Channel gmail-inbox`

    11. on line #179: `Master :gmail-remote: # <-- remote store`

    12. on line #180: `Slave :gmail-local:inbox # <-- local dir`

    13. on line #192: `Group gmail`

    14. on line #193: `Channel gmail-trash`

    15. on line #194: `Channel gmail-inbox`

    16. on line #195: `Channel gmail-sent`

    17. on line #196: `Channel gmail-all`

    18. on line #197: `Channel gmail-starred`

    19. on line #206: ``~/Maildir/Gmail`.`

    20. on line #233: `# Gmail account`

    21. on line #234: `IMAPAccount gmail`

    22. on line #236: `Host imap.gmail.com`

    23. on line #237: `User yours@gmail.com`

    24. on line #255: `IMAPStore gmail-remote`

    25. on line #256: `Account gmail`

    26. on line #258: `# LOCAL STORAGE (CREATE DIRECTORIES with mkdir -p Maildir/gmail)`

    27. on line #259: `MaildirStore gmail-local`

    28. on line #260: `Path ~/Maildir/Gmail/`

    29. on line #261: `Inbox ~/Maildir/Gmail/inbox/`

    30. on line #272: `#       gmail channels`

    31. on line #284: `Channel gmail-inbox`

    32. on line #285: `Master :gmail-remote:`

    33. on line #286: `Slave :gmail-local:inbox`

    34. on line #291: `Channel gmail-trash`

    35. on line #292: `Master :gmail-remote:"[Gmail]/Trash"`

    36. on line #293: `Slave :gmail-local:trash`

    37. on line #298: `Channel gmail-all`

    38. on line #299: `Master :gmail-remote:"[Gmail]/All Mail"`

    39. on line #300: `Slave :gmail-local:all`

    40. on line #305: `Channel gmail-sent`

    41. on line #306: `Master :gmail-remote:"[Gmail]/Sent Mail"`

    42. on line #307: `Slave :gmail-local:sent`

    43. on line #312: `Channel gmail-allChannel gmail-starred`

    44. on line #313: `Master :gmail-remote:"[Gmail]/Starred"`

    45. on line #314: `Slave :gmail-local:starred`

    46. on line #379: `Group gmail`

    47. on line #380: `Channel gmail-trash`

    48. on line #381: `Channel gmail-inbox`

    49. on line #382: `Channel gmail-sent`

    50. on line #383: `Channel gmail-all`

    51. on line #384: `Channel gmail-starred`

    52. on line #465: `# gmail &mdash; less secured`

    53. on line #467: `Sending username and pwd to login in Gmail will be blocked. A couple`
- /home/fengxia/workspace/myblog/content/thoughts/strange fate.md

    1. on line #26: `KANDULA.VENKATA NARENDRA REDDY <bugbounty10378@gmail.com>`

## Is a reference

We think they are file reference or URL link. Changing a value needs cross check.

- /home/fengxia/workspace/myblog/content/dev/mbsync.md

    1. on line #292: `Master :gmail-remote:"[Gmail]/Trash"`

    2. on line #299: `Master :gmail-remote:"[Gmail]/All Mail"`

    3. on line #306: `Master :gmail-remote:"[Gmail]/Sent Mail"`

    4. on line #313: `Master :gmail-remote:"[Gmail]/Starred"`

## Is an email address

- /home/fengxia/workspace/myblog/content/dev/mbsync.md

    1. on line #237: `User yours@gmail.com`
- /home/fengxia/workspace/myblog/content/thoughts/strange fate.md

    1. on line #26: `KANDULA.VENKATA NARENDRA REDDY <bugbounty10378@gmail.com>`

```

Pretty cool, huh!?


[1]: https://github.com/fengxia41103/dev/blob/master/code%20analysis/fancy_string_search.py
[2]: {filename}/dev/pandoc.md
