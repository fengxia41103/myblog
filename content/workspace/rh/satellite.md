Title: Satellite
Date: 2018-04-15 00:00
Tags: lenovo
Slug: satellite
Author: Feng Xia

These notes are based on Satellite 6.3. There are minor difference
between 6.2 and 6.3. Grasp the concept here, and hopefully you will
have a good understanding of the Satellite models and procedures.

# Architecture

<img src="/images/rh%20satellite%20overall%20architecture%20official.png"
     class="col s12">

1. **One** satellite server (master server), and **1+** capsule servers.
2. The Satellite Server is required to connect to Red Hat
   Customer Portal &larr; main source of RH packags, errata,
   Puppet modules.
3. The Satellite Server organizes the life cycle management by
   using `organizations` as principal division units &larr; one
   subscription manifest per org.
4. `org` &rarr; `location` creates a matrix &rarr; 
   3 org and 4 location will create `3x4=12` management contexts.
5. `location` is then tied to a capsule server (isolated).
6. Info flow: external source &rarr; main server &rarr; capsule
    server &rarr; managed host.

# Content view

<img src="/images/rh%20satellite%20content%20view.png"
     class="col s12">

1. `Content Views` are subsets of content from the `Library` (master copy of all contents).
2. Multiple content views can be applied to one capsule server.
3. `Content Views` can be combined to create `Composite Content Views`.
4. Composite view is just a grouping. Individual content view, once
   updated, shall still be promoted, but the composite shell does not
   need to be changed. So from its consumer's POV, it sees the change
   transparently.

# RH subscription model

The center piece of Satellite is RH subscription. This is how
user/client can run `yum install <pkg name>` in RHEL. There can be
multiple sources for you. In this discussion, we only distinguish them
between on-premise `Satellite` source vs. everything else. 


 
## what is my source?

In RHEL, it's easy to find out which source you are pulling these rpms
from. Look at `/etc/yum.repo.d/redhat.repo`:

<pre class="brush:plain;">
For example:
[rhel-7-server-openstack-11-devtools-debug-rpms]
metadata_expire = 86400
sslclientcert = /etc/pki/entitlement/2890837266996509363.pem

#####
baseurl = https://cdn.redhat.com/content/dist/rhel/server/7/7Server/$basearch/openstack-devtools/11/debug
#####

ui_repoid_vars = basearch
sslverify = 1
name = Red Hat OpenStack Platform 11 Developer Tools for RHEL 7 (Debug RPMs)
sslclientkey = /etc/pki/entitlement/2890837266996509363-key.pem
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
enabled = 0
sslcacert = /etc/rhsm/ca/redhat-uep.pem
gpgcheck = 1
</pre>

You see the `baseurl` points to `cdn.redhat.com`. This is the
catch-all Redhat source, meaning you are pulling things directly from
Red Hat.

On a Satellite client, instead, you will something like this:

<pre class="brush:plain;">
[Lenovo_IBB_Lenovo_Yum_Repo_Lenovo_yum_repo_SLES11SP4_Default]
metadata_expire = 1
sslclientcert = /etc/pki/entitlement/3451950880933034925.pem

#####
baseurl = https://brain4-satellite.labs.lenovo.com/pulp/repos/Lenovo_IBB/...........
#####

sslverify = 1
name = Lenovo yum repo SLES11SP4_Default
sslclientkey = /etc/pki/entitlement/3451950880933034925-key.pem
enabled = 1
sslcacert = /etc/rhsm/ca/katello-server-ca.pem
gpgcheck = 0
</pre>

For this one, `baseurl` is pointing to a Satellite server named
`brain4-satellite.labs.lenovo.com`. Note that the `.pem` (`sslcacert`)
is tied to a particular server (as url is in `https`!). Therefore, it
is possible to switch source from Satellite A to Satellite B (see
another section below), but cert
needs to be switched together with url.

## Am I registered?

From [talk][39], on a RHEL system, `ls /etc/pki/product`:

1. `69.pem`: identifies this as a RHEL system, no registration.
2. `cert.pem` and `key.pem`: created when you registered the system.
3. `<a long digit string>.pem`: certificates for subscriptions that
   have been attached to this system.



## Subscription model

From bottom up,
`package`&rarr;`repo`&rarr;`product`&rarr;`subscription` forms the
core, each pair has a `1-N` relationship;
`subscription`&rarr;`entitlement` has a `1-1` relationship. From these
one can derive how many _copies_ (`entitlements`) one can use, and
last, `contract` defines time &larr; expiration dates. In its
simpliest term, a VM consumes **1 entitlement of a subscription**. So
if you assign `10 entitlements` to, say `RH Enterprise Linux`
subscription (which as basic RHEL OS rpms), it will support 10 RHEL
VM, and your 11th one will fail to do even `yum update`.

<figure class="col s12">
  <img src="/images/rh%20subscription%20model.png"/>
</figure>


1. A `package` is a [`rpm`][2] ([ref][1]). Essentially `package` is
   a name, eg, `libgnomeuimm`, where then there is a file named
   `libgnomeuimm....rpm`. But `RPM` can
   refer to both. So use this term with caution. `.rpm` file has
   format: `<name>-<version>-<release>.<architecture>.rpm`

2. Satellite supports 5 types of repos:

    1. **yum**: RH native repos are in this bucket. So are things like
       [Fedora EPEL][3]. The key is the `/repodata` folder which
       represents meta data for this yum repo.
    2. **file**: One can upload any file to Satellite server. Satellite
       will create a URL and function as a regular HTTP server &rarr;
       client can just `wget` it from that.
    3. **OSTree**: These are OS images flattened on a file system.
    4. **Docker**: TBD
    5. **Puppet**: TBD

3. Product: is a grouping of repos (so one can put it on a brochure).

4. Subscription: is an umbrella term that covers not only the products
   one bought, but also service, patch, bug fix, and so forth
   ([ref][38]). It's the unit of software __purchased__ from Red Hat.
   
    Subscription does come with a license, which, once installed, is
    with the system for life time. So even subscription expires, the
    system that uses these subscriptions are still functional. The
    difference being that once it's expired, you will stop receiving
    updates, service, and so on (so it's like `rpms` frozen in time).

    There are 2 types of subscriptions to consider: **standard** and
    **instance-based**.
    
        1. standard: qty `1-N`, and doesn't matter deployment is BM or
        VM, always consumed 1.
        2. instance-based: qty `1-N`, BM and VM consumes different
        amount (see "Entitle accounting" below for more details.)
        
5. Entitlement: essentially a total number that how many clients can
   one subscription allows. For this, we need to do some accounting.

[1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/deployment_guide/ch-rpm

[2]: https://en.wikipedia.org/wiki/Rpm_(software)
[3]: https://archive.fedoraproject.org/pub/epel/7Server/x86_64/

## Entitlement accounting

### how many we have
From [Red Hat Subscription and Entitlement Accounting (pdf)][40]:

> In implementation, the subscription service (Customer Portal for
> hosted connectivity or Satellite 6 for on-premise connectivity)
> converts each subscription into a “pool​” of individual entitlements
> that can be attached to an end-system. The attachment process
> “consumes​” an entitlement from the pool thereby “entitling” the
> end-system to access content stores.

The [pdf][40] has a clear example to describe this. In a nutshell,

<pre class="brush:plain;">
entitlements = subscription qty * entitlement qty/sub *
instance multiplier
</pre>

<figure class="col s12 center-block">
  <img src="/images/rh%20entitlement%20accounting.png"/>
</figure>

### how many we are using

Now, how are entitlement consumed? From [Red Hat Subscription and
Entitlement Accounting (pdf)][40]:

> Each subscription has a consumption rule that determines the number of
> entitlements (rate) that are consumed from a pool to cover the
> end-system.​ The consumption rule depends on several factors including:
> the subscriptions type, the “unit of capacity​” the subscription covers
> (e.g.  sockets, ram, cores), and the deployed system type (physical or
> virtual); thus the consumption rate is governed by the following
> statements:
> 
> 1. “Standard” subscriptions consumed entitlements at a rate of:
>     1. One per each virtual system deployment
>     2. One per unit of capacity on the physical system
> 2. “Instance-based” subscriptions consumed entitlements at a rate of:
>     1. One per each virtual system deployment
>     2. The “instance multiplier” per unit of capacity on the physical system.
>

So to simply things, if we are looking at VM primarily, **1
entitlement per VM**. Period.

### Manifest

Satellite has no entitlement to use. The pool is under a user account
and can be managed in Customer Portal. With the knowledge of
subscription tyeps, we can create a `Subscription Allocation` which
then can be exported into a `manifest` file. Satellite can import this
file to establish its entitlement pool.

Once you have created a `subscription allocation`, export manifest
file to your computer, and see [ref][8]:

1. Download manifest from Customer Portal (screenshot).
2. `scp` it to Satellite server.
3. On satellite server, `hammer -u <sa user> -p <sa pwd> subscription upload --file
   <manifest zip> --organization "<org name>"`

[8]: https://access.redhat.com/solutions/1256693

If getting an error `A backend service [ Candlepin ] is unreachable`,
see [ref][9]:

1. `service tomcat6 status`, likely is in error.
2. `service tomcat6 start`, then check status again, should be fine.
3. Run `hammer` upload again. This takes a while for a file size of
   only 300+k. Don't panic.
4. Now go to `Content`/`Red Hat Repositories`, it will list repos. 

[9]: https://access.redhat.com/solutions/1270233


### Refresh subscription if allocation changed

If we change subscriptions in the allocation using Portal (add/remove
subscriptions), we need to SSH back to Satellite server machine, and
**refresh manifest**:

<pre class="brush:plain;">
$ hammer subscription refresh-manifest --organization "<org name>"
</pre>

# Enable/disable repo

See [ref][10]. On Satellite server:

<pre class="brush:plain;">
subscription-manager repos --list
subscription-manager repos --enable=[repo name]
subscription-manager repos --disable=[repo name]
</pre>

[10]: https://access.redhat.com/solutions/265523


# Register a client to SA server

<figure class="col l6 m12 s12">
  <img class="img-responsive"
       src="/images/katello%20ca.png" />
  <figcaption>Download `katello ca` from Satellite 6.3 server</figcaption>
</figure>

Two ways to register: activation key, or to an environment.

## register with activation keys

On Satellite UI:

1. create activation key: It asks to select an `environment` and a
   `content view`. By default, 6.3 server has a default `environment`
   called `Library`, which includes every subscriptions this SA knows
   about, and a content view `Default content view`, again a catch all
   version.
2. Go to `http://<sa server IP or FQDN>/pub/`, and copy address of
   `katello-ca-consumer-latest.noarch.rpm`.



On client machine:

1. Make sure it has a host name (hint: `/etc/hosts`, and
   `/etc/sysconfig/network`).
   
    If DNS is not resolving SA server's name, you can add it manually
    to `/etc/hosts`. For example, SA server is at
    `brain4-satellite.labs.lenovo.com` with IP `192.168.1.100`, and the
    machine you are to register will be `client1.labs.lenovo.com` with
    IP `192.168.1.200`, simply add two lines in `/etc/hosts`:

    <pre class="brush:plain;">
    In /etc/hosts:
    192.168.1.100 brain4-satellite.labs.lenovo.coom
    192.168.1.200 client1.labs.lenovo.com
    </pre>

    Then restart network services:
    <pre class="brush:plain;">
    systemctl start chronyd
    systemctl enable chronyd
    systemctl start rhsmcertd
    </pre>
   
2. Download `katello-ca...rpm`, eg. `curl -O <link copied above>`
   (Note: it is a capital O as oliver).
3. Install, `rpm -Uvhi --force katello-ca...rpm`.
4. Register, `subscription-manager register --org="<org name>"
   --activationkey="<key name>"`.
5. Verify, `subscription-manager repos --list`.
6. Go to Satellite UI `hosts/content hosts`, you should see this
   machine's host name.

# See also

1. [`hammer` cheatsheet][30]
2. [`subscription-manager` cheatsheet][31]
3. [Satellite 6.2 installation PDF][32]
4. [Satellite 6.3 installation PDF][34]
5. [subscription manager][35], a nice description of Satellite workflow
6. [Openstack repo requirements][33]
7. [IBM doc on Satellite][36]
8. [Lenovo Yum repo][37]
9. [Red Hat Subscription Model FAQ][38]

[30]: https://access.redhat.com/articles/2258471
[31]: https://access.redhat.com/sites/default/files/attachments/rh_sm_command_cheatsheet_1214_jcs_print.pdf
[32]: https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.2/pdf/Installation_Guide/Red_Hat_Satellite-6.2-Installation_Guide-en-US.pdf
[33]: https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/10/html-single/director_installation_and_usage/#sect-Repository_Requirements
[34]: https://access.redhat.com/documentation/en-us/red_hat_satellite/6.3/pdf/installation_guide/Red_Hat_Satellite-6.3-Installation_Guide-en-US.pdf
[35]: https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html-single/using_subscription_asset_manager/index
[36]: https://www.ibm.com/support/knowledgecenter/SSCR9A_2.2.0/doc/iwd/c_redhat_satlitesrv_standup.html
[37]: https://linux.lenovo.com/yum/
[38]: https://www.redhat.com/en/about/subscription-model-faq#?
[39]: https://access.redhat.com/sites/default/files/video/files/summit2015-lightning_talk-subscription-manager.pdf
[40]: https://access.redhat.com/sites/default/files/attachments/subscriptionandentitlementaccounting-v1.1.pdf

[41]: https://access.redhat.com/documentation/en-us/red_hat_satellite/6.3/html/architecture_guide/chap-red_hat_satellite-architecture_guide-introduction_to_red_hat_satellite#sect-Red_Hat_Satellite-Architecture_Guide-Introduction_to_Red_Hat_Satellite-Red_Hat_Satellite_6_System_Architecture
