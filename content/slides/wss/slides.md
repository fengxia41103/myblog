<section align="left">
  <h1>
    Workload Solution
    <i class="fa fa-shopping-basket">Store</i>
  </h1>
  <br>
  <small class="myhighlight">
    by [fxia1@lenovo.com](mailto:fxia1@lenovo.com)
  </small>
</section>
---
<div align="left">
**Agenda**
</div>

1. Today's challenges
2. Introduction of Juju & charms
3. Transform reference architecture
4. Discussion

---
<section data-background="https://drscdn.500px.org/photo/155532687/q%3D80_m%3D2000/v2?webp=true&sig=4122d59c34dde5e01b0a8fd3b10e0330c3b053c27918e55a68464a1937237a34">
  <div align="left" style="width:67%;float:left;">
    Today's Vendor & Customer
    <h1>
      Challenges to Tackle
    </h1>
  </div>
</section>
---
This is how it is being done today...
---
<div align="left">
  <strong>Client starts with...</strong>
</div>
<figure>
  <img data-src="images/lenovo%20catalog.png"
       height="550px;">
</figure>
---
<div align="left">
  <strong>then, add configurations...</strong>
</div>
<figure>
  <img data-src="images/lenovo%20configurator.png"
       height="550px"/>
</figure>
---
<div align="left">
  <strong>then, Lenovo MFG...</strong>
</div>
<figure>
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
<figure style="width:50%;float:left;">
  <img data-src="http://i.imgur.com/KzCHMAx.gif">
</figure>
<div align="left"
    style="width:40%;float:right">
  Working, but can use an upgrade.<br><br>
  
  We have identified **five** areas
  that WSS aims to bring user an improved
  experience.
</div>

Note:

1. https://developers.google.com/youtube/player_parameters
---
Five challanges
<div class="divider"></div>

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
<section data-background="https://drscdn.500px.org/photo/138747795/q%3D80_m%3D1500_k%3D1/v2?webp=true&sig=20cc685f194e95851ba5ceb3181ca0395d511c07948dd15d884235eb477dcbc6">
  <div style="margin-bottom:140px;">
    <span class="mywhite">Vision of the</span>
    <h1 class="mywhite">
      Workload Solution Store
    </h1>
  </div>
</section>
---
<div align="left">
**Objective**
</div>

1. Unified Hardware Modeling (**UHM** project)
2. HW and SW deployment using the same technology stack
3. Multi-platforms
4. Public and private clouds
5. Simple to execute
---
WSS Stack
<figure style="float:left;width:50%;">
  <img data-src="images/wss%20simplified%20function%20stack.png"
       height="500px"
       style="box-shadow:none;">
</figure>
<div style="width:45%;float:right;">
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
---
WSS vision
<figure>
  <img data-src="images/wss%20vision.png"
       style="box-shadow:none;">
</figure>
<br>

* **Battery included <i class="fa fa-battery"></i>**
* Reduce _lost in translation_
* Open source &rarr; technology transparency
* Build a vendor/user community
* Efficient deployment
---
WSS Framework
<figure>
  <img data-src="images/uhm%20five%20phase.png">
</figure>

HW catalog &rarr; solution architect &rarr; ordering &rarr; configuring &rarr; deployment &rarr; monitoring and validation

Note:

* Manifest is a presentation of configurations defined in our data models.
* Configuration instantiates a model &larr; model is really a template/class.
* Instantiated model will be applied in orchestration to bring expectation
into reality.
---
Scope of tools and services
<figure>
  <img data-src="images/wss%20simplified%20phase.png"
       style="box-shadow:none;">
</figure>

Note:

1. Lenovo, client, 3rd party can create their own models
2. Configurations service to drive **software-defined** objective
---
<div align="right">
**Framework details**: solution design
</div>

<figure>
  <img data-src="images/wss%20architecture%20components%201.png"
       style="box-shadow:none;">
</figure>
---
<div align="right">
**Framework details**: configuration
</div>
<br>
<figure>
  <img data-src="images/wss%20architecture%20components%202.png"
       height="550px"
       style="box-shadow:none;">       
</figure>
---
<div align="right">
**Framework details**: deployment, compliance, monitoring
</div>
<figure>
  <img data-src="images/wss%20architecture%20components%203.png"
       height="550px"
       style="box-shadow:none;">       
</figure>
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
  <div align="right" style="width:67%;float:right;">
    Key Technology:
    <h1>
      Juju & charms
    </h1>
  </div>
</section>
---
Juju
<div class="divider"></div>

<p align="left" >
 **Juju's mission** is to provide a
 modeling language for users that abstracts the specifics of operating
 complex big software topologies.
</p>

<img data-src="https://i.ytimg.com/vi/tsou9S6NoDg/maxresdefault.jpg"
     width="25%"
     style="float:left;">

<div style="width:60%;float:right;">
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

Note:

1. recommended charms: 343, community: 1819
---
Charms
<div class="divider"></div>
<p align="left" >
  The central mechanism behind Juju is called Charms.
  <ul>
    <li>Charms can be written in any programming language that can be executed from the command line.</li>
    <li>A charm is a collection of:
      <ol>
        <li>YAML configuration files</li>
        <li>"hooks". A hook is a naming convention to install software, start/stop a service, manage relationships with other charms, upgrade charms, scale charms, configure charms, etc.</li>
        <li>states. A state is a user-defined condition that is evaluated every 5 minutes.</li>
        <li>Charms can have many properties.</li>
        <li>Charm helpers allow boiler-plate code to be automatically generated.
        </li>
      </ol>
    </li>
  </ul>
</p>


<div  align="left">
**Example**:<br><br>
  
databases (19), app-servers (19), file-servers (16), monitoring (14), ops (9), openstack (51), applications (75), misc (63), network (11), analytics (7), apache (38), security (4), storage (17) &mdash; **343** recommended ones, **1819** community contributed ones</div>

---
WSS strategy of using Juju & charms
<div class="row">
  <figure class="col l7 m12 s12">
    <img data-src="images/wss%20orchestration.png"
         style="box-shadow:none;">
  </figure>
  <div align="left"
       class="col l5 m12 s12">
    <ul>
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
    </ul>
  </div>
</div>
---
<div align="left">
Charms **store**
</div>
<iframe data-src="https://jujucharms.com/store"
        height="550px" width="100%"></iframe>
---
<div align="left">
Charm **components**
</div>
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
**Example**: charm state script

```python
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
```
---
**Example**: charm relation script

```PYTHON
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
```
---
<div align="left">
**Designed** in _reactive_
</div>
<br>

| Concepts  | used for                    |
|-----------|-----------------------------|
| hooks     | a hardcoded set of handlers |
| states    | user defined flags          |
| relations | data communication          |
| layer     | model inheritance           |
| bundle    | deployment batch mode       |

---
<div align="left">
**Built** to a fixed file structure
</div>

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
<div align="left">
**Deployed** in _charm bundle_
</div>

<pre class="brush:yaml;">
series: trusty
services:
  wordpress:
    charm: "cs:trusty/wordpress-2"
    num_units: 1
    annotations:
      "gui-x": "339.5"
      "gui-y": "-171"
    to:
      - "0"
  mysql:
    charm: "cs:trusty/mysql-26"
    num_units: 1
    annotations:
      "gui-x": "79.5"
      "gui-y": "-142"
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
<div align="left">
**Managed** in _Juju GUI_
</div>
<iframe data-src="https://jujucharms.com/new/"
        height="550px" width="100%"></iframe>
---
<div align="left">
Example: a deployed Canonical **Openstack**
</div>

<img data-src="https://insights.ubuntu.com/wp-content/uploads/7790/jjuju.png">

Note:

1. 4 machines (VM & containers)
2. 16 services
3. 1 click
4. On Ubuntu 16.04, single host: 40min
</section>
---
<section data-background="https://drscdn.500px.org/photo/179822321/q%3D80_m%3D2000_k%3D1/v2?webp=true&sig=51cdb14b0e0929a01b68133e08caff3d0370f1418ba18be62e5a9c3d193e1ddd">
  <p class="myhighlight">
    A new way to describe
  </p>
  <br>
  <h1>
    Solution + Architecture
  </h1>
</section>
---
## what we have Today

<a href="https://lenovopress.com/tips1275.pdf">
  <img data-src="images/lcv.png" height="500px">
  <i class="fa fa-external-link"></i>
</a>


Note:
1. page 29: server 3650
---
<div align="left">
  Replace static HW with **charms models <i class="fa fa-battery"></i>**
</div>
<br>

<div class="row">
  <iframe data-src="https://www3.lenovo.com/us/en/data-center/servers/racks/System-x3650-M5/p/77XS7HV7V64"
          height="550px"
          class="col l7 m8 s12">
  </iframe>
  <div class="col l5 m4 s12">
    <img data-src="images/uhm%20code%20file%20structure.png">
  </div>
</div>
---

<section>
<pre class="brush:plain;">
|-- charm-rack          <-- HW charm
|-- charm-server
|-- charm-solution
|-- charm-switch
|-- layer-ansible       <-- Ansible actions
|-- layer-basic         <-- OS package installer 
|-- layer-endpoint      <-- Generic endpoint abstract
|-- layer-pylxca        <-- BM manager library
`-- layer-uhm           <-- UHM
</pre>
</section>

---
<div align="left">
**Definition** of a charm includes
</div>
<br>
<section>
  <iframe data-src="http://www.lenovofiles.com/3dtours/products/index.html"
          height="500px" width="100%"></iframe>

<div align="left">
  <strong>1. Hierarchy</strong>
  <br>
  
  HW charm follows the same grouping used in Lenovo's HW catalog.
</div>
<br>
<i class="fa fa-angle-double-down"></i>
</section>

<section>
  <div align="left">
    <strong>2. Configurations</strong>
    <br>

    Parameters designed to change charm's behavior while keeping the
    template model stable.  Each is specified of a data type and
    validation rules.
  </div>
  <pre class="brush:yaml">
  options:
    uuid:
      type: string
      default: ""
      description: "UUID"
    machine_type:
      type: string
      default: ""
      description: "MTM"
    uhm:
      type: string
      default: ""
      description: "UHM specific definitions in YAML"
  </pre>
  <br>
  <i class="fa fa-angle-double-down"></i>
</section>

<section>
  <div align="left">
    <strong>3. Data interfaces</strong>
    <br>

    Determine who can connect **to** and **from**, and
    what data are passed.
  </div>
  
 ```
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
  ```

  <br>
  <i class="fa fa-angle-double-down"></i>
</section>

<section>
  <div align="left">
    <strong>4. Playbooks</strong>
    <br>
    
    Each charm comes with a set of
    Ansible playbooks that implement actions when a
    charm state is reached.
  </div>

  <pre class="brush:yaml;">
  # tasks file for lenovo.lxca-uhm
  - name: Create a resource group for ThingAgile Solution
    pylxca_module:
      command_options: create_resourcegroups
      login_user: "{{ lxca_user }}"
      login_password: "{{ lxca_password }}"
      auth_url: "{{ lxca_url }}"
      name: "{{ name }}"
      description: "{{ description }}"
      type: "{{ type }}"
      solutionVPD: "{{ solutionVPD }}"
      members: "{{ members }}"
      criteria: "{{ criteria }}"
    register: rslt
    tags:
      create_resourcegroups
  </pre>
  <br>
  <i class="fa fa-angle-double-down"></i>
</section>

<section>
  <div align="left">
    <strong>5. States</strong>
    <br>

    A set of handlers of conditions/events/flags
    of each charm, and condtional dependencies
    among multiple running instances.
  </div>
  
  <pre>
    <code>
@when_not('solution.ready', 'solution.error')
@when('solution.group.created')
def add_system_to_group():
    """Add system to group.
    """
    run_uhm(playbook='add_system',
            tags='add_group_member',
            current_state='solution.group.created',
            next_state='solution.system.added',
            error_state='solution.error')

    </code>
  </pre>
  
</section>
---
## to what we can be 
<img data-src="images/hw%20example.png" height="450px">
---
<iframe data-src="https://192.168.122.238/gui/"
        height="550px" width="100%"></iframe>
---
# Thank you
---
