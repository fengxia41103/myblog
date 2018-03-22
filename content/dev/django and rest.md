Title: Django to REST
Date: 2018-03-22 08:40
Tags: dev
Slug: django to rest
Author: Feng Xia

<figure class="col l6 m6 s12">
  <img src="/images/funny/the%20art%20of%20programming.jpg"
       class="center-block img-responsive">
</figure>


I have been building Django based web application for a while now. One
design/request I get often is a REST API. Once the model data is
exposed in REST, one can truly build a complete separate frontend
using things like Angular, react, and whatever you fancy. I have tried
a couple times myself following this architecture. On one hand it
gives a lot of flexibility and it looks nice, too &larr; front end
technology is a lot of "{}", but it does look quite nice, and
responsive, too. But on the other, REST is a thing few understands
well except it is an API through which you can CRUD. Honestly, I don't
even understand yet how authentication is done, what is a good balance
between massaging data (in Tastypie's term, (de)-hydration) and
exposing data model raw.

Anyway, here I want to document a practice I use, a really rudimentary
one, of making django model available as REST resource through
Tastypie.

1. [Django model reference][1]
2. [Tastypie][2]

[1]: https://docs.djangoproject.com/en/2.0/ref/models/fields/
[2]: https://django-tastypie.readthedocs.io/en/latest/


Let's say you are building a site called `mysite`, and in it it has an
application called `myapp`. So the file structure will be like
`gitroot/mysite/urls.py` for site-level URLs, and
`gitroot/myapp/urls.py` for app-level patterns. The confusing part is
that `myapp/urls.py` will be folded into `mysite/urls.py`. So the
thought is that a site can have multiple applications, each defining
its own **sub-pattern**, while the `mysite/urls.py` has the first run
of the match before handing URL to `myapp/urls.py` to match
**further**. So it's a matter of matching order.

Anyway. So building a REST can be broken down into 5 steps:

<figure class="col s12">
  <img src="/images/django%20to%20rest.png"
       class="center-block img-responsive">
</figure>



**Step 1**: create an API varialbe name.

Define an object `v1_api` in `myapp/api.py`. Name is not important at
all. It is a Tastypie's [`Api`][3] object, therefore it comes with an army
of capabilities:

[3]: https://github.com/django-tastypie/django-tastypie/blob/master/tastypie/api.py

<pre class="brush:python;">
from tastypie.api import Api

v1_api = Api(api_name='v1')
</pre>


**Step 2**: wire URL patterns

`v1_api` defined in the previous step comes with a list of REST url
patterns, and this is the beauty of [Tastypie][2]. So all we need to
do is make these _sub-patterns_ available through URL matching. As
explained above, we need to wire these into `mysite/urls.py`:

<pre class="brush:python;">
from myapp.api import v1_api as myapp_api  <-- the variable we defined

urlpatterns = patterns(
    # REST
    url(r'^mysite/api/myapp/',    <-- pattern matching
        include(myapp_api.urls)), <-- sub-pattern handler

</pre>

**Step 3**: define your django DB model

Nothing fancy here. Just the old school of data modeling.

**Step 4**: transform DB model to a resource model

REST speaks _resources_. Packaging a DB model into a resource is quite
simple:

<pre class="brush:python;">
from tastypie.resources import ModelResource

from myapp.models import MyModel  <-- import DB model

v1_api = Api(api_name='v1') <-- we have seen this one (see "step 1")

class MyModelResource(ModelResource):
    class Meta:
        queryset = MyModel.objects.all()  <-- data set to display in list
        resource_name = "mymodels" <-- string used in REST url "/mymodels/"
v1_api.register(MyModelResource())  <-- expose it to URL
</pre>

This is the simpliest example to make magic happen. What's more you
can do with this now?

1. `.objects.all()`: you don't have to expose everything. Any queryset
   is adequate. REST will allow filtering as well. So just need to be
   aware what your decision means.
2. [de-hydrate][4]: this is how you can massage your data set
   (essentially serializing and de-serializing) before you send data
   to user or taking data from data to DB.
3. foreign key reverse lookup
  
  Django defines reverse lookup by defining a related name in model:
  <pre class="brush:python;">
   class Datacenter(BaseModel):
       pass
   class Cluster(BaseModel):
       datacenter = models.ForeignKey("Datacenter",
                                      related_name="clusters") <-- related_name!
  </pre>
  
  Consequently, `DataCenterResource` reverse lookup to `cluster` will
  be like this:
  
  <pre class="brush:python;">
  class DatacenterResource(MyModelResource):
      clusters = fields.ToManyField("vx.api.ClusterResource", <-- FK resource
                                    attribute="clusters", <-- django related name
  </pre>

[4]: http://django-tastypie.readthedocs.io/en/latest/resources.html#flow-through-the-request-response-cycle

**step 5**: enjoy

Now go to `mysite/api/myapp/mymodels` (`mysite/api/myapp/` part is defined
in "step 1", `mymodels` part is defined in "step 4"), it should show
the `queryset` (defined in "step 4"). With REST, you can also do
things like `?format=json` or `?format=yaml`, and `?a_model_field__gt=`
type of [filtering][5]. Cool huh!?

[5]: http://django-tastypie.readthedocs.io/en/latest/interacting.html
