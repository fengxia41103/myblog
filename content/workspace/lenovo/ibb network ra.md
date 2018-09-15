Title: Setting Up Lenovo Open Cloud Networks
Date: 2018-09-14 09:35
Tags: reference architecture
Slug: ibb network design
Author: Feng Xia


# Abstract

The purpose of this document is to provide guidelines and
considerations for setting up Lenovo Open Cloud (aka. LOC) networks.

# Executive Summary

Lenovo Open Cloud consists of a list of physical servers (aka. nodes) and virtual
machines (VMs). This reference environment provides a comprehensive example
demonstrating how to set up networks to connect these servers and VMs
together.

Lenovo Open Cloud is a highly configurable system. From the point of
view of physical servers, LOC can be deployed on a 6-server or
9-server configuration.  In this document we will use a 9-server
configuration as example.

# Components and Considerations

![][overall architecture]{.col .s12}
*Lenovo Open Cloud Architecture*

Lenovo Open Cloud has two sets of clusters: `management cluster` and
`workload cluster`. Workload cluster refers to applications
directly interfacing with end user. Management cluster refers to
applications that manage and provide Open Cloud services. 

## Physical Servers

HW BOM as reference. Description of servers, including:

1. picture
2. general description
3. HW configuration &rarr; best recipe? eg. RAID feature enabled


## Network Switches

HW BOM reference. Description of switches, including:

1. picture
2. general description
3. HW configuration &rarr; best recipe?

## Software

SW BOM as reference. Description of Red Hat software:

### RHV
### RHGS
### Satellite
### Tower
### Ceph
### Openstack

## Services

Open Cloud services can be broken down to three categories based on
their function roles:


1. **Platform services**: Platform services are built upon [Red Hat
    Hyperconverged Infrastructure (RHHI)][rhhi]. It provides LOC core
    services each deployed in one or more virtual machines.
2. **Storage services**: Storage services are built upon Ceph. It
   provides capability to manage Ceph cluster up to xx.
3. **Cloud services**: Cloud is built upon Red Hat Openstack.

### Platform services

### Storage services

### Cloud services



# Network Design

![][network overview]{.col .s12}
*Lenovo Open Cloud Network Overview*

LOC networks can be viewed in three groups whereas:

1. **platform network**: to support platform services.
2. **storage network**: built on top of platform network with added
   networks to handle Ceph data storage traffic and Ceph management functions.
3. **cloud network**: 

## Conventions

Hardware can break. It is important to keep it in mind when designing
a network connection. In this architecture we have followed these
conventions:

1. Inter switch connections are paired.
2. Except BMC connection, server to switch connections are paired.
    1. Each pair connect to separate NICs on the server at north bound, 
       and separate switch at south bound.

## Connection To Upstream

Showing switch topology within IBB as well as how it is connected to
upstream &rarr; what is required from upstream, eg. dhcp, dns,
gateway, access to RH CDN.


## VLANs

## Platform Network Design

![][platform network]{.col .s12}
*Lenovo Open Cloud Platform Network*

## Storage Network Design

![][storage network]{.col .s12}
*Lenovo Open Cloud Storage Network*

## Cloud Network Design

![][cloud network]{.col .s12}
*Lenovo Open Cloud Cloud Network*


# Server to Switch Cable Schema

Each environment is different. Here we present an example cable schema
following the network designs laid out in previous sections. In the
following sections we will use this schema to demonstrate switch
port configurations.

# Configure Switches

There are two aspects of switch configurations:

1. **inter switch connections**: switch are connected to form a
   topology allowing data traffic between Lenovo Open Cloud
   environment and its host environments, and between LOC switches
   within the LOC itself. All switches are paired for high
   availability.
2. **server connections**: are connections between server and
   switch. Except out-of-band connection which has only one connection
   between a server and a switch, thus does not have redundancy, all
   other server to switch connections 

# Configure Servers

# Configure Virtual Machines

# Appendix

## Implementation Worksheet (questioinnaire)

## Hardware BOM

Simplified version covers server & switch at high level should be fine.

## Software BOM

BOM matrix without $$.


[overall architecture]: ../../images/ibb/ibb%20overall%20architecture.png
[network overview]: ../../images/ibb/ibb%20network%20design%20overview.png
[platform network]: ../../images/ibb/ibb%20platform%20brain%20workloads%20network.png
[storage network]: ../../images/ibb/ibb%20ceph%20network%20design.png
[cloud network]: ../../images/ibb/ibb%20cloud%20network%20design.png

[rhhi]: https://access.redhat.com/products/red-hat-hyperconverged-infrastructure
