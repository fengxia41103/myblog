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
2. Charm store
3. Key concepts
  1. layer
  2. hook
  3. state
  4. relation
  5. script execution
  6. bundle
4. Charm deployment

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

<h6>charm intro: what's in charm code</h6>

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
<h6>Charms **store** & deployment</h6>

<iframe data-src="https://jujucharms.com/q/openstack"
        height="550px" width="100%"></iframe>
<div class="divider"></div>

**4** machines (VM & containers), **16** services, **1** click
---
<h6>Charm: **key concepts**</h6>

| Concepts  | used for                    |
|-----------|-----------------------------|
| layer     | model inheritance           |
| hooks     | a hardcoded set of handlers |
| states    | user defined flags          |
| relations | data communication          |
| bundle    | deployment batch mode       |

---
<h6>Charm key concepts: **layers**</h6>
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
<h6>Charm key concepts: **hooks**</h6>

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
<h6>charm key concepts: **states**</h6>

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
<h6>Charm key concepts: **interfaces**</h6>

<div class="row">
  <div class="col s12">
    <img data-src="images/charm%20relation%20and%20interface.png"
         style="box-shadow:none">
  </div>
  <div align="left"
       class="col s12">
    One side "provide", the other "require", so that a provided
    interface can be **reused** by multiple requirers. Check out the
    new <a href="https://jujucharms.com/docs/devel/models-cmr">cross
    model relation</a>.
  </div>
</div>
---
<h6>charm key concepts: **script execution**</h6>
<img data-src="images/charm%20execution.png"
     style="box-shadow:none;">

---
<h6>Charm key concepts: **bundle**</h6>

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
---
<h6>Charm deployment</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/juju%20control%20modeling.png"
    style="box-shadow:none;">
  </div>
  <div class="col s3">
    <ol>
      <li>A **service** == a SW application == a charm.</li>
      <li>A unit == a running instance of a service.</li>
      <li>Each unit has a `sqlite` to save states.</li>
      <li>
        A service can have > 1 units (HA). Their `sqlite` are not
        shared.
      </li>
      <li>A machine can host > 1 services/units.</li>
      <li>Charm code is copied to a fixed directory
      on its runtime machine
      (`/var/lib/juju/agents/unit-[app name]-[unit #]/`).</li>
    </ol>
  </div>
</div>
