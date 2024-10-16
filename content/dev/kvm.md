Title: KVM
Date: 2017-10-11 14:41
Tags: lenovo
Slug: kvm
Author: Feng Xia
Modified: 2022-02-04

[KVM][1] is something new to me, and it sounds awesome. The experience
I want to have is a local dev that I can copy & paste from some base
image in case I forgot to take a snapshot at milestone. This way I
feel comfortable to stand up a sandbox, try out crazy things, then
discard it entirely at done, and repeat. So this means something
minimal, fast.

[1]: https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine

First thing first, get `kvm` and a few tools:

```shell
$ apt kvm libvirt-bin bridge-utils cloud-utils cloud-init libguestfs-tools
```

# Cloud image

Don't bother with full blown `.iso`, use cloud images,
eg. [xenial 16.04][2], my de faco at writing. It's &lt; 300M
and boots fast. Key to know at this point is the file format &larr;
use `qemu-img info [.img]` for `file format:`.

[2]: https://cloud-images.ubuntu.com/releases/16.04/release/

```shell
$ wget [.img url]

To get file format:
$ qemu-img info [.img]
---------------------
image: xenial-server-cloudimg-amd64-disk1.img
file format: qcow2
virtual size: 2.2G (2361393152 bytes)
disk size: 277M
cluster_size: 65536
Format specific information:
    compat: 0.10
    refcount bits: 16
```

## Resize disk

One caveat caught me is that snapshot using [backing file][3] inherits
the maximum disk space from its base image. Looking at the output
above, `virtual size` (`2.2G`) is the maxium disk space this image can
grow to; `disk size` is just the `.img` file's size on disk when you
do `ls -lh`. We want to increase base image's virtual size and here is
how-to.

[3]: https://wiki.qemu.org/Documentation/CreateSnapshot

1. Resize original image <span class="myhighlight">in
   place</span>. This will add `20G` to `virtual size`. But this is
   not sufficient, the _disk_ inside this image needs to be _expanded_
   also (see step #3 below). So think of this step as a _wish_ to the disk
   size I want to have, and step 3 is the actual implementation to
   make it a reality.

    ```shell
    $ qemu-img resize orig.img +20G
    $ qemu-img info orig.img <-- confirm new "virtual size"
    ```

2. Make a copy:

    ```shell
    $ cp orig.img orig-copy.qcow2
    ```

3. Resize disk **inside** the qcow2 image, and save (in this case, we
save newly expanded image back to `orig.img`, but you can save to any
file name you want.):

    ```shell
    $ sudo virt-resize --expand /dev/sda1 orig-copy.qcow2 orig.img
    ```

# Backing files

[Backing files][3] is awesome! The idea is also referred as _external
snapshots_. A few useful references to understand this concept
&mdash; [Advanced snapshots w/ libvirt][4] by
Redhat, [QEMU snapshot doc][3], and a [blog][5] whose diagram I'm
copying below which explained well what these snapshots are related.
In a nutshell, external snapshot keeps a _pointer_ to its base image
(**backing files**). Any new writes will then be applied to the
snapshot image, not the backing file &rarr; this feels like git
commits and branches, isn't it?


[4]: https://kashyapc.fedorapeople.org/virt/infra.next-2015/Advanced-Snapshots-with-libvirt-and-QEMU.pdf
[5]: http://blog.programster.org/kvm-creating-thinly-provisioned-guests

> An example diagram is shown below in which 3 guests are cloned from a
> base image, which is then updated, and a 4th guest is then cloned off
> the updated base image. With all 5 virtual machines, the storage needs
> is only about 4.4 GB (the size of the base image).An example diagram
> is shown below in which 3 guests are cloned from a base image, which
> is then updated, and a 4th guest is then cloned off the updated base
> image. With all 5 virtual machines, the storage needs is only about
> 4.4 GB (the size of the base image).
>

<figure class="center-align responsive-image">
  <svg xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink" width="389px"
  height="509px" version="1.1" content="<mxfile
  userAgent=&quot;Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36
  (KHTML, like Gecko) Chrome/56.0.2924.88 Safari/537.36
  Vivaldi/1.7.735.46&quot; version=&quot;6.2.4&quot;
  editor=&quot;www.draw.io&quot;
  type=&quot;device&quot;><diagram>7Vzfc6o4FP5rnNl9aIcQQHy8dnvv7sOd2Znuj3sfI0TMFIkTYrX7128iAQlBxArYVu1D5RCS8J3vnHxJwBF8WG6/MbRafKchjke2FW5H8LeRbQPxEf+k5TWzjG0vM0SMhKrQ3vBE/sPKaCnrmoQ41QpySmNOVroxoEmCA67ZEGN0oxeb01hvdYUibBieAhSb1n9JyBeZ1c/vQtp/xyRa5C0Db5KdmaHgOWJ0naj2Rjac7z7Z6SXK61I3mi5QSDclE3wcwQdGKc++LbcPOJbY5rBl1309cLboN8MJb3OBnV3wguK1uvW/Z+uEr4UNePeWI/5/W+OUy+OR7aHlagSnySyV/8RxLBqZhuRFfI3kV/9e1va9OCUaLp1Vt8xfc5g53kr7gi9jYQDia8oZfcYPNKZMWBKaiJLTOYnjignFJErEYSDuEwv79AUzToQDv6gTSxKGspnpZkE4flqhQLa5EXSVFdKEf0VLEkt6/oNZiBKkzIqLwM6PVW+Vv2QzeHsQbFC4UIQGpkvM2asooi5wVSUqKHw3O9zsGTZRJRYlcuVXIcXpqKh371fxRbm23s2wvZvtm1vPcyvInTiAX532foU3v57nV2gNF6+u4VfDGXKUkeAwyhEnVIIoegOnYkjkiCQS5Z2LDgKhxk40y2u0TgVo4urEhybxaxGyYQcQee0h6hQS9xTO3Lk1kDh1kPgdQDI+Dom4QGioQ4FWiuxyEEsR4wc4CIyIF2dmvuu4kngRQyERMJWvyqSPSdJC9jS6owy71wg7gL5ORWDi7tXA7nWAut8f6iHC/rwWdS/w8Wx+KdQHQHXSI6ou9kOnDlXfnkHP6xO5C/Azb6qXtODKv1qC7j4DQFkk6SGgNPXWFAnYbMuQXX/h5SpGXJ77Yylnm8cnT7849zvBNv31WvXYkSRv6XrDNfUYgK7p+S4EGThBkQ2owICjQ+IPKTdACwn2YfUGaNZ5lxQcoEedd3HFcQj3IXDtU8kNoTkOYXcJjvao3wYRHUewHFJ11Kze3VRHl6tAR1L9BWVHzQLfJxpiG2G3faiPsDXLqr1FXAu193FH2Ga2H1eUvY0ZoAXqSfhF7u/JLBKjNCWBDra4S/b6Q4b+vZsf/txlAnGwJbx0Shz9zK8KI5znDMr4gkY0QfHj3joN1uwFhxrM8qJmkEXP6ZoFWI9ljliEeZlojWrHrUE7tzEskj150btR5wLVwp+UJLwUYkD39Z1d8WLWfXXV3pFmRZ5eUXV9N7tlox7hSfRaKraSBdKG/kK9GWNz80j5XADt+Zj1YM/OwgXt0kSblZUbYW+EfTeE7XHGPswM56Sxa0jJAOzrywXNy3V2RTeDmilTU644IS24lTCrhnPbtACqO5rV/HIgL7wlFK9Q7Nz4cgZf+tzcHWRB5aTUDa0BU7e5vvLpQ3Hc7I0WT3a881BsK+neEopXONTf+HIGX9rsK7xjvrSbE560tlcd6mt2Jrrhy7jyPBaw3soXu1JTtS+fdcrYZiPnI5O3eKS/LXk9nQhOX9QtgiL3bLWKttR16zvcfaLLU+in5cr4VK5UoK95GvR9c8Wop0OymBPg267mYM+2G47Oh5EhdjVhGwF9HbuazoDzXNjpPFdLzkVC/pGXU8k5O/PGfJvzpD28EOjw9phxPf0BMKc6rLbeigB6RXDSX8o1nyZYr0KRWNNrT4fFclPD8lNv7+b1+LDBfI69+mwYjiczy7rAyt6gGc/c7zr4fpxzez/uPHFb59jeYuYzv+p0moJwbVO59RZPF1vJaqEgcrWgKYizl6ac3pYyq3ND8EYBASpjl1P1dIcCotPFoI4VZK3/T56xQ7uiIL2+/H+wpVMJUK3IqTKpOwLkIrdEAIZReEeTWGKYJmiVLqj6tYjrHh2h8TDKcK+PO+baygE3mfF75W5yBnzL3zHXQYI12/XctkKSPsuy2YKXtWFkN0+zIipzHL2/OU6fN7s1A3VHjhOH+1/kybLm/meP4OP/</diagram></mxfile>"><defs><linearGradient
  x1="0%" y1="0%" x2="0%" y2="100%"
  id="mx-gradient-f8cecc-1-ffffff-1-s-0"><stop offset="0%"
  style="stop-color:#f8cecc"></stop><stop offset="100%"
  style="stop-color:#ffffff"></stop></linearGradient><linearGradient
  x1="0%" y1="0%" x2="0%" y2="100%"
  id="mx-gradient-dae8fc-1-ffffff-1-s-0"><stop offset="0%"
  style="stop-color:#dae8fc"></stop><stop offset="100%"
  style="stop-color:#ffffff"></stop></linearGradient></defs><g
  transform="translate(0.5,0.5)"><g
  transform="translate(0.5,9.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="88" height="40"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 88px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">Ubuntu
  16.04 Guest 1&nbsp;<div>8.2 MB</div></div></div></foreignObject><text
  x="44" y="26" fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">[Not supported by viewer]</text></switch></g><g
  transform="translate(0.5,114.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="88" height="40"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 88px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">Ubuntu
  16.04 Guest 2<div>8.2 MB</div></div></div></foreignObject><text x="44"
  y="26" fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">[Not supported by viewer]</text></switch></g><g
  transform="translate(0.5,229.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="88" height="40"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 88px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">Ubuntu
  16.04 Guest 3<div>8.2 MB</div></div></div></foreignObject><text x="44"
  y="26" fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">[Not supported by
  viewer]</text></switch></g><ellipse cx="263" cy="140" rx="30" ry="30"
  fill="#000000" stroke="#000000"
  transform="translate(2,3)rotate(90,263,140)"
  opacity="0.25"></ellipse><ellipse cx="263" cy="140" rx="30" ry="30"
  fill="url(#mx-gradient-f8cecc-1-ffffff-1-s-0)" stroke="#b85450"
  transform="rotate(90,263,140)"
  pointer-events="none"></ellipse><ellipse cx="125" cy="30" rx="30"
  ry="30" fill="#000000" stroke="#000000"
  transform="translate(2,3)rotate(90,125,30)"
  opacity="0.25"></ellipse><ellipse cx="125" cy="30" rx="30" ry="30"
  fill="url(#mx-gradient-dae8fc-1-ffffff-1-s-0)" stroke="#6c8ebf"
  transform="rotate(90,125,30)" pointer-events="none"></ellipse><ellipse
  cx="125" cy="140" rx="30" ry="30" fill="#000000" stroke="#000000"
  transform="translate(2,3)rotate(90,125,140)"
  opacity="0.25"></ellipse><ellipse cx="125" cy="140" rx="30" ry="30"
  fill="#d5e8d4" stroke="#82b366" transform="rotate(90,125,140)"
  pointer-events="none"></ellipse><ellipse cx="125" cy="250" rx="30"
  ry="30" fill="#000000" stroke="#000000"
  transform="translate(2,3)rotate(90,125,250)"
  opacity="0.25"></ellipse><ellipse cx="125" cy="250" rx="30" ry="30"
  fill="#f5f5f5" stroke="#666666" transform="rotate(90,125,250)"
  pointer-events="none"></ellipse><path d="M 233 140 Q 185 140 185 85 Q
  185 30 161.37 30" fill="none" stroke="#000000" stroke-miterlimit="10"
  pointer-events="none"></path><path d="M 156.12 30 L 163.12 26.5 L
  161.37 30 L 163.12 33.5 Z" fill="#000000" stroke="#000000"
  stroke-miterlimit="10" pointer-events="none"></path><path d="M 233 140
  Q 233 140 161.37 140" fill="none" stroke="#000000"
  stroke-miterlimit="10" pointer-events="none"></path><path d="M 156.12
  140 L 163.12 136.5 L 161.37 140 L 163.12 143.5 Z" fill="#000000"
  stroke="#000000" stroke-miterlimit="10"
  pointer-events="none"></path><path d="M 233 140 Q 194 140 194 195 Q
  194 250 161.37 250" fill="none" stroke="#000000"
  stroke-miterlimit="10" pointer-events="none"></path><path d="M 156.12
  250 L 163.12 246.5 L 161.37 250 L 163.12 253.5 Z" fill="#000000"
  stroke="#000000" stroke-miterlimit="10"
  pointer-events="none"></path><g
  transform="translate(200.5,59.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="133" height="40"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 133px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">Base
  Ubuntu 16.04 Template Image&nbsp;<div>(4.4
  GB)</div></div></div></foreignObject><text x="67" y="26"
  fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">[Not supported by
  viewer]</text></switch></g><ellipse cx="263" cy="350" rx="30" ry="30"
  fill="#000000" stroke="#000000"
  transform="translate(2,3)rotate(90,263,350)"
  opacity="0.25"></ellipse><ellipse cx="263" cy="350" rx="30" ry="30"
  fill="url(#mx-gradient-f8cecc-1-ffffff-1-s-0)" stroke="#b85450"
  transform="rotate(90,263,350)" pointer-events="none"></ellipse><path
  d="M 263 170 L 263 313.63" fill="none" stroke="#000000"
  stroke-miterlimit="10" pointer-events="none"></path><path d="M 263
  318.88 L 259.5 311.88 L 263 313.63 L 266.5 311.88 Z" fill="#000000"
  stroke="#000000" stroke-miterlimit="10"
  pointer-events="none"></path><g
  transform="translate(270.5,238.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="48" height="12"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 48px; white-space:
  nowrap; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">updates</div></div></foreignObject><text
  x="24" y="12" fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">updates</text></switch></g><ellipse cx="125"
  cy="350" rx="30" ry="30" fill="#000000" stroke="#000000"
  transform="translate(2,3)rotate(90,125,350)"
  opacity="0.25"></ellipse><ellipse cx="125" cy="350" rx="30" ry="30"
  fill="#ffe6cc" stroke="#d79b00" transform="rotate(90,125,350)"
  pointer-events="none"></ellipse><g
  transform="translate(0.5,324.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="88" height="40"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 88px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">Ubuntu
  16.04 Guest 4<div>8.2 MB</div></div></div></foreignObject><text x="44"
  y="26" fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">[Not supported by
  viewer]</text></switch></g><ellipse cx="263" cy="475" rx="30" ry="30"
  fill="#000000" stroke="#000000"
  transform="translate(2,3)rotate(90,263,475)"
  opacity="0.25"></ellipse><ellipse cx="263" cy="475" rx="30" ry="30"
  fill="url(#mx-gradient-f8cecc-1-ffffff-1-s-0)" stroke="#b85450"
  transform="rotate(90,263,475)" pointer-events="none"></ellipse><path
  d="M 233 350 L 161.37 350" fill="none" stroke="#000000"
  stroke-miterlimit="10" pointer-events="none"></path><path d="M 156.12
  350 L 163.12 346.5 L 161.37 350 L 163.12 353.5 Z" fill="#000000"
  stroke="#000000" stroke-miterlimit="10"
  pointer-events="none"></path><path d="M 263 380 L 263 438.63"
  fill="none" stroke="#000000" stroke-miterlimit="10"
  pointer-events="none"></path><path d="M 263 443.88 L 259.5 436.88 L
  263 438.63 L 266.5 436.88 Z" fill="#000000" stroke="#000000"
  stroke-miterlimit="10" pointer-events="none"></path><g
  transform="translate(295.5,126.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="88" height="26"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 88px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">read-only
  snapshot 1</div></div></foreignObject><text x="44" y="19"
  fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">read-only snapshot 1</text></switch></g><g
  transform="translate(295.5,336.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="88" height="26"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 88px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">read-only
  snapshot 2</div></div></foreignObject><text x="44" y="19"
  fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">read-only snapshot 2</text></switch></g><g
  transform="translate(298.5,454.5)"><switch><foreignObject
  style="overflow:visible;" pointer-events="all" width="88" height="40"
  requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"><div
  xmlns="http://www.w3.org/1999/xhtml" style="display: inline-block;
  font-size: 12px; font-family: Verdana; color: rgb(0, 0, 0);
  line-height: 1.2; vertical-align: top; width: 88px; white-space:
  normal; word-wrap: normal; text-align: center;"><div
  xmlns="http://www.w3.org/1999/xhtml"
  style="display:inline-block;text-align:inherit;text-decoration:inherit;">current
  disk image writes go to.</div></div></foreignObject><text x="44"
  y="26" fill="#000000" text-anchor="middle" font-size="12px"
  font-family="Verdana">current disk image writes go
  to.</text></switch></g></g></svg>
</figure>

To create one using backing file:

```shell
$ qemu-img create -f qcow2 -b resized-orig.img mydev.snap
```

To verify:

```shell
(dev) fengxia@fengxia-lenovo:~/workspace/tmp$ qemu-img info mydev.snap
image: mydev.snap
file format: qcow2
virtual size: 22G (23836229632 bytes)
disk size: 3.4G
cluster_size: 65536
backing file: resized-orig.img <<-- here!
Format specific information:
    compat: 1.1
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
```

Then in KVM xml, use `mydev.snap` as your primary disk:

```xml
<disk type='file' device='disk'>
  <driver name="qemu" type="qcow2"/>
  <source file="/home/fengxia/workspace/tmp/mydev.snap"/>
  <target dev='vda' bus='virtio'/>
  <alias name='virtio-disk0'/>
  <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
</disk>
```

# cloud-init

Using cloud images, however, is tricky, because it doesn't allow user
login (SSH only) and is expecting a [`cloud-init`][6]. Without it,
snapshots we made above will boot, but you can't login (tried "ubuntu,
passw0rd", "ubuntu, ubuntu", "ubuntu, [no password]", none works).

To use [cloud-init][6], we need to create a `user-data` file which
is actually a `cloud-config` in YAML format. [cloud-init][6]
can use other [formats][8]. Take a look.
A minimal version of `cloud-config` is shown below, which allows
`ubuntu` user login using the `password` value you defined here, eg. `whatever001`.

[6]: http://cloudinit.readthedocs.io/en/latest/
[7]: http://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html
[8]: http://cloudinit.readthedocs.io/en/latest/topics/format.html#user-data-script

```yaml
#cloud-config
password: whatever001
chpasswd:
  expire: False
ssh_pwauth: True
```

Now how `cloud-init` works? Essentially you make `user-data` into
a disk or iso that <span class="myhighlight">can be mounted</span> to
your VM at boot. Your VM's OS image should have had `cloud-init`
installed (and configured?) so when it boots it will **search for
user-data & meta-data**, and run their instructions.

## cloud-init in raw

```shell
$ cloud-localds -m local my-seed.img my-user-data [my-meta-data]
```

When using `cloud-localds`, make sure to use `-m local` so to enable
the [`NoCloud`][7] data source (otherwise, booting will stuck with
error __url_helper.py[WARNING]: Calling
'http://169.254.169.254/2009-04-04/meta-data/instance-id failed...__
because `cloud-init` by default will expect a server somewhere serving
user-data and meta-data files. `NoCloud` says they are on a local disk).

Example as used in KVM's xml. Make sure `slot=` index is unique,
and `<target dev=` index is unique.

```xml
<disk type='file' device='disk'>
  <driver name='qemu' type='raw'/>
  <source file='/home/fengxia/workspace/tmp/my-seed.img'/>
  <backingStore/>
  <target dev='vdb' bus='virtio'/>
  <alias name='virtio-disk1'/>
  <address type='pci'1 domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
</disk>
```

## cloud-init in ISO
```shell
$ genisoimage --output my-seed.iso -volid cidata -joliet -rock my-user-data [my-meta-data]
```

The key here is `-volid` value <span class="myhighlight">must be `cidata`</span>!
Example KVM xml below. Again, `<target dev=` index should be unique.

```xml
<disk type='file' device='cdrom'>
  <source file='/home/fengxia/workspace/tmp/my-seed.iso'/>
  <target dev='vdb' bus='ide'/>
  <readonly/>
</disk>
```

# Sum it up

So back to our mission &mdash; to use cloud image as base and external
snapshots as our dev sandbox:

1. Download a cloud image
2. Resize image
3. Create a snapshot with backing file
4. Add `.snap` as a disk in kvm xml
5. Create `user-data`
6. Create `seed.img` from user-data
7. Add `seed.img` as a disk in kvm xml
8. `virsh create [your xml]`

Enjoy.

# helper files

Everything you need is [here][9].To start a kvm from scratch. This
will download a [16.04 amd64 cloud image][11] by default.

[9]: http://github.com/fengxia41103/dev/kvm

```shell
$ python startmykvm.py --help

usage: startmykvm.py [-h] [--backing [BACKING]] [--user-data [USER_DATA]]
                     [--cloudimg [CLOUDIMG]]
                     [--download-cloudimg [DOWNLOAD_CLOUDIMG]] [--delete]
                     xml

Create a new KVM for me

positional arguments:
  xml                   My XML template.

optional arguments:
  -h, --help            show this help message and exit
  --backing [BACKING], -b [BACKING]
                        Backfile to use when creating a snapshot.
  --user-data [USER_DATA], -u [USER_DATA]
                        Cloud-config user-data file.
  --cloudimg [CLOUDIMG], -c [CLOUDIMG]
                        A cloud image file.
  --download-cloudimg [DOWNLOAD_CLOUDIMG], -d [DOWNLOAD_CLOUDIMG]
                        URL to download cloud image. The downloaded file will
                        be deleted at the end of this bootstrap.
  --delete, -D          Set to delete VM defined in xml.

```

[11]: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-arm64-disk1.img

To start a kvm reusing an existing backing file:

```shell
$ python startmykvm.py -b <backing>.qcow2 mydev.xml
```

# Migrate to another host

If you need to migrate VM to another host, follow this:

1. `virsh shutdown` the VMs
2. `virsh dumpxml guest_name > guest_name.xml`
3. `scp` four files, for example. Depending on the size of the VM,
   this can take a while.

      ```shell
      -rw-rw-r-- 1 fengxia      fengxia        4919 Feb  4 18:17 x83lvdw0at
      -rw-rw-r-- 1 libvirt-qemu kvm          378880 Feb  4 18:17 x83lvdw0at.seed
      -rw-r--r-- 1 libvirt-qemu kvm     65200717824 Feb  4 21:25 x83lvdw0at.snap
      -rw-rw-r-- 1 fengxia      fengxia        4140 Feb  4 18:56 x83lvdw0at.xml
      ```
4. SSH to the destination host, `virsh define <guest_name>.xml`
5. `virsh list --all`

Now you should see the VM, and `virsh start <guest_name>`.
