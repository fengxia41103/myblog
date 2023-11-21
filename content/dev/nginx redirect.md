Title: Nginx Redirect
Date: 2023-11-21 10:49
Slug: nginx redirect
Author: Feng Xia


Nginx redirect is a super confusing topic. I have see way too many
blogs and articles and SO posts, each having a specific example of a
sort, but none talks about it **systematically**. So this article is
an attempt to consolidate the information as part of my own study
notes, and provide a clear understanding of how to use these redirects
in nginx.

# Overview

First of all, there are 5 directives who will cause a redirect:  `index`,
`try_files`, `error_page`, `return`, `rewrite`.

Second, there are two types of redirect &mdash; internal &
external. Internal redirect will cause nginx to **re-evaluate**
location block, and browser is not involved. An external redirect is
to send a HTTP code w/ target URL back to the browser, and it's up to
the browser's behavior to decide what to happen next.

Below shows the five directives and their capabilities in term of
internal and external redirect:

<figure class="col s12">
  <img src="images/nginx%20redirect.png"/>
</figure>


## http redirect code

For external redirect, the response will be sent to the browser, thus
it's up to the implementation of the browser to react based on the
http status code. There are some subtle differences of these code.


| Code       | Name               | Description                                                                                      |
|------------|--------------------|--------------------------------------------------------------------------------------------------|
| [301][301] | Moved Permanently  | A browser redirects to the new URL and search engines update their links to the resource.        |
| [302][302] | Found              | A browser redirects to this page but search engines don't update their links to the resource.    |
| [303][303] | See Other          | Redirects don't link to the requested resource itself, but to another page. Always return `GET`. |
| [307][307] | Temporary Redirect | Same as 302 except request method & body is not altered.                                         |
| [308][308] | Permanent Redirect | Same as 301 except request method & body is not altered.                                         |

## internal limit

You will write a redirect loop at some point. Nginx has a safe-guard.

> There is a limit of 10 internal redirects per request to prevent
> request processing cycles that can occur in incorrect
> configurations. If this limit is reached, the error 500 (Internal
> Server Error) is returned. In such cases, the “rewrite or internal
> redirection cycle” message can be seen in the error log.
>
> Ref: [source][internal]


# index

Index is probably one of the oldest Internet concept. I remember my
very first webpage was an `index.html` in a web server folder. Note
that redirect by index is only applicable when we serve a request w/
**ending slash**.

1. Index is referring to a **file** in the `root` directory,
   eg. `index.html`, but could be any file name designated as you
   wish.
2. Serving index is only applicable to request ending with the slash
   character (‘/’). This is **critical** in redirect loop!

3. Index always triggers an internal redirect, so location match are
   evaluated **twice**.

## index modules

There are three nginx modules that will serve a form of an index:

1. [`ngx_http_index_module`][index]: Defined as `index <filename 1>
   <filename 2> ...`. When matched location has trailing slash, index
   is evaluated in order:

      1. If the file is found, redirect to `$uri/<index file>`;
      2. If none is found, redirect to `$uri/<last index value>`.

2. [`ngx_http_autoindex_module`][autoindex]: Defined as `autoindex
   on`. It returns all contents of the doc root.
3. [`ngx_http_random_index_module`][random index]: Defined as
   `random_index on`. It picks a random file in the doc root to serve.

## index definition

Location can inherit and override index.

```[1-2,5]
root /var/www/me;
index index-A.html;

location /path/a/ {}
location /path/b/ {index index-B.html}
```

You can define multiple values, and their **existence** will be tested
in sequence. If it exists, a redirect as `$uri/<index filename>` will
be issued, which then cause a new round of location match.

```
index index.$geo.html index.0.html /index.html;
```

## index redirect

```
root /var/www/A;
index index-A.html;

location = / {}

location / {alias /home/feng;}
```

A request to `http://blah.com/` will:

1. Match `= /` first because the **exact** takes precedence in
   location matching.
2. We are now in the 1st location block. Nginx tests existence of
   `/var/www/A/index-A.html`. If it exists, it issues a **redirect**
   to `/index-A.html`, thus triggering another location match.
3. This time it will match the **2nd block, processed the URI as
   `/index-A.html`**. Since the URI is not ending w/ slash this time,
   index is not evaluated anymore. File `/home/feng/index-A.html` will
   be returned, or 404 if doesn't exist.

# `try_files`

```
location / {
  try_files /system/maintenance.html
            $uri
            $uri/
            $uri/index.html
            $uri.html
            @mongrel;
}
```

Internal redirect only ([doc][try_files]). Multiple values can be
tested using white-space as delimiter. The last uri value will be the
redirect target if all tests fail.


| Value                | Example                               | Test                                                    |
|----------------------|---------------------------------------|---------------------------------------------------------|
| hardcoded filename   | /system/maintenance.html              | Existence of this file in doc root by `root` or `alias` |
| filename w/ variable | $uri, $uri/me.html, $myname-this.html | Existence of file                                       |
| w/ ending slash      | $uri/                                 | Existence of directory                                  |
| named location       | @blah                                 | Existence of a named location block                     |
| =[code\|named]       | =404, =@django                        | **Can only be the last test**, catch-all redirect       |

# error_page

[official doc][error_page]. Both internal and external. If you
redirect to a named location, a proxy could take cover to continue the
process, and it may have its own error handling strategy.

| Example                                | Effect                                                                                |
|----------------------------------------|---------------------------------------------------------------------------------------|
| error\_page 404 /404.html;             | Redirect to `/404.html` for 404 error code.                                           |
| error\_page 500 502 503 504 /50x.html; | Combine error handling to a single uri redirect.                                      |
| error\_page 404 =200 /empty.gif;       | Return status 200 instead of 404. Can map multiple to one.                            |
| error\_page 404 = @fallback;           | Proxy determines what to be returned. URI is passed on as-is.                         |
| error\_page 404 =301 http://...;       | Redirect to another URL. Default to 302. Can map to 301, 302, 303, 307, and 308 only. |

# return

Will terminate any further processing, and send a response to the
browser ([doc][return]). Thus it's usually define the full URL for the
target. If it's using only a uri such as `/photos`, the full URL will
be composed by Nginx based on a couple other directive values.

| Example                                             | Context  | Effect                                |
|-----------------------------------------------------|----------|---------------------------------------|
| return 301 $scheme://www.newdomain.com$request_uri; | Server   | Redirect all requests to a new domain |
| return 301 $scheme://blah.com/here;                 | Location | Redirect to new URL                   |
| return 301 /photos;                                 | Location | Redirect to a URI                     |
| return [http\|https\|$scheme]://blah.com/...        | Location | Imply code 302                        |

# rewrite

Rewrite is the most flexible one since it uses regex. Behavior is
determined by the **flag** ([doc][rewrite]).

| Flag      | Context  | Return Code  | Effect                                                     |
|-----------|----------|--------------|------------------------------------------------------------|
| last      | Server   | n/a          | Internal redirect. Start new location match.               |
| break     | Location | n/a          | Skip other `rewrite` in this `Location` context.           |
| redirect  | n/a      | 302          | Any replacement **not** starting w/ [http\|https\|$scheme] |
| permanent | n/a      | 301          |                                                            |



[301]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/301
[302]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/302
[303]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/303
[307]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/307
[308]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/308
[index]: https://nginx.org/en/docs/http/ngx_http_index_module.html#index
[autoindex]: https://nginx.org/en/docs/http/ngx_http_autoindex_module.html
[random index]: https://nginx.org/en/docs/http/ngx_http_random_index_module.html
[try_files]: https://nginx.org/en/docs/http/ngx_http_core_module.html#try_file
[error_page]: https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page
[return]: https://nginx.org/en/docs/http/ngx_http_rewrite_module.html
[rewrite]: https://nginx.org/en/docs/http/ngx_http_rewrite_module.html
[internal]: https://nginx.org/en/docs/http/ngx_http_core_module.html#internal
