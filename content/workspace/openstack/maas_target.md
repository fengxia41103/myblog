Title: Targets in MAAS lab
Date: 2016-12-09 22:00
Tags: openstack
Slug: maas target
Author: Feng Xia

After setting up the MAAS server and its subnet, bringing up a target node
is simple.

> All nodes must be on the same **192.168.8.0/24** subnet, and
> they must support PXE boot.

# PXE boot

The MAAS machine functions as both the DHCP server and the TFTP server, both
are required to facilitate PXE booting. First, we creat a blank VM. The important
things are:

1. Under _System &rarr; Mother board &rarr; Boot order_, check the _Network_. However,
    it is not necessary to move the _Network_ boot above _Hard Disk_. When there is no OS
    deployed yet on the hard disk, boot process will fall through to PXE anyway. Once an OS
    has been installed, the machine will boot normally from HD.

    > If you put PXE as the first order,
    > this target will not boot into HD image at all.

2. Set _Network &rarr; Adapter 1 &rarr; Internal Network_, named _intnet_. This corresponds
    to the MAAS managed subnet of 192.168.8.0/24.

After this, start the target VM and it should PXE boot and will shut itself down at the end of the boot.

# MAAS machine life cycle

MAAS target goes through a life cycel as shown below:

<figure>
<img src="/images/maas_target_life_cycle.png" class="center-block img-responsive" />
<figcaption>MAAS target node life cycle</figcaption>
</figure>

## New

Once PXE booted, the MAAS server will automatically _enlist_ this machine
with a _New_ status. This indicates that machine has been discovered by MAAS.
The given node name is completely arbitrary, and it has nothing to do with VM's name.

> If there are multiple targets, the only way to match MAAS node name with a VM
> is through assigned IP addresses.

## Commission

This is the phase in which MAAS server tries to determine the CPU, memory, and disk information
of the target. Two important configurations to notice:

1. Power type: for our virtual lab, select _Manual_. Otherwise, the admin GUI will block you  from commissioning completely.
2. _Retain_: do **NOT** check such checkboxes. The word _retain_ means to keep what you have. Therefore, it will skip registering the target's disk information. This is super confusing because commission output details will show clearly the disk info. So the commission scripts run just fine and pulled everything correctly. It's the MAAS logic to ignore these returned values if user has checked _retain_.

## READY

If commissioning went through, MAAS server will now has all the information needed
to deploy something to this target. Think of machines in this state as a pool from which deployment can pick.

## Deploy

By far, target machine has nothing on it &mdash; it has a blank disk. First thing first,
we need to put an OS on it, and that's _deploy_ is about.

1. Take action &rarr; Deploy, and reboot target which should come up in PXE again.
2. MAAS admin will automatically change node's status to _Deploying_.
3. OS will be written to disk.

Once state switched to _Deployed_, verify by:

1. Goto _Subnet_ menu on MAAS web admin UI, look up the target's assigned IP address.
2. Boot up target machine &larr; it will now load from HD instead of PXE!

    <pre class="brush:bash;">
    ssh ubuntu@192.168.8.xxx
    </pre>

    Since deployed image has copied the SSH public key that we have created in
    steps of creating the MAAS server itself and have copied to the MAAS admin UI,
    you can now SSH to any deployed target without having a password.

## Release

Releasing a deployed target gives an option to erase disk. Again, taget has to be PXE-booted in order to be managed by the MAAS server.

> MAAS sever can not manage a deployed target unless it PXE boots.

If released and disk erased, the node becomes _READY_, again.
