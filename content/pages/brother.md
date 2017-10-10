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

 var DisplayListBox = React.createClass({
   render: function(){
     var imageThumbs = this.props.displayList.map(function(img){
       return (
         <img key={img.key}
              onClick={this.props.onClick.bind(null,img)}
              className="mythumbnail"
              src={img.thumb} />
       );
     },this);

     return (
       <div>
         {imageThumbs}
       </div>
     );
   }
 });

 var OneBox = React.createClass({
   render: function(){
     return(
       <div className="row center-align">
         <img src={this.props.image.full}
              onClick={this.props.onNext}
              style={{maxHeight:"67vh"}} />

         { this.props.showMore?
            <div id="showMore"
                 onClick={this.props.onClick}>
              <i className="fa fa-expand"></i>
              Show more
            </div>
         :null }

         <DisplayListBox displayList={this.props.displayList}
                         onClick={this.props.setImage}
                         className="col s12"/>
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
       showMore: true,
       displayList: []
     }
   },
   componentDidMount: function(){
     var that = this;
     document.onkeydown = function(e) {
        switch (e.keyCode) {
            case 37:
                that.onPrev();
                break;
            case 38:
                break;
            case 39:
                that.onNext();
                break;
            case 40:
                break;
            }
    };
   },
   setImage: function(img){
     this.setState({
       showing: img
     });
   },
   handleImageFieldClick: function(img){
     this.setImage(img);

     // toggle show more
     this.toggleShowMore();
   },
   toggleShowMore: function(){
     this.setState({
       showMore: !this.state.showMore
     });
   },
   onNext: function(){
     var current = this.state.showing;
     var images = this.props.images;
     if (current.key == images.length){
       // Circle back to beginning
       this.setState({
         showing: images[0]
       });
     }else{ // set current to next
       this.setState({
         showing: images[current.key]
       });
     }

     this.handleUpdate();
   },
   onPrev: function(){
     var current = this.state.showing;
     var images = this.props.images;
     if (current.key == 1){
       // Circle back
       this.setState({
         showing: images[images.length-1]
       });
     }else{ // set current to next
       this.setState({
         showing: images[current.key-2]
       });
     }

     this.handleUpdate();
   },
   handleUpdate: function(){
     // Always show 11 photos
     var current = this.state.showing;
     var images = this.props.images;
     var start = Math.max(0,current.key-3);
     var end = Math.min(current.key+3,images.length);
     var tmp = [];
     for(var i=start-1; i<end;i++){
        tmp.push(images[i]);
     }
     this.setState({
        displayList: tmp
     });
   },
   render: function(){
      var imageFields = this.props.images.map(function(img){
        return (
          <ImageField img={img}
                      onClick={this.handleImageFieldClick}
                      key={img.key}/>
        );
      }, this);
      return (
        <div>
          { this.state.showMore?
             <OneBox image={this.state.showing}
                     showMore={this.state.showMore}
                     onClick={this.toggleShowMore}
                     onNext={this.onNext}
                     onPrev={this.onPrev}
                     displayList={this.state.displayList}
                     setImage={this.setImage} />:
             <div className="my-multicol-3">
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
