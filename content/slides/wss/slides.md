<section class="row">
  <h1>
    Workload Solution
    <i class="fa fa-shopping-basket">Store</i>
  </h1>
  <br>
  <small align="left"
      class="myhighlight">
    by [mhalas@lenovo.com](mailto:mhalas@lenovo.com),
    [fxia1@lenovo.com](mailto:fxia1@lenovo.com)
  </small>
</section>
---
<h6>Agenda</h6>

1. Today's challenges
2. Introduction of Juju & charms
3. Transform reference architecture
4. Discussion

---
<section data-background="https://drscdn.500px.org/photo/155532687/q%3D80_m%3D2000/v2?webp=true&sig=4122d59c34dde5e01b0a8fd3b10e0330c3b053c27918e55a68464a1937237a34" class="row">
  
  <div align="left"
       class="col s6">
    Today's Vendor & Customer
    <h2>
      Challenges to Tackle
    </h2>
  </div>
</section>
---
This is how it is being done today...
---
<h6>Client starts with</h6>

<figure class="center-align">
  <img data-src="images/lenovo%20catalog.png"
       class="responsive-img">
</figure>
---
<h6>then, add configurations</h6>

<figure class="center-align">
  <img data-src="images/lenovo%20configurator.png">
</figure>
---
<h6>then, Lenovo MFG</h6>

<figure class="row">
  <img data-src="https://drscdn.500px.org/photo/135937995/q%3D80_m%3D1000_k%3D1/v2?webp=true&sig=a9bfbffe2a1d74bbbfdbaea7b4263b55c50123204741011f4421bd9a2b8e7745"
       height="300px"
       width="30%"/>
  <img data-src="https://drscdn.500px.org/photo/199833393/q%3D80_m%3D2000_k%3D1/v2?webp=true&sig=6a47d3ec149bbb62274e389f241e9be47c9cd1fd251a27cb7a59642af2215f1d"
       height="300px"
       width="30%"/>
  <img data-src="images/hw_manifest.png"
       height="300px"
       width="30%"/>
</figure>

---
<h6>But</h6>

<div class="row">
  <img data-src="http://i.imgur.com/KzCHMAx.gif"
       class="responsive-img col s6">
  <div class="col s5 right"
       align="left">
    <p>
      Like a modern software development,
      lacking clearly defined interface to carry
      information from one domain to the next
      so everyone can build a common knowledge and
      lingual makes inputs inevitably skewed, mis-interpreted,
      and mis-used. Making things match
      then become a **creative** task.
    </p>
  </div>
</div>
In our review of the current Lenovo processes,
we have identified **five** challenges
that WSS aims to bring user an improved
experience.

Note:

1. https://developers.google.com/youtube/player_parameters
---
<h6>Five challanges</h6>


<div align="left"
     style="color:#cecece;">
  <div class="fragment highlight-blue">
    1. Lack of visible _model_ to keep **consistency** from client's
    design board to delivered solution rack.

    Difficult to **validate** configuration vs. expectation.
  </div>
  <div class="fragment highlight-blue">
    2. **Mixed** tools, scripts and manifests hidden in internal processes.

    Domain knowledge is maintained in mixed forms and is **implicit**,
    putting the business at risk.
  </div>
  <div class="fragment highlight-blue">
    3. Cycle of solution deployment is executed in _weeks_. HW
    misconfiguration is not discovered until late in the game, making the
    process **inefficient** and **unreliable**.
  </div>
  <div class="fragment highlight-blue">
    4. No orchestration capability from _HW to SW_ covering "full" stack.

    **End-to-end** is a not only a differentiator, but an **enabler** in
    product designs that Lenovo can leverage its strength in HW to
    support wide range of SW with confidence.
  </div>
  <div class="fragment highlight-blue">
    5. Customers desire solutions across multiple **open** and **proprietary**
    platforms on premise or across clouds.
  </div>
</div>
---
<section data-background="https://drscdn.500px.org/photo/138747795/q%3D80_m%3D1500_k%3D1/v2?webp=true&sig=20cc685f194e95851ba5ceb3181ca0395d511c07948dd15d884235eb477dcbc6" class="mywhite">
  <div align="left" class="col s6">
    Vision of the
    <h2 class="mywhite">
      Workload Solution Store
    </h2>
  </div>
</section>
---
<h6>Objective</h6>

1. Unified Hardware Modeling (**UHM** project)
2. HW and SW deployment using the same technology stack
3. Multi-platforms
4. Public and private clouds
5. Simple to execute
---
<h6>WSS Stack</h6>

<div class="row">
  <div class="col s7">
    <img data-src="images/wss%20simplified%20function%20stack.png"
         class="responsive-img materialboxed"
         style="box-shadow:none;">
  </div>
  <div class="col s5">
    <dl>
      <dt>Component modeling</dt>
      <dd>
        Each hardware component will be modeled to include both i ts
        configuration attributes and its how-to methods &rarr;
        **self-contained** and **self-sufficient**.
      </dd>
      <dt>System design</dt>
      <dd>
        System is decomposed into **modular** elements allowing design of flexible
        hierarchy and inheritance.
      </dd>
      <dt>Adaptive deployment</dt>
      <dd>
        Translate design **blueprint to deployment** executions
        permitting re-configure a software-defined solution.
      </dd>
    </dl>
  </div>
</div>

---
<h6>WSS vision</h6>


* **Battery included <i class="fa fa-battery"></i>**
* Reduce _lost in translation_
* Open source &rarr; technology transparency
* Build a vendor/user community
* Efficient deployment

  <img data-src="images/wss%20vision.png"
       class="responsive-img materialboxed"
       style="box-shadow:none;">
---
<h6>WSS Framework</h6>

<img data-src="images/uhm%20five%20phase.png">

<div align="left">
  <i class="fa fa-flag"></i>
  **Four** phases covering our **six** core processes:<br>
  HW catalog &rarr; solution architect &rarr; ordering &rarr; configuring &rarr; deployment &rarr; monitoring and validation
</div>

Note:

* Manifest is a presentation of configurations defined in our data models.
* Configuration instantiates a model &larr; model is really a template/class.
* Instantiated model will be applied in orchestration to bring expectation
into reality.
---
<h6>**Services** to support the **six cores**</h6>

  <img data-src="images/wss%20simplified%20phase.png"
       style="box-shadow:none;">

Note:

1. Lenovo, client, 3rd party can create their own models
2. Configurations service to drive **software-defined** objective
---

<h6>**Service flow** to support the six cores (**1**/3)</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/wss%20architecture%20components%201.png"
         style="box-shadow:none;">
  </div>
  <div align="left"
       class="col s3">
    <ol>
      <li>Existing catalog such as the **digital rack** can be used
        to build HW inventory, grouping, hierarchy.</li>
    
      <li>Architect can design and determine constraints of a solution model
        including both HW and SW components.</li>
    
      <li>Published models will be available in **solution store**
        that can be purchased *and configured** by customer.</li>
    </ol>
  </div>
</div>
---
<h6>**Service flow** to support the six cores (**2**/3)</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/wss%20architecture%20components%202.png"
         style="box-shadow:none;">
  </div>
  <div class="col s3">
    <ol>
      <li>**Order manifest** is the BOM.</li>
      <li>User accessible configuration is controlled.</li>
      <li>MFG does picking, assembling and packaging.</li>
      <li>MFG logs BOM fullfillment details into **HW manifest**, eg. serial #.</li>
      <li>**UHM Configurator** generates orchestrator instructions (manifest/bundle) and
        validation checklist (compliance).
    </ol>
  </div>
</div>
---
<h6>**Service flow** to support the six cores (**3**/3)</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/wss%20architecture%20components%203.png"
       style="box-shadow:none;">
  </div>
  <div class="col s3">
    <ol>
      <li>**Orchestration service** coordinates multi-layer deployment.</li>
      <li>Each layer includes three elements:
        <ol>
          <li>orchestor</li>
          <li>monitor</li>
          <li>validator</li>
        </ol>
      </li>
      <li>Technology for each layer can be different.</li>
    </ol>
  </div>
</div>
---
<section data-background="images/wss%20architecture%20components.png">
  <div align="left"
       style="margin-bottom:50%;">
    <h4 class="myhighlight">
      <i class="fa fa-key"></i>
      Unified architecture
    </h4>
  </div>
</section>
---
<section data-background="https://drscdn.500px.org/photo/167616481/q%3D80_m%3D2000/v2?webp=true&sig=138122848b49e23f21df0191e4ed3ae335fa47d262006cfa77c022b4771f6de9">
  <div align="left" class="col s6">
    Key Technology:
    <h2>
      Juju & charms
    </h2>
  </div>
</section>
---
<h6>Juju</h6>

<p align="left" >
 **Juju's mission** is to provide a
 modeling language for users that abstracts the specifics of operating
 complex big software topologies.
</p>

<div class="row">
  <div class="col s4">
    <img data-src="https://i.ytimg.com/vi/tsou9S6NoDg/maxresdefault.jpg">
  </div>
  <div class="col s8">
    <ol>
      <li>is an orchestrator</li>
      <li>is [Open source](https://github.com/juju/juju)
      </li><li>
        GNU Affero General Public License v3.0, permitting:
        <ol>
          <li>Commercial use</li>
          <li>Modification</li>
          <li>Distribution</li>
          <li>Patent use</li>
          <li>Private use</li>
        </ol>
      </li><li>
        Deploy charms
      </li><li>
        **Our customer has a strong interest in it**
      </li>
    </ol>
  </div>
</div>

Note:

1. recommended charms: 343, community: 1819

---
<h6>Juju orchestration model</h6>

<div class="row">
  <div class="col s9">
    <img data-src="images/juju%20model.png">
  </div>
  <div class="col s3">
    <p>
      **Clouds** out of the box:
    </p>
    <ol>
      <li>Azure</li>
      <li>Cloudsigma</li>
      <li>Amazon EC2</li>
      <li>GCE</li>
      <li>Joyent</li>
      <li>Openstack</li>
      <li>Rackspace</li>
      <li>Vsphere</li>
      <li>Canonical MAAS</li>
      <li>LXD containers</li>
      <li>Manual</li>
    </ol>
  </div>
</div>
---
<h6>Juju deployment model: **LXD model**</h6>

<div class="row">
  <div class="col s9">
    <img data-sr="images/juju%20lxd%20deployment%20setup.png">
  </div>
  <div class="col s3">
    <ol>
      <li>Resource is created **on demand**.</li>
      <li>All run within a single VM.</li>
      <li>LXD network is tricky.</li>
    </ol>
  </div>
</div>

Note:

is an ideal that resource can be created on the fly, which is observed in juju creating LXD container when deploying workload, eg. openstack base. In the end, we want the entire system appear to operator to have this capability by hiding complexity within the system. 

---
<h6>Juju deployment model: **MaaS** model</h6>

<div class="row">
  <div class="col s9">
    <img data-sr="images/juju%20lxd%20deployment%20setup.png">
  </div>
  <div class="col s3">
  </div>
</div>
---
<h6>Charms</h6>

<p align="left" >
  The central mechanism behind Juju is called Charms.
  Charms can be written in any programming language that can be executed from the command line.
</p>
<p align="left">
  **Example**:<br>
  
databases (19), app-servers (19), file-servers (16), monitoring (14), ops (9), openstack (51), applications (75), misc (63), network (11), analytics (7), apache (38), security (4), storage (17) &mdash; **343** recommended ones, **1819** community contributed ones
</p>


---
<h6>Charm orchestration model</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/juju%20control%20modeling.png"
    style="box-shadow:none;">
  </div>
  <div class="col s3">
    <ol>
      <li>Base unit is a **service**.</li>
      <li>Service can have more than 1 unit to achieve HA.</li>
      <li>Deployment can be on **BM, VM, and LXD** container.</li>
      <li>Relation parity</li>
    </ol>
  </div>
</div>
---
<h6>Charm key concepts</h6>

| Concepts  | used for                    |
|-----------|-----------------------------|
| hooks     | a hardcoded set of handlers |
| states    | user defined flags          |
| relations | data communication          |
| layer     | model inheritance           |
| bundle    | deployment batch mode       |

---
<h6>Charm **layers**</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/juju%20charm%20layers.png"
    style="box-shadow:none;">
  </div>
  <div class="col s3">
    <dl>
      <dt>Base layer</dt>
      <dd>
        Provides foundation service that can be reused.
      </dd>

      <dt>Interface layer</dt>
      <dd>
        Defines service that can be connected to, eg. DB. Parameters
        are managed by charm; **connection method is determined by the
        application**.
      </dd>

      <dt>Application layer</dt>
      <dd>
        Defines states, hooks and application logics.
      </dd>
    </dl>
  </div>
</div>

---

<h6>Charm code **components**</h6>

<figure>
  <img data-src="images/charm%20components.png"
       style="box-shadow:none;">
</figure>

<dl class="my-multicol-2">
  <dt>YAML data files</dt>
  <dd>
    <ol>
      <li>`config.yaml`: configuration key-value pairs, supporting 4 data types: int, float, string, boolean.</li>
      <li>`metadata.yaml`: name, description, tag, and **relations**</li>
      <li>`layer.yaml`: includes other layers and relation interfaces.</li> 
    </ol>
  </dd>

  <dt>States</dt>
  <dd>
    User defined **flags** that will be evaluated every 5 minutes. A TRUE
    condition will be executed multiple times.
  </dd>

  <dt>Hooks</dt>
  <dd>
    Hardcoded execution points and invoking sequence.
  </dd>

  <dt>Relation</dt>
  <dd>
    Can one charm exechange data with another? 
  </dd>
  
  <dt>Ansible (actions)</dt>
  <dd>
    Can also be other config mgt recipes.
    These are independently developed and are usable without charms. 
  </dd>

  <dt>Layesr</dt>
  <dd>
    Re-use other existing charm code, eg. utility function.
  </dd>

  <dt>Dependency packages</dt>
  <dd>
    In Python, these will be wheelhouse packages required by
    the charm scripts.
  </dd>
</dl>
---
<h6>**Example**: config.yaml</h6>

<div class="row">
  <div class="col s8">
<pre class="brush:yaml">
options:
  mount-size:
    type: string
    default: "1U"
    description: "Rack mount size, 1U/2U"
  operating-system:
    type: string
    default: ""
    description: "OS to deploy"
  firmware-update-id:
    type: string
    default: ""
    description: "Firmware update fix ID"
  configuration-pattern-id:
    type: string
    default: ""
    description: ""
</pre>
  </div>
  <div class="col s4">
    <ol>
      <li>Config key-value pairs that charm can use
        to drive its logic.</li>
      <li>Support **four data types**:
        <ol>
          <li>int</li>
          <li>float</li>
          <li>boolean</li>
          <li>string: what about a YAML?</li>
        </ol>
      </li>
    </ol>
  </div>
</div>

---
<h6>**Example**: metadata.yaml</h6>

<div class="row">
  <div class="col s8">
<pre class="brush:yaml">
name: server
summary: This is a server charm
maintainer: Feng Xia
description: |
  This is a generic server charm.
tags:
  - server
requires:
  rack:
    interface: rack-server
  switch:
    interface: switch-server
</pre>
  </div>
  <div align="left" class="col s4">
    Define relation: **require**  and **provide**.
  </div>
</div>

<h6>**Example**: layer.yaml</h6>

<div class="row">
  <div class="col s8">
<pre class="brush:yaml">
includes: ['layer:endpoint', 'interface:rack-server', 'interface:switch-server']
repo: hpcgitlab.labs.lenovo.com/WSS/wss.git
</pre>
  </div>
  <div align="left" class="col s4">
    Include **layer:** and **interface:**.
  </div>
</div>

---
<h6>**Example**: charm state script</h6>

<div class="row">
  <div class="col s9">
<pre class="brush:python">
@when_not('solution.ready', 'solution.error')
@when('solution.config.invalid')
def store_manifests():
    """Store manifests.
    """
    run_uhm(playbook='store_manifest',
            tags='manifest',
            current_state='solution.config.invalid',
            next_state='solution.manifest.stored',
            error_state='solution.error',
            user_vars={
                'sol_id': 'solution',
                'manifest_path': '/tmp/test.manifest'
            })
</pre>
  </div>
  <div class="col s3">
    Using flags 
  </div>
</div>
---
<h6>**Example**: charm relation script</h6>

<pre class="brush:python">
class RackProvides(RelationBase):
    # Every unit connecting will get the same information
    scope = scopes.UNIT
    auto_accessors = ['rack_id',
                      'server_id']

    # Use some template magic to declare our relation(s)
    @hook('{provides:rack-server}-relation-joined')
    def joined(self):
        config = hookenv.config()
        conv = self.conversation()
        conv.set_remote(data={
            'rack_id': config['uuid']
        })
        self.set_state('{relation_name}.joined')

    @hook('{provides:rack-server}-relation-{changed}')
    def changed(self):
        conv = self.conversation()
        if self.servers():
            conv.set_state('server.counted')
    ....
</pre>

---
<h6>**Example**: distribution file structure</h6>

<pre class="brush:plain;">
|-- ansible.cfg
|-- bin/
|-- config.yaml         <-- attributes/config options
|-- hooks/              <-- hook handlers
|-- icon.svg
|-- layer.yaml          <-- charm inheritance
|-- lib/                <-- utility `.py`
|-- metadata.yaml       <-- charm relations/interfaces
|-- playbooks/
|-- reactive/           <-- user defined flags  
|-- README.md
`-- wheelhouse/         <-- Python dependency libs
</pre>
---
<h6>**Example**: charm deployment bundle</h6>

<pre class="brush:yaml;">
series: trusty
services:
  wordpress:
    charm: "cs:trusty/wordpress-2"
    num_units: 1
    to:
      - "0"
  mysql:
    charm: "cs:trusty/mysql-26"
    num_units: 1
    to:
      - "1"
relations:
  - - "wordpress:db"
    - "mysql:db"
machines:
  "0":
    series: trusty
    constraints: "arch=amd64 cpu-cores=1 cpu-power=100 mem=1740 root-disk=8192"
  "1":
    series: trusty
    constraints: "arch=amd64 cpu-cores=1 cpu-power=100 mem=1740 root-disk=8192"
</pre>
---
<h6>Charms **store**</h6>

<iframe data-src="https://jujucharms.com/store"
        height="550px" width="100%"></iframe>
---
<h6>**Juju GUI**/Canvas/Management console</h6>
<iframe data-src="https://jujucharms.com/new/"></iframe>
---
<h6>**Example**: a deployed Canonical Openstack</h6>

<img data-src="https://insights.ubuntu.com/wp-content/uploads/7790/jjuju.png">

* **4** machines (VM & containers)
* **16** services
* **1** click

---
<h6>WSS strategy of using Juju & charms</h6>
<div class="row">
  <figure class="col s9">
    <img data-src="images/wss%20orchestration.png"
         style="box-shadow:none;">
  </figure>
  <div align="left"
       class="col s3">
    <ol>
      <li>
        Three primary types of charms:
        <ol>
          <li>HW (Lenovo innovation)</li>
          <li>software platform (existing)</li>
          <li>user application (existing)</li>
        </ol>
      </li><li>
        Support both baremetal and _clouds_ by implementing a **provider** &rarr; **give me a machine** by constraints, eg. CPU, mem
      </li><li>
        Support premise and public clouds (12 out of box)
      </li><li>
        Used as single-layer orchestrator
      </li>
    </ol>
  </div>
</div>
---
<section data-background="https://drscdn.500px.org/photo/179822321/q%3D80_m%3D2000_k%3D1/v2?webp=true&sig=51cdb14b0e0929a01b68133e08caff3d0370f1418ba18be62e5a9c3d193e1ddd">
  <div align="left" class="col s6">
    A new way to describe
    <h2>
      Solution Architecture
    </h2>
  </div>
</section>
---
<h6>what we have Today</h6>

<div class="row">
  <div class="col l6 m6 s12">
    <a href="https://lenovopress.com/lp0099.pdf">
      <img data-src="images/ra.png">
      <i class="fa fa-external-link"></i>
    </a>
  </div>
  <div class="col l6 m6 s12">
    <img data-src="images/ra%20deployment%20example.png">
  </div>
</div>

Note:
1. page 27: deployment example
---
<h6>
  Replace static HW with **charms models <i class="fa fa-battery"></i>**
</h6>

<div class="row">
  <iframe data-src="https://www3.lenovo.com/us/en/data-center/servers/racks/System-x3650-M5/p/77XS7HV7V64"
          class="col l7 m8 s12">
  </iframe>
  <div class="col l5 m4 s12">
    <img data-src="images/uhm%20code%20file%20structure.png">
  </div>
RA = HW charms + platform charm + application charms
</div>
---
<h6>**Five steps** to transform a paper model &rarr; charm model</h6>

1. hierarchy &rarr; abstract base model
2. attributes &rarr; configuration options
3. data interface &rarr; relations
4. workflow &rarr; states, hooks
5. actions &rarr; Ansible playbooks

---
<h6>
  Take server for example: 1. hierarchy
</h6>

<div class="row">
  <iframe data-src="http://www.lenovofiles.com/3dtours/products/index.html">
  </iframe>
</div>

<div align="left">
server &rarr;  mainstream rack servers &rarr; SR630<br>
We can design a base **charm-server**, then include it in _charm-sr630_
  to inherit base attributes and behaviors.
</div>
---
<h6>
  Take server for example: 2. configurations
</h6>

<pre class="brush:yaml">
options:
  # catalog attributes
  cpu_sockets:
    type: int
    default: 2
    description: ""
  max_25_disks:
    type: int
    default: 12
    description: ""
  max_25_disks:
    type: int
    default: 6
    description: ""

  # reference architecture attributes
  firmware_policy:
    type: string
    default: "policy ID 1231"
    description: ""
  config_pattern:
    type: string
    default: "config ID 367"
    description: ""

  # orchestration attributes
  uhm:
    type: string
    default: ""
    description: "Can be a YAML string"
</pre>
---
Take server for example: 3. relations

| from   | to     | data                       |
|--------|--------|----------------------------|
| server | rack   | announce server_id         |
| rack   | server | announce other servers' IP |
| server | switch | server_ip                  |
| switch | server | available ports            |

---
Take server for example: 4. workflow
<div class="row">
  <div class="col s6">
    <img data-src="images/endpoint%20states.png"
         class="materialboxed">
  </div>
  <div class="col s6">
    <pre class="brush:python">
@when_not('endpoint.ready', 'endpoint.error')
def check_endpoint():
    """Check whether endpoint is ready.
    """
    set_state('endpoint.details.valid')


@when_not('endpoint.ready', 'endpoint.error')
@when('endpoint.details.valid')
def check_compliance():
    """Check firmware compliance.
    """
    run_uhm(playbook='check_compliance',
            tags='',
            current_state='endpoint.details.valid',
            next_state='endpoint.config.valid',
            error_state='endpoint.config.invalid')
    </pre>
  </div>
</div>

---
Take server for example: 5. actions

from rodney

---
Live demo
<iframe data-src="https://192.168.122.238/gui/"
        height="550px" width="100%"></iframe>
---
# Thank you
---
