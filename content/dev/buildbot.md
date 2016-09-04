Title: Buildbot continuous integration setup
Date: 2016-07-20 10:45
Tags: dev, ci, build
Slug: buildbot
Author: Feng Xia

The whole point of quick development cycle is to shorten
the path between a verbal or written requirement, and an actionable
application that reflects an implementation of this requirement. Therefore,
it becomes crucial to set up an CI environment not only to facilitate
development and testing, but to enforce our practice of agile prototyping
by setting up a complete automated test instance for our clients that closely
mirrors development progress. Once achieved, clients and developers can now
truely accalaim that they are *on the same page*.

# Buildbot

We chose [buildbot](http://buildbot.net/) as our CI tool.
Another common choice is the [jenkins](https://jenkins.io/). Jenkins
is in Java. So in order to maintain a technology stack as consistent as
we can, we opted to buildbot for this purpose.

## Installation

Create a python virtualenv and use pip is all it takes:

1. workon build
2. pip install buildbot
3. pip install buildbot-slave

For configuration, you can refer to
[buildbot tutorial](http://docs.buildbot.net/current/tutorial/firstrun.html)
for more details.

On our test server, we have set the paths to:

* master: ~/build-master
* slave: ~/build-slave

## Run service

1. activate *build* virtualenv.
2. to start master: buildbot start build-master
3. to start slave: buildslave start build-slave

To view and administrate our [CI server](http://fengxia.co:8011):
* username: admin
* pwd: xxxxxx

To restart master and slave:
* master: buildbot restart build-master
* slave: buildslave restart build-slave

If config has been modified, it is useful to run *buildbot checkconfig build-master*
to check configurations for error.

Note that it is recommended to start master before the slave.
In practice we have not experienced any problem if this order was reversed.


## Build master configurations

We modified the stock *master.cfg* to make slaves modular. With this,
adding a new slave only requires two changes:


1. import slave's .py
2. add slave configurations to master (nearly a copy and paste)

Sample *master.cfg* is shown here:

    # -*- python -*-
    # ex: set syntax=python:

    from buildbot.plugins import *
    from buildbot.plugins import steps
    from buildbot.plugins import status
    from buildbot.status import html
    from buildbot.status.web import authz, auth

    # <====================================
    # import slave configuration
    import test_gkp
    # <====================================

    # This is the dictionary that the buildmaster pays attention to. We also use
    # a shorter alias to save typing.
    c = BuildmasterConfig = {

        ####### CHANGESOURCES
        # the 'change_source' setting tells the buildmaster how it should find out
        # about source code changes.  Here we point to the buildbot clone of pyflakes.
        'change_source': [],

        ####### SCHEDULERS
        # Configure the Schedulers, which decide how to react to incoming changes.  In this
        # case, just kick off a 'runtests' build
        'schedulers': [],
        'builders': []
    }

    # <====================================
    # Add slave configuration to master
    target = test_gkp.MyTarget()
    c['change_source'] += [target.change_source]
    c['schedulers'] += [target.scheduler, target.force_scheduler]
    c['builders'] += [target.builder]
    # <====================================

    ####### BUILDSLAVES

    # The 'slaves' list defines the set of recognized buildslaves. Each element is
    # a BuildSlave object, specifying a unique slave name and password.  The same
    # slave name and password must be configured on the slave.
    slave1 = buildslave.BuildSlave("myslave", "xxxxxx")
    c['slaves'] = [slave1]

    # 'protocols' contains information about protocols which master will use for
    # communicating with slaves.
    # You must define at least 'port' option that slaves could connect to your master
    # with this protocol.
    # 'port' must match the value configured into the buildslaves (with their
    # --master option)
    c['protocols'] = {'pb': {'port': 9989}}

    # including web pages, email senders, and IRC bots.

    c['status'] = []
    irc_status = status.IRC(
        host="irc.freenode.org",
        nick="TEST-Build",
        channels=["#fengxia.co"]
    )
    c['status'].append(irc_status)

    authz_cfg=authz.Authz(
        # change any of these to True to enable; see the manual for more
        # options
        auth=auth.BasicAuth([("admin","xxxxxx")],
        gracefulShutdown = True,
        forceBuild = 'auth', # use this to test your slave once it is set up
        forceAllBuilds = 'auth',  # ..or this
        pingBuilder = False,
        stopBuild = True,
        stopAllBuilds = False,
        cancelPendingBuild = True,
    )

    ####### STATUS TARGETS
    # 'status' is a list of Status Targets. The results of each build will be
    # pushed to these targets. buildbot/status/*.py has a variety to choose from,
    c['status'].append(html.WebStatus(http_port=8010, authz=authz_cfg))

    ####### PROJECT IDENTITY
    # the 'title' string will appear at the top of this buildbot
    # installation's html.WebStatus home page (linked to the
    # 'titleURL') and is embedded in the title of the waterfall HTML page.
    c['title'] = "Fengxia.co"
    c['titleURL'] = "http://fengxia.co"

    # the 'buildbotURL' string should point to the location where the buildbot's
    # internal web server (usually the html.WebStatus page) is visible. This
    # typically uses the port number set in the Waterfall 'status' entry, but
    # with an externally-visible host name which the buildbot cannot figure out
    # without some help.
    c['buildbotURL'] = "http://localhost:8010/"

    ####### DB URL
    c['db'] = {
        # This specifies what database buildbot uses to store its state.  You can leave
        # this at its default for all but the largest installations.
        'db_url' : "sqlite:///state.sqlite",
    }

A couple notes of master.cfg connfigurations:

1. slave1 = buildslave.BuildSlave("myslave", "xxxxxx"): the name and password
must be the same as the ones used to create build-slave.
2. auth=auth.BasicAuth([("admin","xxxxx")]: defines the admin username
and password to buildbot's admin web UI.

## Build slave configurations

We set up a new configuration for each slave, which corresponds to a project.
Take *test_gkp* configuration for example:

    # -*- python -*-
    # ex: set syntax=python:

    from buildbot.plugins import *
    from buildbot.plugins import steps
    from buildbot.plugins import status

    class MyTarget():
        def __init__(self):
            # project configs
            self.name = 'test-gkp'

            project_configs = {
                'git': 'http://fengxia41103:xxxxxx@github.com/fengxia41103/gkp.git',
                'git username': 'fengxia41103',
                'git password': 'xxxxxx',
                'git source': '~/build-slave/mybuild-%s/build'%self.name,
                'build name': 'mybuild-%s'%self.name
            }

            self.change_source = changes.GitPoller(
                project_configs['git'],
                branch='master',
                pollinterval=300)

            ####### SCHEDULERS
            self.scheduler = schedulers.SingleBranchScheduler(
                name="%s-all"%self.name,
                change_filter=util.ChangeFilter(branch='master'),
                treeStableTimer = 300,
                builderNames=[project_configs['build name']])
            self.force_scheduler = schedulers.ForceScheduler(
                name = '%s-force'%self.name,
                builderNames = [project_configs['build name']])

            ####### BUILDERS
            # The 'builders' list defines the Builders, which tell Buildbot how to perform a build:
            # what steps, and which slaves can execute them.  Note that any particular build will
            # only take place on one slave.
            factory = util.BuildFactory()

            # check out the source
            get_source = steps.Git(
                repourl = project_configs['git'],
                mode='full'
            )
            restart_nginx = steps.ShellCommand(
                command = [
                    'sudo',
                    'service',
                    'nginx',
                    'restart',
                ],
                usePTY = True,
                description = 'restarting nginx service',
                descriptionDone = 'nginx reservice has been restarted'
            )

            factory.addStep(get_source)
            factory.addStep(restart_system_service)

            self.builder = util.BuilderConfig(
                name=project_configs['build name'],
                slavenames=["myslave"],
                factory=factory)

## Add a new project to CI

Adding a new project to CI takes a few steps:

1. Create slave configuration .py.
2. Add it to build-master/master.cfg.
3. Restart build master: buildbot restart build-master.
4. Login to buildbot admin web UI to confirm that slave has been added successfully.
5. Force a build to test.

## Daily workflow

Once CI has been integrated, developer needs only submit changes to Git
and wait for the next build to refresh the test environment. For *hot fixes*
build master can also kickoff a force build to make the changes avaialbe
immediately in test environment.
