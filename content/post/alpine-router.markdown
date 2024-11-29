---
date: 2024-11-29
tags:
- router
- linux
title: "Alpine Linux Router (was: Guix System Router)"
---

I recently replaced my GNU Guix-based router with Alpine Linux. I
previously ran a small amd64 Guix system router, which boasted an
uptime of more than 1000 days. I know that's not a great security
practice and I was setting myself up for failure when it rebooted
finally, which it did after a 5+ day power outage in our area.

The computer was at the point where both `guix pull` failed and `guix
system reconfigure` failed. I probably should have tried to capture
why, but in the end, I don't think that's what's important. The
important part is that when those basic operations inevitably fail,
you need to be one of the handful of people in the world
with knowledge of the system internals to fix it. This reminds me of a
[blog
post](https://drewdevault.com/2023/07/25/Alpine-does-not-make-news.html)
about Alpine Linux and the importance of simplicity. When something
fails in Alpine Linux, it's easier to root cause the component because
there aren't a bunch of configuration abstraction layers between the
actual programs that do the work.

At some point, all software will fail, so it's important that a human
can both understand what the issue is and how it might be fixed. With
Guix system, I wasn't confident in my ability to fix a random Scheme
issue in a shepherd backtrace. Or even what my options are when
something like `guix pull` fails. My opinion is that Guix should keep
the usage of Scheme to just the package configuration and build
tooling, but the runtime system should not be using it in the critical
path. I think doing so would be a pretty fundamental change
though. Perhaps it would be possible to create a read-only root image
spin on it by using Guix to compile something like ostree snapshots.

Guix system has multiple layers of complexity that I didn't want to
deal with. First your system configuration is in Scheme, and I pretty
much had to use that to write configuration files to disk for services
that didn't have system service abstractions, which was pretty
clunky. Then system services are configured in Scheme, but that part
is another abstraction for generating the actual configuration
files. The Shepherd service manager that orchestrates it all feels like a
black box to me. While I am happy Guix is not adopting a systemd-based
monoculture, I feel like they would do better with a simpler
file-based service manager. The user vs root usage of `guix` is
confusing for newcomers, and that would be eliminated if you just had
a simpler way to manage system configuration files (preferably
read-only snapshot based).

While this blog post was intended to be more of a journal entry, I
feel like it's turning into more of a rant on what I'd want out of a
Linux distro. I sort of feel like beyond the basic system services, we
should be adopting more of a containerized model with locked down
permissions. I use a flatpak-based Firefox as my web browser. Web
browsers are probably the most complicated piece of software
distros package, so maybe new distros in the future could just focus
on core services and then rely on containers like Fedora Silverblue
for the rest.

