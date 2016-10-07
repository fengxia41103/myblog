Title: 夏雷
Tags: Lei
Slug: lei
Author: Feng Xia

<div id="sth"></div>

<script type="text/babel">

var images = [];
for (var i=1; i<125; i++){
    var pad = "0000";
    var str = ""+i;
    var name = pad.substring(0, pad.length - str.length) + str;
    images.push({
        key: i,
        thumb: "/images/memory/"+name+"-small.jpg",
        full: "/images/memory/"+name+".jpg"
    });
}

var OneBox = React.createClass({
    render: function(){
        return(
            <div className="pin-card" style={{backgroundColor:"#1e1e1f", color:"#cecece", fontSize:"10pt"}}>
                <img src={this.props.image.full} className="center-block img-responsive" />
                <h3>
                    I miss you very much.
                </h3>
                <div className="row text-right">
                <span className="flabel">
                    <i className="fa fa-angle-left my-huge-font" style={{paddingRight:"1em"}}
                    onClick={this.props.prev}></i>
                </span>
                <span className="flabel pull-right">
                    <i className="fa fa-angle-right my-huge-font" style={{paddingLeft:"1em"}}
                    onClick={this.props.next}></i>
                </span>
                </div>

                { this.props.showMore?
                <div className="row text-right" id="showMore"
                    style={{marginTop:"2em",fontSize:""}}
                    onClick={this.props.onClick}>
                    <i className="fa fa-expand"></i>
                    Show more
                </div>
                :null }
            </div>
        );
    }
});

var ImageField = React.createClass({
    render: function(){
        var img = this.props.img;

        return (
            <div style={{display:"block"}}>
            <span onClick={this.props.onClick.bind(null,img)}>
                <img src={img.thumb} width="100%"/>
            </span>
            </div>
        );
    }
});

var PresentationBox = React.createClass({
    getInitialState: function(){
        return {
            showing: this.props.images[70],
            showMore: true
        }
    },
    handleImageFieldClick: function(img){
        this.setState({
            showing: img
        });

        // toggle show more
        this.toggleShowMore();
    },
    toggleShowMore: function(){
        this.setState({
            showMore: !this.state.showMore
        });
    },
    next: function(){
        var current = this.state.showing;
        var images = this.props.images;
        for(var i=0; i<images.length; i++){
            if (images[i].key===current.key){
                if (i== images.length-1){
                    // Circle back to beginning
                    this.setState({
                        showing: images[0]
                    });
                }else{ // set current to next
                    this.setState({
                        showing: images[i+1]
                    });
                }
                break;
            }
        }
    },
    prev: function(){
        var current = this.state.showing;
        var images = this.props.images;
        for(var i=0; i<images.length; i++){
            if (images[i].key===current.key){
                if (i== 0){
                    // Circle back
                    this.setState({
                        showing: images[images.length-1]
                    });
                }else{ // set current to next
                    this.setState({
                        showing: images[i-1]
                    });
                }
                break;
            }
        }
    },

    componentDidMount: function(){
    },
    render: function(){
        var imageFields = this.props.images.map(function(img){
            return (
                <ImageField img={img} onClick={this.handleImageFieldClick} key={img.key}/>
            );
        }, this);
        return (
            <div>
                { this.state.showMore?
                <OneBox image={this.state.showing} showMore={this.state.showMore}
                    onClick={this.toggleShowMore}
                    next={this.next}
                    prev={this.prev}
                />:
                <div className="my-multicol-4 grid">
                    {imageFields}
                </div>
                }
            </div>
        );
    }
});

ReactDOM.render(
  <PresentationBox images={images} />,
  document.getElementById("sth")
);
</script>
