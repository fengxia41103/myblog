<h6>Unified Hardware Management (UHM)</h6>

1. Introduction
2. WSS-based POC
3. Demo
---
<h6>UHM: **concept**</h6>
<div class="row">
  <div class="col s12">
    <img data-src="images/uhm%20concept.png"
         style="box-shadow:none;">
  </div>
</div>
---
<h6>UHM POC: **user story**</h6>
<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/uhm%20rack.png"
         class="no-shadow">
  </div>

  <div class="col l6 m6 s12">
    <ul>
      <li>
        **AS A**: lenovo customer
      </li>
      <li>
        **I WANT**: a setup that --
        <ol>
	  <li>Has 1 rack</li>
	  <li>1 switch</li>
	  <li>Install 2 servers:</li>
          <ol>
            <li>one to install Windows, and </li>
            <li>one to install ESXi.</li>
          </ol>
	  <li>Server-win has:</li>
          <ol>
            <li>firmware version 4.1</li>
            <li>using config pattern GOLD</li>
	    <li>connected to VLAN 6</li>
          </ol>
          <li>Server-esxi has firmware version 3.8</li>
        </ol>
      </li>
      <li>
        **SO THAT**: I can install my application
      </li>
    </ul>
  </div>
</div>


---
<h6>UHM POC: WSS-based design</h6>
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
<h6>UHM POC: design WSS models</h6>

<div class="row">
  <div align="left"
       class="col s6">
    1. Design charms & playbooks:<br>
    <img data-src="images/uhm%20charms.png">
    <br>
    
    2. Design charm relations:<br>
    <img data-src="images/uhm%20relations.png">
  </div>
  <div align="left"
       class="col s6">
    3. Make them available in (local) store:<br>
    <img data-src="images/uhm%20demo%20juju%20gui%202.png"
         style="box-shadow:none;">
  </div>
</div>
---
<h6>UHM POC: compose WSS orchestration</h6>

<div class="row">
  <div align="left"
       class="col s6">
    4. Compose an orchestration manifest (bundle):<br>
    <img data-src="images/uhm%20solution%20bundle.png">
  </div>
  <div align="left"
       class="col s6">
    Or, create the bundle using Juju GUI:<br>
    <img data-src="images/uhm%20demo%20juju%20gui.png"
  </div>
</div>
---
<h6>UHM poc: overall workflow</h6>
<div class="row">
  <div class="col s7">Design models</div>
  <div class="col s3">Compose orchestration bundle</div>
  <div class="col s2">Orchestrate</div>
</div>

<img data-src="images/uhm%20orchestration%20workflow.png"
     class="no-shadow">
---
<h6>UHM poc: charm inheritance</h6>
<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/uhm%20charm%20inheritance.png"
         class="no-shadow">
  </div>
  <div class="col l6 m6 s12">
    <dl>
      <dt>layer-endpoint</dt>
      <dd>
        common attributes and functions of HW charms, eg. all
        HW charm will have an attribute `uuid`
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
<h6>UHM poc: code structure</h6>

<img data-src="images/uhm%20code%20file%20structure.png"
     class="no-shadow">
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
