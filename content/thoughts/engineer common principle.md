Title: Engineer's common principle
Date: 2025-09-27 13:49
Tags: thoughts
Slug: engineer common principle
Author: Feng Xia

<figure class="col s12">
  <img src="images/DSC_5136.JPG"/>
</figure>

Working at the State for over a year and half now, and I start to
think about some of the common patterns &mdash; some of them I would
deem as being inexperienced, some probably being borderline to a mistake or
should-not-do, and some are hard to evaluate if not given a
condition. Thus, I'd like to dump what I view of such topics, and see
what I could summarize, and perhaps, share w/ the team.

## Engineering = being Deterministic

I learned this word from Miro. Engineering is an effort to be
deterministic. Sometimes this line is presented from the other end of
the certainty spectrum &mdash; engineering is of controlling the
uncertainty/risk. Both are speaking of the same idea.

Engineering is to produce a predictable result w/ a given input. There
are endless possibilities in real world, of course. But that's exactly
why engineer must think deep & hard, like playing chess, you are not
in the business of reading mind or enumerating all possible paths,
well, Alpha Go is hardly doing that even, but you are to think and
compute the possible outcome of a move, and try to confine your
opponent's move into a predictable manner, and that, is what I mean by
being deterministic.

Also like chess, you move is never based on the happy path, but is on
how your opponent will counter. Therefore, building a well of
knowledge of the game and your opponent is the only way, and it should
be difficult to achieve &mdash; how many chess master there is in this
world, in your life!?


## Engineering = Data driven decision

> "If we have data, let's look at data. If all we have are opinions,
> let's go with mine"
>
> -- Jim Barksdale, the former CEO of Netscape
>

First time heard this line AWS event in 2024. Love it.

All engineering is data engineering in its core. We deal w/ facts, and
fact = can be proven wrong, and we all know there is no wrong
opinion. Thus, it will be a logical fallacy if a conclusion is only
backed by opinion. We must collect data, use data, and base a decision
on data.

This is easier said than done. We also know the other proverb: garbage
in, garbage out. The _quality_ of the data in this process determines
the quality of decision. Yet there isn't a clean yard stick on the
quality of data in most cases. Engineer's ingenuity is ultimately
determining this, but we can do more. Crosschecking methods such as
peer review, fact checker, independent assessment, spot checking, are
all useful tool to improve the quality of input. One thing to watch
out for is that these crosschecking should themselves be based on
data. If one subjective opinion is **not sufficient**, then two don't
make it much better.

What to do? **Trust, but verify.**


## The value of POC

We do many POCs. Myself is also a strong advocate of POC-culture
&mdash; nothing is better than rolling up your own sleeves and prove a
working path. The moral of the story is simple &mdash; To see is to
believe. If you claim something, show me.

However, there needs a caution of this exercise. POC is always built
upon a core technology of a sort, which is often a vendor product,
including COTS and things like the AWS services. Based on what this
product **can do**, an idea emerged of using it to solve a problem we
have. It is a natural course as this is exactly how human mind
perceives a possibility when new capability becomes _available_
&mdash; new tools lead to new way of production, new way of solving an
old problem. However, what I found **a miss** is that too much
emphasis/value have been given to the technology itself, sacrificing
the problem itself to a secondary importance. This is reversed.

New technology should be viewed as a new lens to analyze a problem,
and the focus should always be what the problem now means under this
new lens, and we need **deep analysis** of this new view. In
particular, besides the happy path, where the boundary lies, and what
is the limitation of this new tool. Rather, the new technology, in
many times, stole the show. Instead of using the new tool to dissect
the problem again so that to examine **critically on why this new tool
solves the problem** comparing to what we are using or having tried.
Think about why we missed this way of solving before? &mdash; Was it
just because we didn't have this tool, such as pre-AI/pre-Internet
age, something that didn't leave the lab till now? or, that we didn't
know this tool because we didn't explore enough? or, A way of thinking
that led us down a different path?... As you can think of, each such
question/reflection will lead to a different conclusion, as some, if
true, will contribute our success to a luck or a evolution that we
don't control, while other could mean we have an internal inertia of
repeating the same _feeling-stuck_ if not changed.

New technology is, many times, like a new toy, and we engineers are
kids in a toy store. It's fun to explore, to discover, to try, and to
be creative. At the meantime, don't get carried away. The value of the
POC is **not of how cool this new toy is**, but how it breaks the
limit we reached using the old method, and in particular, why we had
that limit to begin with.

## Critical thinking = prove what it is NOT

Extending the POC discussion above, another topic is how to evaluate a
new technology. I love new technologies. Everytime I chanced on some
social media on new opensource projects, I can't wait to download it
and try it out. This is the fun part. Using it to build a happy path
for our solution is fun &mdash; literally we are proving its worth.

But, there is more. Take a step and ask this:"Why I want to try this
myself?" The underline theme is a matter of verification. If we would
take the face value of what the author of that technology claims, what
will be the problem?

I doubt anyone will say "no problem at all". It's not of credibility
of the vendor or their claims, it's all about how human learns a new
thing &mdash; we learn from our experience, thus we must try, see it,
experience it, play with it, even burned by it. So, what are we
looking for to be satisfied w/ this learning? That's what I'm
advocating here, borrowing a big word, **critical thinking**, our
learning is more than knowing it works, or even how it works, but to
find out when it doesn't work. Like coding an application, there is
only one happy path, but endless possibility of broken paths. **What
engineering really is is to design for a tolerable failure mode**
&mdash; we need to have an educated guess of how bad it can be, budget
for it as much as your judgement deems, and pray for not meeting a
black swan event.

Therefore, it is more valuable, if not essential, to prove the
limitation/constraints of this new technology, than to prove its happy
path. How to achieve this? Focus on the problem &mdash; your problem
is unique to the point that we felt stuck, right? What's so unique
about it? Coin the case, then throw this case at this
tool. Fundamentally, a tool is like a mass-made clothes &mdash; GAP
knows nothing about your particular body size, and we know too well
some Medium shirt fits better of your arm's length than other
Mediums. Same logic here. You must have a sense of what's so unique of
yourself, using that to the test, thus stretching the boundary of this
new-found-solution, and try to break it even. Then, you would have a
pretty good sense how _bad_ it can be.

## Document = job description, not a goodwill

Writing document is fun, to some people, and painful, to some
others. Engineers, coders, we write a lot, and it's tiring
sometimes. In particular, document become obsolete quickly, for
example, your API doc, if a code was changed yesterday. It seems an
unsolvable problem and even a wast of time.

It is. Except code-as-doc, or even literate programming, there isn't a
solution to this dilemma. But, document is like testing &mdash; you
better have some than none, even if the testing is poor.

Engineers are exploring _uncharted territory_, thus it sounds counter
intuitive to lay down milestone upfront. However, exactly because we
don't know where the final destination will be, it is only logical
that we constantly leave some breadcrumbs along the way, so that we
could backtrack when we hit a dead end or changing a direction. This
thought has been depicted too well in the story of [Theseus and the
Minotaur][2] &mdash; we are navigating a labyrinth, and the mythology
has spoken its wisdom.

If drafting a plan into the future is difficult, at least writing a
log of historical events, so that we have an account of what happened,
and learn from it.

## Feedback loop, timing

An open loop system is inherently unstable. Period.

We can only solve something if we can iterate, and iteration requires
feedback loop. An engineering process, a SDLC, must be a close-loop
system. Close-loop system requires using the feedback as input for the
next iteration. How much weight it carries can become quite an
art. But one thing would be clear, that is, the shorter the iteration,
the better. A reality check, ideally, should be _real-time_, meaning
whenever I want to see it. On-demand or being-continuous are both
fine, and the driving factor isn't arbitrary, but is determined how
quickly the system needs to adjust. In embedded engineering, for
example, if the system runs at 500hz frequency, then its feedback loop
must be less than `2ms`. Therefore, if a project wishes to move
forward everyday, well, you do the math.

What this derives to, is that, in managing a project or building a
system, information flow must be time boxed, including the process of
human effort to produce this info and analyze this info. Just like any
other data point we have talked about so far, this timebox must be
measurable. For example, in JIRA, we measure its `age=close date -
creation date`.

[1]: {filename}/thoughts/capability%20model.md
[2]: https://en.wikipedia.org/wiki/Ariadne
