---
date: 2021-09-13
tags:
- wayland
- netsurf
title: "GUI Apps without a toolkit"
---

My desktop experience on my personal machine is fairly simple:
  - Ubuntu with Guix (planning to move to pure Guix next week when I
    build a new desktop)
  - The sway compositor with swaystatus
  - Emacs (pgtk + native-comp) for email/RSS news, text editing,
    coding, dired mode
  - Firefox for web
  - Alacritty for all terminal apps
  - Rhythmbox for music (occasionally)
  
If you were to write a new GUI application these days you might
consider:

  - Web browser technology/Electron/etc. See [The reckless, infinite
    scope of web
    browsers](https://drewdevault.com/2020/03/18/Reckless-limitless-scope.html). I
    don't like the idea of building a complex UI in a web browser--it
    feels wasteful.
  - A toolkit like GTK or Qt. Typically they work best for a small set
    of languages--i.e. use GTK for C code and Qt for C++ code. These
    are more like application frameworks now than 'toolkits'
    though. They have become more bloated with all the features they
    bring.
  - https://en.wikipedia.org/wiki/List_of_widget_toolkits

If you're using C, a lot of the options are off the table. Many video
games write their own custom UI widgets, so why not go down that path?
Inspired by
[visurf/netsurf](https://drewdevault.com/2021/09/11/visurf-announcement.html)
(and using some of the code), I wrote a text editor that talks
directly to the Wayland compositor using Cairo. You can use [this
tutorial](https://wayland-book.com/) to learn about the Wayland
protocol.

I would say the the whole GTK to Wayland effort added about 500 lines
of code after taking out GTK4. Most of it's just boilerplate to set up
a window you can draw on, keyboard callbacks, etc. But I think it's
better in the end--I wasn't really using any features that it provides
since I was just drawing on a cairo surface.

It still feels like there are a lot of dependencies though. Even
lightweight programs are heavy these days.

```
$ ldd bin/tem
	linux-vdso.so.1 (0x00007ffe44b70000)
	libwayland-client.so.0 => /home/timmy/.guix-profile/lib/libwayland-client.so.0 (0x00007f319876a000)
	libwayland-cursor.so.0 => /home/timmy/.guix-profile/lib/libwayland-cursor.so.0 (0x00007f3198760000)
	libpangocairo-1.0.so.0 => /home/timmy/.guix-profile/lib/libpangocairo-1.0.so.0 (0x00007f319874f000)
	libpango-1.0.so.0 => /home/timmy/.guix-profile/lib/libpango-1.0.so.0 (0x00007f3198702000)
	libgobject-2.0.so.0 => /home/timmy/.guix-profile/lib/libgobject-2.0.so.0 (0x00007f31986a3000)
	libglib-2.0.so.0 => /home/timmy/.guix-profile/lib/libglib-2.0.so.0 (0x00007f319857c000)
	libharfbuzz.so.0 => /home/timmy/.guix-profile/lib/libharfbuzz.so.0 (0x00007f3198473000)
	libcairo.so.2 => /home/timmy/.guix-profile/lib/libcairo.so.2 (0x00007f3198355000)
	libxkbcommon.so.0 => /home/timmy/.guix-profile/lib/libxkbcommon.so.0 (0x00007f3198313000)
	libm.so.6 => /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/libm.so.6 (0x00007f31981d2000)
	libgcc_s.so.1 => /gnu/store/28bcmy08ki5krvr2g9hbm3bhys822fvn-gcc-11.2.0-lib/lib/libgcc_s.so.1 (0x00007f31981b7000)
	libc.so.6 => /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/libc.so.6 (0x00007f3197ff8000)
	libffi.so.7 => /gnu/store/bw15z9kh9c65ycc2vbhl2izwfwfva7p1-libffi-3.3/lib/libffi.so.7 (0x00007f3197feb000)
	libpthread.so.0 => /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/libpthread.so.0 (0x00007f3197fca000)
	libpangoft2-1.0.so.0 => /gnu/store/bdyk3x43bj8gjlx4jrpw00i7cpyv7fhq-pango-1.44.7/lib/libpangoft2-1.0.so.0 (0x00007f3197fb0000)
	libfontconfig.so.1 => /gnu/store/k6zs6zabhfybh6aphc4988wc2fsyk5hh-fontconfig-2.13.1/lib/libfontconfig.so.1 (0x00007f3197f6b000)
	libfribidi.so.0 => /gnu/store/llccvnpm1dm94d7lndrhs2m6421p45pd-fribidi-1.0.9/lib/libfribidi.so.0 (0x00007f3197f4d000)
	libpcre.so.1 => /gnu/store/k0aqiy7yx8n28dvm3f0a04ka5sd8y950-pcre-8.44/lib/libpcre.so.1 (0x00007f3197eda000)
	libfreetype.so.6 => /gnu/store/j3f5hx6yvhlj3sapiipigkwg05b49nwn-freetype-2.10.4/lib/libfreetype.so.6 (0x00007f3197e2a000)
	libbz2.so.1.0 => /gnu/store/i8h2pcxqdq07ijm3ibkka8f4smn1w48v-bzip2-1.0.8/lib/libbz2.so.1.0 (0x00007f3197e17000)
	libpng16.so.16 => /gnu/store/3x2kak8abb6z2klch72kfff2qxzv00pj-libpng-1.6.37/lib/libpng16.so.16 (0x00007f3197de2000)
	libz.so.1 => /gnu/store/rykm237xkmq7rl1p0nwass01p090p88x-zlib-1.2.11/lib/libz.so.1 (0x00007f3197dc2000)
	libgraphite2.so.3 => /gnu/store/8k726y9bzi4zmclc240l78q6s7pyaff5-graphite2-1.3.13/lib/libgraphite2.so.3 (0x00007f3197d9b000)
	libpixman-1.so.0 => /gnu/store/xwl0p4m34bcan0v9vkjkyzwi6znsv4dm-pixman-0.38.4/lib/libpixman-1.so.0 (0x00007f3197cf4000)
	libxcb-shm.so.0 => /gnu/store/lv92cmzqjpb8mxygpqdvh0mkkkfi9vmz-libxcb-1.14/lib/libxcb-shm.so.0 (0x00007f3197cef000)
	libxcb.so.1 => /gnu/store/lv92cmzqjpb8mxygpqdvh0mkkkfi9vmz-libxcb-1.14/lib/libxcb.so.1 (0x00007f3197cc6000)
	libxcb-render.so.0 => /gnu/store/lv92cmzqjpb8mxygpqdvh0mkkkfi9vmz-libxcb-1.14/lib/libxcb-render.so.0 (0x00007f3197cb6000)
	libXrender.so.1 => /gnu/store/5vblqnckq2v8n1sk5fs5aq2vr2z5vl65-libxrender-0.9.10/lib/libXrender.so.1 (0x00007f3197ca8000)
	libX11.so.6 => /gnu/store/zm5x7j8vaaqr5nfrzi2ql96p5rgbj8sr-libx11-1.7.1A/lib/libX11.so.6 (0x00007f3197b69000)
	libXext.so.6 => /gnu/store/yfv9bvcavfdlnv7arbrk492l7mw4ryl8-libxext-1.3.4/lib/libXext.so.6 (0x00007f3197b55000)
	librt.so.1 => /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/librt.so.1 (0x00007f3197b4b000)
	/gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/ld-linux-x86-64.so.2 => /gnu/store/ksy2b6fwfmz40gjajvspl87ia4vsfzj7-glibc-2.31/lib/ld-linux-x86-64.so.2 (0x00007f319877d000)
	libexpat.so.1 => /gnu/store/g7pznwv07852px2c1bm5gkafiwnvblba-expat-2.4.1/lib/libexpat.so.1 (0x00007f3197b13000)
	libuuid.so.1 => /gnu/store/a45p39mgqvfd8kjwibyr0q42k1mw7gmf-util-linux-2.35.1-lib/lib/libuuid.so.1 (0x00007f3197b0a000)
	libXau.so.6 => /gnu/store/h7sy4hr7arjknbyy1aq0xwv6fksnzw9n-libxau-1.0.9/lib/libXau.so.6 (0x00007f3197b05000)
	libXdmcp.so.6 => /gnu/store/6cdl970wcv4jhvpgbh8sdj54a5gwhmwj-libxdmcp-1.1.3/lib/libXdmcp.so.6 (0x00007f3197afd000)
	libbsd.so.0 => /gnu/store/cqwj25wxzzs8frz5c9alqns24bcfspqz-libbsd-0.10.0/lib/libbsd.so.0 (0x00007f3197ae2000)
	libdl.so.2 => /gnu/store/fa6wj5bxkj5ll1d7292a70knmyl7a0cr-glibc-2.31/lib/libdl.so.2 (0x00007f3197add000)
```
