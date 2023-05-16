Title: Fullstack deployment: nginx, dotenv
Date: 2023-05-16 08:47
Tags: dev
Slug: fullstack deployment nginx dotenv
Author: Feng Xia

<figure class="col l6 m6 s12">
  <img src="images/architecture_joke.jpg"
       class="center img-responsive">
</figure>

Deployment a fullstack requires multiple **special treatments**. First
of all, the overall umbrella is the separation of configs by the
deployment targets, eg. dev/test/prod. Nature of these targets in
practice are quite different. Here I'm identifying some common tasks.

## nginx.conf

I use `nginx` for both the backend & frontend. It serves three purposes:
serve static/media files, frontend (eg. bundled React), and backend proxy.

### http vs. https

In dev it's usually a http, but in production it's always
`https`. When using https, use this config. The key is the `.pem`
which, if using Azure VM as the host, would have these key files
already. If you are building your own host, you need to generate these
`.pem` yourself.

```
server {
  listen 8443 default_server ssl http2;
  listen [::]:8443 ssl http2;

  ssl_certificate /etc/nginx/waagent/TransportCert.pem;
  ssl_certificate_key /etc/nginx/waagent/TransportPrivate.pem;

  location ....
}
```

Assuming the `.pem` is from the docker host, you just need to mount
them to `/etc/nginx/...` inside the nginx docker via `docker-compose`.

### proxy backend

Main use of nginx is to proxy backend. Three pieces needed.

First, define an `upstream`, which is the backend app itself. Here
it's in a docker named `web` and on the docker's port `8001`:


```
upstream django {
  # must be your docker host IP, `localhost` won't work!
  server web:8001;
}
```

Second, in `location /` block, define `try_files`. `nginx` will try
serve the request as much as it can, for example the static files, and
will fallback to `@proxy_to_app`, then to 404 if all fails, cool!

```
  location / {
    ....
    try_files $uri @proxy_to_app $uri/ =404;  <=== !!
  }
```

Last, link proxy to `upstream`:

```
  location @proxy_to_app {
    proxy_pass http://django;  <=== link to upstream
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_redirect off;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Host $server_name;
  }
```

### serve static/media files

You need two pieces for serving these type of files: `root` which
defines the path on the file system where these files are stored, and
`location` which defines uri pattern to match.

```
root /var/www/html;

location /static/ {
  autoindex on;
  alias /path/to/another/place;
}

location /media/ {
  autoindex on;
}

# root ONLY!!
location = / {

}

# catch all domain
location / {
  ....
}
```

Three things:

1. Here `root /var/www/html` is telling `nginx` that the file system
   folder for storing these files is `/var/www/html`. This could be
   changed to any other folder one chooses. Now when serving uri
   `/media`, nginx will look for the file under `<root>/media/`.

2. This file storage value can be overridden using the `alias` per
   location. Therefore, as shown above, you could serve the static
   files from `/path/to/another/place` instead of the
   `<root>`. Further, you could capture value from uri regex, and use
   it to compose a path **dynamically**:

      ```
      location ~ ^/myapp/([a-zA-Z0-9_-]+)/(.*)$ {
       alias /var/lib/myapp/$1/static/$2;
       autoindex on;
      }
      ```

3. `nginx` matches uri from top down, but will use the
   longest matched one.

### match exactly

If you want to match a uri **exactly**, use `location = <uri>`. For
example, `location = /` will match only the `<domain>/`, not
`<domain>/user/1`. W/ this you could control exactly the nginx
behavior.


### trailing slash

Location ends w/ a slash. This is to force a permanent 301
redirect. This is significant when you define django URL
`APPEND_SLASH` which is default to `True`. In other words, be
consistent between your proxied django app's url and other urls in
nginx, using either all ending slash, or not. For me I opt to use
ending slash throughout.

> If a location is defined by a prefix string that ends with the slash
> character, and requests are processed by one of proxy_pass,
> fastcgi_pass, uwsgi_pass, scgi_pass, memcached_pass, or grpc_pass,
> then the special processing is performed. In response to a request
> with URI equal to this string, but without the trailing slash, a
> permanent redirect with the code 301 will be returned to the requested
> URI with the slash appended. If this is not desired, an exact match of
> the URI and location could be defined like this:
>
> ```
> location /user/ {
>     proxy_pass http://user.example.com;
> }
>
> location = /user {
>     proxy_pass http://login.example.com;
> }
> ```
>

## React `.env`

If I have a React frontend, how to parameterize it so that I could
deploy a frontend coupling w/ a specific backend but **without
changing code**!?  The answer is [`.env`][1] file.

> The environment variables are embedded during the build time. Since
> Create React App produces a static HTML/CSS/JS bundle, it can’t
> possibly read them at runtime. To read them at runtime, you would need
> to load HTML into memory on the server and replace placeholders in
> runtime, as described here. Alternatively you can rebuild the app on
> the server anytime you change them.
>
> Note: You must create custom environment variables beginning with
> `REACT_APP_`. Any other variables except NODE_ENV will be ignored to
> avoid accidentally exposing a private key on the machine that could
> have the same name. Changing any environment variables will require
> you to restart the development server if it is running.
>
> These environment variables will be defined for you on
> process.env. For example, having an environment variable named
> REACT_APP_NOT_SECRET_CODE will be exposed in your JS as
> `process.env.REACT_APP_NOT_SECRET_CODE`.
>

So now I define `.env.dev` and `.env.prod`, and specify the backend's
IP in it:

```shell
# .env.dev:

REACT_APP_HOST_URL=http://192.168.68.106:8003

# .env.prod:

REACT_APP_HOST_URL=https://104.208.79.231:8443
```

Then in REACT code, I read this value in and provide it in a global context:

```javascript
import { createContext } from "react";

const GlobalContext = createContext({
  backend: {
    api: `${process.env.REACT_APP_HOST_URL}/api/v1`,
    host: process.env.REACT_APP_HOST_URL,
  },
});

export default GlobalContext;
```

Now, if to build a frontend coupling w/ backend at `192.168...`, I do
a symlink `.env -> .env.dev`, then `npm build`. This version of the
frontend can then be deployed to any web server, and it will use use
the `192.168..` backend. Similarly, if I build one using `.env.prod`,
then I have one using the `104.208..` backend. With these, I have 3
benefits:

1. Can build a frontend w/ any backend w/o changing frontend code.
2. Can deploy frontend to any web server, eg. s3, nginx
3. Can release and scale backend and frontend independently.

## docker-compose `.env`

To define `env` variables in `docker-compose` such as DB credentials,
you can either define them directly in the compose. The downside of
this approach is that sensitive values are saved in git, and a dev
using this same file but different value would have to make
modifications directly, and usually these changes got checked in git
also which then causes conflict.

```yml
environment:
  HTTP_TYPE: http
  HOST_SERVER: 192.168.68.110:8003
  PYTHONUNBUFFERED: 1
  DJANGO_DEBUG: 1 # 0 or 1
  MYSQL_DATABASE: chinesevisaexpress
  DEPLOY_TYPE: dev # dev or prod
  DJANGO_DB_USER: sldkjflsdj
  DJANGO_DB_PWD: sdkjflsj
  DJANGO_DB_HOST: db
  DJANGO_DB_PORT: 3306
  DJANGO_REDIS_HOST: redis
  DJANGO_SUPERUSER_USERNAME: dlksjldlfjd
  DJANGO_SUPERUSER_PASSWORD: sldkjfljdslkj
  DJANGO_SUPERUSER_EMAIL: feng_xia41103@hotmail.com
```

Or, you define them as `key=val` in `.env`, then `docker-compose` will
read in **automagically**. You can check its effect by `docker-compose
config` which is essentially a populated compose yaml w/ these values
plugged in.

```
# .env

HTTP_TYPE=http
HOST_SERVER=192.168.68.110:8003
MYSQL_DATABASE=ljlsjdlfkjlsfj
DEPLOY_TYPE=dev # dev or prod
DJANGO_DB_USER=sldkjfljs
DJANGO_DB_PWD=sldkjfldsjf
DJANGO_SUPERUSER_USERNAME=sdljkfldsj
DJANGO_SUPERUSER_PASSWORD=dslkjfljdsl
DJANGO_SUPERUSER_EMAIL=feng_xia41103@hotmail.com

# docker-compose

environment:

  HTTP_TYPE: ${HTTP_TYPE}
  HOST_SERVER: ${HOST_SERVER}
  MYSQL_DATABASE: ${MYSQL_DATABASE}
  DJANGO_DB_USER: ${DJANGO_DB_USER}
  DJANGO_DB_PWD: ${DJANGO_DB_PWD}
  DJANGO_SUPERUSER_USERNAME: ${DJANGO_SUPERUSER_USERNAME}
  DJANGO_SUPERUSER_PASSWORD: ${DJANGO_SUPERUSER_PASSWORD}
  DJANGO_SUPERUSER_EMAIL: ${DJANGO_SUPERUSER_EMAIL}
```


[1]: https://create-react-app.dev/docs/adding-custom-environment-variables/
