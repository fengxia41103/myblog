Title: Introduction of Juju charms
Date: 2017-02-28 17:00
Tags: openstack
Slug: juju charm layers
Author: Feng Xia
Status: Draft

Juju [charms][1] are, charming. It promises a selection of blueprints
that hold magic to make an application deployment easy. But devils are
in the details, as always the case. In this article we will walk in
the charm world to learn its design. 

[1]: https://jujucharms.com/

# Bundle, charm, service, application

Juju [terms][2] can be confusing. Approximately they can be viewed in a
tree model, where a bundle can have multiple charms, a charm can
contain multiple [services][12], a service is composed of one or more
applications and a group of [relations][4], and 
a relation, if defined, must be one of the two types:

1. **provide** (eg. I am MySQL and I provide a SQL database relation).
2. **require** (eg. I'm Mediawiki and I require a SQL database).

<figure class="row">
<img class="img-responsive center-block"
src="/images/juju%20control%20modeling.png" />
<figcaption>Juju control modeling</figcaption>
</figure>


[2]: https://jujucharms.com/docs/stable/juju-concepts
[3]: https://jujucharms.com/docs/stable/charms
[4]: https://jujucharms.com/docs/1.24/charms-relations
[12]: https://jujucharms.com/docs/2.0/authors-subordinate-services

In term of deployment, a service can be deployed to more than one
machine so as to achieve HA; a machine can also have more than one
services. Here we use the term machine broadly because it can also be
a single LXD container, so in this case there can be many containers
in a single VM, and many VMs on a single physical _machine_.

# Charm and layers

How does a charm describe an application and its relations then? The
anwser is: **layers**. A charm is built from three layers:
[basic/runtime layer][5], [interface layer][6], and charm layer. Basic
layer is like a library &mdash; common parts that many applications
can use without conflicts. Thing like DB services, HTTP server,
storage should belong to this category. Interface layer is an abstract
of what a charm exposes for consumption. Case in point will be any
database charm, who should always define an interface to exchange DB
login credentials and ports. Charm layer is application specific, and
its logic is following the [reactive pattern][10].

[5]: https://jujucharms.com/docs/stable/developer-layers#base,-or-runtime,-layers
[6]: https://jujucharms.com/docs/stable/developer-layers-interfaces

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/juju%20charm%20layers.png" />
    <figcaption>Juju charm layers</figcaption>
</figure>

## Hooks and Reactive pattern

Previously, charms are written as a list of [hooks][15] responding to
events. This is still true because hooks are the actual
scripts. Any charm supports the following hooks:

[15]: https://jujucharms.com/docs/2.0/reference-charm-hooks

1. install
2. config-changed
3. start
4. upgrade-charm
5. stop
6. update-status
7. leader-elected
8. leader-settings-changed

where each event also has four _relation hooks_:

1. [name]-relation-joined
2. [name]-relation-changed
3. [name]-relation-departed
4. [name]-relation-broken

This will give us total of 32 different hooks to choose from. But what
if we want to do something based on a combination of the above events,
and maybe even with some logics &rarr; run this script _after install
is done, and the application has stopped, and a
[update-status]-relation-joined has occured_? This is messy.

So instead of individual hooks, we have now a better way to capture
this concept using **[States][16]** &mdash; [reactive pattern][10].  A
charm can define arbitrary state, say **foo**. Another charm can then
uses Python decorator, eg. **@when**, **@when_not**, to specify the
status of **foo**, which then determined whether the function will be
executed. I suppose the framework itself handles event polling,
broadcasting and the like.

[10]: https://pythonhosted.org/charms.reactive/
[16]: https://jujucharms.com/docs/stable/developer-layers#states

## Basic/runtime layer

There are two ways to construct basic layer: use an existing one, such
as the [apache-php][7], or use the [basic layer][8] template to write
your own. Don't forget to check out these existing [runtime layers][9]
for reuse. _Note_: which one can be reused, and which one can not? I
don't see any document to distinguish this.

[7]: https://github.com/johnsca/apache-php
[8]: http://github.com/juju-solutions/layer-basic
[9]: https://github.com/juju-solutions

## Interface layer

[Interface layer][6] defines both the _provides_ and the _requires_.
One thing to remember is that relation does not define the actual
connection at all! What it does is to pass along configurations
&mdash; IP address, port, user name, password, and such. For example,
if there is a MySQL _provides_ and Wordpress _requires_, Wordpress
will read from the providing side of configurations needed to make the
connection.

<figure class="row">
<img class="img-responsive center-block"
src="/images/charm%20relation%20and%20interface.png" />
<figcaption>Charm relation and interface</figcaption>
</figure>

### Communication scope

Interfaces are categorized into three [communication scopes][11]:
global level, service level, and unit level. Again, they are grouping
concept, where unit is the atom (and the default level). Multiple
units can belong to a service level, and everything else goes into
global level. 

[11]: https://jujucharms.com/docs/stable/developer-layers-interfaces#communication-scopes

The communication scope is closely related to
the [relationship lifecycle][13], where units in the same scope will
have data broadcasted to them so they will be aware of each other's
state. Therefore, unit level can be used for application that provides
no relation and has no peer-to-peer need; service level is certainly
**providing** some type of relation so others can leverage; and global
is just a catch-all scope.

[13]: https://jujucharms.com/docs/2.0/authors-relations-in-depth

### Relation and Interface

So how does relation and interface come into play? Declaring relation
is a strong statement. As we have already mentioned, there are two
types of relations: _provides_ and _requires_. The provides and
requires keys defined in metadata.yaml are used to define pairings of
charms that are likely to be fruitful. Consider mongodb's metadata:

<pre class="brush:bash;">
name: mongodb
...
provides:
  database:
    interface: mongodb
</pre>

where in another metadata who is on the receiving end of this relation:

<pre class="brush:bash;">
name: my-node-app
...
requires:
  database:
    interface: mongodb
provides:
  website:
    interface: http
</pre>

[14]: https://jujucharms.com/docs/stable/authors-relations

The word **database** is the relation name. There is no restriction to
it except it can not be _juju_ or _jujud_. Relation name serves as a
grouping because each relation can have more than one interface.

The interface name, _mongodb_, is important, since it is being used to
look up an existing [relation registry][15] for a match. I think this
is how charm build can pull in dependencies of other charms/layers.

[15]: http://interfaces.juju.solutions/


## Charm layer

This is where the application logics live.

# Screencast

See the process in action:

<figure class="row">
    <img class="img-responsive center-block"
    src="/images/vanilla%20charm%20deploy.gif" />
    <figcaption>Screencast showing deploying a Vanilla charm</figcaption>
</figure>
