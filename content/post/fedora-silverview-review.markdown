---
date: 2021-12-01
tags:
- fedora
- silverblue
- guix
title: "Fedora Silverblue Initial Impressions"
---

Yesterday, I installed Fedora Silverblue into a KVM-enabled qemu image
from my GNU Guix desktop. I was attracted to the immutable design
which is fairly similar on the surface to how GNU Guix works. Under
the covers, it's a lot different, but I thought I'd go over my initial
impressions.

Fedora Silverblue is distributed with an ISO image which boots into a
graphical (i.e. GTK) installer. It's one of the shortest and easiest
Linux installs I've done. That said, I didn't have to worry about any
sort of hardware compatibility given I was running it on virtual
hardware. Because the OS runs on an immutable image, there weren't
many options in the installer with respect to choosing initial
software.

When you boot in and take a look around, it looks like this:

![directory listing of root](/assets/fedora-root.png)

Basically `/var` and `/etc` are writable. `/home` and `/root` are
moved inside `/var`. Binary directories are moved to `/usr`. See also:
[TheCaseForTheUsrMerge](https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/).


Here is the [filesystem
layout](https://docs.fedoraproject.org/en-US/fedora-silverblue/technical-information/#filesystem-layout).


![mounted volumes](/assets/fedora-mount.png)

The `/usr` directory is mounted read-only. The binaries there
basically come from
[OSTree](https://ostreedev.github.io/ostree/introduction/). There are
three ways to install software:

1. `rpm-ostree install` which creates a new system image atomically
   and requires you to reboot into it to take effect. (You can boot
   into previous versions). This might be what you use to install core
   OS components like your shell, wayland compositor, libvirt, etc.
   
2. [Flatpak](http://flatpak.org/). I haven't tried this one. I sort of
   think of it like Ubuntu snaps, which I never tried out either. I
   think you would use this for general consumer software like GUI
   chat clients, office apps, games, etc.

3. [toolbox](https://github.com/containers/toolbox). This is a layer
   over podman (same idea as docker) that seems to have some quality
   of life improvements for developers or regular users that want a
   sandbox environment. I think the ideal scenario here is if you `git
   clone` some project you are working on to `~/src/myproject`, you
   could create a toolbox for working on that project. When you run
   `toolbox create`, you'll get a regular fedora distribution by
   default. If you're working on a python project, you `toolbox enter`
   then `dnf install python` and whatever else you want, and the
   installed things will just be local to that toolbox. I haven't
   played with toolbox for more than a few minutes, but I have a few
   worries about getting too comfortable with a semi-ephemeral
   development environment. It feels like it could be a gray area
   between pet and cattle.


While it might be confusing to average users to have at least 3 ways
to install software, they all have their own pros and cons, so I
appreciate having the flexibility to make my choice. I think they
should change the default behavior of `rpm-ostree install` in
non-server environments to run `rpm-ostree ex apply-live` to avoid the
reboot. I feel like they should be able to figure out how to get
systemd to restart the services.


Since managing installed software is a large part of the operating
system experience, you might wonder how these three options compare to
GNU Guix. Guix is fairly similar in that it has a read-only/immutable
software partition. While Silverblue uses flatpak and toolbox for
library conflict resolution, Guix can install conflicts side-by-side
due to the way it structures the file system. Probably best explained
like this:

```
> which ldd
/home/timmy/.guix-profile/bin/ldd

> ll /home/timmy/.guix-profile/bin/ldd
lrwxrwxrwx 17 root root 74 Dec 31  1969 /home/timmy/.guix-profile/bin/ldd -> /gnu/store/k2gkdpplnnvknfa1c3sdlzbvx6bs468m-clang-toolchain-12.0.1/bin/ldd

> ldd /gnu/store/k2gkdpplnnvknfa1c3sdlzbvx6bs468m-clang-toolchain-12.0.1/bin/ar
	linux-vdso.so.1 (0x00007ffe2c7f2000)
	libdl.so.2 => /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/libdl.so.2 (0x00007fc0a0dee000)
	libc.so.6 => /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/libc.so.6 (0x00007fc0a0c31000)
	/gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/ld-linux-x86-64.so.2 => /gnu/store/ksy2b6fwfmz40gjajvspl87ia4vsfzj7-glibc-2.31/lib/ld-linux-x86-64.so.2 (0x00007fc0a0df5000)
```

So `ar` might use glibc-2.31 but some other package could use it's own
version. Guix is smart enough to share the same `/gnu/store` version
if two packages use the same version. This way conflicts can be
resolved without containers/chroot. When you install software to
`/gnu/store` through `guix install`, you don't have to reboot either,
which is nice. When you do `guix system reconfigure` to upgrade system
packages or system services, shepherd (Guix init system) will
restart them.

I think Guix overall has a more technically elegant solution for
managing software, but Silverblue is worse-is-better and more
mainstream. I think for an ephemeral development environment, `guix
shell` has advantages over `toolbox`, but it might really depend on
your scenario. I think Silverblue will have better container support
out of the box, so if you work with containers, Silverblue will be
easier to get started with. As of this writing, Guix only supports an
old version of docker. Separately I tried [packaging podman for
Guix](https://debbugs.gnu.org/cgi/bugreport.cgi?bug=52174). It took a
couple hours on a Sunday and I was able to run an alpine image without
sudo. But that might not be an option for everyone unless you are
comfortable picking up Guile Scheme and rolling your own
packages. With Guix, you will have more luck packaging software than
trying to compile something outside of the packaging system due to the
nonstandard paths.


systemd has a larger 'compatibility list' than GNU shepherd, and I
feel you are more likely to find yourself in a "Sadly Outta Luck"
situation using Guix than you would with Silverblue. If you prefer to
use free software, I think Guix is a better fit due to the focus on it
and aversion to software telemetry. I was thrown off a bit when
Silverblue asked me if I wanted to connect a social media account
during the install process. Thankfully it allows you to skip that
step, but I could never imagine Guix having a prompt like that.


Long story short, while I could imagine installing Fedora Silverblue
on a workstation for work, I think Guix might be a better fit for me
on my personal machine where I enjoy the practice of system crafting.
