Title: Openstack Ironic
Date: 2017-03-15 22:45
Tags: openstack
Slug: ironic intro
Author: Feng Xia
Status: Draft

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
       + `ipmi_username` 
       + `ipmi_password`: in devstack, default to "password"
       + `ipmi_address`
       + `deploy_kernel`: in devstack, it is "ir-deploy-agent_ipmitool.kernel".
       + `deploy_ramdisk`: in devstack, it is
         "ir-deploy-agent_ipmitool.initramfs"
4. `driver_internal_info` (read-only): this field is not accessible
   via API. Used by driver to store internal information.
   + `agent_url`: this is the callback URL to the Ironic Python Agent (IPA)
     running on the node (when an agent ramdisk image is selected). We
     will cover more of IPA later. The value is filled in when the IPA
     calls Ironic's `/v1/heartbeat` endpoint.
5. `instance_info`: is populated when the node is provisioned.
6. `properties` (<font color="red">required</font>): Physical
   characteristics of this Node. Populated by ironic-inspector during
   inspection. Can also be set via the REST API at any time. These
   values are used by NOVA to match flavor &mdash; an important aspect
   of _baremetal management_ is to filter what a workload wants
   vs. what we have, and the values in `properties` define what we
   have.

The rest of the fields are self-explanatory so I'll skip them for now.

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
PXE.


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

Now how does Ironic conductor interact with this agent? [TBD]

## Provision process &mdash; Agent
Source by [devananda github][18].
[18]: https://github.com/devananda/talks/tree/master/images

<figure class="row">
    <img class="img-responsive center-block"
    src="https://github.com/devananda/talks/blob/master/images/deploy_with_agent.png?raw=true" />
    <figcaption>Ironic deploy &mdash; Agent</figcaption>
</figure>

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

## Using NOVA API to create an instance

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

<table class="table">
    <thead>
        <th>Index</th>
        <th>Call</th>
        <th>Service</th>
        <th>Endpoint</th>
        <th>HTTP Header</th>
        <th>JSON Payload</th>
        <th>Response</th>
        <th>Note</th>
    </thead>
    <tbody>
      <!-- Get basic information from Keystone API -->
        <tr><td>1</td><td>
            GET
        </td><td>
            Keystone
        </td><td>
            /identity/v3
        </td><td>
          None
        </td><td>
            <ol>
                <li>Accept: application/json</li>
                <li>User-Agent: osc-lib/1.3.0 keystoneauth1/2.18.0 python-requests/2.12.5 CPython/2.7.12" </li>
            </ol>
        </td><td>
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
    </td><td>
    
    </td></tr>
    
    <!-- Get security token from Keystone API -->
    <tr><td>2</td><td>
        POST
    </td><td>
        Keystone
    </td><td>
        /identity/v3/auth/tokens
    </td><td>
        <ol>
            <li>Content-Type: "application/json"</li>
        </ol>
    </td><td>
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
    </td><td>
    Too long to paste.
    </td><td>
      The token is in HTTP header "X-Subject-Token" field.
    </td></tr>

    <!-- Get user image meta data -->
    <tr><td>3</td><td>
        Glance
    </td><td>
        GET
    </td><td>
        /v2/images/9794e5b3-b3f1-403c-b37a-19c7e07cca4a
    </td><td>
        <ol>
            <li>Accept-Encoding: gzip, deflate</li>
            <li>Accept: */*</li>
            <li>User-Agent: python-glanceclient</li>
            <li>Connection: keep-alive</li>
            <li>X-Auth-Token: ccc5f650029b710c4a3c8f20320afaaed04326f1</li>
            <li>Content-Type: application/octet-stream</li>
        </ol>
    </td><td>
      None
    </td><td>
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
    </td></tr>

    <!-- Get image schema -->
    <tr><td>4</td><td>
      Glance
    </td><td>
      GET
    </td><td>
    </td><td>
    </td><td>
      <pre class="brush:bash;">
{
   "additionalProperties":{
      "type":"string"
   },
   "name":"image",
   "links":[
      {
         "href":"{self}",
         "rel":"self"
      },
      {
         "href":"{file}",
         "rel":"enclosure"
      },
      {
         "href":"{schema}",
         "rel":"describedby"
      }
   ],
   "properties":{
      "status":{
         "readOnly":true,
         "enum":[
            "queued",
            "saving",
            "active",
            "killed",
            "deleted",
            "pending_delete",
            "deactivated"
         ],
         "type":"string",
         "description":"Status of the image"
      },
      "tags":{
         "items":{
            "type":"string",
            "maxLength":255
         },
         "type":"array",
         "description":"List of strings related to the image"
      },
      "kernel_id":{
         "pattern":"^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}$",
         "type":[
            "null",
            "string"
         ],
         "description":"ID of image stored in Glance that should be used as the kernel when booting an AMI-style image.",
         "is_base":false
      },
      "container_format":{
         "enum":[
            null,
            "ami",
            "ari",
            "aki",
            "bare",
            "ovf",
            "ova",
            "docker"
         ],
         "type":[
            "null",
            "string"
         ],
         "description":"Format of the container"
      },
      "min_ram":{
         "type":"integer",
         "description":"Amount of ram (in MB) required to boot image."
      },
      "ramdisk_id":{
         "pattern":"^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}$",
         "type":[
            "null",
            "string"
         ],
         "description":"ID of image stored in Glance that should be used as the ramdisk when booting an AMI-style image.",
         "is_base":false
      },
      "locations":{
         "items":{
            "required":[
               "url",
               "metadata"
            ],
            "type":"object",
            "properties":{
               "url":{
                  "type":"string",
                  "maxLength":255
               },
               "metadata":{
                  "type":"object"
               }
            }
         },
         "type":"array",
         "description":"A set of URLs to access the image file kept in external store"
      },
      "visibility":{
         "enum":[
            "community",
            "public",
            "private",
            "shared"
         ],
         "type":"string",
         "description":"Scope of image accessibility"
      },
      "updated_at":{
         "readOnly":true,
         "type":"string",
         "description":"Date and time of the last image modification"
      },
      "owner":{
         "type":[
            "null",
            "string"
         ],
         "description":"Owner of the image",
         "maxLength":255
      },
      "file":{
         "readOnly":true,
         "type":"string",
         "description":"An image file url"
      },
      "min_disk":{
         "type":"integer",
         "description":"Amount of disk space (in GB) required to boot image."
      },
      "virtual_size":{
         "readOnly":true,
         "type":[
            "null",
            "integer"
         ],
         "description":"Virtual size of image in bytes"
      },
      "id":{
         "pattern":"^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}$",
         "type":"string",
         "description":"An identifier for the image"
      },
      "size":{
         "readOnly":true,
         "type":[
            "null",
            "integer"
         ],
         "description":"Size of image file in bytes"
      },
      "instance_uuid":{
         "type":"string",
         "description":"Metadata which can be used to record which instance this image is associated with. (Informational only, does not create an instance snapshot.)",
         "is_base":false
      },
      "os_distro":{
         "type":"string",
         "description":"Common name of operating system distribution as specified in http://docs.openstack.org/trunk/openstack-compute/admin/content/adding-images.html",
         "is_base":false
      },
      "name":{
         "type":[
            "null",
            "string"
         ],
         "description":"Descriptive name for the image",
         "maxLength":255
      },
      "checksum":{
         "readOnly":true,
         "type":[
            "null",
            "string"
         ],
         "description":"md5 hash of image contents.",
         "maxLength":32
      },
      "created_at":{
         "readOnly":true,
         "type":"string",
         "description":"Date and time of image registration"
      },
      "disk_format":{
         "enum":[
            null,
            "ami",
            "ari",
            "aki",
            "vhd",
            "vhdx",
            "vmdk",
            "raw",
            "qcow2",
            "vdi",
            "iso",
            "ploop"
         ],
         "type":[
            "null",
            "string"
         ],
         "description":"Format of the disk"
      },
      "os_version":{
         "type":"string",
         "description":"Operating system version as specified by the distributor",
         "is_base":false
      },
      "protected":{
         "type":"boolean",
         "description":"If true, image will not be deletable."
      },
      "architecture":{
         "type":"string",
         "description":"Operating system architecture as specified in http://docs.openstack.org/trunk/openstack-compute/admin/content/adding-images.html",
         "is_base":false
      },
      "direct_url":{
         "readOnly":true,
         "type":"string",
         "description":"URL to access the image file kept in external store"
      },
      "self":{
         "readOnly":true,
         "type":"string",
         "description":"An image self url"
      },
      "schema":{
         "readOnly":true,
         "type":"string",
         "description":"An image schema url"
      }
   }
}      </pre>
    </td></tr>
    </tbody>
</table>

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

1. IPA's [hardware manager][9] &mdash; in-band only. Hardware manager
   is part of IPA's capability. They can run together with IPA to
   collect node information.
2. [Ironic Inspector][8] &mdash; in-band and out-of-band. Inspector is
   a separate service running outside the target node. It exposes a
   set of [API][10]. When caller `POST
   /v1/introspection/<node_indent>`, inspector uses the UUID to
   extract node's drive_info from Ironic DB. With the IPMI credentials
   it can now control the node. Its [in-band inspection][11] will boot
   a ramdisk. Inspector will then update node's `properties` field
   with values it collected.
[8]: https://docs.openstack.org/developer/ironic/deploy/inspection.html
[9]: https://docs.openstack.org/developer/ironic-python-agent/#hardware-managers
[10]: https://docs.openstack.org/developer/ironic-inspector/http-api.html#
[11]: https://docs.openstack.org/developer/ironic/deploy/inspection.html#in-band-inspection



