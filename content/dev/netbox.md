Title: Netbox revised
Date: 2018-06-06 14:00
Tags: dev, lenovo
Slug: netbox
Author: Feng Xia


[Netbox][2] is a nice level 1 tool (for levels, see [capability model][1]).
But we need more. Managing a lab or a rack is more than level 1. On
top of all these, we talk about automation, which implies capabilities
at least to level 4. Therefore, we used Netbox code as a starting
point, and built a POC.

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

There are essentially two type of models: logical and physical. Logic
models are logical relationships, eg. device &rarr; tenant. Tenant is
nothing but a logical concept. Physical models are describing a
relationship that requires a physical connection, eg. an interface is
connected to a switch port (via a cable).

# Device

The center piece of Netbox models is the `Device`, representing a
physical device such as server and switch. This makes sense as the
primary physical asset of a data center are certainly these devices. 

<figure class="col s12 center">
    <img src="/images/netbox%20device%20list.png"/>
    <figcaption>Example list of devices</figcaption>
</figure>

## Device role

`DeviceRole` is a user-defined value list that can be assigned to a
device. Its common use is to group device by its function, such as
what we see above &mdash; "Management Switch", "Ceph".

A device role also defines a color, thus making a color-coded
presentation of a list of devices possible.


## Device type

`DeviceType` describes attributes such as manufacturer and model. There
are two important flags that will affect how a device can be used:

2. is a `network device`? &larr; if not, the device will not have
   an interface &rarr; therefore, it will not be able to link to an IP!
3. can have `child device`? &rarr; if not, it will not have bay device
   (we model BMC controller as a bay device inside a server).

<figure class="col s12 center">
    <img src="/images/netbox%20devicetype%20list.png"/>
    <figcaption>Example list of device types</figcaption>
</figure>


## Access a device

How to access a device? In bare essence
we need three things: **(IP, username, password)** (we will explain
Netbox's way to control password in a later section). Further, we use
`platform` value to determine access method:

1. `linux`: SSH
2. `Lenovo ENOS/CNOS`: these are Lenovo switch operating systems, and
   access method is Telnet (see [Network switch][3] for details.)

<figure class="row center">
    <img src="/images/netbox%20device%20section%201.png"
        class="col s6"/>
    <img src="/images/netbox%20device%20section%202.png"
        class="col s6"/>
    <figcaption>Device IP & credential. A device can have multiple
    IP address but only one primary IP4 & IP6. It can also
    have multiple credentials. We are using credential type
    "Nanagement" to highlight the one to use.</figcaption>
</figure>

## Interface & topology

A device whose device type sets `is_network_device=True` can be linked
to an `Interface`, and an interface can be linked to an IP address.

<figure class="col s12 center">
    <img src="/images/netbox%20device%20interface.png"/>
    <figcaption>Device interfaces</figcaption>
</figure>

An `InterfaceConnection` linking two interfaces is the corner stone
to describe a network topology:

```python

CONNECTION_STATUS_PLANNED = False
CONNECTION_STATUS_CONNECTED = True
CONNECTION_STATUS_CHOICES = [
    [CONNECTION_STATUS_PLANNED, 'Planned'],
    [CONNECTION_STATUS_CONNECTED, 'Connected'],
]

class InterfaceConnection(models.Model):
    """
    An InterfaceConnection represents a symmetrical, one-to-one
    connection between two Interfaces. There is no significant
    difference between the interface_a and interface_b fields.
    """
    interface_a = models.ForeignKey(
        'Interface',
        related_name='connected_as_a',
        on_delete=models.CASCADE)
    interface_b = models.ForeignKey(
        'Interface',
        related_name='connected_as_b',
        on_delete=models.CASCADE)
    connection_status = models.BooleanField(
        choices=CONNECTION_STATUS_CHOICES,
        default=CONNECTION_STATUS_CONNECTED,
        verbose_name='Status')

```

In the example topology diagram below, we see:

1. Connect between port #34 of a switch (`LCTC-R1U39-SW`) to a BMC
   interface (`ceph-1` is the BMC controller's name).
2. A server (`ceph-node-brain2`) has two interfaces &mdash; `eno1` and
   `ens4f1`, where:
   
    1. `eno1` is connected to port 2 of a switch (`R1U39`), and
    2. `ens4f1` is connected to port 18 of another switch (`R1U37`).

<figure class="col s12 center">
    <img src="/images/netbox%20device%20topology.png"/>
    <figcaption>Example device view of a topology</figcaption>
</figure>



## Children device (`DeviceBay`)

A device can have device bays, which essentially forms a
`parent-children` relationship. One use case of this relationship is
to register BMC controller as a bay device inside a server:

<figure class="col s12 center">
    <img src="/images/netbox%20device%20bay%20device.png"/>
    <figcaption>Device bay</figcaption>
</figure>

Conditions to form a parent-child relationship:

1. parent device allows bay/child (defined in `DeviceType`)
2. one can not install into itself

## Related device

`Related devices` is defined as devices that:

1. belong to the same `site`
2. and has the same device role

In Netbox this is only a convenience for navigation. However
we can extend this idea using other definitions.

<figure class="col s12 center">
    <img src="/images/netbox%20device%20related%20devices.png"/>
    <figcaption>Related devices</figcaption>
</figure>

## Grouping

Just how many ways one can group devices? Maybe too many. **Note**
that there are overlapping groups which are very confusing!

1. Rack can also be grouped by `Site`.
2. Both rack and site can be grouped by `Tenant`.


```python
device_type = models.ForeignKey(
    'DeviceType',
    related_name='instances',
    on_delete=models.PROTECT)
device_role = models.ForeignKey(
    'DeviceRole',
    related_name='devices',
    on_delete=models.PROTECT)
tenant = models.ForeignKey(
    "tenancy.Tenant",
    blank=True, null=True,
    related_name='devices',
    on_delete=models.PROTECT)
platform = models.ForeignKey(
    'Platform', related_name='devices',
    blank=True, null=True,
    on_delete=models.SET_NULL)
site = models.ForeignKey(
    'Site', related_name='devices',
    on_delete=models.PROTECT)
rack = models.ForeignKey(
    'Rack', related_name='devices',
    blank=True, null=True,
    on_delete=models.PROTECT)
```


# Rack

Rack is the physical grouping of devices. The most important thing
about rack is whether it has availabe space to **contain a device**:

1. rack height
2. how much have been reserved (`RackReservation`)?
3. what devices does it already have? what are their height and
   depth? 
   
Depth comes to play because some devices can be half-depth, thus
allowing two devices in the same slot &mdash; one facing the front,
and one facing the back. Also, it is common that top-of-rack switch is
mounted facing back so that cables can access its port.
   
   
<figure class="col s12 center">
    <img src="/images/netbox%20rack.png"/>
    <figcaption>Example of a rack</figcaption>
</figure>

There are four ways to group racks:

```python
site = models.ForeignKey(
    'Site', related_name='racks',
    on_delete=models.PROTECT)
group = models.ForeignKey(
    'RackGroup', related_name='racks',
    blank=True, null=True,
    on_delete=models.SET_NULL)
tenant = models.ForeignKey(
    Tenant,
    blank=True, null=True,
    related_name='racks',
    on_delete=models.PROTECT)
role = models.ForeignKey(
    'RackRole',
    related_name='racks',
    blank=True, null=True,
    on_delete=models.PROTECT)
```




[1]: {filename}/thoughts/capability%20model.md
[2]: http://netbox.readthedocs.io/en/latest/
[3]: {filename}/workspace/lenovo/switches.md
