Title: Charm layer-basic
Date: 2017-05-29 9:22
Tags: lenovo
Slug: charm layer-basic
Author: Feng Xia

Have you ever wondered what [layer-basic][1] is for? and why every
charm needs to include it? In this article we will take a look
at its code base to decipher this mystery.

[1]: https://github.com/juju-solutions/layer-basic.git

# Hooks

We already know hooks are hardcoded. Juju expects certain hooks and
hook sequence is always executed in an order that is dictated by Juju
code.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/charm%20hooks.png" />
  <figcaption>Sequence of charm hooks</figcaption>
</figure>

What do we see in hooks? If you run `charm build` and examine the `dist` folder,
hooks live in `dist/yourcharm/hooks` folder:

<pre class="brush:plain;">
.
├── config-changed
├── hook.template
├── install
├── leader-elected
├── leader-settings-changed
├── relations
│   └── rack-pdu
│       ├── __init__.py
│       ├── interface.yaml
│       ├── provides.py
│       └── requires.py
├── start
├── stop
├── update-status
└── upgrade-charm
</pre>

We know we haven't defined any custom hook code for this charm,
so how were they generated? Even more interesting is
that all hooks are strangely **identical**.
Take `install` hook script for example:

<pre class="brush:python;">
#!/usr/bin/env python3

# Load modules from $JUJU_CHARM_DIR/lib
import sys

from charms.layer import basic

# This will load and run the appropriate @hook and other decorated
# handlers from $JUJU_CHARM_DIR/reactive, $JUJU_CHARM_DIR/hooks/reactive,
# and $JUJU_CHARM_DIR/hooks/relations.
#
# See https://jujucharms.com/docs/stable/authors-charm-building
# for more information on this pattern.

from charms.reactive import main
sys.path.append('lib')
basic.bootstrap_charm_deps()
basic.init_config_states()
main()
</pre>

You can diff all of them, and they are all the same! <span
class="myhighlight">and they are all copies of the
`hook.template`</span>. The `from charms.layer import basic`
actually clearly states that these hooks are <span
class="myhighlight">**depending**</span> on `layer-basic`. There, is
why all charms are using it.

This actually gives us a clue to further investigate how
dependent charms are to `layer-basic`. It turned out not as
necessary as we thought.

# charm build

Source of `charm build` is [here][2]. Looking into the charm `Builder` class:

[2]: https://github.com/juju/charm-tools

<pre class="brush:python;">
class Builder(object):
    """
    Handle the processing of overrides, implements the policy of BuildConfig
    """
    HOOK_TEMPLATE_FILE = path('hooks/hook.template')
</pre>

Ah ha, that's where it is expecting `hook.template`. Following this we have discovered the followings:

1. Relatioin hooks and storage hooks are dynamically generated. For
   this to work, **at least one layer must provide** `hook.template`. The
   interesting point is that it doesn't relie on `layer-basic`
   anymore. If you charm has a `/hooks/hook.template`, it will work.

    <pre class="brush:python;">
    def plan_interfaces(self, layers, output_files, plan):
        ......
        if not meta and layers.get('interfaces'):
            raise BuildError(
                'Includes interfaces but no metadata.yaml to bind them')
        elif self.HOOK_TEMPLATE_FILE not in output_files:
            raise BuildError('At least one layer must provide %s',
                             self.HOOK_TEMPLATE_FILE)
    </pre>

2. If you didn't define those **must-have** hooks, eg. `install` hook,
charm build will happily make the dist, but it will fail at run
time. What is happening!? It turned out `charm` binary has an option
to make `proof`, and this will complain if you miss expected hooks
([bug #325][3]), but the proof isn't part of the `charm build` process.

[3]: https://github.com/juju/charm-tools/issues/325

    1. Code expected hooks:
        <pre class="brush:python;">
        lint.check_hook('install', hooks_path, recommended=True)
        lint.check_hook('start', hooks_path, recommended=True)
        lint.check_hook('stop', hooks_path, recommended=True)
        if os.path.exists(os.path.join(charm_path, 'config.yaml')):
            lint.check_hook('config-changed', hooks_path, recommended=True)
        else:
            lint.check_hook('config-changed', hooks_path)
        </pre>

    2. `charm proof` will catch the missing hooks:
        <pre class="brush:plain;">
        fengxia@fengxia-xenial-dev:~/workspace/wss/charms/charm-pdu$ charm proof
        I: metadata name (pdu) must match directory name (charm-pdu) exactly for local deployment.
        W: no copyright file
        W: no README file
        I: relation rack has no hooks
        I: missing recommended hook install
        I: missing recommended hook start
        </pre>

If charm is executed, `install` hook will run first, which
then call two functions from `layer-basic`:

1. `basic.bootstrap_charm_deps()`
2. `basic.init_config_states()`

Let's take a look them respectively.

# `boostrap_charm_deps`

This function is to setup the host Python environment for charms.

1. `charm-pre-install`: execute any nested file named `charm-pre-install`
   under an `exec.d` folder. It uses `check_call` so any script will work.
   Once the script has been executed without error, a hidden file
   `.{}_{}.done'.format(module_name, submodule_name))` will be created so
   the same preinstall script will only run ONCE &rarr; this is the
   way to make the execution only once regardless the sequence of
   hooks. Therefore whoever runs it once will write this file as
   breadcrumb for others to check.

2. Install packages in `wheelhouse` folder. Again, if this has run,
   a hidden file `wheelhouse/.bootstrapped` is created so all these
   packages are installed ONCE (reference: [distutils][4], [easy_install][5]).

[4]: https://docs.python.org/3/install/index.html#inst-config-files
[5]: http://setuptools.readthedocs.io/en/latest/easy_install.html#configuration-files

    In `wheelhouse.txt` file:
    <pre class="brush:plain;">
    pip>=7.0.0,<8.2.0
    charmhelpers>=0.4.0,<1.0.0
    charms.reactive>=0.1.0,<2.0.0
    </pre>
    
3. Install `python-virtualenv` if it is included in
   `config.yaml`. 

# `init_config_states`

This is where charms will start using Juju commands (via
[charmhelpers][6] lib) to set states with Juju controller.
I'm copying the codes below since they are fairly self-explanatory.
Unlike `bootstrap_charm_deps`, there is no magic file or flag to
prevent this block executed multiple times. This makes sense since
each hook can potentially modify charm states, thus run this in each
hook is necessary.

[6]: https://pythonhosted.org/charmhelpers/

<pre class="brush:python;">
def init_config_states():
    import yaml
    from charmhelpers.core import hookenv
    from charms.reactive import set_state
    from charms.reactive import toggle_state
    config = hookenv.config()
    config_defaults = {}
    config_defs = {}
    config_yaml = os.path.join(hookenv.charm_dir(), 'config.yaml')
    if os.path.exists(config_yaml):
        with open(config_yaml) as fp:
            config_defs = yaml.safe_load(fp).get('options', {})
            config_defaults = {key: value.get('default')
                               for key, value in config_defs.items()}
    for opt in config_defs.keys():
        if config.changed(opt):
            set_state('config.changed')
            set_state('config.changed.{}'.format(opt))
        toggle_state('config.set.{}'.format(opt), config.get(opt))
        toggle_state('config.default.{}'.format(opt),
                     config.get(opt) == config_defaults[opt])
    hookenv.atexit(clear_config_states)

def clear_config_states():
    from charmhelpers.core import hookenv, unitdata
    from charms.reactive import remove_state
    config = hookenv.config()
    remove_state('config.changed')
    for opt in config.keys():
        remove_state('config.changed.{}'.format(opt))
        remove_state('config.set.{}'.format(opt))
        remove_state('config.default.{}'.format(opt))
    unitdata.kv().flush()
</pre>

# Conclusion

`layer-basic` is the foundation of charm building because it provides
the entry point to call preinstall scripts, to setup the host Python
environment and to initialize charm states. It has many hardcoded
lines for using `apt-get` CLI and expecting an Ubuntu
environment. These have been addressed somewhat in [python2 charm][7].
Going forward, the code base can use some work to support host other
than Ubuntu and Python2 instead of 3.

[7]: {filename}/workspace/openstack/python2%20charm.md
