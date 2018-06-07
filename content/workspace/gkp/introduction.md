Title: GKP &mdash; introduction
Date: 2015-09-04 10:00
Tags: gkp
Slug: gkp introduction
Author: Feng Xia


GKP project was conceived from a meeting with a friend of mine,
Mr.Zhang, back in Jan, 2015.  Mr.Zhang has been in China's college
education business for 15 year. He has succeeded in building a couple
online training services and is also the head of a private
college. The GKP project is to consolidate multiple data sources into
one place so to facilitate high school graduates and their parents
searching and evaluating college and university.

In this article I'll give a brief introduction of core functions and
thoughts behind each design. It also illustrates how we have
approached each problem with the solution you are currently seeing.

# User preference

An important tool is the `user preference`. Each user can specify her own
searching criteria so to narrow down from a general search to a more
customized version.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_2.png" />
    <figcaption>Set up user preferences</figcaption>
</figure>

These settings are related directly to how Chinese college categorize
students. Take the **Geo requirement** setting for example.  Let's say
that MIT takes 3,000 freshmen each year. Instead of accepting
application nation wide, MIT assigns a fixed quota to each state. Some
states get more quota comparing to their share of the student
population, while others get less. A student from a low
quota-to-student ratio state will then have a reduced chance of
getting into MIT even though she meets the school's qualification.

To enforce this arrangement, it is a hard requirement that student can
only attend national entrance exam in the state that her **birth place
is registered (户口)** (This is a simplified version, but is generally
true). Therefore, regardless where she lives now, she is locked in to
the quota assigned to her *home* state. This is a sad reality.


# Nation level: a school map

The drive behind this function is that students often have a geo
preference in mind.  This function is to make it easy when she wants
to browse schools based on its geo location.

Initially I was to build a Google map view with overlayed filter.  Geo
code was looked up first using Google map API. This alone took about a
week to resolve limited by the upper limit Google imposed on each API
account and the initial trial and error time. Drawing the map was
straightforward using [Google map API] and [marker cluster][].

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_21.png"/>
    <figcaption>Using Google map to browse schools</figcaption>
</figure>

However, a couple issues with this approach:

1. Computing markers within the view bound was time consuming. This is
especially so when user has few filtering criteria.  This will result
in displaying all schools on the map. Zooming in will reduce the
number of markers. So a potential solution is to set the initial zoom
large enough to view only a section of the country's territory.

2. Some addresses were not resolved or resolved incorrectly. They were
viewable on Google map itself, but the returned geo code was
different. It feels like Google uses a better version for his own use
and serves the rest of us with a lower quality data set. A way to
resolve this is to check the address with other geo decoding
services. So I tried Baidu map API. That's when all hell broke loose.

First of all, two systems yielded two different geo codes for the same
school address!  How could this be? Are they having two different GPS
systems? My guess is that their data providers are different. But
whose data is correct?

Further, displayed location on the map are different, sometimes not
even close. Then I tried swapping geo code for the purpose of
experiment &mdash; using Google's geo code to plot on Baidu map. The
result was even stranger. This made me to think that either Google or
Baidu has massaged their data on purpose in order to create this
incompatibility.

Considering the GFW, I abandoned both maps and back to a simple
Chart. Map is drawn using [Echarts][].

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_1.png"/>
    <figcaption>School map using Echarts</figcaption>
</figure>

Legend on the bottom left corner shows school counts categorized into
different shades of color. The darker an area is, the more schools
there are.  Schools in each state are further grouped by its city
(shown on the right) and can be drilled down.


[google map api]: https://developers.google.com/maps/documentation/javascript/tutorial
[marker cluster]: https://github.com/googlemaps/js-marker-clusterer
[echarts]: https://ecomfe.github.io/echarts/index-en.html

# State level: statistics

Next layer below a national view of all schools on a country map is at
state level.  Most people have a general idea of state, such as its
climate, culture, food, and so forth. So here instead of these
information, we focused on aggregated data analysis. In short, schools
within the same state boundary will be grouped along different
dimensions. Statistics are then computed on the fly to provide quick
facts.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_3.png"/>
    <figcaption>School statistics quickview at State level</figcaption>
</figure>

Each dimension can be drilled down to reveal more stats. Among them,
two important dimensions are important for a student
&mdash; Bachelor's vs. Associate program, and tiers.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_4.png"/>
    <figcaption>School statistics drill down by programs and admission tiers</figcaption>
</figure>

The distinction in the degrees are simple to understand. Some schools
and programs offer certificate program while others are accredited by
the government to issue degrees.

A unique concept here is the *admission tier*.  In China, all college
admissions fall into one of the four tiers listed in descending time
order &mdash; _pre tier, 1st tier, 2nd tier and 3rd tier_.  Tiers work
in a waterfall mode. School start with top tier in an admission cycle
and moves down the tiers until all spots are filled. Therefore the
lower the tier is, the less likely a top school will come by. On the
other hand, lower tier has a lower score requirement.  Pre tier is for
school with specialized program, eg. military schools. Often, it is
also the time when elite students get picked by school. For all
others, they have to make a decision prior to the exam day which tier
she is going into, and the primary reference is her estimated score.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_5.png"/>
    <figcaption>School statistics drill down by school types</figcaption>
</figure>

Another dimension is the type of school. Students who want to study
arts can quickly find schools specializing in that.

# City level

What would student want to know about a city? First of all, some
general data imported from wikipedia. Since wikipedia does not have an
API for keyword search, the challenge was to have the computer
matching city name to a wiki page and parse the page for imported data
bits.

<figure class="row">
  <div class="col s6">
    <img class="img-responsive center" src="/images/gkp_6.png"/>
  </div>
  <div class="col s6">
    <img class="img-responsive center" src="/images/gkp_7.png"/>
  </div>
  <figcaption>City wiki</figcaption>
</figure>

Next, an interesting idea came up during our discussion. _How
convenient is it to get to the city from where I live?_ So we decided
to build a train schedule that will show exactly which train are
available to take, all stops in between, and the actual time elapse.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_8.png"/>
    <figcaption>City to city train schedule search engine</figcaption>
</figure>

Considering that no map API or travel search engine can mix up flight
with train to generate a complete door-to-door route, this function
has a great potential to be extended into a service of its own where
flight, train, bus and subway data are matched up.

# School level

Everything comes down to school level where school specific details
are laid out to assist prospective students evaluate not only
the future academic life but also its social life. Read on
our [part two &mdash; school details]({filename}/workspace/gkp/schools.md).
