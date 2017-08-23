Title: Deployment architecture
Date: 2016-09-09 23:05
Tags: dev, architecture
Slug: deployment architecture
Author: Feng Xia
Modified: 2017-08-22 21-52

Deployment strategy for [system architecture][] is centered around AWS
services: EC2 for application server, RDS for database, and S3 for
static files and media files.  AWS does have message service as
well. But to maintain a fair level of portability, I am not using
that. Instead, vanilla message broker such as Redis or RabbitMQ is
used and is deployed on a separate EC2 instance.  In general I tend to
have concerns over investing a critical system component to a 3rd
party service because they usually will introduce some customization
quirks that make it a real pain when migrating to another service
provider or platform later on. I have not run into such problem with
AWS, but would like to keep options open.


<figure class="col l12 m12 s12">
  <img src="/images/deployment_architecture.png"
  <figcaption>Deployment architecture</figcaption>
</figure>

Notice that I do not have multiple database in the diagram. First of
all, I have not had use of DB cluster. Secondly, database replica is
covered by AWS snapshot which has been a great fail-safe tool for
system backup and recovery.  This brings up an important point I'd
like to advocate:

<blockquote>
    AWS services are in general far better
    than a setup that a developer can pull off.
</blockquote>

So unless one has a strong case, don't reinvent the wheels.
Use AWS to save myself from building these essential infrastructure
so that I could focus on writing application code to solve
client's real problems. Service such as [Heroku][] and [GAE][]
are even more hands-off if the application architecture
can fit into their platform.



[system architecture]: {filename}/dev/architecture.md
[Heroku]: https://www.heroku.com/
[GAE]: https://cloud.google.com/appengine/
