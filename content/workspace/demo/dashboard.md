Title: Project SPA Dashboard
Date: 2018-10-15 21:43
Slug: project spa dashboard demo
Author: Feng Xia
Tags: lenovo

<figure class="s12 center">
    <img src="/images/spa%20dashboard%20demo.png" />
    <figcaption>Project SPA Dashboard demo</figcaption>
</figure>

> * [Demo](https://fengxia41103.github.io/spa-dashboard/)
> * [Code](https://github.com/fengxia41103/spa-dashboard)

Project SPA Dashboard is a weekend fun. The idea came from Lenovo Open
Cloud project, in which we have developed auto deployment of a complex
stack on three physical servers. Services are Red Hat software
deployed on a RHHI instance. Previously we have maintained a table
(shown below) of URLs to these services since VM's IP and hostname are
pre-determined. 


<figure class="s12 center">
    <img src="/images/ibb%20rack%201%20cheatsheet.png" />
    <figcaption>IBB example cheatsheet</figcaption>
</figure>

However, since we have achieved daily deployment using playbook and
`extra_vars` as input, it is possible to generate a _dashboard_
representing a deployment instance with these actual config values,
thus eliminating manual maintenance of a static wiki page.

For example, here is part of the config file of`Satellite` VM:

```yaml
vm_name: brain1-satellite <-- host name
qcow_name: rhel75_qcow_satellite

cloud_init_nics:
  - nic_name: eth0
    nic_boot_protocol: static
    nic_ip_address: 10.240.41.1
    nic_netmask: 255.255.252.0
    nic_gateway: 10.240.40.1
    nic_on_boot: true
  - nic_name: eth1
    nic_boot_protocol: static
    nic_ip_address: 172.20.20.101
    nic_netmask: 255.255.255.0
    nic_gateway: 172.20.20.1
    nic_on_boot: true
  - nic_name: eth2
    nic_boot_protocol: static
    nic_ip_address: 172.20.30.101
    nic_netmask: 255.255.255.0
    nic_gateway: 172.20.30.1
    nic_on_boot: true

dns1: 10.240.0.10
dns2: 10.240.0.11
host_name: brain1-satellite


boot_devices: hd
os: rhel_7x64
cpu_cors: 4
memory: 20GiB
storage_domain_vm: iso
storage_domain_disk: vmstore
disk_format: cow
disk_interface: virtio_scsi
disk_bootable: True

nics:
  - name: nic1
    interface: virtio
    profile_name: Campus
    network_name: Campus
  - name: nic2
    interface: virtio
    profile_name: PhysicalMgmt
    network_name: PhysicalMgmt
  - name: nic3
    interface: virtio
    profile_name: VMMgmt
    network_name: VMMgmt

```
Once retrieved, displaying them is really a no brainer.

# Design

The design of it is straightforward. Two components:

1. **config repo server**: a web server serving YAML configs over
   HTTP. The source of YAML files are from git. Alternative, we can
   have github server raw file content directly, thus functioning as
   the web server [fetch][] can `get` these YAML data.
2. **client side**: is the single page application who retrieves YAML data
   and displays them.   

Code structure is reused of [data visualization][1]. Introduced
[js-yaml][2] for parsing YAML, we use [fetch][] API to retrieve YAML
configs, and map them to individual section for display. The overall
architecture is shown below:

<figure class="s12 center">
    <img src="/images/SPA%20dashboard%20design.png" />
    <figcaption>SPA Dashboard Design</figcaption>
</figure>

Benefits are obvious:

1. All values are from YAML config files used by actual
   deployment. Therefore, it's the EXACT same source of our daily.
2. Consistency is guaranteed.
3. YAMLs are served by a webserver and retrieved by this
   application. Thus, it is a trivial step away from having a
   centralized "config repo service" for this EXACT purpose.
4. Application has built-in capability to `fetch` data in format of
   YAML or JSON. Thus, it can speak to any REST API, eg. getting
   server meta from netbox, or POST a request to Tower to kickoff a
   &rarr; the possibility of integration is endless.
5. Any displayed config can be turned into a `input` box, so we can
   change config and trigger _redeploy_ or _update_. The frontend
   (this application) is ready; the function behind the scene is not
   there yet. But when we ever have such capability, we can
   demonstrate it quickly.

# Toolset

* [Materialize][]: "A modern responsive front-end framework based on Material Design" by their words.
* [REACT][]: core
* [webpack][]: new module builder that is making lot of buzz these days.
* [fetch][]: a new way to talk to API endpoints instead of `jQuery AJAX`.

[materialize]: http://materializecss.com/
[react]: https://facebook.github.io/react/
[webpack]: https://webpack.github.io/
[fetch]: https://github.com/github/fetch




[1]: {filename}/workspace/demo/visualization.md
[2]: https://github.com/nodeca/js-yaml
[3]: https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
