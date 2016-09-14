Title: Deployment architecture
Date: 2016-09-09 23:05
Tags: dev, architecture
Slug: deployment architecture
Author: Feng Xia
Status: draft

Deployment strategy for [system architecture][]
is centered around AWS services: EC2 for
application server, RDS for database, and S3 for static files and media files.
AWS does have message service as well. But to maintain a fair level
of portability, we are not using that. Instead, vanilla message broker such as
Redis or RabbitMQ is used and is deployed on a separate EC2 instance.
In general I tend to have concerns over investing a critical
system component to a 3rd party service because they usually will introduce
some customization quirks that make it a real pain
migrating to another service provider or platform later on. I don't have
a case in point to prove this fear. It's just a hunch.


<a href="images/deployment_architecture.png" data-lightbox="deploy">
    <img src="images/deployment_architecture.png" class="center-block"/>
</a>

Notice that I do not have multiple database in the diagram. First of all,
I have not had use of DB cluster. Secondly, database replica
is covered by AWS snapshot which has been a great fail-safe tool
for system backup and recovery.
This brings up an important point I'd like to advocate:

<blockquote>
    Using AWS services are in general far better
    than a setup that a developer can pull off.
</blockquote>

So unless one has a strong case against it, don't reinvent the wheel.
Use them to save your time from building these essential infrastructure
over and over again. Now focus on the application itself because it
is the real value-added piece of this entire architecture.


[system architecture]: {filename}/dev/architecture.md
