Title: General system architecture
Date: 2016-09-08 21:15
Tags: dev, architecture
Slug: general system architecture
Author: Feng Xia


<figure class="col l8 m8 s12">
  <img src="/images/architecture_joke.jpg"
       class="center-block img-responsive">
</figure>

The word "system architect" has been puzzling to me.  I was hired to
be one at one point. But it was not a comfortable position. How much
do we understand the business?  What is the problem we are to solve?
How does the current "architecture" fail? What is the downfall of this
(or any) proposal? Overall, I feel an architecture emerges along with
development and research. The more we start to understand the client's
needs, habits, workflows, relationships, priorities, the more
information we have when evaluating and making decisions on whether
one piece in the stack fits or not, and why so. It is, IMHO, a
backwards process when an architecture is pre-defined as if it is set
in stone. We need to start from somewhere, but keeping in mind that it
evolves and shifts like a living organ.

> System architecture evolves and shifts like a living organ.

This is a system architecture I have been using recently in
projects. It is divided into four components:

1. <span class="myhighlight">foreground service provider</span>: this
  includes machinery that interface with web server, taking HTTP and
  AJAX requests, and generate response to request.  The core of this
  component is Python [Django][]. Django is chosen for its reputation,
  for my past experience, for its maturity, excellent documentations
  and a broad user base. Backed by Python, it is a great _starting
  point_ for building a web application.

2. <span class="myhighlight">background service provider</span>: it
  handles all code executions that do **not** need be in synchronous
  fashion with a user request.  The key here is task queue integrated
  using [Celery] with [Redis][] or [RabbitMQ][]. These replaced what
  used to be messy multithreading code that were prone to error and
  hard to debug. Besides, architecture wise these message queues
  extend well, so it's a natural fit for cloud deployment.


3. <span class="myhighlight">data storage service</span>: traditional
  RDBMS and file system. A consideration here is certainly to include
  remote storage such as AWS. The key point is to separate static data
  (style sheets, JS scripts, media files) from dynamic application
  data. A side note. I think the distinction is rather misleading
  since most application data become stale(static) also once
  generated, and many image data nowadays are saved in DB (so system
  backup takes one step instead of two).  Both have its use.

4. <span class="myhighlight">integration service</span>: customized
  code to implement third party system integration. In general, CRUD
  operations are handled through frontend API(REST) service. There is
  also so called *backdoor tasks* that covers cases where data may get
  pumped directly into data storage via ORM layers. Such cases may
  include initial data import, runtime data synchronization, data
  extraction and system backup.


<figure class="row">
  <img src="/images/system_architecture.png"
       class="center-block img-responsive"/>
    <figcaption>System architecture diagram</figcaption>
</figure>

The beauty of this architecture is that message queue becomes a
distribution hub where tasks are dispatched to different destination
end point for processing. This greatly reduces the complexity of
inter- and intra- system communication. Knowing that queue servers can
be easily extended if load become heavy is yet another benefit to have
in term of scalability.

As shown in the diagram, background queue tasks are being used solely
to generate and consume *model data* (including media data since media
has always some meta data components).  This means they do **not**
participate to generate inline view response; instead, they take
instruction from user input and distribute those intensive code for
asynchronous processing.  This remedies Django's synchronous nature (I
say it is synchronous in the sense of that a Django's native process
will receive and process view request without interrupt or callback.
Django [signals][django signals] are asynchronous, however.) where a
long running code section could bring the entire application to halt.

[django]: https://www.djangoproject.com/
[redis]: http://redis.io/
[rabbitmq]: https://www.rabbitmq.com/
[celery]: http://www.celeryproject.org/
[django signals]: https://docs.djangoproject.com/en/1.10/topics/signals/
