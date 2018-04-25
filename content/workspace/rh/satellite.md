Title: Satellite
Date: 2018-04-15 00:00
Tags: lenovo
Slug: satellite
Author: Feng Xia

These notes are based on Satellite 6.3. There are minor difference
between 6.2 and 6.3. Grasp the concept here, and hopefully you will
have a good understanding of the Satellite models and procedures.

# Make RH repos available to a host via `manifest`

Once a host has registered with Customer Portal (`subscription-manager
register --username <portal username> --password <portal pwd>`). 
In portal we can create a `manifest` for this host to include
`subscriptions`. If host is a Satellite server, its `Content`/`Red Hat
Repositories` will have the list of repos included by the manifest.

## Create manifest in portal

The key is `Subscription Allocation` &rarr; `manifest`. This manifest
is a bootkeeping of what you are making available for whoever is to
import this manifest. Btw, **manifest is not reusable**! (I have
attempted to re-use SH's manifest in dev, and it blocked.).

## Upload manifest to Satellite server

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

If we change subscriptions in the allocation using Portal, we need to
SSH back to Satellite server machine, and **refresh manifest**:

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

# Understand subscription counter


[20]: https://access.redhat.com/sites/default/files/attachments/subscriptionandentitlementaccounting-v1.1.pdf


# Register a client to SA server

We use `activationkey` to control what subscriptions are available to
this client.

On Satellite UI:

1. create `activationkey`. It asks to select an `environment` and a
   `content view`. By default, 6.3 server has a default `environment`
   called `Library`, which includes every subscriptions this SA knows
   about, and a content view `Default content view`, again a catch all
   version.
2. Go to `http://<sa server IP or FQDN>/pub/`, and copy address of
   `katello-ca-consumer-fengsa5.labs.lenovo.com-1.0-1.noarch.rpm`,
   where `fengsa5....com` is the SA server name, so look for
   yours. 

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/katello%20ca.png" />
  <figcaption>Download `katello ca` from Satellite 6.3 server</figcaption>
</figure>


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
3. Install, `rpm -Uvhi katello-ca...rpm`.
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

[30]: https://access.redhat.com/articles/2258471
[31]: https://access.redhat.com/sites/default/files/attachments/rh_sm_command_cheatsheet_1214_jcs_print.pdf
[32]: https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.2/pdf/Installation_Guide/Red_Hat_Satellite-6.2-Installation_Guide-en-US.pdf
[33]: https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/10/html-single/director_installation_and_usage/#sect-Repository_Requirements
[34]: https://access.redhat.com/documentation/en-us/red_hat_satellite/6.3/pdf/installation_guide/Red_Hat_Satellite-6.3-Installation_Guide-en-US.pdf
[35]: https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html-single/using_subscription_asset_manager/index
[36]: https://www.ibm.com/support/knowledgecenter/SSCR9A_2.2.0/doc/iwd/c_redhat_satlitesrv_standup.html
[37]: https://linux.lenovo.com/yum/
