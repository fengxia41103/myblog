---
title: M3 CICD
subtitle: Version 1.0
author:
  - Feng Xia

bibliography: feng.bib
logo: "../../images/dhhs-logo.png"
keywords: [UNC, Schema]
draft: True
abstract: |

  CICD devops

---

This document is to describe the CICD process of M3 application,
whereas many of the steps and principles apply to other application,
also.

# CICD

CICD is a general term refers to a process in which a code change will
be tracked and deployed **continuously** by a set of tools
which we will go into details below.

There is no fixed recipe on which tool one should use, and how a CICD
process should be like. Choices here are made based on proof of
strength from a wide range of industrial practice and feedback that
have testified positive result, thus increasing our chance of success,
and by careful consideration of the nature of the applications we are
to support, infrastructure environment, team experience with such
practice, and anticipation of technology migration in the future once
complexity and maturity grow.

These components thus form the foundation of today's CICD framework
that is not only supporting this application, but being a corner stone
for other application to follow the same path or similar advance so
that they could also benefit from these technologies and
experience.


# Code Repositories

There are two code repositories to track:

| Code Repository | Description      | Location             |
|-----------------|------------------|----------------------|
| `m3-app-d3`     | Application code | [bitbucket][m3-code] |
| `cicd_template` | Deployment code  | [bitbucket][cicd]    |

## Application code repository

This code repository is application specific. Each application such as
`m3`, `voting` has its own repository. Development effort for application
functions are taking place in this repository.

For a complex application, its function code can be broken down to
multiple repositories. Each repository is managed similarly following
the workflow that is laid out below. How these components are
integrated is outside the scope of this document.

## Deployment code repository

This code repository is **not** application specific. It defined an
unified method to deploy an application regardless its function
implementation. Since each application can be based on different
technology stack, deployment defines common ground within which an
application will appear to be similar or identical.

Two such common grounds are:

1. Application packaging: all applications are packaged as Docker image or images.

2. Deployment orchestration: deployment of dockers are orchestrated by `docker-compose`.

# Code maturity

A development change regardless of application or repository follow
the same three maturity levels: development, staging,
production. This division is then mapped by Bitbucket's branching
strategy.

In nutshell, code in development level is unstable and subject to
change often as developer actively adding new function and changing
old functions. Code in staging level is a release candidate, thus
should have met a quality criteria such as passing all unit tests. Code
in production level is the most stable one among three.


## Development

Also know as the **sandbox**.

Development phase is for dev team to design, develop, and test
application functions, fixing bugs, building prototypes, and so
on. Correspondingly, these activities are to be reflected as code
changes in the `dev` branch of a code repository.

Any application instance deployed using the `dev` code is
subject to be unstable. Developer can directly modify a live
instance either through CICD or other means so to facilitate
development and debugging.

## Testing

Also known as the **staging**.

After functions have been developed and tested to certain degree of
satisfaction in the development phase, they may be considered a
release candidate. Such candidatancy requires more, sometimes
different, verification in addition to what were seen during the
development phase.

During this phase, an application instance will be created from `test`
branch of code repository. No code modification by developer to this
branch is allowed unless it is by pull request and has been approved
by peer-reviewed. The number of approval required and other criteria
can be configured in Bitbucket on a per-repository basis.

## Production

Code deployed to a production can only come from the `main`
(aka. `prod`) branch of a repository. Changing code in this branch is
forbidden except by designated personnel in additional all the review
requirements applicable for the `test` branch. In Bitbucket, this
branch should be **protected/locked** except when a release is being
cut. For details of cutting a release, see section "Release Process".

# Code version control & development

## Version Control

Each Bitbucket repo must have these three branches:

| Git Branch | CICD Pipelines          | aka.                                  | Code Maturity |
|------------|-------------------------|---------------------------------------|---------------|
| `main`     | build-prod, deploy-prod | production, prod                      | prod          |
| `test`     | build-test, deploy-test | UAT, pre-production, staging, testing | staging       |
| `dev`      | build-dev, deploy-dev   | development main                      | development   |

In addition one can have as many feature branches, releases branches,
hotfix branches and so on as one likes.

## Development

Code development follows the standard git workflow and common software
development practices. Development works are based on `dev` branch
**only**., and changes are only merged back to the `dev` branch.

![](../../images/unc/software%20development.png)

# M3 CICD

CICD activities are divided in two steps: build and
deploy.

![](../../images/unc/workflow%20overview.png)

- The build is focusing on converting source code to
  artifacts. Artifacts are usually in binary form such as executable,
  `.iso` image, and the like. More and more are further packaged into
  an archive format with meta information so that package manager as
  the installer in a conventional sense can determine its dependency,
  installation destination, and so on. What drives the

- The deploy takes up from artifacts. It is focusing on converting
  artifacts to a running instance.

| CICD Pipeline | Input           | Output                             |
|---------------|-----------------|------------------------------------|
| Build         | Bitbucket       | docker images in `harbor` registry |
| Deploy        | built artifacts | running instance                   |

For a full end-2-end CICD experience, `deploy` is setup to be run upon
`build` succeeds.

## Build

### Application code

For dockerized application, two files should be in the application
code repository. This is applicable to all three branches.

1. `Dockerfile` must be at **the root of the repo**.
2. One `Jenkinsfile.build`, which later corresponds to one pipeline in
   Jenkins.

### Setup build Jenkins Pipeline

Copy `Jenkins.build` from the `cicd_templates` repo to your
application's repo root. Nothing needs to be changed in this file. All
dynamic values will be passed in as Jenkins' parameter.

#### Create a new `build` pipeline

1. Login in `jenkins-dev`, choose `New item`
2. Naming convention for build pipeline: `<your-project-name>-build`.
3. Choose `copy from`, and select `Template-App-Docker-Build`.

      ![](../../images/unc/build%20template.png)

4. Click `Ok` to create new template.

#### Configure a `build` pipeline

You need to set a minimal set of values specific to your application
in a new build pipeline created from a `build` template pipeline:


1. Select `Dockerfile`. Default to `./Dockerfile`. You can then setup
   multiple pipelines, one per `Dockerfile` if your application builds
   multiple artifacts.

      ![](../../images/unc/build%20template%20dockerfile.png)

2. Set docker registry. Once docker image is built, it will be pushed
   to this registry's repo. For harbor, the value is in form of
   `<project>/<repo>`:

      1. `<project>` needs to be created in harbor directly and should be
         the name of the application.
      2. `<repo>` can be any string value, and will be created by the
         pipeline in registry upon build success.

      ![](../../images/unc/build%20template%20docker%20registry.png)

3. Set repo to monitor. The `Branch Specifier` value determines which
    branch it is to build. Choose `*/dev` to build dev branch, and so
    forth that `*/test` and `*/master`.

      ![](../../images/unc/build%20template%20repo%20to%20monitor.png)



## Deploy

This is the step to transfer artifacts, in our case, application Docker images,
onto a deployment host, then bootstrap the application.

![](../../images/unc/cicd%20deploy.png)

### Setup deploy Jenkins Pipeline

#### Create a new `deploy` pipeline

Similar to creating a `build` pipeline, we use a `deploy` template as
the cookiecutter to create a new `deploy` pipeline:

1. Login in `jenkins-dev`, choose `New item`
2. Naming convention for build pipeline: `<your-project-name>-deploy`.
3. Choose `copy from`, and select `Template-App-Deploy`.

      ![](../../images/unc/deploy%20template.png)

4. Click `Ok` to create new template.

#### Configure `deploy` pipeline

Similar to creating a `build` pipeline, we use a `deploy` template as
the cookiecutter to create a new `deploy` pipeline:

1. Login in `jenkins-dev`, choose `New item`
2. Naming convention for build pipeline: `<your-project-name>-deploy`.
3. Choose `copy from`, and select `Template-App-Deploy`.

      ![](../../images/unc/deploy%20template.png)

4. Click `Ok` to create new template.

# Release process

Release process is based on the code maturity we have discussed
above. In essence release of an application is when its code moves
through the maturity levels from development to staging, then finally
to production. This corresponds to a code change first merged to the
`dev` branch, then to the `test` branch, and then to the `main`
branch.

![](../../images/unc/release%20process.png)


# CICD Design Details

This section covers details of CICD design including code structure,
constants such as host names, file and variable naming convention, and so on.

## Deployment networking proxy

![](../../images/unc/deployment%20networking%20proxy.png)

## Ansible

To use these ansible playbooks from your local computer/dev env is really easy.

```
ansible-playbook ansible/main.yml -i ansible/hosts -l test -e
"APP_NAME=<app>  DEPLOY_TO=<env>" -u <username>
```

1. Replace `app` with your application name, eg. use `m3` for M3.
2. Valid choices are listed in `hosts` file, eg. `dev`.
3. Replace user name with your SSH username to the deployment
   host. For example, if you selected `dev` in previous step, then we
   expect the username here has SSH access to all the hosts listed
   under the `dev` host group.

### env/host values

| Env      | Host                     | Reverse Proxy Server | Used By           | Port Assignment Suffix |
|----------|--------------------------|----------------------|-------------------|------------------------|
| dev      | docker-dev.med.unc.edu   | www-dev.med.unc.edu  | dev ONLY          | 10                     |
| test     | docker-nip0.med.unc.edu  | app-test.med.unc.edu | internal test/UAT | 20                     |
| prod     | docker-prod0.med.unc.edu | app.med.unc.edu      | prod ONLY         | 30                     |
| nondev   | test + prod              | n/a                  | non-dev           | n/a                    |
| all      | all host                 | n/a                  | n/a               | n/a                    |


Note:

- `port assignment suffix` is used together w/ a prefix to determine
  the host post the application can map to. This is **assuming** that
  each application is only exposing **one port** to the host.

### port assignment

Port assignment is using naming convention `<prefix><port suffix>`. For example,
M3 prefix is `201` and suffix is `10` for `dev`, thus rendering port `20110` for
M3's dev env.


| App    | Prefix | Env  | Host Port           |
|--------|--------|------|---------------------|
| m3     | 201    | dev  | 20110               |
| m3     | 201    | test | 20120               |
| m3     | 201    | prod | 20130               |
| voting | 200    |      | 20010, 20020, 20030 |
| seekr  | 202    |      | 20210, 20220, 20230 |
| gns    | 203    |      | 20310, 20320, 20230 |

### file structure

Ansible file structure is based on
[roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html).

1. Global level configurations are in `group_vars`.
2. `host` is the inventory list where you define deployment host info,
   eg. `docker-dev.medu.edu`.
3. `main.yml` is the `main` code entry playbook.
4. `roles/` includes a list of _sharable_ roles named `common-xxx`,
   and one role per application, eg. `/m3` for the M3 application.

```
ansible
├── group_vars
│   ├── all
│   ├── prod
│   └── test
├── hosts
├── main.yml
└── roles
    ├── common-run
    ├── common-setup
    ├── common-teardown
    ├── example-app-setup
    ├── gns
    ├── m3
    ├── seekr
    └── voting
```

### inventory

Ansible inventory defines list of servers, in our case, the deployment
target, eg. `docker-dev`.

We further group servers into `dev`, `test` and `prod`, assuming
servers under a group can be treated the same way, eg. we can deploy
to all servers under `dev` by running playbook using the `-l dev` switch.

```conf
# used by DEV
[dev]
docker-dev.med.unc.edu

# aka. staging, for UAT
[test]
docker-nip0.med.unc.edu

# public
[prod]
docker-prod0.med.unc.edu
```

### global config

Global configs are divided into `all`, `test`, and `prod`.

`all` defines the default global settings:

| Variable               | Description                  | Default                                    |
|------------------------|------------------------------|--------------------------------------------|
| `docker_registry_host` | Registry server              | `harbor-dev.med.unc.edu`                   |
| `launchpad_root`       | Target host bootstrap folder | `/var/lib-persist/<app>-<dev\|test\|prod>` |



The `prod` and `test` configs provide specific override or complementary info if
one runs ansible playbooks w/ the `-l <dev|test|prod>`. The name `dev`
or `prod` **must match** inventory group name.

### main playbook

The `main.yml` is the main entry point of running these playbooks.

```shell
ansible-playbook ansible/main.yml -i ansible/hosts -l test -e
"APP_NAME=<app>  DEPLOY_TO=<env>" -u <username>
```

The main playbook does three things:

1. Run common setup: tasks to setup the target environment,
   eg. particular file structure we'd like to have, such as
   `/var/lib/docker-persist/<app>/...`.
2. After the common file structure in place on the target, it runs
   application specific setup playbooks defined in each app/role. This
   is where application `docker-compose` and the like gets copied to
   over to the target.
3. Run the application by evoking `docker-compose`. **Note** that this
   is a common step because we are currently assuming all applications
   will be using `docker-compose` to bootstrap.

```yaml
  tasks:
    - name: Common launchpad folder setup
      import_role:
        name: common-setup

    - name: App specific setup

      import_role:
        name: "{{ APP_NAME }}"

    - name: Start services
      import_role:
        name: common-run
```

### roles

Roles are divided into two groups: sharable ones w/ a naming
convention of `common-xyz`, and others which is usually the name of
an application, thus having application specific ansible pieces:

| Role            | Description                                                                        |
|-----------------|------------------------------------------------------------------------------------|
| common-setup    | Sharable roles to setup common file structures on the deploymene target            |
| common-run      | Sharable roles to bootstrap application via `docker-compose`                       |
| common-teardown | Sharable role to `compose down` an application, and remove its files from the host |
| m3/voting/..    | Role for an application                                                            |

### role file structure

Ansible roles follow a specific [file
structure](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#role-directory-structure). We
use the same convention. In a nutshell:

| Folder    | Description                                                    |
|-----------|----------------------------------------------------------------|
| files     | Static files, eg. `docker-compose.yml`, `.conf`, and DB `.sql` |
| tasks     | Playbooks                                                      |
| templates | `.j2` templates                                                |
| vars      | Ansible vars, eg. application port assignment                  |

### application port assignment

Applying the port assignment takes 4 steps:

1. Define port as `vars`.
2. Remove port mapping in the main `docker-compose.yml`.
3. Add a compose override as `.j2` template.
4. Launch the application using both the main compose and the
   override.

#### Define port as vars

Port assignment is defined in `roles/<app>/vars`. Use `m3` for
example:

```shell
ansible/roles/m3/
└── vars
    ├── dev
    ├── prod
    └── test
```

and in `vars/dev` one finds:

```yaml
host_port: 20110
```

#### main docker-compose


Use `m3` for example. First, the main compose file is in
`/files/docker-compose.yml`. **Note** that the `nginx` service has no
port mapping defined!

```yaml
version: '3'

...

services:
  nginx:
    image: nginx
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - ../static:/static:ro
    command: [nginx-debug, '-g', 'daemon off;']
    networks:
      - management
    depends_on:
      - web

...
```

#### compose override `.j2` template

Next, define a `.j2` template:

```shell
ansible/roles/m3/
├── templates
│   ├── docker-compose-override.j2
```

And in the `.j2` one creates a `compose` like block, whereas the
service name we are to override w/ the port mapping **must match** the
main `compose` file, in our case, `nginx` block. **Note** that we are
defining a port mapping using the `host_port` var.


```
version: '3'

services:
  nginx:
    image: nginx
    ports:
      - "127.0.0.1:{{ host_port }}:80
```

#### launch app w/ main compose & override

If you are to manually test this setup, `docker-compose -f
docker-compose.yml -f docker-compose-override.yml up`. **Note** order
is important that override must be after the main compose.

If using ansible, the `common-run` has been coded to handle this setup
automatically:

```yaml
- name: Create and start services
  community.docker.docker_compose:
    project_src: "{{ launchpad_root }}/control"
    files:   <==== HERE!!!
      - docker-compose.yml
      - docker-compose-override.yml
    state: present
    pull: yes
    project_name: "{{ APP_NAME }}"
```


[m3-code]: https://bitbucket.org/uncsom/m3-app-d3/
[cicd]: https://bitbucket.org/uncsom/cicd_template/src/master/
