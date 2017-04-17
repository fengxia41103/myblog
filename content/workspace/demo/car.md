Title: SPA: car leasing calculator
Date: 2016-09-30 21:00
Slug: car leasing
Tags: demo, angular, react
Author: Feng Xia

<figure class="row">
    <img src="/images/demo_car.png"/>
    <figcaption>Project Car Leasing Calculator</figcaption>
</figure>

> * [AngularJS version][1]
> * [REACT version][4]


[1]: {filename}/workspace/angular/car.md
[4]: {filename}/workspace/react/car.md


Car leasing rooted in my own experience while researching for a new
car.  After putting together an Excel to model the car leasing
process, I started to think how to make the lesson learned available
for other buyers. Also, I figure this is a perfect candidate for a
single page application (SPA).

Two versions have been created &mdash; one in [Angular][], and another
in [REACT][]. This ties to my belief that however wonderful a tool may
be, it is also important how well it fits _your way of thinking and
typing_. So this project gives a case to evaluate which one I'd like
to invest into for more development.

[angular]: https://angularjs.org/
[react]: https://facebook.github.io/react/docs/getting-started.html

# Leasing deciphered

Sad reality is, all the leverages one can pull in a car leasing deal
have been made _intentionally_ complicated so to confuse
buyers. Jargon are everywhere, and everything is connected so one
number changed seems to be changing everything, and some changes are
more significant than others. How could one to figure out which is
which!?

I know there are many car leasing tutorials, blogs, articles and so
on. But here I want to present a different approach.  First of all,
let's turn those maths into diagram:

<figure class="row">
    <img src="/images/car leasing.png"/ class="img-responsive center-block">
    <figcaption>
        How do you get a monthly payment
    </figcaption>
</figure>

Now it's obvious, two numbers are the key because they determine monthly payment:

1. Financing cost: How much you are borrowing from bank? This is
determined by how much you can negotiate down the price, how much
deduction you can get, eg.  down payment, rebates, trade-ins,
credits. The rest will be the money you owe &rarr; borrowing (or in a
fancy term, financing).
2. Depreciation cost: How much your lease will cost to the car to be
worth **less** than a new one. This is the actual _car_ that you are
really paying for.

> Two numbers are the key: financing cost and depreciation cost

Financing cost then links APR (interest rate) because this is
the amount buyer is borrowing from a financing lender, either
a bank or the dealer itself. First of all, there is mathematical
standard to compute this. You need a computer or a calculator
for this because this is not linear math.
Second, believe or not, the effect of interest rate is not
as significant as one thinks, and I'll show you why.

On the other hand, **watch out** for depreciation cost because it is a
disaster.  There is no standard whatsoever. The best reference is a
**residue rate** derived from _official flyer_ posted on
manufacturer's website. But then there can be all kinds of excuses to
void that. Basically each dealer can make up their own
rules. Terrible. This is exactly the advantage dealer has over
buyers. Depreciation cost is easy to calculate. For a $20,000 car, 10%
decrease in residue rate will generate $2,000 more cash for the
dealer. Spreading that out to 36-month term, it's a $56 more payment
per month. So when leasing, make sure to use this tool to figure out
what the residue rate the dealer's offer is implying. If it's too far
off from the official flyer number, walk away!

## Math

This is an example by [Edmunds][]. See if you can follow the math
now after reading the diagram above. Now by looking at this,
I'm wondering maybe I should have built using this format. It is
more form-like than a SPA so this can be easier for user to follow:

<table class="table striped bordered">
  <tbody><tr>
    <td>1. Sticker Price of the car + options</td>
    <td>$23,000</td>
  </tr>
  <tr>
    <td>2. Times the residual value percentage</td>
    <td>X 57%</td>
  </tr>
  <tr>
    <td>3. Equals the residual value</td>
    <td>= $13,110</td>
  </tr>
  <tr>
    <td>4. Invoice price of car minus incentives (net capitalized cost) </td>
    <td>$20,000</td>
  </tr>
  <tr>
    <td>5. Minus the residual (from line 3)</td>
    <td>- $13,110</td>
  </tr>
  <tr>
    <td>6. Equals the depreciation over 36 months</td>
    <td>= $6,890</td>
  </tr>
  <tr>
    <td>7. Depreciation (line 6) divided by term in months</td>
    <td>÷ 36</td>
  </tr>
  <tr>
    <td>8. Equals the monthly depreciation payment</td>
    <td>= $191</td>
  </tr>
  <tr>
    <td>9. Net capitalized cost (From line 4)</td>
    <td>$20,000</td>
  </tr>
  <tr>
    <td>10. Plus the residual (From line 3)</td>
    <td>+ $13,110</td>
  </tr>
  <tr>
    <td>11. Equals</td>
    <td>= $33,110</td>
  </tr>
  <tr>
    <td>12. Times the money factor</td>
    <td>X 0.00125 (3 percent)</td>
  </tr>
  <tr>
    <td>13. Equals money factor (interest) payment portion</td>
    <td>= $41</td>
  </tr>
  <tr>
    <td>14. Monthly depreciation payment (from line 8)</td>
    <td>$191</td>
  </tr>
  <tr>
    <td>15. Plus money factor payment portion (from line 12)</td>
    <td>+ $41</td>
  </tr>
  <tr>
    <td>16. Equals bottom-line monthly lease payment</td>
    <td>= $232</td>
  </tr>
</tbody></table>

[edmunds]: http://www.edmunds.com/car-leasing/calculate-your-own-lease-payment.html

# AngularJS

First version was created in [Angular][].  In particular, I was
interested in its [component][]. It has been quite interesting to make
this page design based on component architecture.  Component
encapsulates logic and view rendering into one piece.  The HTML
templating capability has saved a lot of typings as well as making
changing any component a simple task.  For example, we put all form
input boxes into a component called `myinput`:

[component]: https://docs.angularjs.org/guide/component

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

And the template code `form_input.hh` (shown below). The extension
`.hh` is chosen because `.html` or `.htm` will be picked up by Pelican
for page rendering and not copied as static file even though its
parent path is a _STATIC_. Oh well.

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

<figure class="row">
    <img src="/images/car_1.png" class="img-responsive center-block"/>
    <figcaption>
        AngularJS Component rendered form inputs
    </figcaption>
</figure>

To complete this, below shows the file structure:

<pre class="brush:plain;">
├── app.module.js
└── car-leasing
    ├── assumption.hh
    ├── car-leasing.module.js
    ├── form_input.hh
    ├── form_section_header.hh
    ├── piechart.hh
    ├── summary_line_item.hh
    └── var_display.hh
</pre>

This maps directly to the component structure of this page:

* Summary &larr; a virtual container
    - summary line item &larr; `summary_line_item.hh`
* Charts &larr; a virtual container
    - pie chart &larr; `piechart.hh`
* Form &larr; a virtual container
    - form header &larr; `form_section_header.hh`
    - input boxes &larr; `form_input.hh`
    - derived value display &larr; `var_display.hh`

# REACT

[REACT][] is making a lot of buzz in my circle these days. Using this
project as an exercise I decided to look into building an _identical_
version as the Angular's. Both ended up writing about 700 lines of
code so typing wise they are almost the same.

REACT is done essentially in a big blob of code. I don't see there is
a templating system for JSX so everything is wired in a single
file. This is a plus when it's a one-man show because I don't have to
jump from file to file. But I can see in large-scale project this will
be a problem.

## Component

Similar to Angular's [component][], view and logic are encapsulated
within a REACT [react component][]. But different from Angular's,
REACT's philosophy of one-way data flow enforces design to separate
_props_ from _state_, which makes internal concepts clearer. State
becomes only necessary if its value will change and the change will
drive a UI decision.

[react component]: https://facebook.github.io/react/docs/component-api.html

This separation makes sense to me because too often I find myself
creating an army of variables just to transfer information from module
to module and there is not distinction between what is to be
`consumed` only in submodule for display or further computation, and
what is to be modifiable and make the change available else where.
Even though REACT's `onChange` event way of bubbling a change back to
parent component feels awkward, it does enforce such design decision.

Angular, on the other hand, gives you two-way binding for free so
everything becomes changeable. It's convenient for prototyping. But in
my opinion it delays these decisions which will surface in refactoring
phase anyway. So I think REACT helps in this regard to make the
separation more natural than Angular's way.

## View and Control

I have been doing things in MVC pattern all along. But there is a
devil lurking in background that feels strange and awkward &mdash; how to
make the UX dynamic? jQuery has been the tool for the last 3-5 years.
But honestly selecting element makes it tightly coupled with
HTML presentation layer that it is too fragile to be maintainable! How many
times you have added outer `div` and broke a jQuery action?

Angular and REACT both make life easier by tieing an actual variable
with such task. This goes back to my argument about decision making
&mdash; despite that it's a UI or a business logic, if there is a
decision to be made in order to set its _state_ accordingly, such
decision needs to be as explicit as possible. jQuery's element
selection is too depending on the HTML structure to work
right. Further, jQuery's code lives in its own `<script` section that
it becomes hard to understand which section of the DOM it will
manipulate. As a matter of fact it has access to the entire DOM so it
is irrelevant which template it lives in, it can screw up the others
if it chooses so. It gets even worse when using a templating system
that DOM details are not known until full rendered so that the query
line has to observe things like the sequence of the list item so
picking the `next("li")` gives you the one you want. These
_techniques_ is simply **counter-productive**.

# Conclusion

I like both [Angular][] and [REACT][]. My sense at this moment is
that [Angular][] is more developed. Especially with its [component][]
design, one can do the same thing as [REACT][], and with all the other
good stuff [Angular][] can do.

[REACT][] is a good choice for SPA. Its one-way data binding is a
great idea, IMHO, that enforces an important design decision. Putting
both HTML and JS in one place is a brave attempt to define what a
component is. Let's face it, in today's web application, all UI
elements may respond to some user event or data event so leveraging
Javascript's full power to control presentation from its birth instead
from jQuery's backwards logic is the right direction.
