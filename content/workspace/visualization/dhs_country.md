Title: DHS data set by Country
Date: 2016-10-15 11:00
Category: REACT
Tags: dhs, react
Slug: dhs by cuontry
Author: Feng Xia
Summary: DHS data set visulization by country.

<div id="dhs"></div>

<script type="text/babel">

var CountryAlphabeticList = React.createClass({
    render: function(){
        var letter = this.props.letter;
        var setCountry = this.props.setCountry;
        var fields = this.props.countries.map(function(c){
            if (c.CountryName.startsWith(letter)){
                return (
                    <li key={c.DHS_CountryCode}>
                    <button className="btn btn-default"
                        onClick={setCountry.bind(null,c.DHS_CountryCode)}
                    >{c.CountryName}
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
        var current = this.state.index;
        var setIndex = this.setIndex;
        var index = alphabet.map(function(letter){
            var highlight = current==letter?"flabel myhighlight":"flabel";
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
            countryCode: null
        }
    },
    setCountry: function(code){
        this.setState({
            countryCode: code
        });
    },
    render: function(){
        return (
            <div>
                <CountryBox setCountry={this.setCountry} />
                <D3GraphContainer countryCode={this.state.countryCode} />
            </div>
        );
    }
});

var D3GraphContainer = React.createClass({
    getInitialState: function(){
        return {
            title: "Age-specific fertility rate for the three years preceding the survey, expressed per 1,000 women",
            countryCode: "",
            indicators:[
                "FE_FRTR_W_A15",
                "FE_FRTR_W_A20",
                "FE_FRTR_W_A25",
                "FE_FRTR_W_A30",
                "FE_FRTR_W_A35",
                "FE_FRTR_W_A40",
                "FE_FRTR_W_A45",
            ],
            data: [],
            loading: false
        }
    },
    getData:function(countryCode){
        // Protect from loading multiple times
        // and only when country code has changed
        if (this.state.loading && _.isEqual(countryCode,"")){
            return null;
        }

        // Set up URL
        var that = this;
        var baseUrl = "http://api.dhsprogram.com/rest/dhs/v4/data?";
        var queries = {
            "countryIds": countryCode,
            "indicatorIds": this.state.indicators.join(",")
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
                        countryCode: countryCode,
                        loading: false
                    });
                }
            } // end of success
        });
    },
    componentWillMount: function(){
        this.getData(this.props.countryCode);
        this.debounceGetData = _.debounce(function(countryCode){
            this.getData(countryCode);
        }, 1000);
    },
    render: function(){
        if (this.props.countryCode && !_.isEqual(this.state.countryCode, this.props.countryCode)){
            this.debounceGetData(this.props.countryCode);
        }
        return (
            <div>
                <h3>{this.props.countryCode}</h3>
                <D3GraphBar id="kjlsdjflsjf"
                    data={this.state.data}
                    title={this.state.title} />
            </div>
        );
    }
});

var D3GraphBar = React.createClass({
    getInitialState: function(){
        return {
            id: "DHS"+this.props.id,
            prevData: [],
            viz: null
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
        this.setState({
            viz: d3plus.viz().container("#"+this.state.id)
            .data(this.cleanData(data))
            .type("bar")
            .id("Indicator")
            .color("Indicator")
            .text("Indicator")
            .y("Value")
            .x("SurveyYear")
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



ReactDOM.render(
    <RootBox />,
    document.getElementById("dhs")
);
</script>
