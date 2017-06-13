Title: MAAS vs. Ironic
Date: 2017-03-30 10:20
Tags: lenovo
Slug: maas and ironic
Author: Feng Xia


This article is to analyze Openstack Ironic and Canonical MAAS, both
are tools to turn baremetal into a pool of managed resources that are
ready for consumption by upstream srervice.  On the highest level, a
baremetal is either managed or not-managed. Being **managed** requires
that the manager is aware of the existence of the baremetal, and has
acquired necessary information of the server so that these two things
are now possible:

1. Power cycle the server
2. Install a software such as operating system

The general process of managing a baremetal is straightforward.
Baremetal life cycle can be viewed in the following states. Names and
details of each state and state transitions differ, but the concept
remains valid. 

1. <span class="myhighlight">unknown</span>: Baremetal is not managed.
2. <span class="myhighlight">enlisted</span>: Manager is now aware of
   the existence of the baremetal. It does not yet have sufficient
   information to cycle its power or loading anything to execute on it.
3. <span class="myhighlight">ready for provisioning</span>: Sometimes
   also called _hardware inventory_ phase, in which the manager has
   acquired capability to control the server's power. Knowing other
   server characteristics is not really _required if using PXE boot_ during
   provisioning because the first image loaded can potentially does
   more inventory when it runs.
4. <span class="myhighlight">provisioned</span>: an operating system
   or a bootable file systems have been written to a disk that
   will be used by the server from this point on. 
5. <span class="myhighlight">in use</span>: The server is running user
   workload.
6. <span class="myhighlight">maintenance mode</span>: a catch-all
   state that a baremetal is not available for use in normal states and needs
   operator intervene.
   
<figure class="row">
    <img class="img-responsive center-block"
    src="/images/baremetal%20lifecycle.png" />
    <figcaption>General baremetal life cycle</figcaption>
</figure>


# Comparison framework

Using their APIs as reference, we have
grouped their functions
into the following subject domains for discussion purpose:

+ minimal setup
* power
* select boot order
* new server discovery and enlisting
* server inventory
* image
* OS provisioning
* networking
+ storage and partition
+ deployment customization
+ server grouping
+ multi-tenant

# Minimal setup

| Minimal setup       | MAAS                           | Ironic                        |
|---------------------|--------------------------------|-------------------------------|
| DHCP service        | y                              | y                             |
| TFTP service        | y "no" is using diskless image | y "no" if using iSCSI drivers |
| External image repo | n                              | y                             |
| BMC network         | depends on driver              | depends on driver             |
| Tenant network      | y                              | y                             |
| Provision network   | y                              | y                             |

<div class="my-multicol-2">
<figure class="col s12">
    <img class="img-responsive center-block"
    src="/images/maas%20minimum%20setup.png" />
    <figcaption>MAAS minimal setup</figcaption>
</figure>
<figure class="col s12">
    <img class="img-responsive center-block"
    src="/images/ironic%20minimal%20setup.png" />
    <figcaption>Ironic minimal setup</figcaption>
</figure>
</div>

# Power

The minimum capability in managing power includes two aspects:
querying current power state and set power state.
Both [Ironic][1] and [MAAS][2] support IPMI
interface. MAAS's has more vendor centric implementations
where Ironic's are more general purposed.

[1]: https://wiki.openstack.org/wiki/Ironic/Drivers
[2]: https://docs.ubuntu.com/maas/2.1/en/installconfig-power-types


| Power type                            | MAAS                                             | Ironic                       |
|---------------------------------------|--------------------------------------------------|------------------------------|
| Intel AMT                             | using `amttool`,`amtterm` or `wsman`, `wsmancli` |                              |
| American Power Conversion (APC) -PDU  | using `snmpset`, `snmp`                          |                              |
| Digital Loggers, Inc. - PDU           | HTTP GET, state is parsed from a HTML            |                              |
| Facebook's Wedge                      | SSH, run command `/usr/local/bin/wedge_power.sh` |                              |
| Fence CDU (Redhat cluster)            | using `fence-agents`                             |                              |
| IBM Hardware Management Console (HMC) | SSH, run command `chsysstate`                    |                              |
| General IPMI                          | `freeipmi-tools`                                 | [`ipmitool`][3], [pyghmi][7] |
| Microsoft OCS - Chassis Manager       | using HTTP GET, can set next boot device         |                              |
| HP Moonshot - iLO4                    | `ipmitool`                                       |                              |
| HP Moonshot - iLO Chassis Manager     | SSH, run command                                 |                              |
| SeaMicro 15000                        | [`ipmitool`][3]                                  | x                            |
| Cisco UCS Manager                     | HTTP GET, parameters in url                      |                              |
| OpenStack Nova                        | NOVA API                                         |                              |
| VMware                                |                                                  |                              |
| KVM/Virsh                             | `virsh`, `virt-login-shell`, `libvirt-bin`.      | SSH                          |
| Manual                                |                                                  |                              |
| Dell Remote Access Controller (DRAC)  |                                                  | `drac` driver                |
| HP ProLiant servers                   |                                                  | `ilo` driver                 |
| Cisco IMC                             |                                                  | [imcsck][4]                  |
| iRMC SerView Common Command Interface |                                                  | [scciclient][5]              |
| HPE OneView                           |                                                  | [oneviewclient][6]           |
| General SNMP                          |                                                  | x                            |
| VirtualBox                            |                                                  | SSH                          |
| iboot                                 |                                                  | x                            |
| Wake-On-Lan                      |                                                  | x                            |


[3]: http://ipmitool.sourceforge.net/
[4]: https://github.com/CiscoUcs/imcsdk
[5]: https://github.com/openstack/python-scciclient
[6]: https://github.com/openstack/python-oneviewclient
[7]: https://github.com/openstack/pyghmi

# Boot order

| Select boot order            | MAAS                     | Ironic          |
|------------------------------|--------------------------|-----------------|
| Using IPMI driver            | n                        | y               |
| Using vendor specific driver | Mirosoft OCS driver only | vendor passthru |

Except Microsoft OCS driver, MAAS has no support to select
or change  boot order, even in its IPMI-based drivers.

Ironic, however, supports selecting [boot device][19] using
`*_ipmitool` drivers. It also has _vendor passthrough_ feature which
allows passing in vendor specific instructions in driver, thus giving
the possibility to manipulate the server beyond standard functions.

[19]: https://developer.openstack.org/api-ref/baremetal/?expanded=update-node-detail,set-boot-device-detail,inject-nmi-non-masking-interrupts-detail#set-boot-device

# New server discovery and enlisting

| Server discovery and enlisting | MAAS | Ironic |
|--------------------------------|------|--------|
| Discover new server            | y    | n      |
| Enlisting MAC address          | auto | manual |


MAAS can discover new server by monitoring  DHCP data packet given that MAAS is
the DHCP server serving the subnet that baremetals are
connected to. Discovered server will be registered as *NEW*
and is ready for inventory. At this point MAAS has only the MAC
address that was broadcasted from DHCPREQUEST.

Ironic has no method to auto-discover a new server. It can only
register them through command line or its API interface. So it
requires either a manual process (command line) or programming.
But because of this enlisting a node in Ironic term can include a
wealthy of information more than its MAC address.

# Server inventory

| Server inventory  | MAAS                       | Ironic          |
|-------------------|----------------------------|-----------------|
| CPU               | y                          | y               |
| Memory size       | y                          | y               |
| Partition size    | y                          | y               |
| Network interface | y                          | y               |
| Mechanism         | cloud-init running scripts | special ramdisk |


Server inventory is to inspect the server for hardware features such
as the number of CPUs, memory size, disk size and partition. MAAS
handles this in a separate step, **Commission**, after
discovery, where this is optional in Ironic.

MAAS does so by loading a minimal Ubuntu image at next boot
and run commissioning scripts to harvest
system information:

1. DHCP server is contacted
2. kernel and initrd are received over TFTP
3. machine boots
4. initrd mounts a Squashfs image ephemerally over iSCSI
5. cloud-init runs commissioning scripts
6. machine shuts down


Ironic, on the other hand, relies on a separate
setup, [Ironic Inspector][8] to orchestrate this process (see [steps][19] below). The
principle is the same that Inspector will acquire credentials to
manage the node power from Ironic, then using that to PXE rebooting
the node and load a ramdisk. The difference is, however, that ramdisk
is not limited to Ubuntu.
[8]:https://docs.openstack.org/developer/ironic-inspector/
[19]: https://docs.openstack.org/developer/ironic-inspector/workflow.html#state-machine-diagram

1. Operator sends nodes on introspection using ironic-inspector API or CLI
2. On receiving node UUID ironic-inspector:
    * validates node power credentials, current power and provisioning states,
    * allows firewall access to PXE boot service for the nodes,
    * issues reboot command for the nodes, so that they boot the ramdisk.
    * The ramdisk collects the required information and posts it back to ironic-inspector.
3. On receiving data from the ramdisk, ironic-inspector:
    * validates received data,
    * finds the node in Ironic database using it’s BMC address (MAC address in case of SSH driver),
    * fills missing node properties with received data and creates
      missing ports.


# Image

| Image               | MAAS | Ironic |
|---------------------|------|--------|
| Build-in image repo | y    | n      |
| Ubuntu              | y    | y      |
| CentOS              | y    | y      |
| SUSE                | y    | y      |
| Windows server      | y    | y      |
| RHEL                | n    | y      |

MAAS has built-in capability to work as an image repository. Ironic
relies on helper service, such as Glance, to handle images.

In `src/provisioningservers/drivers/osystem/__init__.py`, MAAS
categories images into five usages: commissioning, install (regular
ISO image), xinstall (.tgz of root `/`), diskless(`tgt-admin`) and bootloader. 


MAAS has a fair restricted list of what it supports, where Ironic is
happy to use any bootable image since it delegates this management to
other service such as Glance. Details of MAAS image handling can be
found in `src/provisioningservers/drivers/osystem`. Here is a list
defaults MAAS supports:

* Ubuntu: all LTS releases
* CentOS: 6.5
* SUSE: openSUSE 13.1 
* Windows:
    * Windows Server 2012
    * Windows Server 2012 R2
    * Windows Hyper-V Server 2012
    * Windows Hyper-V Server 2012 R2
    * Windows Server 2016
    * Windows Nano Server 2016

One can also use MAAS CLI to add _custom_ images to repo, where `name` must in
format `custom/xxx`. For CentOS, the name must be in format `centos72`
for example because of MAAS's regex parser.

<pre class="brush:plain;">
maas local boot-resources create name=custom/foo title="Title is not important" architecture=amd64/generic content@=/path/to/your/image
maas local boot-resources import
</pre>

# OS provisioning

| OS provisioning        | MAAS       | Ironic            |
|------------------------|------------|-------------------|
| PXE                    | y          | y                 |
| iSCSI                  | y          | y                 |
| Select boot order      | n          | y                 |
| Agent-based deployment | n/a        | y                 |
| Post-seed operation    | cloud-init | cloud configdrive |


First of all, both support PXE. This is standard and not much to talk
about. In term of iSCSI, both has implementation, but with different objectives.
Ironic conductor([code][11]) will use the SCSI disk to write image data;
MAAS, on the other hand, uses `tgt-admin` for the job, and
its objective is to **[re-use][12]** an existing root `/` file system. 

[11]: https://docs.openstack.org/developer/ironic/_modules/ironic/drivers/modules/iscsi_deploy.html
[12]: https://blueprints.launchpad.net/maas/+spec/t-cloud-maas-diskless

Second, MAAS lacks the capability to change
boot order. Therefore, a provisioned server will be seemed 
_out of management_ from that point on
because booting from HD is now preferred instead of PXE.
It solves this chicken-egg problem by installing a default account
and SSH credential so they can continue management. Instead, Ironic
can use IPMI driver to set boot device so it does not create
such artificial user account in the system.

Third, Ironic has an agent-based deployment method that a
ramdisk with [IPA][15] installed will be loaded first. Once the agent is
running, it can take further commands including partitioning
(`parted`), mounting remote disk (iSCSI), cleaning disk, and write
OS image to disk.
[15]: https://docs.openstack.org/developer/ironic-python-agent/

Fourth, post-seed operation. MAAS API can accept a `Base64` encoded
`user-data` string used by cloud-init in next boot, where Ironic API
can accept cloud [configdrive][13] string.
[13]: https://developer.openstack.org/api-ref/baremetal/?expanded=change-node-provision-state-detail#change-node-provision-state


# Networking

| Networking                 | MAAS   | Ironic |
|----------------------------|--------|--------|
| Serve DHCP                 | y      | n/a    |
| Use static IP              | y      | n/a    |
| Limite IP ranges           | y      | n/a    |
| Store node's IP            | y      | y      |
| Store subnet               | y      | n      |
| Store VLAN                 | y      | n      |
| Concept of subnet grouping | space  | n/a    |
| Concept of VLAN grouping   | fabric | n/a    |


Ironic does not handle networking. In Openstack, Neutron will be
providing this service.

MAAS understands `subnet` and `vlan`. Subnets can be further grouped
into `space` and vlans into `fabric`. It also
supports [container fan network][14], which Neutron has no support either.

[14]: https://wiki.ubuntu.com/FanNetworking?_ga=1.139973107.197000268.1480367852

Further, MAAS can reserve IP ranges to assign to discovered nodes, CRUD interface on a
particular node, link an interface to a VLAN, and even create a bridge
interface on node. None of these Ironic can do or care.

# Storage and partition

| Storage and partition               | MAAS | Ironic |
|-------------------------------------|------|--------|
| Can configure disk partitions       | y    | n/a    |
| Can deploy partition image          | y    | n      |
| Can put partition on logical volume | n    | n/a    |


MAAS API supports CRUD operations for partitions. According to its
[document][9], it bears a few limitations:
[9]: https://docs.ubuntu.com/maas/2.1/en/installconfig-partitions

* An EFI partition is required to be on the boot disk for UEFI.
* You cannot place partitions on logical volumes.
* You cannot use a logical volume as a Bcache backing device.

Ironic has **no** API in this regards. By default it will only deploy
image to full disk. A [spec][10] has been called for to handle
partition image implemented through [IPA][15].

[10]: https://specs.openstack.org/openstack/ironic-specs/specs/kilo/partition-image-support-for-agent-driver.html

# Deployment customization

| Deployment customization | MAAS                                     | Ironic |
|--------------------------|------------------------------------------|--------|
| use custom image         | y                                        | y      |
| user scripts             | during inspection, commissioning scripts | n      |
| cloud-init               | y                                        | n      |
| cloud configdrive        | n                                        | y      |
| kernel options           | y                                        | n      |

Both can boot from a custom image (see "Image" for details).
MAAS provides three more entry points to influence the
result: commissioning scripts, [kernel option][18], and cloud-init
`user-data`. Commissioning scripts are run to collect server hardware
information. Kernel options can be either global or per-node based.
One can also pass on a cloud-init `user-data` string that MAAS will
use in booting.
 
[18]: https://docs.ubuntu.com/maas/2.1/en/installconfig-nodes-kernel-boot-options

Similarly, Ironic API accepts cloud configdrive string. Since it can have an
agent-based deployment, it is also possible to instruct the agent
to run some commands or scripts. However, there is no method to pass
in kernel options.

# Server grouping

| Server grouping | MAAS | Ironic |
|-----------------|------|--------|
| chassis         | n    | y      |
| rack            | n    | n      |
| region          | y    | n      |
| zone            | y    | n      |

MAAS has created concept of `zone` and zones can be further grouped
into `region`. As a matter of fact, MAAS also has a concept of _region
controller_ which can then manage multiple _rack controller_.

From MAAS [document][16]:
[16]: https://docs.ubuntu.com/maas/2.1/en/intro-concepts#zones
> Zone:
> A physical zone, or just zone, is an organizational unit that contains
> nodes where each node is in one, and only one, zone. Later, while in
> production, a node can be taken (allocated) from a specific zone (or
> not from a specific zone). Since zones, by nature, are custom-designed
> (with the exception of the 'default' zone), they provide more
> flexibility than a similar feature offered by a public cloud service
> (ex: availability zones).
>
> Some prime examples of how zones can be put to use include
> fault-tolerance, service performance, and power management. 
>
> A newly installed MAAS comes with a default zone, and unless a new
> zone is created all nodes get placed within it. You can therefore
> safely ignore the entire concept if you're not interested in
> leveraging zones.
>
> The 'default' zone cannot be removed and its name cannot be edited.

Ironic provides no similar grouping concept. That level of management
is left for other service (eg. NOVA) to handle.

# Multi-tenant

| Multi-tenant                    | MAAS | Ironic |
|---------------------------------|------|--------|
| Support multi-tenant separation | n    | y      |

MAAS has no capability to manipulate an existing network layout. Its
concept of fabric and space are artificial groupings only. Therefore,
it has no say in multi-tenant support. In many cases, baremetal
servers are put on the same network &mdash; provisioning network &mdash; 
as the MAAS server because that's how MAAS can discover and enlist
new servers, thus exposing all tenants to each other (see section
"Minimal setup" for details.)

Ironic has not concept of multi-tenant either. However, it can
dynamically _bind_ a port to use, where port is then managed by
service such as Neutron. This leaves Ironic not suffering from the
same risk that MAAS setup may have.

