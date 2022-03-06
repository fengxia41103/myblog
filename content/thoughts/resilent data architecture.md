Title: Resilient Data architecture
Date: 2022-03-01 17:00
Tags: thoughts
Slug: resilient data architecture
Author: Feng Xia

This is a broad topic because it depends on the exact focus you want
to put on these three words. I'm gonna address them one by one but
going out of order of these three according to a rank of importance
they bring to the table based on my view.

1. `Data` first because it's the information source and core
   value. Without it discussion of architecture is pointless.

2. `Architecture` second because it describes the mechanics, the
   in-and-out of the data flow and the data processing, which means to
   do the discovery/magic to these data and create value for the
   customer.

3. `Resilience` last because this is a gray area that is highly
   dependent on the nature of data themselves and use case.

# data

The No. 1 challenge of data enterprise faces is not the lack of data,
but also the lack of data. In today's world we have too much
data. However, in face of the richness of these data we still feel
_poor_ because we **lack quality data**, and the quality can be viewed
along these three dimensions &mdash; normalization of acquisition,
normalization of the data type/format, and normalization of meaning.

## normalization of data acquisition

Data are everywhere, and being served by all sorts of APIs and
endpoints. But, each endpoint is different in term of handshake
protocol, authentication & authorization, query syntax,
transportation. RESTful is the go-to _choice_ these days, GraphQL is
on the rise. Yet, even with these terms as the overall guide,
implementation details of such interface can dramatically skew its
function, and even the look of these APIs, for example, some APIs are
governed by data models and conform with protocol standard while some
are home-grown URL that _mimic_ the behavior but without
guarantees. APIs today are like computer data bus protocols yesterday
&mdash; luckily for the latter, motherboard manufacturer always have
the say of which protocol it supports, thus all vendors of hardware
that wish to communicate with the computer are driven to converge. But
the Internet has no such power. APIs are developed independently, and
have nearly zero governance of what it should or should not
do. Therefore, integration with a data API is a rather unbalanced
relationship between the data provider and the data consumer.

The fragility of data acquisition is the first obstacle.

## normalization of data type/format

We live in a world of non-structured data while our vision of data processing
prefers, if not requires, structured data. Data anomaly, outliers, are
the most expansive part of data processing because they are not
included in the design blueprint, thus having a high chance becoming
software bug. Regardless how smart the processing tool is, there will
always be a step in which all data in the pipe start to look
structured and alike. Taking image processing, for example. Regardless
how much two images differ, analysis is relying on a pixel matrix to
feed the data processor, and each pixel is a RGB number &mdash;
a `white` pixel will have a value of `000`, but its place in the
matrix is never missing.

This effort of bringing non-aligned data types, fields, formats
**in-line** so that they appear to be **uniform** is an overhead to
data processor and can be costly. Some may argue that technology such
as NoSQL makes this unnecessary. But that is not true. The root of
such overhead is that the programmer must have a **finite number of**
possibilities that the input can be so that s/he can write sensible
implementation. Asking to handle _any_ input is out of the
question. Even in NoSQL, returned query will fill missing values with
default or null, but records from the same table share the same data
structure.

This overhead of conditioning data in to structure is the second
obstacle.

## normalization of meaning

Data itself is dummy unless you know how to read it. It's a myth
people think data equals information, or data equals to fact. Neither
is true. Data is a collection of bits that represent a **meaning**
within a **context**. I find it laughable people think AI is the
magician who is going to tell me something of my data which I do not
yet know &larr; assuming AI can do that, how would you know when it
tells something _new_? This is the same philosophical question that we
seek truth, but even when truth stands right in front our face, can we
recognize it?

Data processing requires deep insight of the domain from which these
data come from. Normalization of data type and format would help to
clarify definition of the data fields, but it does not yet give the
meaning to its interpretation. In a given industry, the meaning of a
term is fairly clear and mutually understood by participants. At the
same time they form a barriers to _outsiders_ of that
industry. Therefore, making cross-domain data analysis requires broad
knowledge as if we are teaching the computer to speak different
languages so it speak them **all at once**.

This acquisition of domain knowledge is the third obstacle.

# Architecture

Here we limit the discussion to the implementation side of an
architecture. The challenge, IMHO, is the sheer number of technologies
a team/project must be able to assemble together in order to form a
product, which in turn are the hoops one must jump through in order to
troubleshoot a problem. From bottom up, you need to know scripting or
DSL to manage infrastructure resource, SQL or some flavor of it to
manage DB, web framework in a programming language to write
application, a list of third-party libraries to support the function,
another set of tools, and certainly different programming languages
(you can run Javascript for server, but you still have to write CSS
just for the UI), for the UI/frontend, another set to write tests, yet
another set of tools to scan code for venerability, security auditing,
another for packaging and deployment, another for documentation, and
one more for monitoring a running instance.

We do these today, amazingly, end-to-end. Otherwise the product
doesn't function. Yet each part requires learning curve, finding
talent, building experience, and tolerating faults. Literally all
parts of the castle is moving and our job is to keep the castle
stand. Enterprise is assumed to have resources to foot the bill. But
the reality is that the complexity of today's web application,
especially if your team is to build and handle the full stack, is
overwhelming. How to formulate a view that dissects such complexity
into smaller scope so that the problem of each scope is defined well
is the role of architecture.

We can find plenty frameworks, design patterns, best practices, tools,
blogs, products, turn-key solutions. The challenge, like a spoiled
consumer who has limited fund, is to choose which one. All aside,
architecture will be subjective. There is not a one-for-all size, but
we also know it must be done.

Thus, fusing all these different technologies into one **coherent*
view as a solution and be executable by the available resource is the
fourth obstacle.

# resilience

Resilience requires a yard stick. An example is the Service Level
Agreement (SLA). In the discussion above we have stated the complexity
of a system. Thus where the single point of failure or the weakest
link is becomes difficult to identify. Experience plays a critical
role in this space.

One particular challenge that is often underestimated is how to design
and implement **fire drill** &mdash; simulation of disaster or event
the system is expected to resist. Common scenarios such as server
crash, disk corruption, component patching and upgrade, failover,
isolation of networking... these risks are real but difficult to
account for. Not to mention error handling in code are growing which
eats up human resource and focus.

Then there is regulation on the data apart of inherent data
integrity. Certain industry and certain type of data may face strict
policy with which resilience is measured not only by the recovery
time, but by accessibility, retention period, encryption, and more.

In the end, resilience can only be defined by knowing the product well,
knowing the customer well, knowing the use case well, and knowing the
data well. So if to put all these into one obstacle, I would say it's
the balance between commonality of the functions the product offers to
all data and the uniqueness of function applicable only to some.

# enterprise

Putting all these into an enterprise environment, there will be other
variables such as networking constraint, on-prem vs. off-prem
vs. hybrid, co-location, AD/LDAP integration. Architecture thus
requires not only satisfaction of the core function, but potential to
be extended and customized. I worked in one company where there was a
whole team of "custom engineering" who retrofit the standard product
case-by-case for customer, then I had another company whose motto was
have "one product for all customer" who only adopted feature if it was
to benefit all its customers. The obstacle in this sense can be to say
"no" to a customer, or to bear a cost.

So in sum, designing and building a resilient data architecture is the
ultimate goal, but there isn't a finish line. Enterprise and startups
face the same set of obstacles. Because of difference in resource they
will have different strength and weakness in the process of
approaching them. With large scale adoption of opensource, their
toolbox are rapidly converging to the same set of tools. What will
make difference, I think, will be more and more by the human
resource.
