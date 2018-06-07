Title: Use RHEL server qcow2 as sandbox
Date: 2018-04-16 00:00
Tags: lenovo
Slug: use rhel server qcow2 as sandbox
Author: Feng Xia


The closest thing RHEL has to a cloud image is a qcow (download from
[here][1]). This image has disabled root password, and disabled SSH
access &larr; so what the heck!?

[1]: https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.5/x86_64/product-software

# Method 1: modify image directly

Really ugly solution. Anyway. On a Ubuntu 16.04, install `guestfish`
and `libguesttools`, then:

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
        ><fs> vi /etc/ssh/sshd_config
        ```
   
Now replace the "!!" on line `root:...` with your password, save,
and `quit` from guetfish terminal. You are done.
