Title: Car leasing calculator Angular
Date: 2016-09-25 13:00
Slug: car leasing calculator angular
Author: Feng Xia
Status: draft

<script type="text/javascript"
        src="../app/app.module.js">
</script>
<script type="text/javascript"
        src="../app/car-leasing/car-leasing.module.js">
</script>

<div ng-app="fengApp"
     ng-controller="CarLeasingController"
     id="sth">
  <div class="row mySummary">
    <h4 class="page-header nocount">Summary</h4>
    <div class="divider"></div>
    <br />
    <summary label="Total lease"
             model="lease_after_tax"
             type="$"></summary>
    <summary label="Monthly payment"
             model="monthly_lease_payment_after_tax"
             type="$"></summary>
    <summary label="APR"
             model="apr"
             type="%"></summary>
    <summary label="Term"
             model="term"
             type="month"
             precision="0"></summary>
    <summary label="Cost of ownership"
             model="cost_of_ownership"
             type="$"></summary>
    <summary label="Drive off cost"
             model="upfront_cost"
             type="$"></summary>
    <summary label="Last payment/refund"
             model="lease_end_cost"
             type="$"></summary>
  </div>

  <div class="row">
    <piechart id="monthly-payment"
              title="Monthly payment breakdown"
              data="monthly_payments_chart"
              class="col s6"
              style="min-height:300px;"></piechart>
    <piechart id="cost-of-ownership"
              title="Cost of ownership breakdown"
              data="cost_of_ownership_chart"
              class="col s6"
              style="min-height:300px;"></piechart>
  </div>

  <formheader title="Official leasing sample"></formheader>
  <section>
    <assumptions id="official-example"
                 values="official_example_assumptions"></assumptions>
    <div class="my-multicol-2">
      <myinput label="Example MSRP"
               model="example_msrp"
               type="$"
               step="1000"></myinput>
      <myinput label="Example residue"
               model="example_residue"
               type="$"
               max="[[example_msrp]]"
               step="1000"></myinput>
    </div>
  </section>

  <formheader title="Deal terms"></formheader>
  <section>
    <assumptions id="deal-term"
                 values="deal_term_assumptions"></assumptions>
    <div class="my-multicol-2">
      <myinput label="MSRP"
               model="msrp"
               type="$"></myinput>
      <myinput label="Invoice"
               model="invoice"
               type="$"
               max="[[msrp]]"></myinput>
      <myinput label="Lease"
               model="lease"
               type="$"
               max="[[msrp]]"></myinput>
      <myinput label="APR"
               model="apr"
               type="%"
               max="40"></myinput>
      <myinput label="Term"
               model="term"
               type="month"
               max="60"
               step="12"></myinput>
      <myinput label="NC HUT"
               model="monthly_tax"
               type="%"></myinput>
      <myinput label="Sales tax"
               model="sales_tax"
               type="%"></myinput>
    </div>
  </section>

  <!-- Deductions -->
  <formheader title="Deductions"></formheader>
  <section>
    <assumptions id="deduction"
                 values="mf_assumptions"></assumptions>
    <div class="my-multicol-2">
      <myinput label="Credits"
               model="credits"
               type="$"></myinput>
      <myinput label="Rebates"
               model="rebates"
               type="$"></myinput>
      <myinput label="Downpayment"
               model="downpayment"
               type="$"></myinput>
      <myinput label="MSD MF discount"
               model="msd_mf_discount"
               max="0.0001"
               step="0.00001"></myinput>
      <myinput label="MSD selected"
               model="msd_selected"></myinput>
      <myvalue label="Equivalent APR discount"
               model="msd_discount_apr"
               precision="2"
               type="%"></myvalue>
    </div>
  </section>

  <!-- Depreciation -->
  <formheader title="Monthly costs"></formheader>
  <section>
    <assumptions id="monthly-costs"
                 values="monthly_assumptions"></assumptions>
    <div class="my-multicol-2">
      <myvalue label="Depreciation cost"
               model="monthly_depreciation"
               type="$"></myvalue>
      <myvalue label="Financing cost"
               model="monthly_financing"
               type="$"></myvalue>
      <myvalue label="Monthly tax"
               model="monthly_tax"
               type="$"></myvalue>
      <myvalue label="Monthly payment w/ tax"
               model="monthly_lease_payment_after_tax"
               type="$"></myvalue>
    </div>
  </section>

  <formheader title="Due at signing"></formheader>
  <section>
    <assumptions id="upfront-costs"
                 values="upfront_cost_assumptions"></assumptions>

    <div class="my-multicol-2">
      <myvalue label="Downpayment"
               model="downpayment"
               type="$"></myvalue>
      <myinput label="Registration fee"
               model="registration_fee"
               type="$"></myinput>
      <myinput label="Plate fee"
               model="plate_fee"
               type="$"></myinput>
      <myinput label="Documentation fee"
               model="documentation_fee"
               type="$"></myinput>
      <myvalue label="1st month payment"
               model="monthly_lease_payment_after_tax"
               type="$"></myvalue>
      <myinput label="Acquisition fee"
               model="acquisition_fee"
               type="$"></myinput>
      <myinput label="Security deposit"
               model="security_deposit"
               type="$"></myinput>
    </div>
  </section>

  <formheader title="Due at lease end"></formheader>
  <section>
    <div class="my-multicol-2">
      <myinput label="Disposition fee"
               model="disposition_fee"
               type="$"></myinput>
      <myinput label="Wear & tear charge"
               model="wear_charge"
               type="$"></myinput>
      <myinput label="Security refund rate"
               model="security_refund_rate"
               type="%"
               max="100"></myinput>
      <myvalue label="Security refund"
               model="security_refund"
               type="$"></myvalue>
      <myvalue label="MSD refund"
               model="total_msd"
               type="$"></myvalue>
    </div>
  </section>

  <formheader title="Dealer's book"></formheader>
  <section>
    <assumptions id="dealer"
                 values="dealer_assumptions"></assumptions>
    <div class="my-multicol-2">
      <myinput label="COGS"
               model="dealer_cogs"
               min="[[residue_value]]"
               step="100"
               type="$"></myinput>
      <myinput label="Resale markup"
               model="dealer_resale_markup"
               type="%"></myinput>
      <myinput label="Ownership of resale"
               model="dealer_ownership_resale"
               type="%"></myinput>
      <myinput label="Cost of capital"
               model="dealer_cost_of_capital"
               type="%"
               max="10"></myinput>
      <myvalue label="NPV"
               model="dealer_npv"
               type="$"></myvalue>
      <myvalue label="IRR"
               model="dealer_irr"
               type="%"></myvalue>
    </div>
  </section>
</div>

<script type="text/javascript">
 var j$ = jQuery.noConflict();

 j$(document).ready(function() {
   j$('section').hide();

   // toggle resume exp content by clicking on its header
   j$('formheader').click(function() {
     j$(this).next('section').toggle("slide", {
       direction: "right"
     }, 1000);

     j$(this).find('i').last().toggleClass('fa-angle-double-up');
     j$(this).find('i').last().toggleClass('fa-angle-double-down');
   });

 });
</script>
