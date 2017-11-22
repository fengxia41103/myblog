<!-- Section: project details  -->

<section data-background="https://drscdn.500px.org/photo/138747795/q%3D80_m%3D1500_k%3D1/v2?webp=true&sig=20cc685f194e95851ba5ceb3181ca0395d511c07948dd15d884235eb477dcbc6" class="mywhite">
  <div align="left" class="col s6">
    Vision of the
    <h2 class="mywhite">
      Workload Solution Store
    </h2>
  </div>
</section>
---
<h6>WSS Objective</h6>

1. Unified Hardware Modeling (**UHM** project)
2. HW and SW deployment using the same technology stack
3. Multi-platforms
4. Public and private clouds
5. Simple to execute
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
<h6>WSS Stack</h6>
<div class="row">
  <div class="col s7">
    <img data-src="images/wss%20simplified%20function%20stack.png"
         class="responsive-img materialboxed no-shadow">
  </div>
  <div class="col s5">
    <dl>
      <dt>Baremetal (server)</dt>
      <dd>
        Server has significant share of
        software component (firmware)
        and software capability (configuration)
        built-in, so view it
        as a software-driven entity and manage it as such. 
      </dd>
      <dt>OS, platform, containers</dt>
      <dd>
        Virtualization and containerization
        has increasingly blurred the underline
        foundation that an operating system is built upon.
        At the mean time, popularity of
        management interface used coordinate
        these large-scaled resources, eg. Kubertenes,
        Openstack, become the corner stone of a deployment stack.
      </dd>
      <dt>Application</dt>
      <dd>
        No single architecture and deployment strategy will
        be suitable for all applications customer is to use.
        Micro-service based application is a natural fit for K83,
        whereas motholic legacy can be helped by elastic computing
        of a cloud.
      </dd>
    </dl>
  </div>
</div>
---
<h6>WSS Strategy</h6>

<div class="row">
  <div align="left"
       class="col s7">
    <img data-src="images/wss%20strategy.png"
         class="no-shadow">
  </div>
  <div class="col s5">
    <dl>
      <dt>Blueprints</dt>
      <dd>
        <ol>
          <li>
            **hardeware workload**: configure hardware within a
              hyper-converge rack to establish base line environment
              such as VLAN, boot sequence.
          </li>
          <li>
            **platform workload**: install OS, agent, and
            application. Configure system and application to form
            software-defined platform such as Openstack.
          </li>
          <li>
            **user application workload**: run on top of OS or Openstack
            type of software-defined platforms.
          </li>
        </ol>
        
      </dd>

      <dt>Orchestration</dt>
      <dd>
        <ol>
          <li>
            **Description language**: written in plain text that
              describes state, event, component, relation, parameters
              for installation and configuration.
          </li>
          <li>
            **Orchestration runtime**: binary that parse blueprint,
              responds to state change and event, and execute built-in
              function and custom scripts.
          </li>
        </ol>
      </dd>

      <dt>Platform</dt>
      <dd>
        Host environment that supports workload requirements and
        scales dynamically.
      </dd>
    </dl>
  </div>
</div>
---
<h6>WSS execution</h6>
    <img data-src="images/wss%20orchestration.png"
         class="no-shadow">
---
<h6>WSS analysis framework</h6>

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
<h6>WSS Services to support the **six cores**</h6>

  <img data-src="images/wss%20simplified%20phase.png"
       style="box-shadow:none;">

Note:

1. Lenovo, client, 3rd party can create their own models
2. Configurations service to drive **software-defined** objective
---

<h6>WSS services (**1**/3)</h6>
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
    
      <li>**Architect** can design and determine constraints of a solution model
        including both HW and SW components.</li>
    
      <li>Published models will be available in **solution store**
        that can be purchased and **configured** by customer.</li>
    </ol>
  </div>
</div>
---
<h6>WSS services (**2**/3)</h6>
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
<h6>WSS services (**3**/3)</h6>
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
---
<section data-background="images/wss%20architecture%20components.png">
  <div align="left"
       style="margin-bottom:50%;">
    <h4 class="myhighlight">
      <i class="fa fa-key"></i>
      WSS services
    </h4>
  </div>
</section>
---
<h6>WSS Project</h6>
<div class="row">
  <div class="col s6">
<ol>
  <li>Vision</li>
  <li>**Function architecture**</li>
  <li>Technology stack</li>
  <li>Deployment</li>
  <li>Build</li>
  <li>Packaging</li>
  <li>Dev</li>
  <li>Testing</li>
  <li>Deliverables</li>
  <li>Roadmap & milestones</li>
  <li>Risks</li>
  <li>Reviews</li>
</ol>
  </div>
  <div align="left"
       class="col s6">
    Function architecture is to describe capabilities the system will
      support (a common drive of it is a MRD, eg. The system should...)
      Functions are grouped by their purpose and use (not by
      their implementation). They focus on the **to-do**, but left
      blank of inputs and outputs of each action.
    <p>
      Level 1 provides a high level view of the system's capability
      which often becomes natural division of sub-systems, components,
      and/or services. Level 1-N is a further break-down of each block
      into finer elements. These elements can then be prioritized
      based on resource and schedule.
    </p>
  </div>
</div>
---
<h6>WSS Function Architecture: **level 1**</h6>
<div class="row">
  <div class="col s12">
    <img data-src="images/wss%20func%20architect%201.png"
         class="no-shadow">
  </div>
</div>
---
<h6>WSS Function Architecture: **level 2**</h6>
<div class="row">
  <div class="col s12">
    <img data-src="images/wss%20func%20architect%202.png"
         class="no-shadow">
  </div>
</div>
---
<h6>Project</h6>
<div class="row">
  <div class="col s6">
<ol>
  <li>Vision</li>
  <li>Function architecture</li>
  <li>**Technology stack**</li>
  <li>Deployment</li>
  <li>Build</li>
  <li>Packaging</li>
  <li>Dev</li>
  <li>Testing</li>
  <li>Deliverables</li>
  <li>Roadmap & milestones</li>
  <li>Risks</li>
  <li>Reviews</li>
</ol>
  </div>
  <div align="left"
       class="col s6">
    Technology stack describes key technology components, eg.
    framework, language, environment, and so on, that will be used
    to construct the system so to provide the functions described in ealier
    section (Function Architecture).

    <p>
      Choice of core technology dictates decisions in
      system deployment, construction of
      development sandbox, product packaging and distribution.
    </p>
  </div>
</div>
---
<h6>WSS technology stack</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/wss%20technology%20stack.png"
         class="no-shadow">
  </div>
  <div align="left"
       class="col s3">
    <ol>
      <li>
        **orange** layers are essential for WSS to work; **gray**
          layers are optional.
      </li>
      <li>
        Charm is the workload model syntax (hook, state, relation,
        layer); Juju is the model execution engine (bundle,
        constraint, `to`).
      </li>
      <li>
        Implement integration point to support execution of
        Ansible playbooks. Playbooks can be used **independently**
        from charm.
      </li>
    </ol>
  </div>
</div>
---
<h6>Project</h6>
<div class="row">
  <div class="col s6">
<ol>
  <li>Vision</li>
  <li>Function architecture</li>
  <li>Technology stack</li>
  <li>**Deployment**</li>
  <li>Build</li>
  <li>Packaging</li>
  <li>Dev</li>
  <li>Testing</li>
  <li>Deliverables</li>
  <li>Roadmap & milestones</li>
  <li>Risks</li>
  <li>Reviews</li>
</ol>
  </div>
  <div align="left"
       class="col s6">
    Deployment architecture illustrates setup and connection of
    components such as execution environment, network location, and
    software version. There can be at least three flavors of a
    deployment: dev, production, and testing.

    <p>
      `Testing` is kept separate because it is often in midway between
      a full-blown production setup and a deverloper's sandbox. This
      is especially true for a deployment that calls for hardware and
      networking whose availability is limited, and for integration of
      third-party resources.
    </p>
  </div>
</div>
---
<h6>WSS deployment: by **single VM**</h6>
<div class="row">
  <div class="col s8">
    <img data-src="images/wss%20technology%20stack%20devbox.png"
         class="no-shadow">
  </div>
  <div align="left"
       class="col s4">
    <ol>
      <li>
        Suitable for dev sandbox.
      </li>
      <li>Host environment
        is based on <a href="https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img">Ubuntu 16.04 AMD64 cloud image</a>.
      </li>
      <li>
        At least two LXC containers are required &mdash; one as Juju
        controller (aka. machine 0 via `juju bootstrap localhost
        [controller name]`), and one for charm execution.
      </li>
      <li>
        Helper libs are optional &rarr; charms and bundle can be used
        as-is without presence of a helper.
      </li>
      <li>
        Charms can be pre-built package ready for use instead from
        being built from source.
      </li>
    </ol>
  </div>
</div>
---
<h6>WSS deployment: by **containers**</h6>
    <img data-src="images/wss%20technology%20stack%20prod.png"
         class="no-shadow">
---
<h6>Project</h6>
<div class="row">
  <div class="col s6">
<ol>
  <li>Vision</li>
  <li>Function architecture</li>
  <li>Technology stack</li>
  <li>Deployment</li>
  <li>**Build**</li>
  <li>Packaging</li>
  <li>Dev</li>
  <li>Testing</li>
  <li>Deliverables</li>
  <li>Roadmap & milestones</li>
  <li>Risks</li>
  <li>Reviews</li>
</ol>
  </div>
  <div align="left"
       class="col s6">
    Build architecture illustrates a full process to construct a testable
    product from source/base components.

    <p>
      There will be two flavors of build process: manual and continuous.
    </p>
  </div>
</div>
