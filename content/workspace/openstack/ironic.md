Title: Openstack Ironic
Date: 2017-03-15 22:45
Tags: openstack
Slug: ironic intro
Author: Feng Xia

> <span class="myhighlight">Copyright @ Lenovo US</span>

This article is an outcome of my writing a Juju-Ironic provider. The
plan was to first figure out Ironic APIs that will achieve what Juju
provider needs &mdash; start an instance on demand, then build those
REST requests into Juju provider code. After playing with Ironic API
and Openstack's Devstack for two weeks, I start to realize that Ironic
by itself doesn't do much. Instead, it heavily relies on other
Openstack services to provision a baremetal &mdash; Keystone to
generate a token which will be used in all HTTP calls, Neutron to
provide network/_port_, Ironic itself to manage a _node_, Glance to
get kernel image, ramdisk image, and actual OS image, and Nova to
_orchestrate_ these information for Ironic API to consume. 


Ironic [user guide][1] has some good information on basic technology
and Ironic design. A [talk][3] & [slides][5] by [devananda][4] on 2015
Vancouver Summit is also a good point to start.


[1]: https://docs.openstack.org/developer/ironic/deploy/user-guide.html
[3]: https://www.openstack.org/videos/vancouver-2015/isn-and-039t-it-ironic-the-bare-metal-cloud
[4]: https://github.com/devananda
[5]: https://github.com/devananda/talks/blob/master/isnt-it-ironic.html

In the following sections I'd like to use the questions I have
encountered in research to create a newbie-oriented tutorial on
Ironic. In particular, I'd like to illustrate a few Ironic internals
to show what "managing baremetal" is actually doing.

# Ironic introduction

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/ironic_design.png" />
    <figcaption>Ironic design (<a href="https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/9/html-single/architecture_guide/#comp-ironic">source</a>)</figcaption>
</figure>

Ironic has three components:

1. Ironic [RESTful API][14]
2. Ironic conductor: its runtime core
3. Ironic CLI ([python-ironicclient][12])

There are two other Ironic related projects that, though optional,
should be included in our discussion also because they play an
important role in Ironic's workflow: [Ironic Python Agent][7] and
[Ironic Inspector][8].

Since it stores meta data in a DB, let's take a look at its DB schema:

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/ironic_db_er.png" />
    <figcaption>Ironic ER diagram</figcaption>
</figure>


# Create a node = Enroll hardware

> API: [POST v1/nodes][13]

Everything starts with creating a node. Ironic node is an abstract
representation of a baremetal. Creating a node is simply adding
certain node's parameters to Ironic DB. The term "enrolling hardware"
(or enrolling a node) can be used interchangeably because it involves
no image or system running on the node. Whether
using [Ironic Python Client][12] to import JSON, or using CLI
`openstack baremetal node create`, it achieves the same thing &mdash;
eventually the command chain will call Ironic's API
endpoint [POST /v1/nodes][13].

[12]: https://github.com/openstack/python-ironicclient
[13]: https://developer.openstack.org/api-ref/baremetal/?expanded=show-v1-api-detail,create-node-detail,delete-node-detail,change-node-power-state-detail,list-attached-vifs-of-a-node-detail,agent-heartbeat-detail#create-node
[14]: https://developer.openstack.org/api-ref/baremetal/

An example snippet to create node in Devstack is shown below. We will go over
details of the input arguments in the next section. <font color="red">Note</font>: you must
specify the `X-OpenStack-Ironic-API-Version` value in HTTP header.

<pre class="brush:python;">
def create_node(token, chassis, driver_info, instance_info, properties):
    # Ironic API: create a node
    url = 'http://%s:6385/v1/nodes' % DEVSTACK_SERVER
    headers = {
        'X-Auth-Token': '%s' % token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-OpenStack-Ironic-API-Version': 1.9  # must have!
    }
    payload = {
        'chassis_uuid': chassis,
        "driver": "agent_ipmitool",
        "name": randomword(5),
        "driver_info": driver_info,
        'instance_info': instance_info,
        'properties': properties,
    }
    r = requests.post(
        url,
        data=json.dumps(payload),
        headers=headers
    )
    resp = json.loads(r.content)
</pre>

## Node details

> API: [GET v1/nodes/{node_ident}][15]
[15]: https://developer.openstack.org/api-ref/baremetal/?expanded=show-v1-api-detail,delete-node-detail,change-node-power-state-detail,list-attached-vifs-of-a-node-detail,agent-heartbeat-detail#show-node-details

Unfortunately, Ironic's [API document][14] does not specify which field is
required. You can _create_ a node without giving it much
information. Again, the creation does nothing besides creating a
record in Ironic DB. Run `openstack baremetal node show [node_uuid]`
displays details of a node.

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/ironic_node_show.png" />
    <figcaption>Details of a provisioned node</figcaption>
</figure>

1. `name` (<font color="red">required</font>): well, a name.
2. `driver` (<font color="red">required</font>): we will discuss more about Ironic
   drivers. This defines which Ironic driver to use.
3. `driver_info` (<font color="red">required</font>): All the metadata required by the driver
   to manage this Node. List of fields varies between drivers, and can be
   retrieved from the /v1/drivers/<DRIVER_NAME>/properties resource.
   For example, for `_ipmi` drivers, one needs:   
       + `ipmi_port`
       + `ipmi_username`  in devstack, default to "admin"
       + `ipmi_password`: in devstack, default to "password"
       + `ipmi_address`: 
       + `deploy_kernel`: in devstack, it is "ir-deploy-agent_ipmitool.kernel".
       + `deploy_ramdisk`: in devstack, it is "ir-deploy-agent_ipmitool.initramfs"

    Example payload:
    <pre class="brush:plain;">
    driver_info = {
        'ipmi_port': 6230,
        'ipmi_username': "admin",
        'deploy_kernel': ir-deploy-agent_ipmitool.kernel UUID,
        'deploy_ramdisk': ir-deploy-agent_ipmitool.initramfs UUID,
        'ipmi_address': "10.0.2.15",
        'ipmi_password': "password"
    }
    </pre>
    
4. `driver_internal_info` (read-only): this field is not accessible
   via API. Used by driver to store internal information.
   + `agent_url`: this is the callback URL to the Ironic Python Agent (IPA)
     running on the node (when an agent ramdisk image is selected). We
     will cover more of IPA later. The value is filled in when the IPA
     calls Ironic's `/v1/heartbeat` endpoint.
5. `instance_info`: is populated when the node is
   provisioned. However, user can also set this field through API.

    Example payload:
    <pre class="brush:plain;">
        {
           "ramdisk":"1a243f7b-3e96-4140-8408-b82064599cec",
           "kernel":"ef538456-704c-445c-a98b-c081be22ad71",
           "image_source":"9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
           "ephemeral_gb":0,
           "image_properties":{
              "kernel_id":"ef538456-704c-445c-a98b-c081be22ad71",
              "ramdisk_id":"1a243f7b-3e96-4140-8408-b82064599cec",
              "virtual_size":null
           },
           "preserve_ephemeral":false,
           "ephemeral_mb":0,
           "local_gb":"10",
           "image_disk_format":"ami",
           "image_checksum":"eb9139e4942121f22bbc2afc0400b2a4",
           "nova_host_id":"devstack",
           "ephemeral_format":null,
           "root_gb":"10",
           "display_name":"tt1",
           "configdrive":null,
           "image_type":"partition",
           "image_tags":[
           ],
           "memory_mb":"1280",
           "vcpus":"1",           "image_url":"http://10.0.2.15:8080/v1/AUTH_dbace9b9b039429ab5c2c3e43817ced2/glance/9794e5b3-b3f1-403c-b37a-19c7e07cca4a?temp_url_sig=da4154125d9011e2768bd5591b4d93c217f27d8b&temp_url_expires=1488585783",
           "image_container_format":"ami",
           "root_mb":10240,
           "swap_mb":0
        }
    </pre>

6. `properties` (<font color="red">required</font>): Physical
   characteristics of this Node. Populated by ironic-inspector during
   inspection. Can also be set via the REST API at any time. These
   values are used by NOVA to match flavor &mdash; an important aspect
   of _baremetal management_ is to filter what a workload wants
   vs. what we have, and the values in `properties` define what we
   have.

    Example payload:

    <pre class="brush:plain;">
    properties = {
        'cpus': 1,
        'memory_mb': 1280,
        'local_gb': 10,
        'cpu_arch': 'x86_64',
        'capabilities': 'memory_mb:1280,local_gb:10,cpu_arch:x86_64,cpus:1,boot_option:local'
    }
    </pre>

The rest of the fields are self-explanatory so I'll skip them for now.

# Hardware inventory

Hardware inventory is to collect characteristics such as the number of
CPUs, memory size, disk partition, MAC address and so on. There are
two ways to collect these: out-of-band and
in-band. In-band inspection involves booting an OS on the target node
and fetching information directly from it. This process is more
fragile and time-consuming than the out-of-band inspection, but it is
not vendor-specific and works across a wide range of hardware.;
out-of-band, on the other hand, does not involve an OS. Instead,
information is collected by a built-in BMC controllera on the baremetal box
and are then queried through the box's IPMI interface.

So translate these into Ironic, it has two ways to inventory hardware:

1. IPA's [hardware manager][9] &mdash; in-band only. [IPA][7] is a
   Python client packaged inside a ramdisk that will be run at the
   beginning of a provisioning process. Hardware manager
   is part of IPA's capability. They can run together with IPA to
   collect node information.
2. [Ironic Inspector][8] &mdash; in-band and out-of-band. Inspector is
   a separate service running outside the target node. It exposes a
   set of [API][10]. When caller sends request to its endpoint `POST
   /v1/introspection/<node_indent>`, inspector uses the UUID to
   extract node's `drive_info` from Ironic DB. With the IPMI credentials
   it can now query node info from BMC as well controlling its
   power cycle if it chooses to run a ramdisk
   as [in-band method][11]. 

[8]: https://docs.openstack.org/developer/ironic/deploy/inspection.html
[9]: https://docs.openstack.org/developer/ironic-python-agent/#hardware-managers
[10]: https://docs.openstack.org/developer/ironic-inspector/http-api.html#
[11]: https://docs.openstack.org/developer/ironic/deploy/inspection.html#in-band-inspection



# Image [TBD]

Two types of images: deploy image and user image. Plenty blogs showing
how to make them. But I'd like to have an explanation what they are
and how they are used.

Devstack image list:
<pre class="brush:bash;">
+--------------------------------------+------------------------------------+--------+
| ID                                   | Name                               | Status |
+--------------------------------------+------------------------------------+--------+
| 94e2055e-fcb3-4c2e-a547-918450b060a1 | Fedora-Cloud-Base-25-1.3.x86_64    | active |
| 8a1a67b7-4875-457d-9242-16df4c537095 | cirros-0.3.4-x86_64-disk           | active |
| 9794e5b3-b3f1-403c-b37a-19c7e07cca4a | cirros-0.3.4-x86_64-uec            | active |
| ef538456-704c-445c-a98b-c081be22ad71 | cirros-0.3.4-x86_64-uec-kernel     | active |
| 1a243f7b-3e96-4140-8408-b82064599cec | cirros-0.3.4-x86_64-uec-ramdisk    | active |
| 9eb37c5a-3021-4eea-93b7-66922eb89152 | ir-deploy-agent_ipmitool.initramfs | active |
| 8d255ece-d66c-43a5-8043-5a6ce8bea4f2 | ir-deploy-agent_ipmitool.kernel    | active |
+--------------------------------------+------------------------------------+--------+
</pre>

# Ironic deploy method: agent & PXE

Ironic offers two deploy methods: agent ([Ironic Python Agent (IPA)][7]) and
PXE. The agent-based deploy method came from [Rackspace][32] and was [blueprinted].

[31]: https://blueprints.launchpad.net/ironic/+spec/agent-driver
[32]: https://journal.paul.querna.org/articles/2014/07/02/putting-teeth-in-our-public-cloud/

[7]: https://docs.openstack.org/developer/ironic-python-agent/#how-it-works

## Ironic Agent (IPA)

Agent method means to boot a specially made ramdisk image on
baremetal. Agent will run as `systemd` service.  The magic is that
agent knows where the Ironic API is. So it will __lookup__ itself by
sending Ironic API its MAC address. Ironic will send back the node
UUID. From that point on, IPA will ping home (hearbeat) periodically
(using UUID) until Ironic commands it to do something. Part of the
hearbeat payload is a callback URL, so apparently IPA also exposes a HTTP service
that Ironic conductor can use for commands.

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/ironic_ipa_sequence.png" />
    <figcaption>Ironic Python Agent (IPA) sequence diagram</figcaption>
</figure>

Quoting from the [Rackspace OnMetal blog][32]:

> With IPA the DHCP, PXE and TFTP configurations become the static for
> all baremetal nodes, reducing complexity. Once running, the Agent
> sends a heartbeat to the Ironic Conductors with hardware
> information. Then the Conductors can order the Agent to take different
> actions. For example in the case of provisioning an instance, the
> Conductor sends an HTTP POST to prepare_image with the URL for an
> Image, and the Agent downloads and writes it to disk itself, keeping
> the Ironic Conductor out of the data plane for an image download. Once
> the image is written to disk, the Ironic Conductor simply reboots the
> baremetal node, and it boots from disk, removing a runtime dependency
> on a DHCP or TFTP server.

## Provision process &mdash; Agent
Source by [devananda github][18].
[18]: https://github.com/devananda/talks/tree/master/images

<figure class="row">
    <img class="img-responsive center-block"
    src="https://github.com/devananda/talks/blob/master/images/deploy_with_agent.png?raw=true" />
    <figcaption>Ironic deploy &mdash; Agent</figcaption>
</figure>

The IPA server is implemented using [Python Pecan][41]. The
long-running process is `IronicPythonAgent` in `ironic_python_agent/agent.py`:
<pre class="brush:python;">
wsgi = simple_server.make_server(
   self.listen_address.hostname,
   self.listen_address.port,
   self.api,
   server_class=simple_server.WSGIServer)
if not self.standalone and self.api_url:
   # Don't start heartbeating until the server is listening
   self.heartbeater.start()
try:
   wsgi.serve_forever()
except BaseException:
   LOG.exception('shutting down')
if not self.standalone and self.api_url:
   self.heartbeater.stop()
</pre>

The `heartbeater.start()` is a thread that expects to receive letter
`'a'` from Ironic and will stop upon receiving `'b'`. IPA also
implements a RPC using the below syntax:
<pre class="brush:python;">
@base.async_command('prepare_image', _validate_image_info)
def prepare_image(self,
                  image_info=None,
                  configdrive=None):
</pre>

The function `prepare_image` is the key. Ironic's
`xx-Agent` driver will call POST to IPA's endpoint
using the string `prepare_image` as a RPC call that will 
envoke the corresponding function on the IPA side, in this case,
the function `prepare_image`, which is to write image to disk. The IPA
implementation of this function is shown below. As one can see,
it is assuming that a block device is available and it will then run a 
`bash` script to write this image to disk. After image is written to
disk, it can also write a bootloader (eg. grub2). Then IPA will signal
Ironic that deploy is all done, and Ironic will go ahead to reboot the
node &mdash; this then completes the provisioning process.
<pre class="brush:python;">
@base.async_command('prepare_image', _validate_image_info)
def prepare_image(self,
                  image_info=None,
                  configdrive=None):
    """Asynchronously prepares specified image on local OS install device.
    In this case, 'prepare' means make local machine completely ready to
    reboot to the image specified by image_info.
    Downloads and writes an image to disk if necessary. Also writes a
    configdrive to disk if the configdrive parameter is specified.
    :param image_info: Image information dictionary.
    :param configdrive: A string containing the location of the config
                        drive as a URL OR the contents (as gzip/base64)
                        of the configdrive. Optional, defaults to None.
    :raises: ImageDownloadError if the image download encounters an error.
    :raises: ImageChecksumError if the checksum of the local image does not
         match the checksum as reported by glance in image_info.
    :raises: ImageWriteError if writing the image fails.
    :raises: InstanceDeployFailure if failed to create config drive.
         large to store on the given device.
    """
    LOG.debug('Preparing image %s', image_info['id'])
    device = hardware.dispatch_to_managers('get_os_install_device')
    disk_format = image_info.get('disk_format')
    stream_raw_images = image_info.get('stream_raw_images', False)
    # don't write image again if already cached
    if self.cached_image_id != image_info['id']:
        if self.cached_image_id is not None:
            LOG.debug('Already had %s cached, overwriting',
                      self.cached_image_id)
        if (stream_raw_images and disk_format == 'raw' and
            image_info.get('image_type') != 'partition'):
            self._stream_raw_image_onto_device(image_info, device)
        else:
            self._cache_and_write_image(image_info, device)
    # the configdrive creation is taken care by ironic-lib's
    # work_on_disk().
    if image_info.get('image_type') != 'partition':
        if configdrive is not None:
            # Will use dummy value of 'local' for 'node_uuid',
            # if it is not available. This is to handle scenario
            # wherein new IPA is being used with older version
            # of Ironic that did not pass 'node_uuid' in 'image_info'
            node_uuid = image_info.get('node_uuid', 'local')
            disk_utils.create_config_drive_partition(node_uuid,
                                                     device,
                                                     configdrive)
    msg = 'image ({}) written to device {} '
    result_msg = _message_format(msg, image_info, device,
                                 self.partition_uuids)
    LOG.info(result_msg)
    return result_msg
</pre>

[41]: https://pecan.readthedocs.io/en/latest/

## Provision process &mdash; PXE
Source by [devananda github][18].
[18]: https://github.com/devananda/talks/tree/master/images

<figure class="row">
    <img class="img-responsive center-block"
    src="https://github.com/devananda/talks/blob/master/images/pxe-deploy-1.png?raw=true" />
    <img class="img-responsive center-block"
    src="https://github.com/devananda/talks/blob/master/images/pxe-deploy-2.png?raw=true" />
    <figcaption>Ironic deploy &mdash; PXE</figcaption>
</figure>

# Using NOVA API to create an instance

Using Devstack, the easiest way to start an instance is CLI command.
<pre class="brush:bash;">
openstack server create --image 9794e5b3-b3f1-403c-b37a-19c7e07cca4a --flavor baremetal --nic port-id=22d79b92-0848-4053-ad0d-f182d02d01a0 tt1 --debug
</pre>

Where:

+ `--image`: using image UUID. Here we use the `cirros-0.3.4-x86_64-uec`
  image.
+ `--flavor`: using _baremetal_ flavor
    <pre class="brush:bash;">
    +----------------------------+--------------------------------------+
    | Field                      | Value                                |
    +----------------------------+--------------------------------------+
    | OS-FLV-DISABLED:disabled   | False                                |
    | OS-FLV-EXT-DATA:ephemeral  | 0                                    |
    | access_project_ids         | None                                 |
    | disk                       | 10                                   |
    | id                         | a5178caf-6b3a-49ec-ab47-a6daaf05423e |
    | name                       | baremetal                            |
    | os-flavor-access:is_public | True                                 |
    | properties                 | cpu_arch='x86_64'                    |
    | ram                        | 1280                                 |
    | rxtx_factor                | 1.0                                  |
    | swap                       |                                      |
    | vcpus                      | 1                                    |
    +----------------------------+--------------------------------------+
    </pre>
  + `--port`: we create a port on _private_ network using Neutron API
  `POST /v2.0/ports`.
    <pre class="brush:python;">
    def create_port(token, network):
      name = randomword(5)
      # Neutron: create a port
      url = 'http://%s:9696/v2.0/ports' % DEVSTACK_SERVER
      headers = {
          'X-Auth-Token': '%s' % token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
      }
      payload = {
          "port": {
              "name": name,
              "network_id": network,
              "admin_state_up": True,
              "extra_dhcp_opts": [
                  {
                      'ip_version': '4',
                      'opt_name': 'tftp-server',
                      'opt_value': '10.0.2.15'
                  }, {
                      'ip_version': '4',
                      'opt_name': 'tag:!ipxe,bootfile-name',
                      'opt_value': 'undionly.kpxe'
                  }, {
                      'ip_version': '4',
                      'opt_name': 'tag:ipxe,bootfile-name',
                      'opt_value': 'http://10.0.2.15:3928/boot.ipxe'
                  }, {
                      'ip_version': '4',
                      'opt_name': 'server-ip-address',
                      'opt_value': '10.0.2.15'
                  }],
              "binding:vnic_type": "normal",
              "device_owner": "network:dhcp"
          }
      }
      r = requests.post(
          url,
          data=json.dumps(payload),
          headers=headers
      )
      resp = json.loads(r.content)
    </pre>


Now let's see how this commands utilizes various API calls:

## Read basic information from Keystone

+ Service: Keystone
+ Method: `GET`
+ Endpoint: `/identity/v3`
+ HTTP header:
    1. Accept: `application/json`
    2. User-Agent: `osc-lib/1.3.0 keystoneauth1/2.18.0 python-requests/2.12.5 CPython/2.7.12`
+ JSON payload: none
+ Response:
<pre class="brush:bash;;">
{
"version":{
      "status":"stable",
      "updated":"2017-02-22T00:00:00Z",
      "media-types":[
         {
            "base":"application/json",
            "type":"application/vnd.openstack.identity-v3+json"
         }
      ],
      "id":"v3.8",
      "links":[
         {
            "href":"http://10.0.2.15/identity/v3/",
            "rel":"self"
         }
      ]
   }
}
</pre>

## Get security token

The token is in response's header `X-Subject-Token` field.
We are using "Password authentication with scoped authorization".

+ Service: Keystone
+ Method: `POST`
+ Endpoint: `/identity/v3/auth/tokens` ([ref][22])
[22]: https://developer.openstack.org/api-ref/identity/v3/?expanded=password-authentication-with-scoped-authorization-detail#password-authentication-with-scoped-authorization
+ HTTP header:
    1. Content-Type: `application/json`
+ JSON payload:
<pre class="brush:bash;">
{
   "auth":{
      "identity":{
         "methods":[
            "password"
         ],
         "password":{
            "user":{
               "domain":{
                  "name":"Default"
               },
               "name":USERNAME,
               "password":PASSWORD
            }
         }
      },
      "scope":{
         "project":{
            "domain":{
               "name":"Default"
            },
            "name":PROJECT
         }
      }
   }
}</pre>
+ Response: too long to paste. Not important.


## Get user image meta data

+ Service: `Glance`
+ Method: `GET`
+ Endpoint: `/v2/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a` ([ref][23])
[23]: https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-image-details-detail#show-image-details
+ HTTP header:
    1. Accept-Encoding: `gzip, deflate`
    2. Accept: `*/*`
    3. User-Agent: `python-glanceclient`
    4. Connection: `keep-alive`
    5. X-Auth-Token: `ccc5f650029b710c4a3c8f20320afaaed04326f1`
    6. Content-Type: `application/octet-stream`
+ JSON payload: none
+ Response:
<pre class="brush:bash;">
{
   "status":"active",
   "name":"cirros-0.3.4-x86_64-uec",
   "tags":[
   ],
   "kernel_id":"ef538456-704c-445c-a98b-c081be22ad71",
   "container_format":"ami",
   "created_at":"2017-03-03T22:38:57Z",
   "ramdisk_id":"1a243f7b-3e96-4140-8408-b82064599cec",
   "disk_format":"ami",
   "updated_at":"2017-03-03T22:38:58Z",
   "visibility":"public",
   "self":"/v2/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
   "min_disk":0,
   "protected":false,
   "id":"9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
   "size":25165824,
   "file":"/v2/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a/file",
   "checksum":"eb9139e4942121f22bbc2afc0400b2a4",
   "owner":"3b2594f2569542f694ff346a6db7fa1e",
   "virtual_size":null,
   "min_ram":0,
   "schema":"/v2/schemas/image"
}
</pre>

## Get image schema
Gets a JSON-schema document that represents the various entities
talked about by the Images v2 API.

+ Service: Glance
+ Method: `GET`
+ Endpoint: `/v2/schemas/images` ([ref][24])
[24]: https://developer.openstack.org/api-ref/image/v2/index.html?expanded=show-images-schema-detail#show-images-schema
+ HTTP header: none
+ JSON payload: none
+ Response: too long to paste.

## Get flavor details

+ Service: Nova
+ Method: `GET`
+ Endpoint: `/v2.1/flavors/a5178caf-6b3a-49ec-ab47-a6daaf05423e`
  ([ref][25])
[25]: https://developer.openstack.org/api-ref/compute/?expanded=show-flavor-details-detail#show-flavor-details
+ HTTP header:
    1. User-Agent: `python-novaclient`
    2. Accept: `application/json`
    3. X-Auth-Token: `ccc5f650029b710c4a3c8f20320afaaed04326f1`
+ JSON payload: none
+ Response:
<pre class="brush:bash;">
{
   "flavor":{
      "links":[
         {
            "href":"http://10.0.2.15:8774/v2.1/flavors/a5178caf-6b3a-49ec-ab47-a6daaf05423e",
            "rel":"self"
         },
         {
            "href":"http://10.0.2.15:8774/flavors/a5178caf-6b3a-49ec-ab47-a6daaf05423e",
            "rel":"bookmark"
         }
      ],
      "ram":1280,
      "OS-FLV-DISABLED:disabled":false,
      "os-flavor-access:is_public":true,
      "rxtx_factor":1.0,
      "disk":10,
      "id":"a5178caf-6b3a-49ec-ab47-a6daaf05423e",
      "name":"baremetal",
      "vcpus":1,
      "swap":"",
      "OS-FLV-EXT-DATA:ephemeral":0
   }
}
</pre>

## Get port details

+ Service: Neutron
+ Method: `GET`
+ Endpoint: `/v2.0/ports/22d79b92-0848-4053-ad0d-f182d02d01a0`
([ref][26])
[26]: https://developer.openstack.org/api-ref/networking/v2/?expanded=show-port-details-detail#show-port-details
+ HTTP header:
    1. User-Agent: `openstacksdk/0.9.13 keystoneauth1/2.18.0 python-requests/2.12.5 CPython/2.7.12`
    2. X-Auth-Token: `ccc5f650029b710c4a3c8f20320afaaed04326f1`
+ JSON payload: none
+ Response:
<pre class="brush:bash;">
{
   "port":{
      "status":"DOWN",
      "binding:host_id":"",
      "description":"",
      "allowed_address_pairs":[
      ],
      "tags":[
      ],
      "extra_dhcp_opts":[
         {
            "opt_value":"http://10.0.2.15:3928/boot.ipxe",
            "ip_version":4,
            "opt_name":"tag:ipxe,bootfile-name"
         },
         {
            "opt_value":"10.0.2.15",
            "ip_version":4,
            "opt_name":"server-ip-address"
         },
         {
            "opt_value":"10.0.2.15",
            "ip_version":4,
            "opt_name":"tftp-server"
         },
         {
            "opt_value":"undionly.kpxe",
            "ip_version":4,
            "opt_name":"tag:!ipxe,bootfile-name"
         }
      ],
      "updated_at":"2017-03-03T23:01:48Z",
      "device_owner":"network:dhcp",
      "revision_number":9,
      "port_security_enabled":false,
      "binding:profile":{
      },
      "fixed_ips":[
         {
            "subnet_id":"d2c3a067-ccda-45c0-9c8e-b73e88b0402e",
            "ip_address":"10.0.0.3"
         },
         {
            "subnet_id":"70ce2eae-bcff-45a5-bf1f-b9720e526e7f",
            "ip_address":"fdb2:c07c:cdc9:0:f816:3eff:feb3:da44"
         }
      ],
      "id":"22d79b92-0848-4053-ad0d-f182d02d01a0",
      "security_groups":[
      ],
      "device_id":"",
      "name":"LNG",
      "admin_state_up":true,
      "network_id":"980f4a97-0f8e-4347-a324-d9d1247f7c3f",
      "tenant_id":"3b2594f2569542f694ff346a6db7fa1e",
      "binding:vif_details":{
      },
      "binding:vnic_type":"normal",
      "binding:vif_type":"unbound",
      "mac_address":"fa:16:3e:b3:da:44",
      "project_id":"3b2594f2569542f694ff346a6db7fa1e",
      "created_at":"2017-03-03T23:01:47Z"
   }
}
</pre>

## Create a NOVA instance based on image and flavor

+ Service: Nova
+ Method: `POST`
+ Endpoint: `/v2.1/servers` ([ref][27])
[27]: https://developer.openstack.org/api-ref/compute/?expanded=show-flavor-details-detail,create-server-detail#create-server
+ HTTP header:
    1. User-Agent: `python-novaclient`
    2. Content-Type: `application/json`
    3. Accept: `application/json`
    4. X-Auth-Token: `ccc5f650029b710c4a3c8f20320afaaed04326f1`
+ JSON payload:
<pre class="brush:bash;">
{
   "server":{
      "name":"tt1",
      "imageRef":"9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
      "flavorRef":"a5178caf-6b3a-49ec-ab47-a6daaf05423e",
      "max_count":1,
      "min_count":1,
      "networks":[
         {
            "port":"22d79b92-0848-4053-ad0d-f182d02d01a0"
         }
      ]
   }
}
</pre>

+ Response:
<pre class="brush:bash;">
{
   "server":{
      "security_groups":[
         {
            "name":"default"
         }
      ],
      "OS-DCF:diskConfig":"MANUAL",
      "id":"3d79d699-16c7-4f99-b034-57403d2d18e6",
      "links":[
         {
            "href":"http://10.0.2.15:8774/v2.1/servers/3d79d699-16c7-4f99-b034-57403d2d18e6",
            "rel":"self"
         },
         {
            "href":"http://10.0.2.15:8774/servers/3d79d699-16c7-4f99-b034-57403d2d18e6",
            "rel":"bookmark"
         }
      ],
      "adminPass":"xvcZ3HXf9Zr4"
   }
}
</pre>  

## Read NOVA instance details

+ Service: Nova
+ Method: `GET`
+ Endpoint: `/v2.1/servers/3d79d699-16c7-4f99-b034-57403d2d18e6`
  ([ref][28])
[28]: https://developer.openstack.org/api-ref/compute/?expanded=show-flavor-details-detail,show-server-details-detail#show-server-details
+ HTTP header:
    1. User-Agent: `python-novaclient`
    2. Accept: `application/json`
    3. X-Auth-Token: `ccc5f650029b710c4a3c8f20320afaaed04326f1`
+ JSON payload: none
+ Response:
<pre class="brush:bash;">
{
   "server":{
      "OS-EXT-STS:task_state":"scheduling",
      "addresses":{
      },
      "links":[
         {
            "href":"http://10.0.2.15:8774/v2.1/servers/3d79d699-16c7-4f99-b034-57403d2d18e6",
            "rel":"self"
         },
         {
            "href":"http://10.0.2.15:8774/servers/3d79d699-16c7-4f99-b034-57403d2d18e6",
            "rel":"bookmark"
         }
      ],
      "image":{
         "id":"9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
         "links":[
            {
               "href":"http://10.0.2.15:8774/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
               "rel":"bookmark"
            }
         ]
      },
      "OS-EXT-STS:vm_state":"building",
      "OS-EXT-SRV-ATTR:instance_name":"",
      "OS-SRV-USG:launched_at":null,
      "flavor":{
         "id":"a5178caf-6b3a-49ec-ab47-a6daaf05423e",
         "links":[
            {
               "href":"http://10.0.2.15:8774/flavors/a5178caf-6b3a-49ec-ab47-a6daaf05423e",
               "rel":"bookmark"
            }
         ]
      },
      "id":"3d79d699-16c7-4f99-b034-57403d2d18e6",
      "user_id":"277d3bed50964145998606c8a66982fd",
      "OS-DCF:diskConfig":"MANUAL",
      "accessIPv4":"",
      "accessIPv6":"",
      "progress":0,
      "OS-EXT-STS:power_state":0,
      "OS-EXT-AZ:availability_zone":"",
      "metadata":{
      },
      "status":"BUILD",
      "updated":"2017-03-03T23:02:45Z",
      "hostId":"",
      "OS-EXT-SRV-ATTR:host":null,
      "OS-SRV-USG:terminated_at":null,
      "key_name":null,
      "OS-EXT-SRV-ATTR:hypervisor_hostname":null,
      "name":"tt1",
      "created":"2017-03-03T23:02:45Z",
      "tenant_id":"3b2594f2569542f694ff346a6db7fa1e",
      "os-extended-volumes:volumes_attached":[
      ],
      "config_drive":""
   }
}
</pre>

## Get user image detail

+ Service: Glance
+ Method: `GET`
+ Endpoint: `/v2/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a` ([ref][23])
+ HTTP header:
    1. Accept-Encoding: `gzip, deflate`
    2. Accept: `*/*`
    3. User-Agent: `python-glanceclient`
    4. Connection: `keep-alive`
    5. X-Auth-Token: `ccc5f650029b710c4a3c8f20320afaaed04326f1`
    6. Content-Type: `application/octet-stream`
+ JSON payload: none
+ Response:
<pre class="brush:bash;">
{
   "status":"active",
   "name":"cirros-0.3.4-x86_64-uec",
   "tags":[
   ],
   "kernel_id":"ef538456-704c-445c-a98b-c081be22ad71",
   "container_format":"ami",
   "created_at":"2017-03-03T22:38:57Z",
   "ramdisk_id":"1a243f7b-3e96-4140-8408-b82064599cec",
   "disk_format":"ami",
   "updated_at":"2017-03-03T22:38:58Z",
   "visibility":"public",
   "self":"/v2/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
   "min_disk":0,
   "protected":false,
   "id":"9794e5b3-b3f1-403c-b37a-19c7e07cca4a",
   "size":25165824,
   "file":"/v2/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a/file",
   "checksum":"eb9139e4942121f22bbc2afc0400b2a4",
   "owner":"3b2594f2569542f694ff346a6db7fa1e",
   "virtual_size":null,
   "min_ram":0,
   "schema":"/v2/schemas/image"
}
</pre>

## Get flavor detail

+ Service: Nova
+ Method: `GET`
+ Endpoint: `/v2.1/flavors/a5178caf-6b3a-49ec-ab47-a6daaf05423e` ([ref][25])
+ HTTP header:
    1. User-Agent: `python-novaclient`
    2. Accept: `application/json`
    3. X-Auth-Token: `ccc5f650029b710c4a3c8f20320afaaed04326f1`
+ JSON payload: none
+ Response:
<pre class="brush:bash;">
{
   "flavor":{
      "links":[
         {
            "href":"http://10.0.2.15:8774/v2.1/flavors/a5178caf-6b3a-49ec-ab47-a6daaf05423e",
            "rel":"self"
         },
         {
            "href":"http://10.0.2.15:8774/flavors/a5178caf-6b3a-49ec-ab47-a6daaf05423e",
            "rel":"bookmark"
         }
      ],
      "ram":1280,
      "OS-FLV-DISABLED:disabled":false,
      "os-flavor-access:is_public":true,
      "rxtx_factor":1.0,
      "disk":10,
      "id":"a5178caf-6b3a-49ec-ab47-a6daaf05423e",
      "name":"baremetal",
      "vcpus":1,
      "swap":"",
      "OS-FLV-EXT-DATA:ephemeral":0
   }
}
</pre>
