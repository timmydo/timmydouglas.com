---
date: 2021-11-17
tags:
- process supervision
- service supervision
- daemontools
- service manager
title: "Process supervision"
---

Recently I was looking for a lightweight user-level service
manager. In most Linux distributions these days, systemd is the
default. systemd allows you to create user-specific services, but by
default you'll need to start them when you login unless you set up
[lingering](https://www.freedesktop.org/software/systemd/man/loginctl.html#enable-linger%20USER%E2%80%A6).


My primary desktop computer runs GNU Guix, which comes with [GNU
Shepherd](https://www.gnu.org/software/shepherd/manual/shepherd.html)
for managing services. It's fine and all, but I was sort of looking
for a method to start a bunch of processes that isn't distro specific,
and potentially something I could use in other places such as in
containers.


Actually, I'm not sure that I was actively searching for this sort of
technology or I just stumbled upon one of jessfraz's
[Dockerfiles](https://github.com/jessfraz/dockerfiles/blob/master/postfix/Dockerfile)
and noticed the usage. The linked Dockerfile uses runit to run postfix
and syslog together in a docker container. It's pretty simple--just
create a parent directory with child directories for each process you
want to run, and in the child directory put a `run` script that runs
the process.


After investigating this a little more, it seems like most of this
process supervision stuff originated from djb's
[daemontools](https://cr.yp.to/daemontools.html). Guix packages
daemontools, but while I was looking into it, I came across
[s6](https://skarnet.org/software/s6/index.html). s6 was interesting
to me because it looks to be written by an opinionated developer that
spent more time comparing the technologies than I could easily find
elsewhere.

It was pretty easy to set up. I just created a couple of directories
under `~/.config/service` with `run` scripts in them, then ran
`s6-svscan ~/.config/service`. Since I'm not running Guix with the
`%desktop-services`, I needed to manually start `pipewire`,
`pipewire-pulse`, and `pipewire-media-session` for audio to work. Not
to mention running `dbus-run-session sway` when starting my desktop
environment so that dbus could hook things up that depended on it
(rhythmbox).

