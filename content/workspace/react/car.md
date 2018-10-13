Title: Car leasing calculator REACT
Date: 2016-09-30 13:00
Slug: car leasing calculator react
Category: REACT
Tags: react
Author: Feng Xia
Status: Draft

<div id="sth"></div>
<script type="text/babel">
 var randomId = function() {
   return "MY" + (Math.random() * 1e32).toString(12);
 };

 var Summary = React.createClass({
   render: function(){
     var divStyle = {
       backgroundColor: "#333",
       padding: "1em",
       color: "#efefef",
       marginBottom:"1em"
     };

     var summaryNodes = this.props.data.map(function(summary) {
       return (
         <SummaryValueDisplay key={summary.label} {...summary} />
       );
     });

     return (
       <div className="row" style={divStyle}>
         <h4 className="page-header nocount">Summary</h4>
         <div className="divider"></div>
         <br />
         <div className="row">
           {summaryNodes}
         </div>
       </div>
     );
   }
 });

 var SummaryValueDisplay = React.createClass({
   render: function(){
     var dollar = (typeof this.props.unit=="undefined") || this.props.unit =="$"?
                  <span style={{"marginRight": "0.3em"}}>$</span>: "";
     var negativeHighlight = this.props.value >= 0 ? "": "myhighlight";
     var pcnt = (this.props.unit=="%" || this.props.unit=="month") ?
                <span style={{"marginLeft": "0.3em"}}>{this.props.unit}</span>:"";

     return (
       <div className="col s6">
         <label className="col s6">
           {this.props.label}
         </label>
         <div className="col s6 myValue">
           {dollar}
           <span className={negativeHighlight}>
             {this.props.value.toFixed(2)}
           </span>
           {pcnt}
         </div>
         <div className="divider"></div>
       </div>
     );
   }
 });

 var FormInput = React.createClass({
   handleChange: function(event) {
     var text = event.target.value;
     this.props.onChange(this.props.id, text);
   },
   render: function(){
     var inputStyle = {
       float: "left"
     };
     var dollar = (typeof this.props.unit=="undefined") || this.props.unit =="$"?"$":null;
     var negativeHighlight = this.props.value > 0 ? "": "myhighlight";
     var pcnt = (this.props.unit=="%" || this.props.unit=="month") ?
                this.props.unit: null;
     var max = this.props.max? this.props.max:"";
     var min = this.props.min? this.props.min:"0";
     var step = this.props.step? this.props.step: "1";

     return (
       <div className="input-field col s6">
         <label className="active">
           {this.props.label} ({dollar}{pcnt})
         </label>
         <input type="number"
                placeholder={this.props.value}
                className="{negativeHighlight}"
                max={max} min={min} step={step}
                value={this.props.value}
                onChange={this.handleChange}
           />
       </div>
     );
   }
 });
 var FormValueDisplay = React.createClass({
   render: function(){
     var dollar = (typeof this.props.unit=="undefined") || this.props.unit =="$"?
                  <span style={{"marginRight": "0.3em"}}>$</span>: "";
     var negativeHighlight = this.props.value >= 0 ? "": "myhighlight";
     var pcnt = (this.props.unit=="%" || this.props.unit=="month") ?
                <span style={{"marginLeft": "0.3em"}}>{this.props.unit}</span>:"";

     return (
       <div className="input-field col s6">
         <label className="active">
           {this.props.label} ({dollar}{pcnt})
         </label>
         <input disabled type="number"
                className="{negativeHighlight}"
                value={this.props.value.toFixed(2)}
                onChange={this.handleChange}
           />
       </div>
     );
   }
 });

 var FormHeader = React.createClass({
   handleClick: function(event) {
     this.props.handleClick();
   },
   render: function(){
     var switchClass = classNames("fa", {
       "fa-angle-double-up": this.props.showFields,
       "fa-angle-double-down": !this.props.showFields
     });

     return (
       <div className="row my-resume-header" onClick={this.handleClick}>
         <div className="col s11">
           <h4 className="nocount">{this.props.title}</h4>
         </div>
         <div  className="right-align col s1" data-toggle="tooltip" title="Click to expand and collapse">
           <br />
           <i className={switchClass}></i>
         </div>
       </div>
     );
   }
 });

 var FormBox = React.createClass({
   getInitialState: function(){
     return {showFields: false};
   },
   handleClick: function(){
     this.setState({
       showFields: !this.state.showFields, // toggle
     });
   },
   render: function(){
     // Input fields
     var formFields = [];
     if (typeof this.props.data.fields != "undefined"){
       formFields = this.props.data.fields.map(function(field) {
         // This is the magic line to make the state update
         // in sync with parent's state
         field.onChange = this.props.onChange;

         field.id = field.name;
         return <FormInput
                    key={field.name}
                    {...field} />
       }, this);
     }
     // Value displays
     var valueFields = [];
     if (typeof this.props.data.values != "undefined"){
       valueFields = this.props.data.values.map(function(field) {
         field.id = field.name;
         return <FormValueDisplay
                    key={field.name}
                    {...field} />
       }, this);
     }

     // All fields
     var fields = this.state.showFields?
     (
       <div>
         <p></p>
         <h6 className="myhighlight nocount">
           Adjustments
         </h6>
         <div style={{marginBottom:"2em"}}
              className="row">
           {valueFields}
           {formFields}
         </div>
       </div>
     ): null;


     var assumptions = this.state.showFields?
                       <AssumptionBox fields={this.props.data.assumptions} />:null;

     // Render
     return (
       <div>
         <FormHeader title={this.props.data.title}
                     showFields={this.state.showFields}
                     handleClick={this.handleClick} />

         {assumptions }
         {fields}
       </div>
     );
   }
 });

 var AssumptionBox = React.createClass({
   render: function(){
     if (typeof this.props.fields == "undefined"){
       return null;
     }

     // Render when there is assumptions
     var fields = this.props.fields.map(function(field){
       var value = parseFloat(field.value).toFixed(2);
       var dollar = (typeof field.unit=="undefined" || field.unit =="$")?"$":"";
       var negativeHighlight = value >= 0 ? "": "myhighlight";
       var pcnt = (field.unit=="%" || field.unit=="month") ?field.unit: "";

       return (
         <tr><td>
           {field.label}
         </td><td>
           <span className={negativeHighlight}>
             {dollar}{value}{pcnt}
           </span>
         </td></tr>
       );
     });

     var id = randomId();
     return (
       <div>
         <h6 className="myhighlight nocount">
           Assumptions
         </h6>
         <table className="table bordered striped highlgiht">
           <tbody>
             <tr>
               <th>Item</th>
               <th>Value</th>
             </tr>
             {fields}
           </tbody>
         </table>
       </div>
     );
   }
 });

 var PieChartBox = React.createClass({
   //Destroy chart before unmount.
   componentWillUnmount: function () {
     this.chart.destroy();
   },

   //Create the div which the chart will be rendered to.
   render: function () {
     var data = this.props.data;
     var currentValue = data && data.valueOf();
     if (this.preValue !== currentValue){
       this.preValue = currentValue;

       // Update chart
       if (this.chart && this.debounceUpdateData){
         this.debounceUpdateData(data);
       }
     }
     this.container = this.props.title.replace(/\s/g,"-").toLowerCase();
     return React.createElement('div', {
       id: this.container
     });
   },
   componentDidMount: function () {
     this.chart = Highcharts.chart(this.container, {
       chart: {
         plotBackgroundColor: null,
         plotBorderWidth: 0,
         plotShadow: false
       },
       title: {
         text: this.props.title,
         align: 'center',
         verticalAlign: 'top',
         y: 25
       },
       tooltip: {
         pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>'
       },
       plotOptions: {
         pie: {
           dataLabels: {
             enabled: true,
             format: '<b>{point.percentage:.0f}%</b>'
           },
           startAngle: -90,
           endAngle: 90,
           center: ['50%', '85%'],
           showInLegend: true
         }
       },
       series: [{
         type: 'pie',
         name: this.props.title,
         innerSize: '50%',
         data: this.props.data
       }]
     }); // end of highcharts

     // Set up debound function
     this.debounceUpdateData = _.debounce(function(data){
       this.chart.series[0].setData(data);
     },500);

   }// end of func
 });

 var ChartBox = React.createClass({
   render: function() {
     if (typeof this.props.data == "undefined"){
       return null;
     }

     var charts = this.props.data.map(function(field) {
       return <PieChartBox key={field.title} {...field} />
     }, this);

     return (
       <div className="my-multicol-2">
       {charts}
       </div>
     );
   }
 });

 var CarLeasingCalculatorBox = React.createClass({
   getInitialState: function() {
     var tmp = {
       "example msrp": {
         label: "Example MSRP",
         value: 18881,
         step: 1000
       },
       "example residue": {
         label: "example residue price",
         value: 13270,
         step: 1000
       },
       "msrp": {
         label: "MSRP",
         value: 25375,
         step: 1000
       },
       "invoice": {
         label: "Invoice",
         value: 24440,
         step: 1000
       },
       "purchase": {
         label: "Purchase",
         value: 23000,
         step: 1000
       },
       "lease": {
         label: "Lease price",
         value: 21287,
         step: 1000
       },
       "sales tax": {
         label: "Sales tax",
         value: 6,
         unit: "%",
         max: 10
       },
       "msd mf discount": {
         label: "MSD MF Discount",
         value: 0.00007,
         unit: "",
         step: 0.00001
       },
       "max msd allowed": {
         label: "Max MSD allowed",
         value: 7,
         unit: "",
         max: 10
       },
       "msd selected": {
         label: "MSD selected",
         value: 7,
         unit: ""
       },
       "apr": {
         label: "APR",
         value: 4,
         unit: "%",
         max: 40
       },
       term: {
         label: "Term",
         value: 36,
         unit: "month",
         step: 12,
         min: 12,
         max: 60
       },
       "downpayment": {
         label: "Downpayment",
         value: 2000,
         step: 100
       },
       "rebates": {
         label: "Rebates",
         value: 0,
         step: 1000
       },
       "credits": {
         label: "Credits",
         value: 0,
         step: 1000
       },
       "monthly tax": {
         label: "Monthly tax",
         value: 3,
         unit: "%",
         max: 10
       },
       "registration fee": {
         label: "Registration fee",
         value: 40
       },
       "plate fee": {
         label: "Plate fee",
         value: 28
       },
       "documentation fee": {
         label: "Documentation fee",
         value: 550
       },
       "acquisition fee": {
         label: "Acquisition fee",
         value: 995
       },
       "security deposit": {
         label: "Security deposit",
         value: 0,
         step: 1000
       },
       "security refund rate": {
         label: "Security refund rate",
         value: 20,
         unit: "%",
         max: 100,
         step: 10
       },
       "disposition fee": {
         label: "Disposition fee",
         value: 350
       },
       "wear charge": {
         label: "Wear charge",
         value: 0
       }
     }; // end of initial state
     return tmp;
   },
   handleFieldChange: function(fieldId, value) {
     var newState = this.state[fieldId];
     newState.value = parseFloat(value); // convert to Float
     this.setState(newState);
   },

   getFields: function(pickList){
     var tmpList = [];
     for (var i=0; i<pickList.length; i++){
       var tmp = this.state[pickList[i]];
       tmp.name = pickList[i];

       if (typeof tmp.value  == "undefined"){
         tmp.value = 0;
       }
       if (typeof tmp.unit == "undefined"){
         tmp.unit = "$";
       }
       tmpList.push(tmp);
     }
     return tmpList;
   },
   getDiscount: function(field1, field2){
     var val1 = this.state[field1].value;
     var val2 = this.state[field2].value;
     var discount = (val2-val1)/val2*100;
     return discount.toFixed(2);
   },
   render: function(){
     var helper = {
       getFields: this.getFields,
       getDiscount: this.getDiscount
     };

     // example residue form
     var residue_rate = 100-helper.getDiscount("example residue", "example msrp");
     var exampleLeaseForm = {
       title: "Official leasing sample",
       fields: helper.getFields(["example msrp", "example residue"]),
       assumptions: [{
         label: "Residue percentage",
         value: residue_rate,
         unit: "%"
       }]
     };

     // Deal terms
     var apr_as_mf = this.state["apr"].value/2400;
     var residue_value = this.state["msrp"].value * residue_rate/100;
     var sales_tax = this.state["lease"].value * this.state["sales tax"].value/100;
     var lease_after_tax = this.state["lease"].value + sales_tax;

     var dealTermForm = {
       title: "Deal terms",
       fields: helper.getFields([
         "msrp", "invoice", "lease","apr","term","monthly tax","sales tax"
       ]),
       assumptions: [{
         label: "Invoice discount by MSRP",
         value: helper.getDiscount("invoice","msrp"),
         unit: "%"
       },{
         label: "Lease discount by MSRP",
         value: helper.getDiscount("lease","msrp"),
         unit: "%"
       },{
         label: "Lease discount by invoice",
         value: helper.getDiscount("lease","invoice"),
         unit: "%"
       },{
         label: "Deal APR as MF",
         value: apr_as_mf,
         unit: ""
       },{
         label: "Residue value",
         value: residue_value
       },{
         label: "Lease after tax",
         value: lease_after_tax
       },{
         label: "Sales tax",
         value: sales_tax
       }]
     };

     // Deductions
     var apr = this.state["apr"].value;
     var msd_discount = this.state["msd mf discount"].value;
     var msd_selected = this.state["msd selected"].value;
     var msd_discount_equivalent = msd_discount*msd_selected*2400;
     var effective_apr = apr-msd_discount_equivalent;

     var deductionForm = {
       title: "Deductions",
       fields: helper.getFields([
         "credits", "rebates", "downpayment",
         "msd mf discount", "msd selected"
       ]),
       assumptions: [{
         label: "Effiective APR",
         value: effective_apr,
         unit: "%"
       },{
         label: "MSD equivalent discoiunt",
         value: msd_discount_equivalent,
         unit: "%"
       }]
     };

     // Monthly costs
     var depreciation_cost = this.state['lease'].value - residue_value;
     var monthly_depreciation_cost = depreciation_cost/this.state["term"].value;
     var net_capitalized_cost = lease_after_tax - (
       this.state["credits"].value +
       this.state["rebates"].value +
       this.state["downpayment"].value
     );
     var financing_cost = net_capitalized_cost+residue_value;
     var monthly_financing_cost = financing_cost * effective_apr/2400;
     var monthly_cost_before_tax = monthly_depreciation_cost + monthly_financing_cost;
     var monthly_tax = monthly_cost_before_tax * this.state["monthly tax"].value/100;
     var monthly_cost_after_tax = monthly_cost_before_tax + monthly_tax;
     var total_tax = sales_tax + this.state["term"].value * monthly_tax;
     var msd = Math.ceil(monthly_cost_after_tax/50)*50;
     var total_msd = this.state["msd selected"].value * msd;

     var monthlyCostForm = {
       title: "Monthly costs",
       values: [{
         label: "Depreciation cost",
         value: monthly_depreciation_cost
       },{
         label: "Financing cost",
         value: monthly_financing_cost
       },{
         label: "Monthly tax",
         value: monthly_tax
       },{
         label: "Monthly leasing cost",
         value: monthly_cost_after_tax
       }],
       assumptions: [{
         label: "Net capitalized cost",
         value: net_capitalized_cost
       },{
         label: "Total depreciation",
         value: depreciation_cost
       },{
         label: "MSD",
         value: msd
       },{
         label: "Total tax",
         value: total_tax
       }]
     };

     // Due at signing
     var to_gov = this.state["registration fee"].value + this.state["plate fee"].value;
     var to_dealer = this.state["documentation fee"].value + this.state["security deposit"].value;
     var to_bank = this.state["acquisition fee"].value;
     var to_myself = this.state["downpayment"].value + total_msd + monthly_cost_after_tax;
     var driveoff_cost = to_gov + to_dealer + to_bank + to_myself;
     var driveOffForm = {
       title: "Due at signing",
       fields: helper.getFields([
         "registration fee", "plate fee", "documentation fee",
         "acquisition fee", "security deposit"
       ]),
       values: [{
         label: "Downpayment",
         value: this.state["downpayment"].value
       },{
         label: "1st month payment",
         value: monthly_cost_after_tax
       }],
       assumptions: [{
         label: "Drive off cost",
         value: driveoff_cost
       },{
         label: "Government administration fee",
         value: to_gov
       },{
         label: "Dealer fees",
         value: to_dealer
       },{
         label: "Bank fees",
         value: to_bank
       },{
         label: "Used to payoff the deal",
         value: to_myself
       }]
     };

     // Due at lease end
     var security_refund = this.state["security deposit"].value * this.state["security refund rate"].value / 100;
     var refund = security_refund + total_msd;
     var lease_end_cost = this.state["disposition fee"].value +
                          this.state["wear charge"].value - refund + monthly_cost_after_tax;
     var leaseEndForm = {
       title: "Due at lease end",
       fields: helper.getFields([
         "disposition fee", "security refund rate", "wear charge"
       ]),
       values:[{
         label: "Security refund",
         value: security_refund
       },{
         label: "MSD refund",
         value: total_msd
       }],
       assumptions:[{
         label: "Lease end cost",
         value: lease_end_cost
       }]
     };

     // Summaries
     var lease_payments = (this.state["term"].value-2)*monthly_cost_after_tax;
     var cost_of_ownership = driveoff_cost + lease_end_cost + lease_payments;
     var summaryList = [{
       label: "Total lease",
       value: lease_after_tax
     },{
       label: "Monthly payment",
       value: monthly_cost_after_tax
     },{
       label: "APR",
       value: this.state["apr"].value,
       unit: this.state["apr"].unit
     },{
       label: "Term",
       value: this.state["term"].value,
       unit: this.state["term"].unit
     },{
       label: "Cost of ownership",
       value: cost_of_ownership
     },{
       label: "Drive off cost",
       value: driveoff_cost
     },{
       label: "Last payment/refund",
       value: lease_end_cost
     }];

     // Monthly payment breakdown chart
     var chartData = [{
       title: "Monthly payment breakdown",
       data: [{
         name: "Depreciation cost",
         y: monthly_depreciation_cost
       },{
         name: "Financing cost",
         y: monthly_financing_cost
       },{
         name: "Tax",
         y: monthly_tax
       }]
     },{
       title: "Cost of ownership",
       data: [{
         name: "Drive off cost",
         y: driveoff_cost
       },{
         name: "Lease payments",
         y: lease_payments
       },{
         name: "Lease end",
         y: lease_end_cost
       }]
     }];

     // Render
     return (
       <div>
       <Summary data={summaryList} />
       <ChartBox data={chartData} />
       <FormBox data={exampleLeaseForm} onChange={this.handleFieldChange} />
       <FormBox data={dealTermForm} onChange={this.handleFieldChange} />
       <FormBox data={deductionForm} onChange={this.handleFieldChange} />
       <FormBox data={monthlyCostForm} />
       <FormBox data={driveOffForm} onChange={this.handleFieldChange} />
       <FormBox data={leaseEndForm} onChange={this.handleFieldChange} />
       </div>
     );
   }
 });

 ReactDOM.render(
   <CarLeasingCalculatorBox />,
   document.getElementById("sth")
 );

</script>
