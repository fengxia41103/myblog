Title: Charm Reactive
Date: 2017-04-24 14:00
Tags: lenovo
Slug: juju charm reactive
Author: Feng Xia
Modified: 2019-03-15
Summary: Charm's reactive framework is the core of charm design and
execution. This article is to dive into its source code in order to
understand its execution logic and design philosophy.

In this article we will study charm's [reactive][1] framework to get a
firm understanding of what they mean by writing an reactive charm.

[1]: https://pythonhosted.org/charms.reactive/

# Hooks

> Decorator: `@hook`
> Definition: `charm.reactive/charms/reactive/decorators.py`

Hooks give one a dedicated sequence that execution is guaranteed in
that order and developer can use `@hook` to define a function block
to run. 

<figure class="s12 center">
  <img src="/images/charm%20hooks.png" />
  <figcaption>Sequence of charm hooks</figcaption>
</figure>

Hooks have a few limitations which affect the usefulness of this
mechanism:

1. Hooks are really meant to be used for internal workflow
   transitions. There are only 8 of them and they represent a specific
   stage in the life cycle of a charm. There is no mechanism to extend
   or inherit these built-ins.

    1. install
    2. config-changed
    3. start
    4. upgrade-charm
    5. stop
    6. update-status
    7. leader-elected
    8. leader-settings-changed
    
2. Hook sequence is **hardcoded**. This is defined in 
  `juju/worker/uniter/operation/runhook.go`. In other words, the
  transition from `install` to `upgrade-charm` is both guaranteed and
  mandatory. This limits how we can design our workflows.

# States

> Decorator: `@not_unless`, `@only_once`, `@when`, `@when_all`, `@when_any`, `@when_file_changed`, `@when_none`, `@when_not`, `@when_not_all`
> Definition: `charm.reactive/charms/reactive/decorators.py`

States were probably designed to fix the limitation that Hooks
present. States can be defined using arbitrary string <span
class="myhighlight">except</span> two reserved words `juju` and
`jujud`. Further, workflow of states are not fixed. States are
evaluated iteratively and a `true` condition will execute 
associated function block.

## When a state is true?

What defines a `true`? The code is defined in class `StateWatch` in
file `charm.reactive/charms/reactive/bus.py`. The value `changed` is
`true` when there are states to monitor (`set(states)` is not empty) and
there are changes (`data['changes]` is not empty).

```python
class StateWatch(object):
    ...
    
    @classmethod
    def watch(cls, watcher, states):
        data = cls._get()
        iteration = data['iteration']
        changed = bool(set(states) & set(data['changes']))
        return iteration == 0 or changed
```

What defines the values in `data['changes']`? There are only two
places to set this value: `set_state(...)` and `remove_state(...)`.
Looking at `set_state` reveals that if the state is already in
`old_states` list, it will not be set to `changed`, therefore the
`watch` will fail to identify this state and will not trigger an
execution. In other words, if a state becomes `true`, it will not be
re-evaluated until it is reset to `false` first.

> Reactive charm triggers only on state transitions:
> **False->True** (`@when`) or
> **True->False** (`@when_not`).

```python
def set_state(state, value=None):
    """
    Set the given state as active, optionally associating with a relation.
    """
    old_states = get_states()
    unitdata.kv().update({state: value}, prefix='reactive.states.')
    if state not in old_states:
        StateWatch.change(state)

```

## Namespace

There isn't really a namespace concept in charm. I'm borrowing the
term to illustrate state boundaries. The question is that if I can
define arbitrary states, in which scope are they visible? Can
`state.xyz` in charm A trigger an action in charm B? or in another
layer? or in another unit? or even a bundle?

To answer this, we need to examine how states are stored. The key
information can be found in `charmhelpers/core/unitdata.py` &mdash;
this is the storage class that is used by charm to store
states. Clearly the backend is a `sqlite3` database.

```python
class Storage(object):
    """Simple key value database for local unit state within charms.

    Modifications are not persisted unless :meth:`flush` is called.

    To support dicts, lists, integer, floats, and booleans values
    are automatically json encoded/decoded.
    """
    def __init__(self, path=None):
        self.db_path = path
        if path is None:
            if 'UNIT_STATE_DB' in os.environ:
                self.db_path = os.environ['UNIT_STATE_DB']
            else:
                self.db_path = os.path.join(
                    os.environ.get('CHARM_DIR', ''), '.unit-state.db')
        self.conn = sqlite3.connect('%s' % self.db_path)
        self.cursor = self.conn.cursor()
    ....
```

Function `_init(self)` reveals the table schema in this database
&mdash; three tables: `kv`,
`kv_revisions` and `hooks`. `kv` is the primary store as can be seen
in the `set_state` function above (`unitdata.kv().update(....`).

```python
def _init(self):
    self.cursor.execute('''
        create table if not exists kv (
           key text,
           data text,
           primary key (key)
           )''')
    self.cursor.execute('''
        create table if not exists kv_revisions (
           key text,
           revision integer,
           data text,
           primary key (key, revision)
           )''')
    self.cursor.execute('''
        create table if not exists hooks (
           version integer primary key autoincrement,
           hook text,
           date text
           )''')
    self.conn.commit()
```

What is not obvious is that each unit has its own DB. Therefore, the
boundary of states are **per charm unit**. In other words, states are
visible inside a unit. Using layers will package states inside a
single charm, but in run time it is the unit boundary that matters.

> States do not go across charms.
> Using the same charm, states do not go across units either.

# Dispatch

Reading function `dispatch` in
`charms.reactive/charms/reactive/bus.py` is interesting because there
is certainly something no document has mentioned. Dispatch is done in
two phases: **hooks** and **other**.

Hooks are run in the `hooks` phase. 
Registered hook will run its `test()` so this scan will test all hooks.

```python
def _test(to_test):
    return list(filter(lambda h: h.test(), to_test))

....

unitdata.kv().set('reactive.dispatch.phase', 'hooks')
hook_handlers = _test(Handler.get_handlers())
_invoke(hook_handlers)
```

States are run in the `other` phase.
The magic number `100` for-loop highlights an underline assumption
that states can converge within these iterations. Otherwise, state
watch is reset and will be count from 0 again during next iteration
&rarr; state effect can then ripple through one single iteration.

```python
unitdata.kv().set('reactive.dispatch.phase', 'other')
for i in range(100):
    StateWatch.iteration(i)
    other_handlers = _test(Handler.get_handlers())
    if not other_handlers:
        break
    _invoke(other_handlers)
```
