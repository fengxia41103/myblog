Title: Stock
Date: 2021-02-08 13:33
Tags: thoughts
Slug: stock
Author: Feng Xia

<figure class="col s12">
  <img src="images/1968%20earth.jpg"/>
  <figcaption>First photo of the Earth taken by NASA in 1968</figcaption>
</figure>

Let's get serious about stocks. There are two ways of investing: pursuing value, or pursuing trend.

Rules:

- Don't mix the two camps &mdash; if you buy a stock for its value, don't pay much attention to its day-to-day trend. Instead, read its 8K and 10k.

Use the NASDAQ [earning calendar][1] to find your target.

# Value (by me)

- How to determine its value on paper?
- What creates value? I think these conditions must be AND:
  1. the product/service are in an industry having growing need.
  2. product/service is good quality
  3. management makes sound decision

## How to find candidates

I may have to re-read Benjamin's [intelligent investor][3]. All below are yr-to-yr.

1. Revenue growth above a threshold
2. Operating income/cash growing. Even better, if it takes a consistent % or larger of the revenue &rarr; company is operating to grow, not doing some other tricks such as finance.
3. Debt-to-income ratio is not blowing up &larr; a leverage threshold?
4. No ugly insider. Any of the below should trigger a NO:
  - executives scandal
  - big bonus when it's downsizing
  - execs sell off stocks in large numbers



## DCF model

Time to pick up your MBA.

1. Cash + cash equivalent assets.
2. Current revenue
3. Future revenue as `current rev * (1+growth rate)^year` for 1-10 years. 6-10 uses rate 50% of the 1-5's.
4. Discount future revenues w/ a rate &larr; use \beta to look up a discount rate.
4. Total debts, both long & short-term.
6. `Value = (cash + discounted revenues - total debts)/shares`

## MSFT

## AMZN

## BFAM

## SBUX

[8k][2]


###  what if my evaluation is always less than the stock price?

# Trend (by computer)

Trend is essentially saying that there is an underline current despite of the daily up/down. Well, for a company if I'm identifying its long-term trend as _growth_, isn't it the same as investing for value? Therefore, I think this thread should not address much as _how good it is in the long run_, but can be taken blindly only on basis of some calculation from historicals instead of much knowledge of the company.

- keep going up: buy things that are rising
  - quit at certain gain
  - quit when trend is reversed &larr; negative direction, and above a threshold.
- down &rarr; up: buy things that just fell, but I believe it will come back &larr; by probability, not value based

## n-day run probability

For a stock, compute how many N-day consecutive run in one direction &rarr; if I'm seeing A has 3-day ups now, this will tell me how likely it will have a 4-day up. Of course, if the probability is small, I should sell before its 4th day.

This computation can be further broken down into:

1. buy low sell high: probability when A fell, say 1%, how many days it took for it to recover 1% (now I have 1% gain)? 2%? and so on.

2. buy high sell high: chasing an up wave. Compute n-day consecutive run probability.
  1. how long can it run in one direction?
  2. how much it can gain before losing steam &larr; quit at certain gain

Now, what number used for this computation?

- adj close price: volatile perhaps. All derived values are essentially trying to make this less volatile. But until I understand them better, I don't think they are relevant yet.

## a longer-term trend (NO)

Apparently, daily volatility is too much. What if I combine different length of time frame, eg. 1-day AND 1-wk and 1-m? If all are in one direction, wouldn't it be a good indicator of the macro of this company?

Not really. I don't see a basis for this theory, because I could equally argue why not using 2-wk, or 6-m data? If I don't do value research, just want to identify a value candidate, say A is on the up curve, why not use yr-to-yr growth of revenue?

Therefore, there isn't a point doing this calculation.




[1]: https://www.nasdaq.com/market-activity/earnings
[2]: https://investors.brighthorizons.com/static-files/c23b8d9f-cda0-49ab-9fb0-325d5be61ca8
[3]: https://riosmauricio.com/wp-content/uploads/2019/04/The_Intelligent_Investor.pdf
