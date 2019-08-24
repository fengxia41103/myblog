Title: Devstack & Heat
Date: 2017-02-27 17:00
Tags: lenovo
Slug: heat devstack
Author: Feng Xia
Status: Draft

Setting up [Heat][1] with [Openstack Devstack][2] is straightforward
once user realizes that the official [instructions][3] is not
up to date. In the doc there are two ways to enable Heat service:

1. Enable as a service:

        [[local|localrc]]

        # Enable heat services
        enable_service h-eng h-api h-api-cfn h-api-cw
    
2. Enable as a plugin:
    
        [[local|localrc]]

        #Enable heat plugin
        enable_plugin heat https://git.openstack.org/openstack/heat

The gotcha is that **do not use both**! As a matter of fact, for newer
devstack, the only method that works is the plugin.

[1]: https://wiki.openstack.org/wiki/Heat
[2]: https://docs.openstack.org/developer/devstack/
[3]: https://docs.openstack.org/developer/heat/getting_started/on_devstack.html
 
Devstack takes a long time to stand up. As a newbie, once you have
created a stack, you also need to issue the following commands in
devstack VM in order to enable SSH to your new VMs:

```shell
openstack security group rule create --proto icmp --dst-port 0 default
openstack security group rule create --proto tcp --dst-port 22 default
```

Again, not that [official document][4] didn't tell you. It's just
buried deep and hard to find.

[4]: https://docs.openstack.org/developer/devstack/networking.html

Here is the __local.conf__ used:

```shell
#OFFLINE=true

# Credentials
ADMIN_PASSWORD=natalie
DATABASE_PASSWORD=natalie
RABBIT_PASSWORD=natalie
SERVICE_PASSWORD=natalie
SERVICE_TOKEN=natalie
SWIFT_HASH=natalie
SWIFT_TEMPURL_KEY=natalie


# Enable Ironic plugin
enable_plugin ironic git://git.openstack.org/openstack/ironic

# Enable Neutron which is required by Ironic and disable nova-network.
disable_service n-net
disable_service n-novnc
enable_service q-svc
enable_service q-agt
enable_service q-dhcp
enable_service q-l3
enable_service q-meta
enable_service neutron
​
# Enable Swift for agent_* drivers
enable_service s-proxy
enable_service s-object
enable_service s-container
enable_service s-account

# Swift temp URL's are required for agent_* drivers.
SWIFT_ENABLE_TEMPURLS=True

# Create 3 virtual machines to pose as Ironic's baremetal nodes.
IRONIC_VM_COUNT=3
IRONIC_VM_SSH_PORT=22
IRONIC_BAREMETAL_BASIC_OPS=True
DEFAULT_INSTANCE_TYPE=baremetal

# Enable Ironic drivers.
IRONIC_ENABLED_DRIVERS=fake,agent_ssh,agent_ipmitool,pxe_ssh,pxe_ipmitool

# Change this to alter the default driver for nodes created by devstack.
# This driver should be in the enabled list above.
IRONIC_DEPLOY_DRIVER=agent_ipmitool

# The parameters below represent the minimum possible values to create
# functional nodes.
IRONIC_VM_SPECS_RAM=1280
IRONIC_VM_SPECS_DISK=10

# Size of the ephemeral partition in GB. Use 0 for no ephemeral partition.
IRONIC_VM_EPHEMERAL_DISK=0

# To build your own IPA ramdisk from source, set this to True
IRONIC_BUILD_DEPLOY_RAMDISK=False

VIRT_DRIVER=ironic

# By default, DevStack creates a 10.0.0.0/24 network for instances.
# If this overlaps with the hosts network, you may adjust with the
# following.
NETWORK_GATEWAY=10.1.0.1
FIXED_RANGE=10.1.0.0/24
FIXED_NETWORK_SIZE=256

# Log all output to files
LOGFILE=/tmp/devstack.log
LOGDIR=$HOME/logs
IRONIC_VM_LOG_DIR=$HOME/ironic-bm-logs

[[local|localrc]]
#Enable heat services
#enable_service h-eng h-api h-api-cfn h-api-cw
#Enable heat plugin
enable_plugin heat https://git.openstack.org/openstack/heat
ENABLED_SERVICES+=,heat,h-api,h-api-cfn,h-api-cw,h-eng
IMAGE_URL_SITE="http://download.fedoraproject.org"
IMAGE_URL_PATH="/pub/fedora/linux/releases/25/CloudImages/x86_64images/"
IMAGE_URL_FILE="Fedora-Cloud-Base-25-1.3.x86_64.qcow2"
IMAGE_URLS+=","$IMAGE_URL_SITE$IMAGE_URL_PATH$IMAGE_URL_FILE
```
