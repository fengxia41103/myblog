Title: GKP &mdash; school details
Date: 2015-09-07 14:00
Tags: gkp
Slug: gkp schools
Author: Feng Xia

In [part one]({filename}/workspace/gkp/introduction.md), we have
introduced functions that will help school
research at nation level, state and city level. In this article
I'll talk about features built to help research at _school level_.

## Bookmark

While research schools, it is useful to bookmark a page for later use. That's
where the _bookmark_ feature comes in. User can save unlimited bookmarks
and manage them by _x-out_(remove) it from saved list. Convenient.

<figure>
<div class="row">
    <div class="col-md-6">
    <img class="img-responsive center-block" src="images/gkp_9.png" />
    </div><div class="col-md-6">
    <img class="img-responsive center-block" src="images/gkp_10.png" />
    </div>
</div>
    <figcaption>Bookmark a school</figcaption>
</figure>

## School summary

School summary are mostly text extracted from multiple sources.
The first page contains an introduction, or a quick view, of the school.
It contains many meta data that can be extracted to form
more data dimensions.

<figure class="row">
    <img class="img-responsive center-block" src="images/gkp_11.png"/>
    <figcaption>School summary</figcaption>
</figure>

School detail page expands on top of the introduction. One small feature
concerning development is that TOC is auto generated.

<figure class="row">
    <img class="img-responsive center-block" src="images/gkp_12.png"/>
    <figcaption>School wiki</figcaption>
</figure>

## Historical admission scores

This page lists historical cutoff scores that the school has applied
in past admissions. GKP has collected over 2,000,000 data records
between 2010 and 2014 and covering 3,000 schools.

<figure class="row">
    <img class="img-responsive center-block" src="images/gkp_13.png"/>
    <figcaption>School historical cutoff scores</figcaption>
</figure>

Students can then use these scores as reference compared
to her estimated exam score in order to get a sense of how likely she
will be admitted.

## Social life

One important factor to consider, also a unique feature
of this application, is the campus social life. Here we
created an advanced backend engine to tap into
popular social media facilities and pull in live chat stream at
**50,000 new posts per minute**. This
gives students a rich information on how the campus life is like.

<figure class="row">
    <img class="img-responsive center-block" src="images/gkp_14.png"/>
    <figcaption>School social media data stream</figcaption>
</figure>

Data stream is being updated every 60 seconds. So for a user
it is convenient to leave the window open and watch new posts appear on
the screen instead of refreshing page manually.
Also, there is a voting mechanism behind the scene so that the more
users a page is being viewed (thus indicating more popularity),
the higher priority the page has in term of  receiving the next update.

<figure>
<div class="row">
    <div class="col-md-6">
    <img class="img-responsive center-block" src="images/gkp_15.png"/>
    </div><div class="col-md-6">
    <img class="img-responsive center-block" src="images/gkp_16.png"/>
    </div>
</div>
    <figcaption>Social media keyword cloud and news ticker</figcaption>
</figure>

Based on these streamed social media data, the application
provides a _Keyword Cloud_(shown on the left)
that reflects hot topics in the most recent 100 threads.
Further, the _Live Campus_(shown on the right) section shows thread
summaries in a scrolling news ticker fashion which makes monitoring
these threads simple and fun.

## Wechat channels

Wechat is a _whatsapp_ equivalent in China. It has a dominating
role especially among young people. Here
user will find a list of Wechat channels
that are affiliated with the candidate school, including
school news, clubs, communities and activities. Connecting to them is as simple
as scanning the barcode with her phone. It is another
unique feature that makes acquiring school information as painless as possible.

<figure class="row">
    <img class="img-responsive center-block" src="images/gkp_17.png"/>
    <figcaption>School Wechat channels</figcaption>
</figure>

## Major

In [part one]({filename}/workspace/gkp/introduction.md) and this article,
we have introduced research functions that assist user at different level
of interest. Here comes another important consideration that any
student must have &mdash; majors.
What to study is often driven by interest, but also it is
closely affected by its future job seeking prospective. In
[part three &mdash; majors]({filename}/workspace/gkp/majors.md) we will go over
these topics.
