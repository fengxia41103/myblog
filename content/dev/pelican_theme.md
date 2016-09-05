Title: DIY Pelican theme
Date: 2016-09-04 11:00
Tags: dev, pelican
Slug: pelican theme
Author: Feng Xia

As a Python house, [Pelican](http://blog.getpelican.com/) is
definitely a winner for our blog site. But like any software engineer
who hold a high standard to his work, I got turned off by
all the [available themes](http://www.pelicanthemes.com/).
"Ugly", "Where is the document?", "Why my translation is not shown?", I felt
running in a maze where there were reflections of exit everywhere, but none
was real. "Well, if it's in Python, we can make one." Solution is that simple.
Besides, we love [Jinja2](http://jinja.pocoo.org/docs/dev/) template systems,
and Pelican has spelled out [everything](http://docs.getpelican.com/en/3.6.3/themes.html#templates-and-variables)
we need.

Quickly we wrote down a few on wish list:

1. The design must be based on [Bootstrap](http://getbootstrap.com/components/).
2. Includes [Fontawesome](http://fontawesome.io/icons/), [Datatable](https://datatables.net/),
    [Lightbox2](http://lokeshdhakar.com/projects/lightbox2/), and
    [SyntaxHighlighter](http://alexgorbatchev.com/SyntaxHighlighter/).
3. Reuse elements we have designed for [showcases]({filename}/toc.md), such as layout, CSS and images.
4. Colors we like: <font color="#337ab7">blue(#337ab7)</font> and <font color="#d52349">red(#d52349)</font>.
5. [Google fonts](https://fonts.google.com/?category=Serif,Sans+Serif,Monospace&selection.family=Alfa+Slab+One|Archivo+Narrow|Baloo+Paaji|Jaldi|Teko)

The actual work was pretty straightforward. Follow Pelican official document
to set up a working directory:

<pre class="brush:bash;">
├── static
│   ├── bower_components
│   ├── css
│   │   └── my.css
│   └── js
│       ├── html5shiv.min.js
│       └── respond.min.js
└── templates
    ├── article.html
    ├── author.html
    ├── category.html
    ├── index.html
    ├── layout.html
    ├── page.html
    └── tag.html
</pre>

`bower_components` has all the third party libraries.
The key is the `layout.html` which is the root template of all others (shown below).

<pre class="brush:xml;">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- <meta name="viewport" content="width=device-width, initial-scale=1"> -->
	    <meta name="apple-mobile-web-app-capable" content="yes" />
	    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

	    {# http://hammerjs.github.io/getting-started/ #}
	    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1">

        <meta name="description" content="">
        <meta name="author" content="{{AUTHOR}}">

        {% block core_library %}
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
            <!-- script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script -->
        <!-- script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script -->
        <script src="/theme/js/html5shiv.min.js"></script>
        <script src="/theme/js/respond.min.js"></script>
        <![endif]-->


	    {# Fontawesome #}
	    <link rel="stylesheet" type="text/css" href="/theme/js/font-awesome/css/font-awesome.min.css">

	    {# DataTable #}
	    <link rel="stylesheet" type="text/css" href="/theme/js/datatables/media/css/dataTables.bootstrap.min.css">

        {# lightbox #}
	    <link rel="stylesheet" type="text/css" href="/theme/js/lightbox2/dist/css/lightbox.min.css">

        {# Bootstrap #}
	    <link rel="stylesheet" href="/theme/js/bootstrap/dist/css/bootstrap.min.css">

        {# Syntaxhighlighter #}
	    <link rel="stylesheet" href="/theme/js/SyntaxHighlighter/styles/shCoreDefault.css">
	    <link rel="stylesheet" href="/theme/js/SyntaxHighlighter/styles/shThemeDefault.css">

        {# my own #}
	    <link rel="stylesheet" type="text/css" href="/theme/css/my.css">

        {# google fonts #}
        <link href="https://fonts.googleapis.com/css?family=Alfa+Slab+One|Archivo+Narrow|Baloo+Paaji|Jaldi|Teko" rel="stylesheet">

	    {# JQuery lib #}
	    <script type="text/javascript" src="/theme/js/jquery/dist/jquery.min.js"></script>
        {% endblock %}


        {# page title #}
        {% block title %}
        {% endblock %}
    </head>

    <body>
        {% block navbar %}
        {% endblock %}<!-- end of block navbar -->

        {% block main %}
	    <div id="wrap">
	        <div class="container center-block">
		        <div class="row page-header">
                    <div class="col-md-6">
			            <h1 class="my-banner">
                            <a href="{{SITEURL}}/">{{ SITENAME }}</a>
			            </h1>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-inline pull-right" style="padding-top:100px;">
                            <li>
                                <a class="label label-default" href="{{SITEURL}}/">Home</a>
                            </li>
				            {% for p in PAGES %}
				            <li>
                                <a class="label label-default" href="{{SITEURL}}/{{ p.url }}">
                                    {{ p.title }}
                                </a>
                            </li>
				            {% endfor %}
                        </ul>
                    </div>
		        </div><!-- end of block header -->
            </div>

            {# introduction #}
            {% block introduction %}
            {% endblock %}

	        <div class="container center-block">
                {# main content #}
		        {% block content %}
		        {% endblock %}

                {# pagination #}
                {% block pagination %}
                {% endblock %}
	        </div><!-- /.container -->
	        <div id="push"></div>
	    </div>
        {% endblock %}<!-- end of block main -->


        {% block footer %}
        <footer>
            <div class="row">
	            <div class="col-md-offset-1 col-md-10">
                    <h3>Categories:</h3>
                    <ul class="list-inline">
                        {% for c,article in categories %}
                        <li>
                            <a href="{{SITEURL}}/{{c.url}}" class="btn btn-default">
                                <i class="fa fa-at"></i>
                                {{ c }}
                            </a>
                        </li>
                        {% endfor %}
                    </ul>
                    <h3>Tags:</h3>
                    <ul class="list-inline">
                        {% for c,article in tags %}
                        <li>
                            <a href="{{SITEURL}}/{{c.url}}" class="btn btn-default">
                                <i class="fa fa-tag"></i>
                                {{ c }}
                            </a>
                        </li>
                        {% endfor %}
                    </ul>
                </div>
           </div>
        </footer>
        {% endblock %}<!- end of block footer -->


        <!-- Placed at the end of the document so the pages load faster -->
        {% block Javascripts %}
	    <!-- Bootstrap -->
	    <script
            src="/theme/js/bootstrap/dist/js/bootstrap.min.js">
        </script>

	    {# DataTable #}
        <script type="text/javascript"
                src="/theme/js/datatables/media/js/jquery.dataTables.min.js">
        </script>
        <script type="text/javascript"
                src="/theme/js/datatables/media/js/dataTables.bootstrap.min.js">
        </script>

	    {# lightbox: http://ashleydw.github.io/lightbox/ #}
        <script type="text/javascript"
                src="/theme/js/lightbox2/dist/js/lightbox.min.js">
        </script>

        {# Syntaxhighlighter #}
        <script type="text/javascript"
                src="/theme/js/SyntaxHighlighter/scripts/XRegExp.js">
        </script>
        <script type="text/javascript"
                src="/theme/js/SyntaxHighlighter/scripts/shCore.js">
        </script>
        <script type="text/javascript"
                src="/theme/js/SyntaxHighlighter/scripts/shBrushPython.js">
        </script>

	    {# TOC https://github.com/dcneiner/TableOfContents/tree/master #}
        <script type="text/javascript"
                src="/theme/js/jquery.tableofcontents/js/jquery.tableofcontents.min.js">
        </script>


        {# application js #}
	    <script type="text/javascript">
		 var j$ = jQuery.noConflict();


		 j$(document).ready(function(){
			 // common global widget initializations
			 var table = j$('table.my-datatable').dataTable({
				 paging: false,
				 info:false,
				 "pagingType": "simple"
			 });


             // syntaxhighlighter
             SyntaxHighlighter.defaults['toolbar'] = false;
             SyntaxHighlighter.all();
		 });
	    </script>
        {% endblock %} <!-- end of block JS -->

        {# extra javascript code #}
        {% block theme_js %}
        {% endblock %}
        {% block custom_js %}
        {% endblock %}
    </body>

</pre>

Once this is set up, creating an individual page is simple. Just replace
the `{% block content %}` with relevant content and you are done.
Take the `page.html` for example that displays all static pages
such as `About`.

<pre class="brush:xml;">
{% extends "layout.html" %}

{% block content %}
<h1>{{ page.title }}</h1>

<div class="col-md-offset-1 col-md-10">
<article>
  {{ page.content }}
</article>
</div>
{% endblock %}
</pre>

Like what you see? Roll up your sleeves and make a new theme. 1,2,3, Go!
