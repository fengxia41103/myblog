Title: Country health (DHS & World Bank)
Date: 2016-10-15 11:00
Category: REACT
Tags: dhs, react
Slug: country heath
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

I'm also adding [The World Bank][] data set to
draw a better picture of the country interested. However,
[DHS][]'s country list is smaller than the World Bank's

[the world bank]: https://datahelpdesk.worldbank.org/knowledgebase/articles/898599-api-indicator-queries


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
        var data = this.props.data;

        // Validate data set
        if (typeof data == "undefined" || data === null || data.length == 0){
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
                        {...this.props}
                        d3config={this.props.d3config.default}/>
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
                        {...this.props}
                        data={data}
                        d3config={this.props.d3config.line}
                    />
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
                            {...this.props}
                            data={tmp[year]}
                            d3config={this.props.d3config.default}
                            title={title}/>
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
            if (c.iso2Code.startsWith(letter) || letter.toLowerCase()=="all"){
                return (
                    <li key={c.iso2Code} style={{marginTop:"0.7em"}}>
                    <button className="btn btn-default"
                        onClick={setCountry.bind(null,c.iso2Code)}
                    >
                        {c.name} ({c.iso2Code})
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
            data: data[1]
        });
    },
    getUrl: function(){
        //var api = "http://api.dhsprogram.com/rest/dhs/countries";
        var api = "http://api.worldbank.org/countries?format=json&per_page=1000";
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
                    "legend": false,
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
                    "time": "SurveyYear",
                    "shape": {
                        interpolate: "step"
                    },
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
        if (typeof data === "undefined" || data === null){
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
                    "legend": false,
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
                    "time": "date",
                    "shape": {
                        interpolate: "basis"
                    },
                    "legend": false,
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
        var query = "?date=1995:2015&format=json&per_page=1000";
        return baseUrl+tmp+query;
    },
    handleUpdate: function(data){
        this.setState({
            data: this.cleanData(data[1])
        });
    },
    cleanData:function(data){
        if (typeof data === "undefined" || data === null){
            return [];
        }else{
            var tmp = [];
            for (var i = 0; i<data.length; i++){
                if (data[i].value !== null){
                    data[i].value = parseFloat(data[i].value);
                    tmp.push(data[i]);
                }
            }
            return  _.sortBy(tmp, 'date');
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
                title: "Rural population (% of total population)",
                indicator: "SP.RUR.TOTL.ZS",
                type: "bar"
            },{
                title: "GNI per capita, Atlas method (current US$)",
                indicator: "NY.GNP.PCAP.CD",
                type: "bar"
            },{
                title: "Life expectancy at birth, total (years)",
                indicator: "SP.DYN.LE00.IN",
                type: "line"
            },{
                title: "Inflation, GDP deflator (annual %)",
                indicator: "NY.GDP.DEFL.KD.ZG",
                type: "bar"
            },{
                title: "Inflation, consumer prices (annual %)",
                indicator: "FP.CPI.TOTL.ZG",
                type: "bar"
            },{
                title: "Real interest rate (%)",
                indicator: "FR.INR.RINR",
                type: "line"
            },{
                title: "Fertility rate, total (births per woman)",
                indicator: "SP.DYN.TFRT.IN",
                type: "line"
            },{
                title: "Population ages 0-14 (% of total)",
                indicator: "SP.POP.0014.TO.ZS",
                type: "line"
            },{
                title: "Population ages 15-64 (% of total)",
                indicator: "SP.POP.1564.TO.ZS",
                type: "line"
            },{
                title: "Health expenditure, total (% of GDP)",
                indicator: "SH.XPD.TOTL.ZS",
                type: "bar"
            },{
                title: "Health expenditure per capita (current US$)",
                indicator: "SH.XPD.PCAP",
                type: "bar"
            },{
                title: "Urban population (% of total)",
                indicator: "SP.URB.TOTL.IN.ZS",
                type: "bar"
            },{
                title: "Population living in slums, (% of urban population)",
                indicator: "EN.POP.SLUM.UR.ZS",
                type: "bar"
            },{
                title: "Revenue, excluding grants (% of GDP)",
                indicator: "GC.REV.XGRT.GD.ZS",
                type: "bar"
            },{
                title: "External debt stocks, public and publicly guaranteed (PPG) (DOD, current US$)",
                indicator: "DT.DOD.DPPG.CD",
                type: "line"
            },{
                title: "Bank nonperforming loans to total gross loans (%)",
                indicator: "FB.AST.NPER.ZS",
                type: "bar"
            },{
                title: "Bank capital to assets ratio (%)",
                indicator: "FB.BNK.CAPA.ZS",
                type: "bar"
            },{
                title: "Broad money growth (annual %)",
                indicator: "FM.LBL.BMNY.ZG",
                type: "line"
            },{
                title: "Merchandise trade (% of GDP)",
                indicator: "TG.VAL.TOTL.GD.ZS",
                type: "line"
            },{
                title: "Merchandise exports (current US$)",
                indicator: "TX.VAL.MRCH.CD.WT",
                type: "line"
            },{
                title: "Merchandise imports (current US$)",
                indicator: "TM.VAL.MRCH.CD.WT",
                type: "line"
            },{
                title: "High-technology exports (% of manufactured exports)",
                indicator: "TX.VAL.TECH.MF.ZS",
                type: "line"
            },{
                title: "Foreign direct investment, net inflows (BoP, current US$)",
                indicator: "BX.KLT.DINV.CD.WD",
                type: "line"
            },{
                title: "Stocks traded, total value (% of GDP)",
                indicator: "CM.MKT.TRAD.GD.ZS",
                type: "line"
            },{
                title: "Stocks traded, turnover ratio of domestic shares (%)",
                indicator: "CM.MKT.TRNR",
                type: "line"
            },{
                title: "Expense (% of GDP)",
                indicator: "GC.XPN.TOTL.GD.ZS",
                type: "line"
            },{
                title: "Tax revenue (% of GDP)",
                indicator: "GC.TAX.TOTL.GD.ZS",
                type: "line"
            },{
                title: "CO2 emissions (metric tons per capita)",
                indicator: "EN.ATM.CO2E.PC",
                type: "line"
            },{
                title: "Energy use (kg of oil equivalent per capita)",
                indicator: "EG.USE.PCAP.KG.OE",
                type: "line"
            },{
                title: "International tourism, expenditures (% of total imports)",
                indicator: "ST.INT.XPND.MP.ZS",
                type: "line"
            },{
                title: "International tourism, receipts (% of total exports)",
                indicator: "ST.INT.RCPT.XP.ZS",
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
