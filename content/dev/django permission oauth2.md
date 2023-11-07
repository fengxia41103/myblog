Title: Django Permission, DRF, OAuth2
Date: 2023-09-10 18:44
Slug: django permission oauth2
Author: Feng Xia

[OAuth2][1] is confusing! Here I'm gonna use Django as the framework
to how OAuth2 can be implemented. This shall provide a reference point
for others to see how OAuth2 is meant to work.

# who is who is who

I'm gonna use layman's term instead of the [RFC][1].

| Who                  | Description                                                                                                  |
|----------------------|--------------------------------------------------------------------------------------------------------------|
| You                  | The user who has a user account w/ Authorization Server.                                                     |
| Application          | For example, my Stock app. You are delegating this app on your behalf to access resources, thus the "Grant". |
| Resource Server      | For example, Gmail is a _resource server_ for my emails, GDrive is another for my drives, etc.               |
| Authorization Server | Google as a whole is an Authorization Server. I authenticate w/ `google.com`. Same for GitHub, FB, etc.      |

# OAuth2 is & is-not

Read [RFC][1]. Some points not clear from the RFC, but are important:

1. **It's a protocol**. In other words it describes a way to
   _negotiate_ authorization, but doesn't care implementation details,
   eg. each framework/language has a dozen different implementations,
   all vary at details but follow the same _requirements_ defined in
   RFC.  This [RFC][1] dictates **a very specific sequence of call
   flow/workflow**, and it dictates some restrictions, eg. `client
   secret` should never be made available to the frontend/browser.

2. **Authorization Server is the source-of-truth for user**. This is
   very important. OAuth2 is meant to allow a user to access
   **multiple applications** while these applications don't have any
   data/table of user records! In other words, in today's micro
   service world, if I have two services and each service is a Django
   app, I don't want to maintain two separate user name called
   `fengxia` in two DBs. Instead, I create 3rd Django app/service just
   to manage user, and this Django app is also the OAuth2
   Authorization Server.

3. **Resource Server can be separate from Authorization Server**. If
   thinking of micro service architecture, this is pretty
   obvious. Individual service is the resource server, and there will
   be one Authorization Server vs. multiple resource servers. In this
   case you need to implement [OAuth2 Introspection][4] on the
   Authorization Server (see later) so that resource server could
   obtain more information of the user by querying this token, and
   then use the user's whatever information for its own purpose.

4. **If letting ppl use social media account to login your own app,
   it's OAuth2**. Say you created the Stock app, how to entice ppl to
   use it? Instead of asking ppl to register w/ your app, you let them
   login using their Google credential. This, is OAuth2. In this case,
   Google is the Authorization Server. You will be granting the Stock
   app a `read` scope of the `user` resource, for example, thus now
   the Stock app can get your name, phone, email, and save them in the
   Stock's DB, the Stock app can render a HTML template w/ `Hello, {{
   user.name }}`. You will also **save the token** in Stock's DB,
   eg. a field in `User` model, because all subsequent calls to Google
   uses this token.

5. **You must register application w/ Authorization Server**. If you
   Stock app is not the Authorization Server, and the Authorization
   Server has something(aka. resource) your want, register your
   application w/ the Authorization Server. This is defined in the
   [protocol][5], and **must be done**.

# OAuth2 workflow

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*9R2CC0_HxtzYERiqHyGs-Q.png)

# OAuth2 scope

It's super confusing what OAuth2 [scope is][5].

First, scope is just string. The Authorization Server could define any
scope it wants.

> The value of the scope parameter is expressed as a list of space-
> delimited, case-sensitive strings.  The strings are defined by the
> authorization server.  If the value contains multiple space-delimited
> strings, their order does not matter, and each string adds an
> additional access range to the requested scope.

Second, it's definition **isn't completely arbitrary**. Because
Authorization Server is using scope to control access to registered
application and its resources, it only makes sense that the _scope_
string means something about the *access control** of the
resource. Therefore, naming a scope is rather like naming a variable
&larr; there is certain [best practice][6] involved.

And this is where Django comes in. For following discussion, we are
talking about a _Resource Server implemented in Django & DRF_.

## Scope can bypass permission

OAuth2 only cares scope. Whether the scope is enforcing a permission
is determined by implementation. Since scope is arbitrary string,
there is nothing preventing an API assigned a scope called "feng",
and returns a queryset of sensitive data even though the requesting user
John has no permission on this data.

What influence the exact behavior in this scenario also depends on:

1. the default DRF permission in the `settings.py`:

        ```python
        # settings.py

        REST_FRAMEWORK = {
            'DEFAULT_PERMISSION_CLASSES': [
                'rest_framework.permissions.IsAuthenticated',  <== default
            ]
        }
        ```

      In this case, John must be authenticated and has the "feng"
      scope. Since OAuth2 always requires authentication, so this is
      a given. However, DRF has a list of other built-in
      permissions, and some would tie into model permission, which
      then enforce a permission on top of scope.


2. and `permission_classes=` per DRF view:

        ```python
        # views.py

        from guardian.shortcuts import assign_perm
        from rest_framework import viewsets
        from rest_framework.permissions import DjangoObjectPermissions

        from .models import Message

        class MessageViewSet(viewsets.ModelViewSet):

            permission_classes = [....]  <== logical AND
        ```

      Besides the default above, each view can have a list, which is
      a logical AND. Only when user has all the permissions will he
      be allowed access to the view/API. This is essentially the
      mechanism how `django-oauth-toolkit` checks its scope together
      w/ other DRF permissions.


## Scope & permission work together

Permission is the foundation of ACL. Really depending on the framework
and implementation, there are different level of security you could
enforce. Ideally the underline permission **is directly translated
into scope**. In Django's world, this is what it looks like:

![](images/oauth2%20scope%20and%20django%20permissions.png)

Django model CRUD permissions are created whenever a model is
created. So you get `blog.view_post` permission for free, which means
you could easily use the string `blog.view_post` as a scope &lrar; a
1:1 mapping! But, each model generates 4 permissions by default, thus
using them directly as scope is too tedious.

Instead, you can define two general scopes called `READ` and `WRITE`,
and add some custom scope, say `music`, to protect all the
music-related APIs.

```python
In `settings.py` by django-auth-toolkit:

OAUTH2_PROVIDER = {
    'SCOPES': {
        'read': 'Read scope',  <== GET, HEAD, OPTIONS
        'write': 'Write scope', <== POST, PUT, PATCH, DELETE
        'music': 'Music scope' <== arbitrary
    },

    'CLIENT_ID_GENERATOR_CLASS': 'oauth2_provider.generators.ClientIdGenerator',

}

Then in a DRF view:

class SongView(views.APIView):
    authentication_classes = [OAuth2Authentication]
    permission_classes = [TokenHasScope, DjangoModelPermissions]  <==work together!
    required_scopes = ['music']
```

## publish scope

Let's say once you design a list of scopes, you provide them as
document so client of your Authorization Server knows what to expect,
for example, [Google scopes][3].


# Django & DRF permission

Since the idea of "scope" is to control access to _resource_, and a
resource is an API/URL (essentially a `view` whether DRF-ed or not),
it'd better be **coherent w/ Django's access control &mdash;
[Permission][7]**. In other words, Django's fundamental resource are
those data and data models. Accessing these data are controlled by the
[Permission][7]. Therefore, these permissions must be the foundation
to define a "scope". And they are.

## Permissions

A couple really good articles about Django permissions, [here][7] &
[here][10]. They have good code examples of how to define and
enforce.

To define a permission:

| Per                     | Django                                                   | DRF                       |
|-------------------------|----------------------------------------------------------|---------------------------|
| Arbitrary permission    | `Permission.objects.create()`, then link to `User/Group` | n/a                       |
| Object/row/data record  | [`django-guardian`][8], [`django-rules`][9]              | `DjangoObjectPermissions` |
| Model                   | Any Django Model: C(add), R(view), U(change), D(delete)  | `DjangoModelPermissions`  |
| Model custom permission | Model's `Meta`: any permission you design                | n/a                       |
| View custom permission  | n/a                                                      | extend `BasePermission`   |

To enforce a permission:

| Per                | Django                                                                   | DRF                                         |
|--------------------|--------------------------------------------------------------------------|---------------------------------------------|
| Group              | 1:n to `permissions` via Admin console                                   |                                             |
| User               | 1:n to `permissions` via Admin console, can inherit Group's directly     | DRF Permissions                             |
| Enforcement @ View | `PermissionRequiredMixin`, `UserPassesTestMixin`, `@permission_required` | `permission_classes`, `@permission_classes` |
| Enforce @ Template | `{% if perms.blog.view_post %}`, `user.has_perm("blog.view_post")`       | n/a                                         |

# Authenticated (Group, Role) vs. Anonymous

If you are anonymous, ACL is depending on whether the view is
_protected_ using an enforcement.

If you are authenticated, we know the `User` and his `Group`, thus the
permission is enforced by what's assigned to the `User` or his `Group`.

Django does **not have "role"**. Django uses `Group` to group
user, and `permission` can be attached to `Group` so to be applied
batchly to all users in this group. Role, if implemented, will
essentially achieve the same `permission` control. Therefore, you
**should treat `Group` == role** in Django.

## DRF access control by who you are

There are two types of users &mdash; authenticated, and
anonymous. Authenticated users are further divided in Django
as. **Note** that staff user could also have `Group` so `D` and `E`
are **not exclusive** to each other. In the followings I'm treating `E` as the
super set of `D`.

```
.
├── A: anonymous
└── B: authenticated
    ├── C: super
    ├── D: staff/admin (User's `is_staff=True`)
    └── E: User <-(n:n)-> Group
```

We code name them as `ABCDE`. So, how to control who can do what?

| DRF Permission                   | Anon can use | Can Read      | Can Write     | Enforce Model Permission |
|------------------------------|--------------|---------------|---------------|--------------------------|
| AllowAny                     | yes          | A,B           | A,B           | none                     |
| IsAuthenticated              | no           | B             | B             | none                     |
| IsAuthenticatedOrReadOnly    | yes          | A,B           | B             | none                     |
| IsAdminUser                  | no           | D             | D             | none                     |
| DjangoModelPermissions       | no           | permission(B) | permission(B) | B's CRUD                 |
| DjangoModelPermissionsOrAnon | yes          | A,B           | permission(B) | B's CUD                  |
| DjangoObjectPermissions      | no           | permission(B) | permission(B) | B's CRUD                 |

## django-oauth-toolkit access control by scope

Finally, we can look at the ACL of [`django-auto-toolkit`][2], which
is just a list of [permissions][11] in addition to DRF permissions!
This extension focuses on checking the oauth scope by the token, and
**can be combined in AND w/ all other DRF permissions**, and then
through DRF's `DjangoModelPermissions`, it will be further tied into
Django model permissions:


```python
class SongView(views.APIView):
    authentication_classes = [OAuth2Authentication]
    permission_classes = [TokenHasScope, DjangoModelPermissions]  <==work together!
    required_scopes = ['music']

```

Below shows the behavior of toolkit permission behaviors. Because OAuth2 user
must have been authenticated, all these are **not applicable** to anonymous users.

| Control                        | required_scopes                        | authentication_classes          | Read                                    | Write                                    | Enforce Model Permission                                                                  |
|--------------------------------|----------------------------------------|---------------------------------|-----------------------------------------|------------------------------------------|-------------------------------------------------------------------------------------------|
| TokenHasScope                  | required                               | `[OAuth2Authentication]`        | has all `required_scopes`               | has all `required_scopes`                | none                                                                                      |
| TokenHasReadWriteScope         | optional                               | `[OAuth2Authentication]`        | has `read` scope                        | has `write` scope                        | none                                                                                      |
| TokenHasResourceScope          | required                               | `[OAuth2Authentication]`        | has `music:read` scope                  | has `music:write` scope                  | none                                                                                      |
| IsAuthenticatedOrTokenHasScope | required                               | DRF's                           | has `music:read` scope or authenticated | has `music:write` scope or authenticated | should use `permission_classes = [IsAuthenticatedOrTokenHasScope, DjangoModelPermission]` |
| TokenMatchesOASRequirements    | `required_alternate_scopes` per method |`[OAuth2Authentication]`  |has all scopes by the HTTP verb | has all scopes by the HTTP verrb        | no    |


Complicated, isn't it!?


[1]: https://www.rfc-editor.org/rfc/rfc6749#section-1.2
[2]: https://django-oauth-toolkit.readthedocs.io/
[3]: https://developers.google.com/identity/protocols/oauth2/scopes
[4]: https://datatracker.ietf.org/doc/html/rfc7662
[5]: https://www.rfc-editor.org/rfc/rfc6749#page-23
[6]: https://www.oauth.com/oauth2-servers/scope/defining-scopes/
[7]: https://testdriven.io/blog/django-permissions/
[8]: https://django-guardian.readthedocs.io/en/stable/
[9]: https://github.com/dfunckt/django-rules
[10]: https://medium.com/djangotube/django-roles-groups-and-permissions-introduction-a54d1070544
[11]: https://django-oauth-toolkit.readthedocs.io/en/latest/rest-framework/permissions.html#
