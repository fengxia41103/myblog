Title: 夏雷
Tags: Lei
Slug: lei
Author: Feng Xia

<div class="jumbotron">
I miss you very much.
</div>

<div id="sth"></div>

<script type="text/babel">
var PresentationBox = React.createClass({
    componentDidMount: function(){
    },
    render: function(){
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

        var imageFields = images.map(function(img){
            return (
                <a href={img.full} key={img.key}>
                    <img src={img.thumb} width="100%"/>
                </a>
            );
        });
        return (
            <div className="my-multicol-4 grid">
                {imageFields}
            </div>
        );
    }
});

ReactDOM.render(
  <PresentationBox />,
  document.getElementById("sth")
);
</script>
