Title: Juju local LXD
Date: 2017-09-06 13:21
Tags: lenovo
Slug: juju local LXD
Author: Feng Xia

Using Juju's [LXD provider][1] is the least-hassle way to start an
experience of Juju and its charms. However, if you have done charm
development for a while, you know making a one line of code change,
deploying charm, then wait to see the _new_ code got executed &larr;
it's good 5-10 minutes per cycle. These add up quickly when you are in
the middle of churning out code to get your ideas written. Not to
mention creating a new `machine` is 2x slower, and bootstraping a new
controller is even worse. I had experience in Shanghai sitting 30+
minutes for a new controller due to the location's unreliable
connections, and sometimes it just failed w/ a timeout. 

[1]: https://jujucharms.com/docs/2.0/clouds-LXD

What to do? The goal is to create a way to reduce this trial-error
cycle as much as possible so to speed up code development.

# Challenge

If you watch `juju debug-log` while it deploys a charm, you start to
realize that there are roughly seven steps:

1. creating a container (will discuss `--to` switch later)
2. update/upgrade the new container
3. provisioning container with Juju agent
4. installing charm software. This itself includes:
   1. transfering charm files to container
   2. installing `/wheelhouse` packages
5. run charm's `hooks/install` to kick of charm code

The last step is what we care about, the rest are there to construct a
runtime environment for charm code. So, can we eliminate them or
reduce them?

Also, the most time consuming pieces are when Juju/agent is hitting
a remote repo for system update or package installation. Therefore,
limiting these is greatly desired.

# Remedy

Strategy we are to present here is to use a custom-built image so that
it has **all** required package pre-installed. This does not eliminate
repo-hit completly, but it reduces the necessity of downloading 100+M
of packages, each time! Package installer (`apt`, `yum`, `pip` ) will
simply reply _package xyz is already installed_ &mdash; much faster.

## create a gold image

First, we create a gold copy that has everything pre-installed,
pre-configured as much as you'd like to:

1. Follow [instruction][2] to launch a standard image:
    <pre class="brush:plain">
    $ lxc launch ubuntu:14.04 gold
    </pre>
2. SSH to your new container, install system packages:
    <pre class="brush:plain">
    $ lxc exec gold bash
    $ apt update
    $ apt install build-essential libssl-dev libffi-dev python-pip python-dev
    </pre>
3. Update user `ubuntu`'s password:
    <pre class="brush:plain">
    $ passwd ubuntu
    </pre>
4. Enable SSH password authentication:
    <pre class="brush:plain">
    $ nano /etc/ssh/sshd_config
    # Change to no to disable tunnelled clear text passwords
    PasswordAuthentication yes # <-- change to "yes"
    </pre>
5. Upgrade `pip`. This is necessary to install `/wheelhouse` contents properly.
    <pre class="brush:plain">
    $ pip install pip --upgrade
    </pre>
6. In your charm's dist, there will be a `/wheelhouse` folder, which
   hosts a list of `.gz` files and such. They are python packages
   needed by charm. Since they are packages into each charm, it makes
   file transfer to container slower, and installing them is rather
   redundant if a container is hosting multiple charms.

    Using `scp` and `ubuntu` credential (see step #3) to copy
    `/wheelhouse` to container. Install them:
     <pre class="brush:plain">
     $ pip install wheelhouse/*
     </pre>
     
7. Any other customization you have in mind, go ahead with it.

[2]: https://insights.ubuntu.com/2016/03/22/lxd-2-0-your-first-lxd-container/

## create an image for Juju

Using the gold image, we are a few command lines away to create a new
LXD image Juju (2.1+) uses when creating a new machine:

1. Create a snapshot of the `gold` image:
    <pre class="brush:plain">
    $ lxc snapshot gold
    </pre>
2. To verify snapshot, `lxc info gold`, an example output:
    <pre class="brush:plain">
    fengxia@local-charmdev:$ lxc info gold
    Name: gold
    Remote: unix:/var/lib/lxd/unix.socket
    Architecture: x86_64
    Created: 2017/08/30 21:13 UTC
    Status: Running
    Type: persistent
    Profiles: default
    Pid: 1858
    Ips:
      eth0:	inet	10.129.186.150	vethWQ2SSG
      eth0:	inet6	fe80::216:3eff:fede:5152	vethWQ2SSG
      lo:	inet	127.0.0.1
      lo:	inet6	::1
    Resources:
      Processes: 15
      Memory usage:
        Memory (current): 18.14MB
        Memory (peak): 116.85MB
      Network usage:
        eth0:
          Bytes received: 30.95kB
          Bytes sent: 7.24kB
          Packets received: 286
          Packets sent: 64
        lo:
          Bytes received: 0B
          Bytes sent: 0B
          Packets received: 0
          Packets sent: 0
    Snapshots:
      snap3 (taken at 2017/09/04 00:18 UTC) (stateless)
    </pre>
3. Export snapshot to an image. Note: the [alias format][3] is
    significant (<span class="myhighlight">"juju/$series/$arch"</span>).
    <pre class="brush:plain">
    $ lxc publish gold/snap3 --alias juju/trusty/amd64
    </pre>

You can verify image by `lxc image list`. A sample output:
<pre class="brush:plain">
fengxia@local-charmdev:~$ lxc image list
+------------------------+--------------+--------+-----------------------------------------------+--------+----------+------------------------------+
|         ALIAS          | FINGERPRINT  | PUBLIC |                  DESCRIPTION                  |  ARCH  |   SIZE   |         UPLOAD DATE          |
+------------------------+--------------+--------+-----------------------------------------------+--------+----------+------------------------------+
| juju/trusty/amd64      | b95d3291e3ae | no     |                                               | x86_64 | 377.03MB | Sep 6, 2017 at 2:10pm (UTC)  |
+------------------------+--------------+--------+-----------------------------------------------+--------+----------+------------------------------+
| ubuntu-xenial (1 more) | 58f90cbf6892 | no     | ubuntu 16.04 LTS amd64 (release) (20170815.1) | x86_64 | 154.11MB | Aug 17, 2017 at 4:19pm (UTC) |
+------------------------+--------------+--------+-----------------------------------------------+--------+----------+------------------------------+
</pre>

[3]: https://bugs.launchpad.net/juju/+bug/1650651
[4]: https://jujucharms.com/docs/2.2/reference-install)

# To use gold image

There are two ways to use the gold copy &mdash; either have Juju
automatically use this image for new machine (requires Juju v2.1+), or
create machines **manually**, for example, via an external
orchestration tool.

## Juju uses gold image

The only requirement is to have Juju version 2.1+.

1. (optional) Delete standard LXD image:
    <pre class="brush:python">
    $ lxc image delete ubuntu-trusty
    </pre>
2. Update juju to 2.1+:
    <pre class="brush:python">
    $ sudo snap install juju --classic
    </pre>
3. After upgrading juju, re-bootstrap a controller (`juju bootstrap
   localhost [pick a name]`).
4. `juju deploy mycharm`: will create a new machine using a local
   image w/ alias `juju/trusty/amd64` for new machine. This can be
   verified by `watch -n 1 lxc image list` to monitor whether it will
   still download a stock image.

## add machine manually

If there is other orchestration mechanism outside Juju, we can also
have it create machines _manually_:

1. Create a new LXD container using the image (or snapshot):
    <pre class="brush:plain">
    $ lxc launch juju/trusty/amd64 testme && lxc start testme
    $ lxc copy gold/snap3 testme && lxc start me
    </pre>
2. Add machine to Juju:
    <pre class="brush:plain">
    $ juju add-machine ssh:ubuntu@[container's ip]
    </pre>
3. `juju deploy mycharm --to [machine #]`. Without the `--to`, Juju
   will create a new machine by default. <span class="myhighlight">Be aware.</span>

# No more update

To speed up the machine even further, we need to disable system
update (on by default) so newly created machine (by Juju) will not hit
repo for system updates.

<pre class="brush:plain">
$ juju model-config enable-os-refresh-update=false
$ juju model-config enable-os-upgrade=false
</pre>

# Comparison results
