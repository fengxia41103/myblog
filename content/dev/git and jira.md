Title: Git & Jira
Date: 2020-05-01 15:11
Slug: git and jira
Author: Feng Xia

Huston, we have a problem.

Having be in both sides of a software development, I can now see
clearer than many what management wants but are not getting, and what
dev is doing but not doing it right. In essence, what is a management
in a software development? It's a catch-22 that manager needs to be
tech savvy so s/he knows what the dev is doing, but then, even so,
s/he is a few in number comparing to the number of devs, not to
mention the line of code changes. So it's simply not practical for him
to keep up anyway. If then, what to manage? and how to manage? If I
were the manager, what do I want to control?[^2]

As of writing, Jira is the popular project management tool, and git is
the code repo. So here is a diagram showing where information reside,
taking an hypothetical example that I'm to release version 5.1.1. The
dream of a manager can be stated as:

> As the manager, I want my entire team to focus on 5.1.1 items, so
> that I can get them done on time and meet product owner's

> expectation.

So, how do we do this? In Jira I have defined my expectations &mdash;
Jira items that I want people to work on. But then, do I need to learn
git in order to find out what people have actually worked on?
Similarly, how do I know QA is testing the right stuff, that CICD is
building the right code, that my instance contains `5.1.1` changes but
not some future experimental contents planned for `6.6.6` release?

**Fundamentally, I think we need an analytic tool. Like QA is for
function verification, a _management QA_ tool for managment.**

# Workflow and problems

Sticking w/ Jira and git, we plug in players in a workflow
demonstrating where they are getting their input, and what their
outputs are.

<figure class="col s12">
  <img src="images/git%20and%20jira.png">
  <figcaption>Workflow using Jira for PM and Git for code</figcaption>
</figure>

To manage this workflow is to trace information, eg. requirement, from
Jira, all the way to the stack, that they are implemented
**correctly**. So first, let's see what information are there and
where to find them.


| Creator | Information                                                       | Info Source                 |
|---------|-------------------------------------------------------------------|-----------------------------|
| Manager | What 5.1.1 items to work on &rarr; todo list                      | Jira, filtered by `release` |
| Dev     | What is in the 5.1.1 code?                                        | Git                         |
| CICD    | Which 5.1.1 code is in build? Is build clean?                     | Jenkins, artifacts          |
| devops  | Which instance has the 5.1.1 build?                               |                             |
| QA      | Test coverage of 5.1.1 code?  is 5.1.1 affecting older functions? | QA repo, report             |

Now walking down this list, let me explain what issues are there we
are to address.

## manager & Jira

Starting w/ Jira, if we are to managing `5.1.1`, then we essentially
divide all actions into:

1. `5.1.1` items
    1. todo that will result in code
        1. `feature` targeting `5.1.1`
        2. `bug fixes`
            1. found in `5.1.1` code, and will be fixed in `5.1.1`
            2. found in other versions, and will be fixed in `5.1.1` &rarr;
               backwards compatibility
    2. those that will not
2. `non-5.1.1` items

These Jira items can be grouped in many ways logistically within Jira
itself, such as using epic, or even outside Jira so it fits the
manager's vision, or the organization's style. But these groupings
don't change the ingredients &mdash; the contents of these todos
remain regardless how you are grouping them.

## dev & git

First and foremost, git code should always be mapped to `5.1.1` Jira
(feature & bug fixes) because, after all, Jira defines the requirement
(what to implement/fix). Two common approaches are: naming branch
using Jira key, and include Jira key in commit message.

If using git w/ gitlab and if dev puts Jira number in commit message
or merge request, Jira ticket will automatically receive a comment w/
a link to the gitlab commit page.[^1]

However, this is where a problem arises &mdash; the match between Jira
and git is through the Jira key in git commit. **What if dev didn't
write that way?** It can result in four undesirable scenarios:

1. **Completly missing**: dev forgot to put the Jira number.
2. **Mismatch**: dev put in the wrong Jira number in commit, eg. typo.
3. **Ignorant**: manager moved a Jira off a release, dev doesn't
   know. Or even worse, the code has been merged to `5.1.1`
   branch. Then what?
4. Dev worked on a code that is not `5.1.1` Jira (the black boxes in
   the diagram), eg. lack of focus.

For all these gaps, how to identify them?

## CICD & artifacts

Transforming code into artifacts, eg. binaries, is the job of
CICD. Ignore the continuous testing aspect of CICD for the time
being. Ideally, the code used to build `5.1.1` artifacts should have:

1. All the 5.1.1 code that are in **done** state (and the _done_
   should match Jira status).
2. Nothing from parallel or future code such as `5.1.2` or `6.0.0`
   &larr; no feature leaks, or bugs from immature (or even untested)
   code &rarr; this is a **clean** build.

But then, **how do I know CICD is doing these two?**

## QA & tests

Last but the least, **how to map QA's tests and reports to Jira?** It
doesn't nee to be mapped to an individual Jira item. However,
conceptually, a group of Jira represents a feature/function that
should be achieved, thus QA's result should be mapped to this
level. For example, if an epic represents a new module I'm putting
into my product, QA would have at least one test for this module, thus
I'd like to map this test to the epic.

# 

[^1]: Even so, clicking through Jira just to know that the link
    exists, or matching the right code, is not practical for a project managaer.

[^2]: There is a counter argument that mangagement doesn't really care
    the process in between. Instead, he defines the requirement, and
    will conduct acceptance review or test for result. How the
    requirement is fulfilled is not his concern.
