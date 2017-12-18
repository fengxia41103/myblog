<h6>Unified Hardware Management (UHM)</h6>

1. Intro
  1. concept
  2. objective
  3. definition of done
3. Analysis & design
  1. process framework
  2. core services
  3. data model
3. Strategy
  1. WSS strategy
  1. model of a full stack
  2. orchestration of a full stack
  3. WSS view of a UHM stack
2. Implementation
  1. function architecture
  2. technology stack
  4. build
  5. packaging
  3. deployment
  6. dev
  7. testing
  8. distribution
  9. upgrade
2. POC
  1. user story
  2. charm models
  3. Demo

---
<h6>UHM intro: **concept**</h6>

Using `LXCA` as HW manager to setup hardware (rack, switch, and
server). For each HW, it takes three steps
to config it: 1. resource registration; 2, firmware compliance; 3. HW configuration.


<img data-src="images/uhm%20concept.png"
     style="box-shadow:none;">

---
<h6>UHM intro: **objective**</h6>

TBD

---
<h6>UHM intro: **definition of done**</h6>

TBD
---
<h6>UHM POC: **user story**</h6>
<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/uhm%20rack.png"
         class="no-shadow">
  </div>

  <div class="col l6 m6 s12">
    <dl>
      <dt>AS A</dt>
      <dd>lenovo customer</dd>

      <dt>I WANT</dt>
      <dd>
        to setup a rack that --
        <ul>
	  <li>Has 1 rack</li>
	  <li>1 switch</li>
	  <li>Install 2 servers:</li>
          <ol>
            <li>one to install `Windows server 2016`, and </li>
            <li>one to install `ESXi 6.5.0`.</li>
          </ol>
	  <li>Server-win has:</li>
          <ol>
            <li>firmware version `4.1`</li>
            <li>using config pattern `GOLD`</li>
	    <li>connected to `VLAN 6`</li>
          </ol>
          <li>Server-esxi has firmware version `3.8`</li>
        </ul>
      </dd>
      
      <dt>SO THAT</dt>
      <dd>I can install my application</dd>
    </dl>
  </div>
</div>
---
<h6>UHM POC: **wss view of a UHM stack**</h6>

<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/wss%20view%20of%20uhm%20stack.png"
         class="no-shadow">
  </div>
  <div class="col l6 m6 s12">
    <dl>
      <dt>blueprints</dt>
      <dd>
        Two type of blueprints: HW and platform.
        <ol>
          <li>
            **HW blueprints**: rack, switch, and server.
          </li>
          <li>
            **platform**: uhm solution
          </li>
      </dd>

      <dt>orchestration</dt>
      <dd>juju</dd>

      <dt>platform</dt>
      <dd>
        Baremetals via LXCA.

        <p>
          However, we are not using a `LXCA provider` to
          orhcestrate. Instead, charm model will call Ansible, which
          in turn calls `pylxca` lib that speaks to LXCA's REST api.
        </p>
      </dd>
    </dl>
  </div>
</div>
---
<h6>UHM POC: **WSS strategy**</h6>
<div class="row">
  <div class="col s5">
    Inputs
  </div>
  <div class="col s4">
    Orchestration service
  </div>
  <div class="col s3">
    Outputs
  </div>
  <div class="col s12">
    <img data-src="images/uhm%20poc%202.png"
         style="box-shadow:none;">
  </div>
</div>
---
<h6>UHM poc: **charm models**</h6>

Platform charm:

1. (UHM) solution

HW charms:

1. rack
2. switch
3. server

Charm relations:

| provide  | require |
|----------|---------|
| solution | rack    |
| rack     | server  |
| rack     | switch  |
| switch   | server  |
---
<h6>UHM poc: **charm model**: **platform**: **(uhm) solution**: **workflow**</h6>

`(uhm) solution` charm workflow diagram:

<img data-src="https://lnvusconf.lenovonet.lenovo.local/download/attachments/49027586/solution_charm_fsm.png?version=19&modificationDate=1502813714000&api=v2"
     class="no-shadow">

Ref: [UHM wiki][21]

[21]: https://lnvusconf.lenovonet.lenovo.local/display/TSM/Endpoint+Charm+Design

---
<h6>uhm poc: **charm model**: **Plaftform**: **(uhm) solution**: **config options**</h6>

<div class="my-multicol-2">
<pre class="brush:yaml">
options:
status:
  default: ''
  type: int
  description: ''
bm_manager:
  default: ''
  type: string
  description: ''
description:
  default: ''
  type: string
  description: ''
parent:
  default: ''
  type: string
  description: ''
is_active:
  default: ''
  type: boolean
  description: ''
playbooks:
  default: ''
  type: string
  description: ''
switches:
  default: ''
  type: string
  description: ''
applications:
  default: ''
  type: string
  description: Supported application list
charm:
  default: ''
  type: string
  description: ''
firmware_repo:
  default: ''
  type: string
  description: ''
id:
  default: ''
  type: string
  description: ''
name:
  default: ''
  type: string
  description: ''
lxca:
  default: ''
  type: string
  description: ''
uuid:
  default: ''
  type: string
  description: ''
servers:
  default: ''
  type: string
  description: ''
compliance:
  default: ''
  type: string
  description: ''
solution:
  default: ''
  type: string
  description: ''
racks:
  default: ''
  type: string
  description: ''
version:
  default: Alpha
  type: string
  description: ''
powers:
  default: ''
  type: string
  description: ''
order:
  default: '21873'
  type: string
  description: Order number
</pre>
</div>
---
<h6>uhm poc: **charm model**: **platform**: **(uhm) solution**: **playbooks**</h6>

| Name                   | Path                         | Tags                  | Extra Vars (JSON) | Comment                                     |
|------------------------|------------------------------|-----------------------|-------------------|---------------------------------------------|
| check solution         |                              |                       |                   |                                             |
| store manifest         | playbooks/uhm/manifests.yml  | manifest              |                   |                                             |
| manage                 | playbooks/config/config.yml  | manage                |                   | Playbook to use for server management       |
| group                  | playbooks/uhm/thinkagile.yml | create_resourcegroups |                   | Playbook to use for group creation          |
| add system             |                              | create_resourcegroups |                   | Playbook to use for adding systems to group |
| upload repo pack       | playbooks/config/config.yml  | updaterepo            |                   |                                             |
| upload config patterns | playbooks/config/config.yml  | import_configpatterns |                   |                                             |
| upload rules           |                              | import_configrules    |                   |                                             |
| post actions           |                              |                       |                   |                                             |
---
<h6>uhm poc: **charm model**: **HW charms**: **rack**: **workflow**</h6>

<img data-src="https://lnvusconf.lenovonet.lenovo.local/download/attachments/49027660/rack_charm_fsm.png?version=6&modificationDate=1502327051000&api=v2"
     class="no-shadow">
---
<h6>uhm poc: **charm model**: **HW charms**: **rack**: **config options**</h6>

<div class="my-multicol-2">
  <pre class="brush:yaml">
options:
  expansion_rack:
    default: ''
    type: string
    description: Expansion rack for the primary
  sidewall_compartment:
    default: ''
    type: int
    description: ''
  description:
    default: ''
    type: string
    description: ''
  is_primary:
    default: ''
    type: boolean
    description: ''
  is_active:
    default: ''
    type: boolean
    description: ''
  eia_capacity:
    default: ''
    type: int
    description: ''
  id:
    default: ''
    type: string
    description: ''
  name:
    default: ''
    type: string
    description: ''
  </pre>
</div>
---
<h6>uhm poc: **charm model**: **HW charms**: **rack**: **playbooks**</h6>

| Name                   | Path                         | Tags                  | Extra Vars (JSON) | Comment                                     |
|------------------------|------------------------------|-----------------------|-------------------|---------------------------------------------|
| validate details       |                              |                       |                   |                                             |
| create rack            |                              |                       |                   |                                             |

---
<h6>UHM poc: **charm model**: **HW charms**: **layer-endpoint**: **workflow**</h6>

By default all HW charms inherting from `layer-endpoint`
will share the same workflow:

<img data-src="https://lnvusconf.lenovonet.lenovo.local/download/attachments/49027559/server_charm_fsm.png?version=14&modificationDate=1502814245000&api=v2"
     class="no-shadow">

Ref: [UHM wiki][21]

[21]: https://lnvusconf.lenovonet.lenovo.local/display/TSM/Endpoint+Charm+Design
---

<h6>UHM poc: **charm model**: **HW charms**: **switch**: **workflow**</h6>

<img data-src="https://lnvusconf.lenovonet.lenovo.local/download/attachments/49027559/server_charm_fsm.png?version=14&modificationDate=1502814245000&api=v2"
     class="no-shadow">

Ref: [UHM wiki][21]

[21]: https://lnvusconf.lenovonet.lenovo.local/display/TSM/Endpoint+Charm+Design
---
<h6>uhm poc: **charm model**: **HW charms**: **switch**: **config options**</h6>

<div class="my-multicol-2">
  <pre class="brush:yaml">
options:
  size:
    default: ''
    type: int
    description: ''
  orientation:
    default: ''
    type: string
    description: ''
  is_active:
    default: ''
    type: boolean
    description: ''
  name:
    default: ''
    type: string
    description: ''
  rear_to_front:
    default: ''
    type: boolean
    description: ''
  speed:
    default: ''
    type: int
    description: ''
  id:
    default: ''
    type: string
    description: ''
  description:
    default: ''
    type: string
    description: ''
  </pre>
</div>

---
<h6>uhm poc: **charm model**: **HW charms**: **switch**: **playbooks**</h6>

| Name                 | Path                        | Tags | Extra Vars (JSON)   | Comment |
|----------------------|-----------------------------|------|---------------------|---------|
| apply firmware       | playbooks/config/config.yml |      | [immediate,apply]   |         |
| assign policy        | playbooks/config/config.yml |      | [sampletest,SERVER] |         |
| update configuration | playbooks/config/config.yml |      | [67,pending,node]   |         |

---

<h6>UHM poc: **charm model**: **HW charms**: **server**: **workflow**</h6>

<img data-src="https://lnvusconf.lenovonet.lenovo.local/download/attachments/49027559/server_charm_fsm.png?version=14&modificationDate=1502814245000&api=v2"
     class="no-shadow">

Ref: [UHM wiki][21]

[21]: https://lnvusconf.lenovonet.lenovo.local/display/TSM/Endpoint+Charm+Design
---
<h6>uhm poc: **charm model**: **HW charms**: **server**: **config options**</h6>

<div class="my-multicol-2">
  <pre class="brush:yaml">
options:
  max_35_disk:
    default: ''
    type: int
    description: ''
  description:
    default: ''
    type: string
    description: ''
  orientation:
    default: ''
    type: string
    description: ''
  is_active:
    default: ''
    type: boolean
    description: ''
  max_25_disk:
    default: ''
    type: int
    description: Maximum number of 2.5inch disks
  size:
    default: ''
    type: int
    description: ''
  id:
    default: ''
    type: string
    description: ''
  cpu_sockets:
    default: ''
    type: int
    description: ''
  name:
    default: ''
    type: string
    description: ''
  </pre>
</div>

---
<h6>uhm poc: **charm model**: **HW charms**: **server**: **playbooks**</h6>

| Name                 | Path                        | Tags | Extra Vars (JSON)   | Comment |
|----------------------|-----------------------------|------|---------------------|---------|
| check compliance     |                             |      |                     |         |
| acquire server       |                             |      |                     |         |
| update policy        |                             |      |                     |         |
| manage server        |                             |      |                     |         |
| update configuration |                             |      |                     |         |
| deploy os            |                             |      |                     |         |
| post actions         |                             |      |                     |         |
| apply firmware       | playbooks/config/config.yml |      | [immediate,apply]   |         |
| assign policy        | playbooks/config/config.yml |      | [sampletest,SERVER] |         |
| update configuration | playbooks/config/config.yml |      | [67,pending,node]   |         |
---
<h6>UHM poc: **charm model**: **HW charms**: **layers**</h6>
<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/uhm%20charm%20inheritance.png"
         class="no-shadow">
  </div>
  <div class="col l6 m6 s12">
    <dl>
      <dt>layer-endpoint</dt>
      <dd>
        parent charm/layer of HW charms (exccluding `rack` charm). It
        implements common attributes and functions of HW charms,
        eg. all HW charm will have an attribute `uuid`
      </dd>

      <dt>layer-uhm</dt>
      <dd>
        common UHM helper functions, eg. log_uhm, run_uhm
      </dd>

      <dt>layer-ansbile</dt>
      <dd>
        Ansible integration
      </dd>

      <dt>layer-pylxca</dt>
      <dd>
        Install `pylxca` Python module
      </dd>

      <dt>layer-basic</dt>
      <dd>
        Handle installation of repo packages
      </dd>
    </dl>
  </div>
</div>

---
<h6>UHM poc: **dev**: **logistics**</h6>

1. Main: [http://hpcgitlab.labs.lenovo.com/WSS/wss/tree/uhm][8]

[8]: http://hpcgitlab.labs.lenovo.com/WSS/wss/tree/uhm

<img data-src="images/uhm%20code%20file%20structure.png"
     class="no-shadow">

---
<h6>UHM demo (live)</h6>
<iframe data-src="https://10.240.42.32/gui/"
        height="550px" width="100%"></iframe>
