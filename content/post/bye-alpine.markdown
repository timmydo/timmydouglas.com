---
date: 2025-10-05
tags:
- mta
- email
- self-hosting
title: "Bye to the Alpine Linux Mail Server. Hello Stalwart."
---

Yesterday, I was doing an Alpine dist upgrade (3.18 to 3.19) to my
mail server, which apparently I thought was such a routine job that I
didn't have any backups. Now, imagine my fear after typing `reboot`
and the machine not coming back. I fumbled around the AWS UI trying to
find out was going on--I found the serial console and saw this:

```
Loading Linux virt ...
error: invalid magic number.
Loading initial ramdisk ...
error: you need to load the kernel first.
```

Yikes! I'm not so sure how to fix that kind of issue on a remote
machine in the cloud. My first instinct was to attach another volume
to boot from, but it felt like my first time using the AWS UI, and I
couldn't find anything I wanted in it. With my mail server offline, I
was risking mail not being delivered, bouncing, etc. Something you'd
normally have a BC/DR solution figured out for, except I guess my
email doesn't rise to the level to have backups figured out. I use
`mbsync` to get the mail locally, so it's not like I'm that worried
about losing messages that I had already downloaded.


I made the quick decision to just spin up a new machine and setup
SMTP/IMAP/ACME from scratch. Ironically, I was reading a [hacker news
article](https://news.ycombinator.com/item?id=45473730) when I was
upgrading the alpine box, and was intrigued by
[stalwart](https://stalw.art/). I had long wanted to create something
equivalent for myself--a single binary self-contained solution for
email with database options other than files on disk. It looked like
this ticked all the boxes so I thought I'd try to set it up for the
first time while my email was down. Unfortunately, given the time
constraint, I didn't really have time to set it up the way I wanted.


I started by creating another nano ARM Amazon Linux machine,
installing stalwart, fixing DNS because I didn't use an elastic IP
(and made the same mistake twice creating this one), and setting up
everything over the web UI. I wish I had selected the postgres
backend, but the default RocksDB is probably fine for hosting a single
account. I enjoy having the server itself take care of the TLS certs
with ACME, so I don't have to run certbot with post-hooks to restart
dovecot/smtpd. I would say the core email setup probably took like 5
minutes, and I was able to complete the rest of the stuff within an
hour: learning AWS UI, finding the firewall ACL, fixing DNS, etc. The
stalwart web interface could use some work--the settings and
configuration left-hand panel changes depending on the context, and I
had a hard time finding what I needed. The search feature was a nice
touch though.

From what I can tell so far, everything seems fine, but I think the
upgrade story of a fully-integrated MTA will be more tricky. I'll have
to consider database migrations, manually updating a rust binary,
etc. With OpenSMTPD and dovecot, I didn't really have to do anything
to upgrade because it was included with the distro and updated with
packages. I should mention somewhere that my self-hosting solution is
just for receiving email. I pay Migadu for sending email. I believe
that's the right balance of control and pain. I might send a couple
emails a week, but I subscribe to email lists that might bump up the
count for any services that charge based on emails received. I also
prefer to store my email on a server that I control.

After I was back up and running, I was able to detach the alpine disk
volume from the old computer and reconnect it to the new computer to
grab any files I needed. I don't think there was anything there but it
was pretty easy to backup the Maildir just in case. There were
probably a lot of things I could do differently, like maybe I should
have thought of creating an EBS volume just for the mail app so I
could migrate that between machines easier. Or I could have tried a
cloud-hosted postgresql instance, to further separate the compute and
the data. I set up automated snapshots, but I think I'd prefer an
option that separates the operating system out more. The mail service
is already available as a container, so in the future it would be
interesting to see I could run it on a simple container runtime so I
wouldn't have to think about OS upgrades.


