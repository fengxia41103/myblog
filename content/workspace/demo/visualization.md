Title: SPA: World Snapshot
Date: 2016-10-15 22:00
Slug: data visualization
Tags: demo, react
Author: Feng Xia

<figure class="s12 center">
  <img src="images/country_1.png"/>
    <figcaption>World Snapshot</figcaption>
</figure>

> * [live demo][3], and [github][4]
[3]: http://snapshots.world/
[4]: https://github.com/fengxia41103/worldsnapshot

The joy of making graphs in a data-driven web application has been the
highlight that kept me going from project to project. Once all things
are hooked up and data can be created in a meaningful way, the
ultimate presentation are _reports_ and _graphs_. In most cased, I
have found graphs are far better than reports &mdash; reports often
fall into a table form which looks impressive because it is filled
with data. But who is to the analysis and draw a conclusion!?  On the
other hand, graph, even using the same data set as that of the
report/table, is one step closer to a conclusive message &mdash; KPI
is above or below threshold, department A is doing better than
department B, sales of this month dropped comparing to last month's...

# Data sources

1. [DHS][]: [DHS][] data set is published by [US AID][]. Following its [API][]
   documents, [indicators][] are selected to depict a country's well doing.
2. [The World Bank]:  Another comprehensive data set is [The World Bank][] set.
   Check out its [indicators][1] page for a list of available indexes. Note that
   [official document][2] is still refering to _v1_ version of the API, which
   will block on CORS requests. Using **v2/en** endpoint instead. For example,
   to get a list of country names:

```javascript
var api = "http://api.worldbank.org/v2/en/countries?format=json&per_page=1000";
```

[data usa]: https://datausa.io/
[dhs]: http://dhsprogram.com/data/
[us aid]: https://www.usaid.gov/
[api]: http://api.dhsprogram.com/#/index.html
[indicators]: http://api.dhsprogram.com/#/api-indicators.cfm
[the world bank]: https://datahelpdesk.worldbank.org/knowledgebase/articles/898599-api-indicator-queries
[1]: http://data.worldbank.org/indicator
[2]: https://datahelpdesk.worldbank.org/knowledgebase/topics/125589

# Toolset

* [Materialize][]: "A modern responsive front-end framework based on Material Design" by their words.
* [REACT][]: core
* [webpack][]: new module builder that is making lot of buzz these days.
* [fetch][]: a new way to talk to API endpoints instead of `jQuery AJAX`.

[materialize]: http://materializecss.com/
[react]: https://facebook.github.io/react/
[webpack]: https://webpack.github.io/
[fetch]: https://github.com/github/fetch

# REACT components

Following REACT practice, compoents have been designed to handle both the
data acquisition through 3rd party API, and ploting using the awesome D3 library:

<figure class="s12 center">
  <img src="images/country health.png"/>
    <figcaption>Data visualization SPA architecture</figcaption>
</figure>

The key is to encapsulate data acquisition into `AjaxContainer`, data
source handling into `DataSourceContainer` and graphing into its own
`GraphFactoryContainer`.  Therefore, we can swap out any of these
components, for example, using Google chart for graphing, adding a new
data source, or using [fetch][] instead of `jQuery` for AJAX calls.

