Title: IBB brain shutdown procedure
Date: 2018-11-16 15:34
Tags: lenovo
Slug: ibb brain shutdown procedure
Author: Feng Xia

This document describes procedure to shutdown an IBB brain instance.

# Shutdown procedure

1. On RHV admin portal, shutdown all virtual machines but not the `hosted-engine`.

2. Put the cluster in **global maintenance mode** by login any brain
   server, and `hosted-engine --set-maintenance --mode=global`. 
   
    To verify, login in a brain node and `hosted-engine --vm-status`:
   
        ```shell
        [root@lmorlct0207brain3 ~]# hosted-engine --vm-status


        !! Cluster is in GLOBAL MAINTENANCE mode !!



        --== Host 1 status ==--

        conf_on_shared_storage             : True
        Status up-to-date                  : True
        Hostname                           : lmorlct0203brain3.labs.lenovo.com
        Host ID                            : 1
        Engine status                      : {"health": "good", "vm": "up", "detail": "up"}
        Score                              : 3400
        stopped                            : False
        Local maintenance                  : False
        crc32                              : 8eb75a80
        local_conf_timestamp               : 3249288
        Host timestamp                     : 3249287
        Extra metadata (valid at timestamp):
            metadata_parse_version=1
            metadata_feature_version=1
            timestamp=3249287 (Fri Nov 16 15:57:39 2018)
            host-id=1
            score=3400
            vm_conf_refresh_time=3249288 (Fri Nov 16 15:57:40 2018)
            conf_on_shared_storage=True
            maintenance=False
            state=GlobalMaintenance
            stopped=False


        --== Host 2 status ==--

        conf_on_shared_storage             : True
        Status up-to-date                  : True
        Hostname                           : 10.240.41.235
        Host ID                            : 2
        Engine status                      : {"reason": "vm not running on this host", "health": "bad", "vm": "down", "detail": "unknown"}
        Score                              : 3400
        stopped                            : False
        Local maintenance                  : False
        crc32                              : 3711533b
        local_conf_timestamp               : 3249303
        Host timestamp                     : 3249303
        Extra metadata (valid at timestamp):
            metadata_parse_version=1
            metadata_feature_version=1
            timestamp=3249303 (Fri Nov 16 15:57:33 2018)
            host-id=2
            score=3400
            vm_conf_refresh_time=3249303 (Fri Nov 16 15:57:33 2018)
            conf_on_shared_storage=True
            maintenance=False
            state=GlobalMaintenance
            stopped=False


        --== Host 3 status ==--

        conf_on_shared_storage             : True
        Status up-to-date                  : True
        Hostname                           : 10.240.41.236
        Host ID                            : 3
        Engine status                      : {"reason": "vm not running on this host", "health": "bad", "vm": "down", "detail": "unknown"}
        Score                              : 3400
        stopped                            : False
        Local maintenance                  : False
        crc32                              : b05b67cb
        local_conf_timestamp               : 3249295
        Host timestamp                     : 3249295
        Extra metadata (valid at timestamp):
            metadata_parse_version=1
            metadata_feature_version=1
            timestamp=3249295 (Fri Nov 16 15:57:42 2018)
            host-id=3
            score=3400
            vm_conf_refresh_time=3249295 (Fri Nov 16 15:57:42 2018)
            conf_on_shared_storage=True
            maintenance=False
            state=GlobalMaintenance
            stopped=False


        !! Cluster is in GLOBAL MAINTENANCE mode !!   
        ```
   
3.  On RHV admin portal, go to `Data Center/Storage` tab, select a
   storage domain and click `maintenance` on menu bar, or right-click
   then select `maintenance`.
   
    - **Note** that you will not be able shutdown the one that
      hosted-engine is using (usually named `master` or
      `hosted_storage`) by mistake because software will prevents you
      with an error.


    - **Note** that this step can take some time as storage goes
      through `locked` &rarr; `preparing maintenance` &rarr;
      `maintenance`:

    <figure class="col s12">
      <img src="/images/ibb/shutdown%20rhv%20storage%20domain.png"/>
    </figure>

4. Shutdown `hosted-engine` VM.

5. Shutdown the hosted-engine's storage (should be the only one left), eg. `master`.

6. SSH to each brain node and shutdown ovirt HA:

   1. shutdown ovirt HA agent: `systemctl  stop ovirt-ha-agent`
   2. shutdown ovirt HA broker: `systemctl  stop ovirt-ha-broker`

7. On any brain node, disconnect RHV from its storage: `hosted-engine
   --disconnect-storage`

8. SSH to each brain and stop gluster volumes:

   1. get volume list: `gluster volume list`
   2. stop one: `gluster volume stop <volume name>`

    <figure class="col s12">
      <img src="/images/ibb/shutdown%20gluster%20volume.png"/>
    </figure>

9. Power off brain nodes.


# Bringup procedure

1. Login any brain node and start gluster volumes. Order is not important.

        ```shell
        $ gluster volume start data
        $ gluster volume start engine
        $ gluster volume start vmstore
        ```
    
2. Verify `gluster volume status`. You should see all bricks.

        ```shell
        [root@lmorlct0203brain3 ~]# gluster volume status
        Status of volume: data
        Gluster process                             TCP Port  RDMA Port  Online  Pid
        ------------------------------------------------------------------------------
        Brick 172.24.0.234:/gluster_bricks/data/dat
        a                                           49152     0          Y       5582 
        Brick 172.24.0.235:/gluster_bricks/data/dat
        a                                           49152     0          Y       1816 
        Brick 172.24.0.236:/gluster_bricks/data/dat
        a                                           49152     0          Y       47247
        NFS Server on localhost                     N/A       N/A        N       N/A  
        Self-heal Daemon on localhost               N/A       N/A        Y       6074 
        NFS Server on 172.24.0.236                  N/A       N/A        N       N/A  
        Self-heal Daemon on 172.24.0.236            N/A       N/A        Y       47654
        NFS Server on 172.24.0.235                  N/A       N/A        N       N/A  
        Self-heal Daemon on 172.24.0.235            N/A       N/A        Y       2257 

        Task Status of Volume data
        ------------------------------------------------------------------------------
        There are no active volume tasks

        Status of volume: engine
        Gluster process                             TCP Port  RDMA Port  Online  Pid
        ------------------------------------------------------------------------------
        Brick 172.24.0.234:/gluster_bricks/engine/e
        ngine                                       49153     0          Y       5785 
        Brick 172.24.0.235:/gluster_bricks/engine/e
        ngine                                       49153     0          Y       2006 
        Brick 172.24.0.236:/gluster_bricks/engine/e
        ngine                                       49153     0          Y       47414
        NFS Server on localhost                     N/A       N/A        N       N/A  
        Self-heal Daemon on localhost               N/A       N/A        Y       6074 
        NFS Server on 172.24.0.235                  N/A       N/A        N       N/A  
        Self-heal Daemon on 172.24.0.235            N/A       N/A        Y       2257 
        NFS Server on 172.24.0.236                  N/A       N/A        N       N/A  
        Self-heal Daemon on 172.24.0.236            N/A       N/A        Y       47654

        Task Status of Volume engine
        ------------------------------------------------------------------------------
        There are no active volume tasks

        Status of volume: vmstore
        Gluster process                             TCP Port  RDMA Port  Online  Pid
        ------------------------------------------------------------------------------
        Brick 172.24.0.234:/gluster_bricks/vmstore/
        vmstore                                     49154     0          Y       6030 
        Brick 172.24.0.235:/gluster_bricks/vmstore/
        vmstore                                     49154     0          Y       2103 
        Brick 172.24.0.236:/gluster_bricks/vmstore/
        vmstore                                     49154     0          Y       47496
        NFS Server on localhost                     N/A       N/A        N       N/A  
        Self-heal Daemon on localhost               N/A       N/A        Y       6074 
        NFS Server on 172.24.0.235                  N/A       N/A        N       N/A  
        Self-heal Daemon on 172.24.0.235            N/A       N/A        Y       2257 
        NFS Server on 172.24.0.236                  N/A       N/A        N       N/A  
        Self-heal Daemon on 172.24.0.236            N/A       N/A        Y       47654

        Task Status of Volume vmstore
        ------------------------------------------------------------------------------
        There are no active volume tasks

        ```
3. On any brain, use `hosted-engine --vm-start` to start the hosted
   engine VM.
   
    1. If there is an error &mdash; `VM is not present`,  then switch
       to a different host and give the command. One of the three brain
       node shall be able to start the engine.
    2. Use `hosted-engine --vm-status` to check engine status.
    3. The hosted-engine will come up in **global maintenance** mode.

4. Login in the RHV admin portal, select `System &rarr; Storage`, the
   domain of hosted-engine, eg. `hosted-storage` should be in green,
   and all others are in maintenance mode (a lock symbol) or down (red
   down arrow).

    1. Activate the domain that has `(Master)` tag on `Data Center` tab
       below the storage list pane.
    2. Once `(Master)` domain started, activated other domains. Order
       is unimportant.
    3. Starting storage can take a while.

    <figure class="col s12">
      <img src="/images/ibb/rhhi%20activate%20domain.png"/>
    </figure>

5. Remove global maintenance mode: `hosted-engine --set-maintenance
   --mode=none`.

6. Starting VMs you need, and you are back to business.

