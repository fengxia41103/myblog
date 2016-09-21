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
between the two is _fullfillment rate_. All products are cleared when fullfillment rate hits 100%.
At this point, seller has fullfilled what the buyer is expecting, either by original
products or replacement or any other forms of settlement in between.

<figure>
    <img class="center-block" src="images/order%20life%20cycle.png">
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


## Sales order

<figure>
    <img class="center-block" src="images/fashion_7.png">
    <figcaption>Sales order summary</figcaption>
</figure>
