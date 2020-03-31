Title: Git
Date: 2019-10-09 13:18
Tags: thoughts
Slug: git
Author: Feng Xia
Modified: 2020-03-20

Too many times I can't remember a particular git command. So here
let's keep notes on the ones I'd like to use and what they are.

# log

## show file changed
`git log --name-only --pretty=format:"%h - %an, %ar : %s" --graph
--all` will show a short commit #, who committed it, the commit
message, and list of files changed:

```shell
* f48af046 - fxia1, 18 minutes ago : Minor change of webapp/README.md. Add branch 422 strategy diagram to git.| 
| diagrams/git develop branch 422 strategy.dia
| diagrams/git develop branch 422 strategy.png
| mwc/src/main/webapp/README.md
```

## train tracks

Another one is to draw a log graph of train tracks:

```shell
git log --graph --full-history --all --color \
        --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
```

This will show in terminal of full git histories and draw those train
track graphs. An example of my blog git:

```shell
* 8775404a       Update pandoc Makefile and pandoc.css
*   495b70e4     Merge branch 'dev'
|\  
| * 9d44fd57     Update draft doc.
* |   656ed837   Merge branch 'dev'
|\ \  
| |/  
| * bd47499b     Adding cp deployment.md and git.md
* |   2b4cdbd0   Merge branch 'dev'
|\ \  
| |/  
| * cf000d79     Add a summary to .md.
* |   eaa16ba3   Merge branch 'dev'
|\ \  
| |/  
| * a2efd99c     Add thoughts/smart phone.md
* |   e346f0d5   Merge branch 'dev'
|\ \  
| |/  
| * b1c05698     Upgrade pelican to 4.1.2. Fixing page iteration on the index page.
* |   e2456350   Merge branch 'dev'
|\ \  
| |/  
| * d9bfa593     Add thoughts/what we know is untrue.md
|/  
* 5e8e909b       Replacing {filename} for download content w/ {static}.
```

## commits between two dates

`git log --since "DEC 1 2014" --until "DEC 5 2014"`

# tag

- Add one: `git tag -a <tag name> -m "Say something"`
- Delete: `git tag -d <tag name>`
- Show a tag list: `git tag`

# diff

- two branches: `git diff <branch A>..<branch B>`
- two commits: `git diff ee4be da82da`
- a single file: `git diff <file name>`: this will diff between disk
  file and branch's HEAD.
- a single file between two branches: `git diff <branch A>..<branch B>
  -- <file name>`
  
# revert

- back to HEAD: `git reset --hard HEAD`: this throws away everything
  you have changed in this branch.
- back to a commit but keep the local changes: `git reset --soft
  <commit #>` &larr; this is going back in time, but keep my changes
  since then scenario. Neat!
- a commit: `git revert <commit #>`


