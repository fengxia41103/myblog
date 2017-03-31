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

On the highest level, a baremetal is either managed or
not-managed. Being **managed** requires that the manager is aware of
the existence of the baremetal, and has acquired necessary information
of the server so that these two things are now possible:

1. Power cycle the server
2. Install a software such as operating system

# Comparison framework

Both tools provide a RESTful API. Comparison is therefore done using
the APIs as reference to analyze different capabilities each tool
offers for a caller function. We'll artificially group these functions
into the following subject domains for discussion purpose:

* power
* select boot order
* new server discovery and enlisting
* server inventory
* image
* OS provisioning
* networking
    * interface
    * subnet
    * vlan
    * grouping
+ storage and partition
+ placement
+ customization
    * commissioning scripts pre and post
    * kernel option
    * cloud init, cloud config
+ multi-tenant
+ barebone setup

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
| Wake-On-Language                      |                                                  | x                            |


[3]: http://ipmitool.sourceforge.net/
[4]: https://github.com/CiscoUcs/imcsdk
[5]: https://github.com/openstack/python-scciclient
[6]: https://github.com/openstack/python-oneviewclient
[7]: https://github.com/openstack/pyghmi

# Boot order

Except the MAAS's Microsoft OCS driver, there is no support to select
or change  boot order even among those IPMI drivers.

# New server discovery and enlisting

MAAS can discover new server through DHCP data packet provides MAAS is
the DHCP server serving the subnet that baremetal servers are
connected to. New server will be registered as *NEW*
and is ready for inventory. At this point MAAS has only the MAC
address that was broadcasted from DHCPREQUEST.
More details can be found in section "Barebone setup".

Ironic has no method to auto-discover a new server. It can only
register them through command line or its API interface. So it
requires either a manual process (command line) or programming.
But because of this enlisting a node in Ironic term can include a
wealthy of information other than its MAC address.

# Server inventory

Server inventory is to inspect the server for hardware features such
as the number of CPUs, memory size, disk size and partition. MAAS
handles this in a separate step, **Commission**, after
discovery, where this is optional in Ironic.

MAAS does so by loading a minimal Ubuntu image at next boot (must be
PXE booting) and the image will then load some tools for hardware
discovery.

Ironic, on the other hand, relies on a separate
setup, [Ironic Inspector][8] to orchestrate this process. The
principle is the same that Inspector will acquire credentials to
manage the node power from Ironic, then using that to PXE rebooting
the node and load a ramdisk. The difference is, however, that ramdisk
is not limited to Ubuntu.
[8]:https://docs.openstack.org/developer/ironic-inspector/

# Image

MAAS has built-in capability to work as an image repository. Ironic
relies on helper service, such as Glance, to handle images.

In `src/provisioningservers/drivers/osystem/__init__.py`, MAAS
categories images into five usages: commissioning, install (regular
ISO image), xinstall (.tgz of root `/`), diskless(`tgt-admin`) and bootloader. 


MAAS has a fair restricted list of what it supports, where Ironic is
happy to use any bootable image. Details of MAAS image handling can be
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

First of all, both support PXE. This is standard and not much to talk
about. In term of iSCSI, both has implementation, but with different objectives.
Ironic [code][11] will use the SCSI disk for partition and image
deployment. MAAS, on the other hand, uses `tgt-admin` for the job, and
its objective is to **[re-use][12]** an existing root `/`. 

[11]: https://docs.openstack.org/developer/ironic/_modules/ironic/drivers/modules/iscsi_deploy.html
[12]: https://blueprints.launchpad.net/maas/+spec/t-cloud-maas-diskless

Second, both tools lack the capability to change
boot order. Therefore, a provisioned server will be seemed 
_out of management_ from that point on
because booting from HD is now the default instead of PXE.
Both solve this chicken-egg problem by installing a default account
and SSH credential so they can login the system.

Third, Ironic developed an agent-based deployment method that a
ramdisk with IPA installed will be loaded first. Once the agent is
running, it can take further commands including partitioning
(`parted`), mounting remote disk (iSCSI), cleaning disk, and write
OS image to disk.

Fourth, post-seed operation. MAAS API can accept a `Base64` encoded
`user-data` string used by cloud-init in next boot, where Ironic API
can accept cloud [configdrive][13] string.
[13]: https://developer.openstack.org/api-ref/baremetal/?expanded=change-node-provision-state-detail#change-node-provision-state


# Networking
    * interface
    * subnet
    * vlan
    * grouping

# Storage and partition

MAAS API supports CRUD operations for partitions. According to its
[document][9], it bears a few limitations:
[9]: https://docs.ubuntu.com/maas/2.1/en/installconfig-partitions
* An EFI partition is required to be on the boot disk for UEFI.
* You cannot place partitions on logical volumes.
* You cannot use a logical volume as a Bcache backing device.

Ironic has **no** API in this regards. By default it will only deploy
image to full disk. A [spec][10] has been called for to handle
partition image implemented through IPA.

[10]: https://specs.openstack.org/openstack/ironic-specs/specs/kilo/partition-image-support-for-agent-driver.html

# Barebone setup

 
