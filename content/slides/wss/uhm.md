<h6>Unified Hardware Management (UHM): **concept**</h6>
<div class="row">
  <div class="col s12">
    <img data-src="images/uhm%20concept.png"
         style="box-shadow:none;">
  </div>
</div>
---
<h6>**UHM POC**: objectives</h6>

<p align="left">
  **Expected**:<br><br>
  Using WSS technologies to model 1 rack, 1 switch, and 2 servers. Once
  workloads have been deployed, servers are **managed** by LXCA and each has
  user-defined attributes &mdash; one server is assigned as
  Windows server, the other for ESXi server, and each has a different
  firmware version.
</p>
---
<h6>**UHM POC**: WSS-based design</h6>
<div class="row">
  <div class="col s3">
    Inputs
  </div>
  <div class="col s6">
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
<h6>**UHM POC**: WSS models</h6>

<div class="row">
  <div align="left"
       class="col s6">
    1. **Design charms & playbooks**:<br>
    <img data-src="images/uhm%20charms.png">
    **Design charm relations**:<br>
    <img data-src="images/uhm%20relations.png">
  </div>
  <div align="left"
       class="col s6">
    2. **Make them available in store**:<br>
    <img data-src="images/uhm%20demo%20juju%20gui%202.png"
         style="box-shadow:none;">
  </div>
</div>
---
<h6>**UHM POC**: WSS orchestration</h6>

<div class="row">
  <div align="left"
       class="col s6">
    3. **Compose an orchestration manifest (bundle)**:<br>
    <img data-src="images/uhm%20solution%20bundle.png">
  </div>
  <div align="left"
       class="col s6">
    4. **Created a connected HW resources based on bundle definitions**:<br>
    <img data-src="images/uhm%20demo%20juju%20gui.png"
  </div>
</div>
---
<h6>**UHM charm example**: distribution file structure</h6>

<pre class="brush:plain;">
|-- ansible.cfg
|-- bin/
|-- config.yaml         <-- attributes/config options
|-- hooks/              <-- hook handlers
|-- icon.svg
|-- layer.yaml          <-- charm inheritance
|-- lib/                <-- utility `.py`
|-- metadata.yaml       <-- charm relations/interfaces
|-- playbooks/          <-- playbooks
|-- reactive/           <-- user defined flags  
|-- README.md
`-- wheelhouse/         <-- Python dependency libs
</pre>
---
<h6>**UHM charm example**: config.yaml</h6>

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
<h6>**UHM charm example**: metadata.yaml</h6>

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
    "rack-server" and "switch-server" indicates which
    code "charm build" will collect and package. For example,
    "rack-server" will take an interface defined as "rack is providing"
    and "server is requiring/receiving".
  </div>
</div>

<h6>**UHM charm example**: layer.yaml</h6>

<div class="row">
  <div class="col s7">
    <pre class="brush:yaml">
includes: ['layer:endpoint', 'interface:rack-server', 'interface:switch-server']
repo: hpcgitlab.labs.lenovo.com/WSS/wss.git
    </pre>
  </div>
  <div class="col s1"></div>
  <div align="left" class="col s4">
    Include **layer:** and **interface:**.
  </div>
</div>

---
<h6>**UHM charm example**: charm state script</h6>

<div class="row">
  <div class="col s7">
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
  <div class="col s1"></div>
  <div class="col s4">
    <ol>
      <li>Use when and when_not conditions
        to define execution criteria.</li>
      <li>Code body can be executed multiple times
        even with "remove_state" to turn off itself.</li>
    </ol>
  </div>
</div>
---
<h6>**UHM charm example**: charm relation script</h6>

<div class="row">
  <div class="col s9">
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
  </div>
  <div class="col s3">
    <dl>
      <dt>Four events</dt>
      <dd>
        joined, changed, broken, departed
      </dd>

      <dt>Four scopes</dt>
      <dd>
        global, unit, subordinate, **cross-model**
      </dd>
    </dl>
  </div>
</div>

---
<h6>**UHM charm example**: charm deployment bundle</h6>

<div class="row">
  <div class="col s8">
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
  </div>
  <div class="col s4">
    <dl>
      <dt>series</dt>
      <dd>Default OS version</dd>

      <dt>services</dt>
      <dd>A list of charms to deploy.
        <ol>
          <li>"charm": can be from charm store or from a local repo.</li>
          <li>"num_units": how many instancs?</li>
          <li>"to": deployed to which machine?</li>
        </ol>
      </dd>
    </dl>
  </div>
</div>
---
<h6>UHM demo (live)</h6>
<iframe data-src="https://10.240.42.32/gui/"
        height="550px" width="100%"></iframe>
