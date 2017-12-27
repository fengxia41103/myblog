<h6>VX installer</h6>

1. Intro
  1. concept
  2. objective
  3. definition of done
3. Analysis & design
  1. process framework
  2. core services
  3. data model
3. Strategy
  1. model of a full stack
  2. orchestration of a full stack
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

---
<h6>VX intro: **concept**</h6>

> VMware vSAN provides enterprise-class software-defined storage  to back a hyper-converged infrastructure.   ThinkAgile VX series combines enterprise grade networking, server storage and VMware virtualization to deliver highly available storage solutions.  Software defined storage enables users to expand storage capacity on demand and automate storage polices based on workload.
>
> Each ThinkAgile node provides compute resources engineered for storage-heavy/high-performance workloads. The goal of  Lenovo vSAN installer is to **configure a set of these ThinkAgile nodes as a single storage cluster in vCenter**.
>
<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Create+a+VSAN+using+vCenter
</span>
---

<h6>VX intro: **objective**</h6>

VxInstaller is an application that will enable a user to:

1. Configure a vCenter instance
2. Assign ThinkAgile VX appliances to a DataCenter within that vCenter instance
3. Create software defined storage (vSAN) under a cluster within a vCenter datacenter

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Architecture
</footer>
---
<h6>VX intro: **definition of done**</h6>
<div class="row">
  <div class="col s9">
    <img data-src="http://www.storagereview.com/images/StorageReview-VMware-VSAN-Cluster.png"
         class="responsive-img materialboxed"/>
  </div>
  <div class="col s3">
    <p>
    A completely deployed solution consists of:
    </p>

    <ol>
      <li>vCenter</li>
      <li>ThinkAgile hosts assigned to a customer defined DataCenter</li>
      <li>ThinkAgile hosts connected to an ESXi Management Network</li>
      <li>ThinkAgile hosts connected to a ESXi vMotion Network</li>
      <li>ThinkAgile hosts connected to an ESXi vSAN Network</li>
      <li>Customer defined disk groups are assigned to a cluster within a cluster within the DataCenter</li>
    </ol>
  </div>
</div>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Architecture
</span>
---
<h6>VX analysis & design: **process framework**</h6>

Workflow of using VX installer consists of six steps:

1. User selects from a pre-defined list of `solution`.
2. User selects from a list of **compatible** hardware **discovered** by ??
3. User sets up configurations necessary to configure a `vCenter`.
4. User sets up configurations for a `vMotion`.
5. User sets up configurations for a `vSan`.
6. Send configurations to an orchestration service for actual deployment.

<p>
  Steps 1-5 are collecting **configuration** information, and
  an **orchestration service** is expected to handle all actions
  utilizing these configurations as input to
  implement instructions covered in <a
  href="http://confluence1.labs.lenovo.com:8090/display/TSM/ThinkAgile+VX+Configuration+Guide+1.1?preview=/4391864/4391865/ThinkAgile%20VX%20Configuration%20Guide%20v1.1.docx">ThinkAgile
  VX Configuration Guide 1.1</a>.
</p>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Workflow
</span>

---
<h6>VX analysis & design: **core services (1/3)**</h6>

<img data-src="images/vx%20simplified%20phase.png"
     class="no-shadow"/>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Workflow<br>
</span>

Note:

* `post` are for configuration validation, not for orchestration actions
---
<h6>VX analysis & design: **core services**</h6>

<div class="row">
  <div class="col s8">
    <img data-src="images/vx%20architecture%20components%201.png"
         class="no-shadow"/>
  </div>
  <div class="col s4">
    <dl>
      <dt>Model designer</dt>
      <dd>
        Offline service to design WSS-based data models based on
        inputs from <a
  href="http://confluence1.labs.lenovo.com:8090/display/TSM/ThinkAgile+VX+Configuration+Guide+1.1?preview=/4391864/4391865/ThinkAgile%20VX%20Configuration%20Guide%20v1.1.docx">ThinkAgile
        VX Configuration Guide 1.1</a>.
      </dd>

      <dt>Solution Store</dt>
      <dd>
        A way to order `ThinkAgile VX` solution.
      </dd>
    </dl>
  </div>
</div>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Architecture
  <br/>
  Ref: http://10.240.42.32/presentations/wss/index.html#/64
</span>

---
<h6>VX analysis & design: **core services (2/3)**</h6>
<div class="row">
  <div class="col s8">
    <img data-src="images/vx%20architecture%20components%202.png"
         class="no-shadow"/>
  </div>
  <div class="col s4">
<dl>
  <dt>Resource discovery service</dt>
  <dd>
    <p>
    Responsible for identifying components of the solution including:
    </p>

    <ol>
      <li>Existing vCenter instances</li>
      <li>ThinkAgile VX appliances that are candidates for inclusion in the solution</li>
      <li>Network resources  (DNS, DHCP, security?)</li>
    </ol>
  </dd>

  <dt>Configuration service</dt>
  <dd>
    <p>
    Responsible for generating the complete definition of the solution including:
    </p>

    <ol>
      <li>vCenter parameters</li>
      <li>vMotion settings</li>
      <li>vSAN DiskGroup definition</li>
    </ol>
  </dd>

  </div>
</div>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Architecture
  <br/>
  Ref: http://10.240.42.32/presentations/wss/index.html#/65
</span>

---
<h6>VX analysis & design: **core services (3/3)**</h6>

<div class="row">
  <div class="col s9">
    <img data-src="images/vx%20architecture%20components%203.png"
         class="no-shadow"/>
  </div>
  <div class="col s3">
    <dl>
      <dt>Resource management service</dt>
      <dd>
        Referring to `vcenter` API that orchestration service will send commands
        to in order to carry out setup steps in automation mode.
      </dd>

      <dt>VX orechestration service</dt>
      <dd>
        VX orchestration **differs from WSS** that there
        is no `validator` service to verify orchestration result.
        (See _WSS orchestration service_ for details on validator.)
      </dd>
    </dl>
  </div>
</div>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Architecture
  <br/>
  Ref: http://10.240.42.32/presentations/wss/index.html#/67
</span>

---
<h6>VX analysis & design: **core services overview**</h6>
<img data-src="images/vx%20architecture%20components.png"
class="no-shadow"/>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Architecture
  <br/>
  Ref: http://10.240.42.32/presentations/wss/index.html#/68
</span>

---
<h6>VX analysis & design: **data model**: **Solution, VCenter**</h6>

<div class="row">
  <div class="col s5">
    <a href="images/vx%201.png">
      <img data-src="images/vx%201.png"
           class="no-shadow"/>
    </a>
  </div>
  <div class="col s7">
    <dl>
      <dt>Solution</dt>
      <dd>
        A Lenovo definition of product. A solution can support multiple `vcenters`.
      </dd>

      <dt>VCenter</dt>
      <dd>
        Virtual grouping of `hosts` (see below)
      </dd>

      <dt>Host</dt>
      <dd>
      A virtual representation of compute resources on a physical
      server.  The virtual representation is managed by a hypervisor
      running ESX/ESXi.  (<a
      href="https://www.vmware.com/products/vcenter-server.htmlhttps://www.vmware.com/products/vcenter-server.html">1</a>)
      </dd>
    </dl>
  </div>
</div>

---
<h6>VX analysis & design: **data model**: **Datacenter, Cluster**</h6>

<div class="row">
  <div class="col s12">
    <a href="images/vx%202.png">
      <img data-src="images/vx%202.png"
           class="no-shadow"/>
    </a>
  </div>
  <div class="col s12">
    <p>
  In order to aggregrate/virtualize the resources from each host node,
  the host nodes need to be added to the same `DataCenter cluster`.  The
  `Datacenter` must exist and then the cluster can be created within the
  scope of that Datacenter.  The first node is added to the cluster
  and a unique cluster ID is assigned.  The remaining nodes are added
  to this cluster using the cluster ID as a key.
    </p>

    <dl>
      <dt>Datacenter</dt>
      <dd>
        The set of hosts, physical servers, storage networks and
        arrays, IP networks and management servers.

        <p>
          A `vcenter` can have N `datacenter`,
          and one datacenter can have N `clusters`.
        </p>
      </dd>

      <dt>Cluster</dt>
      <dd>
        An aggregrate of compute and memory resources for a group.

        <p>
          A cluster can have multiple N `hosts`.
        </p>
      </dd>
    </dl>
  </div>

</div>
---
<h6>VX analysis & design: **data model**: **Host**</h6>

<div class="row">
  <div class="col s9">
    <img src="images/vx%204.png"
         class="no-shadow"/>
  </div>

  <div class="col s3">
    <dl>
      <dt>Host</dt>
      <dd>
      A virtual representation of compute resources on a physical
      server.  The virtual representation is managed by a hypervisor
      running ESX/ESXi.  (<a
      href="https://www.vmware.com/products/vcenter-server.htmlhttps://www.vmware.com/products/vcenter-server.html">1</a>)
      </dd>
    </dl>

    <p>
    There are two types of resource accessible via
    the abstract of a `host` &mdash; disk resource,
    and network resource.
    </p>

    <p>
      VX installer concerns setting up disk resources that are distributed
      among multiple physical servers accessible via `vcenter` as a `vsan` storage.
      Network resources are mere vehicles to facilitate execution
      of setup instructions.
    </p>
  </div>
</div>
---
<h6>VX analysis & design: **Host & networks**</h6>

<div class="row">
  <div class="col l5 m5 s12">
    <img data-src="images/vx%20host%20network.png"
         class="no-shadow"/>
  </div>

  <div class="col l7 m7 s12">
    <p>
    Each ESXi node/host is connected to three networks &mdash; `management`, `vmotion`, and `vsan`:
    </p>
    <ul>
      <li>1 virtual switch</li>
      <ul>
        <li>
          2 external ports to the outside world (teaming, bonded across all nodes)
        </li>
        <li>4 internal ports:</li>
        <dl>
          <dt>management network</dt>
          <dd>
            One ESXi management network (assigned an internal port
            group): ESXi requires one IP address for the management
            network. This interface connects with ESXi management
            software like vCenter
          </dd>
          <dt>vMotion network</dt>
          <dd>
            One vMotion network (assigned an internal port group):
            Dedicated network for migrating virtual machines state
            between source and destination hosts. Source and
            destination hosts must be configured on the same
            network. (uses VMkernel network adapter)
          </dd>

          <dt>vSan network</dt>
          <dd>
            Two vSAN ports (assigned to the vSAN port group):
            The vSAN management network.  This network is configured
            to carry storage packets.
          </dd>
        </dl>
      </ul>
  </div>
</div>

<span class="reference">
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Create+a+VSAN+using+vCenter
</span>

---
<h6>VX analysis & design: **data model**: **Host & networks**</h6>

<img data-src="images/vx%203.png"
     class="no-shadow"/>
---
<h6>VX analysis & design: **data model**: **Host & vSan**</h6>

<div class="row">
  <div class="col s6">
    <img data-src="images/vx%206.png"
         class="no-shadow"/>
  </div>

  <div class="col s6">
    <p>
      `vSan` requirements:
    </p>

    <ol>
      <li>One SAS or SATA solid state disk on each host for cache</li>
      <li>
        At least one SAS or NL-SAS magnetic disk for virtual machine data storage
      </li>
      <li>
        One SAS or SATA host bus adapter (HBA) or a RAID controller in passthrough or RAID 0 mode
      </li>
      <li>
        Disable the storage controller cache
      </li>
      <li>32 GB of memory</li>
      <li>Minimum of 3 hosts</li>
      <li>Hosts must not participate in any other clusters.</li>
      <li>1Gbps network link for hybrid storage configurations</li>
      <li>10 Gbps network link for flash configurations</li>
      <li>VMKernel network adapter on each host for vSAN traffic</li>
      <li>Hosts must be connected on the same subnet</li>
      <li>Configure a port group on the virtual switch for vSAN</li>
      <li>vSAN network supports both IPv4 and IPv5</li>
      <li>vSAN License assigned to the cluster</li>
      <li>
        vSAN cannot consume external storage (SAN or NAS) connected to
        the cluster
        .</li>
    </ol>
  </div>
</div>

<span class="reference">
  Ref: https://kb.vmware.com/s/article/2106708<br>
  Ref: http://confluence1.labs.lenovo.com:8090/display/TSM/Create+a+VSAN+using+vCenter
</span>
---
<h6>VX analysis & design: **data model**: **Host & disks**</h6>

<img data-src="images/vx%205.png"
     class="no-shadow"/>

`host` is the central model that bridges physical server and its disk resources
to a `vsan` managed by a `vcenter`.
---

<h6>VX analysis & design: **data model overview**</h6>

<a href="images/vx.png">
  <img data-src="images/vx.png"
       class="no-shadow"/>
  <br/>
  <i class="fa fa-external-link"></i>
  click to enlarge
</a>
---
<h6>VX: **strategy**</h6>

1. WSS view of a VX stack
2. orchestration of a VX stack

---
<h6>VX strategy: **WSS view of a VX stack**</h6>
<div class="row">
  <div class="col l6 m6 s12">
    <img data-src="images/wss%20view%20of%20vx%20stack.png"
         class="no-shadow"/>
  </div>
  <div class="col l6 m6 s12">
    <dl>
      <dt>blueprints</dt>
      <dd>
        Two type of blueprints: HW and application.
        <ol>
          <li>
            **HW blueprints**:
            <ol>
              <li>
                VX assumes UEFI settings of a physical server has been
                setup accordingly &rarr; HW blueprints will be a **shell**
                as there is no actual HW-level setup required.
              </li>
              <li>
                Key modeling will be around virtual representation of
                a server &rarr; `vhost`, and its **logical** groupings
                such as `vsan`, `cluster`, `datacenter`, and
                `vcenter`.
              </li>
            </ol>
          </li>
          <li>
            **application**: ThinkAgile VX
          </li>
      </dd>

      <dt>orchestration</dt>
      <dd>juju</dd>

      <dt>platform</dt>
      <dd>
        Server via `ESXi VCenter Server API`.

        <p>
          However, we are not using a `vcenter provider` to
          orhcestrate. Instead, charm model will call Ansible, which
          in turn calls `vcenter REST api`.
        </p>
      </dd>
    </dl>
  </div>
</div>

<span class="reference">
  Ref: http://10.240.42.32/presentations/wss/#/54
</span>

---
<h6>VX strategy: **orchestration of a VX stack**</h6>

<div class="row">
  <div class="col l9 m9 s12">
    <img data-src="images/vx%20orchestration%20strategy.png"
         class="no-shadow"/>
  </div>

  <div class="col l3 m3 s12">
    <ol>
      <li>
        vx orchestration service will receive a JSON/YAML describing a **complete** setup of a `vcenter` and its subordinates.
      </li>
      <li>
        `vx configurator` will map this _description_ into a **single Juju bundle
        YAML file** in which config values are mapped charm's config YAML,
        and grouping are mapped to relations.
      </li>
      <li>
        A request to deploy is then **queued** (`task queue`) in a `pub-sub` pattern.
      </li>
      <li>
        `vx deployer` will remove a request from queue and call
        `python deploy.py [bundle file].yaml`
      </li>
      <li>
        Charm will be executed in LXD container on the same host where `vx deployer` instance is.
      </li>
    </ol>
  </div>
</div>

---
<h6>VX Implementation</h6>

1. function architecture
2. technology stack
4. build
3. deployment
5. packaging
6. dev
7. testing
8. distribution
9. upgrade

---

<h6>VX implementation: **function architecture**: **level 1**</h6>

<div class="row">
  <div class="col s9">
    <img data-src="images/vx%20func%20architect%201.png"
         class="no-shadow"/>
  </div>
  <div class="col s3">
    <p>
      Unused WSS services are grayed out:
    </p>

    <ol>
      <li>
        baremental management service: HW will be interfaced via
        `VCenter Server API`.
      </li>
      <li>
        validation service: `vx` is to orchestrate `vcenter`
        setup with no capability to verify its execution result (maybe
        via the same vcenter API?)
      </li>
      <li>
        workload management service: no need for multi-layer
        deployment and traversing.
      </li>
    </ol>
  </div>
</div>


<span class="reference">
  Ref: http://10.240.42.32/presentations/wss/#/73
</span>

---
<h6>VX implementation: **function architecture**: **level 2**</h6>
<img data-src="images/vx%20func%20architect%202.png"
     class="no-shadow"/>

Consider `ThinkAgile VX` as application because its outcome will not be used
for further workload deployment.

<span class="reference">
  Ref: http://10.240.42.32/presentations/wss/#/74
</span>
---

<h6>VX implementation: **function architecture**: **level 3**</h6>

<img data-src="images/vx%20func%20architect%203.png"
     class="no-shadow"/>

---
<h6>VX implementation: **technology stack**</h6>
<div class="row">
  <div class="col s9">
    <img data-src="images/vx%20technology%20stack.png"
         class="no-shadow">
  </div>
  <div align="left"
       class="col s3">
    VX technology stack is mostly
    covered by <a href="http://10.240.42.32/presentations/wss/#/76">
    WSS technology stack</a> in which unused components are _grayed out_.

    <p>
      New to VX:
    </p>
    <ol>
      <li>
        A _presentation layer_ in `AngularJS`.
      </li>
    </ol>
  </div>
</div>

<span class="reference">
  Ref: http://10.240.42.32/presentations/wss/index.html#/76
</span>
---
<h6>VX implementation: **technology stack**: **full architecture**</h6>

<img data-src="images/vx%20technology%20stack%20full%20architecture.png"
     class="no-shadow"/>
---
<h6> VX implementation: **build**</h6>

At service level, we have the following services to build:

1. VX configuration service
1. VX orchestration service
2. VX resource discovery service

---
<h6>VX implementation: **build**: **configuration service**</h6>

1. source: https://git.icelab.lenovo.com/cloud/ui-base
2. build steps:

---
<h6>VX implementation: **build**: **orchestration service**</h6>

1. source: http://hpcgitlab.labs.lenovo.com/WSS/wss/tree/vx
2. build charms:
  1. <a href="http://10.240.42.32/presentations/wss/#/78">build single
     charm</a>
  2. using <a href="http://10.240.42.32/presentations/wss/#/79">builder lib</a>
3. data model backend:
  1. source: http://hpcgitlab.labs.lenovo.com/WSS/wss/tree/vx/backend
  2. to setup `django`+`uwsgi`+`nginx`:
     https://github.com/lenovo/workload-solution/wiki/Nginx-Uwsgi-Django-deployment
  2. `uwsgi`:
    1. config: http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/vx/backend/deploy/lenovo.uwsgi.ini
    3. run `uwsgi` as system service:
       http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/vx/backend/deploy/uwsgi.service
  4. `nginx` config:
       http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/vx/backend/deploy/lenovo.nginx
  2. `configurator.lib`:
     http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/vx/configurator.py,
`UhmOrchestratorConfigurator`
  5. to launch vx msg queue: `celery -A lenovo worker -l info`
3. LXD:
  1. config:
     http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/vx/vm/lxd-bridge.default
  2. LXC image: http://10.240.42.32/vm/gold.tar.gz, using alias
     `juju/trusty/amd64`
3. `deployer.lib`: WSS deployer
4. `vx task consumer`:
   http://hpcgitlab.labs.lenovo.com/WSS/wss/blob/vx/backend/vx/task.py
5. playbooks: http://hpcgitlab.labs.lenovo.com/WSS/ansible.lenovo-lxca


<span class="reference">
Ref: http://10.240.42.32/presentations/wss/index.html#/78
</span>
---
<h6>VX implementation: **build**: **resource discovery service**</h6>

TBD
---
<h6>VX implementation: **deployment**</h6>

Each service has two deployment modes:

1. dev
2. production

---

<h6>VX implementation: **deployment**: **dev**</h6>

<div class="row">
  <div class="col s12">
    <img data-src="images/vx%20deployment%20dev.png"
         class="no-shadow">
  </div>
</div>

<span class="reference">
  Ref: http://10.240.42.32/presentations/wss/index.html#/88
</span>

---
<h6>VX implementation: **deployment**: **prod**</h6>

<div class="row">
  <div class="col l9 m9 s12">
    <img data-src="images/vx%20deployment%20prod.png"
         class="no-shadow"/>
  </div>
  <div class="col l3 m3 s12">
    <ol>
      <li>
        Deployed in a single Ubuntu 16.04.
      </li>
      <li>
        Use unix socket `lenovo.sock` to connect `uwsgi` to `nginx`.
      </li>
      <li>
        Database server and RabbitMQ server can be remote, in which case
        Django `settings.py` needs their IP info.
      </li>
      <li>
        Proxy `juju gui` is optional.
      </li>
    </ol>
  </div>
</div>
---
<h6> VX implementation: **packaging**</h6>

---
<h6>VX implementation: **dev**</h6>

---
<h6>VX implementation: **testing**</h6>

---
<h6>VX implementation: **distribution**</h6>

---
<h6>VX implementation: **upgrade**</h6>
