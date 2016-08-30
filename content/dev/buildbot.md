Title: Buildbot continuous integration set
Date: 2016-07-20 10:45
Tags: dev, ci, build
Slug: buildbot
Author: Feng Xia
Summary: Using Python Buildbot to set up a continuous integration
    workflow.


Continuous integration
=====================================

关于CI对内部开发的功效，以及选用的[buildbot](http://buildbot.net/)，
可以参见[IBM的这篇文章](http://www.ibm.com/developerworks/cn/linux/l-buildbot/index.html).
这里我们主要描述在linkage服务器上的基础环境搭建，如何增加新的测试机，和日常的工作流程三部分。

安装
--
如同以往，先选择一个python virtualenv，然后利用pip安装。

1. SSH登陆后
2. source .bashrc
3. workon build
1. pip install buildbot
2. pip install buildbot-slave

安装后的对于master和slave环境的设置详见[buildbot文档](http://docs.buildbot.net/current/tutorial/firstrun.html)。
在服务器上对应的环境路径为:

* master: ~/build-master
* slave: ~/build-slave

运行服务
----
1. 首先，切换到"build" virtualenv.
2. 启动master: buildbot start build-master
3. 启动slave: buildslave start build-slave

至此，启动完成，可以在[此处](http://fengxia.co:8011)察看，用户登陆信息
为:
* username: admin
* pwd: natalie

如果因为某种原因造成CI超时不响应或宕机，可以通过以下命令重启服务：
* master: buildbot restart build-master
* slave: buildslave restart build-slave

根据经验，服务启动是应遵循先启动master，再启动slave的原则。在实际使用中，这个顺序并没有
不良影响，但我们依然建议遵循此原则作为最佳实践。

build master配置
-------------------

系统配置的核心为build-master/master.cfg，对一个slave环境，只需改动两处：

1. 加载slave定义的.py（见import）
2. 加载slave中的配置到master

master.cfg可参见以下定义：

    # -*- python -*-
    # ex: set syntax=python:

    from buildbot.plugins import *
    from buildbot.plugins import steps
    from buildbot.plugins import status
    from buildbot.status import html
    from buildbot.status.web import authz, auth

    # <====================================
    # 此处加载不同slave， 如test_cheersum
    import test_gkp
    import test_jk
    import prod_fashion
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
    # 此处加载不同slave的配置到master。
    target = test_gkp.MyTarget()
    c['change_source'] += [target.change_source]
    c['schedulers'] += [target.scheduler, target.force_scheduler]
    c['builders'] += [target.builder]
    # <====================================

    ####### BUILDSLAVES

    # The 'slaves' list defines the set of recognized buildslaves. Each element is
    # a BuildSlave object, specifying a unique slave name and password.  The same
    # slave name and password must be configured on the slave.
    slave1 = buildslave.BuildSlave("myslave", "natalie")
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
        auth=auth.BasicAuth([("admin","Linabc123")],
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
    c['title'] = "Linkage project"
    c['titleURL'] = "http://www.linkage.top:8012"

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

master.cfg中的几个配置说明：

1. slave1 = buildslave.BuildSlave("myslave", "natalie"): 此处在建立
slave时定义，因此必须保持和build-slave中的配置一致。
2. auth=auth.BasicAuth([("admin","natalie")]: 为master网页界面的用户登陆名和密码

build slave配置
------------------

针对每一个测试环境，都应建立一个新的slave配置。以test_gkp为例：

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
                'git password': 'xf123456',
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

增加新的测试机
----------

CI实现的是从代码（GIT）到测试环境部署的全流程的自动化，因此CI的成功不仅依赖于对build
master和build slave的配置，还需要系统层面的系统服务配置，端口分配，
NGINX代理配置等。此处，我们重点针对buildbot的环境配置。

1. 创立新的slave配置.py.
2. build-master/master.cfg加载新的配置.
3. 重新加载master.cfg: buildbot reload build-master，或重启build-master.
4. 在网页端确认有新的slave.
5. 测试force build.

日程工作流程
------

CI前期配置完成并通过测试后，日常的工作流程被大大简化。开发人员只需要在本地测试通过后提交
代码到build slave跟踪的GIT分支，然后等待CI自动更新公用的测试环境。如果是hot fix提交，
也可由CI的管理员启动force build, 强制更新测试环境。
