Title: Fashion ERP &mdash; introduction
Date: 2016-06-02 10:00
Tags: fashion, erp
Slug: fashion introduction
Author: Feng Xia

Project Fashion is an ERP system built from ground up
based on operations in an international trading company
who has a specialty in fashion products. Each season there
are between 10 and 20 vendors and a few thousand new SKUs. Most
vendors roll out new designs twice per year &mdash; spring/summer
season and fall/winter season. Some may have new products
every month. To keep track of these products
and keep up with vendor's schedule have been the primarily challenge this coompany
has.

The system's role, therefore, is to replace previously paper-based
operations with now an online version so that product catelogue can be
centrally maintained, and multiple subsidaries
who are geographically separated can coordinate sales, purchase
and inventory, and upper management can receive
instant up-to-date reports and the ability to drill down to
SKU level details when needed.

Unlike a full blown ERP, a decision was made during
design to remove complexity so user and customer can operate with little training.
Configurable UI and workflow were scratched off. Instead,
hard coded workflow and accurate cross reference were implemented
so operator at each business function can understand
and operate her job intutitively.

On the broad side, functions are divided into the following categories:

* <span class="myhighlight">CRM</span>: customer and vendor database
* <span class="myhighlight">Product</span>: product database
* <span class="myhighlight">Inventory</span>: product inventory
* <span class="myhighlight">Sales</span>: sales order
* <span class="myhighlight">Purchase</span>: purchase order
* <span class="myhighlight">Invoice</span>: order invoices
* <span class="myhighlight">Report</span>: management reports

## Product

The key concept I'd like to clarify is the product [SKU][].
It has
been a surprise to me how many people who, even have been working in this industry
for years, do not understand SKU. _SKU_ is a stock unit. In other words,
it is the smallest unit the company chooses to manage its product.
The more detailed it is, the more accurate the rest of the
operations can be, but also the more work to set it up initially.

<figure>
    <img class="center-block img-responsive" src="images/fashion_1.png">
    <figcaption>For staffs, search by filter</figcaption>
</figure>

One interesting challenge relates to how one finds a particular product in
the system. Shoppers are visual animals. During 2015 Fall/Winter season
we followed clients in stores and observed their pattern.
All went on by first picking a cloth up from rack and looking at it
before she seeked out for more concrete information such as its
vendor or season. On the other hand, staffs can often directly recall
a product through their familiarity with its attributes such as vendor, season, name
and style's serial number,
instead of seeing it physically. Therefore, to staffs filtering
by these attributes will be more efficient.


<figure>
    <img class="center-block img-responsive" src="images/fashion_3.png">
    <figcaption>For customers, browse/search by season and vendor</figcaption>
</figure>

The search by season function is built with an e-Commerce interface in mind.
Customers are to "browse" instead of "search". Products are first grouped
by season then by vendor. Customer browse through
product catelogue as if in a e-shop so it
creates a more direct experience that filter boxes.
User can drill down from season to vendor, and to add product to shopping
cart which later turns into a sales order.

[sku]: https://en.wikipedia.org/wiki/Stock_keeping_unit


## Inventory

Product inventory are mapped to a 3-layer structure: company &mdash; location &mdash; storages.
A location represents a store, and within a store there can be multiple storages. Inventory
in storage can then be rolled up to location level and company level. There is also
a common setup of _region_ or _district_ level that is between company and location. It is
not implemented but can be added easily.

<figure>
    <img class="center-block img-responsive" src="images/fashion_2.png">
    <figcaption>Inventory structure diagram</figcaption>
</figure>

For each product, there are two inventory counts: _theoretical_ and _actual_. Theoretical
counts are derived from sales, purchase, returns and so forth; actual counts are
directly obtained from physically counting products in a storage, also called physical inventory.
As you can see, theoretical counts are dynamic because they are influenced by
business activities. Physical inventory is a snapshot in time when a staff
walks into the store's storage to count. Therefore, it is crucial to understand that
comparing the two implies a time stamp that both sides have to agree. Otherwise, such comparison
is meaningless.

<table class="table table-striped">
    <thead>
        <th>Theoretical inventory</th>
        <th>Physical inventory</th>
    </thead>
    <tbody>
        <tr><td>
            Product count will increase and decrease dynamically due to sales and purchase.
        </td><td>
            Product count is obstained only through counting goods in inventory physically.
        </td></tr>
    </tbody>
</table>

Physical inventory is usually scheduled. Some companies have daily count
while some have weekly or monthly count. On physical inventory page, user
can select from a list of storages to do the counting. Season and vendor
list within each storage are derived from products in that
storage by the application automatically.

<figure>
    <img class="center-block img-responsive" src="images/fashion_4.png">
    <figcaption>Select location and vendor to count</figcaption>
</figure>

When taking the physical count, one has two modes to choose from depending on
how counting is done. **Admin mode** displays product details such as style and size.
They are used as assisting information to the counting staff. Counts are default to 0.
Only the ones having a non-zero count will be highlighted and saved later.
However, it is possible that a product has been sold out. So to handle this special
case we use a _star_ to indicate this situation.

<figure>
    <img class="center-block img-responsive" src="images/fashion_5.png">
    <figcaption>Physical inventory admin mode</figcaption>
</figure>

User mode removes product details from the view, leaving only product SKU and
size information for reference.

<figure>
    <img class="center-block img-responsive" src="images/fashion_6.png">
    <figcaption>Physical inventory user mode</figcaption>
</figure>

So far I have covered Product and Inventory functions.
In [part two]({filename}/workspace/fashion/order.md), I will
dive into the core of this application to talk about
how we will handle sales orders and purchase orders.
