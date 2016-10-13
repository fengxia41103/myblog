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
            countries: [],
            index: "A",
            loading: true
        }
    },
    componentWillMount: function(){
        var that = this;
        var apiUrl= "http://api.dhsprogram.com/rest/dhs/countries?returnFields=CountryName,DHS_CountryCode&f=json";

        // Get data
        j$.ajax({
            url: apiUrl,
            dataType: "json",
            method: "GET",
            success: function(resp){
                if ((typeof resp != "undefined") && resp){
                    that.setState({
                        countries: resp.Data,
                        loading: false
                    });
                }
            } // end of success
        });
    },
    setIndex: function(letter){
        this.setState({
            index: letter
        });
    },
    render: function(){
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
        return (
            <div className="page-header">
                {this.state.loading?
                    <i className="fa fa-spinner">Loading</i>
                : null}
                <ul className="list-inline">
                    {index}
                </ul>
                <CountryAlphabeticList
                    letter={this.state.index}
                    countries={this.state.countries}
                    setCountry={this.props.setCountry} />
            </div>
        );
    }
});

var RootBox = React.createClass({
    getInitialState: function(){
        return {
            countryCode: null,
            graphs: [{
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
        var graphs = this.state.graphs.map(function(g){
            var id = randomId();
            return (
                <D3GraphContainer
                    key={id}
                    countryCode={countryCode}
                    {...g}
                />
            );
        });
        return (
            <div>
                <CountryBox setCountry={this.setCountry} />
                {graphs}
            </div>
        );
    }
});

var D3GraphContainer = React.createClass({
    getInitialState: function(){
        return {
            countryCode: "",
            data: []
        }
    },
    getData:function(countryCode, indicators){
        // Set up URL
        var that = this;
        var baseUrl = "http://api.dhsprogram.com/rest/dhs/v4/data?";
        var queries = {
            "countryIds": countryCode,
            "indicatorIds": indicators.join(",")
        };
        var tmp = [];
        for (var key in queries){
            var val = queries[key];
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
                        data: resp.Data,
                        countryCode: countryCode
                    });
                }
            } // end of success
        });
    },
    componentWillMount: function(){
        this.debounceGetData = _.debounce(function(countryCode, indicators){
            this.getData(countryCode, indicators);
        }, 500);
     },
    render: function(){
        // Update data if country code has changed
        if (this.props.countryCode && !_.isEqual(this.state.countryCode, this.props.countryCode)){
            this.debounceGetData(this.props.countryCode, this.props.indicators);
        }

        // Render graph
        if (this.props.type === "bar" && this.state.data.length){
            // container id
            var containerId = randomId();
            return (
                <div className="page-header">
                    <h3>
                        {this.props.countryCode}
                    </h3>
                    <D3GraphBox containerId={containerId}
                        data={this.state.data}
                        title={this.props.title}
                        type={this.props.type} />
                </div>
            );
        } else if (this.props.type === "pie" && this.state.data.length){
            var graphs = [];
            var data = this.state.data;

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
            for (year in tmp){
                var containerId = randomId();
                var title= [this.props.title, year].join(" -- ");

                graphs.push(
                <div key={randomId()} style={{display:"inline-block"}}>
                    <h3>
                        {this.props.countryCode}
                    </h3>
                    <D3GraphBox containerId={containerId}
                        data={tmp[year]}
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

var D3GraphBox = React.createClass({
    getInitialState: function(){
        return {
            prevData: []
        }
    },
    cleanData:function(data){
        var tmp = data.slice(); // make a copy
        for (var i = 0; i<data.length; i++){
            tmp[i].SurveyYear = ""+tmp[i].SurveyYear;
        }
        return tmp;
    },
    makeViz: function(data){
        this.viz = d3plus.viz().container("#"+this.props.containerId)
            .data(this.cleanData(data))
            .type(this.props.type.toLowerCase())
            .id("Indicator")
            .color("Indicator")
            .text("Indicator")
            .y("Value")
            .x("SurveyYear")
            .size("Value")
            .draw();
    },
    componentDidMount: function(){
        // Initialize graph
        this.makeViz(this.props.data);

        // Set up data updater
        var that = this;
        this.debounceUpdate = _.debounce(function(data){
            that.viz.data(this.cleanData(data));
            that.viz.draw();
            // Save data
            that.setState({
                prevData: data
            });
        }, 200);
    },
    render: function(){
        // Update graph only when data has changed
        if (this.viz && !_.isEqual(this.state.prevData, this.props.data)){
            this.debounceUpdate(this.props.data);
        }
        return (
            <figure id={this.props.containerId} style={{minHeight:"500px"}}>
                <figcaption>{this.props.title}</figcaption>
            </figure>
        );
    }
});



ReactDOM.render(
    <RootBox />,
    document.getElementById("dhs")
);
</script>
