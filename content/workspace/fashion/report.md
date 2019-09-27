Title: Fashion ERP &mdash; reports
Date: 2016-06-12 10:00
Tags: fashion
Slug: fashion reports
Author: Feng Xia

In [part one]({filename}/workspace/fashion/intro.md) and
[part two]({filename}/workspace/fashion/order.md), we have
reviewed inventory management and order management. Their functions
are meant for operator to book-keep information of daily operations.
Once these data points have been captured, the power of the application
shines in term of data analysis and reporting.

Reports can be grouped into three categories:

1. <span class="myhighlight">reports at product level</span>: top
   seller, top purchased, top profitable
2. <span class="myhighlight">reports at order level</span>: top SO by
   qty balance, top SO in-progress fulfills
3. <span class="myhighlight">reports of seller/buyer account
   level</span>: customer AR, vendor AP

Data points are essentially rolled up following this pattern: product level &rarr; order level
&rarr; account level.

# Product level reports
## Top selling product

Knowing the top seller is the most important thing for any business.
The report is compiled from sales orders to show which product is high in demand.

<figure>
    <img class="center img-responsive" src="images/fashion_19.png">
    <figcaption>Top seller report</figcaption>
</figure>

## Top profitable product

Your best seller shows the demand, but they are not necessarily
the best for your business if their margin is low. Instead, a high margin
item may be the target that your next market campaign should focus on.
Together with the _top seller report_, these two
can give good insights to guide your pricing strategy and marketing
efforts.

> A negative profit margin is a clear signal that something is
> not correct in either the
> price or the vendor cost of product. It can be a simple typo, but
> can also be an indicator of wrong strategy.

<figure>
    <img class="center img-responsive" src="images/fashion_20.png">
    <figcaption>Most profitable product report</figcaption>
</figure>

## Top purchased product

Top purchased product can be a result of a good sales. But it can also
become staled stocks sitting there. The mismatch between your top seller
and top purchased should always deserve a further analysis in order to
ensure that your business is not just piling up inventory without
an exit plan.

<figure>
    <img class="center img-responsive" src="images/fashion_21.png">
    <figcaption>Top purchased product report</figcaption>
</figure>

# Order level reports

## Top sales orders by QTY balance

Purpose of this report is to monitor sales orders whose fulfillment is
lagging behind.  The higher the QTY balance is, the more risk there is
that the order fails to fulfill properly. However, it does not
distinguish between an order that has zero fulfillment rate and the
ones that are in-progress.

<figure>
    <img class="center img-responsive" src="images/fashion_22.png">
    <figcaption>Top sales order by QTY balance report</figcaption>
</figure>

## Top SO in-progress fulfills

This report monitors in-progress sales orders that have received some
levels of fulfillment. The higher the fulfillment rate is, the
healthier the order is.  A negative rate is possible when such type of
sales allows filing product returns without linking it to a
fulfillment. That's usually the case when filing return and filing
fulfillment form are handled by two groups of people who are not
synchronized.

<figure>
    <img class="center img-responsive" src="images/fashion_23.png">
    <figcaption>Top sales order in-progress fulfills report</figcaption>
</figure>

# Account level reports

At account level, we created _customer account receivable_ report and
_vendor account payable_ report. Both are health indicators of how well
we are maintaining a relationship with our peers.

<figure>
  <div class="row">
    <div class="col s6">
      <img class="center img-responsive" src="images/fashion_24.png">
    </div><div class="col s6">
      <img class="center img-responsive" src="images/fashion_25.png">
    </div></div>
    <figcaption>Customer AR and vendor AP report</figcaption>
</figure>
