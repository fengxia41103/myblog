Title: Details of a Stock
Date: 2021-03-03 10:16
Tags: dev
Slug: stock detail
Author: Feng Xia

Detail of a stock is the primary research tool where you get
one-stop-shop of its numbers. Instead of duplicating common layouts
such as Google Finance, Finviz, I'm hoping to provide a _better_ user
experience that focuses on how a reader of this page is to consume the
information, not just throwing at him pile of facts & data, which,
though always impressive to begin with, is often overwhelming and
creating a diminishing return of these information quickly.


# Select a stock

To look at detail of a stock, select a symbol of list:

<figure class="col s12">
  <img src="images/stock/stock%20list.png"/>
  <figcaption>Stock list filter</figcaption>
</figure>

Upon typing on the search bar, case-sensitive matching takes place automatically with a 1-second debounce. Matched one will then be highlighted. To return to the full list, simply clear the search bar.

# Summary

<figure class="col s12">
  <img src="images/stock/stock%20detail%20summary.png"/>
  <figcaption>Stock detail summary section</figcaption>
</figure>

Three values that are less intuitive than others are:

- `DuPont ROE`: ROE computed using the Dupont model. This is based on
  company's financial statements. If happened to be that this stock
  doesn't have statement data, value will be 0, equivalent to an
  invalid.

- `ROE Gap %`: Since there is also _published_ ROE, this value
  indicates how far off the Dupont ROE from published one: `% =
  (published-dupont)/published`[^1]. Negative value will indicate that
  consensus opinion is more _conservative_ on this stock than I am.

- `Top 10 Institution Owned %`: Counting the ownership of top 10
  largest institutional owner/investor in this stock.

# Dupont ROE

[Dupont model][1] is a **decomposition** of ROE.

> There are three major financial metrics that drive return on equity
> (ROE): operating efficiency, asset use efficiency and financial
> leverage. Operating efficiency is represented by net profit margin
> or net income divided by total sales or revenue. Asset use
> efficiency is measured by the asset turnover ratio. Leverage is
> measured by the equity multiplier, which is equal to average assets
> divided by average equity.

What I like about this is the distinction of three different business models:

1. **high margin**: reflected in high profit margin. Their unit profit
   is good, think of high-end fashion. Downside of this type is that
   increasing volume will work against high unit margin. Thus scaling
   up by producing more is not the right strategy.

2. **high turn over**: think of Walmart, low unit margin, but huge
   volume. This is the opposite of high margin model, and is the
   dominant strategy by nearly all new entrants of an industry &larr;
   selling things cheap is always a eyeball catcher.

3. **high leverage**: don't know yet how to read this value because it
   feels a double-edge sword &mdash; can be interpreted as having the
   good credit to borrow (assuming banks are not stupid), or, on the
   other hand, loaded w/ debt and is in trouble. Further, this is
   highly dependent on the macro when debt is cheap or expansive, and
   I would even say the personality of CFO, as we all know, gamblers
   stack high leverage, and conservative grandpa hates debt. A common
   example of this model is the financial industry, whose foundation
   is leverage.

ROE, or the published ROE you find online, is usually based on an
averaged sales over multiple reporting periods, averaged assets, and
so on, thus resulting a single number.  This tool, however, computes
ROE for each reporting period, thus shedding lights on how ROE has
changed over time[^2].

<figure class="col s12">
  <img src="images/stock/dupont%20roe%20chart.png"/>
  <img src="images/stock/dupont%20roe%20values.png"/>
  <figcaption>Example of Dupont Period-to-Period</figcaption>
</figure>

In this example above, MSFT's ROE runs around 30 year to year. Profit
margin and asset turnover all went up in 2020 report, indicating a
healthy business operation. Its equity multiplier dropped a bit,
indicating it is taking on more debt than before. Considering MSFT's
reputation, I wouldn't then worry about its increased debt, and
further considering the cheap interest rate, it's likely a good
strategy to leverage up in this period. For example, if you google
`msft bond rate`, MSFT is running at [`3.625%`][2], making borrowing
money quite cheap for MSFT.

# Net Asset per Share

[Net asset][3] valuation is often applied to company that will be
liquidated. Here I'm applying a simple version: `(total asset - total
liabilities)/shares`. The idea is that if I pay off all liabilities,
what's left for stockholder, assuming you get asset for its book
value. Of course, this is a very rough estimation.

<figure class="col s12">
  <img src="images/stock/net%20asset.png"/>
  <figcaption>Example of Net Asset per Share</figcaption>
</figure>

However, there is also an important underline assumption that **asset
will grow together with business** &larr; essentially the company is
becoming bigger and bigger, and that biggness is in term of its
assets. Therefore, if it is deemed a healthy business, growing net
assets per share should be an indicator of its success. Using the
example above, BFAM's NAV grew from $12 to $21. Considering it is
acquiring more daycare centers and probably equipment with them, I am
taking this trend as a healthy growth of the business.

# DCF

Yeah I did quite some DCFs back in the MBA days, and sadly, I almost
forgot how to do it. So here it is, bringing back some memories.

<figure class="col s12">
  <img src="images/stock/dcf.png"/>
  <figcaption>Example of DCF</figcaption>
</figure>

DCF has a **lot of assumptions**. So I really don't see how to verify
or beat the market on all these dials single-handedly. Play with your
scenario by tweaking the input fields see how it will affect the
valuation[^3]. **Note** that terminal rate has a dramatic impact on the
valuation. So be prudent in your projection. Also, if your target is
an ETF, there won't be a DCF because it doesn't have balance sheet.

# Balance Sheet

Balance sheet data are the largest data set. See [yahooquery doc][4]
for available data points. I found raw numbers on a balance sheet are
rather pointless because human brain isn't good at processing
them. Further, knowing one's asset is 2.3B is meaningless, but its
changing from 2.3B to 2300B in one period is revealing! Therefore, for
balance sheet analysis, I'm not listing any reported numbers, but are
focusing on % of a total, and the same index change % from one period
to next.

<figure class="col s12">
  <img src="images/stock/balance%20sheet.png"/>
  <figcaption>Example of balance sheet</figcaption>
</figure>

I want to be conservative. Therefore, more attention is given to debt
and liability.

- `equity multiplier`: `= asset / equity`. Since `asset=debt+equity`,
  the higher this multiplier is, the more debt this company is taking,
  thus more leveraged. This, of course, is a double edged sword. It
  can mean that it has capability to raise debt (w/ lenders), thus
  using less equity to do business; it an also mean it's loaded w/
  debt and is in trouble.

- `debt to equity ratio`: ` = total debt/equity`.  Similar to the
  equity multiplier, I'm trying to understand how bad the company is
  relying on debt. So, if debt is 60%, and equity is 40%, it will be
  6:4=1.5. Therefore, the higher this number is, the more leveraged
  this company is.

- `liability/asset %`: `= total liability/total assets`. I'm assuming
  if the company is liquidating, will its asset enough to pay off its
  liability[^4]. Without consideration of discount, relative change
  among periods are still valid.

## period-to-period changes

- `debt % of asset`: `= total debt / total assets`. Debt is long-term
  liability. Ideally you also need to discount liability for its
  market value, not using its book value. In the example above, about
  50% of assets are debts. Debts are often renewed so a company
  constantly borrows. So my understanding is that a stable % is fine;
  a sudden change will signal health issue or a strategy shift.

- `debt %`: `= growth of total debt` from p1 to p1. Value of the first
  reporting period will be set to 0 as it has no _previous_
  one. Similar to the `debt % of asset` above, it measures how quickly
  a company is accruing debts. Negative value will be highlighted
  because the debt is decreasing, a good sign.

- `account payable %`: `= growth of AP`. AP is a liability. I feel in
  business AP can grow for two reasons: company is not paying off
  vendors because it's poor, or being greedy to use AP as free deposit
  for interest. AP decrease may either be a healthy sign that company
  has money to pay, or that vendors are losing faith in this business.

- `account receivable %`: `= growth of AC`. The counterpart of AP. If
  it grows, it's a bad sign that customers are not paying.

- `cash %`: `= growth of cash, cash equivalents, and short-term
  investment`. In other words, anything one an quickly turn into cash
  are counted. If it grows, I take it as a positive sign.

- `working capital %`: as name. Working capital = current assets -
  current liabilities. In other words, this measures how much a
  company needs to keep its business going, like a filler. If it
  grows, then the gap is enlarging, which puts more burden in
  borrowing to get a bigger filler.

- `net PP&E %`: as name.  PP&E is a long-term investment. It's a
  signal how much they are investing into the future production.

      Think about this. If you are going to run away, will u want to
      invest into a factory, or keep cash? So, I think a positive
      change is a good thing.

# Income Statement

See [yahooquery doc][5] for available data points. Again, raw numbers are not helpful. Instead, % of a total is useful, eg. profit margin.

<figure class="col s12">
  <img src="images/stock/income%20statement.png"/>
  <img src="images/stock/income%20statement%20values.png"/>
  <figcaption>Example of income statement</figcaption>
</figure>

- `COGS margin %`: `= cogs/revenue`. Total cost to bring in that much
  revenue. I'm expecting it to be rather stable if a business is run
  well.

- `operating income margin %`: `= operating income/operating
  revenue`. The higher it is, the higher operating margin there are,
  thus more efficient.

- `operating expanse margin %`: `= operating expanse/operating
  revenue`. These are direct cost to earn those revenue. The lower,
  the better. However, if we look at `operating income margin`
  together with this, you will find their sum is not 100%! What is
  missing is the operation overhead.

- `OPEX margin %`: `= OPEX/revenue`.

- `EBIT margin %`: `= EBIT/revenue`.

- `total expanse margin`: `= total expanse/revenue`.

# Cash Flow Statement

See [yahooquery doc][6] for available data points. In this analysis,
all values are converted to `B`. As a layman, I think the more cash
you have, the better.


<figure class="col s12">
  <img src="images/stock/cash%20flow%20values.png"/>
  <figcaption>Example of Cash Flow Statement</figcaption>
</figure>

- `cash growth from beginning`: `= (ending cash - beginning
  cash)/beginning`. This measures how much cash grew in that reporting
  period. I take this as a sign of how profitable the business is.

- `operating cash from prev %`: how much operating cash grew from
  previous report. I focus on operating cash because it represents
  what this business is about. Income, on the other hand, can be
  generated not through its core business, but some fancy accounting
  or financial activity (eg. bought bitcoin early) &larr; these are
  not what this business is, but luck. So if this index is growing, I
  take the biz is growing stronger.

- `FCF/operating CF`: how much operating cash ended up being free
  cash. The higher, the less overhead/debt one needs to pay off from
  operating cash flow, thus healthier.

- `FCF/net income`: a good explanation [here][7]:

      > If net income is much larger than cash flow from operations, it's a
      > signal that the company's earnings quality-the usefulness of
      > earnings-is questionable. If cash flow from operations exceeds net
      > income, on the other hand, the company may be much healthier than
      > its net income suggests.

- `operating CF/net income`: just because.

# valuation ratios

These are published ratios taken from [yahooquery][8]. I'm taking them
on face value as a reference point.

<figure class="col s12">
  <img src="images/stock/valuation%20ratios.png"/>
  <img src="images/stock/valuation%20ratios%values.png"/>
  <figcaption>Example of valuation ratios</figcaption>
</figure>

In this example, BFAM's PE grew from 49.76 in 12/31/2019 to now 379.47
on 2/24/2021. Alarming, isn't it!? If accepting this, we are saying
this business grew 7x more valuable in just one year, 2020, and don't
forget 2020 was the Corvid year! Doesn't make sense, does it?

On the other hand, P/B decreased from 9.73 &rarr; 8.06 over the same
period. Therefore, we actually need to find out what these _book
values_ came from, as it must have grown a lot in 2020. If they are
assets useful for operation, it's a good thing; otherwise, remember,
liability is part of asset also (since debt can actually be sold, thus
has value!). So growing asset can also be that it's taking on more
debts, which, in my opinion, is not a good thing.


[1]: https://www.investopedia.com/terms/d/dupontanalysis.asp
[2]: https://cbonds.com/bonds/87917/#:~:text=International%20bonds%3A%20Microsoft%2C%203.625%25%2015dec2023%2C%20USD%20(US594918AW47)
[3]: https://www.investopedia.com/terms/a/asset-based-approach.asp
[4]: https://yahooquery.dpguthrie.com/guide/ticker/financials/#balance_sheet
[5]: https://yahooquery.dpguthrie.com/guide/ticker/financials/#income_statement
[6]: https://yahooquery.dpguthrie.com/guide/ticker/financials/#cash_flow
[7]: https://www.morningstar.com/invglossary/cash_flow_from_operations.aspx
[8]: https://yahooquery.dpguthrie.com/guide/ticker/financials/#valuation_measures

[^1]: Whenever there is a published alternative to a computed one, it
    will always cast doubt when the two are different. Comparison as
    this is an attempt to measure how accurate source data are, and
    how accurate my computation is. Even assuming these two are
    perfect, a substantial gap would imply that I'm missing
    information which the concensus value has included (of course,
    here I'm assuming the published value is itself dependable).

[^2]: Smoothing always troubles me because it can mask outliers
    without good reasoning. An outlier can either be a noise that
    skews result, or a signal that something is wrong. Overall, I
    prefer a business who runs rather like a stable ship, not a bumper
    cart.

[^3]: I thought of building a sensitivity analysis. However, the
    general impact of each factor can be understood without using a
    specific stock. Further, combination of these factors can grow to
    a large matrix, and presenting all of them may seem impressive,
    but defeats the purpose making data consumable by a user.

[^4]: Asset value is using its book value. In reality, this should be
    discounted as some assets may have no buyer. Further, intangible
    asset such as reputation should be heavily discounted or removed
    entirely since I'm really thinking of this in case of the company
    being troubled, and then its name won't be worth much.
