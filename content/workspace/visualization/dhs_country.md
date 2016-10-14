Title: DHS data set by Country
Date: 2016-10-15 11:00
Category: REACT
Tags: dhs, react
Slug: dhs by cuontry
Author: Feng Xia

[DHS][] data set is published by [US AID][]. Following its [API][]
documents, this page is a prototype that
uses data from selected [indicators][]
to draw a picture of a given country.  Considering the massive
amount of [indicators][] available, it is an opportunity
to build visual presentation of these data. As a prototype,
I am starting with only a few KPIs. The list will continue
to grow as I gain more insights of the dataset and its meanings.
Note that a KPI will be
omitted if there is no data in [DHS][] database.

[dhs]: http://dhsprogram.com/data/
[us aid]: https://www.usaid.gov/
[api]: http://api.dhsprogram.com/#/index.html
[indicators]: http://api.dhsprogram.com/#/api-indicators.cfm

<div id="dhs"></div>

<script type="text/babel">

var randomId = function(){
    return "DHS"+(Math.random()*1e32).toString(12);
};

//****************************************
//
//    Common AJAX containers
//
//****************************************
var AjaxContainer = React.createClass({
    getInitialState: function(){
        return {
            loading: false
        }
    },
    getData: function(){
        if (this.state.loading){
            return null;
        }else{
            this.setState({
                loading: true
            });
        }

        // Get data
        var that = this;
        var handleUpdate = this.props.handleUpdate;
        console.log("getting: "+this.props.apiUrl);

        j$.ajax({
            url: this.props.apiUrl,
            dataType: "json",
            method: "GET",
            success: function(resp){
                if ((typeof resp != "undefined") && resp){
                    handleUpdate(resp);
                }
            } // end of success
        });
    },
    componentWillMount: function(){
        this.debounceGetData = _.debounce(function(){
            this.getData();
        }, 500);
    },
    render: function(){
        // Get data
        if (!this.state.loading && this.debounceGetData){
            this.debounceGetData();
        }
        return null;
    }
});

//****************************************
//
//    Common graph containers
//
//****************************************
var GraphFactory = React.createClass({
    render: function(){
        // Validate data set
        if (this.props.data.length === "undefined" || this.props.data.length < 1){
            return null;
        }

        // Render graph by chart type
        if (this.props.type === "bar"){
            // container id
            var containerId = randomId();
            return (
                <div className="page-header">
                    <h3>
                        {this.props.countryCode}
                    </h3>
                    <GraphBox containerId={containerId}
                        data={this.props.data}
                        d3config={this.props.d3config.default}
                        title={this.props.title}
                        type={this.props.type} />
                </div>
            );
        } else if (this.props.type === "line"){
            // container id
            var containerId = randomId();
            return (
                <div className="page-header">
                    <h3>
                        {this.props.countryCode}
                    </h3>
                    <GraphBox containerId={containerId}
                        data={this.props.data}
                        d3config={this.props.d3config.line}
                        title={this.props.title}
                        type={this.props.type} />
                </div>
            );
        } else if (this.props.type === "pie"){
            var graphs = [];
            var data = this.props.data;

            // Regroup by year
            var tmp = {};
            for (var i=0; i<data.length;i++){
                var year = data[i].SurveyYear;
                if (tmp.hasOwnProperty(year)){
                    tmp[year].push(data[i])
                } else{
                    tmp[year] = [data[i]];
                }
            }

            // One pie chart per year's data
            for (year in tmp){
                var containerId = randomId();
                var title= [this.props.title, year].join(" -- ");

                graphs.push(
                    <div key={randomId()} style={{display:"inline-block"}}>
                        <h3>
                            {this.props.countryCode}
                        </h3>
                        <GraphBox containerId={containerId}
                            data={tmp[year]}
                            d3config={this.props.d3config.default}
                            title={title}
                            type={this.props.type} />
                    </div>
                );
            }
            return (
                <div className="row my-multicol-2 page-header">
                    {graphs}
                </div>
            );
        }

        // Default
        return null;
    }
});

var GraphBox = React.createClass({
    makeViz: function(data){
        this.viz = d3plus.viz()
            .container("#"+this.props.containerId)
            .config(this.props.d3config)
            .data(this.props.data)
            .type(this.props.type)
            .draw();
    },
    componentDidMount: function(){
        // Initialize graph
        this.makeViz(this.props.data);

        // Set up data updater
        var that = this;
        this.debounceUpdate = _.debounce(function(data){
            that.viz.data(data);
            that.viz.draw();
        }, 500);
    },
    render: function(){
        // If data changed
        var currentValue = this.props.data && this.props.data.valueOf();
        if (currentValue != null && this.preValue !== currentValue){
            this.preValue = currentValue;

            // Update graph data
            if (this.viz && this.debounceUpdate){
                this.debounceUpdate(this.props.data);
            }
        }

        return (
            <figure id={this.props.containerId} style={{minHeight:"500px"}}>
                <figcaption>{this.props.title}</figcaption>
            </figure>
        );
    }
});


//****************************************
//
//    Application containers
//
//****************************************
var CountryAlphabeticList = React.createClass({
    render: function(){
        var letter = this.props.letter;
        var setCountry = this.props.setCountry;
        var fields = this.props.countries.map(function(c){
            if (c.CountryName.startsWith(letter) || letter.toLowerCase()=="all"){
                return (
                    <li key={c.DHS_CountryCode} style={{marginTop:"0.7em"}}>
                    <button className="btn btn-default"
                        onClick={setCountry.bind(null,c.DHS_CountryCode)}
                    >
                        {c.CountryName} ({c.DHS_CountryCode})
                    </button>
                    </li>
                );
            }
        });

        return (
            <div>
                <h3>{this.props.letter}</h3>
                <ul className="list-inline">
                    {fields}
                </ul>
            </div>
        );
    }
});

var CountryBox = React.createClass({
    getInitialState: function(){
        return {
            data: [],
            index: "A"
        }
    },
    handleUpdate: function(data){
        // Save response data
        this.setState({
            data: data.Data
        });
    },
    getUrl: function(){
        var api = "http://api.dhsprogram.com/rest/dhs/countries";
        return api;
    },
    setIndex: function(letter){
        this.setState({
            index: letter
        });
    },
    render: function(){
        // Build A-Z index
        var alphabet = "abcdefghijklmnopqrstuvwxyz".toUpperCase().split("");
        alphabet.unshift("All");
        var current = this.state.index;
        var setIndex = this.setIndex;
        var index = alphabet.map(function(letter){
            var highlight = current==letter?"myhighlight":"";
            return (
                <li key={letter} onClick={setIndex.bind(null,letter)}>
                    <a className={highlight}>{letter}</a>
                </li>
            );
        });

        // Update data
        if (this.state.data=="undefined" || this.state.data.length < 1){
            var api = this.getUrl();
            return (
                <AjaxContainer
                    apiUrl={api}
                    handleUpdate={this.handleUpdate} />
            );
        }

        // Render
        return (
            <div className="page-header">
                <ul className="list-inline">
                    {index}
                </ul>
                <CountryAlphabeticList
                    letter={current}
                    countries={this.state.data}
                    setCountry={this.props.setCountry} />
            </div>
        );
    }
});


var DhsGraphContainer = React.createClass({
    getInitialState: function(){
        return {
            data: [],
            // graph config, mostly to define based on
            // data structure saved in "data" so the graph
            // knows which property stands for what
            d3config: {
                "default": {
                    "id": "Indicator",
                    "color": "Indicator",
                    "text": "Indicator",
                    "y": "Value",
                    "x": "SurveyYear",
                    "time": "SurveyYear",
                    "size": "Value",
                    "footer": {
                        position: "top",
                        value: "Data source: USAID DHS Program"
                    }
                },
                "line": {
                    "id": "",
                    "text": "Indicator",
                    "y": "Value",
                    "x": "SurveyYear",
                    "footer": {
                        position: "top",
                        value: "Data source: USAID DHS Program"
                    }
                }
            }
        }
    },
    getUrl: function(countryCode, indicators){
        // Build DHS API url
        var baseUrl = "http://api.dhsprogram.com/rest/dhs/v4/data?";
        var queries = {
            "countryIds": countryCode,
            "indicatorIds": indicators.join(","),
            "perpage": 1000, // max for non-registered user

            // return fields must match what is being used in D3 graph
            "returnFields": ["Indicator","Value","SurveyYear"].join(",")
        };
        var tmp = [];
        for (var key in queries){
            var val = queries[key];
            if (val && (val.length > 0)){
                tmp.push(key + "=" + val);
            }
        }
        return baseUrl+tmp.join("&");
    },
    cleanData:function(data){
        if (typeof data === "undefined"){
            return [];
        }else {
            // Data needs to be massaged
            for (var i = 0; i<data.length; i++){
                data[i].SurveyYear = ""+data[i].SurveyYear;
            }
            return data;
        }

    },
    handleUpdate: function(data){
        this.setState({
            data: this.cleanData(data.Data)
        });
    },
    render: function(){
        // If country code changed, update data
        var changed = false;
        var currentValue = this.props.countryCode && this.props.countryCode.valueOf();
        if (currentValue != null && this.preValue !== currentValue){
            this.preValue = currentValue;
            var api = this.getUrl(this.props.countryCode, this.props.indicators);
            return (
                <AjaxContainer
                    handleUpdate={this.handleUpdate}
                    apiUrl={api} />
            );
        }

        // Render graphs
        return (
            <GraphFactory
                data={this.state.data}
                d3config={this.state.d3config}
                {...this.props}
            />
        );
    }
});

var WbGraphContainer = React.createClass({
    getInitialState: function(){
        return {
            data: [],
            d3config: {
                "default": {
                    "id": "date",
                    "color": "date",
                    "text": "date",
                    "time": "date",
                    "y": "value",
                    "x": "date",
                    "size": "value",
                    "footer": {
                        position: "top",
                        value: "Data source: The World Bank"
                    }
                },
                "line": {
                    "id": "country",
                    "text": "date",
                    "y": "value",
                    "x": "date",
                    "footer": {
                        position: "top",
                        value: "Data source: The World Bank"
                    }
                }
            }
        }
    },
    getUrl: function(countryCode, indicator){
        // Build DHS API url
        var baseUrl = "http://api.worldbank.org/countries/";
        var tmp = [countryCode, "indicators", indicator].join("/");
        var query = "?date=2000:2015&format=json";
        return baseUrl+tmp+query;
    },
    handleUpdate: function(data){
        this.setState({
            data: this.cleanData(data[1])
        });
    },
    cleanData:function(data){
        if (typeof data === "undefined"){
            return [];
        }else{
            for (var i = 0; i<data.length; i++){
                if (data[i].value !== null){
                    data[i].value = Math.round(parseFloat(data[i].value));
                }
            }
            return  _.sortBy(data, 'date');
        }
    },
    render: function(){
        // If country code changed, update data
        var changed = false;
        var currentValue = this.props.countryCode && this.props.countryCode.valueOf();
        if (currentValue != null && this.preValue !== currentValue){
            this.preValue = currentValue;
            var api = this.getUrl(this.props.countryCode, this.props.indicator);
            return (
                <AjaxContainer
                    handleUpdate={this.handleUpdate}
                    apiUrl={api} />
            );
        }

        // Render graphs
        return (
            <GraphFactory
                data={this.state.data}
                d3config={this.state.d3config}
                {...this.props}
            />
        );
    }
});

var RootBox = React.createClass({
    getInitialState: function(){
        return {
            countryCode: null,
            dhsGraphs: [{
                title: "Age-specific fertility rate for the three years preceding the survey, expressed per 1,000 women",
                indicators:[
                    "FE_FRTR_W_A15",
                    "FE_FRTR_W_A20",
                    "FE_FRTR_W_A25",
                    "FE_FRTR_W_A30",
                    "FE_FRTR_W_A35",
                    "FE_FRTR_W_A40",
                    "FE_FRTR_W_A45",
                ],
                type: "bar"
            },{
                title:"HIV prevalence among couples",
                indicators:[
                    "HA_HPAC_B_CPP",
                    "HA_HPAC_B_CPN",
                    "HA_HPAC_B_CNP",
                    "HA_HPAC_B_CNN"
                ],
                type: "pie"
            }],
            wbGraphs:[{
                title: "GNI per capita, Atlas method (current US$)",
                indicator: "NY.GNP.PCAP.CD",
                type: "bar"
            },{
                title: "GDP per capita (current US$)",
                indicator: "NY.GDP.PCAP.CD",
                type: "line"
            }]
        }
    },
    setCountry: function(code){
        this.setState({
            countryCode: code
        });
    },
    render: function(){
        var countryCode = this.state.countryCode;
        var dhs = this.state.dhsGraphs.map(function(g){
            var id = randomId();
            return (
                <DhsGraphContainer
                    key={id}
                    countryCode={countryCode}
                    {...g}
                />
            );
        });
        var wb = this.state.wbGraphs.map(function(g){
            var id = randomId();
            return (
                <WbGraphContainer
                    key={id}
                    countryCode={countryCode}
                    {...g}
                />
            );
        });

        return (
            <div>
                <CountryBox setCountry={this.setCountry} />
                {dhs}
                {wb}
            </div>
        );
    }
});

ReactDOM.render(
    <RootBox />,
    document.getElementById("dhs")
);
</script>
