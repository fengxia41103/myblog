Title: System capability model
Date: 2018-06-12 09:20
Tags: dev
Slug: capability model
Author: Feng Xia


Ah, [DCIM][1]. Infrastructure needs to be managed, but then, what does
it mean? Borrowing from wiki, a view can be:

1. Asset Management
2. Network connectivity Management
3. Environment Management
4. Energy Management
5. Change Management and
6. Capacity Management
7. Computational Fluid Dynamics (CFD) Integration[17]

This type of view is based on an attribute of object that we are
managing &mdash; serial number is logged in asset management,
utilization is likely in energy management, and how full the rack is
falls in capacity management, and so on.

# View of attributes


However, I think such a view is inadequate because it artificially
break an attribute into multiple systems, thus creating a boundary
and possibility that the same attribute may not present, or not
defined in an agree-ed way, thus its data and meaning becomes a
conflict rather than an added-value. The situation becomes even worse
when certain aspect of this attribute is a moving target,
eg. interface changes a name, or VLAN gets re-named. Are these
networking management? or asset management?


To give an example: what does it mean when a server is _under
management_? First is to inventory (model, serial #,
components...). But this is certainly not sufficient. What's the
_state_ of it? (firmware version, BIOS settings). Then, reading these
and display them leads to the next step -- can we update them? Now
this is LXCA and its alternatives. But this leads to more, because
server _state_ is meaningful only to whoever is using it
(workloads).... on top of these, a deployment involving multiple
servers will have a shutdown or bootup sequence which may call for a
specific order because of data dependency &larr; don't shutdown
storage server before all its _writers_ have been turned off.

Therefore, managing a server will inevitably involve multiple
attributes at the same time, thus it must be a vertical view that cuts
through all the services mentioned above. In other words, previously
we extract a list of attributes from an object and build a system 
based on commonality of their meaning, eg. we put all serial numbers
into a system called "asset management", all fan speed and heat
assumption into a "energy management" system, and so on.
But such approach will always result in overlapping
presentation of the same object in multiple domains, which then
leads to a turf war that each fights over
whose reference is _more true than others_. A band-aid concept then is
brought up to build a [MDM][5], a place where all different references
are reconcilled so to have a consistency and authority. But then, any
secondary presentation of a data leads to a load of questions such as
data synchronization, data integrity, and whether MDM is a receiver of
first-line system, or the source for them? 

It should not be that way.

# A capability model

Instead, I am proposing a different approach. Take any attribute you
would like to _management_, I would define its management using a
model of **five levels of capabilities** (see below). The higher the
level of capability we implement, the more control we have over that
attribute, and having control is just another term for management.


<figure class="col s12 center">
  <img src="images/my%20capability%20model.png"/>
  <figcaption>Five levels of capabilities</figcaption>
</figure>



## level 1: inventory

This is capability of bookkeeping, such as an inventory of hardware as
seen in vanilla netbox. The distinguished character of data is that
they are static &mdash; serial number, UUID, and the like. Some data
are changed over time, such as rack position, but the frequency of its
change justifies it to be fully capable of a manual update.

Acceptable strategy:

1. manual, or import
2. auto &larr; discovery [confluent][3]

## level 2: reality, and/or, design

These two go hand-in-hand, and I'll explain why so.

Reality is referring to a form of **passive read** to collect
information &mdash; meta of a system, network traffic, interface name,
power state, host name, MAC address. It provides data to form a view
of **what we actually have**.

> Remember, in a machine world, if it can read once, it can read
> continuously for many many times.

If one can describe a reality, the same syntax shall be able to
describe also a **design** &mdash; an expectation of what we want to
have.

In any software-defined scheme, we can easily relate to a set of
_configuration values_ as the design, while their effects represent
the reality &mdash; I want to set host name to be "xyz", well, so what
is its name as of this moment? or in a programming language context,
reality is the `get` while design is the `set`.

But one curious thing of this level is that these two capabilities are
not both required! You can have a way to read reality, but may have no
way to match it to a design. For example, [`logdash`][4], is a reality
tool, not a design tool. Then there is Visio, PPT, Word, that you can
write all about your design, and they will not do anything to convert
your text to a line of code or a configured system.

Acceptable strategy:

1. For monitoring, auto ONLY (manual is meaningless).

## level 3: diff

**Diff = reality - design**.  If you have ever been in a brainstorm
session of new idea, this is what got most people execited about,
because it quickly leads to: customer configurable threshold, and
**alerts**. Now everybody is picturing a buzzing text message, or at
least an email, to alert an admin in the middle of a night when **a
diff exceeds a threshold** &larr; it feels empowering, intelligent,
and machine like.

But this is a lot harder than many would like to believe. The
challenge lies in the detail of the **design** &larr; what consists of
your design? what are the indexes? values? definition of done? Few
people are good at describing what they want in an upfront
fashion. Often enough it becomes a guess game, while either both
parties enjoy, or one gets completly annoyed and frustrated.


> You: I want to buy a ticket.
> Agent: where are you going?
> You: Raleigh, NC.
> Agent: here it is.
> You: But it's no good.
> Agent: What do you mean?
> You: It's not a United Airline flight.
> Agent: Oh, np. Here is a UA ticket.
> You: No good.
> Agent: Why?
> You: It's a morning flight!
> Agent: What would you prefer?
> .....

Challenge is in the hand of designer &mdash; how well can s/he list
out a list of preferences, and how important they are... if you have
written software requirements, you know most, if not all projects, die
right here.

Acceptable strategy:

1. auto (manual is meaningless).

## level 4: design &rarr; reality

As soon as one can monitor and validate (level 3 capabilities), the
next logical step is to **make design into reality**. This at least
takes care of Day 0 deployment. It requires:

1. a syntax to describe design, 
2. a tool to convert it into executable instructions, 
3. a monitoring service/agent to read where we are
4. a validation/diff to know how far are we from destination

To user, this is what they will call a `state` &mdash; they give you a
wish list, and you are the genie in a bottle.

Acceptable strategy:

1. paper instruction
2. some level of automation
3. many orchestration tools all claim to achieve this with zero pains.

## level 5: diff &rarr; design

If level 4 gets your design to a reality on day 1, then system will
inevitably drift and diff from design over time. Alert is nice, but
self-correction is better.

Different from design &rarr; reality, diff is essentially a moving
target. Unlike design which is a static set of expectations, diff can
expose a value on one has thought about. Thus a capability to bring
diff back into designed state is a challenge.

Acceptable strategy:

1. Full re-build: wipe it clean and re-build as if new.
2. Incremental correction.
3. Hybrid: this is the hardest one, also the most likely approach,
   because it involves a decision of when we should just wipe it clean
   and rebuild, and when a correction is preferred.

# An exercise

Let's try it with managing a server. 

<figure class="col s12 center">
  <img src="images/netbox%20device.png"/>
  <figcaption>Example: netbox device model</figcaption>  
</figure>

**Filling a value to each and every attribute field does not make the
server managed**. Instead, we should examine one attribute at a time. Take
`primary_ip4` attribute for example:

1. level 1: can we document/inventory its value?
2. level 2: 
    1. reality: can we discover IP and match it with a server?
    2. design: can we define an IP for a server before this IP actually
      exists?
3. level 3: can we audit and sound an alarm if there is a diff?
4. level 4: can we command this server to obtain a pre-defined IP?
5. level 5: if diff is detected, can we do sonmething to re-obtain the original IP
   besides sounding an alarm?

In Netbox, this capability stops at level 1. It can inventory, but has
no discovery capability, no design capability, thus having no level
3-5 capabilities either. Therefore, the IP attribute of a
server in Netbox is managed at Level 1, if that satisfies your requirement.

# Conclusion


There is no silver bullet. View, framework, paradigm, these are just
convenient words, labels, jargons, or BS-es. Attribute is often real
and concrete &mdash; a rack position, a serial number;
but its management is ambiguous. However, following a vertical view
in term of these capabilities, we can at least create five
placeholders for each and every, thing, that you want to call to
manage, and ask to fill these blanks before claiming it is managed
just because it is in a "management system".

My 2 cents.

[1]: https://en.wikipedia.org/wiki/Data_center_infrastructure_management
[2]: http://netbox.readthedocs.io/en/latest/
[3]: https://github.com/xcat2/confluent/
[4]: https://www.elastic.co/products/logstash
[5]: https://en.wikipedia.org/wiki/Master_data_management
