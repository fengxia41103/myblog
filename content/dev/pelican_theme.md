Title: DIY Pelican theme
Date: 2016-09-04 11:00
Tags: dev, pelican
Slug: pelican theme
Author: Feng Xia

As a Python house, [Pelican][] is
definitely a winner for our blog site. But like any software engineer
who hold a high standard to his work, I got turned off by
all the [available themes][].
"Ugly", "Where is the document?", "Why my translation is not shown?", I felt
running in a maze where there were reflections of exit everywhere, but none
was real. "Well, if it's in Python, we can make one." Solution is that simple.
Besides, we love [Jinja2][] template systems,
and Pelican has spelled out [everything][]
we need.

[pelican]: http://blog.getpelican.com
[available themes]: http://www.pelicanthemes.com/)
[jinja2]: http://jinja.pocoo.org/docs/dev/
[everything]: http://docs.getpelican.com/en/3.6.3/themes.html#templates-and-variables


Quickly we wrote down a few on wish list:

1. The design must be based on [Bootstrap][]
2. Includes [Fontawesome][], [Datatable][], [Lightbox2][], and [SyntaxHighlighter][].
3. Reuse elements I have designed for [showcases][], such as layout, CSS and images.
4. Colors we like: <font color="#337ab7">blue(#337ab7)</font> and <span class="myhighlight">red(#d52349)</span>.
5. [Google fonts][]

[bootstrap]: http://getbootstrap.com/components/
[showcases]: {category}demo
[fontawesome]: http://fontawesome.io/icons/
[datatable]: https://datatables.net/
[lightbox2]: http://lokeshdhakar.com/projects/lightbox2/
[syntaxhighlighter]: http://alexgorbatchev.com/SyntaxHighlighter/
[google fonts]: https://fonts.google.com/

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
<!DOCTYPE html>
<html>
    <head>
        {% block css %}
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

            {% block introduction %}
            {% endblock %}

	        <div class="container center-block" id="content">
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
            {# block of related contents #}
            {% block related %}
            {% endblock %}

            <div class="row">
	            <div class="col-md-offset-1 col-md-10">
                    <h3>Categories:</h3>
                    <ul class="list-inline">
                        {% for c,article in categories %}
                        <li style="margin-top:0.7em;">
                            <a href="{{SITEURL}}/{{c.url}}" class="btn btn-default">
                                <i class="fa fa-folder-open-o"></i>
                                {{ c }}
                            </a>
                        </li>
                        {% endfor %}
                    </ul>
                    <h3>Tags:</h3>
                    <ul class="list-inline">
                        {% for c,article in tags %}
                        <li style="margin-top:0.7em;">
                            <a href="{{SITEURL}}/{{c.url}}" class="btn mytag">
                                <i class="fa fa-tag"></i>
                                {{ c }}
                            </a>
                        </li>
                        {% endfor %}
                    </ul>

                </div>
           </div>


            <div class="row" style="text-align:center; margin-top:5em;">
                <h4>
                    2016 PY Consulting Ltd.
                    1236 Beacon Street, Brookline, MA 021461
                </h4>

                <ul class="list-inline">
                    <li>
                        <a href="mailto:{{EMAIL_ADDRESS}}">
                            <i class="fa fa-envelope"></i>
                        </a>
                    </li>

                    <li>
                        <a href="{{GITHUB_ADDRESS}}">
                            <i class="fa fa-github"></i>
                        </a>
                    </li>
                    <li>
                        <a href="{{LINKEDIN_ADDRESS}}">
                            <i class="fa fa-linkedin"></i>
                        </a>
                    </li>
                    <li>
                        <a href="">
                            <i class="fa fa-phone-square"></i>
                            (508)801-1794
                        </a>
                    </li>

                </ul>
                <p>
                    <i class="fa fa-copyright" ></i>All rights reserved.
                </p>
            </div>
            </footer>
        {% endblock %}<!- end of block footer -->


        <!-- Placed at the end of the document so the pages load faster -->
        {% block Javascripts %}

        {# application js #}
	    <script type="text/javascript">
		 var j$ = jQuery.noConflict();


		 j$(document).ready(function(){
		 });
	    </script>
        {% endblock %} <!-- end of block JS -->

        {# extra javascript code #}
        {% block theme_js %}
        {% endblock %}
        {% block custom_js %}
        {% endblock %}
    </body>

</html>
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
