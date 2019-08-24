Title: Project Fashion Demo
Date: 2016-03-06 9:00
Slug: project fashion demo
Author: Feng Xia

<figure class="s12 center">
    <img src="images/demo_fashion.png" />
    <figcaption>Project Fashion front page</figcaption>
</figure>

> * [Demo][1]
> * Login: (demo, demopassword)

Project Fashion is built to support daily business of an international
trading company who specializes fashion products. Main functions of
the application include product management, customer and vendor
database, order management (both sales and purchase), and inventory
management.

The company is based in US with two subsidiaries in mainland China.
Its challenges lied in multiple folds. First, orders and updates are emailed
back and forth which is error prone and can be quickly out of sync with
reality. Second, operation becomes
unaccountable when critical data points are missing, eg. who made
the last modification 2of a sales order? Third, vendors are operating
in Europe and North America time zones while the company's customers
are in China. The time difference and geographical separation between
the two ends make information flow difficult without a centrally maintained
information repository. Cloud drives were tried but still they
lack the capability to provide a coherent view for both sides.

On top of these issues, the company was to launch an initiative
to develop an e-Commerce platform for its customers and vendors.
This calls for a backbone system that can support not only the company's
currently offline operations, but its strategy going forward.


Without a further delay, I will introduce the core functions
and design considerations in these articles:

1. [product and inventory][2]
2. [sales order and purchase order][3]
3. [reporting][4]


[1]: http://fengxia.co:8003/wei/
[2]: {filename}/workspace/fashion/intro.md
[3]: {filename}/workspace/fashion/order.md
[4]: {filename}/workspace/fashion/report.md
