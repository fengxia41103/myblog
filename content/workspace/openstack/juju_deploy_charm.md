Title: Canonical Juju deploying charm
Date: 2017-01-19 15:45
Tags: openstack
Slug: juju deploy
Author: Feng Xia

We have covered Juju's [bootstrap][1] phase. In this article, we will
continue our research into another important function &mdash; juju deploy.

[1]: {filename}/workspace/openstack/juju_cloud_bootstrap.md


Deploy will command a node to pull down requested charm and install
whatever needed based the charm's instruction. As the bootstrap
research, I'm interested in the internal mechanism of this process,
the bare minimum to simulate a successful run, and the minimum steps
to repeat this for development and troubleshooting.

# Screencast

See the process in action:

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/juju%20deploy%20jenkins.gif" />
    <figcaption>Screencast of juju deploying Jenkins</figcaption>
</figure>

## Juju + MAAS

We have already covered state machine of [MAAS target node][3]. In the
context of deploying a charm driven by Juju, we can take a look MAAS internals
how those states are related.

[3]: {filename}/workspace/openstack/maas_target.md

<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20deploy%20target%20node%20state%20diagram.png" />
    <figcaption>MAAS target node state diagram during Juju deploy process</figcaption>
</figure>

# Deploy steps illustrated

This is a more detailed view of juju deploying a charm broken down
into three steps.

<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20deploy%20original.png" />
    <figcaption>Illustration of a Juju cloud environment before a deployment</figcaption>
</figure>

In this environment, we have a CLI controller where we will type in
juju commands, one state controller who manages the cloud, and one
machine running Mysql. The objective is to deploy a [Jenkins][2] charm
to a new machine (in <font color="green">green</font>) we have just
provisioned.

[2]: https://jujucharms.com/jenkins/

Broadly speaking, events of a juju deploy take four steps to get the
job done:

1. Add the new machine to juju's environment. A juju agent
   (aka. jujud) will be installed. More details are discussed 
   in the next section.
  <pre class="brush:plain;">
  $ juju add-machine ssh://[username]@192.168.8.235
  </pre>

2. Juju state controller (aka. machine-0) will recoganize the new
   machine and register its availability.

3. Issuing a deploy command
  <pre class="brush:plain;">
  $ juju deploy jenkinsn
  </pre>

4. Jujud will download [Jenkins charm][2] and execute per its instruction.

<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20deploy%20commands.png" />
    <figcaption>Issuing command to deploy Jenkins</figcaption>
</figure>

The result, as expected, is that we have now two machines in the
cloud, each equipped with an application, and both have a jujud
installed.

<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20deploy%20result.png" />
    <figcaption>Deployment result</figcaption>
</figure>


# What takes to be a good machine

In our previous example, we used _add-machine_ command to bring new
machine into the juju environment. As it turned out, one can add any
provisioned machine into the cloud (as long as it knows how to install
juju agent which is another topic). Now let's take a look what
installing an agent will do to this machine.

First We created a vanilla Xenial 16.04 server with certainly *no
knowledge* of juju. The only user account is under
_whateverusername_. We intentionally avoided using _ubuntu_ as user
because we know the bootstrap was relying on such an account. Will
juju complain of its missing? Let's find out.

<pre class="brush:plain;">
$ juju add-machine ssh://[username]@192.168.8.235
</pre>

What is interesting is to watch the node and figure out what is
installed by this command.

## /var/lib/juju

This is the *home* folder for juju &mdash; _/var/lib/juju_.  Remember,
this folder did not exist prior to the _add-machine_ command.

<pre class="brush:plain;">
/var/lib/juju
├── agents
│   └── machine-15
│       └── agent.conf
├── init
│   └── jujud-machine-15
│       ├── exec-start.sh
│       └── jujud-machine-15.service
├── locks
└── tools
    ├── 2.0.1.98-xenial-amd64
    │   ├── downloaded-tools.txt
    │   ├── FORCE-VERSION
    │   └── jujud
    └── machine-15 -> 2.0.1.98-xenial-amd64

8 directories, 6 files
</pre>

Pretty minimum. It designated a machine serial number &mdash; 15. This
magic number is apparently assigned by machine-0 because only it knows
the next index (this index is ever incremental). However, this index
is troublesome also because folders and files are created using this
index, and we have already seen system files are symbolic links to
them. So the challenge is to simulate this configuration process as if
it were done by juju. It is doable (copy files, create folders and so
forth), but will be tedious. 

## /etc

<pre class="brush:plain;">
/etc/apt/apt.conf.d/42-juju-proxy-settings
/etc/profile.d/juju-introspection.sh
/etc/sudoers.d/90-juju-ubuntu
/etc/systemd/system/jujud-machine-15.service
/etc/systemd/system/multi-user.target.wants/jujud-machine-15.service

root@192-168-8-235:~# ls -lh /etc/systemd/system | grep juju
lrwxrwxrwx 1 root root   60 Jan 19 16:47 jujud-machine-15.service -> /var/lib/juju/init/jujud-machine-15/jujud-machine-15.service
</pre>

You can use the common _service juju-machine-15
start|stop|restart|status_ to manage this service like any
others. 

## /usr/bin

Two binaries appeared, both linked (again) to some files under the
_/var/lib/juju/_ folder.

<pre class="brush:plain;">
/usr/bin/juju-dumplogs
/usr/bin/juju-run

root@192-168-8-235:~# ls -lh /usr/bin | grep juju
lrwxrwxrwx 1 root   root      36 Jan 19 16:47 juju-dumplogs -> /var/lib/juju/tools/machine-15/jujud
lrwxrwxrwx 1 root   root      36 Jan 19 16:47 juju-run -> /var/lib/juju/tools/machine-15/jujud
</pre>

## /usr/share

<pre class="brush:plain;">
/usr/share/sosreport/sos/plugins/juju.py
/usr/share/sosreport/sos/plugins/\_\_pycache\_\_/juju.cpython-35.pyc
</pre>

## /home/ubuntu

So juju's agent install process actually created a user *ubuntu* which
did not exist before. In _/home/ubuntu/.ssh_ folder, a file of
_authorized_keys_. Um.

<pre class="brush:plain;">
/home/ubuntu/.juju-proxy
</pre>

# Deploy an application

Once the node has been recognized by machine-0, it's ready to be used
by a juju deploy. Let's pick something _light_ (for example, an
application which will request only one node) to try.

Below is an *impressive* capture of the _/var/lib/juju_ contents when
deploying an application, in this case, jenkins.

  > Juju charm is a zip file. You can use command _unzip_ to extract
  > these contents under the /var/lib/juju/unit-jenkins-1/ folder.
  
<pre class="brush:plain;">
/var/lib/juju
├── agents
│   ├── machine-15
│   │   └── agent.conf
│   └── unit-jenkins-1
│       ├── agent.conf
│       ├── charm
│       │   ├── bin
│       │   │   └── layer_option
│       │   ├── config.yaml
│       │   ├── copyright
│       │   ├── hooks
│       │   │   ├── config-changed
│       │   │   ├── extension-relation-broken
│       │   │   ├── extension-relation-changed
│       │   │   ├── extension-relation-departed
│       │   │   ├── extension-relation-joined
│       │   │   ├── hook.template
│       │   │   ├── install
│       │   │   ├── leader-elected
│       │   │   ├── leader-settings-changed
│       │   │   ├── master-relation-broken
│       │   │   ├── master-relation-changed
│       │   │   ├── master-relation-departed
│       │   │   ├── master-relation-joined
│       │   │   ├── relations
│       │   │   │   ├── http
│       │   │   │   │   ├── __init__.py
│       │   │   │   │   ├── interface.yaml
│       │   │   │   │   ├── provides.py
│       │   │   │   │   ├── __pycache__
│       │   │   │   │   │   ├── __init__.cpython-35.pyc
│       │   │   │   │   │   ├── provides.cpython-35.pyc
│       │   │   │   │   │   └── requires.cpython-35.pyc
│       │   │   │   │   ├── README.md
│       │   │   │   │   └── requires.py
│       │   │   │   ├── jenkins-extension
│       │   │   │   │   ├── __init__.py
│       │   │   │   │   ├── interface.yaml
│       │   │   │   │   ├── provides.py
│       │   │   │   │   ├── __pycache__
│       │   │   │   │   │   ├── __init__.cpython-35.pyc
│       │   │   │   │   │   ├── provides.cpython-35.pyc
│       │   │   │   │   │   └── requires.cpython-35.pyc
│       │   │   │   │   ├── README.md
│       │   │   │   │   ├── requirements.txt
│       │   │   │   │   ├── requires.py
│       │   │   │   │   └── tox.ini
│       │   │   │   ├── jenkins-slave
│       │   │   │   │   ├── __init__.py
│       │   │   │   │   ├── interface.yaml
│       │   │   │   │   ├── provides.py
│       │   │   │   │   ├── __pycache__
│       │   │   │   │   │   ├── __init__.cpython-35.pyc
│       │   │   │   │   │   ├── provides.cpython-35.pyc
│       │   │   │   │   │   └── requires.cpython-35.pyc
│       │   │   │   │   ├── README.md
│       │   │   │   │   ├── requirements.txt
│       │   │   │   │   ├── requires.py
│       │   │   │   │   └── tox.ini
│       │   │   │   └── zuul
│       │   │   │       ├── __init__.py
│       │   │   │       ├── interface.yaml
│       │   │   │       ├── provides.py
│       │   │   │       ├── __pycache__
│       │   │   │       │   ├── __init__.cpython-35.pyc
│       │   │   │       │   ├── provides.cpython-35.pyc
│       │   │   │       │   └── requires.cpython-35.pyc
│       │   │   │       ├── README.md
│       │   │   │       ├── requirements.txt
│       │   │   │       ├── requires.py
│       │   │   │       └── tox.ini
│       │   │   ├── start
│       │   │   ├── stop
│       │   │   ├── update-status
│       │   │   ├── upgrade-charm
│       │   │   ├── website-relation-broken
│       │   │   ├── website-relation-changed
│       │   │   ├── website-relation-departed
│       │   │   ├── website-relation-joined
│       │   │   ├── zuul-relation-broken
│       │   │   ├── zuul-relation-changed
│       │   │   ├── zuul-relation-departed
│       │   │   └── zuul-relation-joined
│       │   ├── icon.svg
│       │   ├── layer.yaml
│       │   ├── lib
│       │   │   └── charms
│       │   │       ├── apt.py
│       │   │       ├── __init__.py
│       │   │       ├── layer
│       │   │       │   ├── basic.py
│       │   │       │   ├── execd.py
│       │   │       │   ├── __init__.py
│       │   │       │   ├── jenkins
│       │   │       │   │   ├── api.py
│       │   │       │   │   ├── configuration.py
│       │   │       │   │   ├── credentials.py
│       │   │       │   │   ├── __init__.py
│       │   │       │   │   ├── packages.py
│       │   │       │   │   ├── paths.py
│       │   │       │   │   ├── plugins.py
│       │   │       │   │   ├── __pycache__
│       │   │       │   │   │   ├── api.cpython-35.pyc
│       │   │       │   │   │   ├── configuration.cpython-35.pyc
│       │   │       │   │   │   ├── credentials.cpython-35.pyc
│       │   │       │   │   │   ├── __init__.cpython-35.pyc
│       │   │       │   │   │   ├── packages.cpython-35.pyc
│       │   │       │   │   │   ├── paths.cpython-35.pyc
│       │   │       │   │   │   ├── plugins.cpython-35.pyc
│       │   │       │   │   │   ├── service.cpython-35.pyc
│       │   │       │   │   │   └── users.cpython-35.pyc
│       │   │       │   │   ├── service.py
│       │   │       │   │   └── users.py
│       │   │       │   └── __pycache__
│       │   │       │       ├── basic.cpython-35.pyc
│       │   │       │       ├── execd.cpython-35.pyc
│       │   │       │       └── __init__.cpython-35.pyc
│       │   │       └── __pycache__
│       │   │           └── apt.cpython-35.pyc
│       │   ├── Makefile
│       │   ├── metadata.yaml
│       │   ├── reactive
│       │   │   ├── apt.py
│       │   │   ├── __init__.py
│       │   │   ├── jenkins.py
│       │   │   └── __pycache__
│       │   │       ├── apt.cpython-35.pyc
│       │   │       ├── __init__.cpython-35.pyc
│       │   │       └── jenkins.cpython-35.pyc
│       │   ├── README.md
│       │   ├── requirements.txt
│       │   ├── revision
│       │   ├── templates
│       │   │   └── jenkins-config.xml
│       │   ├── tests
│       │   │   ├── 01-trusty-basic
│       │   │   ├── 01-xenial-basic
│       │   │   ├── 02-trusty-website
│       │   │   ├── 02-xenial-website
│       │   │   ├── 03-trusty-slave
│       │   │   ├── 03-xenial-slave
│       │   │   ├── 04-trusty-external
│       │   │   ├── 04-xenial-external
│       │   │   ├── basic.py
│       │   │   ├── deployment.py
│       │   │   ├── external.py
│       │   │   ├── README
│       │   │   ├── slave.py
│       │   │   ├── tests.yaml
│       │   │   └── website.py
│       │   ├── TODO.md
│       │   ├── tox.ini
│       │   ├── unit_tests
│       │   │   ├── fakes.py
│       │   │   ├── states.py
│       │   │   ├── stubs
│       │   │   │   ├── apt.py
│       │   │   │   ├── execd.py
│       │   │   │   └── __init__.py
│       │   │   ├── test_api.py
│       │   │   ├── test_configuration.py
│       │   │   ├── test_credentials.py
│       │   │   ├── testing.py
│       │   │   ├── test_packages.py
│       │   │   ├── test_plugins.py
│       │   │   ├── test_service.py
│       │   │   └── test_users.py
│       │   └── wheelhouse
│       │       ├── charmhelpers-0.10.0.tar.gz
│       │       ├── charms.reactive-0.4.5.tar.gz
│       │       ├── Jinja2-2.8.tar.gz
│       │       ├── MarkupSafe-0.23.tar.gz
│       │       ├── multi_key_dict-2.0.3.tar.gz
│       │       ├── netaddr-0.7.18.tar.gz
│       │       ├── pbr-1.10.0.tar.gz
│       │       ├── pip-8.1.2.tar.gz
│       │       ├── pyaml-16.11.4.tar.gz
│       │       ├── python-jenkins-0.4.13.tar.gz
│       │       ├── PyYAML-3.12.tar.gz
│       │       ├── six-1.10.0.tar.gz
│       │       └── Tempita-0.5.2.tar.gz
│       ├── metrics-send.socket
│       ├── run.socket
│       └── state
│           ├── bundles
│           │   ├── cs_3a_xenial_2f_jenkins-1
│           │   └── downloads
│           ├── deployer
│           │   └── manifests
│           │       └── cs_3a_xenial_2f_jenkins-1
│           ├── relations
│           ├── storage
│           └── uniter
├── init
│   ├── jujud-machine-15
│   │   ├── exec-start.sh
│   │   └── jujud-machine-15.service
│   └── jujud-unit-jenkins-1
│       ├── exec-start.sh
│       └── jujud-unit-jenkins-1.service
├── locks
├── meter-status.yaml
├── metricspool
└── tools
    ├── 2.0.1.98-xenial-amd64
    │   ├── action-fail -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── action-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── action-set -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── add-metric -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── application-version-set -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── close-port -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── config-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── downloaded-tools.txt
    │   ├── FORCE-VERSION
    │   ├── is-leader -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── jujud
    │   ├── juju-log -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── juju-reboot -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── leader-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── leader-set -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── network-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── opened-ports -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── open-port -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── payload-register -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── payload-status-set -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── payload-unregister -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── relation-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── relation-ids -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── relation-list -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── relation-set -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── resource-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── status-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── status-set -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── storage-add -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── storage-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   ├── storage-list -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    │   └── unit-get -> /var/lib/juju/tools/2.0.1.98-xenial-amd64/jujud
    ├── machine-15 -> 2.0.1.98-xenial-amd64
    └── unit-jenkins-1 -> /var/lib/juju/tools/2.0.1.98-xenial-amd64

45 directories, 194 files
</pre>
