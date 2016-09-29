Title: Car leasing calculator
Date: 2016-09-25 13:00 S
lug: car leasing
Author: Feng Xia
Summary: Car leasing calculator is a research tool
    for car buyer to evaluate different offers. Car leasing, IMHO, is
    built with whoops and traps that seller has _intentionally_ put there
    in order to take advantage of buyers. These maths are not advanced,
    but complex enough to intimidate buyers to the point that they will
    take whatever is handed down by the dealer just to avoid the
    stress. It doesn't need to be that way. This tool is to lift the hood
    and show you how everything pieces are put together.

<script type="text/javascript" src="/app/app.module.js">
</script>
<script type="text/javascript" src="/app/car-leasing/car-leasing.module.js">
</script>

<div ng-app="fengApp" ng-controller="CarLeasingController">

    <div class="row" style="background-color:#337ab7; padding: 0em 1em 1em 1em;color:#efefef;margin-bottom:1em;">
        <h4 class="page-header">Summary</h4>
        <span class="col-xs-4">Total lease</span>
        <strong class="col-xs-6">$ [[lease_after_tax | number: "2" ]]</strong>
        <span class="col-xs-4">Monthly payment</span>
        <strong class="col-xs-6">$ [[monthly_lease_payment_after_tax | number: "2" ]]</strong>
        <span class="col-xs-4">APR</span>
        <strong class="col-xs-6">[[ apr ]]%</strong>
        <span class="col-xs-4">Term</span>
        <strong class="col-xs-6">[[ term ]] months</strong>
        <span class="col-xs-4">Cost of ownership</span>
        <strong class="col-xs-6">[[ cost_of_ownership | number: "2" ]]</strong>
    </div>

    <div class="row">
        <piechart title="Monthly payment breakdown" data="monthly_payments_chart" class="col-md-6" style="min-height:300px;"></piechart>
    </div>

    <formheader title="Official leasing sample"></formheader>
    <fieldset class="my-multicol-2">
        <myinput label="Example MSRP" model="example_msrp" type="$"></myinput>
        <myinput label="Example lease price" model="example_lease" type="$"></myinput>
    </fieldset>


    <formheader title="Deal terms"></formheader>
    <fieldset class="my-multicol-2">
        <myinput label="MSRP" model="msrp" type="$"></myinput>
        <myinput label="Invoice" model="invoice" type="$"></myinput>
        <myinput label="Lease" model="lease" type="$"></myinput>
        <myinput label="APR" model="apr" type="%"></myinput>
        <myinput label="Term" model="term" type="month"></myinput>
        <myinput label="NC HUT" model="monthly_tax" type="%"></myinput>
        <myinput label="Sales tax" model="sales_tax" type="%"></myinput>
    </fieldset>


    <!-- Deductions -->
    <formheader title="Deductions"></formheader>
    <fieldset class="my-multicol-2">
        <myinput label="Credits" model="credits" type="$"></myinput>
        <myinput label="Rebates" model="rebates" type="$"></myinput>
        <myinput label="Downpayment" model="downpayment" type="$"></myinput>
        <myinput label="MSD MF discount" model="msd_mf_discount" type="$"></myinput>
        <myinput label="MSD selected" model="msd_selected"></myinput>
        <myvalue label="Equivalent APR discount" model="msd_discount_apr" precision="2" type="%"></myvalue>
    </fieldset>


    <!-- Depreciation -->
    <formheader title="Monthly costs"></formheader>
    <fieldset class="my-multicol-2">
        <myvalue label="Depreciation cost" model="monthly_depreciation" type="$"></myvalue>
        <myvalue label="Financing cost" model="monthly_financing" type="$"></myvalue>
        <myvalue label="Monthly tax" model="monthly_tax" type="$"></myvalue>
        <myvalue label="Monthly payment w/ tax" model="monthly_lease_payment_after_tax" type="$"></myvalue>
        <myvalue label="MSD" model="msd" type="$"></myvalue>
    </fieldset>


    <formheader title="Upfront costs"></formheader>
    <fieldset class="my-multicol-2">
        <myvalue label="Upfront cost" model="upfront_cost" type="$"></myvalue>
        <myvalue label="Downpayment" model="downpayment" type="$"></myvalue>
        <myvalue label="1st month payment" model="monthly_lease_payment_after_tax" type="$"></myvalue>
        <myinput label="Registration fee" model="registration_fee" type="$"></myinput>
        <myinput label="Plate fee" model="plate_fee" type="$"></myinput>
        <myinput label="Documentation fee" model="documentation_fee" type="$"></myinput>
        <myinput label="Acquisition fee" model="acquisition_fee" type="$"></myinput>
        <myinput label="Security deposit" model="security_deposit" type="$"></myinput>
    </fieldset>


    <formheader title="Lease end costs"></formheader>
    <fieldset class="my-multicol-2">
        <myinput label="Disposition fee" model="disposition_fee" type="$"></myinput>
        <myinput label="Wear & tear charge" model="wear_charge" type="$"></myinput>
    </fieldset>

    <formheader title="Implied Assumptions"></formheader>
    <!-- Implied assumptions -->
    <fieldset>
        <assumption label="Invoice-MSRP discount" model="msrp_invoice_discount" type="%"></assumption>
        <assumption label="Purchase-MSRP discount" model="msrp_purchase_discount" type="%"></assumption>
        <assumption label="Lease-MSRP discount" model="msrp_lease_discount" type="%"></assumption>
        <assumption label="Purchase-invoice discount" model="invoice_purchase_discount" type="%"></assumption>
        <assumption label="Lease-invoice discount" model="invoice_lease_discount" type="%"></assumption>
        <assumption label="Residue pcnt" model="residue" type="%"></assumption>
        <assumption label="Dealer MF" model="dealer_mf" precision="6"></assumption>
        <assumption label="Max MSD discount" model="max_msd_discount" precision="6"></assumption>
        <assumption label="Actual MF" model="actual_mf" precision="6"></assumption>
        <assumption label="Actual APR" model="actual_apr" precision="2" type="%"></assumption>
    </fieldset>


    <h3>Dealer's secret book</h3>

    <fieldset class="my-multicol-2">
        <myinput label="Manufacturer discount" model="dealer_discount" type="%"></myinput>
        <myinput label="Cost of capital" model="dealer_cost_of_capital" type="%"></myinput>
        <myinput label="Resale markup" model="dealer_resale_markup" type="%"></myinput>
    </fieldset>

    <assumption label="Dealer initial investment" model="dealer_initial_investment" type="$"></assumption>
    <assumption label="Dealer terminal value" model="dealer_terminal_value" type="$"></assumption>
    <assumption label="Dealer IRR" model="dealer_irr" type="%"></assumption>
    <assumption label="Dealer NPV" model="dealer_npv" type="$"></assumption>
</div>

<script type="text/javascript">
    var j$ = jQuery.noConflict();


    j$(document).ready(function() {
        // toggle resume exp content by clicking on its header
        j$('formheader').click(function() {
            j$(this).next('fieldset').toggle("slide", {
                direction: "right"
            }, 1000);

            j$(this).find('i').last().toggleClass('fa-angle-double-up');
            j$(this).find('i').last().toggleClass('fa-angle-double-down');
        });

    });
</script>
