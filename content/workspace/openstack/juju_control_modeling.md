Title: Canonical Juju modeling
Date: 2017-1-03 10:45
Tags: openstack
Slug: juju
Author: Feng Xia

This article is a high level view of Juju's internal modelings. For me it was fairly confusing when looking at its document
which has an army of these concepts: charm, bundle, model, unit.... of course, each of them makes sense after a while. Its [terminology][1] page helps on understanding individual term. But like other Canonical documents, it needs a design level diagram
to help user grasp the structure of this wealth of knowledge.

[1]: https://jujucharms.com/docs/2.0/glossary

So here it is my attemp to show the relationship between these terms. Instead of drawing a tree to reflect 1-N relationship, I used
an outer enclosure which can have multiple of its inner enclosures, eg. a bundle can have N charms.

<figure>
<img src="/images/juju_control_modeling.png" class="center-block img-responsive" />
<figcaption>Juju control models</figcaption>
</figure>

A few interesting points besides the 1-N relationships. 

* A single application can be deployed on multiple machines, eg. Application #2 has two units. This is how
one application can be scaled out horizontally. 
* One machine, in turn, can host multiple applications, eg. one unit
of application #2 and #3 both live on the same machine. 

By default, _juju deploy_ will call for a new machine for each application
within the bundle/charm. Of course, there is command flag to switch that so you can specify which machine is to be used.
