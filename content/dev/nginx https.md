Title: Nginx Https
Date: 2023-03-19 16:16
Tags: thoughts
Slug: nginx https
Author: Feng Xia

<figure class="col s12">
  <img src="images/DSC_0820.JPG"/>
</figure>

In my development this is a common scenario that I have a stack up and
running on a server which has an IP but no domain. This creates a
problem for getting a cert using [certbot][1]. Instead, on Azure VM
there is already a folder called `waagent` which has a cert. So the
idea is to use the same cert for HTTPs.

First, define the django application as an `upstream`. Here the
`web:8001` is that the django docker service is named `web` (in
`docker-compose`) and on port `8001` of this web docker.

```conf
upstream django {
  # must be your docker host IP, `localhost` won't work!
  server web:8001;
}
```

Second, serve as the proxy for upstream `django`. This snippet lives
inside a `server {.... }`. Here we define the location as
`@proxy_to_app`, important!! This will later be used in `redirect` section.

```conf
location @proxy_to_app {
  proxy_pass http://django;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";

  proxy_redirect off;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Host $server_name;
}
```

Third, the https piece. Again these live inside a `server {...}`.
We are listening to port `8443` of the host server (**therefore, you
need to add networking rules to allow port 8443 traffic by
azure/aws**!), and the certs are the ones I mentioned earlier which
you can find in azure's vm itself &larr; this is the main trick!

```conf
listen 8443 default_server ssl http2;
listen [::]:8443 ssl http2;

ssl_certificate /etc/nginx/waagent/TransportCert.pem;
ssl_certificate_key /etc/nginx/waagent/TransportPrivate.pem;
```

Fourth, catch all to redirect! So up to the section above, if you type
in `https://<ip>:8443`, you should hit your django app. If you ommitt
8443, for example, or typed `http://` instead of `https://`, this
redirect will come into effect. Notice that it says `try_files $uri
@proxy_to_app;`, and the `@proxy_to_app` is the named block of django
app we defined earlier! So this is saying that any traffic hitting `/`
(if not matched earlier because nginx matches url pattern in order)
will be redirected to `@proxy_to_app`, just what we want:

```conf
location / {
  add_header Access-Control-Allow-Origin "*";
  add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS, PUT, PATCH, DELETE';
  add_header Access-Control-Allow-Headers 'X-Requested-With,Accept,Content-Type, Origin';
  try_files $uri @proxy_to_app;
  keepalive_timeout 0;
}
```

Last, any url pattern other than `/` should be put before the `/`
block so to give them a chance to match. This is used for nginx
serving static files such as media (your uploaded files) and css/js
stuff. For example, here we are using nginx to serve `/static/` and
`/media/` before it goes to the catch all `/`. **Note** that location
must have the **trailing slash**!!!!

```conf
location /static/ {
  root /var/www/html;
  autoindex on;
}

location /media/ {
  root /var/www/html;
  autoindex on;
}

location / {
 ...
}
```

So to piece all these together, this is a `nginx.conf` I use in
production to serve https:

```conf
upstream django {
  # must be your docker host IP, `localhost` won't work!
  server web:8001;
}

server {
  listen 8443 default_server ssl http2;
  listen [::]:8443 ssl http2;

  ssl_certificate /etc/nginx/waagent/TransportCert.pem;
  ssl_certificate_key /etc/nginx/waagent/TransportPrivate.pem;


  location /static/ {
    root /var/www/html;
    autoindex on;
  }

  location /media/ {
    root /var/www/html;
    autoindex on;
  }

  location / {
    add_header Access-Control-Allow-Origin "*";
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS, PUT, PATCH, DELETE';
    add_header Access-Control-Allow-Headers 'X-Requested-With,Accept,Content-Type, Origin';
    try_files $uri @proxy_to_app;
    keepalive_timeout 0;
  }

  location @proxy_to_app {
    proxy_pass http://django;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_redirect off;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Host $server_name;
  }
}
```

And the very last, to make the `waagent` available to nginx, we mount
them in `docker-compse`, together with nginx config, static file
folder, media folder:

```yml
backend-proxy:
  image: nginx
  restart: always
  ports:
    - "8443:8443"
  volumes:
    - ./waagent:/etc/nginx/waagent/:ro
    - ./backend/nginx.prod.conf:/etc/nginx/conf.d/default.conf:ro
    - ./backend/staticfiles:/var/www/html/static:ro
    - ./media:/var/www/html/media
  depends_on:
    - web
  command: [nginx-debug, '-g', 'daemon off;']
  networks:
    - management
```



[1]: https://certbot.eff.org/
