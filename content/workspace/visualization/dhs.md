Title: DHS
Date: 2016-10-12 13:00
Category: REACT
Tags: demo, react
Slug: dhs
Author: Feng Xia
Status: Draft
Summary: DHS data set visulization using D3plus library. Inspired by DATA USA.


<div id="dhs"></div>

<script type="text/babel">

var FormInput = React.createClass({
    handleChange: function(event) {
        var text = event.target.value;
        this.props.onChange(this.props.id, text);
    },
    render: function(){
        var inputStyle = {
            float: "left"
        };

        return (
            <div className="row form-group my-nobreak">
                <span className="col-xs-6 col-form-label text-right">
                    {this.props.label}
                </span>
                <div className="col-xs-5 input-group" style={inputStyle}>
                    <input type="text" className="form-control"
                        value={this.props.value}
                        onChange={this.handleChange}/>
                </div>
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
                <div className="col-md-11">
                    <h4>{this.props.title}</h4>
                </div>
                <div  className="text-right col-md-1" data-toggle="tooltip" title="Click to expand and collapse">
                    <br />
                    <i className={switchClass}></i>
                </div>
            </div>
        );
    }
});

var FormBox = React.createClass({
    getInitialState: function(){
        return {
            showFields: true
        };
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
                return <FormInput key={field.label} {...field} />
            }, this);
        }
        var fields = this.state.showFields?
            <div className="my-multicol-2">{formFields}</div>: null;

        // Render
        return (
            <div>
                <FormHeader title={this.props.data.title} showFields={this.state.showFields} handleClick={this.handleClick} />
                <button className="btn btn-default"
                    onClick={this.props.onRedraw}>Graph</button>
                {fields}
            </div>
        );
    }
});

var D3GraphContainer = React.createClass({
    getInitialState: function(){
        return {
            title: "",
            data: [], // graph data
            dataId: null,
            redrawCounter: 0
        }
    },
    handleRedraw:function(){
        var that = this;
        var queries = this.props.data;
        var baseUrl = "http://api.dhsprogram.com/rest/dhs/v4/data?";
        var tmp = [];
        for (var key in queries){
            var val = queries[key].value;
            if (val && (val.length > 0)){
                tmp.push(key + "=" + val);
            }
        }
        var apiUrl = baseUrl+tmp.join("&");
        console.log(apiUrl);

        // Get data
        j$.ajax({
            url: apiUrl,
            dataType: "json",
            method: "GET",
            success: function(resp){
                if ((typeof resp != "undefined") && resp){
                    that.setState({
                        title: resp.Data[0].Indicator,
                        data: resp.Data,
                        dataId: resp.Data[0].IndicatorOrder,
                        redrawCounter: that.props.redraw
                    });
                }
            } // end of success
        });
    },
    render: function(){
        if (this.props.redraw > this.state.redrawCounter){
            this.handleRedraw();
        }
        return (
            <div>
                {this.state.dataId?
                    <D3Graph id={this.state.dataId}
                        data={this.state.data}
                        title={this.state.title} />
                    :null}
            </div>
        );
    }
});

var D3Graph = React.createClass({
    getInitialState: function(){
        return {
            id: "DHS"+this.props.id,
            prevData: [],
            viz: null
        }
    },
    cleanData:function(data){
        var tmp = data.slice();
        for (var i = 0; i<data.length; i++){
            tmp[i].SurveyYear = "" + tmp[i].SurveyYear;
        }
        return tmp;
    },
    makeViz: function(data){
        this.setState({
            viz: d3plus.viz().container("#"+this.state.id)
            .data(this.cleanData(data))
            .type("bar")
            .id("CountryName")
            .color("CountryName")
            .text("CountryName")
            .y("Value")
            .x("SurveyYear")
            //.shape({
            //    "interpolate": "basis"  // takes accepted values to change interpolation type
            //})
            .draw()
        });
        this.debounceUpdate = _.debounce(function(data){
            this.state.viz.data(this.cleanData(data));
            this.state.viz.draw();

            // Save data
            this.setState({
                prevData: data
            });
        }, 500);
    },
    componentDidMount: function(){
        this.setState({
            prevData: this.props.data
        });
        this.makeViz(this.props.data);
    },
    render: function(){
        if (this.state.viz && !_.isEqual(this.state.prevData, this.props.data)){
            this.debounceUpdate(this.props.data);
        }

        return (
            <figure id={this.state.id} style={{minHeight:"500px"}}>
                <figcaption>{this.props.title}</figcaption>
            </figure>
        );
    }
});

var DhsBox = React.createClass({
    getInitialState: function(){
        return {
            "countryIds": {
                label: "Country IDs",
                value: "KE"
            },
            "indicatorIds": {
                label: "Indicator IDs",
                value: "FE_FRTR_W_TFR"
            },
            "breakdown": {
                label: "Breakdown level",
                value: null
            },
            "surveyIds": {
                label: "Survey IDs",
                value: null
            },
            "surveyYear": {
                label: "Survey Year",
                value: null
            },
            counter: {
                redraw: 0
            }
        }; // end of initial state
    },
    getFields: function(pickList){
        var tmpList = [];
        for (var i=0; i<pickList.length; i++){
            var tmp = this.state[pickList[i]];
            tmp.name = pickList[i];

            if ((typeof tmp.value  == "undefined") || (!tmp.value)){
                tmp.value = ""; // default input value
            }
            tmpList.push(tmp);
        }
        return tmpList;
    },
    handleFieldChange: function(fieldId, value) {
        var newState = this.state[fieldId];
        newState.value = value;
        this.setState(newState);
    },
    handleRedraw: function(){
        var currentRedrawCounter = this.state.counter.redraw;
        this.setState({
            counter: {
                redraw: currentRedrawCounter+1 // increment counter
            }
        });
    },
    render: function(){
        var helper = {
            getFields: this.getFields
        };
        var dhsForm = {
            title: "DHS data set",
            fields: helper.getFields(["countryIds", "indicatorIds", "surveyYear"])
        };
        return (
            <div>
                <FormBox data={dhsForm}
                    onChange={this.handleFieldChange}
                    onRedraw={this.handleRedraw}
                />
                <D3GraphContainer
                    data={this.state}
                    redraw={this.state.counter.redraw}
                />
            </div>
        );
    }
});

ReactDOM.render(
    <DhsBox />,
    document.getElementById("dhs")
);
</script>
