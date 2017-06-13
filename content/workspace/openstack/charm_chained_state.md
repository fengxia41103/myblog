Title: Charm chained states
Date: 2017-04-24 13:00
Tags: lenovo
Slug: juju charm chained states
Author: Feng Xia

This charm is created to demonstrate chained states using Juju
charm. Chained states is essentially mirroring a pattern of any sequential
execution in a workflow. Potentially each execution block can also
have conditions to set the next state, even though this type of knowledge
should be exposed outside function element, if possible, and to be
handled by something better than pure code (eg. BPMN).

The model for this experiment is straightforward. We create a layer
with three states: `state.1`, `state.2`, and `state.3`. Upon start
charm kicks off execution of `state.1`, which then transit itself to
the `state.2`, then to `state.3`, and then loop back to `state.1`.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/charm%20chain%20states.png" />
  <figcaption>Charm design pattern: chain states</figcaption>
</figure>

The key questions to answer in this experiment are:

1. What is the entry point to start the first state?
2. If setting two states true, are they executed serially or
   in parallel?
3. Can a blocking command halt state transition even if there are
   states being true and can be acted upon? 
   
# Screencast

Top left window shows the `juju debug-log` which prints state
transition among three states. Top right window `juju status` also
shows state transitions in **Message** column which is set by
`set_status` in each state's function block.

<figure class="row">
  <img class="img-responsive center-block"
       src="/images/charm%20chained%20states%20screencast.gif" />
  <figcaption>Charm chain states screencast</figcaption>
</figure>


# The 1st state

> How to start the first state?

In this test we experimented using hooks to introduce the first state since hooks
are executed in a predetermined sequence. However, `set_state` has no
effect and actually should be avoided within hook execution according
to document (needs reference).

To safely start the whole process, we settled on `@only_once`:

<pre class="brush:python;">
@only_once
def state_0():
    log('something------------------')
</pre>

## Chain state pattern

The three primary states follow the same pattern. Using `state.1` for example:

<pre class="brush:python;">
@when('state.1')
def state_1():
    """State.1
    """

    # set status
    t = time.ctime(time.time())
    status_set('maintenance', 'state.1 %s' % t)

    # workload
    time.sleep(TEST_TIMEOUT)

    # state transition
    remove_state('state.1')
    set_state('state.2')
</pre>

# Multiple states being true

> If we set multiple states `true`, will they be executed in parallel?

From [previous article][1] on state execution, we can already see that
states are first saved in a dictionary and then scanned by
iterator. Therefore, there is no parallel computing built in the charm
execution mechanism. Further, execution order of two states have no
guarantee except they will all be done sooner or later because Python
dictionary does not enforce any order.

[1]: {filename}/workspace/openstack/charm_reactive.md

> Multiple `true` states will be executed in serial.
> Orders of execution is undetermined.

# Long running process

> Will a shell blocking call halt state transition?

In this test we want to verify whether starting a long running process
will block charm's state transition. We used `subprocess.check_all` to
start a blocking call while state 1-3 are kept to loop as designed.

<pre class="brush:python;">
def state_4():
    """State4.
    """
    subprocess.check_all("apt update && apt dist-upgrade")
</pre>

The result is clear that state machine will come to a halt at this
blocking call, which would have to be the case since we already know
how states are being scanned and executed
from [previous article][1]. All states are cached in a dictionary and
are scanned in a tight loop per iteration. Thus a blocking call in any
handler will cause the loop to a halt. Nowhere in code will take a
signal so this behavior can not be interruptted either.
