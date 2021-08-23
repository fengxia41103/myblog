Title: REACT Key Authentication (1/2) - API side
Date: 2021-08-22 10:38
Tags: dev
Slug: react key authentication backend
Author: Feng Xia

I'm very much surprised that not much information can be found on this
topic. As a matter of fact, there are very few examples on how to
handle two most common tasks that every single frontend must face:
**login** and **logout** &mdash; I mean, there are too many code
examples out there which talks from one aspect of things, namely
either from the frontend or the backend, but the code hows too much
details on the how-to, but lacks illustration of how pieces are fit
together. In other words, it has all the implementations but little
design. So after days of trial, let me write down what I learned, and
hopefully will put this task to sleep once for all.

# API Backend

In my case, backend is Django w/ [Tastypie][1] REST API and frontend
in REACT. [Tastypie][1] is just a matter of convenience. Here in
essence I'm assuming there is a RESTful backend serving data and
supports API key authentication. If you were not fullstack, you may
not need to bother how backend is coded. But Tastypie doesn't come w/
login/logout touch points out of box, so I had to write code for that.

## API & data model

I have a strong opinion **against** this type of APIs. In my view,
they should not call themselves APIs even.

These APIs are designed **artificially**, meaning they are not
generated from data models, but instead is coded from scratch by some
dev &larr; this kind is the worst because this adds another layer of
translation (and I'm talking about knowledge translation, not coding
language translation) from backend's data model (which is the source of all
truth, especially about data's logical relationships) to yet another
data presentation (in form of web accessible URLs)[^1].

> In short, backend API should only be a (de)serialization of the
> underline data. It **should not** change the meaning of the data,
> and absolutely not modifiy their logical relationships.
>

## three types of auth & data model

It's quite confusing when one talks about authentication,
authorization, and sometimes, role-based. How are they fit into a
single picture? In essence the purpose of auth is to answer two
questions: **data ownership** and **CRUD mapping**.

<figure class="col s12">
  <img src="images/backend%20auth.png"/>
  <figcaption>Backend authentication & authorization</figcaption>
</figure>

- **Type 1**: Fit for public data API whereas user management can be
  optional. There might still be authentication step, but essentially
  backend doesn't distinguish difference between two users &mdash; A &
  B users have the same right within the data domain. The idea here is
  to focus on the models that support functions of your application,
  so don't get distracted yet by user management.

- **Type 2**: Now to introduce user A vs. B because of two things in
  mind:

  1. data ownership: a data record may now have a `User` key, thus A
     can't see B's data.
  2. CRUD: anonymous user is READONLY, vs. logged in user can
     CRUD. This is essentially a `role`, but without yet separate it
     into its own entity.

  The key is that `user` hierarchy is **flat**. As soon as you are
  thinking hierarchy in user, you need now move to type 3.

- **Type 3**: On top of type 2, introduce a role management. If Role
  is flat, type 3 is just a fancy version of type 2. However, role can
  be hierarchical, also.

  1. data ownership: w/ role, ownership can be `User` based, or `role`
     based (think of your boss can see your data).
  2. CRUD: instead of linked to `user` in type 2, now linked to
     `role`. This is the same as `position` in an org &mdash; that
     employee can change, but function of the position doesn't.

In the end, there is really only one design, the type 3 &mdash; Type 1
is a special case of 2 (when every user is the same user), and 2 a
special case of 3 (when every user is the same role).

## Top down vs. bottom up

Here is the disconnect &mdash; In dev/POC, I find it much better to do
the bottom up way by starting w/ type 1, the bare minimum, so to focus
on the functions first. Once the application is doing what I want, we
can slap on top of these auth to make it fancy.  But in
meetings/projects, type 3 is often the talk because it is
**theoretically correct** &larr; how can any design be ok w/o thinking
upfront of auth?

> But what they don't realize is that type 1 isn't defected at all.
> It's only a simplified version of type 3, but it doesn't skip any of
> the critical ingredients in the design, just that assigning them a
> _default_ value for the time being.
>

Top down is fine for experienced designer who know how these are fit
together, and what default values are used and what they mean. But too
often than not, the inexperienced  will take the top down approach,
but function, or the foundation of the application, suffers exactly
because of the complexity it introduces at each turn. This is like
teaching 1st graders college math, yes college math is a better
version than `1+1`, then?

# API Authentication Proxy

It should be clear by now that **API level authentication is a
proxy**. In the end it will invoke some backend's native
authentication mechanism for user checking. Hypothetically speaking
API proxy can integrate multiple backend/data sources, thus may
present multiple ways to authenticate a user[^2]. But assuming you are
authenticated, the key question remains &mdash; what is the data
ownership and CRUD mapping within each application?

## API key

Tastypie creates a new model `ApiKey` w/ `1:1` relationship to
`User`. When using this authentication, client/frontend is to call w/
username and pwd with a `POST`, then server/api authenticate this
user, and return the key. All subsequent client HTTP calls will have
this in the HTTP header, and that's it.

```js
Authorization: `ApiKey ${user}:${api_key}`
```

Remember, because user management is a backend thing, whether the key
expires or not is irrelevant in authentication itself. If it expires
somehow, client gets an error code/msg. How it handles is a function
discussion by itself.

## Create a Tastypie Auth resource

Now as you can see, even Tastypie can neatly package Django model into
a [resource][2], a [resource][2] doesn't by itself
authenticate. Instead, you build a touch point for client to call,
**whether the URL is `/api/v1/<whatever` or a dedicated view at
`/me/blahblah`** is irrelevant. Below I'm choosing the former because
then auth URLs will be part of `/api/v1` schema instead of a made-up
URL, feels cleaner.

### An auth dummy resource

In some blogs login is exposed w/ `User` resource/model. However, I
think it's better to create a dummy resource for auth purpose
only. Therefore, one can abuse this touch point and feel safe because
there is model data behind this!


```python
class AuthResource(Resource):
    class Meta:
        allowed_methods = ["get", "post"]
        resource_name = "auth"
        authentication = ApiKeyAuthentication()
```

Here I allow both `post` and `get`, for we are to login w/ `post`, and
logout with `get`. For using `get` to logout, since I'm not passing
any user data in post body, I need to use the API key to identify this
user, thus it needs `authentication=ApiKeyAuthentication` so that
Tastypie workflow will observe the header for API key.

### prepend url

There is very little info on the [doc][3], but this is the key. The
question is, once I have created a resource, how will call to this
resource trigger a login!? This is what you do:

1. In the resource, define a class method to handle login details.
2. Use `prepend_url` to assign a URL linked to this method! In other
   words, you get your resource URL, ie. `/api/v1/auth`, but you can
   define a `/auth/whatever` in your resource and link to a class
   method as the handler. So as you can see, this isn't much different
   from creating a Django view and link to a URL.

```python
from django.conf.urls import url

class AuthResource(Resource):
    class Meta:
        allowed_methods = ["get", "post"]
        resource_name = "auth"
        authentication = ApiKeyAuthentication()

    def prepend_urls(self):
        return [
            url(
                r"^(?P<resource_name>%s)/login%s$"
                % (self._meta.resource_name, trailing_slash()),
                self.wrap_view("login"),
                name="api_login",
            ),
            url(
                r"^(?P<resource_name>%s)/logout%s$"
                % (self._meta.resource_name, trailing_slash()),
                self.wrap_view("logout"),
                name="api_logout",
            ),
        ]
```

So, the key is `self.wrap_view("login")`, whereas `login` is actually
a class method which I'll do next. The URL pattern is up to whatever
you imagine really. By doing the `self._meta.resource_name`, you are
creating a pattern `/<your resource name>/login`. Same applies to the
logout function.

### login

I wouldn't go into details of the code. The key here is the
`self.deserialize` which gives you a way to extract username and
password in the JSON body. Once  you have them, call Django's built-in
`authenticate` for the actual work. Here is where you can see proxy
hooking up w/ other backends for authentication calls if so.

The `ApiKey` part is to create a key for the user if not
presented. Tastypie recommends using model signal so that each new
user gets a key always. They all achieve the same end state &mdash;
**one user, one key**, therefore key becomes the user. Period.


```python
def login(self, request, **kwargs):
    self.method_check(request, allowed=["post"])
    data = self.deserialize(
        request,
        request.body,
        format=request.META.get("CONTENT_TYPE", "application/json"),
    )
    username = data.get("username", "")
    password = data.get("password", "")
    user = authenticate(username=username, password=password)
    if user:
        if user.is_active:
            # login(request, user)
            try:
                key = ApiKey.objects.get(user=user)
                if not key.key:
                    key.save()
            except ApiKey.DoesNotExist:
                key = ApiKey.objects.create(user=user)
            return self.create_response(
                request,
                {
                    "success": True,
                    "data": key.key,
                },
            )
        else:
            return self.create_response(
                request,
                {
                    "success": False,
                    "message": "User is not active",
                },
                HttpForbidden,
            )
    else:
        return self.create_response(
            request,
            {
                "success": False,
                "message": "Login failed",
            },
            HttpUnauthorized,
```

### logout

The key is `self.is_authenticated(request)`. This will populate
`request.user` w/ the key's user. Otherwise you will always get
`request.user` being `AnonymousUser`.

Of course, you can choose to use `post`, and have frontend pass back
the `(user,key)`, and have code here to look up the identity. But
since I have added `authentication = ApiKeyAuthentication()` in the
resource Meta, the key in the HTTP header will be picked up by
Tastypie's `get` already. Thus making the call a bit cleaner. Further,
`get` is a better shot than `post` for logging out a user, imho.


```python
def logout(self, request, **kwargs):
    self.method_check(request, allowed=["get"])

    # MUST: call to populate User
    self.is_authenticated(request)

    if request.user and request.user.is_authenticated:
        logout(request)
        return self.create_response(request, {"success": True})
    else:
        return self.create_response(
            request, {"success": False}, HttpUnauthorized
        )

```

[1]: https://django-tastypie.readthedocs.io/en/v0.9.11/authentication_authorization.html
[2]: https://django-tastypie.readthedocs.io/en/v0.9.7/resources.html
[3]: https://django-tastypie.readthedocs.io/en/latest/api.html#prepend-urls

[^1]: This is not only risky, but is often than not, wrong! All
    language has lib to transform your data model code into API
    **automagically**. There is simply no reason to  write from
    scratch. If yours can't, you should consider upgrading the
    underline data modeling layer, but not to patch it w/ an
    webservice API.

[^2]: In some cases, proxy authenticate is really a convenience to
    bring more users to your application, ie. allow user to use Google
    account in your application w/o doing any user registration.
