Title: Git strategy for backward compatibility
Date: 2020-04-01 11:42
Tags: thoughts
Slug: git rebase strategy
Author: Feng Xia

<figure class="col s12 center">
  <img
  src="images/olympia/git%20strategy%20rebase%20for%20release.png"/>
  <figcaption>
  Git strategy for a backward-compatible release
  </figcaption>
</figure>

As a sequel to our discussion on [git strategy][1], we have started w/
an objective that we want to "control the release content". Further, I
discussed how **backwards compatibility** of releases may not be true
if we are introducing long-term-support on releases, that hot fixes
and bugs can only **roll forward**, eg. V4 bugs can be patched to V5
(assuming V5 was released after V4, time wise and git commit wise),
but not from V5 &rarr; V4 without introducing some V5 contents into V4
(whether this is desired or not is the focal of the discussion,
essentially, how much control you want to have over the release
content!?)

Now, let's build on top of this and say that **we want backwards
compatibility** &mdash; all newer releases are always backwards
compatible? This is certainly a desired outcome because this makes
upgrade and maintenance easier (who wants to maintain a 10-year-old
code when a customer _frozen in time_ call you of a bug which you
probably don't even remember who wrote that crap 10 years earlier! Was
that me?... this can't be good for self-conscience ~~)

Now what you do? Pretty simple, use rebase or merge, whichever you
feel comfortable, to keep your branch in sync w/ moving targets
&mdash; changes you will be interested in:

| Who              | Do what                                                                                               |
|------------------|-------------------------------------------------------------------------------------------------------|
| feature dev      | rebase feature onto `5.1 dev` prior to MR submission                                                  |
| 5.1 branch owner | merge changes from `develop` periodically                                                             |
| CICD             | rebase/merge changes to `5.1 staging` from both `develop` and `5.1 dev` when `5.1 dev` becomes stable |
| CICD/release     | rebase `5.1 staging` to `develop`, close `5.1 dev`, tag release on `develop`                          |


A few notes:

1. Root of CICD branch does not have to be the same as dev root
   anymore because we are constantly pulling in changes from
   `develop`. **This is the most important difference** from [previous
   git strategy][1], in which I made argument in conclusion that "_All
   three types of in-progress branches should root in the same commit,
   ideally a releas commit &mdash; feature, hot fixes, and release
   staging._" This is because we are now assuming these releases are
   backward compatible, while previously they are not.

2. `5.1 dev` branch is a **public branch**, thus should not use
   rebase. Use `merge` instead to pull in changes from `develop`.
   
3. `5.1 staging` should not be treated as CICD's development
   branch. Otherwise, rebase should also be prohibited on it.

[1]: {filename}/dev/git%20strategy.md
