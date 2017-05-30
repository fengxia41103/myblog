Title: Charm layer-basic
Date: 2017-05-29 9:22
Tags: openstack
Slug: charm layer-basic
Author: Feng Xia
Status: Draft

> <span class="myhighlight">Copyright @ Lenovo US</span>

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

Source of `charm build` is [here][2]. Looking into the charm builder class:

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
    
2. If you didn't define those **must-have** hooks, eg. `install` hook, charm build will happily make the dist, but it will fail at run time. What is happening!? It runed out `charm` binary has an option to make `proof`, and this will complain if you miss expected hooks ([bug #325][3]):

[3]: https://github.com/juju/charm-tools/issues/325
    
    <pre class="brush:plain;">
    fengxia@fengxia-xenial-dev:~/workspace/wss/charms/charm-pdu$ charm proof
    I: metadata name (pdu) must match directory name (charm-pdu) exactly for local deployment.
    W: no copyright file
    W: no README file
    I: relation rack has no hooks
    I: missing recommended hook install
    I: missing recommended hook start
    </pre>
