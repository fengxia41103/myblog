Title: Quote of the day
Tags: quote
Slug: quote of the day
Author: Feng Xia

<div id="quote"></div>
<div id="d3"></div>

<script type="text/babel">

var QuoteBox = React.createClass({
    getInitialState: function(){
        return {
            quote: null,
            img: null
        }
    },
    componentDidMount: function(){
        this.setImage();
    },
    setImage: function(){
        // Spinner
        this.setState({
            loading: true
        });

        // AJAX
        var that = this;
        var min = 1, max = 1743; // 1743 is from manual testing
        var id = Math.floor(Math.random()*(max-min)+min);
        var apiUrl = "http://dynamic.xkcd.com/api-0/jsonp/comic/"+id;
        j$.ajax({
            url: apiUrl,
            dataType:"jsonp",
            method: "GET",
            success: function(data){
                that.setState({
                    quote: data.title,
                    img: data.img,
                    loading: false
                });
            }
        });
    },
    render: function(){
        return (
            <div>
                <figure>
                    <img src={this.state.img} className="center-block img-responsive" />
                    <figcaption>
                        {this.state.quote}
                        <span className="flabel"
                        onClick={this.setImage}
                        style={{marginLeft:"1em", float:"none"}}>
                            <i className="fa"
                                className={this.state.loading? "fa-spinner":"fa-angle-right"}
                            style={{paddingLeft:"1em",marginRight:"1em"}}></i>
                            more
                        </span>
                    </figcaption>
                </figure>
            </div>
        );
    }
});
ReactDOM.render(
    <QuoteBox />,
    document.getElementById("quote")
);

var CrimeGraph = React.createClass({
    makeViz: function(data){
        var id = "#"+this.props.id;
        var visualization = d3plus.viz()
            .container(id)
            .data(data)
            .type("tree_map")
            .id("State")
            .size("Assault")
            .time({
                "value": "Year",
                "solo": 2012
            })
            .draw();
    },
    componentDidMount: function(){
        var that = this;
        var dataUrl = "/data/state_crime.tsv";
        d3.tsv(dataUrl, function(error, state_crime) {
            if (error) return console.error(error);

            // Coerce data values to be numeric
            state_crime.forEach(function(d) {
                d3.keys(d).forEach(function(k) {
                    if (k != "State") {
                        d[k] = +d[k]
                    }
                    if (k != "State" && k != "Population" && k != "Year") {
                        d[k] = d[k] / d['Population']
                    }

                })
            });

            // Filter out US total values
            state_crime = state_crime.filter(function(d) {
                return d.State != "United States-Total"
            });

            // Draw graph
            that.makeViz(state_crime);
        });
    },
    render: function(){
        return (
            <figure id={this.props.id} style={{minHeight:"500px"}}>
                <figcaption>State crime data</figcaption>
            </figure>
        );
    }
});
ReactDOM.render(
    <CrimeGraph id="crime"/>,
    document.getElementById("d3")
);

</script>
