---
date: 2021-02-07
tags:
- Guix
- router
- ubiquiti
title: "A Home Router with GNU Guix"
---

Here are some features I find to be important in a home router:

- Desired state configuration: one config file than can be
  imported/exported that describes the whole router state.

- Separate control plane channel: a physical serial port for admin
  access, or easier yet, just simply plug in a monitor. For cases when
  the network is down and you need a console.
  
- Atomic updates and rollbacks for configuration: useful if something breaks.

- A separate in-memory vs disk configuration: useful for testing or
  temporary changes.

- Commodity hardware: easy to find a replacement.

- FOSS software: to not be tied into any vendor system.

- DNS server with DNS over TLS support: keeping my ISP from building
  an advertising profile

- IPv6 support: it's 2021 already.

- dhcpd: support giving out IPv4 addresses. NetworkManager to help
  machines obtain IPv6 addresses

- Unattended security updates: you shouldn't have to go to some vendor
  site and download a zip file and manually update

- Monitoring: nice to view latency, bandwidth, etc.


GNU Guix should support all of those, and its design around a single
system configuration file makes this appealing. Unfortunately, it
still has a ways to go before the ecosystem is mature. 


The first bump I hit was that I wanted to use CoreDNS for my DNS
server (I wrote about it in an earlier blog post), but there isn't a
good way yet to package go language packages. There are essential
three approaches you could take to package a go language package
with Guix:

1. Modify the fetch mechanism to download not just the sources but
   also all the module dependencies recursively. This would be my
   preferred option, but there isn't any sharing done between the
   modules, their licenses aren't indexed, Guix would need a special
   method to patch dependencies that needed a security update, etc.
1. Build a package importer that generates Guix Scheme code for the
   package and for all of its dependencies. This doesn't scale because
   you'd create a new package for every unique version of every
   dependency. The package store would become too bloated.
1. Build an importer that operates like the above except dependencies
   are shared and locked to a single version. The problem with this
   approach is that packages get versions of dependencies they weren't
   designed for, might not work with, etc.

For getting CoreDNS to work, I just hacked together the first option
by creating a GitHub fork of CoreDNS, ran `go mod vendor`, then
checked in the `vendor/` directory.

After that, I needed to write some Scheme code so that I could
configure CoreDNS through my system config.scm. There is a little
learning curve to writing your first service. Especially if you
haven't used Scheme in 15 years.

Setting up a guix development environment is pretty straightforward:

```sh
$ git clone https://git.savannah.gnu.org/git/guix.git
$ guix environment guix --pure --ad-hoc help2man git strace bash less
$ ./configure --localstatedir=/var
$ make
```

Then you can run your custom build of guix with `./pre-inst-env guix
build hello` or similar. This [perfect setup
guide](https://guix.gnu.org/manual/en/html_node/The-Perfect-Setup.html)
discusses how you can get an IDE by basically running `guix package -i
emacs guile emacs-geiser` and using that to edit the sources. I
basically did that an a few hours later I was able to look at enough
sample code on building services that I could get my own working. For
this exercise, you don't really need a custom Guix, you can just use
`--load-path=xyz` to add your scheme sources so they can be referenced
by other files.


To consume your custom packages, you generally set up a
[channel](https://github.com/timmydo/guix-channel). Take note there is
a special orphan branch called `keyring` (`git switch --orphan
keyring`) with your public GPG key that you use to sign the commits in
the `main` branch. You might need to run commands like this to set up
commit signing:

```sh
git config commit.gpgsign true
git config user.signingkey=1234
```

In the root of the git repo, you'll have a `.guix-authorizations`,
which is a list of keys that are authorized (and should also be in
files in the `keyring` branch):

```scheme
(authorizations
 (version 0)
 (("4334 F13E FD13 BC4D 7F5E  69B6 1CA2 7EA5 0709 6538"
   (name "timmy"))))
```

The fingerprint is from `gpg --fingerprint` and the name is just a
comment so you remember what it is. You'll also have a `.guix-channel`
file that can point to a subdirectory to add to the Guile path:

```scheme
(channel
 (version 0)
 (directory "channel"))
```

In `channel/timmy/coredns.scm`, I have code for the package and
service:

```scheme
(define-module (timmy coredns)
  #:use-module (gnu packages admin)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (guix packages)
  #:use-module (guix records)

  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system go)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (srfi srfi-1)
  
  #:export (
            coredns-configuration
            coredns-service
            coredns-service-type))

(define-public coredns
  (let ((commit "78de01a9cddf140c04ec3c4095195177d21cacff")
	(revision "0"))
    (package
     (name "coredns")
     (version (git-version "1.8.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/timmydo/coredns")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
	       (base32 "02gdj866mz17p1f0fgfjpbb9cah2ykziacahpkw0viq1vj231hai"))))
     (build-system go-build-system)
     (arguments
      '(#:import-path "github.com/timmydo/coredns"))
     (synopsis "DNS server/forwarder, written in Go, that chains plugins")
     (description "CoreDNS is a fast and flexible DNS server.
  The key word here is flexible: with CoreDNS you are able to do
what you want with your DNS data by utilizing plugins.  If some
functionality is not provided out of the box you can add it by
writing a plugin.")
     (home-page "https://github.com/coredns/coredns")
     (license license:asl2.0))))


(define-record-type* <coredns-configuration>
  coredns-configuration make-coredns-configuration
  coredns-configuration?
  (package coredns-configuration-package
           (default coredns))
  (name coredns-configuration-name (default "default"))
  (port coredns-configuration-port (default 1053))
  (config-file coredns-configuration-config-file
               (default "/etc/Corefile")))

(define %coredns-accounts
  (list (user-group (name "coredns") (system? #t))
        (user-account
         (name "coredns")
         (group "coredns")
         (system? #t)
         (comment "coredns server user")
         (home-directory "/var/empty")
         (shell (file-append shadow "/sbin/nologin")))))

(define (coredns-shepherd-service config)
  (match-record config
      <coredns-configuration>
    (package name port config-file)
    (let ((coredns-bin (file-append package "/bin/coredns"))
          (log-filename (string-append "/var/log/coredns-" name ".log")))
      (list (shepherd-service
             (provision '(coredns))
             (documentation "Run the coredns daemon.")
             (requirement '(networking))
             (start #~(make-forkexec-constructor
                       `(#$coredns-bin
                         #$@(list "-conf" config-file)
                         #$@(list "-dns.port" (number->string port)))
                       #:user "coredns" #:group "coredns"
                       #:log-file #$log-filename))
             (stop #~(make-kill-destructor)))))))

(define coredns-service-type
  (service-type
   (name 'coredns)
   (extensions
    (list (service-extension shepherd-root-service-type
                             coredns-shepherd-service)
          (service-extension account-service-type
                             (const %coredns-accounts))))
   (compose concatenate)
   (default-value (coredns-configuration))
   (description "Run the coredns Web server.")))

```

To consume this channel, you need to add/edit `/etc/guix/channels.scm`
to:

```scheme
(cons (channel
       (name 'timmy-packages)
       (url "https://github.com/timmydo/guix-channel.git")
       (branch "main")
       (introduction
	(make-channel-introduction
	 "4cec36d449afcf0a6c70e1b63b12bd73372cd122"
	 (openpgp-fingerprint "4334F13EFD13BC4D7F5E69B61CA27EA507096538"))))
      %default-channels)
```

Then run `guix pull` to fetch that channel. Then you can run `guix
system reconfigure /etc/config.scm` on your `config.scm`:

```scheme
(use-modules (gnu))
(use-modules (gnu services admin))
(use-modules (gnu services monitoring))
(use-modules (gnu services networking))
(use-modules (gnu services sysctl))
(use-modules (timmy coredns))
(use-service-modules desktop networking ssh xorg)
```

This sets up nftables config with enp2s0 as LAN and enp4s0 as WAN. A
work in progress.

```scheme
(define %my-nftables-ruleset
  (plain-file "nftables.conf"
	      "
flush ruleset

table ip nat {
  chain prerouting {
    type nat hook prerouting priority 0; policy accept;
    iif enp2s0 udp dport 53 counter redirect to :1053
  }
  chain postrouting {
    type nat hook postrouting priority 100; policy accept;
    iif enp2s0 ip saddr 10.18.0.0/16 oifname enp4s0 masquerade
    
  }
  chain output {
    type nat hook output priority 100; policy accept;
  }
}

table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;

    # early drop of invalid connections
    ct state invalid counter drop

    # allow established/related connections
    ct state { established, related } counter accept

    # allow from loopback
    iifname lo counter accept

    # allow icmp
    ip protocol icmp counter accept
    ip6 nexthdr icmpv6 counter accept

    # allow ssh
    ip saddr 10.18.0.0/16 tcp dport ssh counter accept

    # allow dns
    ip saddr 10.18.0.0/16 udp dport { 53, 1053 } counter accept

    # reject everything else
    reject with icmpx type port-unreachable
  }
  chain forward {
    type filter hook forward priority 0; policy accept;
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}
"))
```

This part sets up the DNS configuration. This is probably straight
from another post.

```scheme
(define %corefile
  (plain-file "Corefile"
	      "
. {
  bind 10.18.11.4
  prometheus
  errors
  cache
  forward . tls://9.9.9.9 tls://[2620:fe::fe]:853 {
    tls_servername dns.quad9.net
    health_check 15s
  }

  hosts {
    10.18.11.4 timmydns
    fallthrough
  }
}
"))
```

This sets up dhcpd.conf. Nothing special here besides my random
internal LAN IP addresses.


```scheme
(define %my-dhcpd-config
  (plain-file "dhcpd.conf"
	      "
option domain-name-servers 10.18.11.4, 10.18.11.2;
default-lease-time 14400;
max-lease-time 28800;


subnet 10.18.0.0 netmask 255.255.0.0 {
  option routers 10.18.11.4;
  pool {
    range 10.18.12.10 10.18.12.250;
  }
}
"))
```

This sets up the base system and what packages are installed. The
hardware here is a [Lenovo
M90n](https://slickdeals.net/e/14734595-lenovo-thinkcentre-m90n-iot-desktop-i3-8145u-uhd-graphics-4gb-ddr4-128gb-ssd-200-free-shipping?src=SiteSearchV2_SearchBarV2Algo1)
I got for $200.

```scheme
(operating-system
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "timmy-m90n")
  (users (cons* (user-account
                  (name "timmy")
                  (comment "Timmy")
                  (group "users")
                  (home-directory "/home/timmy")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
     (map specification->package
	  '("nss-certs"
	    "emacs-next-pgtk"
	    "git"
	    "gnupg"
	    "zsh"
	    "coredns"
	    "btrfs-progs"
	    "nftables"
	    "curl"))
      %base-packages))
```

These are the system services orchestrated through GNU Shepherd
(rather than systemd). I use network manager for the network config.
You can use `nmtui` to set that up separately--it's unfortunate that it
isn't included in this configuration file. This also references the
CoreDNS, dhcpd, and nftables config above. I also turn on IP
forwarding here.

```scheme
  (services
    (append
      (list (service openssh-service-type)
	    (service unattended-upgrade-service-type)
	    (service network-manager-service-type)
	    (simple-service '%my-nftables-ruleset etc-service-type (list `("nftables.conf" ,%my-nftables-ruleset)))
	    (simple-service '%corefile etc-service-type (list `("Corefile" ,%corefile)))
	    (service dhcpd-service-type
		     (dhcpd-configuration
		      (config-file %my-dhcpd-config)
		      (version "4")
		      (interfaces '("enp2s0"))))
	    (service coredns-service-type
		     (coredns-configuration (config-file "/etc/Corefile")))
	    (service nftables-service-type
		     (nftables-configuration (ruleset %my-nftables-ruleset)))
	    (service prometheus-node-exporter-service-type
		     (prometheus-node-exporter-configuration
		                           (web-listen-address ":9100")))
            (service wpa-supplicant-service-type))
      %base-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "5c18bc14-16e5-4e76-b1b4-9ad71bececbb")))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "c70fdb86-0828-4ddf-a275-21613e9c2c1b"
                     'btrfs))
             (type "btrfs"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "BA8F-DDF3" 'fat32))
             (type "vfat"))
           %base-file-systems)))
```

