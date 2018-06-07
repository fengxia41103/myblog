Title: GKP &mdash; major details
Date: 2015-09-012 19:00
Tags: gkp
Slug: gkp majors
Author: Feng Xia


In [part one]({filename}/workspace/gkp/introduction.md) and
[part two]({filename}/workspace/gkp/schools.md), I have introduced
functions to assist students get to know about the schools
from multiple aspects. In this article, we will touch upon
another important factor when going to college &mdash; major.

In China, majors are split into three layers: category, subcategory,
and majors. Similar to the _state-city-school_ configuration,
functions at category and subcategory level focus on statistic
analysis so to offer an overview, where major level contains
details that are relevant to that particular major which students
would find useful.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_major_setup.png"/>
    <figcaption>Majors are split into 3 layers</figcaption>
</figure>

According to [document]({attach}/downloads/20121012084054830.pdf)
published by the [Department of Education][] in 2012,
there are 12 categories, 92 subcategories and
506 majors.

# Category and subcategory

At this level, focus was to provide statistics which
is similar to what is done for schools at _State level_.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_18.png"/>
    <figcaption>Major category and subcategory</figcaption>
</figure>

Students can quickly browse through category and subcategory to locate
area of interest she wants to drill further down.

[department of education]: http://www.moe.gov.cn/publicfiles/business/htmlfiles/moe/s3882/201210/xxgk_143152.html

# Major

At this level, we think the most relevant information students want to
know is the job market datat.  So we built an integration point with
popular job posting sites. Dynamically the application will query
these sites and compile the most recent 50 job posts that matches this
major.


<figure class="row">
    <img class="img-responsive center" src="/images/gkp_19.png"/>
    <figcaption>Job title cloud</figcaption>
</figure>

Based on these data stream, a _job title keyword cloud_ is compiled
taht shows the job titles used by the industry, and they are further
grouped into cities so they provide another geo reference for
students.

<figure class="row">
    <img class="img-responsive center" src="/images/gkp_20.png"/>
    <figcaption>Schools grouped by job locations</figcaption>
</figure>

Below listed jobs, application will conveniently show schools that are
located in those cities since local graduate usually have an advantage
competing for jobs in local market. Another feature is that a toggle
switch will turn user's preference on and off so researcher can easily
search either by major and jobs alone, or by combination of the market
data and her own criteria.
