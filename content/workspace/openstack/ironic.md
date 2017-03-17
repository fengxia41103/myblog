Title: Openstack Ironic
Date: 2017-03-15 22:45
Tags: openstack
Slug: ironic intro
Author: Feng Xia
Status: Draft

This article is an outcome of my writing a Juju-Ironic provider. The
plan was to first figure out Ironic APIs that will achieve what Juju
provider needs &mdash; start an instance on demand, then build those
REST requests into Juju provider code. After playing with Ironic API
and Openstack's Devstack for two weeks, I start to realize that Ironic
by itself doesn't do much. Instead, it heavily relies on other
Openstack services to provision a baremetal &mdash; Keystone to
generate a token which will be used in all HTTP calls, Neutron to
provide network/_port_, Ironic itself to manage a _node_, Glance to
get kernel image, ramdisk image, and actual OS image, and Nova to
_orchestrate_ these information for Ironic API to consume. 


Ironic [user guide][1] has some good information on basic technology
and Ironic design. A [talk][3] & [slides][5] by [devananda][4] on 2015
Vancouver Summit is also a good point to start.


[1]: https://docs.openstack.org/developer/ironic/deploy/user-guide.html
[3]: https://www.openstack.org/videos/vancouver-2015/isn-and-039t-it-ironic-the-bare-metal-cloud
[4]: https://github.com/devananda
[5]: https://github.com/devananda/talks/blob/master/isnt-it-ironic.html

In the following sections I'd like to use the questions I have
encountered in research to create a developer-oriented tutorial on
Ironic. In particular, I'd like to illustrate a few Ironic internals
to show what "managing baremetal" is actually doing.

# Baremetal vs. server

First of all, there is a distinction between **baremetal** and
**server** &rarr; there can be more than one server within a
baremetal box. The common format, however, is one server per
baremetal. A server, in turn, can have many CPUs, memory, storage,
network cards, and so on and so forth. When we _provision_ a baremetal
&mdash; installing an OS on it &mdash; we are actually putting an OS
on a server, more precisely, on a server's disk (somewhere).

A baremetal box can have __0__ server installed. But the box always have an
interface that allows operator access ([IPMI][6]). An example
will be IBM/Lenovo's [IMM][2]. Think of it as a backdoor to a
baremetal. It is accessible even when the server is box is powered
off!

[2]: http://systemx.lenovofiles.com/help/index.jsp?topic=%2Fcom.lenovo.sysx.5462.doc%2Fc_using_imm.html
[6]: https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface

# Ironic deploy method

There are two deploy methods: [Ironic Python Agent (IPA)][7] and PXE. 

[7]: https://docs.openstack.org/developer/ironic-python-agent/#how-it-works

## Agent (IPA) method

Agent method means to boot a specially made ramdisk image on
baremetal. The magic is that agent knows where the Ironic API is. So
it will __lookup__ itself by sending Ironic API its MAC
address. Ironic will send back the node UUID. From that point on, IPA
will ping home (hearbeat) periodically until Ironic commands it to do
something. Part of the hearbeat payload is a callback URL, so IPA also
exposes a HTTP service that Ironic conductor can use for commands.

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/ironic_ipa_sequence.png" />
    <figcaption>Ironic Python Agent (IPA) sequence diagram</figcaption>
</figure>

# Hardware inventory

Hardware inventory is to collect characteristics such as the number of
CPUs, memory size, disk partition, MAC address and so on. I categorize
methods for such purpose into two buckets: out-of-band and
in-band. In-band inspection involves booting an OS on the target node
and fetching information directly from it. This process is more
fragile and time-consuming than the out-of-band inspection, but it is
not vendor-specific and works across a wide range of hardware.;
out-of-band, on the other hand, does not involve an OS. Instead,
information are collected by a built-in BMC controllera on the baremetal box
and are then queried through an IPMI interface.

In Ironic there are two ways to inventory hardware:

1. IPA's [hardware manager][9] &mdash; in-band only. Hardware manager is part of IPA's capability. They can run together
with IPA to collect node information. 
2. [Ironic Inspector][8] &mdash; in-band and out-of-band. Inspector is
a separate service running outside the target node. It exposes a
set of [API][10]. When caller `POST
/v1/introspection/<node_indent>`, inspector uses the UUID to
extract node's drive_info from Ironic DB. With the IPMI credentials it
can now control the node. Its [in-band inspection][11] will boot a
ramdisk.

[8]: https://docs.openstack.org/developer/ironic/deploy/inspection.html
[9]: https://docs.openstack.org/developer/ironic-python-agent/#hardware-managers
[10]: https://docs.openstack.org/developer/ironic-inspector/http-api.html#
[11]: https://docs.openstack.org/developer/ironic/deploy/inspection.html#in-band-inspection

# Image


# What make an Ironic node useful?

Ironic node is the abstraction of a server. 
