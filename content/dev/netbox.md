Title: Netbox revised
Date: 2018-06-06 14:00
Tags: dev, lenovo
Slug: netbox
Author: Feng Xia
Status: Draft

# Background

It has been a painful experience to witness how we are diagnosing
infrastructure, especially network connections, in a what I would call
`chasing the rabbit` fashion in which `ping`, `route`, `vlan`, `port`
on a switch, to which port the two ends of a cable plugged into, all
coming to a single chain of a `valid` connection. Part of it is to
verify hardware connections (cablings), part of software
configurations (many layers deep). A knowledgeable person can traverse
the link from one end to the other, but even he is faced with a harsh
reality of which area is to focus on.

If you think of it in the highest level &mdash; a topology design, its
mirror image is the reality. Scanning devices to acquire and compose
the reality is what computer is good at. Therefore, like counting
inventory, it shall have the capability to **replace** the typing of
repetitive commands by a human hand, and piece-meal ocean of meta data
into a **logical, meaningful view** that saves operator mechanical
efforts. Without knowing the design, at least it should produce, and
even maintain, the reality view, on demand and continuously.

Taking this further, if reality can be described, the same syntax
shall be used to describe **expectation** (design). Now, we will be
equiped with both views and produce a **diff** &rarr; Previously we
are relying on an experienced operator to know where to look; in the
future this diff view highlights it, color-codes it, for anyone who
wants to look, anytime, and no devop expertise required.

If you have read [system capability model][1], you must have
identified that this is a capability approach. This shifts the focus
of management from bookkeeping to knowledge automation. The goal is
not to eliminate human factor, but to alleviate waste of their
bandwidth on things that can be well known, well modeled, and
scriptable.

Analysis requires intelligence; SSH to ten machines does not.


# Life cycle

This logic chain goes on and on and on. The point I see is that there
is no **isolated** infrastructure management --- we can't do this
piece meal (say, LXCA manages HW). We have to come up a hollistic view
of this entire chain so to understand our position in it. One analogy
I was thinking is how diaper companies compete to get to new borns at
their first existence --- whatever your hospital gives your baby to
use at their birth, is **more likely than any** to be adopted by
parents.


Therefore with this chain, if we look from a hardware's prospective,
its existence at customer site is not when it is deployed, it is at
(capacity) planning, procurement, or even board meetings. There is no
way we can trace all the way back to its origin (unlike a new born,
whose starting point is well defined, and if s/he was delivered inside
a hospital, its environment is controlled.). But this is not a losing
battle. The lifecycle of a hardware is not a myth, it can be
described:

<figure class="col s12 center">
  <img src="/images/baremetal%20lifecycle.png"/>
</figure>


1. Planned
2. Commissioned
3. Decommissioned (then back to #2 re-purposed)
4. Obsoleted

[1]: {filename}/thoughts/capability%20model.md
