Title: Baremetal provisioning
Date: 2017-03-22 15:45
Tags: lenovo
Slug: baremetal provisioning
Author: Feng Xia


Everyone of us has installed an operating system to a computer at some
point in life. It is easy to perceive inserting a disk or USB key to
make this happen because the OS files are _there_. A fancier version
is to boot from network using PXE boot option, which seems like a
magic (when the environment has been setup) &mdash; it somehow finds
the OS image and start installing, all over a _network_!


Now if we move to the world of servers, it works the same
way. Baremetal is another name referring to a server that has no
operating system (or hypervisor) installed yet. But the challenge is
to physically access to it to insert that OS disk &mdash; in a data
center setting, I think the walking part is neither fun nor
desired. Remote provisioning is, therefore, the way to go.

First, let's define **provisioning**. Here we mean to have installed
an operating system or hypervisor on a baremetal so it is available
for further software installation.  In the simplest term, one needs to
answer these three questions:

<figure class="s12 center">
    <img src="images/baremetal%20provisioning%20intro.png" />
    <figcaption>Minimal setup for baremetal provisioning</figcaption>
</figure>

1. **What is my address?**. If using BOOTP, the address will be
   static; if using DHCP, it can be either static or dynamic.
2. **Which boot file to use?**. Also referred as **Network Bootstrap
   Program (NBP)**. This is controlled by a boot service. BOOTP can
   provide this service, so is DHCP. This can be as simple as a static
   list mapping client's architecture to a file. But it can also be a
   very specific so a client can get a completly customized file.
   Also, the file must be in some pre-determined format based on
   client's architecture so the client knows how to execute it.
3. **How to download the file?**. This is handled by TFTP protocol.

Boot file is often pretty minimal.  Once the file is downloaded and
loaded in memory, baremetal's firmware will start its execution, which
can then take over the machine and possibly pull down another image,
such as the actual OS image, and then hand over the execution to OS's
bootloader.

# BOOTP, DHCP &mdash; address and boot file list

When a client is connected, it needs an address. Two services are
created for this task &mdash; BOOTP and DHCP. In addition, both will
boot service by telling the client which boot file to use.

BOOTP is an earlier IETF-defined booting protocol that is much less
flexible than DHCP. However, DHCP has been defined to be upwardly
compatible with BOOTP and both these protocols can coexist and
function simultaneously in the same network.  BOOTP is about <font
color="blue">address determination and bootfile selection</font>.
From its [spec][5], we can derive a sequence diagram shown below:

[5]: https://tools.ietf.org/html/rfc951

<figure class="s12 center">
    <img src="images/bootp%20sequence.png" />
    <figcaption>BOOTP sequence diagram</figcaption>
</figure>

One major characteristic of BOOTP is that it is **static**, meaning
when server looks up the client information, such as its IP address,
it is using a **static** table (the _database_ referred in the diagram
above is actually a plain text file). Therefore, everytime client asks
for its information, it will get the same result. Below shows the
format of a BOOTP data packet. This same format in both directions.

<figure class="s12 center">
    <img src="images/bootp%20packet%20format.png" />
    <figcaption>BOOTP data packet</figcaption>
</figure>

DHCP's data packet is nearly identical to BOOTP's for compatibility
reason. Same ports (67 on the server side & 68 on the client side) are
used. Below shows a simplified DHCP cycles ([source][6]):

[6]: http://facweb.cs.depaul.edu/cwhite/TDC%20365/BOOTP%20and%20DHCP.ppt

<figure class="s12 center">
    <img src="images/dhcp%20sequence.png" />
    <figcaption>Simplified DHCP sequence diagram</figcaption>
</figure>


# TFTP &mdash; download boot file 

At this point, client has acquired an address and knows which file to
download. Next, it needs to contact a _file server_ to get the
file. Here comes TFTP.

[TFTP][4] is a very simple protocol used to transfer files.  It is
from this that its name comes, Trivial File Transfer Protocol or TFTP.
Each nonterminal packet is acknowledged separately. It has been
implemented on top of the Internet User Datagram protocol (UDP or
Datagram) so it may be used to move files between machines on
different networks implementing UDP.

[4]: https://tools.ietf.org/html/rfc1350

The only thing it can do is read and write files (or mail) from/to a
remote server &rarr; no user authentication.  Two modes of transfer
are currently supported: ASCII (8-bit) and octet (raw 8-bit bytes).
<font color="red">Note</font> that [spec][4] defines 3rd mode
_message_ but it is obsoleted.

Between client and server, everything is transported as a _data
packet_, and each data packet includes a `op code` which indicates the
meaning of this packet as well as the rest of data structure.  The
[spec][4] has nice illustration of the data formats so I'll copy &
paste them here for reference:

TFTP data packet formats:

```shell
Type   Op #     Format without header
----   ----     --------------------
      2 bytes    string   1 byte     string   1 byte
      -----------------------------------------------
RRQ/  | 01/02 |  Filename  |   0  |    Mode    |   0  |
WRQ    -----------------------------------------------
      2 bytes    2 bytes       n bytes
      ---------------------------------
DATA  | 03    |   Block #  |    Data    |
      ---------------------------------
      2 bytes    2 bytes
      -------------------
ACK   | 04    |   Block #  |
      --------------------
      2 bytes  2 bytes        string    1 byte
      ----------------------------------------
ERROR | 05    |  ErrorCode |   ErrMsg   |   0  |
      ----------------------------------------
```

OP codes:

```shell
opcode  operation
-----   ---------
  1     Read request (RRQ)
  2     Write request (WRQ)
  3     Data (DATA)
  4     Acknowledgment (ACK)
  5     Error (ERROR)
```

Error codes:

```shell
Value     Meaning
-----     -------
0         Not defined, see error message (if any).
1         File not found.
2         Access violation.
3         Disk full or allocation exceeded.
4         Illegal TFTP operation.
5         Unknown transfer ID.
6         File already exists.
7         No such user.
```

Additionally, server always listens to a pre-known port (known as
**transfer identifier**) to begin with. In its first returning data
packet, it can change this to a different port by setting the `Source
Port`, and client will then only accept packets bearing this port
number.

However, client has not such default. Since client is to initialize
the contact, it's free to tell the server which port it uses.
UDP header format:

```shell
0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|            Length             |           Checksum            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

where the values of fields are:

+ `Source Port`: Picked by originator of packet.
+ `Dest. Port`: Picked by destination machine (69 for RRQ or WRQ).
+ `Length`: Number of bytes in UDP packet, including UDP header.
+ `Checksum`: Reference 2 describes rules for computing checksum.  (The
  implementor of this should be sure that the correct algorithm is used
  here.)  Field contains zero if unused.

<figure class="s12 center">
    <img src="images/tftp%20sequence.png" />
    <figcaption>TFTP sequence diagram</figcaption>
</figure>


# Preboote Execution Environment (PXE)

Once we put BOOTP/DHCP and TFTP together, we will have an environment
suitable for client to select PXE boot.  Being such a core technology
used widely in baremetal provisioning, the [Preboot Execution
Environment (PXE) Specification Version 2.1][1] should be the first
document to read. Honestly I'm amazed how well it was written, thought
through, clearly defined, and neatly illustrated, all dated back in
1999!

[1]: http://download.intel.com/design/archives/wfm/downloads/pxespec.pdf

As its name indicates, PXE provides a runtime environment prior to an
OS. A detailed step-by-step diagram is reproduced below (remade from
Figure 2-1 in the [PXE Spec][1]). In a nutshell, it takes three
services to make a PXE working:

1. **DHCP service**: This service handles the initial contact by a
   client. However, its primary function is **not in offering an IP
   address**. Instead, after the first handshakes, it offers clients a
   list of Boot services to choose from so client can move on to
   obtain NBP.
2. **Boot service**: The service essentially maintains a map between
   client architecture (defined in PXE [Client System Architecture
   Type Option Definition][3], values below) and NBP file names. So in
   modern term, it would have been called _NBP registry_ or something
   like that. There can be more than one Boot services co-existed. It
   is up to the client to choose. According to the [spec][1], PXE 2.1
   supports the following client architectures:

        ```shell
        Type   Architecture Name
        ----   -----------------
        0    Intel x86PC
        1    NEC/PC98
        2    EFI Itanium
        3    DEC Alpha
        4    Arc x86
        5    Intel Lean Client
        6    EFI IA32
        7    EFI BC
        8    EFI Xscale
        9    EFI x86-64
        ```

3. **TFTP service**: The actual server that will serve the NBP file
   for client to download.

[3]: https://tools.ietf.org/html/rfc4578

<figure class="s12 center">
    <img src="images/pxe%20boot%20sequence.png" />
    <figcaption>PXE boot sequence diagram</figcaption>
</figure>

Copying and pasting the detailed explanation from the [PXE Spec][1]
below with merely a few reformatting.

## Step 1

The client broadcasts a `DHCPDISCOVER` message to the standard DHCP
port (67). An option field in this packet contains the following:

1. A tag for client identifier (UUID).
2. A tag for the client UNDI version.
3. A tag for the client system architecture.
4. A DHCP option 60, Class ID, set to
   `PXEClient:Arch:xxxxx:UNDI:yyyzzz`.

## Step 2

The DHCP or Proxy DHCP Service responds by sending a `DHCPOFFER`
message to the client on the standard DHCP reply port (68). If this is
a Proxy DHCP Service, then the client IP address field is null
(`0.0.0.0`). If this is a DHCP Service, then the returned client IP
address field is valid.

At this point, other DHCP Services and BOOTP Services also respond
with DHCP offers or BOOTP reply messages to port (68). Each message
contains standard DHCP parameters: an IP address for the client and
any other parameters that the administrator might have configured on
the DHCP or Proxy DHCP Service.

## Step 3

From the `DHCPOFFER(s)` that it receives, the client records the
following:

1. The Client IP address (and other parameters) offered by a standard
   DHCP or BOOTP Service.
2. The `Boot Server` list from the Boot Server field in the PXE tags
   from the `DHCPOFFER`.
3. The `Discovery Control Options` (if provided).
4. The `Multicast Discovery IP` address (if provided).

## Step 4

If the client selects an IP address offered by a DHCP Service, then it
must complete the standard DHCP protocol by sending a request for the
address back to the Service and then waiting for an acknowledgment
from the Service. If the client selects an IP address from a BOOTP
reply, it can simply use the address.

## Step 5

The client selects and discovers a Boot Server. This packet may be
sent broadcast (port 67), multicast (port 4011), or unicast (port
4011) depending on discovery control options included in the previous
DHCPOFFER containing the PXE service extension tags. This packet is
the same as the initial DHCPDISCOVER in Step 1, except that it is
coded as a DHCPREQUEST and now contains the following:

1. The IP address assigned to the client from a DHCP Service.
2. A tag for client identifier (UUID)
3. A tag for the client UNDI version.
4. A tag for the client system architecture.
5. A DHCP option 60, Class ID, set to `PXEClient:Arch:xxxxx:UNDI:yyyzzz`.
6. The Boot Server type in a PXE option field

## Step 6

The Boot Server unicasts a DHCPACK packet back to the client on the
client source port.  This reply packet contains:

1. Boot file name.
2. MTFTP1 configuration parameters.
3. Any other options the NBP requires before it can be successfully executed.

## Step 7

The client downloads the executable file using either standard TFTP
(port69) or MTFTP (port assigned in Boot Server Ack packet). The file
downloaded and the placement of the downloaded code in memory is
dependent on the client’s CPU architecture.

## Step 8

The PXE client determines whether an authenticity test on the
downloaded file is required. If the test is required, the client sends
another DHCPREQUEST message to the boot server requesting a
credentials file for the previously downloaded boot file, downloads
the credentials via TFTP or MTFTP, and performs the authenticity test.

## Step 9

Finally, if the authenticity test succeeded or was not required, then
the PXE client initiates execution of the downloaded code

## Initial Program Load (IPL)

At this step, we have a NBP and is ready to load the image, and this
all boils down to the good-old days that how to link a hardware
interrupt with software interrupt so the initial BIOS will be able to
load register with a specific memory location where the NBP
image resides. 

### Option ROM

**Option ROM**: ROM associated with a plug and play device. May be
located on the device or in non-volatile storage on a system. An
Option ROM is used to extend the services or capabilities of the BIOS
prior to IPL. It is the only way, other than directly modifying the
BIOS, that new devices may be added to the IPL process.  During POST,
the BIOS scans the Upper Memory area for Option ROMs that have been
mapped into this space by adapter cards plugged into a system
expansion bus. A valid Option ROM begins on a 2KB boundary and
contains a data structure with a signature, the length of the Option
ROM and an entry point for initialization code.  If a valid Option ROM
is located by the BIOS, the ROM’s initialization code is
invoked. Option ROMs replace or filter standard BIOS services by
replacing the BIOS initialized interrupt vectors.

There have been various techniques developed to map ROM into memory,
including hardware mapping, copying to Upper Memory and to Shadow
Memory. The objective is always to maintain a method that a common
BIOS runtime can register and later on hand execution over to
ever-expanding list of hardware without updaing BIOS for each change.

### BIOS & Option ROM

The BIOS maintains an ``IPL Table`` listing all of the possible IPL
sources.  In the 1996 [BBS Specification][2], boot devices are
categorized into:

[2]: http://www.scs.stanford.edu/05au-cs240c/lab/specsbbs101.pdf

1. **BIOS Aware IPL Devices (BAID)**: have all the code necessary to perform
IPL resident in the system BIOS. BAID devices include floppy or fixed
drives.
2. **Boot Connection Vector (BCV)** devices: use Option ROM on associated
   device or in non-volatile storage on the motherboard.
3. **Bootstrap Entry Vector (BEV)** devices: use Option ROM on associated
   device or in non-volativel storage on the motherboard. 
   **PXE is implemented as a BEV device**!.


The BIOS adds IPL devices to the BBS `IPL Table` already containing
the BAIDs. These devices are identified during the BIOS Option ROM
scan process. If the device hardware is detected and the rest of
Option ROM initialization is successful (in other words, the Option
ROM initialization code and loader code are placed in upper memory),
control is returned to the BIOS indicating the Option ROM manages an
IPL device. Within the ROM, a Plug and Play Expansion header will be
present for each bootable device supported by the Option ROM. Each PnP
Expansion header for a PXE IPL device will have a non-zero BEV.


Once Option ROM scan is complete, the BIOS builds a list of bootable
devices using the information obtained during the scan. According to
the [BBS][2], the priority list for these devices is established by
the enduser through BIOS setup &rarr; thus, the boot order option!

### PXE Split ROM Architecture

So BIOS can find PXE option by finding its Option ROM. Great. Since
PXE is network dependent, how can it handles different networking
hardware? Two techniques come into play: **Split ROM** architecture
and **UNDI**. We will cover UNDI separately. Here, let's look at the
split architecture.

<figure class="s12 center">
    <img src="images/pxe%20option%20rom%20split%20architecture.png" />
    <figcaption>PXE Option ROM split architecture</figcaption>
</figure>

Prior to the [PXE Spec][1], all PXE Option ROMs were implemented as a
monolithic Option ROM with an option ROM header that encapsulates
three components:

1. PCI init & loader code
2. NIC specific code (UNDI driver)
3. Base code (BC)

The PXE Split ROM Architecture specifies three different Option ROMs
that work cooperatively to create a working PXE that supports one or
more network interfaces. The three Option ROMs are:

1. the Base-Code ROM (BC ROM): is common code to support one or more
   instances of the other ROMs.  The BC ROM provides the protocol stack
   in addition to various loader and initialization code. A Base-Code ROM
   is required.
2. the UNDI ROM: provides the network interface specific code. An UNDI
   ROM is specific to particular network interface hardware. UNDI
   provides a set of APIs that allow the remotely booted program to use
   universal protocol drivers. A system must contain at least one (but
   may contain several) UNDI ROMs, where each ROM would support one
   network interface.
3. the BUSD ROM: provides bus support for CardBus-based network
   interface cards. BUSD is only required if supporting CardBus. Unlike
   the Base-Code and UNDI ROMs, BUSD’s call mechanism must be added to
   the BIOS.

## Time to boot

Now with all the basics out of the way, let's power on the computer!
Page 77 in the [PXE Spec][1] has a nice diagram showing the details
behind the scene from BIOS to a PXE:

<figure class="s12 center">
    <img src="images/pxe%20IPL.svg" />
    <figcaption>PXE IPL (from power on to PXE)</figcaption>
</figure>

