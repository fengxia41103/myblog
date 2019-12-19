Title: Jira
Date: 2019-10-23 13:00
Slug: jira
Author: Feng Xia
Modified: 2019-12-18 08:31

<figure class="col s12">
  <img src="images/jira.gif"/>
</figure>


Jira is, tough. I have been searching a solution to make my Jira life
easy. The problems I want to fix are:

1. Loading browser is too slow &larr; how many times I just want to
   get a view of the comment or description so to refresh my memory.
2. Navigating from one ticket to another is to open a new tab, but
   that just clutter my browser. Very soon I don't remember which tab
   is for which ticket, so ended up openning the same jira over and
   over.
3. To switch its status is again, to load page, click some kind of
   dropdown, then click to select &rarr; 3 clicks. No, I already know
   what status I want it to be, so I want to simplify this.
4. \#3 also applies to reassign a ticket to someone &mdash; there are
   usually only a handful ppl you deal w/ on a daily basis during
   development. Instead of waiting for the spinning wheel to come up
   the name, just memorize the user's name, and assign.
5. This is actually the very first reason got me to look into an
   alternative solution than using a browser &mdash; **create ticket**
   is very tedious! I dislike filling that form very much. Again,
   usually I already know the value I want to use, so a cheat was to
   _clone_ an existing one. But then, finding an adequate existing one
   is time consuming also. So again, to simplify this is a big win.
6. Filters. Too many times there are this view, that view &mdash; I
   want to see all my stories, or all my bugs, or just high priority
   bugs, or just the ones created today, or all bugs associated w/ the
   theme I'm working on because I need to coordinate developers on the
   work.... the list goes on and on, and I know, there is the filter,
   which is nothing but a web version of the JQL query. So why the
   hassle of creating a whole bunch of filters, then the browser takes
   a long time to load, and that filter gives you a **long list of
   fields** you can display! But hell, I only care a few fields which
   the team uses, so even to hunt down the fields that is useful to me
   is time consuming. I want to use the JQL and a list of fields that
   has valuable info, no more, no less.
   
So the journey goes w/ a weekend try starting w/ [org-jira][1], which
looked very promising! I thought it would also be a good way to learn
org-mode. But hell, the org-mode itself is really slow! Just a small
org file of my bugs make the entire emacs choking to death. WTF!

Long story short. Here is the [go-jira][2], incredibly fast, and
useful! It's a command line ([download here][3]), just copy it to
`/usr/local/bin` and type `jira help`:

```shell
╰─➤  jira help
usage: jira [<flags>] <command> [<args> ...]

Jira Command Line Interface

Global flags:
      --help                   Show context-sensitive help (also try --help-long and --help-man).
  -v, --verbose ...            Increase verbosity for debugging
  -e, --endpoint=ENDPOINT      Base URI to use for Jira
  -k, --insecure               Disable TLS certificate verification
  -Q, --quiet                  Suppress output to console
      --unixproxy=UNIXPROXY    Path for a unix-socket proxy
      --socksproxy=SOCKSPROXY  Address for a socks proxy
  -u, --user=USER              user name used within the Jira service
      --login=LOGIN            login name that corresponds to the user used for authentication

Commands:
  help:                Show help.
  version:             Prints version
  acknowledge:         Transition issue to acknowledge state
  assign:              Assign user to issue
  attach create:       Attach file to issue
  attach get:          Fetch attachment
  attach list:         Prints attachment details for issue
  attach remove:       Delete attachment
  backlog:             Transition issue to Backlog state
  block:               Mark issues as blocker
  browse:              Open issue in browser
  close:               Transition issue to close state
  comment:             Add comment to issue
  component add:       Add component
  components:          Show components for a project
  create:              Create issue
  createmeta:          View 'create' metadata
  done:                Transition issue to Done state
  dup:                 Mark issues as duplicate
  edit:                Edit issue details
  editmeta:            View 'edit' metadata
  epic add:            Add issues to Epic
  epic create:         Create Epic
  epic list:           Prints list of issues for an epic with optional search criteria
  epic remove:         Remove issues from Epic
  export-templates:    Export templates for customizations
  fields:              Prints all fields, both System and Custom
  in-progress:         Transition issue to Progress state
  issuelink:           Link two issues
  issuelinktypes:      Show the issue link types
  issuetypes:          Show issue types for a project
  labels add:          Add labels to an issue
  labels remove:       Remove labels from an issue
  labels set:          Set labels on an issue
  list:                Prints list of issues for given search criteria
  login:               Attempt to login into jira server
  logout:              Deactivate session with Jira server
  rank:                Mark issues as blocker
  reopen:              Transition issue to reopen state
  request:             Open issue in requestr
  resolve:             Transition issue to resolve state
  start:               Transition issue to start state
  stop:                Transition issue to stop state
  subtask:             Subtask issue
  take:                Assign issue to yourself
  todo:                Transition issue to To Do state
  transition:          Transition issue to given state
  transitions:         List valid issue transitions
  transmeta:           List valid issue transitions
  unassign:            Unassign an issue
  unexport-templates:  Remove unmodified exported templates
  view:                Prints issue details
  vote:                Vote up/down an issue
  watch:               Add/Remove watcher to issue
  worklog add:         Add a worklog to an issue
  worklog list:        Prints the worklog data for given issue
  session:             Attempt to login into jira server
```

# templates

This thing is really sick. It uses YAML template to handle all the
data posting back to the Jira server. Thus, you are dealing w/ a list
of yaml files to tweak what data fields you want to use in an
action. But two most useful ones are: [table][4] and [create][5].

## `table` template

[This][4] is the primary table template to display a list of things, the
same idea in jira browser when you on a list view. Since this is to
display on a terminal, nothing fancy is required, just straightforward
string to compose a _table_ look. The key to success is to:

1. know what `fields` are available
2. some knowledge of this strange [hugo syntax][6]. It's quite like
   Jinja2, the concept is the same, just different syntax. One thing I
   find useful is its [functions][7], so you can do a bit of extra in
   the template. But overall, writing template is not pleasant, but
   it's a one-time deal, so it's ok.
   
What it looks like is pretty slick! &rarr;

```plain
╰─➤  jira cp-bug-mine                                                                                    1 ↵
| OL-3228 | QA_1910:User management section incorrectly r... | B | In T | fxia1      | M | 19 days
| OL-3482 | Nav area font is not high contrast enough        | B | Sele | fxia1      | M | 4 days
| OL-3453 | Storage HA failed notification - contact info... | B | Sele | fxia1      | M | 6 days
| OL-3342 | QA_1910_chat box icon is not visible in login... | B | Sele | fxia1      | M | 14 days
| OL-3327 | QA_1910:Shut Down failed for application inst... | B | In P | fxia1      | H | 14 days
| OL-3326 | QA_1910: Chat support box is grey'ed out         | B | In P | fxia1      | H | 14 days
| OL-3241 | QA_1910: Lenovo EULA in create account page s... | B | In P | fxia1      | H | 19 days
| OL-3560 | QA_1910_Empty extra cell in Network Reosurces    | B | Back | fxia1      | M | a day
| OL-3552 | QA_1910- Cloud controller version is displaye... | B | Back | fxia1      | H | a day
| OL-3551 | QA_1910 - User guide page is not loaded with ... | B | Back | fxia1      | M | a day
| OL-3549 | QA_1910_Shows cloudistics fav icon for a second  | B | Back | fxia1      | M | a day
| OL-3548 | QA_1910_Lenovo cloud market place filter by l... | B | Back | fxia1      | M | a day
| OL-3546 | QA_1910_change filter by label color             | B | Back | fxia1      | M | a day
| OL-3545 | QA_1910: The Lenovo logo from main login page... | B | Back | fxia1      | M | a day
| OL-3544 | QA_1910: The links to User guide and Legal In... | B | Back | fxia1      | M | a day
| OL-3532 | QA_1910 - Chat box chat information is displa... | B | Back | fxia1      | M | a day
| OL-3530 | QA_1910_Texts are not visible in calendar pop... | B | Back | fxia1      | M | a day
| OL-3328 | QA_1910:Error message received while performi... | B | Back | fxia1      | H | 14 days
| OL-3270 | QA_1910: Trouble downloading multiple templat... | B | Back | fxia1      | H | 15 days
| OL-3214 | QA_1910: Can filter info storage having only ... | B | Back | fxia1      | M | 20 days
| OL-3205 | QA_1910: Invalid port range error message dis... | B | Back | fxia1      | H | 20 days
| OL-3204 | QA_1910:An error appears in top right corner ... | B | Back | fxia1      | M | 20 days
| OL-3201 | QA_1910: Unable to restart windows Instance      | B | Back | fxia1      | H | 20 days
| OL-3198 | QA_1910:No text appears in the white borders ... | B | Back | fxia1      | M | 20 days
| OL-3183 | QA_1910:Inconsistent behavior when assign a V... | B | Back | fxia1      | M | 21 days
| OL-3182 | QA_1910:The window that pops out when user ad... | B | Back | fxia1      | L | 21 days
| OL-3117 | QA_1910_'verify phone number page' lenovo Log... | B | Back | fxia1      | M | 27 days
```

## `create` template

This is to display a YAML file for you to fill in the blanks. This is
where you can plugin all kinds of _hardcoded_ values to save
time. It's pretty self-explanatory, so [take a look][5]. I don't know
much about the [hugo][6] yet, so most of the contents here are just
basics.

# jira server, username

In [config.yml][8], just define these:

```yaml
endpoint: https://jira1.labs.company.com:8443
user: fxia1
```

It will prompt you for password when it tries to connect. Somehow it
saves (cookie?) so that once you have authenticated, your CLI works
without asking the password again for a while (good a whole day in my
situation). I haven't found an option where I can save the pwd, like
`.authinfo`. Small inconvenience.

# custom commands

This is really a life-saver, unbelievably powerful! You just define a
JQL, and it becomes just another command! Example:

```yaml
custom-commands:
  - name: mine
    help: Display issues assigned to me
    script: >-
      {{jira}} list --template table --query "
      assignee=currentUser()
        AND status not in (DONE,CANCELED)
      ORDER BY
        issuetype ASC,
        status DESC,
        created DESC,
        key DESC
      "
```

This says to use the [table template][4] for display, and the query
string is the just whatever you want to speak to jira server. Also by
using the `>-` to handle [yaml multiline string][9], we can type the
query in any nice indented format you like, and it will be converted
into a single string by removing all the newlines in between w/ a
single white space! Slick, isn't it!?

With this, you can really just learn the JQL and fly w/ your
knowledge. The entire jira server is up for your grab at this
point. Of course you can just copy & paste your filter's SQL query
string from Jira brower to here!  To give you an idea what it can do,
here are the _filters_ I'm using:

```shell
  cp-story:            All CP stories
  cp-bug:              All CP bugs
  cp-story-mine:       My CP stories
  cp-bug-mine:         My CP bugs
  cp-mine:             Everything of CP that is assigned to me
  cp-done:             CP done items
  cp-unassigned:       CP unassigned items
```

If I'm really interested the look, I can give it different `--template
<whatever>` to customize that experience. But as of today, I really
want to a consistent view, the same view, for all the tables, so I
save on context switching looking at different look for each filter
(which I found very annoying, and no value add in term of information,
whatsoever).

# editor

Set in [`config.yml`][8]. I think it uses whatever the default editor
is. I tried `nano` and for now, using `emacsclient` will simply reuse
the existing emacs session and opens a new buffer! &rarr; makes
editing YAML so much more pleasant. And it is definitely better than
typing in browser's small text box!

# commands

These are the ones I use the most:

| command                     | description                                |
|-----------------------------|--------------------------------------------|
| jira mine                   | list everything assigned me                |
| jira today-mine             | everything created today an assigned to me |
| jira <custom cmd>           | any shortcut you defined                   |
| jira comment OL-1234        | make a comment                             |
| jira view OL-1234           | view a ticket                              |
| jira create -p OL           | create a ticket for project "OL"           |
| jira view OL-1234 -t debug  | check what fields are available/useful     |
| jira transitions            | available transition values                |
| jira transition "<val>" OL- | move along the workflow                    |
| jira take OL-               | assign it to myself                        |
| jira give <userX> OL-       | give it to him/her                         |
| jira done OL-               | mark it DONE                               |

So far, soooooooooooooooooooooooo good ~~~~~

[1]: https://github.com/ahungry/org-jira
[2]: https://github.com/go-jira/jira
[3]: {filename}/downloads/jira/jira
[4]: {filename}/downloads/jira/templates/table
[5]: {filename}/downloads/jira/templates/create
[6]: https://gohugo.io/templates/introduction/
[7]: https://gohugo.io/functions/
[8]: {filename}/downloads/jira/config.yml
[9]: https://yaml-multiline.info/
