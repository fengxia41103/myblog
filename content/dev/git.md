Title: Git
Date: 2019-10-09 13:18
Tags: thoughts
Slug: git
Author: Feng Xia
Status: Draft

Too many times I can't remember a particular git command. So here
let's keep notes on the ones I'd like to use and what they are.

# log

`git log --name-only --pretty=format:"%h - %an, %ar : %s" --graph
--all` will show a short commit #, who committed it, the commit
message, and list of files changed:

```shell
* f48af046 - fxia1, 18 minutes ago : Minor change of webapp/README.md. Add branch 422 strategy diagram to git.| 
| diagrams/git develop branch 422 strategy.dia
| diagrams/git develop branch 422 strategy.png
| mwc/src/main/webapp/README.md
```

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
- a commit: `git revert <commit #>`
