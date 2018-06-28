Title: Server RAID
Date: 2018-06-27 23:54
Tags: lenovo
Slug: server raid
Author: Feng Xia

If you are like me who dislikes any GUI and mouse clicks, CLI via a
SSH session to IMM is a fun way to get things done. This one shows how
to config disks into RAID.

CLI manual is [here][1].

```
usage:
    storage -config vol -option [-options] -target target_id
options:
    -remove                     - remove one volume.
    -set                        - modify one volume's properties.
        -N volume_name          - volume name (optional).
        -w <0|1|2>              - cache write policy (optional, 0 - Write Through, 1 - Always Write Back, 2 - Write with BBU).
        -r <0|1|2>              - cache read policy (optional, 0 - No Read Ahead, 1 - Read Ahead, 2 - Adaptive Read Ahead).
        -i <0|1>                - cache I/O policy (optional, 0 - Direct I/O, 1 - Cached I/O).
        -a <0|2|3>              - access policy (optional, 0 - Read Write, 2 - Read Only, 3 - Blocked).
        -d <0|1|2>              - disk cache policy (optional, 0 - Unchanged, 1 - Enable, 2 - Disable. 1 - Enable doesn't support mirror RAID level).
        -b <0|1>                - background initialization (optional, 0 - Enable, 1 - Disable).
    -add                        - create one volume with new storage pool when the target is a controller or with existing storage pool when the target is a storage pool.
        -R <0|1|5|1E|6|10|50|60|00>                                 - RAID level (new storage pool only).
        -D disk[id11]:disk[id12]:...,disk[id21]:disk[id22]:...,...  - specify drive group including spans (new storage pool only).
        -H disk[id1]:disk[id2]:...                                  - hot spare group (new storage pool only).
        -l hole                 - specify index of free hole space in the storage pool (existing storage pool only).
        -N volume_name          - volume name (optional).
        -w <0|1|2>              - cache write policy (optional, 0 - Write Through, 1 - Always Write Back, 2 - Write with BBU).
        -r <0|1|2>              - cache read policy (optional, 0 - No Read Ahead, 1 - Read Ahead, 2 - Adaptive Read Ahead).
        -i <0|1>                - cache I/O policy (optional, 0 - Direct I/O, 1 - Cached I/O).
        -a <0|2|3>              - access policy (optional, 0 - Read Write, 2 - Read Only, 3 - Blocked).
        -d <0|1|2>              - disk cache policy (optional, 0 - Unchanged, 1 - Enable, 2 - Disable. 1 - Enable doesn't support mirror RAID level).
        -f <0|1|2>              - initialization status (optional, 0 - No Initialization, 1 - Quick Initialization, 2 - Full Initialization).
        -S volume_size          - new volume size (MB, optional).
        -P strip_size           - strip size (optional, for example: 512B, 4K, 128K, 1M and so on)
    -getfreecap                 - get the drive group configuration's free capacity.
        -R <0|1|5|1E|6|10|50|60|00>                                 - RAID level.
        -D disk[id11]:disk[id12]:...,disk[id21]:disk[id22]:...,...  - specify drive group including spans.
        -H disk[id1]:disk[id2]:...                                  - hot spare group.
```


# View RAID controller

First, get controller to use:
```shell
system> storage -list controllers
ctrl[9]				ServeRAID M1215(PCI Slot 9)	
```

# View disks

Second, list disks and select disks to use:
```shell
system> storage -list drives
disk[9-0]			Drive 0									
disk[9-1]			Drive 1									
disk[9-2]			Drive 2									
disk[9-3]			Drive 3									
disk[9-4]			Drive 4									
disk[9-5]			Drive 5									
disk[9-6]			Drive 6									
disk[9-7]			Drive 7									
system> storage -show disk[9-0] info
Product Name: INTEL SSDSC2BA100G3 
State: Online
Slot No.: 0
Disk Type: SATA
Media Type: SSD
Health Status: Normal
Capacity: 93.160GB
Speed: 6.0Gb/s
Current Temperature: 23C
Media Error Count: 0
Other Error Count: 0
Predication Fail Count: 0
Manufacture: ATA
Device ID: 16
Enclosure ID: 0x003E
Machine Type: 
Model: 
Serial No.: BTTV249403FA100FGN  INTEL SSDSC2
FRU No.:         
Part No.: 
```

# Create RAID

Third, config RAID. 

# RAID 0

will use the following configs:

```shell
system> storage -config vol -add -R 1 -D disk[9-0]:disk[9-1] -N OS -w 1 -r 2 -i 0 -a 0 -d 0 -f 0 -target ctrl[9]
ok
```

To create RAID 5 with 6 disks:

```shell
system> storage -config vol -add -N gluster -R 5 -D
disk[9-2]:disk[9-3]:disk[9-4]:disk[9-5]:disk[9-6]:disk[9-7] -target ctrl[9]
ok
```

# Verify RAID volumes

To verify created RAID volumes:

```shell
system> storage -list volumes
vol[9-0]			OS									
vol[9-1]			gluster									
system> storage -show vol[9-1] info
Name: gluster
Status: Optimal
Strip Size: 64KB
Bootable: Not Bootable
Capacity: 4651.953GB
Read Policy: No Read Ahead
Write Policy: Write Through
I/O Policy: Direct I/O
Access Policy: Read Write
Disk Cache Policy: Unchanged
Background Initialization: Enable
```

# To reset RAID configs

To wipe controller configs:
```shell
system> storage -config ctrl -clrcfg -target ctrl[9]
```

[1]: http://systemx.lenovofiles.com/help/index.jsp?topic=%2Fcom.lenovo.sysx.imm2.doc%2Fnn1iv_c_server_mgmt_local_storage.html
