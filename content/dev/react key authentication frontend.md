Title: REACT Key Authentication (2/2) - frontend
Date: 2021-08-22 21:18
Tags: dev
Slug: react key authentication frontend
Author: Feng Xia

Following last article on [API backend][1] using Tastypie, this
article will show REACT frontend side, in particular, the `login` and
`logout`. Again, I'm very surprised that not many `npm` readily
available to encapsulate such a common task. Blogs show how the author
has done the authentication, aka. authentication, but I couldn't find
much on how to design the logout &mdash; Should I redirect to page
upon logout? if yes, which page, any? How then should the routing be?
and how to protect all pages to require authentication?

# Design

<figure class="col s12">
  <img src="images/react%20login%20logout.png"/>
  <figcaption>REACT login & logout</figcaption>
</figure>


Observe the followings:

1. `login view`: First of all, I'm not saying this page is only doing
   login. It can be any view as you wish. As long as the login call is
   happening while user is using this page, I'm calling it the `login`
   page, thus there is always a `login view`. The actual login call to
   `post` can be component rendered by this view.

2. `logout component`: is most likely a button/icon on nav bar that
   lets user to logout. Nothing prevents you doing a full page just
   for the logout. So similar to the `login view`, as long as the
   logout call to API is happening on this page/view, this is the
   `logout component`.

3. `Auth logic root view`: is the mother view of the `login view`. For
   simplicity purpose I'm also drawing it to be the mother of all
   other views which **require authentication**. Theoretically the
   latter is not mandatory because you can use routing to `goto`
   another URL. But keeping them as children view ensures that they
   can not escape the login logic.

4. `Auth protected views`: any view that requires authentication.

Once we have these concepts, the requirements are clear:

> 1. If not authenticated, show `login view`.
> 2. Once authenticated:
>
>     1. If login was his first page, go to app's landing page
>     2. If user was to view a protected view but was rerouted to the
>        login, show the protected view.
>
> 3. Logout will put user back to `login view`, or any other public view
>    which does not require authentication, ie. marketing site.
>

# Where to save the key

There isn't a single answer. Here I'm using `sessionStorage` because
it is **per browser tab** instead of `localStorage` which is
global. Whatever your storage solution is, the auth key needs to be
saved because different view/component would use this storage to
determine whether a key is presented, thus driving its logic what to
render.

# Pseudo code

## Auth logic root view

View itself isn't important. A pseudo code to handle auth is shown
below:

```
get storaged auth key

if kye is not found:
  render login view
else:
  render by routing
```

## Login view

This is where you design the login form/dialog/inputs, and submit
username and pwd to API for authentication.

```
get username & password
POST to API login URL
if success:
  save username & API key to storage
  goto protected landing page
```

## Logout component

```
read storaged username and auth key
Call API logout URL
if success:
  clean storaged info
  goto login page
```

When using `sessionStorage`, make sure you do both the `removeItem(key_name)`
and at last the `.clear()`.

# Routing

1. Login view is at `/login`.
2. Application views are at `/<something>`.
3. `/` is mapped to anything but `/login` &larr; so upon logged in,
   goto `/` will lead us somewhere other than the login[^1].
4. Once logged in, goto `/`.
5. Once logged out, goto `/login`.

## central routing mapping

In `route.js` where REACT routers are defined:

```js
const routes = [
  // auth
  { path: "login", element: <LoginView /> },

  // application specific
  {
    path: "/",
    element: <MainLayout sideNavs={navbar_items} />,

    children: [
      // landing page, default to dashboard
      { path: "/", element: <Navigate to="/dashboard" /> },

      { path: "404", element: <NotFoundView /> },

      // catch all, 404
      { path: "*", element: <Navigate to="/404" /> },
    ],
  },
];

```

## in login

Upon success, `navigate("/")`, thus use the routing above for further
navigation:

```js
// call login handler
const on_submit = async e => {
  e.preventDefault();
  const resp = await login({ user, pwd });

  if (resp.success) {
    set_auth(user, resp.data);
    navigate("/");
  }
};

```

## in logout

Upon logout, `navigate("login")`. Here we can't go to `/` but must use
`/login` because of **disk cache**! &mdash; Goto `/` will route you to
the default landing page. You would expect that landing page will be
reloaded, thus noticing that authenticate info is not there anymore,
thus redirect yet again to `/login`. But because of disk cache,
browser will actually render the landing page just fine (**without
rerendering it**, thus skipping its code)! If you force browser to
reload this landing page again (hold down left `CTRL` then refresh),
it will get you back to login page because now it runs code as if for
the first time, and realizes that authentication info is
missing. Therefore, you **must** goto `/login` upon logout.


```js
// call logout handler
const on_logout = async e => {
  e.preventDefault();
  const resp = await logout();

  if (resp.success) {
    // clear session storage
    session.removeItem("user");
    session.removeItem("api_key");
    session.clear();

    // back to root
    navigate("login");
  }
};

```

[1]: {filename}/dev/react%20key%20authentication%20backend.md

[^1]: We could write in login code  `navigate("/landing")`. But this
    presents two issues: 1. This is hardcoded behavior that logged in
    will always go to this landing page. This is not necessarily the
    case. If user is logging in from `/` view, this is correct
    behavior. But if he was thinking to go `/another/page` and was
    rerouted back to do the login first, he should be sent to
    `/another/page` in the end. This, if you go to `/` at the end of
    login, will be naturally achieved by the routing, instead of you
    writing yet another code to catch his intention, then goto that at
    the end.
