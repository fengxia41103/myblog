Title: Netbox, infrastructure management
Date: 2018-06-06 14:00
Tags: dev
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

Sky is the limit, but this doesn't mean much. Practically speaking,
phase 1-5 draws a picture that shifts the focus of infrastructure
management from counting inventory to knowledge automation. The goal
is not to eliminate human factor, but to alleviate waste of their
bandwidth on things that can be well known, well modeled, and scriptable.

Analysis requires intelligence; SSH to ten machines does not.

# View of infrastructure management

Ah, [DCIM][1]. Borrowing from wiki, a service-oriented view can be:

1. Asset Management
2. Network connectivity Management
3. Environment Management
4. Energy Management
5. Change Management and
6. Capacity Management
7. Computational Fluid Dynamics (CFD) Integration[17]

[1]: https://en.wikipedia.org/wiki/Data_center_infrastructure_management

However, I think it is inadequate.

To give an example: what does it mean when a server is _under
management_? First is to inventory (model, serial #,
components...). But this is certainly not sufficient. What's the
_state_ of it? (firmware version, BIOS settings). Then, reading these
and display them leads to the next step -- can we update them? Now
this is LXCA and its alternatives. But this leads to more, because
server _state_ is meaningful only to whoever is using it
(workloads)....

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

## Five system capabilities

Instead, I am proposing a different approach to actually any system by
looking into these **five capabilities**, using netbox as case in point:

1. inventory of subjects: rack, server, switch,
   PDU, cabling.
   1. manual, or import
   2. auto &larr; discovery
2. diagnosis/reality of subjects: network connection diagnosis &larr; if a
   server is not accessible, is it powered off? did it lose
   connection? or assigned a new IP (in a DHCP world)? or a router in
   between is pdown?.... this is a fact collection.
   1. auto only (manual is meaningless)
3. design: if we can describe _reality_, we can describe an
   expectation, too.
   1. manual (a design board), or an interface w/ another design tool
4. diff = design - reality: if we diff them once, we can diff
   them continuously, thus leading to thresholds and alert.
   1. auto only. This is the most customer-configurable area.
5. design &rarr; reality: can I make a design into reality? &rarr;
   orchestration, automation, self-correction.
   1. instructions, manuals, wiki, scripts....
   2. auto: workflow, scriptions, execution chain

Now looking at an _infrastructure_ since it is such a loaded term (what else can be
called an _infrastructure_?), I'd like to further confine the scope of
**subjects** of our infrastructure to include only the followings:

1. Hardware: rack, server, pdu, switch, including sub-components such as BMC,
   sub-bay inside a server. Cable, plugs... your call.
2. Networking:
   1. physical connections: switch-to-switch, switch-to-server,
      server-to-server
   2. logical (at layer-N): routing, vlan, gateway, proxy

