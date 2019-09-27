Title: UML
Date: 2018-07-24 12:03
Tags: dev
Slug: uml
Author: Feng Xia



Finally [a book on UML][1] that makes sense to me (and is short enough
so I was willing to read it, in one morning). 

# Milestone 1: requirement review

Everything starts with an analysis of the problem at hand. One thing
learned and I'd like to clarify is `requirement` &mdash;
it is a set of **constraints** (thus the word `must`,
`should`). Requirements often cause confusion as they are taken as the
system's objectives &rarr; in essence they are, but they are measured
as a set of **conditions** that the system will have to **behave
within boundary**. Thus, viewing them as the **law for your
design**, it's a valid test to your test, but your design
can come in many forms, and that's where engineering has some fun.

So it becomes clear & natural that design and implementation are like
people living in society &rarr; his behavior is completly boxed by law
he has to obey, that's the minimal.  Anything that no law permits nor
prohibits (functions that links to no requirements), well, is just to
keep the developers happy.

<figure class="col s12 center">
  <img src="images/practical%20uml%20problem%20domain.png"
       class="responsive-image">
  <figcaption>Problem domain</figcaption>
</figure>


## problems

Any description of what the client is trying to do or what they
want. There is no restriction at all. What comes out of it are:

1. requirement
2. domain modeling

## requirement

1. Uses **shall**, **must**.
2. Have a N-N mapping to use case &rarr; traceability from requirement
   &rarr; design &rarr; code &rarr; test.
3. Many ways to cut it: functional requirement, data requirement,
   performance requirement, and so on.
   
   
> - A use case describes a unit of behavior.
> - Requirements describe the laws that govern that behavior.
> - Functions are the individual actions that occur within that behavior.
>

## domain modeling

Quite similar to ERD from Django graph. The difference is that it
doesn't yet care attributes or methods, and they are not necessarily
translated 1-1 into a DB table.

1. Pick out the `nouns` &rarr; domain models
2. Formulating 3 relationships:

    1. generalization: parent &rarr; children class
    2. aggregation: roll up, eg. `DailyRecord` &rarr; `MonthlyRecord`
    3. association: the closest understanding I can get is to describe
       the many-to-many relationships.
 
## use case

This is the soul of UML (or at least for this book) since everything
derives from it.

1. Inputs: domain models & requirements.
1. Two types: 
    1. basic course of action
    2. alternative course of action &rarr; thus we can cover any
       exceptions we need to handle.
2. Go expansive on case statement. We want to derive two things out of
   it:
    1. actor
    2. domain objects
3. What helps &larr; visual and mockup user experience:
    1. GUI prototyping
    2. write a user manual in use case statement, or reverse
       engineering case statements from a legacy user manual
    3. wire frame, or any kind of GUI mockup
4. Ask:
    1. what happens &rarr; then &rarr; then.... use the word `invokes`
       and `precedes`.
    2. what else can happen? &rarr; alternative course
5. Being thorough is key

Once you have done so called analysis, you reach the first milestone
&mdash; requirement review. That's when client should sign off to
recognize these set of `use case` do represent what they want to do.


# Milestone 2: design review

With a set of use cases, we can break them down into design
elements. This book talks in context of OOD, thus words like `model`
and `object` are essentially a **CLASS** in code. We don't have to be
bound by this. Instead, taking `model` as an abstract &mdash; it can
be a database table, or a service &mdash; it's just a representation
of a logical element that describes our view of breaking down the
initial problem into a set of items who interacts with each other. 

<figure class="col s12">
  <img src="images/practical%20uml%20solution%20domain.png"
       class="responsive-image">
  <figcaption>How problem domain works w/ solution domain</figcaption>
</figure>


## robustness diagrams

<figure class="col l3 m4 s6 right">
<img src="https://docs.oracle.com/cd/E13214_01/wli/docs92/bestpract/wwimages/robustnessanalysisrules.gif"
       class="center responsive-image">
</figure>

Robustness diagram is optional. It is the transition
from problem domain &rarr; solution domain because it starts to speak
using design language, not natural English (as in use case) anymore.

Robustness diagram is essentially a MVC framework. This is optional in
the sense that this is a transition between problem domain to solution
domain.

1. Three types of objects:
    1. boundary obj &larr; interface, UI falls in this category &rarr;
       the `V`
    2. entity obj &rarr; can result in more domain models &rarr; the `M`
    3. control obj &rarr; will be translated to helper models, methods
       &rarr; the `C`
2. One diagram per use case
3. The good thing about robustness diagram is, there is strict rule of
   what is allowed:
    1. Actor can talk only to boundary objects.
    2. Boundary objects can talk only to controllers and actors.
    3. Entity objects can also talk only to controllers.
    4. Controllers can talk to both boundary objects and controllers,
       but not to actors.

## sequence diagram

This is where the solution domain starts. Sequence diagram represents
detailed design.

1. Per use case &larr; both basic course and alternative course, try
   to fit them to the same diagram.
2. On the side of sequence, note which use case it is for &rarr;
   traceability.
3. We will end up with a list of `classes` and `methods`.
    1. allocation methods to class &larr; design pattern, eg. class
       factory vs. iterator

## state diagram

1. Per class from sequence diagram, but cherry pick the important ones
   &larr; if it has only two states (on/off), don't bother.
2. Three types of events:
    1. entry: do this when you **enter this state**
    2. exit: do this when you **leave this state**
    3. do: do this when you are **at this state**
    4. "guard": condition (True/False)

# Milestones 3 & 4: development and UAT

UML doesn't address development. For completeness I'm adding two more
milestones here:

1. dev: topics such as test case fall into this place.
2. release: the only thing matters is the **UAT**, which should come
   straightly from use cases. 
   
 Here I also want to highlight the **separation between development tool
 from test tool** &rarr; programming your solution in Python does not
 dictate you to test in Python. If you look at the two type of
 test cases, I think unit test (whitebox) is tightly determined by
 implementation details &rarr; how thorough I traverse code paths
 (those `if-else`). It's often a matter of convenience to write them
 in the same language because the language itself offers a toolset for
 the purse, for example, Python's unit test framework.
 
 But `blackbox` cases have not such restriction &mdash; performance
 test can well be done using a tool that has no relevance with Python
 whatsoever because it only concerns `use case` which represents
 `requirements`! Therefore, these tests are what UAT is about. The
 whitebox tests, on the other hand, are for management purpose so you
 can have control of quality.
 
 Now, this separation of purse is not to support that quality is just
 for the internal use as long as UAT passes. In practice, use cases (=
 requirements) are simply not possible to address all qualities. Again
 going back the analogy of requirement being the law you obey in daily
 life, law often tells you what not to do, but does not tell you what
 you should do &larr; you can always live a despicable life but being
 a lawful citizen at the same time.

<figure class="col s12">
  <img src="images/practical%20uml.png"
       class="responsive-image">
  <figcaption>A complete view of the framework</figcaption>
</figure>


# Exercise

> We have a cowboy named Bill Bob, who is driving down the road at 80
> miles an hour while drinking beer, scratching, and tossing the empty
> beer cans out the window of his pickup truck.
> 

1. domain models & relationships
1. basic course use case diagram
2. requirements




[1]: https://www.amazon.com/Driven-Object-Modeling-UMLTheory-Practice/dp/1590597745
