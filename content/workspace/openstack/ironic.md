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
_orchestrate_ all these pieces together. In other words, Ironic is
quite useless without these services, and just powering on and off
those baremetals don't do much unless all these other pieces are
installed and configured.

So in the following sections I'd like to use the questions I have
encountered in research to create a developer-oriented tutorial on
Ironic. In particular, I'd like to illustrate a few Ironic internals
to show what "managing baremetal" is actually doing.

# Baremetal vs. server

There is a distinction between baremetal and server &rarr; there can
be more than one servers within a baremetal box. The common format,
however, is one server per baremetal. A server, in turn, can have many
CPUs, memory, storage, network cards, and so on and so forth.

When we _provision_ a baremetal &mdash installing an OS on it &mdash;
we are actually putting an OS on a server, more precisely, on a
server's disk (somewhere).

A baremetal box can have __0__ server installed. But the box always have an
interface that allows operator access. An example
will be IBM/Lenovo's [IMM][1]. Think of it as a backdoor to a
baremetal when all servers on it failed for some reason, and this interface
thus is the key to Ironic.   

[1]: http://systemx.lenovofiles.com/help/index.jsp?topic=%2Fcom.lenovo.sysx.5462.doc%2Fc_using_imm.html

# Ironic drivers

Ironic driver is an interface to a baremetal.  

# What make an Ironic node useful?

Ironic node is the abstraction of a server. 
