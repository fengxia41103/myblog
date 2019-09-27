Title: Gerrit access setup
Date: 2017-1-12 15:00
Tags: lenovo
Slug: gerrit access
Author: Feng Xia
Status: Draft


# Gerrit access

Accessing Gerrit involves setting up user account on the VM server
itself and an account on Gerrit. The two are linked via the same SSH
public key you will use.

  > VM server: gerrit.labs.lenovo.come
  
Step 1. Create a VM user account: login VM server (username: *feng*, password: *feng*)

```shell
$ sudo -i --> password: feng
$ useradd -m [user name] --> create user and home directory
$ passwd [user name] --> change user password

Logout and test:
$ ssh [user name]@gerrit.labs.feng.com
```

Step 2. Create a [SSH public key][4]. You can first look in _~/.ssh/_ for _id\_rsa.pub_ file. If it exists, you already have a public key to use.

[4]: https://help.github.com/articles/connecting-to-github-with-ssh/

Step 3. Copy the key file to VM server.

```shell
$ scp ~/.ssh/id_rsa.pub [user name]@gerrit.labs.feng.com:

Logon to the VM server:
$ touch ~/.ssh/authorized_keys
$ cat ~/id_rsa.pub >> ~/.ssh/authorized_keys

Logout and test:
$ ssh [user name]@gerrit.labs.feng.com
```

Step 4. Setup Gerrit user. Browse _http://gerrit.labs.feng.com:8080_. 

1. If you don't have an OpenID, follow the link at the bottom to *Get OpenID".
2. If you already have one, click _Sign in with a Launchpad ID_.
  
<figure class="row">
    <img class="img-responsive center" src="images/gerrit%20openid%20ubuntu%20redirect.png" />
    <figcaption>Gerrit OpenID login Ubuntu redirect</figcaption>
</figure>

Step 5. Set up a Gerrit user name (eg. "*demouser*"). In Gerrit, go to user settings and create a user name for yourself. 
  > 1. This name is permanent.
  > 2. It doesn't have to be the same as your VM's user name.
  
<figure class="row">
    <img class="img-responsive center" src="images/gerrit%20user%20setting%20username.png" />
    <figcaption>Setup Gerrit user name</figcaption>
</figure>

Step 6. Setup SSH access. Als on user setting, paste in the content of _id\_rsa.pub_ from step 2.

<figure class="row">
    <img class="img-responsive center" src="images/gerrit%20user%20setting%20ssh%20key.png" />
    <figcaption>Setup Gerrit user SSH public key</figcaption>
</figure>

```shell
Test Gerrit user setup:

$ ssh -p 29418 [gerrit user name, eg. demouser]@gerrit.labs.feng.com gerrit ls-projects
```

If you get an error, add _-oKexAlgorithms=+diffie-hellman-group1-sha1_ per [OpenSSH][5] instruction.

```shell
Unable to negotiate with 10.240.43.177 port 29418: no matching key exchange method found. Their offer: diffie-hellman-group1-sha1

$ ssh -p 29418 -oKexAlgorithms=+diffie-hellman-group1-sha1 fengxia41103@gerrit.labs.feng.com ....
```

[5]: https://www.openssh.com/legacy.html
