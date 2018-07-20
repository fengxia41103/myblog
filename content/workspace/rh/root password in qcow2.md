Title: Use RHEL server qcow2 as sandbox
Date: 2018-04-16 00:00
Tags: lenovo
Slug: use rhel server qcow2 as sandbox
Author: Feng Xia
Modified: 2018-07-19 22:40

The closest thing RHEL has to a cloud image is a qcow (download from
[here][1]). This image has disabled root password, and disabled SSH
access &larr; so what the heck!?

[1]: https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.5/x86_64/product-software

# Method 1: modify image directly

Really ugly solution. Anyway. On a Ubuntu 16.04, install `guestfish`
and `libguesttools`, then:

## create root password

1. Create a password to use. Note it is "digit 1", not a "l"
   (as in love):
   
        ```shell
        $ openssl passwd -1 natalie
        ```
   
2. Modify the image directly:

        ```shell
        $ sudo guestfish --rw -a rhel-server-7.5-x86_64-kvm.qcow2 
        ><fs> run
        ><fs> list-filesystems
        ><fs> mount /dev/sda1 /
        ><fs> vi /etc/shadow
        ```
   
Now replace the "!!" on line `root:...` with your password you just
created in step 1, save,

## allow ssh root & password

Modify `/etc/ssh/sshd_config` and uncomment two places:
```
><fs> vi /etc/ssh/sshd_config

# Authentication:

#LoginGraceTime 2m
PermitRootLogin yes <--- uncomment
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes <-- uncomment
#PermitEmptyPasswords no
```

## disable cloud-init

This is the single gottcha that held me back for weeks. It turned out
that `cloud-init` has a setting to turn `PasswordAuthentication` back
into `no` even after I have modified `sshd_config`. How wonderful.

```
><fs> vi /etc/cloud/cloud.cfg

users:
 - default

disable_root: 0 <-- set to 0, was 1!!
ssh_pwauth: 1
disable_ec2_metadata: True
datasource_list: [ ConfigDrive, None ]
datasource:
  ConfigDrive:
    dsmode: local

mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
resize_rootfs_tmp: /dev
ssh_deletekeys:   0
ssh_genkeytypes:  ~
syslog_fix_perms: ~

cloud_init_modules:
 - migrator
 - bootcmd
 - write-files
 - growpart
 - resizefs
```

Now `quit` from guetfish terminal. You are done.
