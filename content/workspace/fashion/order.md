Title: Fashion ERP &mdash; orders
Date: 2016-06-06 10:00
Tags: fashion, erp
Slug: fashion orders
Author: Feng Xia

In [part one]({filename}/workspace/fashion/intro.md) I have
shown the design and function behind Product and Inventory management.
In this article I'll talk about orders.

Sales order and purchase order are like two sides of the same coin.
Each sales order(SO) can include a mixed bag of products
from different vendors. Once a SO has been created, application will parse
it into multiple purchase order (PO) and route them
to their vendor. Reversely, company can place a PO with a vendor, and purchased
products can be used to fullfill multiple sales orders later.

## Order life cycle

To understand the design of orders, one has to first grasp the life cycle
of an order. I'd like to divide its functions into roughly two areas: _about physical
good_ and _about money_.

The area of physical goods takes care of
the acquisition of products on order. This includes shipping, receiving,
reconciliation, inventory, product return and substitution. Like what we did
in inventory, we maintain a theoretical list which comes from the sales order itself (think
of it as a wish list) and an actual list which tracks all the above activities. The ratio
between the two is _fullfill rate_. All products are cleared when fullfill rate hits 100%.
At this point, seller has fullfilled what the buyer is expecting, either by original
products or replacement or any other forms of settlement in between.

<figure>
    <img class="center-block" src="images/order life cycle.png">
    <figcaption>Order life cycle</figcaption>
</figure>

The second area of interest is about money. Depending on the business model and industry,
some will require a form of payment, either by a percentage or in full, before any shipment, while others
can live with zero down up front. The hinge that links activities handling physical goods
and the money is the _invoice_. Invoice is a detailed record (bill) that both the seller
and the buyer will eventually agree in order to proceed with a financial reconciliation.
Ideally buyer pays against an invoice, though I have seen other forms of arrangement in different industries.
Therefore, on the money side there are also a theoretical represented by invoices and an actual
which are actual payments. The ratio between these two forms _payment ratio_. To simplify
things here we will regard financial reconciliation is complete when payment ratio hits 100%.


## Create an order

Sales order can ben taken in one of two ways. The _quick way_ is designed
for internal staff to create an sales order by directly typing in
line items using a simple syntax:

> Each line starts with SKU number, followed by comma delimitered size-qty pairs.

For example, "234, S-1, M-2" is to
order product SKU# 234, one small and two medium. Alternatively one can also
create a sales order through traditional shopping cart method.

<figure>
    <div class="row">
    <div class="col-md-6">
    <img class="center-block" src="/images/fashion_7.png">
    </div><div class="col-md-6">
    <img class="center-block" src="/images/fashion_8.png">
    </div></div>
    <figcaption>
        One can use a quick way or shopping cart to create a sales order
    </figcaption>
</figure>

## Order summary and details

A nice feature here is that for an aggregated information such as total
quantity and sum, the application offers a dropdown that user can
easily view a broken-down detail by each vendor.

<figure>
    <img class="center-block" src="/images/fashion_9.png">
</figure>

Order details are grouped by vendor also. Each vendor tab has details
of products on order. At the bottom of tab, the application computes
a _total qty_ and _total value_ for that vendor.

<figure>
    <img class="center-block" src="/images/fashion_10.png">
    <figcaption>Order detail tabs are a set of shopping basket, one per vendor</figcaption>
</figure>

## Receiving and fullfillment

Product receiving is represented by fullfillment in the application.
I call an item fullfilled when buyer side has _received and accepted_
that item. In turn, fullfill rate is the count of items that met this condition
over the total products on order. It is important to note
that only _accpeted_ one is counted as fullfilled. Received counts are
inaccurate because item can be received but then returned due to damage.

> fullfill rate = count of fullfilled item / total number of items

<figure>
    <img class="center-block" src="/images/fashion_11.png">
    <figcaption>Create an order fullfillment</figcaption>
</figure>

Fullfilling a product is almost like filling in an inventory count sheet.
Potentially this can be automated using barcode scanner or other form
of scanning technology
But unlike a count sheet that is specific for a vendor, fullfillment form
lists all vendors and products on order. This accouts for the
fact that shipments can come in at random order. Therefore, showing
them on a single page saves the receiving staff
from jumping through multiple screens in order to record shipments.
_QTY BALANCE_ column shows
the remaining quantity that the application is expecting. This is the _theoretical_
value for a line time, and the addition of all received fullfillments will
be the _actual_.

<figure>
    <img class="center-block" src="/images/fashion_12.png">
    <figcaption>Fullfillment summary</figcaption>
</figure>

Fullfillment summary is a great way to keep track of receiving status.
One interesting distinction here is the _fullfill rate of quantity versus that of
value_. This accounts for the fact that products have different values.
Therefore, a 90% fullfill rate of quantity may not be a good news if
in value the fullfill rate is much lower. Monitoring this gap can be
an early warning sign that the supplier is lagging behind.

Finalizing a fullfillment is to lock in the receiving status. User can
either do this on each fullfillment (eg. in a long
running order where fullfillments come in over a stretched
period of time), or close them all with a single click. Simple.
