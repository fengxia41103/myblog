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
<h6 class="menu-title">Table of contents</h6>

1. Objectvie & Vision
3. Strategy
  1. view of a full stack
  2. model of a full stack
  3. orchestration of a full stack
    1. simplified version
    2. multi-layer version
3. Analysis & design
  1. process framework
  2. core services
  3. data model
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
3. Project management
  1. deliverables
  2. roadmap & milestones
  3. risks
4. Reviews & reports

---
<h6>WSS: **Objective**</h6>

1. HW (UHM) and SW deployment using the same technology stack
2. Multi-platforms
3. Public and private clouds
4. Simple to execute

---
<h6>WSS: **vision**</h6>


* **Battery included <i class="fa fa-battery"></i>**
* Reduce _lost in translation_
* Open source &rarr; technology transparency
* Build a vendor/user community
* Efficient deployment

<img data-src="images/wss%20vision.png"
     class="responsive-img materialboxed"
     style="box-shadow:none;">
---
<h6>WSS: **strategy**</h6>

1. view of a full stack
2. model of a full stack
3. orchestration of a full stack
  1. simplified version
  2. multi-layer version

---
<h6>WSS: **strategy**: **view of a full stack**</h6>
<div class="row">
  <div class="col s7">
    <img data-src="images/wss%20simplified%20function%20stack.png"
         class="responsive-img materialboxed no-shadow">
  </div>
  <div class="col s5">
    From bottom up:
    <br>
    
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
<h6>WSS: **Strategy**: **abstract of a full stack**</h6>

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
<h6>WSS: **strategy**: **orchestration of a full stack (simplified)**</h6>
    <img data-src="images/wss%20orchestration.png"
         class="no-shadow">
---
<h6>WSS: **strategy**: **orchestration of a full stack (multi-layer)**</h6>

> 2. Multi-layer pattern is a stack consisting of **nested platforms**
>    between user application and baremetal servers.
> 1. Multi-layer orchestration is a reality, not an outlier.

For example:

1. Deploy ESXi hypervisor, eg. VMWARE, onto Lenovo M3650 servers,
2. Then, float RHEL based VMs on ESXi,
3. Then, deploy an Openstack control plane onto these VMs,
4. Then, create Ubuntu 16.04 VMs (eg. kvm) managed by Openstack,
5. Then, deploy Canonical Kubertenes charms to these VMs ("machines""),
6. Then, deploy Wordpress into one Docker, two Postgresql as master-slave
into two Dockers, and Nginx webserver into another &larr; all managed by K8s.

---
<h6>WSS: **strategy**: **multi-layer orchestration patterns**</h6>

If we take:

  - **A** for application workload
  - **P** for platform workd, and
  - **B** for baremetal

We can summarize that regardless how complex a nested stack
can be, there are only four stack patterns to implement:

<img data-src="images/wss%20orchestration%20multi%20layer%20pattern.png"
     class="no-shadow">
---
<h6>WSS: **strategy**: **multi-layer (super) orchestration**</h6>

<img data-src="images/wss%20orchestration%20multi%20layer.png"
     class="no-shadow">


Marking baremetal server as `layer 0`, one can deploy
`A0` (eg. hypervisor or UHM), which in turn
becomes the platform `P1` for `layer 1`.


Continue this pattern until application `A` is deployed, thus,
forming a multi-layer deployment chain whereas
an application (**A**) of a lower layer is the platform (**P**) for the
next upper layer (as illustrated in same color per each **A-P** pair).
---
<h6>WSS: **strategy**: **multi-layer reference chain**</h6>

<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/wss%20orchestration%20multi%20layer%20reference.png"
         class="no-shadow">
  </div>
  <div class="col l6 m6 s12">
    Now taking a multi-layer deployment chain, a common
    user story asks:
    <dl>
      <dt>AS A</dt>
      <dd>operator</dd>
      
      <dt>I WANT</dt>
      <dd>to know which application will be affected if I need to
        shutdown this physical server
      </dd>

      <dt>SO THAT</dt>
      <dd>
        I can formulate a strategy to handle interruptioin to my user
        who uses these applications.
      </dd>
    </dl>

    <p>
    If each platform (**P**) maintains a reference/handle to the
    application (**A**) that was deployed on top it, we shall be able
    to traverse the reference chain from one end to the other.
    </p>
  </div>
</div>
---
<h6>WSS: **strategy**: **multi-layer reference chain in Juju**</h6>

<img data-src="images/wss%20orchestration%20multi%20layer%20reference%20in%20juju.png"
     class="no-shadow"
     height="450px">
<br>

If using `juju` as layer orchestrator, its `machine-0` holds a
reference to the applications deployed (and managed) by it. Together
with HW `uuid` as hardware reference (managed by `LXCA`),
one shall be able to identify
which **A** and **P** were deployed on a server.

Note, however, that workload can be shifted by a platform software, eg.
dynamic migration of containers by k8s. Therefore, it is up to the API of such platform to support query of workload reference at runtime.
---
<h6>WSS analysis & design</h6>

1. process framework
2. core services
  1. model designer
  2. solution Store
  3. configuration service
  4. orchestration service
3. data model
---    
<h6>WSS: **analysis & design**: **process framework**</h6>

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
<h6>WSS: **analysis & design**: **services to support the six cores**</h6>

  <img data-src="images/wss%20simplified%20phase.png"
       style="box-shadow:none;">

Note:

1. Lenovo, client, 3rd party can create their own models
2. Configurations service to drive **software-defined** objective
---
<h6>WSS: **analysis & design**: **services (1/3)**</h6>
<div class="row">
  <div class="col l7 m7 s12">
    <img data-src="images/wss%20architecture%20components%201.png"
         style="box-shadow:none;">
  </div>
  <div align="left"
       class="col l5 m5 s12">
    <dl>
      <dt>Model designer</dt>
      is a set of tools and scripts that facilitate conversion existing
      HW and SW artifacts, eg. digital rack, HW catalog, reference architecture,
      to charm-based models.

      <p>
        There is no magic here. This is a human process because it requires
        analysis of **non-structured** data.
        Common process is analyze &rarr; create abstract model &rarr; create charm.
      </p>

      </dd>

      <dt>Solution store</dt>
      is the <a href="https://jujucharms.com/store">Juju charm store</a>
      or a Lenovo version of it. The idea is to be app store
      that are specifict to charm models
      developed by Lenovo and Lenov partners.

      <p>
        User can order either solution (pre-defined group of
        charm models, eg. ThinkAgile) or individual
        available model (HW & SW), and can configure
        their orders using store GUI. The output
        is saved into a **order manifest** format that can be used as BOM.
      </p>
      <dd>
      </dd>
    </dl>
  </div>
</div>
---
<h6>WSS: **analysis & design**: **services (2/3)**</h6>
<div class="row">
  <div class="col l7 m7 s12">
    <img data-src="images/wss%20architecture%20components%202.png"
         style="box-shadow:none;">
    <dl>
      <dt>MFG</dt>
      <dd>
        <ol>
          <li>**Order manifest** is the BOM.</li>
          <li>MFG does picking, assembling and packaging.</li>
          <li>MFG logs BOM fullfillment details into **HW manifest**, eg. serial #. &rarr; order manifest is the abstract, and HW manifest is an instance of that abstract.</li>
        </ol>
      </dd>
    </dl>
  </div>
  <div class="col l5 m5 s12">
    <dl>
      <dt>Configuration serversice</dt>
      <dd>
        <ol>
          <li>
            Configuration options are **pre-defined** by model designer, eg.
            setting IP address for a server, or the number of 2.5" disk bay
            to install.
          </li>
          <li>
            Options are grouped by its **applicable services**, eg. HW configs
            are directly applicable to MFG, whereas SW configs are meant for orchestration service &rarr; different user role shall have access to his set of
            configs ONLY.

            <p>
            For example, server config has the option to pick firmware
            version, but this is not accessible by user role of a
            sales order. It is, however, accessible by service, MFG,
            and orchestrator.
            </p>
          </li>
          <li>
            It generates two artifacts &rarr; orchestrator instructions
            (manifest/bundle) & validation checklist (compliance).
          </li>
        </ol>
      </dd>
    </dl>
  </div>
</div>
---
<h6>WSS: **analysis & design**: **services (3/3)**</h6>
<div class="row">
  <div class="col l9 m9 s12">
    <img data-src="images/wss%20architecture%20components%203.png"
       style="box-shadow:none;">
  </div>
  <div class="col l3 m3 s12">
    <dl>
      <dt>Orchestration service</dt>
      <dd>
        <ol>
          <li>
            Orchestration service is the core of WSS architecture. All
            configurations and models are **made to orchestrate**.
          </li>

          <li>
            Handling single layer orchestration is
            easy; handling multi-layer version is hard.
          </li> 
          <li>Technology for each layer can be different.</li>
        </ol>    
      </dd>
    </dl>
</div>
---
<h6>WSS: **analysis & design**: **services (3/3) cont.**</h6>

<div class="row">
  <div class="col l7 m7 s12">
    <img data-src="images/uhm%20orchestrator.png"
         style="box-shadow:none;">
  </div>
  <div class="col l5 m5 s12">
    <dl>
      <dt>Single layer orchestrator</dt>
      (for example: UHM orchestrator)
      <dd>
        <ol>
          <li>
            **orchestor**(deployment): Juju or its wrapper
            (if using charm as model). 
          </li>
          <li>
            **baremetal manager**: LXCA
          </li>
          <li>
            **monitor**: is responsible to query orchestrator (or its
            execution env) for its runtime status, eg. `$ juju status
            --format json`
          </li>
          <li>
            **validator/compliance**:
            to match a model's execution vs. its design, eg.
            how many M3650 servers are configured with firmware
            version 4.1.0 comparing to the numbers on customer's order?
          </li>
        </ol>    
      </dd>
    </dl>
</div>
---
<section data-background="images/wss%20architecture%20components.png">
  <div align="left"
       style="margin-bottom:50%;">
    <h4 class="myhighlight">
      <i class="fa fa-key"></i>
      WSS design of services overview
    </h4>
  </div>
</section>
---
<h6>WSS: **analysis & design**: **data model**</h6>

<img data-src="images/wss%20data%20model.png"
     class="no-shadow">

---
<h6>WSS Implementation</h6>

  1. function architecture
  2. technology stack
  4. build
  5. packaging
  3. deployment
  6. dev
  7. testing
  8. distribution
  9. upgrade
---
<h6>WSS implementation: A word on TOC</h6>

This TOC represents a framework to view and categorize tasks that are in reality
inter-linked and inter-dependent. But there must be a "starting point".

---
<h6>WSS implementation: **Function architecture**</h6>


Function architecture is to describe capabilities the system will
support (a common drive of it is a MRD, eg. The system
should...).

Functions are grouped by their purpose and use (not
by their implementation). They focus on the **to-do**, but left
blank of inputs and outputs of each action.

Level 1 provides a high level view of the system's capability
which often becomes natural division of sub-systems, components,
and/or services. Level 1-N is a further break-down of each block
into finer elements. These elements can then be prioritized
based on resource and schedule.
---
<h6>WSS implementation: **Function Architecture**: **level 1**</h6>
<div class="row">
  <div class="col s12">
    <img data-src="images/wss%20func%20architect%201.png"
         class="no-shadow">
  </div>
</div>
---
<h6>WSS implementation: **Function Architecture**: **level 2**</h6>
<div class="row">
  <div class="col s12">
    <img data-src="images/wss%20func%20architect%202.png"
         class="no-shadow">
  </div>
</div>
---
<h6>wss implementation: **Technology stack**</h6>


This section describes key technology components, eg.
framework, language, environment, and so on, that will be used
to construct the system so to provide the functions described in ealier
section (Function Architecture).

Choice of core technology dictates decisions in
system deployment, construction of
development sandbox, product packaging and distribution.
</p>
---
<h6>WSS implementation: **technology stack**</h6>
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
<h6>wss implementation: **Build**</h6>

Two ways to build charm:

1. using `charm build` to build a single
  charm and use its `dist` code as is
2. using `builder lib`
    to build in batch mode and replace dist contents post build.
---
<h6>WSS implementation: **build**: **a single charm**</h6>

1. Use `charm build`
1. code: [hpcgitlab.labs.lenovo.com/WSS/wss.git][1]
2. `git clone --recursive` &larr; to fetch submodules
  1. `layer-basic`
  2. `layer-ansible`
3. install `charm-tools` from repo
3. setup environment variables:
  1. `LAYER_PATH`: absolute path to charm code
  2. `INTERFACE_PATH`: absolute path to charm interface code
  3. `JUJU_REPOSITORY`: absolute path to charm `dist` folder
4. chang to a charm folder and run `charm build`
  1. default build uses **Python 3.0** packages (`--series xenial`)
  2. for Python 2.7, use `--series trusty`
5. built dist  are in  in `$JUJU_RESPOSITORY/[series]/[charm name]`


[1]: http://hpcgitlab.labs.lenovo.com/WSS/wss.git
---
<h6>WSS implementation: **build**: **`builder` lib**</h6>

<pre class="brush:plain">
usage: build.py [-h] [--series SERIES] [--keep KEEP] [--no-wheelhouse]
                [--no-playbooks] path/to/charms
</pre>

1. `builder lib` is developed as a wrapper over `charm build`
2. it can build multiple charms in **batch** mode
3. it can take post-build actions on `/dist` by:
  1. overriding `charms.helper` &larr; for Python 2.7 compatibility
  2. overriding `layer-basic` files  &larr; for Python 2.7 compatibility
  3. removing `/dist/.../wheelhouse` to minimize charm dist file size (about 100M less) &larr; when using an image which has dependencies pre-installed
  4. for separately managed/developed files, eg. playbooks, adding them
     to each charm's dist
---
<h6>wss implementation: **Packaging**</h6>

There are three types of packaging:

1. **of a single charm**: contains a single charm for distribution
  1. default `charm build` output

2. **of batch charms**: contains multiple charms
  1. `build.py` creates `.tar.gz`

3. **of a charm execution env**: 

  1. `qcow2` VM image usable by KVM
  2. `vdi` VM image used by Virtualbox
  2. Docker container

---
<h6>wss implementation: **packaging**: **A single charm**</h6>

Example of a `charm build` result:

<pre class="brush:plain">
(dev) fengxia@ubuntu:~/workspace/wss/dist/trusty/solution$ ls -lh
total 72K
-rw-rw-r-- 1 fengxia fengxia  18K Nov 26 10:00 ansible.cfg
drwxrwxr-x 2 fengxia fengxia 4.0K Nov 26 09:58 bin
-rw-rw-r-- 1 fengxia fengxia  939 Nov 26 09:58 config.yaml
drwxrwxr-x 3 fengxia fengxia 4.0K Nov 26 10:00 hooks
-rw-rw-r-- 1 fengxia fengxia 7.1K Nov 26 09:57 icon.svg
-rw-rw-r-- 1 fengxia fengxia  383 Nov 26 09:58 layer.yaml
drwxrwxr-x 3 fengxia fengxia 4.0K Nov 26 09:58 lib
-rw-rw-r-- 1 fengxia fengxia  239 Nov 26 09:58 metadata.yaml
drwxrwxr-x 6 fengxia fengxia 4.0K Nov 26 09:58 playbooks
drwxrwxr-x 2 fengxia fengxia 4.0K Nov 26 10:00 reactive
-rw-rw-r-- 1 fengxia fengxia 5.7K Nov 26 09:57 README.md
drwxrwxr-x 2 fengxia fengxia 4.0K Nov 26 10:00 wheelhouse
</pre>
---
<h6>wss implementation: **packaging**: **batch charms**</h6>

1. create a batch charm dist
2. naming convention: `%Y-%m-%d-%H-%M-%S-[random 10-char string].tar.gz`
2. using `builder.py --keep N` to save the last `N` builds
4. `builder.py` saves tar balls in `dist/archives`

Exmaple:

<pre class="brush:plain">
(dev) fengxia@ubuntu:~/workspace/wss/dist/archives$ ls -lh
total 62M
-rw-rw-r-- 1 fengxia fengxia 62M Nov 26 10:00 2017-11-26-10-00-29-eyd1c9jba5.tar.gz
</pre>
---
<h6>wss implementation: **packaging**: ** charm execution env as KVM**</h6>

Export KVM image:

1. Bootstrap KVM using [cloud-image][2] and [cloud-init][3] ([example `user-data`][4])
2. `virsh list --all` to view VM names
2. `virsh dumpxml [vm name] > myimage.xml`
3. save `myimage.xml` and the corresponding `.img` disk image files

[2]: https://cloud-images.ubuntu.com/xenial/
[3]: http://cloudinit.readthedocs.io/en/latest/
[4]: http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/uhm/vm/my-user-data

Example `myimage.xml` showing the location of disk files:
<pre class="brush:xml">
    <disk type='file' device='disk'>
      <driver name="qemu" type="qcow2"/>
-->   <source file="/home/fengxia/workspace/tmp/mydev.snap"/> 
      <target dev='vda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
    </disk>
</pre>
---
<h6>wss implementation: **packaging**: **charm execution env as Virtualbox**</h6>

1. Bootstrap a VM using Vagrant ([example `vagrantfile`][5])
2. `vboxmanage list vms` to view VM names
3. `vboxmanage export [vm name] -o [export name].ova`

Example: 
<pre class="brush:plain">
$ vboxmanage export [vm name] -o [export name].ova                                                                  
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
</pre>

[5]: http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/uhm/vm/Vagrantfile
[6]: https://www.virtualbox.org/manual/ch01.html#ovf

Reference: [1][6]

---
<h6>wss Implementation: **Packaging**: **charm execution env as Docker container**</h6>
TBD
---
<h6>wss implementation: **Packaging**: **VM conversions**</h6>
1. `raw` &rarr; `qcow2`:
  <pre class="brush:plain">
  $ qemu-img convert -f raw -O qcow2 image.img image.qcow2
  </pre>
2. `vmdk` &rarr; `img`:
  <pre class="brush:plain">
  $ qemu-img convert -f vmdk -O raw image.vmdk image.img
  </pre>
3. `vmdk` &rarr; `qcow2`:
  <pre class="brush:plain">
  $ qemu-img convert -f vmdk -O qcow2 image.vmdk image.qcow2
  </pre>
4. `vdi` &rarr; `raw`:
  <pre class="brush:plain">
  $ VBoxManage clonehd ~/VirtualBox\ VMs/image.vdi image.img --format raw
  </pre>

Reference: [1][7]

[7]: https://docs.openstack.org/image-guide/convert-images.html
---
<h6>wss implementation: **Deployment**</h6>

This section illustrates setup and connection of
components such as execution environment, network location, and
software version. There can be at least three flavors of a
deployment: **dev**, **production**, and **testing**.

`Testing` is kept separate because it is often in midway between
a full-blown production setup and a deverloper's sandbox. This
is especially true for a deployment that calls for hardware and
networking whose availability is limited, and for integration that
relies on external third-party resources.
---
<h6>WSS implementation: **deployment**: **Dev/prod in a single VM**</h6>
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
<h6>WSS implementation : **deployment**: **Prod in containers**</h6>
<img data-src="images/wss%20technology%20stack%20prod.png"
     class="no-shadow">
---
<h6>wss implementation: **Dev**</h6>

Your imagination is more imporant than rules...

---
<h6>wss implementation: **Dev**: **logistics**</h6>

1. Main: [http://hpcgitlab.labs.lenovo.com/WSS/wss/tree/master][8]
2. Use [git submodule][16] to track external repo
2. Create a `branch` for your work
3. Create a `merge request` (pull request) to merge your changes back to
   `master`
4. Issues are logged [here][9]
5. Use Python 2.7 [virtualenv][17] for your Python code &rarr; `$ pip install -r requirements.txt` ([requirements.txt][10])
  1. format **must** be in [pep8 style][14] (use [autopep8][15])
  2. **4 whitespaces** as tab
6. Use Juju 2.1+ for local testing (see next page for sandbox)
7. Good luck

[8]: http://hpcgitlab.labs.lenovo.com/WSS/wss/tree/master
[9]: http://hpcgitlab.labs.lenovo.com/WSS/wss/issues
[10]: http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/master/requirements.txt
[14]: https://www.python.org/dev/peps/pep-0008/
[15]: https://pypi.python.org/pypi/autopep8
[16]: https://git-scm.com/docs/git-submodule
[17]: https://virtualenv.pypa.io/en/stable/

---
<h6>wss implementation: **Dev**: **sandbox**</h6>

Use one of these standard Virtualbox or KVM as your sandbox:

1. Use [Vagrantfile][11] for Virtualbox: `$ vagrant up`
2. Use [my-user-data][12] for KVM: `$ python startmykvm.py mydev.xml` ([wiki][13])

[11]: http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/uhm/vm/Vagrantfile
[12]: http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/uhm/vm/my-user-data
[13]: http://cowork.us.lenovo.com/teams/openstack/SitePages/KVM%20using%20cloud-init%20and%20backing%20file.aspx

---
<h6>wss implementation: **testing**</h6>

Two levels of tests:

1. test of individual component
2. test as integration of > 1 components
---
<h6>wss implementation: **testing**: **single charm**</h6>

1. python unit test: TBD

---
<h6>wss implementation: **testing**: **CI/CD**</h6>
<div class="row">
  <div class="col l7 m7 s12">
    <img data-src="images/wss%20ci.png"
         class="no-shadow">
  </div>
  <div class="col l5 m5 s12">
    <ol>
      <li>
        source: <a href="http://hpcgitlab.labs.lenovo.com/WSS/buildbot">
        http://hpcgitlab.labs.lenovo.com/WSS/buildbot</a>
      </li>
      <li>
        <a href="https://buildbot.net/">Buildbot</a> instance:
        <a href="http://10.240.42.52:8010">http://10.240.42.52:8010</a>
      </li>
      <li>
        One master can drive multiple slaves/workers (one per
        sub/related project).
      </li>
      <li>
        Status is emailed to distribution list &
        IRC `#lenovo-lctc` (user nick `lctc-buildbot`)
      </li>
    </ol>

    <p>
      Adding a new project to CI takes a few steps
      (<a href="http://hpcgitlab.labs.lenovo.com/WSS/buildbot/blob/master/README.md">README.md</a>):
      <ol>
        <li>Create slave `configuration .py`.</li>
        <li>Add it to `build-master/master.cfg`.</li>
        <li>Restart build master: `$ buildbot restart build-master`.</li>
        <li>
          Login to buildbot admin web UI to confirm that slave has been
          added successfully.
        </li>
        <li>Force a build to test.</li>
      </ol>
    </p>

    <blockquote>
      Any manual step that you are finding yourself
      doing more than **enough times**, CI it!
    </blockquote>
  </div>
</div>
---
<h6>wss implementation: **testing**: **Builtbot example**</h6>

<img data-src="images/wss%20buildbot%20ci%20example.png"
     class="no-shadow">
---
<h6>wss implementation: **Distribution**</h6>
TBD
---
<h6>wss implementation: **Upgrade**</h6>
TBD
