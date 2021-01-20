---
date: 2021-01-20
tags:
- system crafting
- Lisp
- Emacs
title: "System Crafting"
---

I've been following a newish [youtube channel](https://www.youtube.com/channel/UCAiiOTio8Yu69c3XnR7nQBQ) for the last couple of months
which mostly started with Emacs from scratch videos, but now looks to
be evolving towards a term they coined as system crafting. I recommend
the channel to anyone looking to learn more about Emacs or system crafting.

_System crafting is basically the practice of tailoring your computer to be
enjoyable and effecient to use._

In some ways it reminds me of
[r/battlestations](https://old.reddit.com/r/battlestations/) or
[r/unixporn](https://old.reddit.com/r/unixporn/). It's a hobby I've
had ever since I discovered FOSS or various Linux distros--probably 20
years ago. Back then, there wasn't anything like Ubuntu that just gave
you a desktop out of the box. Instead, you would instead spend time trying to
build a linux kernel that had all the right drivers, get a working
XF86Config (xorg.conf), choose a window manager, choose a terminal
app, etc. Every step of the way you got to choose what piece of
software you were going to use and then you spent a decent amount of
time setting it up the way you wanted. The only thing I can think of
being similar in the Windows world would be skinning winamp or
download some custom theme (WindowBlinds?). But Windows and MacOS
never really gave you the same level of tinker-ability. 

But this blog entry isn't just about creating a custom nix
environment, just like the youtube channel at the top hasn't really
discussed system crafting much yet. It's about Emacs, the extensible,
self-documenting text editor that comes about the same as your
mid-2000s Linux distro--like a bunch of components that need to be
tailored together before you have an excellent lisp
machine. Unforunately most people don't have enough time or patience
to build their own shell or text editor, but if they do, you can spend
a lifetime modifying emacs through its config file.

