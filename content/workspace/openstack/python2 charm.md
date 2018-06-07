Title: Juju charm Python2
Date: 2017-05-27 10:00
Tags: lenovo
Slug: python2 charm
Author: Feng Xia

Why do we want to build Python2 charms? Charms are claimed to built
for Python3. However, the catch is that charms are also built for
Ubuntu ecosystems <span class="myhighlight">ONLY</span> if you care to
examine its code base.

Take `__init__.py` in [`charmhelpers/charmhelpers`][1] for example:

[1]: https://pythonhosted.org/charmhelpers/

```python
try:
    import six  # flake8: noqa
except ImportError:
    if sys.version_info.major == 2:
        subprocess.check_call(['apt-get', 'install', '-y', 'python-six'])
    else:
        subprocess.check_call(['apt-get', 'install', '-y', 'python3-six'])
    import six  # flake8: noqa
```

Command line `apt-get` is a clue, isn't it? There are many such
hardcoded lines who shout out that Ubuntu is the way to go, and of
course, charms are developed by Canonical, and you are expected to use
them the way they were designed for.

Well, this is fine <span class="myhighlight">
until you want to deploy them on **CentOS**.</span>

# CentOS challenge

CentOS and RHEL remain to dominate enterprise. CentOS7 is shipped with
Python27. We enabled `EPEL-RELEASE` repo, but then
charm install gave us an error `no module yum found`. The call is made
in `charmhelpers/fetch.centos.py`, and python34 has no `yum` module!

```python
import yum
```

And trace it one step further, it came from
`charm-helpers/charmhelpers/fetch/__init__.py`:

```python
if __platform__ == "ubuntu":
    apt_cache = fetch.apt_cache
    apt_install = fetch.install
    apt_update = fetch.update
    apt_upgrade = fetch.upgrade
    apt_purge = fetch.purge
    apt_mark = fetch.apt_mark
    apt_hold = fetch.apt_hold
    apt_unhold = fetch.apt_unhold
    get_upstream_version = fetch.get_upstream_version
elif __platform__ == "centos":
    yum_search = fetch.yum_search
```

Here we are making a mapping between defined function definitions and
the function names that will be used in other places in the
lib. Needless to say, CentOS definitions are missing a lot comparing
to Ubuntu's. So yes, `import yum` is just the tip of the iceberg,
execution will break anywhere `apt_` is called. Take `apt_install` for
example, here is a search result where this function is expected:

```shell
-*- mode: grep; default-directory: "~/workspace/wss/hack/charmhelpers-0.15.0/" -*-
Grep started at Sat May 27 22:32:10

find . -type d \( -path \*/SCCS -o -path \*/RCS -o -path \*/CVS -o -path \*/MCVS -o -path \*/.src -o -path \*/.svn -o -path \*/.git -o -path \*/.hg -o -path \*/.bzr -o -path \*/_MTN -o -path \*/_darcs -o -path \*/\{arch\} \) -prune -o \! -type d \( -name .\#\* -o -name \*.beam -o -name \*.vee -o -name \*.jam -o -name \*.hi -o -name \*.o -o -name \*\~ -o -name \*.bin -o -name \*.lbin -o -name \*.so -o -name \*.a -o -name \*.ln -o -name \*.blg -o -name \*.bbl -o -name \*.elc -o -name \*.lof -o -name \*.glo -o -name \*.idx -o -name \*.lot -o -name \*.fmt -o -name \*.tfm -o -name \*.class -o -name \*.fas -o -name \*.lib -o -name \*.mem -o -name \*.x86f -o -name \*.sparcf -o -name \*.dfsl -o -name \*.pfsl -o -name \*.d64fsl -o -name \*.p64fsl -o -name \*.lx64fsl -o -name \*.lx32fsl -o -name \*.dx64fsl -o -name \*.dx32fsl -o -name \*.fx64fsl -o -name \*.fx32fsl -o -name \*.sx64fsl -o -name \*.sx32fsl -o -name \*.wx64fsl -o -name \*.wx32fsl -o -name \*.fasl -o -name \*.ufsl -o -name \*.fsl -o -name \*.dxl -o -name \*.lo -o -name \*.la -o -name \*.gmo -o -name \*.mo -o -name \*.toc -o -name \*.aux -o -name \*.cp -o -name \*.fn -o -name \*.ky -o -name \*.pg -o -name \*.tp -o -name \*.vr -o -name \*.cps -o -name \*.fns -o -name \*.kys -o -name \*.pgs -o -name \*.tps -o -name \*.vrs -o -name \*.pyc -o -name \*.pyo \) -prune -o  -type f \( -name \*.py \) -exec grep -i -nH -e apt_install \{\} +
./charmhelpers/contrib/hardening/host/checks/pam.py:26:    apt_install,
./charmhelpers/contrib/hardening/host/checks/pam.py:89:            apt_install(pkg)
./charmhelpers/contrib/hardening/host/checks/pam.py:125:        apt_install('libpam-modules')
./charmhelpers/contrib/hardening/ssh/checks/config.py:27:    apt_install,
./charmhelpers/contrib/hardening/ssh/checks/config.py:199:        apt_install(settings['client']['package'])
./charmhelpers/contrib/hardening/ssh/checks/config.py:277:        apt_install(settings['server']['package'])
./charmhelpers/contrib/hardening/templating.py:27:    from charmhelpers.fetch import apt_install
./charmhelpers/contrib/hardening/templating.py:31:        apt_install('python-jinja2', fatal=True)
./charmhelpers/contrib/hardening/templating.py:33:        apt_install('python3-jinja2', fatal=True)
./charmhelpers/contrib/storage/linux/ceph.py:64:    apt_install,
./charmhelpers/contrib/storage/linux/ceph.py:729:    apt_install('ceph-common', fatal=True)
./charmhelpers/contrib/openstack/context.py:27:    apt_install,
./charmhelpers/contrib/openstack/context.py:106:        apt_install('python-psutil', fatal=True)
./charmhelpers/contrib/openstack/context.py:108:        apt_install('python3-psutil', fatal=True)
./charmhelpers/contrib/openstack/context.py:119:        apt_install(required, fatal=True)
./charmhelpers/contrib/openstack/keystone.py:18:from charmhelpers.fetch import apt_install
./charmhelpers/contrib/openstack/keystone.py:121:                apt_install(["python-keystoneclient"], fatal=True)
./charmhelpers/contrib/openstack/keystone.py:123:                apt_install(["python3-keystoneclient"], fatal=True)
./charmhelpers/contrib/openstack/keystone.py:155:                apt_install(["python-keystoneclient"], fatal=True)
./charmhelpers/contrib/openstack/keystone.py:157:                apt_install(["python3-keystoneclient"], fatal=True)
./charmhelpers/contrib/openstack/templating.py:19:from charmhelpers.fetch import apt_install, apt_update
./charmhelpers/contrib/openstack/templating.py:32:        apt_install('python-jinja2', fatal=True)
./charmhelpers/contrib/openstack/templating.py:34:        apt_install('python3-jinja2', fatal=True)
./charmhelpers/contrib/openstack/templating.py:214:                apt_install('python-jinja2')
./charmhelpers/contrib/openstack/templating.py:216:                apt_install('python3-jinja2')
./charmhelpers/contrib/openstack/utils.py:85:    apt_install,
./charmhelpers/contrib/openstack/utils.py:591:        apt_install('ubuntu-cloud-keyring', fatal=True)
./charmhelpers/contrib/database/mysql.py:43:    apt_install,
./charmhelpers/contrib/database/mysql.py:54:        apt_install(filter_installed_packages(['python-mysqldb']), fatal=True)
./charmhelpers/contrib/database/mysql.py:56:        apt_install(filter_installed_packages(['python3-mysqldb']), fatal=True)
./charmhelpers/contrib/network/ovs/__init__.py:20:from charmhelpers.fetch import apt_install
./charmhelpers/contrib/network/ovs/__init__.py:90:            apt_install('python-netifaces', fatal=True)
./charmhelpers/contrib/network/ovs/__init__.py:92:            apt_install('python3-netifaces', fatal=True)
./charmhelpers/contrib/network/ip.py:23:from charmhelpers.fetch import apt_install, apt_update
./charmhelpers/contrib/network/ip.py:42:        apt_install('python-netifaces', fatal=True)
./charmhelpers/contrib/network/ip.py:44:        apt_install('python3-netifaces', fatal=True)
./charmhelpers/contrib/network/ip.py:52:        apt_install('python-netaddr', fatal=True)
./charmhelpers/contrib/network/ip.py:54:        apt_install('python3-netaddr', fatal=True)
./charmhelpers/contrib/network/ip.py:447:            apt_install('python-dnspython', fatal=True)
./charmhelpers/contrib/network/ip.py:449:            apt_install('python3-dnspython', fatal=True)
./charmhelpers/contrib/network/ip.py:498:                apt_install("python-dnspython", fatal=True)
./charmhelpers/contrib/network/ip.py:500:                apt_install("python3-dnspython", fatal=True)
./charmhelpers/contrib/ansible/__init__.py:135:    charmhelpers.fetch.apt_install('ansible')
./charmhelpers/contrib/templating/jinja.py:19:from charmhelpers.fetch import apt_install, apt_update
./charmhelpers/contrib/templating/jinja.py:25:        apt_install(["python3-jinja2"], fatal=True)
./charmhelpers/contrib/templating/jinja.py:27:        apt_install(["python-jinja2"], fatal=True)
./charmhelpers/contrib/python/packages.py:23:from charmhelpers.fetch import apt_install, apt_update
./charmhelpers/contrib/python/packages.py:44:                apt_install('python-pip')
./charmhelpers/contrib/python/packages.py:46:                apt_install('python3-pip')
./charmhelpers/contrib/python/packages.py:144:        apt_install('python-virtualenv')
./charmhelpers/contrib/python/packages.py:146:        apt_install('python3-virtualenv')
./charmhelpers/contrib/mellanox/infiniband.py:23:    apt_install,
./charmhelpers/contrib/mellanox/infiniband.py:36:        apt_install('python-netifaces')
./charmhelpers/contrib/mellanox/infiniband.py:38:        apt_install('python3-netifaces')
./charmhelpers/contrib/mellanox/infiniband.py:88:    apt_install(REQUIRED_PACKAGES, fatal=True)
./charmhelpers/contrib/saltstack/__init__.py:104:    charmhelpers.fetch.apt_install('salt-common')
./charmhelpers/fetch/__init__.py:88:    apt_install = fetch.install
./charmhelpers/fetch/__init__.py:100:    apt_install = fetch.install
./charmhelpers/core/templating.py:43:    installed, calling this will attempt to use charmhelpers.fetch.apt_install
./charmhelpers/core/templating.py:50:            from charmhelpers.fetch import apt_install
./charmhelpers/core/templating.py:57:            apt_install('python-jinja2', fatal=True)
./charmhelpers/core/templating.py:59:            apt_install('python3-jinja2', fatal=True)
./tests/contrib/storage/test_linux_ceph.py:612:    @patch.object(ceph_utils, 'apt_install')
./tests/contrib/openstack/test_os_contexts.py:2106:    @patch.object(context, 'apt_install')
./tests/contrib/openstack/test_os_templating.py:59:        self.addCleanup(patch.object(templating, 'apt_install').start().stop())
./tests/contrib/openstack/test_os_templating.py:69:    @patch.object(templating, 'apt_install')
./tests/contrib/openstack/test_keystone_utils.py:10:    'apt_install',
./tests/contrib/openstack/test_openstack_utils.py:496:    @patch('charmhelpers.contrib.openstack.utils.apt_install')
./tests/contrib/network/test_ip.py:618:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:619:    def test_get_host_ip_with_hostname(self, apt_install):
./tests/contrib/network/test_ip.py:627:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:628:    def test_get_host_ip_with_hostname_no_dns(self, apt_install, socket,
./tests/contrib/network/test_ip.py:640:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:641:    def test_get_host_ip_with_hostname_fallback(self, apt_install, socket,
./tests/contrib/network/test_ip.py:654:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:655:    def test_get_host_ip_with_ip(self, apt_install):
./tests/contrib/network/test_ip.py:661:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:662:    def test_ns_query_trigger_apt_install(self, apt_install):
./tests/contrib/network/test_ip.py:667:                apt_install.assert_called_with('python-dnspython', fatal=True)
./tests/contrib/network/test_ip.py:669:                apt_install.assert_called_with('python3-dnspython', fatal=True)
./tests/contrib/network/test_ip.py:672:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:673:    def test_ns_query_ptr_record(self, apt_install):
./tests/contrib/network/test_ip.py:679:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:680:    def test_ns_query_a_record(self, apt_install):
./tests/contrib/network/test_ip.py:687:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:688:    def test_ns_query_blank_record(self, apt_install):
./tests/contrib/network/test_ip.py:694:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:695:    def test_ns_query_lookup_fail(self, apt_install):
./tests/contrib/network/test_ip.py:701:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:702:    def test_get_hostname_with_ip(self, apt_install):
./tests/contrib/network/test_ip.py:708:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:709:    def test_get_hostname_with_ip_not_fqdn(self, apt_install):
./tests/contrib/network/test_ip.py:715:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:716:    def test_get_hostname_with_hostname(self, apt_install):
./tests/contrib/network/test_ip.py:720:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:721:    def test_get_hostname_with_hostname_trailingdot(self, apt_install):
./tests/contrib/network/test_ip.py:725:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:726:    def test_get_hostname_with_hostname_not_fqdn(self, apt_install):
./tests/contrib/network/test_ip.py:730:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:731:    def test_get_hostname_trigger_apt_install(self, apt_install):
./tests/contrib/network/test_ip.py:737:                apt_install.assert_called_with('python-dnspython', fatal=True)
./tests/contrib/network/test_ip.py:739:                apt_install.assert_called_with('python3-dnspython', fatal=True)
./tests/contrib/network/test_ip.py:745:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:746:    def test_get_hostname_lookup_fail(self, apt_install, ns_query, socket):
./tests/contrib/network/test_ip.py:756:    @patch('charmhelpers.contrib.network.ip.apt_install')
./tests/contrib/network/test_ip.py:758:            self, apt_install, ns_query, socket):
./tests/contrib/network/test_ovs.py:110:    "apt_install",
./tests/contrib/ansible/test_ansible.py:46:        self.mock_fetch.apt_install.assert_called_once_with(
./tests/contrib/ansible/test_ansible.py:54:        self.mock_fetch.apt_install.assert_called_once_with(
./tests/contrib/python/test_packages.py:13:    "apt_install",
./tests/contrib/python/test_packages.py:27:        self.apt_install.return_value = True
./tests/contrib/python/test_packages.py:174:            self.apt_install.assert_called_with('python-virtualenv')
./tests/contrib/python/test_packages.py:176:            self.apt_install.assert_called_with('python3-virtualenv')
./tests/contrib/saltstack/test_saltstates.py:34:        self.mock_charmhelpers_fetch.apt_install.assert_called_once_with(
./tests/contrib/saltstack/test_saltstates.py:42:        self.mock_charmhelpers_fetch.apt_install.assert_called_once_with(
./tests/fetch/test_fetch.py:804:        fetch.apt_install(packages, options)
./tests/fetch/test_fetch.py:821:        fetch.apt_install(packages)
./tests/fetch/test_fetch.py:839:        fetch.apt_install(packages, options)
./tests/fetch/test_fetch.py:857:        fetch.apt_install(packages, options, fatal=True)

Grep finished (matches found) at Sat May 27 22:32:10
```

Enough proof that default charms will break. Let's see how to fix it.

# Python2 fix

> Strategy: make a charm Python2 compatible.

This can be broken down to the following steps:

1. Use  `python27` (in hooks).
2. Change python search path in hooks.
3. Map `apt_` function for CentOS in `charmhelpers`.
4. Update `RelationBase` class definition `charms.reactive` lib to use Python2 syntax.
5. Update `layer-basic`.

## Python27 in  hooks

If you run `charm build` and search `python3` in dist folder, the
first offender are hooks:

```python
#!/usr/bin/env python3

change to:

#!/usr/bin/env python
```

The root cause is actually the `hook.template`, which is used in a
copy-paste fashion to create the list of default hooks if user didn't
define one. Remember, the hooks are hardcoded, and certain hooks will
always be created!

## `sys.path` in hooks

Update Python search path used in **all** hooks:

```python
# Load modules from $JUJU_CHARM_DIR/lib
import sys
sys.path.append('lib')

change to:

# Load modules from $JUJU_CHARM_DIR/lib
import sys
import os
sys.path.append(os.path.join(os.getcwd(),'lib'))
```

Btw, don't be fooled by the comment line __$JUJU_CHARM_DIR__,
there isn't one. Otherwise, there is no need to
make this change.

## Function mapping in `charmhelpers`

Update `charmhelpers/fetch/__init__.py` to add CentOS function
mappings:

```python
if __platform__ == "ubuntu":
    apt_cache = fetch.apt_cache
    apt_install = fetch.install
    apt_update = fetch.update
    apt_upgrade = fetch.upgrade
    apt_purge = fetch.purge
    apt_mark = fetch.apt_mark
    apt_hold = fetch.apt_hold
    apt_unhold = fetch.apt_unhold
    get_upstream_version = fetch.get_upstream_version
elif __platform__ == "centos":
    yum_search = fetch.yum_search

    # ADD: centos mapping
    apt_install = fetch.install
    apt_upgrade = fetch.upgrade
    apt_update = fetch.update
    apt_purge = fetch.purge
    apt_cache = fetch.yum_search
```

## `RelationBase` in `charms.reactive`

Update `class RelationBase` in
`charms.reactive/charms/reactive/relations.py`:

```python
class RelationBase(object, metaclass=AutoAccessors):
    """
    The base class for all relation implementations.
    """

change to:

class RelationBase(object):
    __metaclass__=AutoAccessors
```

## `layer-basic`

[layer-basic][2] is inherited in all charms. We will have a [separate
analysis][6] on this lib alone. For now, let's take it for granted and
work around the issues to make Python2 charms.

[2]: https://github.com/juju-solutions/layer-basic
[6]: {filename}/workspace/openstack/layer%20basic.md

Diff file list:

```shell
Files layer-basic/bin/layer_option
Only in /home/fengxia/workspace/wss/charms/layer-basic/lib/charms: __init__.py
Files layer-basic/lib/charms/layer/basic.py 
Files layer-basic/lib/charms/layer/execd.py
```

### `sys.path` in `layer_option`

Update `layer-basic/bin/layer-optioin`. This is the same change made
in hooks.

```python
import sys
sys.path.append('lib')

change to:

import sys
import os
sys.path.append(os.path.join(os.getcwd(),'lib'))
```


### Python import path

Touch an empty file `layer-basic/lib/charms/__init__.py` &rarr; make Python2
search path work.

### `basic.py`

Changes to this file look intimidating (showing diff -r old
new). However, the theme is quite straightforward:

1. Install python2 modules, eg `python-setuptools`, as prerequisite to
prepare the environment ([bug #97][4]).
2. The correct binary path for your `pip`.
3. Use `platform.linux_distribution()[0]` to determine host platform.
4. `apt` uses `--assume-yes`, where `yum` uses `--assumeyes`.

There are mixed `apt_install` ([bug #98][3]) using the mapped function and direct
`check_call` shell calls. Moving forward, we should consolidate all
package functions to mapped version.

[3]: https://github.com/juju-solutions/layer-basic/issues/98
[4]: https://github.com/juju-solutions/layer-basic/issues/97

```diff
6a7
> import platform
51,56c52,77
<         apt_install([
<             'python3-pip',
<             'python3-setuptools',
<             'python3-yaml',
<             'python3-dev',
<         ])
---
>         me = platform.linux_distribution()[0]
>         if 'ubuntu' in me.lower():
>             apt_install([
>                 'python3-pip',
>                 'python3-setuptools',
>                 'python3-yaml',
>                 'python3-dev',
>             ])
>         elif 'cent' in me.lower():
>             # if using python3
>             #apt_install([
>             #    'redhat-lsb-core',
>             #    'python34-setuptools',
>             #    'python34-pip',
>             #    'python34-yaml',
>             #    'python34-devel',
>             #])
>             apt_install([
>                 'epel-release', # must
>                 'redhat-lsb-core',
>                 'python-setuptools',
>                 'python-pip',
>                 'python-yaml',
>                 'python-devel',
>             ])
> 
64c85,88
<                 series = lsb_release()['DISTRIB_CODENAME']
---
>                 try:
>                     series = lsb_release()['DISTRIB_CODENAME']
>                 except:
>                     series = 'centos7'
66a91
>                     pip = vpip
68c93,96
<                     apt_install(['virtualenv'])
---
>                     # pip = 'pip3' # if using python3
>                     pip = 'pip'
>                     check_call([pip, 'install', '-U', '--no-index', '-f', 'wheelhouse','pip'])
>                     check_call([pip, 'install', 'virtualenv'])
74d101
<             pip = vpip
76c103,104
<             pip = 'pip3'
---
>             # pip = 'pip3' # if using python3
>             pip = vpip
83,84c111,114
<         check_call([pip, 'install', '-U', '--no-index', '-f', 'wheelhouse',
<                     'pip'])
---
>     
>         # TODO: feng
>         pip = 'pip' # this is a hack to use Python2
>         check_call([pip, 'install', '-U', '--no-index', '-f', 'wheelhouse','pip'])
86,87c116
<         check_call([pip, 'install', '-U', '--no-index', '-f', 'wheelhouse'] +
<                    glob('wheelhouse/*'))
---
>         check_call([pip, 'install', '-U', '--no-index', '-f', 'wheelhouse'] + glob('wheelhouse/*'))
113c142,143
<         sys.path.append('lib')
---
>         import os
>         sys.path.append(os.path.join(os.getcwd(),'lib'))
157c187,190
<     cmd = ['apt-get',
---
>     me = platform.linux_distribution()[0]
>     if 'ubuntu' in me.lower():
>         my_cmd = 'apt-get'
>         cmd = [my_cmd,
160a194,199
>     elif 'cent' in me.lower():
>         my_cmd = 'yum'
>         cmd = [my_cmd,
>            '--assumeyes',
>            'install']
> 	
```

### `execd.py`

A formatting error?

```shell
17a18
> from __future__ import print_function
114,115c115
<             print("ERROR ({}) running {}".format(e.returncode, e.cmd),
<                   file=stderr)
---
>             print("ERROR ({}) running {}".format(e.returncode, e.cmd),file=stderr)
```

# How to build

1. git clone `http://hpcgitlab.labs.lenovo.com/WSS/wss.git`.
2. Copy (or symlink) `wss/hack/layer-basic` to `LAYER_PATH`.
3. `charm build` your charm as usual.
4. Copy `wss/hack/charmhelpers....tar.gz` and
   `charms.reactive....tar.gz` to `dist/trusty(or
   centos)/yourcharm/wheelhouse`.
5. Copy `wss/hack/hooks` to `dist/.../hooks`. However, if you have
   customized hooks, you need to make modifications manually. 

Have fun with CentOS.
