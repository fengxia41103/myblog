Title: HW workload charms
Date: 2017-04-25 8:00
Tags: lenovo
Slug: juju charm hw workload
Author: Feng Xia
Status: Draft

In this article we will introduce the HW workload charms and how to
build them. **What is a HW workload?** In orchestration space we can
divide technologies into two categories: description language and
orchestration runtime. Description language defines a particular set
of syntax, keywords and format that one uses to **describe** a
workload, and runtime is the binaries that consumes the template (or
blueprints) and execute instructions. With this context, we can view
charms as the workload template in which one uses _states_ that a
workload should observe, and Juju binaries, including its CLI and juju
agent, provide the runtime environment to monitor and act upon those
states.

So far charms have been used to describe software workload both in the
level of software application (eg. MySql) and the level of platform
(eg. Openstack). The underline assumption is that a supporting layer
pre-exist, such as an operating system or a platform (thinking of
Openstack or hypervisors). Extending on this concept, we ask ourselves
whether we can utilize the same Juju & Charm framework to support
deployment of infrastructures? If assuming the infrastructure can be
**software-defined**, once the wires are all done and
hardwares are installed, what's left to do is really falling into the
same pattern as deploying a software application -- installing OS,
installing application, tweak configurations and so on.

Along this thought, using ThinkAgile as an example we set off to model
a **Hardware workload** in charms.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/hw%20workload%20stack%20diff.png" />
  <figcaption>New system stack with HW workload capability</figcaption>
</figure>


# Vision

> Utilizing charm technology and its toolsets to model a hardware
> **solution** and components and to a achieve a seamless deployment
> from design board and a configured system with full automation. 

As an example, we are to design a solution that consists of the
following hardwares. Using the charm tools we will be not only model
the solution, but to make the deployment based on this configuration
so to acquire a complete software-defined system.

<figure class="row">
  <img class="col s7"
       src="/images/hw%20workload%20deploy%20example.png" />
  <img class="col s5"
       src="/images/hw%20workload%20deploy%20example%20components.png" />
  <figcaption class="col s12">HW workloads</figcaption>
</figure>

# Model

In an over simplified form, we view a system such as ThinkAgile in a tree
model, where the top level is a **solution**, say ThinkAgile, which
then contains one-to-many racks. Rack can then include servers, and
servers are consisted of components such as RAID adapters and
storages.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/hw%20solution%20tree.png" />
  <figcaption>HW solution hierarchy</figcaption>
</figure>

Each of these entities (rack, server, and so on) can have
configuration options (attributes), and to execute these
configurations there will be actions. So if we arrive to the point
that we define a switch with its attributes and a set of actions so
that it can be configured based on a pre-defined blueprint, we shall
be able to wire these entities together to achieve higher complexity
&mdash; like building legos!

# Charm dev

In this section we'll go over the code layout that implement this
model in charm terms. 

## Code layout

The code can really live in any folder (we can wire them using
environment variables, see below). But here we suggest to put all of
them into one directory.

1. <span class="myhighlight">interfaces</span>: relation interface
   code. This is the mechanism to signal between charms and between
   charm units since `state` do not go across unit boundary.
2. <span class="myhighlight">charms</span>: charm code. Each subfolder can
   be compiled into a charm (see "Compiling charms" section for
   details).
3. <span class="dist">dist</span>: built charms live here. Subfolder
   `trusty` is defined in charm build `--series`. This is significant
   in software application where one determines the OS compatibility
   with the deployment, but has no meaning in HW workload currently. 


<pre class="brush:plain;">
.
├── deps
│   ├── interface
│   └── layer
├── dist
│   ├── deps
│   └── trusty
├── interfaces
│   ├── rack-pdu
│   ├── rack-switch
│   ├── raid-server
│   ├── server-rack
│   ├── storage-server
│   └── switch-server
├── charms
│   ├── charm-chain-state
│   ├── charm-pdu
│   ├── charm-rack
│   ├── charm-raid
│   ├── charm-raid-cisco-p345
│   ├── charm-raid-dell-h330
│   ├── charm-server
│   ├── charm-server-3550
│   ├── charm-server-3650
│   ├── charm-storage
│   ├── charm-switch
│   ├── charm-switch-dell-n2048p
│   └── charm-switch-meraki-ms425
├── README.md
└── thinkagile.yaml
</pre>

## Environment variables

Correspondingly, we define three environment variables, each points to
a folder above:

1. `LAYER_PATH` &rarr; `./charms`, where charm/layer code resides.
2. `INTERFACE_PATH` &rarr; `./interfaces`, where interface code
   resides.
3. `JUJU_REPOSITORY` &rarr; `./dist`, where ready-to-deploy charms reside.

## Compiling charms

Compiling a charm refers to using a Canonical developed Python tool,
`charm-tools`([source][1]), to assemble charm and its dependent libs
and so on into a single _charm_ so that juju can then be used to
deploy it to a target machine.

Two ways to install `charm-tools`:
1. `apt get charm-tools` (if on Ubuntu), or
2. `pip install charm-tools`, preferred since then you can use Python
   virtualenv.

Be warned that the installed `charm` has a poor CLI interface &mdash;
it doesn't have `--help` nor error message if the parameters are not
adequate. So typing `$ charm` will hang without giving you a clue of
what is going wrong.

To compile a charm, for exampe `charm-switch`:
<pre class="brush:bash;">
$ cd $LAYER_PATH/charm-server
$ charm build
....
build: Composing into /home/fengxia/workspace/hwcharm/dist
build: Destination charm directory: /home/fengxia/workspace/hwcharm/dist/trusty/switch
build: Processing layer: layer:basic
build: Processing layer: switch
</pre>

The `Destination charm directory` is the directory defined by
environment variable `JUJU_REPOSITORY`.

# A HW charm

Defining a HW charm is like defining any other charms. The basic code
structure is shown below (using `charm-switch` as an example):

<pre class="brush:plain;">
.
├── config.yaml        <-- configuration options
├── icon.svg           <-- application icon
├── layer.yaml         <-- charm inheritance
├── metadata.yaml      <-- charm name, relations
├── reactive          
│   └── switch.py      <-- application logics
└── templates
    └── switch_config  <-- jinja2 template for configs
</pre>

## config.yaml

The file holds configuration variables that can then be set using juju
command and through Juju GUI. For example, here we define a few switch
attributes: `size`, `speed`, `os`, `cooling-orientation`... Charm
supports four `type`: boolean, string, int and float.

<pre class="brush:yaml">
options:
  size:
    type: string
    default: "1U"
    descriptioin: "1U/2U"
  speed:
    type: string
    default: "1G"
    description: "1G/10G"
  cooling-orientation:
    type: string
    default: "Horizontal"
    description: "Horizontal/Vertical"
  os:
    type: string
    default: "ENOS"
    description: "ENOS/CNOS"
  port-config-json:
    type: string
    default: ""
    description: "Por config JSON"
  configuration-url:
    type: string
    default: "http://10.0.240.43/server/configuration/"
    description: "Server configuration file URL"
</pre>

## metadata.yaml - relation hierarchy

This file defines the charm name, and more importantly, its `relation`
with other charms as in the `provides` and `requires` section.

<pre class="brush:yaml;">
name: switch
summary: This is a switch charm.
maintainer: Feng Xia <fxia1@lenovo.com>
description: |
  A generic switch charm.
tags:
  - switch
provides:
  rack:
    interface: rack-switch
  server:
    interface: switch-server
</pre>

1. <span class="myhighlight">name</span>: `charm build` will create a
   folder named `switch` in `JUJU_REPOSITORY/trusty` directory. Can
   use `$ juju deploy $JUJU_REPOSITORY/trusty/switch` to deploy.
2. <span class="myhighlight">tags</span>: arbitrary. Canonical charm
   store has a [list][1] but if we are using these charm local, they become
   irrelevant.
3. <span class="myhighlight">provides/requires</span>: `interface:`
   must be a valid interface defined in `$INTERFACE_PATH`. The name
   `rack` and `server` can be anything. They will be later be used in
   bundle file (see "Bundle" section).

[1]: https://jujucharms.com/docs/1.24/authors-charm-metadata

## layer.yaml - charm inheritance

Each charm is defined as a `layer` in charm's term. So here one can
**inherit** other charms using `includes` syntax. 

1. `layer:basic` **must** be included! It defines some basic package
   installation, eg. Python binaries and its virtualenv. 
2. Configs from _included_ charms will be pulled into the new charm so
  on Juju GUI all configs defined in both the parent and the children
  are visible.

<pre class="brush:yaml;">
repo: git@github.com:xyz/xyz.git
includes:
  - 'layer:basic'
  - 'layer:other-charm
</pre>

## Interface - charm relations

Charm interface is used in our modeling to define entity-to-entity
relation, such as linking rack to PDU. We have seen how to use these
interfaces in `metadata.yaml` earlier using `requires/provides`. In
this section we will see how to define an interface. Using interface
`rack-pdu` for example:

<pre class="brush:plain;">
rack-pdu
├── interface.yaml
├── provides.py    <-- code for interface provider
└── requires.py    <-- code for interface consumer
</pre>

## interface.yaml

1. <span class="myhighlight">name</span>: is the actual interface name
   used in `metadata.yaml`, not the folder name.
2. repo: will generate a warning, but no harm.

<pre class="brush:yaml;">
name: rack-pdu
summary: Rack to PDU interface
version: 1
repo: https://git.launchpad.net/whatever/
</pre>

# Deploy charm

We will cover two ways to deploy charms &mdash; deploy a single charm,
or using a bundle (batch mode). 

Setup a sandbox

1. Get a Ubuntu 16.04 VM, install Juju per this [instruction][2].
2. `$ juju bootstrap lxd lxd-test` to bootstrap a LXD based juju
   environment.
3. To run a juju gui, `$ juju gui`. This should bring up a brower with
   the GUI.
    1. To login, you need to change the admin password: $ juju
       change-user-password`.
    2. In GUI, username: `Admin`, password: see previous step.

[2]: https://jujucharms.com/docs/stable/getting-started

Deploy a single charm. Charm name is the folder name in
`$JUJU_REPOSITORY/trusty`.

<pre class="brush:plain;">
$ juju deploy $JUJU_REPOSITORY/trusty/[charm name]

fengxia@local-charmdev:~/juju deploy $JUJU_REPOSITORY/trusty/pdu --series trusty --debug
11:13:59 INFO  juju.cmd supercommand.go:63 running juju [2.0.1.97 gc go1.6]
11:13:59 DEBUG juju.cmd supercommand.go:64   args: []string{"/home/fengxia/juju", "deploy", "/home/fengxia/workspace/hwcharm/dist/trusty/pdu", "--series", "trusty", "--debug"}
11:13:59 INFO  juju.juju api.go:72 connecting to API addresses: [10.129.186.203:17070]
11:13:59 INFO  juju.api apiclient.go:530 dialing "wss://10.129.186.203:17070/model/3b248754-ad0b-40e6-84ca-2b5dedeb98c9/api"
11:13:59 INFO  juju.api apiclient.go:466 connection established to "wss://10.129.186.203:17070/model/3b248754-ad0b-40e6-84ca-2b5dedeb98c9/api"
11:13:59 DEBUG juju.juju api.go:263 API hostnames unchanged - not resolving
11:13:59 DEBUG juju.cmd.juju.application deploy.go:768 cannot interpret as local bundle: read /home/fengxia/workspace/hwcharm/dist/trusty/pdu: is a directory
11:13:59 DEBUG httpbakery client.go:244 client do POST https://10.129.186.203:17070/model/3b248754-ad0b-40e6-84ca-2b5dedeb98c9/charms?revision=0&schema=local&series=trusty {
11:14:00 DEBUG httpbakery client.go:246 } -> error <nil>
11:14:00 INFO  cmd cmd.go:129 Deploying charm "local:trusty/pdu-0".
11:14:00 INFO  cmd supercommand.go:467 command finished
</pre>

## bundle

Charm bundle is a template to batch deploying of multiple charms and
their relations. 

1. <span class="myhighlight">machines</span>: section to define
  machines that are being requested to run the workload.
2. <span class="myhighlight">services</span>: list of charms to
   deploy.
3. <span class="myhighlight">series</span>: default OS series for a
   new machine.
    1. `charm`: relative path to charm artifacts
    2. `num_units`: how many charm instances to deploy
    3. `to`: can designate a machine ID for this charm
    4. `annotations`: coordinates for Juju GUI
4. <span class="myhighlight">relations</span>: list of relations to
   connect charms.

<pre class="brush:yaml;">
machines:
  "1":
    constraints: "mem=2G"
    series: "xenial"

services:
  # 42U default rack
  rack:
    charm: ./dist/trusty/rack
    num_units: 1
    annotations:
      gui-x: "300"
      gui-y: "300"
    to:
      - "1"

# default series, n/a in modeling
series: xenial

# relations
relations:
  # rack to PDU relation
  - - "rack:pdu" # require first, app name:required interface name
    - "pdu:rack" # provide 2nd, app name:provides interface name
</pre>

### relations

Definition of _relations_ is confusing at beginning. For software
applications it is less so because `provides` will offer a service,
eg. http and DB, and `requires` will consume it.

In HW workload we are borrowing this term to illustrate a rather
general connection between two entities. In the bundle example above,
we first define an interface in `$INTERFACE_PATH` called
`rack-pdu`. Then in rack's `metadata.yaml` we define:

<pre class="brush:yaml;">
requires:
  pdu:                   <-- can be any name
    interface: rack-pdu  <-- must be a valid interface!
</pre>

and correspondingly in pdu's `metadata.yaml` we define:

<pre class="brush:yaml;">
provides:
  rack:                  <-- can be any name
    interface: rack-pdu
</pre>

Then in bundle, we define the followings:

<pre class="brush:yaml;">
relations:
  # rack to PDU relation
  - - "rack:pdu" # require first, charm name:required interface name
    - "pdu:rack" # provide 2nd, charm name:provides interface name
</pre>

where:
1. first one must be a `require` relation. Format `charm name:interface
   name`. Since rack is _requiring_ in this case, the charm name is
   `rack` (as seen in the `Services` section), and relation name is
   what's defined in rack's `metadata.yaml`.
2. Similarly, the second one is the `provide` relation. Same format
   and naming.
   
With these set, one can deploy a bundle using `$ juju deploy
bundle.yaml` and watch the charms get deployed.

