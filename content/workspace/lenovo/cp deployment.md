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

# mwc wildfly local dev

## anaconda

[Official instruction][1].

1. install system packages:

        ```shell
        apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
        ```

2. download [installer][2].

3. `source ~/.bashrc`. If you are curious, this is what that
   initialization step put in this file:
   
        ```shell
        __conda_setup="$('/home/fengxia/anaconda2/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home/fengxia/anaconda2/etc/profile.d/conda.sh" ]; then
                . "/home/fengxia/anaconda2/etc/profile.d/conda.sh"
            else
                export PATH="/home/fengxia/anaconda2/bin:$PATH"
            fi
        fi
        unset __conda_setup
        ```

4. `conda -version`. You should see sth like `conda 4.7.10`.

5. `conda config --add channels conda-forge`.

6. `conda create -n mwc_scripts python=2.7 psycopg2 sqlparse
   cassandra-driver`. This message `Collecting package metadata
   (current_repodata.json):` will take a while to complete. Be patient.

## docker

1. Just follow [this].
2. `sudo usermod -a -G docker $USER`, then exit SSH and login again.
3. `docker run hello-world` as test.

## mwc

1. In `.bashrc`, append to the end:

        ```shell
        export CLDTX_HOME=/home/fengxia/workspace/ignite
        export CLDTX_CONFIG=/etc/cloudistics
        export PYTHON_HOME=/home/fengxia/miniconda2
        ```
2. `source ~/.bashrc`.

3. `mwc\maintenance\unix\setup\init-mwc-builder.sh`. This will build
   docker images.

4. `mwc/maintenance/unix/setup/init-config.sh`.

5. `~/workspace/ignite/mwc/maintenance/unix/workflow/build-mwc.sh`. If
   there is error, stop.

6. `cd ~/workspace/ignite/mwc/docker`, then:

  1. `docker-compose up -d postgres scylla`
  2. `docker-compose up -d wildfly`
  
[1]: https://docs.anaconda.com/anaconda/install/linux/
[2]: https://www.anaconda.com/download/#linux
[3]: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
