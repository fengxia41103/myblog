Title: 夏雷
Tags: Lei
Slug: lei
Author: Feng Xia

<div id="sth"></div>

<script type="text/babel">

        var images = [];
        for (var i=1; i<101; i++){
            var pad = "0000";
            var str = ""+i;
            var name = pad.substring(0, pad.length - str.length) + str;
            images.push({
                key: name,
                thumb: "/images/memory/IMG_"+name+"-small.jpg",
                full: "/images/memory/IMG_"+name+".jpg"
            });
        }

var OneBox = React.createClass({
    render: function(){
        return(
            <div className="pin-card" style={{backgroundColor:"#1e1e1f"}}>
                <img src={this.props.image.full} className="center-block img-responsive"/>
                <h3 style={{color:"white"}}>I miss you very much.</h3>
            </div>
        );
    }
});

var ImageField = React.createClass({
    render: function(){
        var img = this.props.img;

        return (
            <div style={{display:"block"}} key={img.key}>
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
            showing: this.props.images[0]
        }
    },
    setImage: function(img){
        this.setState({
            showing: img
        });
    },
    componentDidMount: function(){
    },
    render: function(){
        var imageFields = this.props.images.map(function(img){
            return (
                <ImageField img={img} onClick={this.setImage} />
            );
        }, this);
        return (
            <div>
                <OneBox image={this.state.showing} />
                <div className="my-multicol-4 grid">
                    {imageFields}
                </div>
            </div>
        );
    }
});

ReactDOM.render(
  <PresentationBox images={images} />,
  document.getElementById("sth")
);
</script>
