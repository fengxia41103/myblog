Title: Alpha Advantage SP500 API
Date: 2017-11-12 19:00
Slug: alpha sp500
Category: REACT
Tags: react
Author: Feng Xia

<figure class="row">
  <img class="center-block responsive-img"
       src="/images/alpha%20advantage%20sp500.png"/>
    <figcaption>SP500</figcaption>
</figure>


While fixing my [stock project][1], I hit a road block, that Yahoo's 
free finance API is [gone!][2], no more. This is quite a bummer. How
to get daily quotes so to reestablish the data stream? Well, as a the
beauty of free market, someone is always up to the service if there is
a demand. So I ended up using [Alpha Advantage API][3] for a change.

[1]: https://github.com/fengxia41103/jk
[2]: https://forums.yahoo.net/t5/Yahoo-Finance-help/Is-Yahoo-Finance-API-broken/td-p/250503
[3]: https://www.alphavantage.co/documentation/

Tagging on top the [World Snapshot][4] project, this one is
essentially a graph browser that takes the API data stream based on
user selected company symbol, and draw all the data index on a single page.

[4]: {filename}/workspace/demo/visualization.md

> [live demo][5]

[5]: http://sp500chart.s3-website-us-east-1.amazonaws.com

The `architecture`/`design` is shown below, and [github code][6].
[6]: https://github.com/fengxia41103/sp500

<figure class="row">
  <img class="center-block responsive-img"
       src="/images/sp500%20architecture.png"/>
  <figcaption>SP500 SPA architecture</figcaption>
</figure>
