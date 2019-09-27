Title: Project GKP Demo
Date: 2015-03-06 9:00
Slug: project gkp demo
Author: Feng Xia


<figure class="s12 center">
    <img src="images/demo_gkp.png"/>
    <figcaption>Project GKP frontpage</figcaption>
</figure>

> * [Demo (in Chinese)][2]
> * Login: (demo, demopassword)


Project GKP is an interesting one.  It is a web tool that helps high
school graduates in China to find a right college.  The grand vision
is to make it a one-stop shop to get information that are mostly
relevant at each step of research.

When we first conceived this idea, the leader in this field was a
Chinese startup company, [高考派][3](aka. GKP). It was rumored that
the company was facing a pending acquisition with a enticing price
tag. After diving into their site for a few weeks, we came to realize
that beneath the skin of their application, its baseline data was
seriously broken. For example, GKP's core feature was its historical
exam data. However, we found a dozen similar sources all claimed to
have the same data set. But surprisingly there have been hard reached
to find agreement between any of the two data sets! This cast a
serious doubt on the validity of these services. Further analysis of
them made it clear that even though China's college admission is
centralized around test scores, selecting the _right_ school is
not. There are rich set of peripheral information that students and
their families would like to consider besides a test score. But none
of them offered much help.

Therefore, we have shifted our strategy and embarked on a different
journey. Score is becoming one facet of a multi-dimension information
repository.  We focused on identifying channels and means students are
using to acquire information, and the types of information that they
would want to have access to at different context of research &mdash;
what is important to know about the city? the school itself? the
people in school?  how easy to get there and come home?... Utilizing
advanced techniques we have built data pipeline that finds the answer
for you.


Read on about its functions and design considerations and try your
hand with demo.

1. [state, city and a school map][1]
2. [everything about a school][4]
3. [majors][5]

[1]: {filename}/workspace/gkp/introduction.md
[2]: http://fengxia.co:8001/gaokao/
[3]: http://www.gaokaopi.com/
[4]: {filename}/workspace/gkp/schools.md
[5]: {filename}/workspace/gkp/majors.md
