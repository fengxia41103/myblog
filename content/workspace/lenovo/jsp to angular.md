Title: JSP to Angular
Date: 2019-07-02 13:26
Tags: lenovo
Slug: jsp to angular
Author: Feng Xia

Man, don't I dislike Java!

# how to angular

Top level controller is `mwc`, and is linked at the root `<html>`:

```
./WEB-INF/jsp/administration.jsp:5:<html ng-app="mwc">
./WEB-INF/jsp/login.jsp:6:<html ng-app="mwc">
./WEB-INF/jsp/index.jsp:6:<html ng-app="mwc" lang="en">
./WEB-INF/jsp/exception/500-server-error.jsp:4:<htmll ng-app="mwc" lang="en">
./WEB-INF/jsp/exception/405-method-not-allowed.jsp:4:<html ng-app="mwc" lang="en">
./WEB-INF/jsp/exception/401-unauthorized.jsp:4:<html ng-app="mwc" lang="en">
./WEB-INF/jsp/exception/404-not-found.jsp:4:<html ng-app="mwc" lang="en">
```

# how to include `script` in HTML

Using `/webapp/WEB-INF/jsp/index.jsp`. The key concept is the
[`tile`][1] that is essentially a component equivalent in Angular,
that a piece of code will be _injected_ at this place.  For example,
`<tiles:insertDefinition name="_auth-assets" />` will lookup a tile
named `_auth-assets` in `WEB-INF/tiles.xml`:

```xml
<definition name="_auth-assets"
            template="/WEB-INF/jsp/_auth-assets.jsp" />

```

This in turn imports the `template`, in this example, the
`_auth-assets.jsp`:

```html
<link rel="stylesheet" href="/dist/styles.css"> 
<script src="/dist/vendor.js"></script>
<script src="/dist/auth.js"></script>
<script src="/dist/templates.js"></script>
```

## bundled vs. unbundled

Alternatively, there is a _bundled_ version, essentially a production
build by `webpack` that bears like a [hash][2]:

```html
<link rel="stylesheet" href="/dist/styles.css?hash=a690ab24969fdbeb810a">
<script src="/dist/vendor.js?hash=a690ab24969fdbeb810a"></script>
<script src="/dist/app.js?hash=a690ab24969fdbeb810a"></script>
<script src="/dist/templates.js?hash=a690ab24969fdbeb810a"></script>
```

# how to change `favicon`

`favicon` is the little icon on a browser tab. They are defined in
`/webapp/WEB-INF/jsp/_favicon.jsp`:

```html
<link rel="mask-icon" href="/resources/icons/safari-pinned-tab.svg" color="#828181">
<link rel="apple-touch-icon" sizes="180x180" href="/resources/icons/apple-touch-icon.png">
<link rel="icon" type="image/png" href="/resources/icons/favicon-32x32.png" sizes="32x32">
<link rel="icon" type="image/png" href="/resources/icons/favicon-16x16.png" sizes="16x16">
<link rel="manifest" href="/resources/icons/manifest.json">
<link rel="mask-icon" href="/resources/icons/safari-pinned-tab.svg" color="#828181">
<link rel="shortcut icon" href="/resources/icons/favicon.ico">
<meta name="msapplication-TileColor" content="#ffffff">
<meta name="msapplication-TileImage" content="/resources/icons/mstile-144x144.png">
<meta name="msapplication-config" content="/resources/icons/browserconfig.xml">
<meta name="theme-color" content="#ffffff">
```

and they are injected in HTML as a `<tiles:insertDefinition
name="_favicon" />` in `.jsp.

# how to change HTML Meta

The whole HTML meta section are defined as tile in
`WEB-INF/jsp/_meta.jsp`:

```html
<meta charset="utf-8" />
<meta name="viewport"
      content="width=device-width, initial-scale=1.0">
<meta name="application-name"
      content="ThinkAgile CP">
<meta name="description"
      content=".....""
/>
```

[1]: https://tiles.apache.org/2.2/framework/tiles-jsp/tlddoc/tiles/insertDefinition.html
[2]: https://webpack.js.org/guides/caching/
