---
date: 2021-02-09
tags:
- router
- ipv6
- nmcli
- networkmanager
title: "IPv6 with NetworkManager"
---

In my last post I talked about [a home router with GNU
Guix](/2021/02/07/guix-router.html). I had spent a day during the
previous weekend trying to package CoreDNS, but the actual blog post
and setting up the rest of the routing was mostly done in a
night. Needless to say it was a little rushed making the switch from
my Edgerouter Lite to my commodity software/hardware solution.

At one point in the past I thought had used `radvd` for IPv6
configuration, so I mentioned it an the end of the post, but it
appears that it's not needed. NetworkManager, which I was using for
the rest of my interface configuration, seems to already provide all the necessary
functionality by setting `ipv6.method` to `shared` on your internal
network interface.


My current setup:

```sh
root@timmy-m90n /home/timmy# nmcli con
NAME             UUID                                  TYPE      DEVICE
internet         f6602a7f-a525-4aee-a9fd-182ec7cd86b2  ethernet  enp4s0
static-internal  d9187c3d-b106-47b8-b122-a38435b9c3ee  ethernet  enp2s0
```

Using `nmcli` to edit the LAN ethernet configuration:

```sh
root@timmy-m90n /home/timmy# nmcli con edit static-internal

===| nmcli interactive connection editor |===

Editing existing '802-3-ethernet' connection: 'static-internal'

Type 'help' or '?' for available commands.
Type 'print' to show all the connection properties.
Type 'describe [<setting>.<prop>]' for detailed property description.

You may edit the following settings: connection, 802-3-ethernet
(ethernet), 802-1x, dcb, sriov, ethtool, match, ipv4, ipv6, tc, proxy 
nmcli> describe ipv6.method

=== [method] ===
[NM property description]
IP configuration method. NMSettingIP4Config and NMSettingIP6Config
both support "disabled", "auto", "manual", and "link-local". See the
subclass-specific documentation for other values. In general, for the
"auto" method, properties such as "dns" and "routes" specify
information that is added on to the information returned from
automatic configuration.  The "ignore-auto-routes" and
"ignore-auto-dns" properties modify this behavior. For methods that
imply no upstream network, such as "shared" or "link-local", these
properties must be empty. For IPv4 method "shared", the IP subnet can
be configured by adding one manual IPv4 address or otherwise
10.42.x.0/24 is chosen. Note that the shared method must be configured
on the interface which shares the internet to a subnet, not on the
uplink which is shared. 

nmcli> set ipv6.method shared
nmcli> quit
The connection is not saved. Do you really want to quit? (yes/no) [no] no
nmcli> save
Connection 'static-internal' (d9187c3d-b106-47b8-b122-a38435b9c3ee)
successfully updated.
nmcli> q
```

Refreshing the interface:

```sh
root@timmy-m90n /home/timmy# nmcli con up static-internal
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7460] agent-manager: agent[5908e805660d5161,:1.69/nmcli-connect/0]: agent registered
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7467] device (enp2s0): state change: activated -> deactivating (reason 'new-activation', sys-iface-state: 'managed')
Feb  9 21:18:04 localhost dbus-daemon[294]: [system] Activating service name='org.freedesktop.nm_dispatcher' requested by ':1.1' (uid=0 pid=330 comm="/gnu/store/sw5nmv030gz1hy1hkkf7f0x7na0wpbxx-networ") (using servicehelper)
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7476] device (enp2s0): disconnecting for new activation request.
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7477] audit: op="connection-activate" uuid="d9187c3d-b106-47b8-b122-a38435b9c3ee" name="static-internal" pid=9090 uid=0 result="success"
Feb  9 21:18:04 localhost dbus-daemon[294]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7541] device (enp2s0): state change: deactivating -> disconnected (reason 'new-activation', sys-iface-state: 'managed')
Feb  9 21:18:04 localhost nscd: 257 monitored file `/etc/resolv.conf` was moved into place, adding watch
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7808] device (enp2s0): Activation: starting connection 'static-internal' (d9187c3d-b106-47b8-b122-a38435b9c3ee)
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7818] device (enp2s0): state change: disconnected -> prepare (reason 'none', sys-iface-state: 'managed')
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7819] device (enp2s0): state change: prepare -> config (reason 'none', sys-iface-state: 'managed')
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7824] device (enp2s0): state change: config -> ip-config (reason 'none', sys-iface-state: 'managed')
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7837] device (enp2s0): state change: ip-config -> ip-check (reason 'none', sys-iface-state: 'managed')
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7849] device (enp2s0): state change: ip-check -> secondaries (reason 'none', sys-iface-state: 'managed')
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7851] device (enp2s0): state change: secondaries -> activated (reason 'none', sys-iface-state: 'managed')
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/11)
Feb  9 21:18:04 localhost nscd: 257 monitored file `/etc/resolv.conf` was moved into place, adding watch
Feb  9 21:18:04 localhost NetworkManager[330]: <info>  [1612934284.7868] device (enp2s0): Activation: successful, device activated.
Feb  9 21:18:06 localhost NetworkManager[330]: <info>  [1612934286.1712] policy: ipv6-pd: none of 0 prefixes of enp4s0 can be shared on enp2s0
Feb  9 21:18:06 localhost NetworkManager[330]: <info>  [1612934286.1713] device (enp4s0): DHCPv6 lease renewal requested
Feb  9 21:18:06 localhost NetworkManager[330]: <info>  [1612934286.1713] dhcp6 (enp4s0): canceled DHCP transaction
Feb  9 21:18:06 localhost NetworkManager[330]: <info>  [1612934286.1713] dhcp6 (enp4s0): state changed bound -> done
Feb  9 21:18:06 localhost NetworkManager[330]: <info>  [1612934286.1717] dhcp6 (enp4s0): activation: beginning transaction (timeout in 45 seconds)
Feb  9 21:18:06 localhost nscd: 257 monitored file `/etc/resolv.conf` was moved into place, adding watch
Feb  9 21:18:07 localhost NetworkManager[330]: <info>  [1612934287.3222] dhcp6 (enp4s0): option dhcp6_name_servers   => '2001:558:feed::1 2001:558:feed::2'
Feb  9 21:18:07 localhost NetworkManager[330]: <info>  [1612934287.3222] dhcp6 (enp4s0): option ip6_address          => '2001:558:[snip]:51d7'
Feb  9 21:18:07 localhost NetworkManager[330]: <info>  [1612934287.3222] dhcp6 (enp4s0): state changed unknown -> bound
Feb  9 21:18:07 localhost NetworkManager[330]: <info>  [1612934287.3236] policy: ipv6-pd: received a prefix 2601:[snip]::/64 from enp4s0
```
That was it! I got at 10/10 on my [IPv6 score](https://test-ipv6.com/).

