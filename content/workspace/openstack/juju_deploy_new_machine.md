Title: Juju deploy and Provider
Date: 2017-02-08 14:00
Tags: openstack
Slug: juju deploy provider
Author: Feng Xia

In [this][1] article, we have demonstrated how Juju deploys a charm,
including what makes a node eligible as a target and what files will
be put on by the deployer.If you recall, there were four steps in 
a deploy process:

[1]: {filename}/workspace/openstack/juju_deploy_charm.md

1. Add a new machine to the cloud environment. In the [demo][1],
   we added this machine manually using _juju add-machine_ command.
2. Machine-0 recognizes the new node.
3. CLI issues a deploy command.
4. Charm gets deployed.


This usecase, however, is somewhat backwards -- we have provisioned a
machine prior to the deploy command. Wouldn't it be better if the
command will signal the cloud provider to create a new machine on the
fly? MAAS provider can almost do just that.

# MAAS way of a deploy

We have briefly touched upon [the MAAS way][1].  By default, Juju
deploy will request for a new machine unless using the "--to [machine
number]" flag. While using MAAS it is seen that MAAS will turn a READY
machine into ALLOCATED then DEPLOYING. Once a Juju agent is installed
(provisioned), the agent executes application deployment.


<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20deploy%20target%20node%20state%20diagram.png" />
    <figcaption>MAAS target node state diagram during Juju deploy process</figcaption>
</figure>


# From CLI to provider

We know machine-0 will call MAAS's REST API to kick off the machine
provisioning process. But we do not know which API endpoint it is
using, and who is the caller inside machine-0 that makes this call.
[Priviously][1] we have analyzed this process from the outside &mdash;
files generated, states changed, application installed. Here we will
look into the code to understand how these steps take place.


## Overview of the agent

While looking at this process, one can't help noticing the key role
the juju agent plays. It seems to have intelligence that, once
installed, knows how to speak to the state controller (machine-0), how
to find and download a charm, and how to use it to deploy an
application. So just how are agents wired together?

<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20agent%20overview.png" />
    <figcaption>High level view of Juju agents in an environment</figcaption>
</figure>

The key of this diagram is that the agents are connected in a
    **client-server** configuration, where machine-0's agent is the
    _API server_ and all other agents are its clients. The API server
    provides a _facade_, a design pattern, which exposes functions for
    client to call. It is not clear yet how function is mapped to a
    string, eg. "Deploy" RPC will translate to facade's _Deploy()_
    function call.So Juju CLI is a client, same as a provisioned node.


## Machine-0, state, and provisioner

Now when agent, say the CLI, issues a command, to the API server, what
happens next? Juju's design maintains an internal state that are
persisted in a mongo DB. A command will cause a state change, eg. if
machine XYZ's current state is one that has no MySQL (state A), a
deploy MySQL command will generate a state B (=state A + MySQL
installed).  This change is then saved to the DB. There is a
background loop called **provisioner**, who monitors this state
change. The change(set) essentially has all the information the
provisioner needs to take an action so to bring machine from state A
&rarr; state B.

<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20machine%200%20state.png" />
    <figcaption>Machine-0 state & provisioner</figcaption>
</figure>

## Provisioner and provider

Ok, so the provisioner loop is the action taker. How is it aware of
the cloud provider? This is the final piece of the puzzle &mdash;
within the _provisionTask_ struct, there is a
_environs.InstanceBroker_. Now if you recall, the _environs_ is
another name for provider, where _InstanceBroker_ is a provider
interface! Bingo.

<pre class="brush:bash;">
type provisionerTask struct {
	controllerUUID             string
	machineTag                 names.MachineTag
	machineGetter              MachineGetter
	toolsFinder                ToolsFinder
	machineChanges             watcher.StringsChannel
	retryChanges               watcher.NotifyChannel
-->	broker                     environs.InstanceBroker
	catacomb                   catacomb.Catacomb
	auth                       authentication.AuthenticationProvider
	imageStream                string
	harvestMode                config.HarvestMode
	harvestModeChan            chan config.HarvestMode
	retryStartInstanceStrategy RetryStrategy
	// instance id -> instance
	instances map[instance.Id]instance.Instance
	// machine id -> machine
	machines map[string]*apiprovisioner.Machine
}
</pre>

## Call chain, and call to provider

Back to our initial question then &mdash; how a CLI deploy command can
kick off provider to create a new machine? The command chain is
roughly like this:

1. CLI will send a RPC request to API server (machine-0).
2. RPC figures out what the next state needs to be.
3. machine-0's agent write the change to DB.
4. Provisioner detects a state change.
5. Provisioner task calls _environs.broker.StartInstance_ function to
   kick off a new machine.

Mapping everything here into what's in the code, here is a
illustration showing call chain from one module to the next. Some of
them are just think wrapper of next function. The mapping between a
command to a state is taking place in _state.AddApplication()_ which
I'm highlighting in <font color="green">green</font>.

<figure class="row">
    <img class="img-responsive center-block" 
    src="/images/juju%20deploy%20call%20chain.png" />
    <figcaption>Illustration of call chain by "juju deploy" command</figcaption>
</figure>


