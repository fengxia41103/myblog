Title: Git & Jira
Date: 2020-05-01 15:11
Slug: git and jira
Author: Feng Xia

# Introduction

We use Jira for project manage, and git for code. W/ a plugin, Jira is
able to integrate w/ Gitlab such as create a link to git commit as
comment. However, it has not the capability to create statistic
analysis of git commits within Jira, for example, how to know the
number of line changes of a Jira (number of line changes are a good
indicator of workload as well as a hotspot of bugs), and vice versa,
how to know a commit is part of a release 5.1.1 (the `fix version`
attribute in Jira)? If we are to generate a **release note** of a
release, wouldn't it be nice if it listed out:

- list of Jira &rarr; tasks the team wants to achieve in planning
- list of commits &rarr; actual code changes/contributions
- statistics of grouped information such as number of commits by Jira
component, or label
- developer contributions: who changed which file, and how much was
changed

Further, when team follows a development workflow, such as the
_popular_ [git
strategy](https://nvie.com/posts/a-successful-git-branching-model/),
it is impossible for manager to identify violation w/o bringing
information from both Jira and git together for cross reference,
whether manually or automated. Once we follow the development chain
from dev to CICD to various version of testing/QA, this dilemma is
compounded even more &mdash; how do I know CICD is building the right
source? how do I know QA is testing the right feature? and how do I
know what is deployed on a stack is the right code?

Essentially, if we agree that QA is a **MUST** to protect code
quality, then QA is also a **MUST** to protect process quality. Such
QA for management is harder than code's because it is less well
understood, thus more difficult to quantify, to standardize, and to be
assisted by system &mdash; if CICD is now a cliche in any software
development project, a management version of CICD is not yet an
essence.

This tool is to solve this.

# Strategy

Building cross reference is an information asymmetry challenge &mdash;
we have multiple information sources scattered in different form,
place, by different owner. Logically, their data have relation to each
other as the status of one becomes the trigger/input for another. The
strategy to solve this challenge is:

1. Develop data extractor that brings these scattered  information
into one place &larr; 1st tier data.
2. Checking consistency of cross reference, eg. a Jira status of "work
in progress" should not find an associated git commit already lived
in a release, not to mention already deployed into production!
3. Derive 2nd tier data, such as aggregated statistics following their
logical relationships, so to provide insight to the overall
development activities measured by management expectation.

Following the [five-level capability model](), this strategy will
fulfill level 1-3:

- level 1 inventory: have mechanism to collect needed information bits
- level 2 expectation & reality: map out models and relationships
between expectation and reality. For example, management expectation
is represented by Jira items while development reality represented
by code in git. The tool will build cross reference of the two. With
growth of knowledge, we can bring in more related information bits,
thus extending the scope these cross references.
- level 3 diff = expectation - reality: Identify gap between an
expectation and the reality, thus signaling an execution gap that
requires management attention.

# Information bits

What information do we have? Following the development pipeline described
in the diagram below, pretending we are development for a release
called `5.1.1`, let's focus on what is in Jira and what is in Git:

- Jira: two buckets &mdash; 5.1.1 related vs. non-5.1.1 related
    1. 5.1.1 items: three kinds
    
        1. 5.1.1 features
        2. Bugs: two types of bugs:
        
            1. bugs found in other version, and will be fixed in this release.
            2. bugs found in `5.1.1` (maybe during development), and needs to
               be fixed in this release.
               
        3. 5.1.1 non-code related activities &mdash; managerial, logistics
    
    2. non-5.1.1 items
   
- Git: two buckets &mdash; code/branch that will be included in 5.1.1 build
  vs. those that will not be included.
  
    1. Release 5.1.1 branches/code: two types:
    
        1. new code: including newly added code, deleted and/or
           modified old code that was done for the purpose of
           5.1.1. Following the Jira categories above, there are two
           types, and within each, there is Jira tracked
           vs. not-tracked.
           
            1. features: new code for implementing a feature:
            
                - jira tracked: has logical relationship between the
                   code work and a Jira ticket
                - **not-tracked**: code was made either w/o a Jira,
                   eg. ad-hoc code change not linked to a planned
                   activity, or a missing cross reference between the
                   two which made this change
                   difficult to trace in term of management visibility.   
            2. bugs: new code for fixing a bug (remember, two types of
               bugs). Similar to the feature code changes, they can be
               either Jira tracked, or not-tracked.
                - jira tracked
                - not-tracked
              
        2. old code that didn't change, but will be part of 5.1.1
           &larr; regression.
           
    2. Non-5.1.1 branches: these code will not be part of the 5.1.1
       release in term of build and release. Similarly, it can be
       divided into new code vs. old code.

        - new code
        - old code 

<figure class="col s12">
  <img src="images/gitjira/git%20and%20jira.png" />
  <figcaption>
    Git & Jira information bit of a release v5.1.1
  </figcaption>
</figure>

If we could harness all these information bits and categorize them, we
will be able to answer:

| Creator | Information                                                       | Info Source                 |
|---------|-------------------------------------------------------------------|-----------------------------|
| Manager | What 5.1.1 items to work on &rarr; todo list                      | Jira, filtered by `release` |
| Dev     | What is in the 5.1.1 code?                                        | Git                         |
| CICD    | Which 5.1.1 code is in build? Is build clean?                     | Jenkins, artifacts          |
| devops  | Which instance has the 5.1.1 build?                               |                             |
| QA      | Test coverage of 5.1.1 code?  Is 5.1.1 affecting older functions? | QA repo, report             |

# Application design

The application is a modern data driven web application divided into
three components: backend, frontend, and data collector.

<figure class="col s12 center">
  <img src="images/gitjira/high%20level%20design.png" />
  <figcaption>High level architecture</figcaption>
</figure>

## data model

Everything starts w/ data model. It tells what information bits will
be collected and stored, and the logical relationships among them.

<figure class="col s12 center">
    <img src="images/gitjira/jirra.png"/>
    <figcaption>Django data model</figcaption>
</figure>
  
## data collector

Can be any tool/script to pull information from interested information
source. `Gitpython` and `jira-python` are self-explanatory. The
`git-jira-analyzer` script is to use these two libraries to extract
information from Jira and a clone of a git on your local system.

The collectors are, however, only a library. The extracted data must
be persisted to the DB in the backend. However, instead of speaking to
DB directly, we are to take advantage of Django's [custom
command](https://docs.djangoproject.com/en/3.0/howto/custom-management-commands/),
so the extractor is fully in sync w/ the backend data model, and can
use Django's powerful query and ORM for data manipulation.

[source](git_jira_analyzer.py)

## backend

Backend is Django+Gunicorn. We use
[Tastypie](https://django-tastypie.readthedocs.io/en/latest/) to
provide RESTful API based on Django models. Aggregated stats can be
either processed on the client side (by frontend), or on the server
side (by backend). In this design, we opted for backend for the job.

Further, we keep the backend as a pure API provider, meaning that we
avoid building any custom URL endpoint that participates backend-front
action &larr; every single bit the frontend needs is obtainable via
exposed and documented REST API, no more and no less.

As of writing (5/22/2020), API is not enforcing user
authentication. However, backend has capability to provide [various
types of
authentication](https://django-tastypie.readthedocs.io/en/latest/authentication.html)
when the time comes.

### tastypie vs. DRF

[Django Rest Framework](https://www.django-rest-framework.org/) is a
more powerful REST API toolset than
[Tastypie](https://django-tastypie.readthedocs.io/en/latest/). By my
experience, Tastypie is easier to produce de facto API by using
`ModelResource`, which maps neatly 1:1 between Django model to an API
resource. If you need lots of special massage of data between raw
model data to its JSON version, eg. mapping date to some special
format, DRF gives you more machinery along the hydration/dehydration
path.

## frontend

Frontend is based on REACT + [materialize
CSS](https://materializecss.com/). The setup is also ready to use [React
Bootstrap](https://react-bootstrap.github.io/). For more sophisticated
UI layout and function, a Bootstrap-based approach will be better.

<figure class="col s12 center">
  <img src="images/gitjira/frontend.png"/>
  <figcaption>Frontend main page</figcaption>
</figure>

Roughly there is a 1:1 mapping between REACT component and [API
resource](http://10.240.43.48:8001/api/v1/), simply for the reason
that each resource needs rendering at some point of a UI. Thus even
for simple component such as `Branch` which is only rendering the
branch name, we created a separate component (as place holder) so the
code structure is ready to be extended.

### JWT authentication

not implemented yet

### routing

not implemented yet


# Development

Everything has been dockerized. Use it for both development &
deployment. 

**Prerequisite**: [install `docker-compose`](https://docs.docker.com/compose/install/).

- for backend: in `backend/` folder, `docker-compose up --build` if
  you are running it for the first time. You can omit the `--build`
  once the image has been built.

- for frontend: in `frontend/` folder, run `npm install && npm run
  dev`, then browser to `localhost:8080`.
  
  Alternatively, you can use `docker-compose up --build`. Here
  **`--build` is required** because the REACT source needs a
  compilation. However, you lose the `webpack hot reload` in this
  method because the compilation is happening inside the docker on a
  fresh copy of your `/src` each time its `docker-compose up`, so
  there is nothing to _reload_. This is good for deployment, but
  doesn't work well for frontend dev.
  

## manual intervention

There are always  configs needed tweaking to fit  your environment . In
particular you want to pay attention to:

1. port mapping: expose Docker port to host. For example, MySQL port
   `3306` is mapped to host `3306` by default as shown below.

    ```yaml
        ports:
          - "3306:3306"
    ```
  
2. IP mapping: in `frontend/src/root.jsx`, class function
   `constructor`:
   - `SERVER`: set to the API server IP or hostname
   - `PORT`: API server port
   
   For example, when we are setting them to `localhost` & `8002`
   because we are assuming the backend dockers are living on the same
   host (thus `localhost`) and is available on port `8002` (which is
   listened by the backend nginx).
   
3. CORS whitelisting: in `backend/gitt/settings.py`,
   `CORS_ORIGIN_WHITELIST`, adds the API server IP and port. This is
   **critical**.
   
Of course, the values in `docker-compose` can be changed such as
`enviroment` that defines DB port, user name, password, even the
application's database name, and so on. They are fairly
self-explanatory. Therefore I'm skipping them here.

# Deployment

The `docker-compose` way is production ready. 

There certainly can be different ways to deploy depending on the
underline platform this is deployed unto. For example, using `uwsgi`
instead of `gunicorn`, or tweaking the number of `gunicorn` workers,
and so on. These topics are beyond the scope of this document.
