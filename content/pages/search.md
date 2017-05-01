Title: Search
Tags: search
Slug: search
Author: Feng Xia

<div id="search"></div>

<script type="text/babel">
 var randomId = function() {
   return "MY" + (Math.random() * 1e32).toString(12);
 };

 var ItemBox = React.createClass({
   render: function(){
      var url = "/"+this.props.url;
      return (
       <div className="row">
         <div className="col s2">
           <i className="fa fa-tag">&nbsp;</i>
           {this.props.tags}
         </div>
         <div className="col s7 myhighlight">
           {this.props.title}
         </div>
         <div className="col s3 right-align">
           <a href={url}>
             read more
           </a>
         </div>
         <br />
         <div className="divider"></div>
       </div>
     );
   }
 });

 var SearchBox = React.createClass({
   getInitialState: function(){
     return {
       in_search: "",
       articles: []
     }
   },
   _setContent: function(json){
     this.setState({
       articles: json
     });
   },
   _handleChange: function(event){
     this.debounceHandleChange(event.target.value);
   },
   componentDidMount: function(){
     var setContent = this._setContent;
     fetch("/tipuesearch_content.json")
       .then(function(resp){
         return resp.json();
       }).then(function(json){
         if ((typeof json != "undefined") && json){
           setContent(json);
         }
       });

     var handleChange = this._handleChange;
     this.debounceHandleChange = _.debounce(function(data){
       this.setState({
         in_search: data
       })
     }, 500);
   },
   render: function(){
     var pages = this.state.articles.pages;
     var in_search = this.state.in_search;
     var items = pages; // by default, display all pages
     if (in_search){
       items = _.filter(pages, function(p){
         // search for searchbox input
         if (p.title.indexOf(in_search)>0 || p.text.indexOf(in_search)>0){
           return true;
         }else{
           return false;
         }
       });
     }

     // display all pages or filtered items
     if (pages){
       items = items.map(function(p){
         return <ItemBox key ={p.url}
                         {...p}/>

       });
     }

     // render
     return (
       <div>
         <SearchInput handleChange ={this._handleChange}/>
         {items}
       </div>
     )
   }
 });

 var SearchInput = React.createClass({
   render: function(){
     return (
       <div className="input-field">
         <input type="text"
                placeholder="Search content"
                onChange={this.props.handleChange}/>
       </div>
     );
   }
 });


 ReactDOM.render(
   <SearchBox />,
   document.getElementById("search")
 );

</script>

