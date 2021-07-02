---
date: 2021-07-01
tags:
- mtpfs
- jmtpfs
- phone
- android
- backup
title: "Backing up photos from an Android phone"
---

There are a lot of applications that can help you back up photos from
your phone, but many do not give you the freedoms you expect from free
software. I believe GUI-based apps make this more difficult than
it needs to be. I have decided that I will start using command line
tools for this from now on. Here is the magic sauce:

```
jmtpfs ~/mnt
rsync -vrt ~/mnt/Internal\ shared\ storage/DCIM/Camera/ /mnt/backup/photos/phone
```

`-vrt` is verbose, recursive, and include timestamps. `rsync` will use
timestamps/file sizes to decide if it needs to recopy files. The first
run wrote this at the end:

```
sent 20,719,784,884 bytes  received 23,956 bytes  30,582,743.68 bytes/sec
total size is 20,714,634,422  speedup is 1.00
```

The second invocation returned immediately:

```
$ rsync -vrt ~/mnt/Internal\ shared\ storage/DCIM/Camera/ /mnt/backup/photos/phone
sending incremental file list

sent 44,653 bytes  received 63 bytes  29,810.67 bytes/sec
total size is 20,714,634,422  speedup is 463,248.82
```

Unmount with `fusermount -u ~/mnt`. Link to [jmtpfs](https://github.com/JasonFerrara/jmtpfs).

