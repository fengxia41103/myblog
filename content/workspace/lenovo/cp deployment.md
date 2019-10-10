Title: ThinkAgile CP Deployment
Date: 2019-10-02 13:24
Tags: lenovo
Slug: cp deployment
Author: Feng Xia
Status: Draft

Follow these instructions to deploy a ThinkAgile CP stack.

# Prerequisite

1. Stacks have been cabled.
2. Network planning worksheet has been filled out.
3. Uplink switches have been configured according the worksheet.
4. Connect a bootstrap (Linux) machine, eg. your laptop, with a serial
   to USB adapter cable. Serial cable is connected to the primary
   interconnect.
   
# Bootstrap

On Ubuntu 18.04, 

1. `sudo screen /dev/ttyUSB0 115200 cs8`, wait for prompt `XorPlus
   login:`. Now you are connected to the primary interconnect.
   
     - login: (manager, cloudistics)
   
2. Setup uplink IP, DNS server, and NTP server:


        ```shell
        sudo cldtx_set_switch_oob_ip -v <oob vlan> \
          -i <oob ip> \
          -m <oob netmask> \
          -g <oob gateway> \
          -n <primary DNS server, default to 8.8.8.8> \
          -d <2nd DNS server, default to 8.8.4.4> \
          -t <primary NTP server, default to "time1.google.com"> \
          -p <2nd NTP server, default to "time2.google.com">
        ``` 

    Example output:
    
        ```shell
        Execute command: 
                          set system management-ethernet eth0 ip-gateway IPv4 10.240.22.1.
        The same value is set to node "system management-ethernet eth0 ip-gateway IPv4".
        root@XorPlus# 
        Execute command: 
                          commit.
        Commit OK.
        root@XorPlus# 
        Execute command: 
        .
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: delete system dns-server-ip 8.8.8.8^M.
        Deleting: 
            8.8.8.8

        OK 
        root@XorPlus# 
        Execute command: commit 
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        OK 
        root@XorPlus# 
        Execute command: commit 
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.8.8.
        root@XorPlus# 
        Execute command: commit
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.4.4.
        root@XorPlus# 
        Execute command: commit
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.8.8.
        root@XorPlus# 
        Execute command: commit
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.4.4.
        root@XorPlus# 
        Execute command: commit
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Stopping NTP server: ntpd.
        Starting NTP server: ntpd.
        Checking connectivity to host:   port: 
        Cloudistics Portal connection check failed    
        ```
