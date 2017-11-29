<!-- Section 2: key technology  -->
<section data-background="https://drscdn.500px.org/photo/106221169/q%3D80_m%3D2000/v2?webp=true&sig=4d1adadcf323aae65032cea2b95c76f60b140cb07fdcb7f82b7e137749c398cc">
  <div align="left" class="col s6">
    Key Technology:
    <h2>
      Canonical Juju charms
    </h2>
  </div>
</section>
---
<h6 class="menu-title">Table of contents</h6>

1. Introduction
  1. store (live demo)
  2. charm code
  3. dist files
3. Key concepts
  1. layer
  2. hook
  3. state
  4. relation
  5. script execution
  6. bundle
4. Charm deployment
  1. (live demo)
---
<h6>Charm: **introduction**</h6>

<p align="left" >
  <i class="fa fa-quote-left"></i>
  The central mechanism behind Juju is called Charms.
  Charms can be written in any programming language that can be executed from the command line.
  <i class="fa fa-quote-right"></i>
</p>

<p align="left">
  **Example**:
</p>
<p align="left">
databases (19), app-servers (19), file-servers (16), monitoring (14),
ops (9), openstack (51), applications (75), misc (63), network (11),
  analytics (7), apache (38), security (4), storage (17)
</p>
<p class="right">
  <i class="fa fa-hand-o-right"></i>
  **343** recommended ones, **1819** community contributed
ones
</p>
---

<h6>Charm: **intro**: **store (live)**</h6>

<iframe data-src="https://jujucharms.com/q/openstack"
        height="550px" width="100%"></iframe>
<div class="divider"></div>

**4** machines (VM & containers), **16** services, **1** click
---
<h6>charm: **intro**: **charm code**</h6>

<figure>
  <img data-src="images/charm%20components.png"
       style="box-shadow:none;">
</figure>

<dl class="my-multicol-2">
  <dt>YAML files</dt>
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
  
  <dt>Action (eg. playbooks)</dt>
  <dd>
    These can be independently developed and usable without charms.
  </dd>

  <dt>Layer</dt>
  <dd>
    Re-use other existing charm code, eg. utility function.
  </dd>

  <dt>Dependency packages</dt>
  <dd>
    In Python, these will be wheelhouse packages required by
    the charm scripts. They will be installed in
    charm's runtime env (thus, OS dependent).
  </dd>
</dl>
---
<h6>charm: **intro**: **dist files**</h6>

<pre class="brush:plain;">
|-- ansible.cfg
|-- bin/
|-- config.yaml         <-- attributes/config options
|-- hooks/              <-- hook handlers
|-- icon.svg
|-- layer.yaml          <-- layer inheritance
|-- lib/                <-- utility `.py`
|-- metadata.yaml       <-- relations/interfaces
|-- playbooks/          <-- playbooks
|-- reactive/           <-- states  
|-- README.md
`-- wheelhouse/         <-- Python dependency libs
</pre>

---
<h6>Charm: **key concepts**</h6>

| Concepts  | used for                                |
|-----------|-----------------------------------------|
| config    | charm's `key:val` that is user accessible |
| states    | user defined flags                      |
| hooks     | a hardcoded set of handlers             |
| relations | data communication                      |
| layer     | model inheritance                       |
| bundle    | deployment batch mode                   |

---
<h6>charm: **key concepts**: **config (YAML)**</h6>
<div class="row">
  <div class="col s8">
    Example config YAML:
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
      <li>
        Config key-value pairs that are
        meant to be set by user/operator
        at runtime to affect charm's behavior without
        modifying its code.
      </li>
      <li>Support **four data types**:
        <ol>
          <li>int</li>
          <li>float</li>
          <li>boolean</li>
          <li>string: for complex configs, use another YAML/json!</li>
        </ol>
      </li>
    </ol>
  </div>
</div>
---
<h6>charm: **key concepts**: **states**</h6>

<div class="row">
  <div class="col s6">
    <img data-src="images/charm%20chain%20states.png"
         style="box-shadow:none">
  </div>
  <div class="col s6">
    <ol>
      <li>
        States should be viewed as **flags** &rarr; multiple
        flags can be `true` at the same time.
      </li>
      <li>
        `set_state()` to raise a flag; `remove_state()` to
        lower one.

          `remove_state()` does not take affect immediately &rarr; code
          of a state **can be executed more than once**.

      </li>
      <li>
        `@when`, `@when_not` to check a flag (or its negation).
        If condition is met, code block is executed.
        This can be anything, eg. calling
        Ansible from charm.
      </li>
      <li>
        States can be split among layers,
        but not across different charms
        or different units of the same charm.
      </li>
      <li>
        States from all included layers share the same namespace.
      </li>
      <li>
        Flag checking and (un)setting is driven by a
        hard-coded 5-minute (non realtime) loop.
      </li>
    </ol>
  </div>
</div>

---
<h6>charm: **key concepts**: **state code**</h6>

Example state code:
    
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

States are defined in `[your charm]/reactive/*.py`:
<pre class="brush:plain">
-rw-rw-r--  1 fengxia fengxia 7214 Oct  3 10:16 icon.svg
-rw-rw-r--  1 fengxia fengxia   95 Oct  3 10:16 layer.yaml
-rw-rw-r--  1 fengxia fengxia  207 Oct  3 10:16 metadata.yaml
drwxrwxr-x  2 fengxia fengxia 4096 Oct 27 23:01 reactive   <-- states
</pre>

---
<h6>Charm: **key concepts**: **hooks**</h6>

<div class="row">
  <div class="col s12">
    <img data-src="images/charm%20hooks.png"
         style="box-shadow:none">
  </div>
  <div class="col s12">
    <ol>
      <li>
        Hook types and sequences are
        **hard-coded** in `juju/worker/uniter/operation/runhook.go` &rarr;
        compiled in `juju` & `jujud` (agent) binaries.
      </li>
      <li>
        Though being replaced by states, it is still
        the core that drives everthing in charm execution.
      </li>
      <li>
        `update-status` loop drives state scanning and flag (un)setting.
        But `remove_state` may surprise you. 
      </li>
    </ol>
  </div>
</div>
---
<h6>charm: **key concepts**: **hook code**</h6>

<div class="row">
  <div class="col l10 m10 s12">
Example hook code:
<pre class="brush:python">
#!/usr/bin/env python

import os

# Load modules from $JUJU_CHARM_DIR/lib
import sys
sys.path.append(os.path.join(os.getcwd(), 'lib'))

# This will load and run the appropriate @hook and other decorated
# handlers from $JUJU_CHARM_DIR/reactive, $JUJU_CHARM_DIR/hooks/reactive,
# and $JUJU_CHARM_DIR/hooks/relations.
#
# See https://jujucharms.com/docs/stable/authors-charm-building
# for more information on this pattern.
from charms.layer import basic
basic.bootstrap_charm_deps()
basic.init_config_states()

from charms.reactive import main
main()
</pre>
  </div>
  <div class="col l2 m2 s12">
    <ol>
      <li>
        `import` sequence is important &rarr; without `sys.path.append`,
        importing `from charms.layer import basic` will fail.
      </li>
      <li>
        `bootstrap_charm_deps()` will install repo packages, wheelhouses.
      </li>
      <li>
        `init_config_states()` loads config key:value pairs and setup flags.
      </li>
    </ol>
  </div>
</div>

---
<h6>charm: **key concepts**: **hook code**</h6>

<div class="row">
  <div class="col s12">
Hooks are defined in `layer-basic/hooks`:

<pre class="brush:plain">
-rwxrwxr-x 1 fengxia fengxia  561 Oct  3 10:16 config-changed
-rwxrwxr-x 1 fengxia fengxia  561 Oct  3 10:16 hook.template
-rwxrwxr-x 1 fengxia fengxia  550 Oct  3 10:16 install
-rwxrwxr-x 1 fengxia fengxia  549 Oct  3 10:16 leader-elected
-rwxrwxr-x 1 fengxia fengxia  549 Oct  3 10:16 leader-settings-changed
-rwxrwxr-x 1 fengxia fengxia  550 Oct  3 10:16 start
-rwxrwxr-x 1 fengxia fengxia  550 Oct  3 10:16 stop
-rwxrwxr-x 1 fengxia fengxia  549 Oct  3 10:16 update-status
-rwxrwxr-x 1 fengxia fengxia  865 Oct  3 10:16 upgrade-charm
</pre>
  </div>
  <div class="col s12">
    <ol>
      <li>
        `layer-basic` is included in every charm &rarr; changing
        its hook code is not advised.
      </li>
      <li>
        `hook.template` is used to create a missing hook (remember
        hooks are hard-coded in `juju` binary, it must have a
        counterpart in charm's python code!)
      </li>
      <li>
        By default, all hooks have the exact same code.
      </li>
      <li>
        Hook can not be overriden in other layers. `charm build` will
        complain upon seeing two identical hook names.
      </li>
    </ol>
  </div>
</div>
---
<h6>Charm: **key concepts**: **relations**</h6>

<div class="row">
  <div class="col s12">
    <img data-src="images/charm%20relation%20and%20interface.png"
         style="box-shadow:none">
  </div>
  <div align="left"
       class="col s12">
    One side "provide", the other "require", so that a provided
    interface can be **reused** by multiple requirers.

    <p>
      In this example, charm on the left hand side provides two
      interfaces: `database` and `website`. The `mediawiki charm` on
      the right hand side thus does not need to install database
      itself. Instead, it uses a `require` to connect to the
      `database` interface provided by the other charm. Database IP,
      port, login credentials will then be exchanged when relations are `joined`
      (connected).
    </p>
  </div>
</div>
---
<h6>charm: **key concepts**: **relation code**</h6>

<div class="row">
  <div class="col s9">
    Example relation code:
    
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
        global, unit, subordinate, <a
        href="https://jujucharms.com/docs/devel/models-cmr">cross
        model</a>.
      </dd>
    </dl>
  </div>
</div>
---
<h6>charm: **key concepts**: **relation code**</h6>

Relations are defined in `$INTERFACE_PATH/[relation name]`:

<pre class="brush:plain">
-rw-rw-r-- 1 fengxia fengxia 1.3K Nov 26 09:57 provides.py
-rw-rw-r-- 1 fengxia fengxia 1.8K Nov 26 09:57 requires.py
</pre>

Relation `provide` and `require` are defined in `metadata.yaml`:
<pre class="brush:yaml">
name: rack
...
provides:
  server:
    interface: rack-server
  switch:
    interface: rack-switch
requires:
  solution:
    interface: solution-rack
</pre>

Relation (code) is included in `layer.yaml`:
    <pre class="brush:yaml">
includes: [..., 'interface:solution-rack', 'interface:rack-server', 'interface:rack-switch']
    </pre>
---
<h6>Charm: **key concepts**: **layers**</h6>
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
<h6>charm: **key concepts**: **layer code**</h6>

Example `layer.yaml`:

<pre class="brush:yaml">
includes: ['layer:endpoint', 'interface:....']
</pre>

1. State `.py` files from `layer:endpoint` will be copied to `$JUJU_REPOSITORY/[series]/[charm name]/reactive`.
2. States from children layers are therefore merged into the same name space.
3. Can nest.
2. Hooks can not be overriden.
---
<h6>charm: **key concepts**: **script execution**</h6>
<img data-src="images/charm%20execution.png"
     style="box-shadow:none;">


1. Hooks and states are Python code. So it can call **anything**.

---
<h6>Charm: **key concepts**: **bundle**</h6>

<div class="row">
  <div class="col s6">
    Example bundle YAML: 
    <pre class="brush:yaml">
series: xenial

machines:
  '0':
    series: xenial
    
services:
  ceph-mon:
    charm: cs:ceph-mon-12
    num_units: 3
    options:
      expected-osd-count: 3
      source: cloud:xenial-pike
    to:
    - lxd:1
    - lxd:2
    - lxd:3

relations:
- - nova-compute:amqp
  - rabbitmq-server:amqp
- - neutron-gateway:amqp
  - rabbitmq-server:amqp
    </pre>
  </div>
  <div class="col s6">
    <p>
      Bundle YAML is a description to deploy charms in **batch mode**.
      It can be imported to & exported from Juju GUI, so they are
      interchangeable.
    </p>
    Four key elements to define:
    <dl>
      <dt>series</dt>
      <dd>
        Defautl OS to provision. Can also be overridden by individual _service_.
      </dd>

      <dt>machines</dt>
      <dd>
        Definitions of runtime host environment (aka. machine) who
        will execute the charm code.
      </dd>

      <dt>services</dt>
      <dd>
        A service &larr; a charm.
        <ol>
          <li>**option**: config values</li>
          <li>**num_units**: number of instances of this service (HA)</li>
          <li>**to**: in which machine/container these instances will be running </li>
        </ol>
      </dd>

      <dt>relations</dt>
      <dd>
        Connecting services so they can exchange data when coming online.
      </dd>
    </dl>
  </div>
</div>
---
<h6>Charm: **deployment**</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/juju%20control%20modeling.png"
    style="box-shadow:none;">
  </div>
  <div class="col s3">
    <dl>
      <dt>service</dt>
      <dd>
        A service == a SW == a charm.
      </dd>

      <dt>unit</dt>
      <dd>
        A unit == a running instance of a service.
        Each unit has a `sqlite` to save states.
        A service can have > 1 units (HA). Their `sqlite` are not
        shared.
      </dd>

      <dt>machine</dt>
      <dd>
        Request via `provider`. Is the running
        env into which charm code is copied to and run.

        <p>
          Charm code is copied to a fixed directory
          on its runtime machine
          (`/var/lib/juju/agents/unit-[app name]-[unit #]/`).
        </p>
        
        A machine can host > 1 services/units.
      </dd>
    </dl>
  </div>
</div>
---
<h6>Charm: **demployment**: **live demo**</h6>

<iframe data-src="https://jujucharms.com/q/openstack"
        height="550px" width="100%"></iframe>
<div class="divider"></div>

