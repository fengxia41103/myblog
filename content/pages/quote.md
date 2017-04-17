Title: Quote of the day
Tags: quote
Slug: quote of the day
Author: Feng Xia

<div id="quote"></div>

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
               <i className={this.state.loading? "fa fa-spinner":"fa fa-angle-right"}
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

</script>
