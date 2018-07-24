Title: UML
Date: 2018-07-24 12:03
Tags: dev
Slug: uml
Author: Feng Xia

Finally [a book on UML][1] that makes sense to me (and is short enough
so I was willing to read it, in one morning). All contents can be
divided into two milestones:

# ML1: requirement review

## problems

Any description of the what the client is trying to do or what they
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

# ML2: design review

## robustness diagrams

<figure class="col l3 m4 s6 right">
<img src="https://docs.oracle.com/cd/E13214_01/wli/docs92/bestpract/wwimages/robustnessanalysisrules.gif"
       class="center responsive-image">
</figure>

Essentially a MVC framework. This is optional in the sense that this
is a transition between problem domain to solution domain.

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

# Exercise

> We have a cowboy named Bill Bob, who is driving down the road at 80
> miles an hour while drinking beer, scratching, and tossing the empty
> beer cans out the window of his pickup truck.
> 

1. domain models & relationships
1. basic course use case diagram
2. requirements


[1]: https://www.amazon.com/Driven-Object-Modeling-UMLTheory-Practice/dp/1590597745
