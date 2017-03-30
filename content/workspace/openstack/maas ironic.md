Title: Openstack Ironic vs. Canonical MAAS
Date: 2017-03-30 10:20
Tags: openstack
Slug: maas and ironic
Author: Feng Xia
Status: Draft

This article is to analyze Openstack Ironic and Canonical MAAS, both
are tools to turn baremetal into a pool of managed resources that are ready for
consumption by upstream srervice.

# Baremetal life cycle

The general process of managing a baremetal is straightforward.
Baremetal life cycle can be viewed in the following states. Names and
details of each state and state transitions differ, but the concept
remains valid. On the highest level, a baremetal is either managed or
not-managed. Being **managed** requires that the manager is aware of
the existence of the baremetal, and has acquired necessary information
of the server so that these two things are now possible:

1. Power cycle the server
2. Install an operating system

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/baremetal%20lifecycle.png" />
    <figcaption>General baremetal life cycle</figcaption>
</figure>


1. <font color="myhighlight">unknown</font>: Baremetal is not managed.
2. <font color="myhighlight">enlisted</font>: Manager is now aware of
   the existence of the baremetal. It does not yet have sufficient
   information to cycle its power or loading anything to execute on it.
3. <font color="myhighlight">ready for provisioning</font>: Sometimes
   also called _hardware inventory_ phase, in which the manager has
   acquired capability to control the server's power. Knowing other
   server characteristics is not really _required if using PXE boot_ during
   provisioning because the first image loaded can potentially does
   more inventory when it runs.
4. <font color="myhighlight">provisioned</font>: an operating system
   or a bootable file systems have been written to a disk that
   will be used by the server from this point on. 
5. <font color="myhighlight">in use</font>: The server is running user
   workload.
6. <font color="myhighlight">maintenance mode</font>: a catch-all
   state that a baremetal is not available for regularly and needs
   operator intervene. 
