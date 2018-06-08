Title: Switches
Date: 2018-06-08 14:00
Tags: lenovo
Slug: switches
Author: Feng Xia

Switch is a gold mine. You will need (ip, username, pwd) to get to it,
using Telnet(!). Your friend is [pexpect][1], but even that gives you
jinx sometimes when each switch can return you some random garbages
once a while that makes `session.expect("your regex pattern")` to time
out and you don't know why.

[1]: https://pexpect.readthedocs.io/en/stable/

# enos vs. cnos

Not much to say. These are two switch OS seen on Lenovo switches. They
are all closely looked like Cisco's [IOS][2], but different. 

1. [CNOS manual][3]
2. [ENOS commands][4] (Googling `enos manual` shows Lenovo switch
   types, eg. G8272. So I guess the term is applicable on a model basis.)

[2]:     https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/security/s1/sec-s1-xe-3se-5700-cr-book/sec-s1-xe-3se-5700-cr-book_chapter_010.html

[3]: http://systemx.lenovofiles.com/help/topic/com.lenovo.rackswitch.g8332.doc/CNOS_QS_10-3.pdf

[4]: http://systemx.lenovofiles.com/help/topic/com.lenovo.rackswitch.g8272.doc/G8272_CR_8-4.pdf

Anyway, the biggest difference to be aware is that CNOS device uses `display`
whicle ENOS device uses `show`. To get a list of commands available:

1. CNOS: `display ?`

        ```shell
        LCTC-R1U37-SW>display ?
          aaa               AAA Model
          access            access parameters
          access-lists      List IP access lists
          arp               IP ARP table
          banner            Show current motd banner message
          bfd               Bidirectional Forwarding Detection (BFD)
          bgp               Border Gateway Protocol (BGP)
          cee               Converged Enhanced Ethernet
          class-map         Class map entry
          cli               Show CLI tree of current mode
          dbg               Debugging functions
          dot1q-tunnel      Display dot1q tunnel
          env               Show environment
          errdisable        Error disable information
          hardware          Show hardware information
          hostname          Hostname
          interface         Interface status and configuration
          inventory         Show inventory
          ip                Configure ip features
          ipv6              Internet Protocol version 6 (IPv6)
          lacp              Show LACP information
          license           FoD license
          lldp              Show LLDP information
          logging           Logging configuration and data
          mac               MAC
          monitor           Show Ethernet SPAN information
          npa               Network Policy Agent
          ntp               Network time protocol
          policy-map        Policy Map Entry
          port-aggregation  Port aggregation interface
          privilege         Show current privilege level
          queuing           Egress Queuing Information
          radius-server     Specify a RADIUS server
          restApi           RestApi
          rib               RIB
          role              Show role configuration
          router-id         Router ID
          routing           Display routing information
          running-config    Running system information
          snmp              Snmp service
          spanning-tree     Show spanning tree information
          ssh               Ssh
          statistics        Statistics
          switchname        Display switch name
          sys-info          show sys-info
          system            System-related show commands
          tacacs-server     Display tacacs configuration
          tech-support      Show router technical information
          telnet            Telnet
          user-account      User Account Management
          users             Display information about terminal lines
          vdm               Display Virtual Domain Manager Information
          version           Display NOS version
          virtual-machine   Display virtual machine
          vlag              VLAG - Virtual Link Aggregator
          vlan              Display VLAN information
          vnetworks         Display virtual networks
          vrrp              Show vrrp information
          zerotouch         Display zerotouch parameters

        ```
        
2. ENOS: `show ?`

        ```shell
        RS G8272>show ?
        Show running system information
          access-control     Show access control 
          arp                IP ARP table
          boot               Show boot configuration
          cee                Show CEE Information
          clock              Display current switch date and time
          counters           Show all statistics
          custom-dst         Show custom DST configuration
          dcbx               Show DCBX information
          dot1x              Show 802.1x configuration
          ecp                Show Edge Contrl Protocol (ECP) information
          environment        Show running environment
          errdisable         Show Errdisable information
          etherchannel       Show etherchannel
          failover           Show failover state
          fcalias            Show fc-alias configurations per vlan
          fcf                Display details of FCF
          fcns               Show commands for Name Server
          fcoe               Show FCOE Information
          fcs                Show commands for Fabric Configuration Server
          fdmi               Show commands for FDMI
          flogi              Show FLOGI database
          history            Show the session command history
          hotlinks           Show Hot Links configuration
          https              Show HTTPS related information
          ikev2              Show IKEv2 configuration
          information-dump   Show all information
          interface          Show interface configuration and information
          ip                 Show IP information
          ipsec              Show IPsec information
          ipv6               Show IPv6 information
          lacp               Show LACP configuration
          layer2             Show all layer 2 related configuration and information
          layer3             Show all layer 3 related configuration and information
          line               Line information
          lldp               Show LLDP configuration and information
          logging            Show syslog configuration and messages
          mac-address-table  Show MAC forwarding table
          microburst         Show microburst statistics.
          mp                 Show management processor specific statistics
          ntp                Show NTP information and statistics
          nwv                Show Networking Virtualization Information
          oam                Show OAM information
          openflow           Show Openflow configuration and status
          pki                Display the host certificate
          port-mirroring     Show port mirroring configuration
          PortChannel        Show PortChannel
          processes          Show management processor specific statistics
          protocol-vlan      Show protocol VLAN configuration
          ptp                Show PTP informations
          qos                Show quality of service
          rmon               Show current RMON configuration
          route-map          Show route map configuration
          rscn               Show commands for RSCN
          scheduler          Show scheduler configuration 
          script             Show installed scripts
          script-log         Show script logs
          sflow              Show sflow information
          snmp-server        Show SNMP server information and statistics
          software-key       Show software licensing keys
          spanning-tree      Show spanning tree topology
          ssh-clienthostkey  Show SFTP/SSH host keys
          ssh-clientpubkey   Show SSH client public key
          sys-info           Show general system information
          terminal-length    Show current terminal length
          transceiver        Show Port Transceiver status
          trustpoint         Show trustpoint in CA store
          udld               Show UDLD dump
          ufp                Show UFP feature information
          user               Currently logged in users
          version            Show system version
          virt               Show virtual machine
          vlag               Show vLAG configuration and statistics
          vlan               Show VLAN configuration and status
          who                Currently logged in users
          zone               Show zone configurations per vlan
          zoneset            Show zoneset configurations per vlan
        ```

# login

A typical login session looks like this:

```shell
(dev) fengxia@fengxia-lenovo:~$ telnet 10.240.43.29
Trying 10.240.43.29...
Connected to 10.240.43.29.
Escape character is '^]'.

Lenovo RackSwitch G8272.


Enter login username: admin
Enter login password: 
------------------------------------------------------------------
NOTE: System dump exists in FLASH.
      The dump was saved at 18:44:14 Wed Apr 11, 2018.
      Use 'copy flash-dump' to extract the dumps for analysis and
      'clear flash-dump' to clear the FLASH region.
------------------------------------------------------------------
RS G8272>
```

Using [`pexpect`][1] is tedious, rigid (as it expects a certain
sequence in text output from remote device, so randomly shown alert
messages are the worst offender.), but it works.

1. Telnet to IP.
2. Enter username and pwd. **Note** that sometimes it will skip asking
   username and will only require password. 
3. Once you logged in, you may be greeted by a prompt, eg `RS G8272>`,
   the only reliable piece is the ">", the rest can change because it
   is just a switch name.
4. Send `en\n` to put this login session into a superuser mode. I
   think this is optional because the login user may already be
   configured to be a super user.
5. Send `no console\n` to turn off alerts! This is
   important. Otherwise switch will throw at you all kinds of
   messages, such as topology changed, detected logged in from IP
   (actually that's you!). Anyway, just a best practice.

# MAC table

Commands to use:

1. ENOS: `show mac`
2. CNOS: `display mac address-table`

> MAC table is saying: I see this `MAC` on `VLAN` on `port #`.


MAC address table is the core of a switch &mdash; all the MACs it has
learned by seeing it from a traffic. 

These MACs, however, are not necessarily from a device you know of!
For example, a traffic from some external device flowing through this
switch will certainly show up in this table with its MAC, but we have
no way to derive information of the device who owns this MAC (a
switch? a server? a router?). Further, MAC table changes ALL THE
TIME. It is built up from traffic, thus its contents only reflects
what this switch has seen (based on its update algorithm). We use it
as a exhaustive list (everything this switch knows of), and relying to
match with other meta, eg. I found this MAC to be an interface in this
server, to connect the dots. **This is the key of constructing a reality
view of a physical topology**.

So from a traffic, we can capture:

1. MAC of the source. Again, we know the MAC, but don't know who owns
   it.
2. VLAN id.
3. Port number.


## ENOS

Example of output:

```shell
RS G8272>show mac
Mac address Aging Time: 300 

     MAC address       VLAN     Port    Trnk  State  Permanent  Openflow
  -----------------  --------  -------  ----  -----  ---------  --------
  00:00:0c:9f:f0:2f       1    48             FWD                  N    
  00:00:0c:9f:f0:46     100    48             FWD                  N    
```

## CNOS

Example of output:

```shell
LCTC-R1U37-SW>display mac address-table
 VLAN     MAC Address     Type      Ports 
  -----+----------------+---------+-----------------------+
  1      0000.0c9f.f02f   dynamic   Ethernet1/54 
  1      0001.7302.5c96   dynamic   Ethernet1/54 
```

# switch name

Get switch name (if there is one, oh well). 

1. ENOS: `show run`
2. CNOS: `display run`

In both cases, search for pattern `hostname\s(?P<hostname>.*)` in
`re.MULTILINE` mode. If there is no match, then the switch's hostname
has not been set.

# switch neighbors

1. ENOS: `show lldp remote-device`
2. CNOS: `display lldp neighbors`

This is an interesting one. Switch-to-switch links (we are talking
about physical cable connections from A port to B port) can be pulled
from a switch &larr; they refer to devices connected to a switch
**neighbors**. This information is the foundation to draw a (physical)
network topology such as:

<figure class="s12 center">
    <img src="/images/switch%20network%20topology.png"/>
    <figcaption>Example of a switch-switch topology</figcaption>
</figure>

## ENOS

Example output:

```shell
RS G8272#show lldp remote-device
LLDP Remote Devices Information
Legend(possible values in DMAC column) :
NB   - Nearest Bridge          - 01-80-C2-00-00-0E
NnTB - Nearest non-TPMR Bridge - 01-80-C2-00-00-03
NCB  - Nearest Customer Bridge - 01-80-C2-00-00-00
Total number of current entries: 19

LocalPort | Index | Remote Chassis ID         | Remote Port          | Remote System Name            | DMAC     
----------|-------|---------------------------|----------------------|-------------------------------|---------
1         | 5     | 68 05 ca 62 ef a5         | 68-05-ca-62-ef-a5    |                               | NB 
2         | 4     | 68 05 ca 62 ef a4         | 68-05-ca-62-ef-a4    |                               | NB 
3         | 6     | 68 05 ca 62 ee 7d         | 68-05-ca-62-ee-7d    |                               | NB 
4         | 7     | 68 05 ca 62 ee 7c         | 68-05-ca-62-ee-7c    |                               | NB 
5         | 8     | 68 05 ca 62 f3 fd         | 68-05-ca-62-f3-fd    |                               | NB 
```

## CNOS

Example output:

```shell
LCTC-R1U37-SW>display lldp neighbors
Capability codes:
  (R) Router, (B) Bridge, (T) Telephone, (C) DOCSIS Cable Device
  (W) WLAN Access Point, (P) Repeater, (S) Station, (O) Other
Device ID            Local Intf      Hold-time  Capability  Port ID        
                     Ethernet1/7     120                                   
LCTC-R1U39-SW        Ethernet1/48    120        BR          XGE4           
LCTC-R3U38-SW        Ethernet1/54    120        BR          1              
LCTC-R1U39-SW        mgmt0           120        BR          47             

Total entries displayed: 4
```

# switch port list

1. ENOS: `show lldp port`
2. CNOS: `display lldp interface all`

Each switch port represents an interface that has:

1. A port number &mdash; in nearl all cases they are an `int`, but
   switch management port can be in string such as `mgmt0` (I don't
   think there is convention/default here.) So we need to treat this
   value as `string`.
2. A MAC. 
   > Internally, MAC is normalized to format `AA:BB:CC` &larr; all capital
3. `vlan` ID.

## ENOS

Example output:

```
RS G8272>show lldp port
LLDP Port Info
-  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Port    MAC address       MTU  PortEnabled AdminStatus RxChange TrapNotify
======= ================= ==== =========== =========== ======== ==========
1       a4:8c:db:9b:01:00 9216 enabled     tx_rx       no       disabled 
2       a4:8c:db:9b:01:00 9216 enabled     tx_rx       no       disabled 
```

## CNOS

Example output:

```
LCTC-R1U37-SW>display lldp interface all
Interface Name: Ethernet1/1
--------------
Interface Information 
 Enable (tx/rx/trap): Y/Y/N   Port Mac address: a4:8c:db:34:b2:03

Interface Name: Ethernet1/2
--------------
Interface Information 
 Enable (tx/rx/trap): Y/Y/N   Port Mac address: a4:8c:db:34:b2:04

Interface Name: mgmt0
--------------
Interface Information 
 Enable (tx/rx/trap): Y/Y/N   Port Mac address: a4:8c:db:34:b2:00
```

### management port

In CNOS, you can get management port directly (name, MAC) by using
`display interface mgmt 0`:

Example output:

```
LCTC-R1U37-SW>  display interface mgmt 0
Interface mgmt0
  Hardware is Management Ethernet  Current HW addr: a48c.db34.b200
  Physical:a48c.db34.b200  Logical:(not set)
  index 3 metric 1 MTU 1500 Bandwidth 1000000 Kbit
  no bridge-port
  arp ageing timeout 1500
  <UP,BROADCAST,RUNNING,ALLMULTI,MULTICAST>
  VRF Binding: Associated with management
  Speed 1000 Mb/s Duplex full
  IPV6 DHCP IA-NA client is enabled.
  inet 10.240.41.147/22 broadcast 10.240.43.255
  inet6 fe80::a68c:dbff:fe34:b200/64
  RX 
    0 input packets 18446744073706907944 unicast packets 3025224 multicast packets 
    2693333 broadcast packets 910620066 bytes 
  TX 
    84138 output packets 39832 unicast packets 44276 multicast packets 
    30 broadcast packets 9839336 bytes 

Automatic policy provisioning is disabled on this interface
```

Have fun w/ switches ~~
