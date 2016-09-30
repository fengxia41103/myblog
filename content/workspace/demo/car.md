Title: Car leasing
Date: 2016-09-30 21:00
Slug: car leasing
Author: Feng Xia

<figure class="row">
    <img src="/images/demo_car.png"/>
    <figcaption>Project Car Leasing Calculator</figcaption>
</figure>


> * [Car leasing calculator][1]

Car leasing rooted in my own experience
while researching for a new car.
After putting together an Excel to model
the car leasing process, I started to think
how to make the lesson learned available
for other buyers. Also, I figure
this is a perfect candidate for a single
page application (SPA). Time for some [Angular][2].

## Logic

Sad reality is, all the leverages
one can pull in a car leasing deal
have been made _intentionally_ complicated
so to confuse buyers. Jargon
are everywhere, and everything is connected so
one number changed seems to be changing everything,
and some changes are more significant than
others. How could one to figure out
which is which!?

I know there are many car leasing tutorials, blogs, articles
and so on. But here I want to present a different approach.
First of all, let's turn those maths into diagram:

<figure>
    <img src="/images/car leasing.png"/ class="img-responsive center-block">
    <figcaption>
        How do you get a monthly payment
    </figcaption>
</figure>

Now it's obvious, two numbers are the key:

1. Financing cost: How much you are borrowing from bank? This is determined
by how much you can negotiate down the price, how much deduction you can get, eg.
down payment, rebates, trade-ins, credits. The rest will be the money
you owe &rarr; borrowing (or in a fancy term, financing).
2. Depreciation cost: How much your lease will cost to the car to be
worth **less** than a new one. This is the actual _car_ that you
are really paying for.

> Two numbers are the key: financing cost and depreciation cost

Financing cost then links APR (interest rate) because this is
the amount buyer is borrowing from a financing lender, either
a bank or the dealer itself. First of all, there is mathematical
standard to compute this. You need a computer or a calculator
for this because this is not linear math.
Second, believe or not, the effect of interest rate is not
as significant as one thinks, and I'll show you why.

On the other hand, **watch out** for depreciation cost
because it is a disaster.
There is no standard whatsoever. The best reference is
a **residue rate** derived from
_official flyer_ posted on manufacturer's website. But then
there can be all kinds of excuses to void that. Basically
each dealer can make up their own rules. Terrible. This
is exactly the advantage dealer has over buyers. Depreciation cost
is easy to calculate. For a $20,000 car, 10% decrease in residue rate
will generate $2,000 more cash for the dealer. Spreading that out
to 36-month term, it's a $56 more payment per month. So when leasing,
make sure to use this tool to figure out what the residue rate
the dealer's offer is implying. If it's too far off from the
official flyer number, walk away!


[1]: {filename}/workspace/angular/car.md

## AngularJS

[AngularJS][2] was picked for the project. In particular, I was interested
in its [component][3]. It has been quite interesting to
make this page design based on component architecture.
Component encapsulates logic and view rendering into one piece.
The HTML templating capability has saved a lot of typings
as well as making changing any component a simple task.
For example, we put all form input boxes into a component called
`myinput`:

<pre class="brush:javascript">
    ]).component('myinput', {
        bindings: {
            label: '@',
            model: '=',
            type: '@',
            max: '@',
            min: '@',
            step: '@'
        },
        templateUrl: '/app/car-leasing/form_input.hh',
        controller: function(){
            // Decimal points
            if (this.min) {
                this.min = parseInt(this.min);
            } else {
                this.min = 0;
            }
        }
</pre>

And the template code `form_input.hh` (shown below). The extension `.hh` is
because `.html` or `.htm` will all be picked up by Pelican for page
rendering and not copied as static
file even though its parent path is a _STATIC_. Oh well.

<pre class="brush:xml;">
    <div class="row form-group">
        <span class="col-xs-6 col-form-label text-right">[[ $ctrl.label ]]</span>
        <div class="col-xs-5 input-group" style="float:left;">
            <div class="input-group-addon" ng-show="$ctrl.type=='$'">$</div>
            <input type="number" class="form-control" min="[[$ctrl.min]]" max="[[$ctrl.max]]" step="[[$ctrl.step]]" ng-model="$ctrl.model">
            <div class="input-group-addon" ng-show="$ctrl.type=='%'">%</div>
            <div class="input-group-addon" ng-show="$ctrl.type=='month'">month</div>
        </div>
    </div>
</pre>

With the component in place, rendering an `form input` section like this one is a breeze:

<figure>
    <img src="/images/car_1.png" class="img-responsive center-block"/>
    <figcaption>
        AngularJS Component rendered form inputs
    </figcaption>
</figure>


[2]: https://angularjs.org/
[3]: https://docs.angularjs.org/guide/component
