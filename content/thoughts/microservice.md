Title: My view on microservice arch
Date: 2020-08-24 09:48
Tags: thoughts
Slug: my view on microservice arch
Author: Feng Xia

<figure class="col s12">
  <img src="images/DSC_1100384.JPG"/>
</figure>

This is an email w/ teammates regarding my thinkings on microservice
arch and a few other things happening in the project which I
dislike. 

Read at your convenience ~~

# SOA is hard, and I haven't seen it working

I first learned [SOA][1] (and an IBM [book][2], very comprehensive) in
2013. I was in charge of designing the architecture of a 3-million $$
project for a Fortune 500 company. Yes it was SOA-ed, but not, no one
can implement it.

I have been in this trade long enough to see these patterns come and go,
every so many years they come back in a new emperor's
dress. Microservice arch seems to be the same thing. It's popular in all
meetings and talks. We assume ourselves ignorant if we can't name a
single project personally that has successfully pulled it off. But the
reality, I'm afraid, is that except a few deep pocket giants, no one has
done it according to book, and it never will.

SOA requires a ESB (enterprise service bus) for messaging (data), and
[BPM][4] engine for workflow orchestration. Both concepts are sound. I
love them. But they are very difficult to implement. The bottleneck is
not technology, but to abstract biz workflow so much so it can be
delegated to BPM engine, and maintenance (BPMN is too hard for client to
learn) because biz logic is constantly changing.


# Talk is cheap (rant)

It's a cheap word to make one look good and sophisticated. But here is
my view &mdash; if you propose it, you do it. I'm frustrated that
_architects_ roll of their tongue these buzz words as if they are ready
to grab, but they never code any of them, and they usually end the
sentence "Any question? If no, you do it".

There is another popular version of the same superficial talk in China,
[so-and-so technology is mature and simple][7] used to justify the proposal
is low risk.. just because you can say the word, doesn't make it
simple. There are different level of credits to this statement (best ->
worst, in order):

1. Yourself has coded it, even as small part of a large proj/module.
2. You have a die-hard buddy John, and he has done it and showed to you
   before.
3. Your friend John has a friend Alex who claims he is coding it.
4. You and John and Alex all read about it on a SO post, or a book, or a
   meetup, and know it's a trendy thing to do right now.
5. You all know that Google is using this technology and it's
   awesome (but, are you Google?)

You get the spirit. I had same conversation w/ my client in 2013. It's a
common mistake non-engineer make. Just because Google can do it, doesn't
mean I can, or this team can. There are plenty such example in
life. Pick up any Physics book, the theory of atomic bomb is
printed. Can you then build one? Yeah we all know US has built a bunch
for a while, does it make it easy if you, or your country, to build one?

Talkers don't care details; but they dont sweat making the claim
that "it is simple", either.

# container, microservice

Microservice architecture is good, but too good to be true. Forget about
benefits. Let's talk problems we can perceive.

1. It's not justified _monotholic_ design is natively bad. One common
   sales pitch is "your company's systems are all silos, and mine is a
   one-stop-shop".

    If each micro-service is a full stand-alone thing, aren't we then
    creating a bunch of _silos_?

2. Modular.

    Code naturally become modular because repetitive pattern emerge
    during coding, and I hate to copy&paste. So up to 10th time, I start
    think to make it a _module_ (whatever the name is) so I write one
    line to call it. I'm sure you echo this.

    I worked w/ an IT woman in 2010. At a lunch break, we were talking
    how tolerant you are before you want to _automate_ sth. I considered
    myself pretty hardcore to eliminate repetitive works using
    scripts. Her answer was, "1". It's an exaggeration I thought. But the
    mentality is sound -- constantly think how to combine things into a
    logical group, thus "module", so to save yourself the trouble.

3. Top down design.

    Top down to do modular in design is great, if the person has deep
    knowledge of the domain, and is responsible. His/her view essentially
    makes decisions that function XYZ should be a service/module on its
    own, or not. It's a very difficult decision. Whoever says it's easy
    is a liar.

    My first job was in a semiconductor company making lithography
    machine. The entire project (300+ people) was directly by this one
    guy. He was an engineer, 60s maybe, gave us a talk every week, and he
    knew everything of that product -- mechanical, real-time control (my
    job), everything. I haven't ever met such situation after. Guru is
    wonderful, if they are real. In 99.999% cases, it's _con artist_ w/
    impressive title.

4. Container.

    Container is a packaging choice. It can't package anything. Some code
    can and benefit from it; some don't. The one single blocker I would
    consider is that it is a single process -- if your thing can live w/
    it, good. Otherwise, you need other trick to scale horizontally,
    which adds complexity in knowledge and maintenance. Therefore,
    speaking "containerizing" sth as if it were a given is ignorant (the
    atomic bomb example above).

    My view is that a container is yesterday's CD/ISO. Fit your music on
    a CD doesn't make your music suddenly good, if it were bad.

    By choosing docker and k8s, it comes an _ecosystem_ that makes things
    _easier_. But. It shouldn't replace the knowledge if you were to do
    it without them -- if you can't maintain an accounting book using
    paper and ink (let's say all the Excels are dead today), are you
    still an accountant? These ecosystems, like python native and 3rd
    party libraries, require you to learn, to try, and some work out of
    box, others don't as claimed. So, it's same engineering practice, not
    magic.

I know LXCO architecture is microservice _oriented_, at least some
components, such as an aggregator (API proxy), access gateway. It's a
living example to examine. I don't know the status of it, nor how
good/bad it is. Find it out yourself if you are interested in. Talk to
engineers who code it, not manager's PPT.

# in CP?

We can't, and we shouldn't.

Service MUST maintains its own state. Each will have at least an admin
interface (aka. UI), and an API.

Therefore, there can't be one UI team coding all these UIs. Each service
has a UI person to code and maintain and add feature and debug. Same for
UX.

This leads to more considerations -- how to reuse components, or not?
and common technology stack, or not?...

CP is sort of service-oriented. What can be done is to break up
components into its own repo, its own build pipeline, its own release
schedule, and of course, finish each w/ an admin interface and API if
missing.

Now, the million $$ problem, is the STATEs. The complexity has been
hidden by Postgres & Scylla, because [DB's model and constraints][5]
**guarantee** a logical relationship between two data points. But in a
group of isolated services, it's fishy. I don't have knowledge to
suggest further reading or thinking. At least, read [this][6].

Remember. Technology might be _mature_, but until we built one crude
versioin, that wonderful theory is, theory. 

[1]: https://en.wikipedia.org/wiki/Service-oriented_architecture
[2]: https://www.redbooks.ibm.com/redbooks/pdfs/sg246303.pdf
[3]: https://en.wikipedia.org/wiki/Enterprise_service_bus
[4]: https://en.wikipedia.org/wiki/Business_Process_Model_and_Notation
[5]: https://www.codeproject.com/Articles/359654/11-important-database-designing-rules-which-I-fo-2
[6]: https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing
[7]: {filename}/thoughts/tech%20maturity.md
