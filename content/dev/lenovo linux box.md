Title: Linux laptop
Date: 2017-10-04 22:19
Slug: linux laptop
Author: Feng Xia
Modified: 2019-10-17 10:11


Instructions to get Ubuntu Xenial & Bionic (or any Linux) as your laptop OS.

# Install Linux

You can do a dual boot or just wipe the whole disk. Window's boot
manager will interfere, somehow, which I don't remember the details
anymore. Google it. Eventually it will work. The rest assumes you have
Linux installed.

Also, follow [these steps][6] to get your Linux in a good shape.

# VPN

Most importantly, you need VPN.

1. Go to `otp.company.com` to register your phone number.
2. Install `Company OTP` from your app store.
3. Keep `Company OTP` app running so you can see the active OTP.
4. `apt install openconnect screen tmux`
5. In a screen, `sudo openconnect -u [username] webvpn.us.company.com`

    1. first password: your regular domain login pwd
    2. second one: OTP

If works, you should see something like this:

```shell
root@fengxia-company:~# openconnect -u fxia1 webvpn.us.company.com
POST https://webvpn.us.company.com/
Attempting to connect to server 104.232.254.247:443
SSL negotiation with webvpn.us.company.com
Connected to HTTPS on webvpn.us.company.com
Got HTTP response: HTTP/1.0 302 Object Moved
GET https://webvpn.us.company.com/
Attempting to connect to server 104.232.254.247:443
SSL negotiation with webvpn.us.company.com
Connected to HTTPS on webvpn.us.company.com
Got HTTP response: HTTP/1.0 302 Object Moved
GET https://webvpn.us.company.com/+webvpn+/index.html
SSL negotiation with webvpn.us.company.com
Connected to HTTPS on webvpn.us.company.com
Please enter your username and password.

Password:  <--- A/D password
Password:  <--- OTP

POST https://webvpn.us.company.com/+webvpn+/index.html
Got CONNECT response: HTTP/1.1 200 OK
CSTP connected. DPD 30, Keepalive 30
Connected tun0 as 10.38.102.28, using SSL
Established DTLS connection (using GnuTLS). Ciphersuite (DTLS0.9)-(RSA)-(AES-256-CBC)-(SHA1).
```

A list of VPN servers:

- `webvpn.cn.company.com`   for China user
- `webvpn.hk.company.com`   for AP region user
- `webvpn.us.company.com`   for AG region user
- `webvpn.sk.company.com`   for EMEA user​    

# Email

These settings work for Thunderbird. Terminology may be different for
other clients.

Incoming (IMAP) settings:

   1. server: `outlookae.company.com`, port `993`
   2. username: your domain login
   3. connection security: `SSL/TLS`
   4. authentication method: `Normal password`

Outgoing (SMTP) settings:

   1. server: `mailae.company.com`, port `587`
   2. connection security: `STARTTLS`
   3. authentication method: `NTLM`
   4. username: domain login

Alternatively, use [mbsync w/ Davmail][3].

# Lync

A couple options: [skype for business][1], [pidgin-sipe][2].


## pidgin

**DON'T use the stock package!** It will not work. And don't follow
[this instruction][4], either.  The only way to get it working is
[this][2] to install `pidgin pidgin-sipe`, then add configuration
listed below!

1. add ppa: `add-apt-repository ppa:sipe-collab/ppa`
2. `apt update && apt install pidgin pidgin-sipe`
2. `snap install remmina` 

Create a new account with these settings:

1. protocol: `Office Communicator`
2. username: `you@company.com`
3. password: domain password
4. connection type: `Auto`
5. user agent: `UCCAPI/16.0.6001.1073 OC/16.0.6001.1073 (Skype for Business)`
6. authentication scheme: `NTLM`
7. remote desktop client: `remmina` (or `xfreerdp`)

Leave everything else as default/blank.

[1]: https://www.skype.com/en/download-skype/skype-for-computer/
[2]: https://launchpad.net/~sipe-collab/+archive/ubuntu/ppa
[3]: {filename}/dev/mbsyc.md
[4]: http://sipe.sourceforge.net/install/
[5]: {filename}/dev/my%20system.md
