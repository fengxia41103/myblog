Title: Browser proxy
Date: 2019-04-23 14:45
Tags: dev
Slug: browser proxy
Author: Feng Xia

This is a common trick. Say we have local machine (A), and a remote
machine (B). If we can SSH from A&rarr;B, we can reroute browser
traffic from A to B, much quicker than X-windows.

<figure class="col l4 m4 s12">
  <img src="images/browser%20proxy.png"
       class="center img-responsive">
</figure>

1. On A, `ssh -vv -ND 8080 root@<B's IP>`, then SSH login.
   
    1. `-N`: Do not execute a remote command.  This is useful for
       just forwarding ports.`
    2. `-D [bind_address:]port`:

        Specifies a local “dynamic” application-level port forwarding.  This works by
        allocating a socket to listen to port on the local side, optionally bound to
        the specified bind_address.  Whenever a connection is made to this port, the
        connection is forwarded over the secure channel, and the application protocol
        is then used to determine where to connect to from the remote machine.  Cur‐
        rently the SOCKS4 and SOCKS5 protocols are supported, and ssh will act as a
        SOCKS server.  Only root can forward privileged ports.  Dynamic port forward‐
        ings can also be specified in the configuration file.

        IPv6 addresses can be specified by enclosing the address in square brackets.
        Only the superuser can forward privileged ports.  By default, the local port
        is bound in accordance with the GatewayPorts setting.  However, an explicit
        bind_address may be used to bind the connection to a specific address.  The
        bind_address of “localhost” indicates that the listening port be bound for
        local use only, while an empty address or ‘*’ indicates that the port should
        be available from all interfaces.
   
2. On A, open Firefox, and setup proxy as shown below:
  1. Goto `Preferences/networking settings`.
  2. `Manual proxy configuration`
  3. `SOCKS Host` to `localhost`, and port to `8080` (whatever the
     port you set above).
  4. Select `socks v5`.
  5. Clear `No proxy for`, because sometimes `localhost` and
     `127.0.0.1` are listed. We want to use `localhost`!
 
<figure class="col s12">
  <img src="images/browser%20proxy%20firefox%20setting.png"
       class="center img-responsive">
  <figcaption>Setting up proxy in Firefox</figcaption>
</figure>
 
This is it. Then anything on this browser will be routed to localhost
port 8080, which by the `ssh`, will be forwarded to B.

