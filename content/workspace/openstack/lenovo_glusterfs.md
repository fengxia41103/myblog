Title: Enable GlusterFS and Virtualization on CIMP
Date: 2017-04-12 11:00
Tags: lenovo
Slug: lenovo glusterfs
Author: Feng Xia
Status: Draft


> Pre-requirement:
> 
> All the CIMP nodes have CentOS  installed with basic packages;
> All the CIMP nodes have logical networks configured, and each of them can reach to others via Internal management network;
> All the CIMP nodes have a disk partition configured on /dev/sdb2

In order to support high availability (HA) feature for control plane
applications, we decided to use GlusterFS to provide file system
HA. With the help of GlusterFS, we can support live-migration of VMs
from one CIMP node to another. GlusterFS also helps to replicate the
snapshots of VMs to othe CIMP nodes, so that no data loss is expected
even one CIMP node is down.

Running on CIMP nodes, Openstack Controller VMs already protected with
HA mechanism build on Pacemaker. Thus, there is little benefit to
provide file system level HA for Openstack Controller VMs. So
Openstack Controller images are stored on `/var/controller/running`
directory, which is not mounted to glusterFS.

Roller and XClarity don't have any native HA feature implemented. The
proposed design is to store Roller and XClarity running image on
GlusterFS cluster, e.g. `/var/images/running`. All the snapshots will
be stored on this directory also. The rest of this document will
further explain how to setup GlusterFS.

# Configure Communication Between Nodes

Confirm that you can `ping` all the CIMP nodes using their IP,
eg. `192.0.23.1`.  Setup hostname resolution or DNS for all the CIMP
nodes as shown below.  Now we need to make sure we can communicate
with the machines by their host name. If you have a DNS server, add
additional entries for all CIMP ndoes. Alternatively, you'll need to add
the machines to `/etc/hosts` on all nodes (`cimp-node2` shown below):

```shell
# cat /etc/hosts

127.0.0.1   cimp-node2 localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         cimp-node2 localhost localhost.localdomain localhost6 localhost6.localdomain6
192.0.23.1 cimp-node1
192.0.23.2 cimp-node2
192.0.23.3 cimp-node3
```

We can now verify the setup by `ping cimp-node[x]`.

# Install GlusterFS package

> Execute for each node.

GlusterFS version `3.8.7` is recommended for ThinkAgile CIMP nodes. To
install GlusterFS, download the compressed file of the following RPMs
from [rpm files][1] to `/tmp` directory and run `yum install *.rpm` 
to install all the packages.

[1]: http://cowork.us.lenovo.com/teams/openstack/SiteAssets/SitePages/Lenovo%20ThinkAgile%20Ceph/rpms.tar​ 

```shell
attr-2.4.46-12.el7.x86_64.rpm
epel-release-latest-7.noarch.rpm
glusterfs-3.8.7-1.el7.x86_64.rpm
glusterfs-api-3.8.7-1.el7.x86_64.rpm
glusterfs-cli-3.8.7-1.el7.x86_64.rpm
glusterfs-client-xlators-3.8.7-1.el7.x86_64.rpm
glusterfs-fuse-3.8.7-1.el7.x86_64.rpm
glusterfs-libs-3.8.7-1.el7.x86_64.rpm
glusterfs-server-3.8.7-1.el7.x86_64.rpm
gssproxy-0.4.1-13.el7.x86_64.rpm
keyutils-1.5.8-3.el7.x86_64.rpm
libbasicobjects-0.1.1-27.el7.x86_64.rpm
libcollection-0.6.2-27.el7.x86_64.rpm
libevent-2.0.21-4.el7.x86_64.rpm
libini_config-1.3.0-27.el7.x86_64.rpm
libnfsidmap-0.25-15.el7.x86_64.rpm
libpath_utils-0.2.1-27.el7.x86_64.rpm
libref_array-0.1.5-27.el7.x86_64.rpm
libtalloc-2.1.6-1.el7.x86_64.rpm
libtevent-0.9.28-1.el7.x86_64.rpm
libtirpc-0.2.4-0.8.el7.x86_64.rpm
libverto-tevent-0.2.5-4.el7.x86_64.rpm
nfs-utils-1.3.0-0.33.el7_3.x86_64.rpm
psmisc-22.20-11.el7.x86_64.rpm
quota-4.01-14.el7.x86_64.rpm
quota-nls-4.01-14.el7.noarch.rpm
rpcbind-0.2.0-38.el7.x86_64.rpm
sysstat-10.1.5-7.el7.x86_64.rpm
tcp_wrappers-7.6-77.el7.x86_64.rpm
userspace-rcu-0.7.16-1.el7.x86_64.rpm​
```

After the installation, use the following command to verify:

```shell
$ gluster --version

glusterfs 3.8.7 built on Dec 14 2016 04:49:31
Repository revision: git://git.gluster.com/glusterfs.git
...
```

# Install KVM/Libvirt package

> Execute for each node.

```shell
$ sudo yum update
$ sudo yum install qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer
```

# Install KVM/Libvirt package

> Execute for each node.

```shell
$ sudo systemctl start libvirtd
$ sudo  systemctl enable libvirtd
$ sudo systemctl start glusterd
$ sudo systemctl enable glusterd
$ sudo systemctl status glusterd
```

<figure class="s12 center">
<img     src="http://cowork.us.lenovo.com/teams/openstack/SiteAssets/SitePages/GlusterFS-setup/glusterfs%20status.png" />
<figcaption>Install KVM/libvirt packages</figcaption>
</figure>

# Configure firewall

> Execute for each node.

```shell
$ sudo firewall-cmd --zone=public --add-port=111/tcp --add-port=139/tcp --add-port=445/tcp --add-port=965/tcp --add-port=2049/tcp --add-port=38465-38469/tcp --add-port=24007-24008/tcp --add-port=631/tcp --add-port=111/udp --add-port=963/udp --add-port=49152-49251/tcp  --permanent
$ sudo firewall-cmd --zone=public --add-port=5900-5910/tcp  --permanent
$ sudo firewall-cmd --reload
```

<figure class="s12 center">
<img src="http://cowork.us.lenovo.com/teams/openstack/SiteAssets/SitePages/GlusterFS-setup/firewall.png" />
<figcaption>Setup firewall</figcaption>
</figure>

# Configure GlusterFS

## Build GlusterFS brick

> Execute for each node.

```shell
$ sudo pvcreate /dev/sdb2
$ sudo vgcreate vg_gluster /dev/sdb2
$ sudo lvcreate -l 100%FREE -n brick-img vg_gluster
$ sudo mkfs.xfs /dev/vg_gluster/brick-img
```

Note: alternatively you can use `lvcreate -L 1000G` switch if the
known free space is exactly 1000G. However, if nodes were
partititioned differently, it is easier to use the `-l 100%FREE`
(lower case "L") switch, which will take all the free space available to create a new logic volume `brick-img`. Snapshot below actually shows both commands, where `-L 1000G` failed with error `insufficient free space`.

<figure class="row">
    <img class="img-responsive center"
    src="http://cowork.us.lenovo.com/teams/openstack/SiteAssets/SitePages/GlusterFS-setup/configure%20glusterfs.png"/>
    <figcaption>Create logic volume used by Glusterfs</figcaption>
</figure>

After configure the brick, use `lsblk` command to verify it. The
output should look similar to the following:

<figure class="row">
    <img class="img-responsive center"
    src="http://cowork.us.lenovo.com/teams/openstack/SiteAssets/SitePages/GlusterFS-setup/verify%20logical%20volume.png"/>
    <figcaption>Verify logical volume</figcaption>
</figure>

Then, mount the brick to a directory:

```shell
$ sudo mkdir –p /var/brick-img
$ sudo  mount /dev/vg_gluster/brick-img /var/brick-img
```

To make this mount persistent, add the following line in the `/etc/fstab`:

```shell
/dev/vg_gluster/brick-img /var/brick-img            xfs defaults 0 0
```

Check the mount point:

```shell
$ sudo mount -a && mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)

...

tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,size=52761800k,mode=700,uid=1000,gid=1000)
/dev/mapper/vg_gluster-brick--img on /var/brick-img type xfs (rw,relatime,attr2,inode64,noquota)
```


## Configure trusted pool

> Execute on `cimp-node1`

```shell
$ gluster peer probe cimp-node2
$ gluster peer probe cimp-node3
$ gluster peer status
```

<figure class="row">
    <img class="img-responsive center"
    src="http://cowork.us.lenovo.com/teams/openstack/SiteAssets/SitePages/GlusterFS-setup/gluster%20peer%20status.png"/>
    <figcaption>Configure trusted pool</figcaption>
</figure>

## Create GlusterFS volume

> Execute on `cimp-node1`

```shell
$ sudo gluster volume create vol-1 replica 3 cimp-node1:/var/brick-img/running cimp-node2:/var/brick-img/running cimp-node3:/var/brick-img/running
$ sudo gluster volume start vol-1
```

Confirm the Gluster volume running:

```shell
[root@cimp-node1 ~]# gluster volume info all
Volume Name: vol-1
Type: Replicate
Volume ID: e2adeb6c-e0ac-4696-8d9f-940536a6f525
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: cimp-node1:/var/brick-img/running
Brick2: cimp-node2:/var/brick-img/running
Brick3: cimp-node3:/var/brick-img/running
Options Reconfigured:
transport.address-family: inet
performance.readdir-ahead: on
nfs.disable: on
```

## Use the GlusterFS volume as a shared storage pool

> Execute for each node.

The following commands are using `cimp-node1` as example.  They should
be executed on each CIMP node by replacing `cimp-node[x]` with proper
host name index, eg. `cimp-node2`.

Create a new directory as a place holder of all the VM images and
snapshots that requires GlusterFS as the backend storage pool.

```shell
$ sudo mkdir -p /var/images/running
```

Then, mount the GlusterFS volume to the new directory:

```shell
$ sudo mount -t glusterfs cimp-node1:/vol-1 /var/images/running
```

To make the mount persistent, the mount entry should be added to `/etc/fstab`:

```shell
cimp-node1:vol-1  /var/images/running glusterfs defaults,_netdev 0 0
```
 
Finally, enable `virt_use_fusefs`:

```shell
$ sudo setsebool -P virt_use_fusefs 1
```

## Modify default logging configuration

> Execute for each node.

Modify the following configuration at `/etc/logrotate.d/glusterfs` 
to keep 4 weeks backlog only.

```shell
$ nano /etc/logrotate.d/glusterfs

rotate 52 --> rotate 4
```

# Testing and troubleshooting

Test the GlusterFS setup by writing a new file to the 
`/var/imags/running` from one CIMP node, and 
make sure it replicates automatically to all the other CIMP nodes.

If the directory is read-only, it usually indicates the GlusterFS cluster is not formed either because of networking connection issues or firewall issue.

```shell
[root@cimp-node1 ~]# gluster peer status
Number of Peers: 2

Hostname: cimp-node2
Uuid: c20929dd-3ef1-432f-8d51-ca61ac74f9b2
State: Peer in Cluster (Connected)

Hostname: cimp-node3
Uuid: 31c93891-45da-4162-a27a-63ac87903304
State: Peer in Cluster (Connected)
```

If all the gluster peers are connected, but the problem is still persistent, you should look into the firewall rules to make sure the port required by the gluster operation is open.

As a reference, the followings are the firewall ports enabled on my setup:

```shell
Chain IN_public_allow (1 references)

target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ssh ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpts:24007:24008 ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:netbios-ssn ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpts:38465:38469 ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ipp ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpts:rfb:cm ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:965 ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:sunrpc ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:microsoft-ds ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:nfs ctstate NEW
ACCEPT     udp  --  anywhere             anywhere             udp dpt:sunrpc ctstate NEW
ACCEPT     udp  --  anywhere             anywhere             udp dpt:963 ctstate NEW
ACCEPT     tcp  --  anywhere             anywhere             tcp dpts:49152:49251 ctstate NEW
```
