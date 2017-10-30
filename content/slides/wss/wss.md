<section data-background=""
         align="left">
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

1. Intro of WSS
2. How to model, differently
3. Solution architect
4. Discussion'

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
**this is how it is being done...**
---
<section>
  <div align="left">
    <strong>Client starts with...</strong>
  </div>
  <figure>
    <img src="./images/lenovo%20catalog.png"
         height="550px;">
  </figure>
  <i class="fa fa-angle-double-down"></i>
</section>

<section>
  <div align="left">
    <strong>then, add configurations...</strong>
  </div>
  <figure>
    <img src="./images/lenovo%20configurator.png"
         height="550px"/>
  </figure>
  <i class="fa fa-angle-double-down"></i>
</section>

<section>
  <div align="left">
    <strong>then, Lenovo MFG...</strong>
  </div>
  <figure>
    <img src="https://drscdn.500px.org/photo/135937995/q%3D80_m%3D1000_k%3D1/v2?webp=true&sig=a9bfbffe2a1d74bbbfdbaea7b4263b55c50123204741011f4421bd9a2b8e7745"
         height="300px"
         width="30%"/>
    <img src="https://drscdn.500px.org/photo/199833393/q%3D80_m%3D2000_k%3D1/v2?webp=true&sig=6a47d3ec149bbb62274e389f241e9be47c9cd1fd251a27cb7a59642af2215f1d"
         height="300px"
         width="30%"/>
    <img src="./images/hw_manifest.png"
         height="300px"
         width="30%"/>
  </figure>
  <i class="fa fa-angle-double-down"></i>
</section>

<section>
  <div align="left">
    <strong>in reality...</strong>
  </div>
  <figure>
  <iframe width="67%"
          height="400px"
          src="https://www.youtube.com/embed/PP14X8MXAXA?version=3&autoplay=1&controls=0&loop=1&showinfo=0"
          frameborder="0" gesture="media" allowfullscreen></iframe>
  </figure>
  <!-- <figure>
       <img src="http://i.imgur.com/KzCHMAx.gif">
       </figure> -->
  <i class="fa fa-angle-double-right"></i>
</section>

Note:

1. https://developers.google.com/youtube/player_parameters
---
**so the challenges lie in...**
---
**so the challenges lie in...**

<section>
<div align="left">
**1.**
<br>

Cycle of solution deployment is executed in _weeks_. HW
misconfiguration is not discovered until late in the game, making
the process **inefficient** and **unreliable**.
</div>
</section>

<section>
<div align="left">
**2.**
<br>

**Mixed** tools, scripts and manifests hidden in internal processes.

Domain knowledge is maintained in mixed forms and is **implicit**,
putting the business at risk.
</div>
</section>

<section>
<div align="left">
**3.**
<br>

Lack of visible _model_ to keep **consistency** from client's design
board to delivered solution rack. 

Difficult to **validate** configuration vs. expectation
</div>
</section>

<section>
<div align="left">
**4.**
<br>

No orchestration capability from _HW to SW_ covering "full" stack.

**End-to-end** is a not only a differentiator, but an **enabler** in
product designs that Lenovo can leverage its strength in HW to
support wide range of SW with confidence.
</div>

Note:
LXCA handles OS but nothing beyond (eg. Openstack).
</section>

<section>
<div align="left">
**5.**
<br>

Customers desire solutions across multiple **open** and **proprietary**
platforms on premise or across clouds.
</div>
</section>
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

1. **HW** workload modeling
2. HW and SW deployment using the same models
3. Multi-platforms
4. Public and private clouds
5. Simple to execute
---
<figure>
  <img src="./images/wss%20architecture.png"
       height="550px">
</figure>
---
<figure>
  <img src="./images/wss%20vision.png"
       width="100%">
</figure>
<br>

* **Battery included <i class="fa fa-battery"></i>**
* Reduce _lost in translation_
* Open source &rarr; technology transparency
* Build a vendor/user community
* Efficient deployment
---
<div align="right">
**Unified** solution design
</div>

<figure>
  <img src="./images/wss%20architecture%20components%201.png"
       height="100%">
</figure>
---
<div align="right">
**Unified** HW & SW configuration
</div>
<br>
<figure>
  <img src="./images/wss%20architecture%20components%202.png"
       height="500px">
</figure>
---
<div align="right">
**Unified** multi-layer deployment
</div>
<figure>
  <img src="./images/wss%20architecture%20components%203.png"
       height="550px">
</figure>
---
<section data-background="./images/wss%20architecture%20components.png">
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
<div align="left" 
     class="my-multicol-2">
  
 <span class="myhighlight">Juju's mission</span> is to provide a
 modeling language for users that abstracts the specifics of operating
 complex big software topologies.
</div>

<img src="https://i.ytimg.com/vi/tsou9S6NoDg/maxresdefault.jpg"
     height="200px">
---
<div align="left">
Charms are in **store**
</div>
<iframe src="https://jujucharms.com/store"
        height="550px" width="100%"></iframe>
---
<div align="left">
Charms are **PYTHON code**
</div>

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
<iframe src="https://jujucharms.com/new/"
        height="550px" width="100%"></iframe>
---
<div align="left">
Example: a deployed Canonical **Openstack**
</div>

<img src="https://insights.ubuntu.com/wp-content/uploads/7790/jjuju.png">

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
  <img src="./images/lcv.png" height="500px">
  <i class="fa fa-external-link"></i>
</a>


Note:
1. page 29: server 3650
---
<div align="left">
  Replace with **charms models <i class="fa fa-battery"></i>**
</div>
<br>

<section>
  <div style="float:right; width:33%;margin-top:20%;">
    <ul>
      <li>PDUs</li>
      <li>Switches</li>
      <li>Servers</li>
      <li>Storages</li>
      <li>...</li>
      <i class="fa fa-angle-double-down"></i>
    </ul>
  </div>
  <iframe src="https://www3.lenovo.com/us/en/data-center/servers/racks/System-x3650-M5/p/77XS7HV7V64"
        height="550px" width="67%"
        style="float:right;"></iframe>
</section>

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
  <iframe src="http://www.lenovofiles.com/3dtours/products/index.html"
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
<img src="./images/hw%20example.png" height="450px">
---
<iframe src="https://192.168.122.238/gui/"
        height="550px" width="100%"></iframe>
---
# Thank you
---
