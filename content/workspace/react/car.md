Title: Car leasing calculator in REACT
Date: 2016-09-30 13:00
Slug: car leasing calculator react
Category: REACT
Tag: REACT
Author: Feng Xia

<div id="sth"></div>

<script type="text/babel">

var Summary = React.createClass({
    render: function(){
        var divStyle = {
            backgroundColor: '#337ab7',
            padding: '0em 1em 1em 1em',
            color: '#efefef',
            marginBottom:'1em'
        };

        var summaryNodes = this.props.data.map(function(summary) {
          return (
            <SummaryList label={summary.label} value={summary.value} />
          );
        });

        return (
            <div className="row" style={divStyle}>
                <h4 className="page-header">Summary</h4>
                {summaryNodes}
           </div>
        );
    }
});

var SummaryList = React.createClass({
    render: function(){
        return (
            <div className="row">
                <div className="col-xs-6">
                    {this.props.label}
                </div>
                <div className="col-xs-6">
                    $ {this.props.value}
                </div>
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
            float: 'left'
        };
        var dollar = this.props.unit =='$'?
            <div className="input-group-addon">
                $
            </div> : '';
        var negativeHighlight = this.props.value > 0 ? '': "myhighlight";
        var pcnt = (this.props.unit=='%' || this.props.unit=='month') ?
            <div className="input-group-addon">
                {this.props.unit}
            </div> : '';

        return (
            <div className="row form-group">
                <span className="col-xs-6 col-form-label text-right">
                    {this.props.label}
                </span>
                <div className="col-xs-5 input-group" style={inputStyle}>
                    {dollar}
                    <input type="number" className="form-control {negativeHighlight}"
                        value={this.props.value}
                        onChange={this.handleChange}
                    />
                    {pcnt}
                </div>
            </div>
        );
    }
});

var FormHeader = React.createClass({
    render: function(){
        return (
            <div className="row my-resume-header">
                <div className="col-md-11">
                    <h4>{this.props.title}</h4>
                </div>
                <div  className="text-right col-md-1" data-toggle="tooltip" title="Click to expand and collapse">
                    <br />
                    <i className="fa fa-angle-double-down"></i>
                </div>
            </div>
        );
    }
});

var FormBox = React.createClass({
    render: function(){

        var formFields = this.props.data.fields.map(function(field) {
            var props = {
                id: field.name,
                onChange: this.props.onChange,
                value: field.value,
                label: field.label,
                type: field.unit
            };
            return <FormInput {...props} />
        }, this);

        return (
            <div>
                <FormHeader title={this.props.data.title} />
                <AssumptionBox fields={this.props.data.assumptions} />
                <div className="my-multicol-2">
                { formFields }
                </div>
            </div>
        );
    }
});

var AssumptionBox = React.createClass({
    render: function(){
        if (typeof this.props.fields == 'undefined'){
            return null;
        }
        // Render when there is assumptions

        var fields = this.props.fields.map(function(field){
            var dollar = field.unit =='$'?field.unit:'';
            var negativeHighlight = field.value > 0 ? '': "myhighlight";
            var pcnt = (field.unit=='%' || field.unit=='month') ?field.unit: '';

            return (
                <tr><td>
                    {dollar}
                    {field.label}
                </td><td>
                    <span className={negativeHighlight}>
                        {field.value}{pcnt}
                    </span>
                </td></tr>
            );
        });

        return (
            <div type="button" className="dropdown btn btn-link myhighlight" style={{"marginBottom":"1em"}}>
                <span className="dropdown-toggle" id={this.props.id} data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                    <i className="fa fa-flag"></i>
                    Assumptions
                    <span className="caret"></span>
                </span>
                <ul className="dropdown-menu" aria-labelledby={this.props.id} style={{'padding':'10px 20px'}}>
                    <table className="table table-striped table-hover table-responsive">
                        <tbody>
                            <tr>
                                <th>Item</th>
                                <th>Value</th>
                            </tr>
                            {fields}
                        </tbody>
                    </table>
                </ul>
            </div>
        );
    }
});

var CarLeasingCalculatorBox = React.createClass({
    getInitialState: function() {
        var tmp = {
            'example msrp': {
                label: 'Example MSRP',
                value: 18881
            },
            'example lease': {
                label: 'Example lease price',
                value: 13270
            },
            'msrp': {
                label: 'MSRP',
                value: 25375
            },
            'invoice': {
                label: 'Invoice',
                value: 24440
            },
            'purchase': {
                label: 'Purchase',
                value: 23000
            },
            'lease': {
                label: 'Lease price',
                value: 21287
            },
            'sales tax': {
                label: 'Sales tax',
                value: 6,
                unit: '%'
            },
            'msd mf discount': {
                label: 'MSD MF Discount',
                value: 0.00007,
                unit: ''
            },
            'max msd allowed': {
                label: 'Max MSD allowed',
                value: 7,
                unit: ''
            },
            'msd selected': {
                label: 'MSD selected',
                value: 0,
                unit: ''
            },
            'apr': {
                label: 'APR',
                value: 4,
                unit: '%'
            },
            term: {
                label: 'Term',
                value: 36,
                unit: 'month'
            },
            'downpayment': {
                label: 'Downpayment',
                value: 2000
            },
            'rebate': {
                label: 'Rebates',
                value: 0
            },
            'credits': {
                label: 'Credits',
                value: 0
            },
            'monthly tax': {
                label: 'Monthly tax',
                value: 3,
                unit: '%'
            },
            'registration fee': {
                label: 'Registration fee',
                value: 40
            },
            'plate fee': {
                label: 'Plate fee',
                value: 28
            },
            'documentation fee': {
                label: 'Documentation fee',
                value: 550
            },
            'acquisition fee': {
                label: 'Acquisition fee',
                value: 995
            },
            'security deposit': {
                label: 'Security deposit',
                value: 0
            },
            'security refund rate': {
                label: 'Security refund rate',
                value: 20,
                unit: '%'
            },
            'disposition fee': {
                label: 'Disposition fee',
                value: 350
            },
            'wear charge': {
                label: 'Wear charge',
                value: 0
            }
        }; // end of initial state
        return tmp;
    },
    handleFieldChange: function(fieldId, value) {
        var newState = this.state[fieldId];
        newState.value = value;
        this.setState(newState);
    },
    getSubsetState: function(pickList){
        var tmpList = [];
        for (var i=0; i<pickList.length; i++){
            var tmp = this.state[pickList[i]];
            tmp.name = pickList[i];

            if (typeof tmp.value  == 'undefined'){
                tmp.value = 0;
            }
            if (typeof tmp.unit == 'undefined'){
                tmp.unit = '$';
            }
            tmpList.push(tmp);
        }
        return tmpList;
    },
    computeDiscount: function(field1, field2){
        var val1 = this.state[field1].value;
        var val2 = this.state[field2].value;
        var discount = (val2-val1)/val2*100;
        return discount.toFixed(2);
    },
    render: function(){
        var summaryList = this.getSubsetState([
            'example msrp',
            'example lease'
        ]);

        var exampleLeaseForm = {
            title: 'Official leasing sample',
            fields: this.getSubsetState(['example msrp', 'example lease'])
        };
        var dealTermForm = {
            title: 'Deal terms',
            fields: this.getSubsetState(['msrp', 'invoice', 'lease','apr','term','monthly tax','sales tax']),
            assumptions: [{
                label: "Invoice discount by MSRP",
                value: this.computeDiscount('invoice','msrp'),
                unit: '%'
            },{
                label: "Lease discount by MSRP",
                value: this.computeDiscount('lease','msrp'),
                unit: '%'
            },{
                label: "Lease discount by invoice",
                value: this.computeDiscount('lease','invoice'),
                unit: '%'
            }]
        };
        return (
            <div>
                <Summary data={summaryList} />
                <FormBox data={exampleLeaseForm} onChange={this.handleFieldChange} />
                <FormBox data={dealTermForm} onChange={this.handleFieldChange} />
            </div>
        );
    }
});

ReactDOM.render(
  <CarLeasingCalculatorBox />,
  document.getElementById('sth')
);

</script>
