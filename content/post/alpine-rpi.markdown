---
date: 2022-02-13
tags:
- alpine
- raspberry
- pi
title: "Alpine on Raspberry Pi 4"
---

A couple of weeks ago, I found my Raspberry Pi 4 8GB that I bought in
July of 2020 sitting on a shelf, turned off for the last year. I
thought it would be worth trying to get working again, so I set off to
install Alpine Linux for it. I wasn't intending to make a blog post
about it, otherwise I would have taken notes on the experience.


Alpine Linux provides a Raspberry Pi specific image--it's a `tar.gz`
file that needs to be extracted into a fat16 partition on the SD
card. I followed the [instructions
here](https://wiki.alpinelinux.org/wiki/Classic_install_or_sys_mode_on_Raspberry_Pi). It
wasn't the smoothest experience.

After I extracted the files to a fat16 partition and booted, I was
greeted by a rainbow screen and seven (7) blinks on the Raspberry
Pi. Apparently that means that the kernel image wasn't found. Luckily,
I came across [this
post](https://raspberrypi.stackexchange.com/questions/119608/rpi-4b-cant-find-the-alpine-kernel-green-light-flashes-7x)
describing a fix: edit the config.txt on the boot partition to specify
kernel and initramfs images in the root directory. It seems like the
Raspberry Pi boot logic can read this text file from the partition,
but maybe it does not have the correct logic on my version to follow links into
subdirectories. Well, luckily that worked and then I was able to boot
into Alpine.

Next I ran the `setup-alpine` script, answered some questions, but
near the end it couldn't find a device to install onto, so the script
failed and left me at a prompt without any of my options saved
anywhere (that I could find). Searching online (it's also written in
red on the install page, but I did not connect the dots at the time),
there seems to be a tool called `setup-disk` that allows you to just
specify the root partition to install Alpine on. I wanted the classic
sys mode that gives me a writable root partition. I got an error when
trying to run this command though, because the `setup-disk` script for
Raspberry Pi did not like that the root partition I mounted was
ext4. It seemed like a bug in the installer. I found some helpful
details
[here](https://gitlab.alpinelinux.org/alpine/aports/-/issues/12353#note_152951). The
source code for the installer shows the vfat check can be [overridden
here](https://github.com/alpinelinux/alpine-conf/blob/e2965a2d5d90297741fd37a1090fe49bc411c65b/setup-disk.in#L461). So
after `export FORCE_BOOTFS=1`, I was able to get `setup-disk` to
install to my mounted `/dev/mmcblk0p2`. I think I had to do one other thing
like editing the config.txt to provide my root partition before rebooting.

Things seemed to work after rebooting, but I
probably missed a step to mount `/dev/mmcblk0p1` as `/boot` so that
system updates would update my kernel there. Maybe that will be
a task for another day. First, I need to find something to do with this
little computer.
