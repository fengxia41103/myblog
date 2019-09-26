Title: Juju GUI nginx proxy
Date: 2017-10-22 22:21
Tags: lenovo
Slug: juju gui nginx proxy
Author: Feng Xia


In [LXD on localhost][1] we introduced using
LXD container to bootstrap a Juju controller. 
But how to access the Juju GUI? Launching it is easy
enough with `$ juju gui` from juju host; 
accessing it from anywhere outside
the host is a challenge. One way is through `$ ssh -X` to 
the LXD and launch firefox. 

[1]: {filename}/workspace/openstack/juju%20local%20lxd.md

Another option is to use [`nginx` to proxy][2] the GUI service. The
quirk here is to enable `ssl` proxy (notice the `https`?)

[2]: https://www.nginx.com/resources/admin-guide/reverse-proxy/

<figure class="col s12 center">
  <img src="/images/juju%20gui%20nginx.png"/>
  <figcaption>Juju GUI with Nginx proxy</figcaption>
</figure>


1. Get SSL cert in `/etc/nginx`. This will create two files in this
   directory: `cert.key` and `cert.crt`.

        ```shell
        $ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt
        ```

2. In LXD host, use `$ juju gui` to find out its server address and
   port, for example:

        ```shell
        (dev) fengxia@ubuntu:~$ juju gui
        GUI 2.10.2 for model "admin/default" is enabled at:
        https://10.175.135.193:17070/gui/u/admin/default
        Your login credential is:
        username: admin
        password: 049ab8c2284b3b7fa7e87933df18da15
        ```
    
    So the server's ip is `10.175.135.193` and port `17070`.

2. (Optionally), you can change the Juju password here:

        ```shell
        $ juju change-user-password
        ```
    
2. Create `juju.conf` in `/etc/nginx/site-available`. Note that this
   server listens port `443`!

        ```shell
        map $http_upgrade $connection_upgrade {
         default upgrade;
         ''      close;
        }
        upstream jujugui{
         server 10.175.135.193:17070;
        }
        server {
         listen 443;
         server_name 192.168.122.214; # your IP
         ssl_certificate           /etc/nginx/cert.crt;
         ssl_certificate_key       /etc/nginx/cert.key;
         ssl on;
         ssl_session_cache  builtin:1000  shared:SSL:10m;
         ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
         ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
         ssl_prefer_server_ciphers on;
         location / {
           proxy_pass https://jujugui;
           proxy_set_header    Host            $host;
           proxy_set_header    X-Real-IP       $remote_addr;
           proxy_set_header    X-Forwarded-for  $proxy_add_x_forwarded_for;
           proxy_connect_timeout 300;
           port_in_redirect off;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_read_timeout 86400;
         }
        }
        ```

Reload `$ sudo service nginx reload`, and browse to
`https://[yourip]/gui`, you shall see the Juju GUI.
