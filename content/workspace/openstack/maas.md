Title: Setup a MAAS Virtualbox lab
Date: 2016-12-08 10:45
Tags: openstack
Slug: maas virtualbox
Author: Feng Xia

Canonical [MAAS][1] is a deployment tool that can give a bare metal life by putting an OS on it. Working together with [Juju][2], they can setup a cluster of applications quite quickly. Think of them as a package manage like Ubuntu's **apt-get**, but in the context of a cloud. Interesting.

[1]: http://maas.io/
[2]: https://www.ubuntu.com/cloud/juju

This article shows how to setup a virtual lab so one can play with these two tools and get a sense of what they do. The whole setup is based on Virtualbox. One 
thing I found out the hard way is that despite their nice looking website and rather recent project history, there is no single document that can bring this environment live from A to Z. All official documents have out-of-date commands here and there which made following them useless. I consulted countless blogs, posts, chasing down bugs (or I thought they were bugs), and finally when everything works, it became so obvious and simple. Hopefully this article will shorten this journey for readers and they can have this environment easily.


# Baseline environment

1. Virtualbox 5.1.10 and its extension pack. I could not verify why this particular version worked. I had 5.1.8 and the first successful trial occurred after I upgraded to 5.1.10. Was that a coincidence? Without being able to reproduce this, I am merely documenting what I have.

# Network topology

Getting network configurations right is the key for success. The biggest **gotcha** is that MAAS server **must** be the DHCP server on its managing subnet! The official document talks about "if there is an existing DHCP, points it to the MAAS server", huh? I never figured that out, so don't listen to that.

There will be two VMs and one internal network, "**intnet1**".

1. **VM #1** is the MAAS server. Use Xenial 16.04 desktop image.
2. **VM #2** is an emulated BM. 
3. **intnet1** is a subnet (192.168.8.0/24) that MAAS server will live together with its managed nodes (I call them targets).

<figure class="row">
<img src="/images/maas_networking_topology.png" class="center-block img-responsive" />
<figcaption>MAAS Virtualbox lab networking topology</figcaption>
</figure>

# Setup instructions

Personally I dislike those step-by-step instructions because first of all, it is intimidating; secondly, each environment is a bit different, so how confident user will feel to duplicate other's success? Not much. I'll explain thoughts and lessons learned along the way. I think that is more useful even from the point that Google may pick up a few words here and will help others if they search.

## Install MAAS server, admin account, subnet

MAAS server uses Ubuntu 16.04 Xenial desktop image. Setup the networking to have two interfaces &mdash; one uses
default NAT so you have internet access, while the other uses **Internal Network** with name **intnet1**.

> Defining the subnet managed by MAAS server is the most imporant step in MAAS configuration. 

1. Config subnet **intnet1**. Define it as **192.168.8.x** (This is completely arbitrary. Use whatever
   network range you want to use). Use _ifconfig_ to find out interface name that corresponds
   to _intnet1_ (a clue: the one that has no IP assigned):

    <pre class="brush:bash;">
    nano /etc/network/interfaces
    auto enp0s9
    iface enp0s9 inet static
      address 192.168.8.1
      netmask 255.255.255.0
      gateway 192.168.8.1
    </pre>

    At Virtualbox level we have added an interface to this VM using _Internal Network_, we need then define this network in VM. Also, defining this before installing MAAS will have MAAS installer pick up this subnet automatically so to save some manual work down the road.

2. Install MAAS is simple. Don't bother with other methods.
    <pre class="brush:bash;">
    sudo add-apt-repository ppa:maas/stable
    sudo apt update
    sudo apt install maas
    </pre>xo

3. Create MAAS admin: 
    <pre class="brush:bash;">
    sudo maas createadmin
    </pre>

4. Create SSH key and copy content from _.ssh/id_rsa.pub_:
    <pre class="brush:bash;">
    mkdir .ssh
    ssh-keygen -t rsa
    less ~/.ssh/id_rsa.pub
    </pre>

5. Login in _http://localhost:5240_ using admin created in step 3. At the step where it complains about SSH key missing,
    select **upload** and paste step 4's content into the text box. This is the public key that will be copied to each MAAS
    target at deployment so later you can SSH into these targets without knowing the password.

At this point, the MAAS server is installed and user can login the web admin console. Next, setup firewall rules on MAAS server so it can be the router for managed subnet.

## MAAS server firewall rules

Install [UFW][]. UFW is infinitely easier to use than iptables. Making the MAAS server as a router is necessary because targets, once acquired an OS, will need internet access in order to APT other things. (If using real metal server, the server can be connected to multiple VLANs among which one is providing internet access.)

[UFW]: https://help.ubuntu.com/community/UFW

### Masquerading

Following the [instructions][4] to enable default port forwarding:

[4]: https://help.ubuntu.com/lts/serverguide/firewall.html

1. Packet forwarding needs to be enabled in ufw. Two configuration files will need to be adjusted, in _/etc/default/ufw_ change the DEFAULT_FORWARD_POLICY to “ACCEPT”:
   <pre class="brush:bash;">
   DEFAULT_FORWARD_POLICY="ACCEPT"
   </pre>

2. Then edit _/etc/ufw/sysctl.conf_ and uncomment:
  <pre class="brush:bash;">
  net/ipv4/ip_forward=1
  net/ipv6/conf/default/forwarding=1
  </pre>
  
### Firewall policies

> Enabling UFW will deny all access (except the current ssh session). So before anything, allow port 22!

To config MAAS server to route 192.168.8.x subnet traffic to internet using UFW is simple. Using _ifconfig_ to find the interface name that is connected to the internet(NAT), in this example, enp0s3:
    <pre class="brush:bash;">
    nano /etc/ufw/before.rules
    </pre>

Paste this at the bottom of the file, **after** the _COMMIT_ that has already been in that document:
    <pre class="brush:bash;">
    # nat Table rules
    *nat
    :POSTROUTING ACCEPT [0:0]
    -A POSTROUTING -s 192.168.8.0/24 -o enp0s3 -j MASQUERADE
    COMMIT
    </pre>

What this does is to make **enp0s3** as the router for subnet 192.168.8.x &larr; welcome the internet!

### Ports

[UFW][] will erect a firewall that blocks everything by default! We have poked holes for port 22 to allow SSH. More need to be done:

1. Allow http 80: ufw allow http
2. Allow ping: ufw allow 53
3. Allow region controller API port: 5240
4. Allow Bootp server and client: 67, 68
5. Allow Img service: 5248
6. Allow tftp: 69, 5244
7. Allow domain service: 5246
8. Allow rndc service: 5247
9. Allow iscsi: 3260
10. Allow ntp: 123
11. Allow MAAS bootstrap sever: 8000

Finally, **ufw enable**. Our GFW is up.

## MAAS as DHCP server

> As I have mentioned, the MAAS server node **must** be the DHCP server on subnet 192.168.8.x. No exception!

MAAS admin web is the tool to use for this configuration. 

1. Login into _http://192.168.8.1/MAAS/_, goto **Subnets** and select
   the VLAN &larr; this is how you can turn on DHCP on a subnet:

    <figure class="row">
    <img src="/images/maas_vlan_config.png" class="center-block
    img-responsive" />
    <img src="/images/maas_subnet_config.png" class="center-block img-responsive" />    
    <figcaption>MAAS  DHCP config</figcaption>
    </figure>

2. Click **"Vlan"** to get to the Vlan configuration page. _Take action_ to enable DHCP. Change the gateway to 192.168.8.1, which is this server's static IP on this subnet.

    <figure class="row">
    <img src="/images/maas_dhcp_config.png" class="center-block img-responsive" />
    <figcaption>MAAS admin DHCP config</figcaption>
    </figure>


We have done the hard part &mdash; setting up the MAAS server. In our [next article][3], I'll show you what MAAS can do for fun &rarr; brining up a bare metal machine to life. Stay tuned.

[3]: {filename}/workspace/openstack/maas_target.md
