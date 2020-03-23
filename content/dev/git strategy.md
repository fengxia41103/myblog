Title: Git strategy
Date: 2020-03-21 12:42
Tags: thoughts
Slug: git strategy
Author: Feng Xia

<figure class="col s12 center">
  <img src="images/funny/a%20lot%20of%20cats.jpg"/>
</figure>


[git][1] is wonderful, but its workflow is very confusing. Surprised?
Then I would dare to say that you haven't had first hand experience
using it in a full blown enterprise environment &mdash; when in such
environment, the challenge isn't about git itself, but what the
content of a release are, and how we are testing/CICD them.

You would think it sounds rather cliche that this problem even
exists. After all, these are what a software engineering is all about,
aren't they? But take a step back and consider this scenario:

0. We just did a release 5.0.0.
1. We have two features: 1 & 2.
2. Initially they were all targeting the next release, say `5.1`.
3. We create a **staging** branch, `5.1-staging` and point our CICD to
   this so to QA them (more on this later).
4. Feature 1 & 2 have been merged into `5.1-staging`. Their source
   branches, eg. `feature-1`, have been deleted &larr; at merge
   request, select to delete source branch.
4. Time is slipping, 5.1 is up this Friday, but one feature is failing
   QA tests. So management is going to release 5.1 w/ feature 1 only,
   and moving feature 2 to release 5.2, which has another staging
   branch `5.2-staging`.
   
All sound fair and common. But there are multiple questions. First,
let's set the objective.

# Objective

> AS a product owner, I want to control the release content, so that I
> can plan release schedule into the future and communicate w/ stake
> holders of availability of a feature based on these schedules.

No mystery here. Regardless Agile or not, team is to deliver features,
and these features will fall into a release, and release is not Agile
by nature &larr; however Agile desires the product to be _usable_ by
the end of each Sprint, the reality is not so, and further, the
definition of a release has usually two more requirements than a
product being _usable_ (`usable` is an ambiguous term and is useless
in determining a release):

1. It must pass a set of user defined tests (UAT).
2. We must know the content of the release in term of functions
   (aka. features).

It's the second requirement we are to discuss in this article.

# Problem statement

The problem is that at any given time, there are multiple teams and
developers working on various topics &mdash; some features, some bug
fixings, thus code is constantly in fluctuation. This is directly
contradicting us controlling the content of a release:

> I want to select the changes I want and nothing else, while the pool
> of changes to be selected from is constantly expanding in a rate
> higher than an individual can keep up w/.

Since all development result in a code change, and all code changes
are ear marked in git, is there a git strategy to solve this problem?

Yes there is gotta be. Otherwise, git or any other version control
tool will become useless for software development.

# Two rules 

In git, individual code change is ear marked in **commit**, and
changes are _grouped_ into **branches**. Here we are to use two
branches for discussion &mdash; feature branch, and release
staging. Feature branch is to hold the group of changes of a feature;
release staging is hold the group of changes of a release. It is the
release staging we are interested in controlling.

**Assuming** branch `develop` is our MASTER:

1. Feature branch **must go into a staging** or abandoned. No one can
   merge a feature directly into `develop` &larr; this is to prevent
   skipping CICD/QA.


2. **Release staging will go into `develop` eventually instead of
   living as independent branch indefinitely**. This is assuming that
   all releases are essentially backwards compatible. **This may not
   be true**, and we will discuss further in "Long term support"
   section.


# Possible strategies

Now consider the original story that we have an past release of `5.0`,
and two upcoming releases `5.1` & `5.2`. Since a release must have
staging, we will have two staging branches: `5.1-staging` and
`5.2-staging`. 

There are two features in development, feature 1 & 2, correspondingly
there are two feature branches.

Out of all these, there are only finite combinations of possibilities:

1. What are the origin of these two staging branches? Two
   possibilities:
    1. both from `develop`
    3. `5.2-staging` is a branch off `5.1-staging`, and `5.1-staging`
       was branched off `develop`.
   
2. What are the origin of these two feature branches? 
    1. both from `develop`
    2. both from `5.1-staging` 

Similarly we determine where these features are merged into, and where
these staging branches are merged in eventually. So with these in
mind, we have the following combinations:

| Strategy | Staging from    | Staging to          | Feature from | Feature to | Applicable |
|----------|-----------------|---------------------|--------------|------------|------------|
| 1        | develop         | develop             | develop      | staging    |            |
| 2        |                 |                     | develop      | develop    | no         |
| 3        |                 |                     | staging 1    | staging 1  |            |
| 4        |                 |                     | staging 1    | staging 2  |            |
| 5        | another staging | develop             | develop      | staging    |            |
| 6        |                 |                     | develop      | develop    | no         |
| 7        |                 |                     | staging 1    | staging 1  |            |
| 8        |                 |                     | staging 1    | staging 2  |            |
| 9        | develop         | staging             | develop      | staging    |            |
| 10       |                 |                     | develop      | develop    | no         |
| 11       |                 |                     | staging 1    | staging 1  |            |
| 12       |                 |                     | staging 1    | staging 2  |            |
| 13       | another staging | yet another staging | develop      | staging    |            |
| 14       |                 |                     | develop      | develop    | no         |
| 15       |                 |                     | staging 1    | staging 1  |            |
| 16       |                 |                     | staging 1    | staging 2  |            |

Strategy 2,6,10,14 are ruled out because they violate rule #1 &larr;
feature code can not be merged directly to `develop`.


# Strategy 1

| Strategy | Staging from | Staging to | Feature from | Feature to |
|----------|--------------|------------|--------------|------------|
| 1        | develop      | develop    | develop      | staging    |


<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%201.png"/>
    <figcaption>Release staging (dev&rarr;dev), feature (dev&rarr;staging)</figcaption>
</figure>

In the diagram I have two feature branches and two staging
branches. All four were created from `develop`. 

Pros:

- Developer always create his/her feature from `develop`. Thus they
  don't have to be aware which release this feature is going
  into. Logistically it's a managerial decision anyway.
  
      But, this is to creating a big problem! See first item in "cons"
      section below.

Cons:

- Developer's starting point is arbitrary &larr; dev don't have
  control what is in `C0` and `C4`, nor do they really pay attention
  to them when they were creating a branch at that moment.
  
     What this means is that feature 1 is fine in its own branch,
     but may break as soon as it's merged to `5.2-staging`, because
     `C4` is after both `C0` and `C1`, thus having **unknown**
     contents when developer was working on feature 1.
     
     Mitigation is to control the starting points, for example, having
     both features starting from `C0` &rarr; if we have multiple
     features, the latter ones will have to consult the very first
     feature branch for its starting point.
  
- `staging-5.2` will also have hot fix content because of feature 2
  merge. This may not be desired if I want feature branch to only have
  feature content. 
  
     Because features are created from `develop`, `C4` from which
     feature 2 branch was created is essentially a random location (you
     don't necessarily know what is before `C4` when you decided to
     create a `5.2-staging` brach from it), thus making the content of
     `5.2-staging` random as well. Same is true for `C0` that we don't
     necessarily consider it be part of `5.1` release at all, but it is
     pulled in because of the branching strategy.

     Therefore, contents of both feature staging become arbitrary if not
     controlled carefully when the feature branch is
     created. Considering that dev owns feature branch, it's too much a
     risk to rely on personal code of conduct to keep staging branch
     _clean/minimal_.
  
# Strategy 3&4

| Strategy | Staging from | Staging to | Feature from | Feature to |
|----------|--------------|------------|--------------|------------|
| 3        | develop      | develop    | staging 1    | staging 1  |
| 4        | develop      | develop    | staging 1    | staging 2  |

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%203%20and%204.png"/>
    <figcaption>Release staging (dev&rarr;dev), feature (staging&rarr;staging)</figcaption>
</figure>

In this diagram I am covering two strategies: 

1. feature is either folding into the same stating it was branched off
   (case 3) &mdash; feature 2 was developed for 5.2, and will be
   merged to `5.2-staging`.

2. feature is merged onto yet another staging (case 4) &mdash; feature
   1 was developed for 5.1, but later was decided to be 5.2.

Cons:

- As in strategy 1, staging branches were created from two different
  `develop` commits, making its contents arbitrary.
  
- In case 4, feature 1 may stop working when merged into `5.2-staging`
  because contents between `C0` and `C3` were unknown to feature 1's
  developer.

- Developer has to be aware which release the feature is intended so
  to create the feature branch off the **proper** staging, even though
  this doesn't have any material impact on the code state. Thus this
  is an unnecessary noise for developer and adds no value but a
  falsified impression that we are feature code is already _contained_
  within a release, which it is not.
  
  
# Strategy 5

| Strategy | Staging from    | Staging to | Feature from | Feature to |
|----------|-----------------|------------|--------------|------------|
| 5        | another staging | develop    | develop      | staging    |

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%205.png"/>
    <figcaption>Release staging (staging&rarr;dev), feature (dev&rarr;staging)</figcaption>
</figure>

In this strategy, `5.1.1-staging` is created from `5.1-staging`. This
is simulating that we started w/ 5.1 release development, but later
decided to do a `5.1.1` release first.

Cons:

1. This strategy suffers the same problems as strategy 1, that we will
   have arbitrary contents in the staging depending on what the
   feature is bringing w/ it &mdash; feature 2 will drag in all the
   changes of `C0` to `C4` into `5.1.1-staging`.

# Strategy 7

| Strategy | Staging from    | Staging to | Feature from | Feature to |
|----------|-----------------|------------|--------------|------------|
| 7        | another staging | develop    | staging 1    | staging 1  |

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%207.png"/>
    <figcaption>Release staging (staging&rarr;dev), feature
  (staging&rarr;same staging)</figcaption>
</figure>

Pros:

- This is a clean solution that we have had a 5.0 release, thus any
  staging is off the 5.0 commit, creating a common base for all
  features.
- Features are confined to its release staging during development.
- Contents of the staging is controlled. Nothing on `develop` will
  leak into the staging by surprise.

# Strategy 8

| Strategy | Staging from    | Staging to | Feature from | Feature to |
|----------|-----------------|------------|--------------|------------|
| 8        | another staging | develop    | staging 1    | staging 2  |


<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%208.png"/>
    <figcaption>Release staging (staging&rarr;dev), feature
  (staging 1&rarr;staging 2)</figcaption>
</figure>

Similar to strategy 4, that we are changing mind during a release
(`5.1-staging`), that we are shift one feature to another release
(`5.2-staging`) instead.

Pros:

- Because of the common root law of two staging branches, feature 2
  will work the same on `5.2-staging` because it is based on 5.0 in
  any case.

Cons:

- Feature 2 merging will bring w/ it `C1` and `C2` to `5.2-staging`,
  which may defeat the purpose of moving feature 2 (but feature 1) to
  `5.2-staging` at the first place.

# Strategy 9

| Strategy | Staging from | Staging to | Feature from | Feature to |
|----------|--------------|------------|--------------|------------|
| 9        | develop      | staging    | develop      | staging    |

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%209.png"/>
    <figcaption>Release staging (dev&rarr;staging), feature
  (dev&rarr;staging)</figcaption>
</figure>

Up to this point you can certainly see the similarity between strategy
1, 5 and 9. Even though we are merging staging into another staging
instead of `develop`, this strategy suffers all the problems strategy
1&5 suffer. After all, the core of the objective is to have a known
content in a release, which this fails to achieve.

# Strategy conclusion

I'm gonna skip strategy 10-16 because they are redundant after the
discussions so far. It's clear that the key to the issue are two:

1. root of the staging
2. root of the feature

If we can't control these two, we lost control of the contents in each
branch. Therefore, the only viable strategy is 7:

1. stagings use the same root, ideally a past release
2. root of feature is staging (if we satisfies first point, all
   stagings are essentially the same!)

# Move feature to new staging

Common request is to move a feature to a new release. The feature may
be in progress or having been merged. How to do this properly?

From strategy 8, we already see that repointing MR is necessarily
sufficient because moving feature 2 will bring commits that were
developed on `5.1-staging`. For all we know, these commits can be
intermittent works by feature 1. Therefore, we will be leaking feature
1 works to the `5.2-staging`.

The clean method is to fully revert feature 2 on `5.1-staging`,
**reimplement** it from scratch on `5.2-staging`, then MR.
`
<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%20move%20feature%20to%20new%20staging.png"/>
    <figcaption>Move feature to a new release staging</figcaption>
</figure>


# Long term support (LTS) releases and hot fixes

A release is a snapshot in time. But hardly, because there will be hot
fixes &mdash; things you have to patch, say, security, that will
ultimately change the content of a released release. What is the
strategy for hot fixes? 

## Hot fixes

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%20lts.png"/>
    <figcaption>LTS and hot fixes based on Strategy 7</figcaption>
</figure>


Coming from strategy 7, you can see that same problem will occur again
if we are to merge hot fixes into my LTS, that unintended commits `C0`
and `C1` will be included in LTS. Remedy is simple, hot fix branch
must be rooted in `5.0` like all `5.x` release branches!

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%20lts%20based%20on%208.png"/>
    <figcaption>LTS and hot fixes</figcaption>
</figure>

If we had two releases, 4 & 5, we will create two parallel hot fix
branches tracking each.

Now, what if I found a security bug in V4, fixed it, can I apply the
same fix to V5? or vice versa? From V4&rarr;5, yes; but from 5&rarr;4,
no. See next section on "Bugs".

## Bugs

Bugs are essentially the same as hot fixes but w/ a critical
difference: we don't know bugs are critical until we discover and fix
them; we know hot fixes are critical because they are usually
determined by some external sources such as vendor of a library we are
using, or of the operating system we are deploying into.


Once bug is found and fixed, we are facing the question whether
this same bug is **critical enough** that needs to be applied in other
releases.

Following the hot fix discussion, bugs found in V4 can be applied to
V5 without ill feeling because V4's `C0` is already part of V5. But
bringing V5's bug fix into V4 will then bring `C1` into V4! Therefore,
bugs and hot fixes can only roll forward, but never backward &mdash;
you can apply a bug fix of a older release to a newer release, but not
the other way around.

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%20lts%20bugs.png"/>
    <figcaption>LTS and bug fixes</figcaption>
</figure>

## CICD/QA, UAT, and life cycle of a release

When does a release start, when does it end? We have said in rule that
all development will always go into a staging, and the purpose of a
staging is to have a chance for CICD/QA. If we follow git strategy 7,
we will have a clear idea of the contents in a staging, thus whenever
CICD passes a certain criteria, that particular commit can then be a
release candidate.  Usually the criteria is per user-acceptance-test
(UAT), thus it represents **what the user considers done**.

At that point, the staging can be further _elevated_ into a official
release. Again, release is mostly dictated by time line or a
managerial decision. Dev (including QA) is responsible for passing the
UAT on staging, but they don't roll out a release whenever. When we
release V5, we fold the code into `develop` and tag it.

<figure class="col s12 center">
  <img src="images/olympia/git%20strategy%20release.png"/>
    <figcaption>CICD/QA, UAT, and life cycle of LTS</figcaption>
</figure>


If we released V5 and now have a hot fix, what do we do? We roll hot
fix into `v5-staging` to test, then to a patched release if UAT
passes. Note that UAT in this case may be an enhanced version of the
original UAT because of the hot fixes. Patch release should also be
foled to `develop` as an official release.

When LTS reaches its end of life, the `v5-lts` branch is folded into
`develop`. At that point, `v5-staging` will be removed.

# Conclusion

To sum these all up:

1. All three types of in-progress branches should root in the same
   commit, ideally a releas commit &mdash; feature, hot fixes, and
   release staging.
2. If you create multiple release stagings, have them use the same
   root, too.
3. CICD/QA monitors staging branch.
4. Merge a release commit to `develop` as soon as the release is official.
5. `develop` should not have commits other than releases.

Enjoy. (also available in [pdf][2])


[1]: {filename}/dev/git.md
[2]: {filename}/downloads/git.pdf

