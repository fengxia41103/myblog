#/usr/bin/python

import os
import random
import re
import string
import uuid
import xml.etree.ElementTree as ET
from argparse import ArgumentParser
from subprocess import call
from tempfile import NamedTemporaryFile


def rand_mac():
    return "02:00:00:%02x:%02x:%02x" % (random.randint(0, 255),
                                        random.randint(0, 255),
                                        random.randint(0, 255))


def random_string():
    s = string.lowercase + string.digits
    return ''.join(random.sample(s, 10))


def main():
    XENIAL_16_04 = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img"
    parser = ArgumentParser(description="Create a new KVM for me")
    parser.add_argument("--backing",
                        "-b",
                        nargs="?",
                        default=None,
                        help="Backfile to use when creating a snapshot.")
    parser.add_argument('--user-data',  # user-data file
                        '-u',
                        nargs='?',
                        default="my-user-data",
                        help='Cloud-config user-data file.')
    parser.add_argument('--cloudimg',  # the original cloud img file
                        '-c',
                        nargs='?',
                        default=None,
                        help='A cloud image file.')
    parser.add_argument('--download-cloudimg',
                        '-d',
                        nargs='?',
                        default=XENIAL_16_04,
                        help='URL to download cloud image. The downloaded file will be deleted at the end of this bootstrap.')
    parser.add_argument("xml",
                        help="My XML template.")

    args = parser.parse_args()
    assert(os.path.exists(args.xml))

    tree = ET.parse(args.xml)
    root = tree.getroot()

    # new uuid
    for id in root.iter("uuid"):
        id.text = str(uuid.uuid4())

    # new name
    for name in root.iter("name"):
        name.text = random_string()

    # new mac address
    for interface in root.findall(".//interface"):
        if interface.get("type") == "network":
            for mac in interface.iter("mac"):
                mac.set("address", rand_mac())

    # get base image to use
    base = get_backing_img(args.backing,
                           args.cloudimg,
                           args.download_cloudimg)

    # new snapshot as disk file
    for disk in root.findall(".//disk"):
        for source in disk.iter("source"):
            f = source.get("file")
            if f.endswith(".snap"):
                source.set("file", snapshot(base))
            elif f.endswith("seed.img"):
                source.set("file", cloud_config_seed(args.user_data))

    # write xml and virsh create
    with NamedTemporaryFile(delete=True, mode="wt") as f:
        tree.write(f.name)
        call("sudo virsh define %s" % f.name, shell=True)
        call("virsh create %s" % f.name, shell=True)
        call("virsh list", shell=True)


def get_backing_img(backing, cloud_img, cloud_img_url, add_size=20):
    """Create a backing file served as base image.

    This image is a resized cloud image. Default cloud image, eg.
    xenial 16.04 amd64 server, only allows a virtual size of 2.2G.
    We need to resize it to +20G so we can have space to grow.

    Args:
      backing (str): Backing file.
      cloud_img (str): Cloud image file.
      cloud_img_url (str): URL to cloud image.
      add_size (int): Add `add_size`GB of `virtual size` to the cloud image.

    Returns:
      backing file (str): Resized backing file full path.
    """

    # if user specified a backing file, use it
    if backing and os.path.exists(backing):
        return os.path.abspath(backing)

    # Ok, we have a more to do:
    # 1. download cloud image, called it `xenial.img`.
    # 2. resize `xenial.img` in-place
    # 3. make a copy, `xenial.img` --> `orig-copy.qcow2`
    # 4. resize disk of `orig-copy.qcow2` and write to `mybacking.img`.

    if not cloud_img or (cloud_img and not os.path.exists(cloud_img)):
        call("aria2c -j 10 %s" % cloud_img_url, shell=True)
        cloud_img = cloud_img_url.split("/")[-1]

    call("qemu-img resize %s +%dG" % (cloud_img, add_size), shell=True)
    call("cp %s orig-copy.qcow2" % cloud_img, shell=True)
    call("sudo virt-resize --expand /dev/sda1 orig-copy.qcow2 %s" % cloud_img,
         shell=True)
    return os.path.abspath(cloud_img)


def cloud_config_seed(user_data):
    """Create a cloud-config file.

    Returns:
      seed file (str): the `seed.img`.
    """
    assert(os.path.exists(user_data))
    seed_name = "%s.img" % random_string()
    call("cloud-localds -m local %s my-user-data" % seed_name, shell=True)
    return os.path.abspath(seed_name)


def snapshot(base):
    """Create a backfile snapshot.

    Args:
      base (str): Image file used as backfile.
      name (str): Snapshot file name, append `.snap`.
    Returns:
      snapshot name (str): Absolute path of the created snapshot file
        name.  This file is used as disk image.
    """
    snapshot_name = "%s.snap" % random_string()
    call("qemu-img create -f qcow2 -b %s %s" % (base, snapshot_name), shell=True)
    return os.path.abspath(snapshot_name)

if __name__ == "__main__":
    main()
