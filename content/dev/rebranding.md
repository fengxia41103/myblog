Title: Rebranding
Date: 2019-09-11 16:15
Tags: dev
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
   
<hr />

Below is an example output (in `.md` format):


# Search criteria


- root folder: 
    - /home/fengxia/workspace/myblog

- matching key words: 
    - whatever

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

### AWS S3


## Emails


# Files skipped

# Matched by "whatever"


## File type: ".md":

- /home/fengxia/workspace/myblog/content/dev/browser proxy.md

    1. on line #42: `3. `SOCKS Host` to `localhost`, and port to `8080` (whatever the`
- /home/fengxia/workspace/myblog/content/dev/django and rest.md

    1. on line #16: `using things like Angular, react, and whatever you fancy. I have tried`
- /home/fengxia/workspace/myblog/content/dev/kvm.md

    1. on line #352: ``ubuntu` user login using the `password` value you defined here, eg. `whatever001`.`

    2. on line #360: `password: whatever001`
- /home/fengxia/workspace/myblog/content/dev/pandoc.md

    1. on line #230: `Quite simple: write &rarr; make <whatever> &rarr; view &rarr; repeat.`
- /home/fengxia/workspace/myblog/content/dev/rebranding.md

    1. on line #17: `find a string `whatever` (old brand), replace it w/ `feng` (new`
- /home/fengxia/workspace/myblog/content/pages/about.md

    1. on line #43: `problem, whatever it is. This isn't a shopping experience like others`
- /home/fengxia/workspace/myblog/content/thoughts/a song.md

    1. on line #79: `with her? even if the place is called hell or whatever, I think it's`
- /home/fengxia/workspace/myblog/content/thoughts/accelerated anonymity.md

    1. on line #26: `really, just whatever image I want to project of myself, that's the`
- /home/fengxia/workspace/myblog/content/thoughts/age and maturity.md

    1. on line #58: `center of a person's universe, and being appreciated for whatever you`
- /home/fengxia/workspace/myblog/content/thoughts/ai.md

    1. on line #77: `so called deep learning or AI or whatever fancy words you know, this`
- /home/fengxia/workspace/myblog/content/thoughts/another friday.md

    1. on line #38: `whatever the reason they looked totally crappy on the camera's`
- /home/fengxia/workspace/myblog/content/thoughts/bad day.md

    1. on line #17: `whatever life has it for me, trash me to the ground, and better just`
- /home/fengxia/workspace/myblog/content/thoughts/bizzare logic.md

    1. on line #57: `Honestly, I really think everything, good or bad or whatever, is`
- /home/fengxia/workspace/myblog/content/thoughts/boston and other thoughts.md

    1. on line #61: `by, watching the people go by, watching myself, whatever is left of`
- /home/fengxia/workspace/myblog/content/thoughts/china witness.md

    1. on line #150: `> myself. Whatever were they were thinking of, hanging a picture of a`
- /home/fengxia/workspace/myblog/content/thoughts/class.md

    1. on line #84: `So, call it whatever you want, and feel free to agree or disagree this`
- /home/fengxia/workspace/myblog/content/thoughts/data digit.md

    1. on line #46: `data,  one  says  "Bob  whatever"   and  the  other  says  "William`

    2. on line #47: `whatever", are these two the  same person!? and what reference/clue`
- /home/fengxia/workspace/myblog/content/thoughts/dictator.md

    1. on line #38: `whatever it is, questionable also? What about other words, probably`
- /home/fengxia/workspace/myblog/content/thoughts/generalization.md

    1. on line #99: `based on race, gender, education, family tie, whatever (and these are`
- /home/fengxia/workspace/myblog/content/thoughts/history.md

    1. on line #116: `they are named, mummy, gold, or whatever.`
- /home/fengxia/workspace/myblog/content/thoughts/human grouping.md

    1. on line #23: `reality is, this person, your idol, do not know you, and whatever s/he`

    2. on line #55: `and good luck and whatever! We are so uncomfortable with ourselves`
- /home/fengxia/workspace/myblog/content/thoughts/hurt feeling.md

    1. on line #30: `sad, or whatever, no one else can. If not, it becomes a scary thing,`
- /home/fengxia/workspace/myblog/content/thoughts/innovation.md

    1. on line #46: ``google`, `BAT`, `R`, `AI`...  Whatever the problem is, or even the`

    2. on line #160: `whatever their coding language is, they can all do the same thing, and`
- /home/fengxia/workspace/myblog/content/thoughts/internet.md

    1. on line #83: `in the subjective sphere, all bets are off &mdash; I can say whatever`

    2. on line #84: `I want, and you can hear whatever you like &mdash; it's a fair game`

    3. on line #98: `company of that media, while whatever is circulating on the Internet`
- /home/fengxia/workspace/myblog/content/thoughts/irresponsible response.md

    1. on line #89: `warned you, so whatever you end up with is not my responsibility`
- /home/fengxia/workspace/myblog/content/thoughts/logic.md
- /home/fengxia/workspace/myblog/content/thoughts/luck.md

    1. on line #29: `result, whatever it may be, pleasant or horrible.`

    2. on line #86: `reference! You make a decision, then you move on. Whatever comes out`
- /home/fengxia/workspace/myblog/content/thoughts/marketing.md

    1. on line #105: `wonderful the outcome in the future may be</span>. Whatever it is`
- /home/fengxia/workspace/myblog/content/thoughts/moment of quietness.md

    1. on line #35: `girlfriend, or just a one-night-stand. Whatever, there is a song, that`
- /home/fengxia/workspace/myblog/content/thoughts/moving.md

    1. on line #69: `expect. Whatever it may be, I am just hoping I can stay true, to`
- /home/fengxia/workspace/myblog/content/thoughts/must do.md

    1. on line #108: `(what-is-happiness kind of talk).... whatever it is called, I want to`
- /home/fengxia/workspace/myblog/content/thoughts/ordinary.md

    1. on line #68: `whatever is happening, I will be on your side.`
- /home/fengxia/workspace/myblog/content/thoughts/plagarism.md

    1. on line #45: `essentially, whatever the virtue to make a good human being, is what`
- /home/fengxia/workspace/myblog/content/thoughts/reader digest.md

    1. on line #46: `than I am, so his/her view and summary of the book/article/whatever`
- /home/fengxia/workspace/myblog/content/thoughts/say no.md

    1. on line #45: `to difficult times, if you decide it is worthwhile, for whatever`
- /home/fengxia/workspace/myblog/content/thoughts/science.md

    1. on line #142: `for themselves whatever their agenda is. **Science is a view, and as`
- /home/fengxia/workspace/myblog/content/thoughts/self-disciplined.md

    1. on line #56: `it police, or whatever you want, but that doesn't change the nature of`
- /home/fengxia/workspace/myblog/content/thoughts/self-esteem.md

    1. on line #37: `wrinkle, or weight, or whatever that may be bothering you, the`
- /home/fengxia/workspace/myblog/content/thoughts/self-selected bias.md

    1. on line #65: `weaker and weaker, for whatever reason. Someone's had died down long`
- /home/fengxia/workspace/myblog/content/thoughts/silence.md

    1. on line #50: `them would pull out the iphone (or whatever) and.. and there is no`

    2. on line #66: `to touch or kiss him? but then his wife (or gf, or whatever) has a`

    3. on line #102: `gift or present or handbags or roses or whatever?`
- /home/fengxia/workspace/myblog/content/thoughts/social media.md

    1. on line #118: `much!? I know one, and you probably have, whatever, a few, a`

    2. on line #221: `man or whatever, another who enjoys computer, another who loves`
- /home/fengxia/workspace/myblog/content/thoughts/society.md

    1. on line #91: `take-for-granted attitude that science is better than (whatever your`

    2. on line #102: `in whatever you are arguing about]?`
- /home/fengxia/workspace/myblog/content/thoughts/strange fate.md

    1. on line #51: `this `bugbounty10378` guy, for whatever purpose (but honestly, doesn't`
- /home/fengxia/workspace/myblog/content/thoughts/tears.md

    1. on line #38: `that I wanted to stop it, to stop whatever that caused her`
- /home/fengxia/workspace/myblog/content/thoughts/the wrong elite.md

    1. on line #66: `blood.. that's totally fine, which also makes the whatever derived`

    2. on line #78: `countries or ppl or whatever, wouldn't you then draw the opposite`

    3. on line #170: `people are an unity, therefore whatever technology US has developed is`
- /home/fengxia/workspace/myblog/content/thoughts/to nianyi.md

    1. on line #56: `doing, and I made the choices without regret. So whatever they lead`
- /home/fengxia/workspace/myblog/content/thoughts/too much trust.md
- /home/fengxia/workspace/myblog/content/thoughts/turtle.md

    1. on line #37: `on the road or drive by your ex- whatever, or a clothes that makes you`

    2. on line #73: `smoke break, or a coffee break, so the turtle is taking its **whatever`
- /home/fengxia/workspace/myblog/content/workspace/openstack/hw_charm.md

    1. on line #306: `repo: https://git.launchpad.net/whatever/`
- /home/fengxia/workspace/myblog/content/workspace/openstack/juju_deploy_charm.md

    1. on line #16: `whatever needed based the charm's instruction. As the bootstrap`

    2. on line #110: `_whateverusername_. We intentionally avoided using _ubuntu_ as user`
- /home/fengxia/workspace/myblog/content/workspace/openstack/maas.md

    1. on line #78: `completly arbitrary. Use whatever network range you want to`
- /home/fengxia/workspace/myblog/content/workspace/rh/satellite.md

    1. on line #351: `repo. You get whatever content views give you, and each environment`

## Is a reference

We think they are file reference or URL link. Changing a value needs cross check.


None

## Is an email address


None

<hr />

Pretty cool, huh!?

[1]: https://github.com/fengxia41103/dev/blob/master/code%20analysis/fancy_string_search.py
