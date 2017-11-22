<!-- Section 2: key technology  -->
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
    <img data-src="images/juju%20model.png"
         style="box-shadow:none">
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
<h6>Juju resource model: **LXD model**</h6>

<div class="row">
  <div class="col s9">
    <img data-src="images/juju%20lxd%20deployment%20setup.png"
         style="box-shadow:none">
  </div>
  <div align="left"
       class="col s3">
    <p>Resource is created **on demand**.</p>
    <ol>
      <li>All run within a single VM.</li>
      <li>Minimal 2 nodes to run a workload &mdash; managment(**M0**) + ...</li>
      <li>CentOS support is sketchy (<a href="https://github.com/lxc/lxd/issues/2984">1</a>,
        <a href="https://github.com/aleph-zero/lxd-centos-7#running-a-container">2</a>).
      </li>
      <li>Unclear yet how constraints are enforced?</li>
    </ol>
  </div>
</div>

Note:

is an ideal that resource can be created on the fly, which is observed
in juju creating LXD container when deploying workload, eg. openstack
base. In the end, we want the entire system appear to operator to have
this capability by hiding complexity within the system.

---
<h6>Juju resource model: **MaaS** model</h6>

<div class="row">
  <div class="col s12">
    <img data-src="images/juju%20maas%20deployment%20setup.png"
         style="box-shadow:none">
  </div>
  <div align="left" class="col s12">
    <p>Resources are **pooled** and selected by constraints.</p>
    <ol>
      <li>MaaS must be the **DHCP server** on provision network.</li>
      <li>Rely on **PXE**.</li>
      <li>Support CentOS.</li>
    </ol>
  </div>
</div>
---
<h6>Charms</h6>

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
<h6>Charms **store** & deployment</h6>

<iframe data-src="https://jujucharms.com/q/openstack"
        height="550px" width="100%"></iframe>
<div class="divider"></div>

**4** machines (VM & containers), **16** services, **1** click
---
<h6>Charm key concepts</h6>

| Concepts  | used for                    |
|-----------|-----------------------------|
| layer     | model inheritance           |
| hooks     | a hardcoded set of handlers |
| states    | user defined flags          |
| relations | data communication          |
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
<h6>Charm **hooks**</h6>

<div class="row">
  <div class="col s12">
    <img data-src="images/charm%20hooks.png"
         style="box-shadow:none">
  </div>
  <div class="col s12">
    <ol>
      <li>Hook sequences are
        **hard-coded** in "juju/worker/uniter/operation/runhook.go".</li>
      <li>Though being replaced by states, it is still
      the **engine**.</li>
    </ol>
  </div>
</div>
---
<h6>charm **states**</h6>

<div class="row">
  <div class="col s8">
    <img data-src="images/charm%20chain%20states.png"
         style="box-shadow:none">
  </div>
  <div class="col s4">
    <ol>
      <li>@set_state() to transit from one state to another.</li>
      <li>States should be viewed as **flags** meaning set_state() or
        remove_state() does not take affect immediately &rarr; code of
        a state **can be executed more than once**.</li>
      <li>States can be split among layers, but not across different charms
        or different units of the same charm.</li>
      <li>Names from all included layers have the same namespace.</li>
    </ol>
  </div>
</div>
---
<h6>Charm **interfaces**</h6>

<div class="row">
  <div class="col s12">
    <img data-src="images/charm%20relation%20and%20interface.png"
         style="box-shadow:none">
  </div>
  <div align="left"
       class="col s12">
    One side "provide", the other "require", so that a provided interface
    can be **reused** by multiple requirers.
  </div>
</div>
---
<h6>charm **execution**</h6>
<img data-src="images/charm%20execution.png"
     style="box-shadow:none;">

---
<h6>Example: **components** of a built charm</h6>

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
    the charm scripts.
  </dd>
</dl>
---
<h6>Charm **orchestration model**</h6>
<div class="row">
  <div class="col s3">
    <ol>
      <li>Base unit is a **service**.</li>
      <li>Service can have more than 1 unit to achieve HA.</li>
      <li>Deployment can be on **BM, VM, and LXD** container.</li>
      <li>Relation parity</li>
    </ol>
  </div>
  <div class="col s9">
    <img data-src="images/juju%20control%20modeling.png"
    style="box-shadow:none;">
  </div>
</div>
---
<h6>Charm **bundle**</h6>

<div class="row">
  <div class="col s7">
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
  <div class="col s5">
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
