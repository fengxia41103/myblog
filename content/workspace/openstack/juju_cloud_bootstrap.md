Title: Juju bootstrap process
Date: 2017-1-11 17:00
Tags: lenovo
Slug: juju bootstrap
Author: Feng Xia


The very first command user will encounter is the `juju bootstrap`. It
createa a special machine &mdash; state controller, `machine-0`, control
node, etc. &mdash; naming convention aside, it is the brain that
tracks others nodes in the cloud, applications installed and their
status. 

# Screencast

Through research I want to learn about its process, internal
mechanism, how this command triggers off other juju components, what
is the minimum take to simulate a successful bootstrap, and if things
go south, what is the minimum to simulate a clean state so we can run
`juju bootstrap` again as if from scratch. This last point is
particuarly useful for development and troubleshooting.

<figure class="row">
    <img class="img-responsive center-block"
         src="/images/juju%20bootstrap.gif" />
    <figcaption>Screencast of juju bootstraping a cloud environment</figcaption>
</figure>


First thing first, if we have create a cloud or are using a stock
cloud type:

<pre class="brush:bash;">
$ juju bootstrap [cloudname] [machine-0 name]

for example:
$ juju bootstrap devx test-1
</pre>

This will create a state controller (machine-0) that will be the
management node within juju's cloud environment.

# Develop a new provider

Case in point is to develop a new provider. Juju's [document][2] is
helpful to guide development provides that one is familiar with code
base and the rest of the Juju environment. The article fill in gap
between a design document and code itself so not only one defines
these interfaces, methods and so on, but one understands when these
methods will be called, how they are called, and what they are to
achieve.

[2]: https://github.com/juju/juju/wiki/Implementing-environment-providers

# Juju cloud & provider

Canonical Juju is a powerful orchestration tool. Its power lies in
deploying some applications by sending a form of _request_ to
underline cloud and have the cloud figuring out what type of machine
should be provisioned, putting an OS on it, installing necessary tools
and application, and finally putting the desired applications on
top. It's magic.

Being able to handle multiple types of cloud, Juju abstracs a _cloud_
with _an envrionment_ (we will use "cloud" and "environment"
interchangeably in this article).  Within an environment, there is a
special machine, the `machine-0`, that functions as a management node
to all other machines.  In essence it is a state controller where
configurations of all slave nodes, status of deployed applications and
so on are kept.  The _cloud provider_ is the driver layer where Juju's
CLI speaks to a cloud. Each cloud has a different API. Juju provides a
common bootstrap framework to tie these providers into a common
process.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/juju%20cloud%20and%20provider.png" />
    <figcaption>Juju cloud abstraction</figcaption>
</figure>

# Bootstrap usage

Before Juju bootstraps an environment, it needs to know to have basic
knowledge of [clouds][1]. Off the shelf Juju supports the followings:

1. Azure
2. Cloudsigma
3. Amazon EC2
4. GCE
5. Joyent
6. Openstack
7. Rackspace
8. Vsphere
9. Canonical MAAS
10. LXD containers
11. Manual

[1]: https://jujucharms.com/docs/2.0/clouds

For the above, nearly everything is built-in(!) The bare minimum to
bootstrap a machine is user credential (and some cloud, eg. LXD,
doesn't use credentials). Juju handles everything else. Depending on
the selected cloud type, Juju commands also offer different
configurations that can be customized, for example, direct request to
a particular EC2 region.

LXD is a special type of cloud because it does not involve another
machine throughout &mdash; everything is taking place on the same
machine where CLI are being issued. For all others, it always involves
some kind of remote API interface for commanding purpose.

To list all supported cloud types:

<pre class="brush:bash;">
$ juju list-clouds

fengxia@ubuntu:~$ ./juju list-clouds
Cloud        Regions  Default        Type        Description
aws               12  us-east-1      ec2         Amazon Web Services
aws-china          1  cn-north-1     ec2         Amazon China
aws-gov            1  us-gov-west-1  ec2         Amazon (USA Government)
azure             18  centralus      azure       Microsoft Azure
azure-china        2  chinaeast      azure       Microsoft Azure China
cloudsigma         5  hnl            cloudsigma  CloudSigma Cloud
google             4  us-east1       gce         Google Cloud Platform
joyent             6  eu-ams-1       joyent      Joyent Cloud
rackspace          6  dfw            rackspace   Rackspace Cloud
localhost          1  localhost      lxd         LXD Container Hypervisor
devmaas            0                 maas        Metal As A Service
devx               0                 xclarity    Lenovo XClarity
</pre>

To bootstrap an environment is simple if everything has been setup
correctly. It is really up to the underline cloud to provide a
machine, and this is where we are going to analye in further details.

<pre class="brush:bash;">
$ juju bootstrap [cloud type][any name]
</pre>

# Bootstrap overview

Juju offers a generalized framework into which code that drives a
cloud type is tied. Being the first machine to create in a given
environment, machine-0 involves tremendous amount of machinary to go
live.  In a nutshell, all activities can be categorized into the
followings:

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/juju%20bootstrap%20overview.png" />
    <figcaption>Juju bootstrap framework</figcaption>
</figure>

* Setup constraints: An umbrella term containing anything from memory
  size to region to the version of OS itself.
* Pick OS image: For Ubuntu, it does mapping from a name, eg. Precise,
  to an actual OS version.
* Pick agent/tools: Juju requires to install an agent, _jujud_, on all
  slave nodes. Bootstrap will abort if no adequate agent can be located.
  
  > Chaning version number to a non-official one, eg. 2.0.1.99, will force Juju binary to use a local jujud (compiled).
  
* Provision OS: Machine is setup for SSH access via public-key
  (including root). A default user, _ubuntu_, is created on the
  machine.
* Set up instance configuration: An instance configuration controls
  all things beyond a bare OS, such as triggering an OS update & upgrade
  (eg. apt upgrade), ports Juju agent should listen to, networking
  configurations, etc..
* Configure node: From the main controller, Juju will SSH into the
  node, install Juju agent and tools, set up a mongoDB for data
  persistence and running other chores using cloud-init.

  > Default Juju agent path: /var/lib/juju

# Bootstrap framework 

With the overview in mind, let's take a look Juju's actual bootstrap
process located in `juju.juju.environs.Bootstrap` function.

* <font color="gray">Gray</font> boxes: depicts data inputs to each
  functional block, and details of data structures.
* <font color="green">Green</font> boxes: are integration points with
  different cloud providers &mdash; how to start an instance from
  scratch (provisioning), and how to configure an OS-ed machine. The
  latter can be argued cloud agnostic. However, it is heavily geared
  towards Ubuntu environment by default.
* <font color="blue">Blue</font>: are clearly Canonical dependent due
  to hard-coded values (eg. simplestream URL).

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/juju%20bootstrap%20process.png" />
    <figcaption>Juju bootstrap framework</figcaption>
</figure>

The purpose of this framework is to pre-evaluate constraints and
requested resources for provider's consumption. For example, it will
cponstruct a list of Juju agents and tools but delay its final picking
until providre's code is called. Same for OS images (imageMetadata).

The Juju tools & agent play such a key role in bootstraping that the
entire process will abort if no matching tool is located.  The
assumption is that privisioning OS is the job the cloud and Juju is
responsible for actions from OS onward. So if there is no tools to
take the machine to the next stage, why bother installing an OS?


Now let's drive into a provider's arena and take a look what a provider offers.

# Illustration of a "common" provider 

Juju's _common_ provider serves as an example for study. It can looked
as a _standard_ way to provision and configure a node. As a matter of
fact, some providers uses its `Bootstrap` function completly.

## "common" provisioning & cloud integration

If framework has done preliminary sanity checks and collected possible
resources, provider's task is to make a final pick.  Thing like
selecting the OS image and juju agent and tools are all taking place
here. Once ducks are in line, call a provider's `BootstrapInstance`
function &larr; and this is the point where underline cloud meets
Juju.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/juju%20common%20BootstrapInstance.png" />
    <figcaption>"common" provider's BootstrapInstance function</figcaption>
</figure>

What is expected from the cloud? Four things that are all hardware centric:

1. hardware characteristics: architecture, memory size, root disk size, CPU cores.
2. network information
3. storage volume
4. storage volume attachment

<pre class="brush:bash;">
// StartInstanceResult holds the result of an
// InstanceBroker.StartInstance method call.
type StartInstanceResult struct {
    // Instance is an interface representing a cloud instance.
    Instance instance.Instance

    // Config holds the environment config to be used for any further
    // operations, if the instance is for a controller.
    Config *config.Config

    // HardwareCharacteristics represents the hardware characteristics
    // of the newly created instance.
    Hardware *instance.HardwareCharacteristics

    // NetworkInfo contains information about how to configure network
    // interfaces on the instance. Depending on the provider, this
    // might be the same StartInstanceParams.NetworkInfo or may be
    // modified as needed.
    NetworkInfo []network.InterfaceInfo

    // Volumes contains a list of volumes created, each one having the
    // same Name as one of the VolumeParams in StartInstanceParams.Volumes.
    // VolumeAttachment information is reported separately.
    Volumes []storage.Volume

    // VolumeAttachments contains a attachment-specific information about
    // volumes that were attached to the started instance.
    VolumeAttachments []storage.VolumeAttachment
}
</pre>

### Hardware characteristics

<pre class="brush:bash;">
// HardwareCharacteristics represents the characteristics of the instance (if known).
// Attributes that are nil are unknown or not supported.
type HardwareCharacteristics struct {
    // Arch is the architecture of the processor.
    Arch *string `json:"arch,omitempty" yaml:"arch,omitempty"`

    // Mem is the size of RAM in megabytes.
    Mem *uint64 `json:"mem,omitempty" yaml:"mem,omitempty"`

    // RootDisk is the size of the disk in megabytes.
    RootDisk *uint64 `json:"root-disk,omitempty" yaml:"rootdisk,omitempty"`

    // CpuCores is the number of logical cores the processor has.
    CpuCores *uint64 `json:"cpu-cores,omitempty" yaml:"cpucores,omitempty"`

    // CpuPower is a relative representation of the speed of the processor.
    CpuPower *uint64 `json:"cpu-power,omitempty" yaml:"cpupower,omitempty"`

    // Tags is a list of strings that identify the machine.
    Tags *[]string `json:"tags,omitempty" yaml:"tags,omitempty"`

    // AvailabilityZone defines the zone in which the machine resides.
    AvailabilityZone *string `json:"availability-zone,omitempty" yaml:"availabilityzone,omitempty"`
}
</pre>

### Network info

<pre class="brush:bash;">
// InterfaceInfo describes a single network interface available on an
// instance. For providers that support networks, this will be
// available at StartInstance() time.
// TODO(mue): Rename to InterfaceConfig due to consistency later.
type InterfaceInfo struct {
    // DeviceIndex specifies the order in which the network interface
    // appears on the host. The primary interface has an index of 0.
    DeviceIndex int

    // MACAddress is the network interface's hardware MAC address
    // (e.g. "aa:bb:cc:dd:ee:ff").
    MACAddress string

    // CIDR of the network, in 123.45.67.89/24 format.
    CIDR string

    // ProviderId is a provider-specific NIC id.
    ProviderId Id

    // ProviderSubnetId is the provider-specific id for the associated
    // subnet.
    ProviderSubnetId Id

    // ProviderSpaceId is the provider-specific id for the associated space, if
    // known and supported.
    ProviderSpaceId Id

    // ProviderVLANId is the provider-specific id of the VLAN for this
    // interface.
    ProviderVLANId Id

    // ProviderAddressId is the provider-specific id of the assigned address.
    ProviderAddressId Id

    // AvailabilityZones describes the availability zones the associated
    // subnet is in.
    AvailabilityZones []string

    // VLANTag needs to be between 1 and 4094 for VLANs and 0 for
    // normal networks. It's defined by IEEE 802.1Q standard.
    VLANTag int

    // InterfaceName is the raw OS-specific network device name (e.g.
    // "eth1", even for a VLAN eth1.42 virtual interface).
    InterfaceName string

    // ParentInterfaceName is the name of the parent interface to use, if known.
    ParentInterfaceName string

    // InterfaceType is the type of the interface.
    InterfaceType InterfaceType

    // Disabled is true when the interface needs to be disabled on the
    // machine, e.g. not to configure it.
    Disabled bool

    // NoAutoStart is true when the interface should not be configured
    // to start automatically on boot. By default and for
    // backwards-compatibility, interfaces are configured to
    // auto-start.
    NoAutoStart bool

    // ConfigType determines whether the interface should be
    // configured via DHCP, statically, manually, etc. See
    // interfaces(5) for more information.
    ConfigType InterfaceConfigType

    // Address contains an optional static IP address to configure for
    // this network interface. The subnet mask to set will be inferred
    // from the CIDR value.
    Address Address

    // DNSServers contains an optional list of IP addresses and/or
    // hostnames to configure as DNS servers for this network
    // interface.
    DNSServers []Address

    // MTU is the Maximum Transmission Unit controlling the maximum size of the
    // protocol packats that the interface can pass through. It is only used
    // when > 0.
    MTU int

    // DNSSearchDomains contains the default DNS domain to use for non-FQDN
    // lookups.
    DNSSearchDomains []string

    // Gateway address, if set, defines the default gateway to
    // configure for this network interface. For containers this
    // usually is (one of) the host address(es).
    GatewayAddress Address
}
</pre>

### Storage volume

<pre class="brush:bash;">
// Volume identifies and describes a volume (disk, logical volume, etc.)
type Volume struct {
    // Name is a unique name assigned by Juju to the volume.
    Tag names.VolumeTag

    VolumeInfo
}

// VolumeInfo describes a volume (disk, logical volume etc.)
type VolumeInfo struct {
    // VolumeId is a unique provider-supplied ID for the volume.
    // VolumeId is required to be unique for the lifetime of the
    // volume, but may be reused.
    VolumeId string

    // HardwareId is the volume's hardware ID. Not all volumes have
    // a hardware ID, so this may be left blank.
    HardwareId string

    // Size is the size of the volume, in MiB.
    Size uint64

    // Persistent reflects whether the volume is destroyed with the
    // machine to which it is attached.
    Persistent bool
}
</pre>

### Storage volume attachment

<pre class="brush:bash;">
// VolumeAttachment identifies and describes machine-specific volume
// attachment information, including how the volume is exposed on the
// machine.
type VolumeAttachment struct {
    // Volume is the unique tag assigned by Juju for the volume
    // that this attachment corresponds to.
    Volume names.VolumeTag

    // Machine is the unique tag assigned by Juju for the machine that
    // this attachment corresponds to.
    Machine names.MachineTag

    VolumeAttachmentInfo
}

// VolumeAttachmentInfo describes machine-specific volume attachment
// information, including how the volume is exposed on the machine.
type VolumeAttachmentInfo struct {
    // DeviceName is the volume's OS-specific device name (e.g. "sdb").
    //
    // If the device name may change (e.g. on machine restart), then this
    // field must be left blank.
    DeviceName string

    // DeviceLink is an OS-specific device link that must exactly match
    // one of the block device's links when attached.
    //
    // If no device link is known, or it may change (e.g. on machine
    // restart), then this field must be left blank.
    DeviceLink string

    // BusAddress is the bus address, where the volume is attached to
    // the machine.
    //
    // The format of this field must match the field of the same name
    // in BlockDevice.
    BusAddress string

    // ReadOnly signifies whether the volume is read only or writable.
    ReadOnly bool
}
</pre>

## "common" node configuring

In code this step is presented as an "interface" function within the
`BootstrapInstance`. So it is really part of the provisioning calls.
However, we are separating it here for discussion purpose.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/juju%20common%20BootstrapInstance%20finalizer%20func.png" />
    <figcaption>"common" provider's BootstrapInstance finalizer function</figcaption>
</figure>

The most critical thing in this step is to install Juju agent. We will
write more about this agent in other articles. For bootstrap, the
followings are observed:

* default path: `/var/lib/juju`
* hardcoded log file name: `cloud-init-output.log`
* nonce content (see below)

### nonce

Juju identifies machine-0 by SSH-ing into the machine and matching
`/var/lib/juju/nonce.txt` content to a special string:
`user-admin:bootstrap`.

  > Machine-0 must have file (`/var/lib/juju/nonce.txt`) with content: <span class="myhighlight">user-admin:bootstrap</span>

# Wrapup

This concludes our humble attempt to decipher Juju's bootstrap
mechanisms. We have covered quite some grounds. The key take away is
to understand where provider is expected. However, this is an over
simplified view because it also depends on how much involvement a
cloud want to have in this process. Argubly one can say that cloud
provider is really called for in each of the six steps in this process
&mdash; it needs to validate constraints, it should pick the OS image,
it certainly should control the tool and cloud-init process, and
certainly it is doing the provisioning.

I think this argument is nearly true if one looks into stock providers
and pull all their implementation together. For writing a new
provider, XClarity, it comes down to a design decision then how much
the underline cloud wants control. The bare minimum (as we have done
in the simulation, see below) is to rely on default values, `common`
provider's `Bootstrap` functions, and return a `StartInstanceResult`.

<pre class="brush:bash;">
// For now, we are imitating a successful instance by directly returning a result struct
var tmpArch string = arch.AMD64
var tmpMem uint64 = 2000000
var tmpCpuCore uint64 = 1
var tmpCpuPower uint64 = 100
hardware := instance.HardwareCharacteristics{
        Arch: &tmpArch,
        Mem: &tmpMem,
        CpuCores: &tmpCpuCore,
        CpuPower: &tmpCpuPower,
}
volumes := make([]storage.Volume, 0)
networkInfo := make([]network.InterfaceInfo, 0)
volumeAttachments := make([]storage.VolumeAttachment, 0)

return &environs.StartInstanceResult{
        Instance:          xclarityBootstrapInstance{},
        Config:			   env.ecfg.Config,
        Hardware:          &hardware, // type instance.HardwareCharacteristics struct
        NetworkInfo:       networkInfo, // type network.InterfaceInfo struct
        Volumes:           volumes, // type storage.Volume struct
        VolumeAttachments: volumeAttachments, // type storageVolumeAttachment struct
}, nil
</pre>

There are a few topics that are not covered in this article, but need
to be studied further:

1. Juju agent & tools: What does an agent do? What is the DB look
like? How is information registered with jujud (aka. agent)? How does
agent communicates with CLI controller? Why is it an issue to match
agent with juju binary? How to build a custom agent?
2. cloud-init: My understanding at the moment is that the entire node
configuration is done via [cloud-init][3]. Itself is not
interesting. But what Juju does to make cloud-init carry out its task
is interesting. I think there are scripts involved. So who is
generating these scripts? what type of scripts? Can they be
customized? This helps us to know how much we can control the final
state of an instance.
3. SimpleStream: I think it is a form of communication protocol. It is
how one communicates with jujud. What capability does it have? Who is
providing that in Juju's environment? How it may be affected by other
network design/configuration?

[3]: https://launchpad.net/cloud-init

Well, stay tuned.

