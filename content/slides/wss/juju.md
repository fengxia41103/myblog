<!-- Section 2: key technology  -->
<section data-background="https://drscdn.500px.org/photo/167616481/q%3D80_m%3D2000/v2?webp=true&sig=138122848b49e23f21df0191e4ed3ae335fa47d262006cfa77c022b4771f6de9">
  <div align="left" class="col s6">
    Key Technology:
    <h2>
      Canonical Juju
    </h2>
  </div>
</section>
---
<h6 class="menu-title">Table of contents</h6>

1. Introduction
2. Key concepts
2. How Juju executes charm
3. How Juju manages/requests (platform) resource
4. Internals
  1. bootstrap process
  2. provider
  3. agent
---
<h6>Juju: **introduction**</h6>

>  **Juju's mission** is to provide a
>  modeling language for users that abstracts the specifics of operating
>  complex big software topologies.
>

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
<h6>Juju: **key concepts**</h6>

<div class="row">
  <div class="col l5 m5 s12">
    <img data-src="images/juju%20conceptual%20model.png"
         class="no-shadow">
  </div>

  <div class="col l7 m7 s12">
    <dl>
      <dt>provider</dt>
      <dd>
        Provider is the **driver** that Juju speaks
        to different clouds/platforms.

        <p>
          It is **NOT** a plugin system. All providers are
          compiled into `juju` binary. 
        </p>
      </dd>
      
      <dt>controller (as `machine-0`)</dt>
      <dd>
        A Juju controller is the management node of a Juju cloud
        environment. In particular, it houses the database and keeps
        track of all the models in that environment.
        (<a href="https://jujucharms.com/docs/2.2/controllers">doc</a>)

      </dd>

      <dt>model</dt>
      <dd>
        Model hosts configurations that affects Juju (code)
        execution, eg. agent version, apt mirror
        (list of <a href="https://jujucharms.com/docs/2.2/models-config">key/value options
        </a>).

        <p>
          Two models are created by default per controller &mdash; `controller` and `default`.
          `controller` is for internal use; all other models can be CRUD.
        </p>
      </dd>

      <dt>machine (resource)</dt>
      <dd>
        Machine is an abstract of a usable server that has an operating system
        installed and can be used to deploy software. They are managed by
        the `machine-0` and are generally selected by <a href="https://jujucharms.com/docs/2.2/reference-constraints">constraints</a>.
      </dd>
    </dl>
  </div>
</div>
---
<h6>Juju: **how to execute a charm**</h6>

1. Agent-based
2. A command is sent to **one controller** only
3. You can have multiple controllers active (`$ juju list-controllers`)
4. Charm is copied to a `machine` in its `/var/lib/juju/agents/[app name]-[machine index]/`
---
<h6>Juju: **How to execute a charm**: **model**</h6>
<img data-src="images/juju%20model.png"
     style="box-shadow:none">

---
<h6>juju: **How to execute a charm**: **sequence diagram**</h6>

<div class="row">
  <div class="col l9 m9 s12">
    <img data-src="images/juju%20charm%20deploy%20sequence.png"
         class="no-shadow">
  </div>
  <div class="col l3 m3 s12">
    <dl>
      <dt>machine-0</dt>
      <dd>
        Manager node. One per cloud environment. Keep agent states, serve CLI
        request, and command agents.
      </dd>

      <dt>agent</dt>
      <dd>
        Runtime workload orchestrator. Distributed on each target node.
      </dd>

      <dt>charm store</dt>
      <dd>
        Workload repository. Can be both local & remote.
      </dd>
    </dl>
  </div>
</div>
---
<h6>Juju: **how to  execute a charm**: **supported clouds (platform)**</h6>

<pre class="brush:plain">
$ juju list-clouds
</pre>

| Cloud       | Regions | Default         | Type       | Description                  |
|-------------|---------|-----------------|------------|------------------------------|
| aws         |      14 | us-east-1       | ec2        | Amazon Web Services          |
| aws-china   |       1 | cn-north-1      | ec2        | Amazon China                 |
| aws-gov     |       1 | us-gov-west-1   | ec2        | Amazon (USA Government)      |
| azure       |      26 | centralus       | azure      | Microsoft Azure              |
| azure-china |       2 | chinaeast       | azure      | Microsoft Azure China        |
| cloudsigma  |       5 | hnl             | cloudsigma | CloudSigma Cloud             |
| google      |       9 | us-east1        | gce        | Google Cloud Platform        |
| joyent      |       6 | eu-ams-1        | joyent     | Joyent Cloud                 |
| oracle      |       5 | uscom-central-1 | oracle     | Oracle Compute Cloud Service |
| rackspace   |       6 | dfw             | rackspace  | Rackspace Cloud              |
| localhost   |       1 | localhost       | lxd        | LXD Container Hypervisor     |
---
<h6>How Juju manages/requests resource</h6>
<p>
Two models Juju manages/requests a cloud (platform) resource:
</p>

1. **On-demand**: Cloud resource is created on the fly, eg. `localhost` (LXD container) cloud has one container (`machine-0`) to begin with. Issuing `$ juju deploy [charm name]` on `localhost` cloud will consequently create more containers as `machine-N`.  

2. **Pre-registered pool**: cloud resource has been created and needs to be
   registered to Juju's `machine-0` before it can be used, eg. MAAS handles server discovery (via PXE) and OS provision so to put it into `READY` state for Juju's orchestration.

---
<h6>Juju: **How to get a resource**: **LXD model**</h6>

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
<h6>juju: **How to get a resource**: **MaaS model**</h6>

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
      <li>Can import and use customized OS image.</li>
    </ol>
  </div>
</div>
---
<h6>Juju internals</h6>

1. bootstrap process
2. bootstrap finalizer
3. provider
4. juju agent

---
<h6>Juju: **internals**: **bootstrap process**</h6>
<img data-src="images/juju%20bootstrap%20process.png"
     class="no-shadow">

Reference: [v2.0][16]

[16]: https://github.com/juju/juju/tree/2.0
---
<h6>Juju: **internals**: **bootstrap finalizer**</h6>

<div class="row">
  <div class="col l6 m6 s12">
<img data-src="images/juju%20common%20BootstrapInstance%20finalizer%20func.png"
     class="no-shadow">
  </div>
  <div class="col l6 m6 s12">
    <ol>
      <li>Dir: `/var/lib/juju`</li>
      <li>Machine identity: `none.txt` </li>
      <li>Provision done: SSH polling</li>
      <li>Agent & pkg install: `cloud-init`</li>
    </ol>
  </div>
</div>
---
<h6>Juju: **internals**: **provider**</h6>
<img data-src="images/juju%20provider.png"
     class="no-shadow">

Reference: [v2.0][16]

[16]: https://github.com/juju/juju/tree/2.0
---
<h6>Juju: **internals**: **agent**</h6>
<img data-src="images/juju%20agent%20overview.png"
     class="no-shadow">

Reference: [v2.0][16]

[16]: https://github.com/juju/juju/tree/2.0
