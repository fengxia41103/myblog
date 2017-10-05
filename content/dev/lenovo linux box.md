Title: Linux laptop
Date: 2017-10-04 22:19
Tags: lenovo
Slug: lenovo linux laptop
Author: Feng Xia
Status: Draft

Instructions to get Ubuntu 16.04 (or any Linux) as your laptop OS.

# Install Linux

You can do a dual boot or just wipe the whole disk. Window's boot
manager will interfere, somehow, which I don't remember the details
anymore. Google it. Eventually it will work. The rest assumes you have
Linux installed.

# VPN

Most importantly, you need VPN.

1. Go to `otp.lenovo.com` to register your phone number.
2. Install `Lenovo OTP` from your app store.
3. Keep `Lenovo OTP` app running so you can see the active OTP.
4. `apt install openconnect screen`
5. In a screen, `sudo openconnect -u [username] webvpn.us.lenovo.com`

    1. first password: your regular domain login pwd
    2. second one: OTP
   
    If works, you should see something like this:
    <pre class="brush:plain;">
    root@fengxia-lenovo:~# openconnect -u fxia1 webvpn.us.lenovo.com
    POST https://webvpn.us.lenovo.com/
    Attempting to connect to server 104.232.254.247:443
    SSL negotiation with webvpn.us.lenovo.com
    Connected to HTTPS on webvpn.us.lenovo.com
    Got HTTP response: HTTP/1.0 302 Object Moved
    GET https://webvpn.us.lenovo.com/
    Attempting to connect to server 104.232.254.247:443
    SSL negotiation with webvpn.us.lenovo.com
    Connected to HTTPS on webvpn.us.lenovo.com
    Got HTTP response: HTTP/1.0 302 Object Moved
    GET https://webvpn.us.lenovo.com/+webvpn+/index.html
    SSL negotiation with webvpn.us.lenovo.com
    Connected to HTTPS on webvpn.us.lenovo.com
    Please enter your username and password.
    Password:
    Password:
    POST https://webvpn.us.lenovo.com/+webvpn+/index.html
    Got CONNECT response: HTTP/1.1 200 OK
    CSTP connected. DPD 30, Keepalive 30
    Connected tun0 as 10.38.102.28, using SSL
    Established DTLS connection (using GnuTLS). Ciphersuite (DTLS0.9)-(RSA)-(AES-256-CBC)-(SHA1).
    </pre>

    A list of VPN servers:

       - `webvpn.cn.lenovo.com`   for China user
       - `webvpn.hk.lenovo.com`   for AP region user
       - `webvpn.us.lenovo.com`   for AG region user
       - `webvpn.sk.lenovo.com`   for EMEA user​    

# Email

These settings work for Thunderbird. Terminology may be different for
other clients.

Incoming (IMAP) settings:

   1. server: `outlookae.lenovo.com`, port `993`
   2. username: your domain login, eg. `fxia1`
   3. connection security: `SSL/TLS`
   4. authentication method: `Normal password`

Outgoing (SMTP) settings:

   1. server: `mailae.lenovo.com`, port `587`
   2. connection security: `STARTTLS`
   3. authentication method: `NTLM`
   4. username: domain login

# Lync

A couple options: [skype for business][1], [pidgin-sipe][2].

[1]: https://www.skype.com/en/download-skype/skype-for-computer/
[2]: https://launchpad.net/~sipe-collab/+archive/ubuntu/ppa

## pidgin

Follow [instructions][2] to install `pidgin pidgin-sipe`:

   1. add ppa: `add-apt-repository ppa:sipe-collab/ppa`
   2. `apt update && apt install pidgin pidgin-sipe`
   2. `snap install remmina` 

Create a new account with these settings:

   1. protocol: `Office Communicator`
   2. username: `you@lenovo.com`
   3. password: domain password
   4. connection type: `Auto`
   5. user agent: `UCCAPI/16.0.6001.1073 OC/16.0.6001.1073 (Skype for Business)`
   6. authentication scheme: `NTLM`
   7. remote desktop client: `remmina` (or `xfreerdp`)

Leave everything else as default/blank.
