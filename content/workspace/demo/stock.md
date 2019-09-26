Title: Project Stock Backtesting Demo
Date: 2015-08-06 15:00
Slug: project stock demo
Author: Feng Xia


<figure class="s12 center">
    <img src="/images/demo_jk.png"/>
    <figcaption>Project Stock frontpage</figcaption>
</figure>


> * [Demo][1]
> * Login: (demo, demopassword)

This project started at lunch with a friend who has been trading
stocks as hobby for years. None of us has worked in a trading house
playing with some serious money. Nonetheless, he believed that he has
found a winner strategy and I felt there is only one way to prove it
&mdash; data and test.

So here it is, a tool that can test a trading strategy over S&P 500
daily data and a few other data sets. The cool thing about this
application is that simulation is done as background process and
report has not only statistics compared against some index such as the
S&P 500, but a detailed step-by-step transaction trace that is ready
for a replay.

The bad news is that his winner strategy doesn't seem to be a winner
yet.  The good news is that we now have a framework that can host much
more data set and strategies, and running data set in this scale is
fun.

[1]: http://fengxia.co:8002/jk/
