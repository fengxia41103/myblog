Title: SPA: data visualization
Date: 2016-10-15 22:00
Slug: data visualization
Tags: demo, react, visualization
Author: Feng Xia

<figure>
    <img class="center-block img-responsive" src="/images/country_1.png"/>
    <figcaption>Project Data Visualization</figcaption>
</figure>

> * [Country health][]


[country health]: {filename}/workspace/visualization/dhs_country.md


The joy of making graphs in a data-driven web application has been
the highlight that kept me going from project to project. Once all things
are hooked up and data can be created in a meaningful way,
the ultimate presentation are _reports_ and _graphs_. In most cased,
I have found graphs are far better than reports &mdash; reports
often fall into a table form which looks impressive because it
is filled with data. But who is to the analysis and draw a conclusion!?
On the other hand, graph, even using the same data set as that of the
report/table, is one step closer to a conclusive message &mdash;
KPI is above or below threshold, department
A is doing better than department B, sales of this month dropped comparing
to last month's...

After finding [these open source data API][1], the thought is to construct
a SPA to turn these data into visual form. Using REACT for the job, I came
up with this structure which consumes [The World Bank][] data
to illustrate a [country's KPIs][2].

[1]: https://github.com/toddmotto/public-apis
[the world bank]: https://datahelpdesk.worldbank.org/knowledgebase/articles/898599-api-indicator-queries
[2]: {filename}/workspace/visulization/dhs_country.md

<figure>
    <img class="center-block img-responsive" src="/images/country health.png"/>
    <figcaption>Data visualization SPA architecture</figcaption>
</figure>

The key is to encapsulate
data acquisition into `AjaxContainer`, data source handling into
`DataSourceContainer` and graphing into its own `GraphFactoryContainer`.
Therefore, we can swap out any of these components, for example, using
Google chart for graphing, adding a new data source, or
using [fetch][] instead of `jQuery` for AJAX calls.


[fetch]: https://github.com/github/fetch
