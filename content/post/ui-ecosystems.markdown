---
date: 2024-12-20
tags:
- ui
- sdk
title: "User Interface Ecosystems"
---

When I think about how I use a computer these days, there are only a
handful of user interface technologies. The most pervasive and
widespread is probably interfaces rendered through a web
browser. I feel like half of my computer usage is through what could
be considered a
[shell](https://en.wikipedia.org/wiki/Shell_(computing)), and the
other half would be through the browser.


Shells like Gnome and KDE each have their own UI toolkits: GTK and
Qt. Generally their usage is limited to their respective desktop
environment ecosystem.

What shell do I use? Well it's a mix of [Sway](https://swaywm.org/),
GNU Emacs, and foot (a terminal emulator). I use Emacs for editing
files, browsing directories, and reading email/news. The remaining
terminal emulator is for running command line applications or running
programs on remote computers. Pretty much everything else happens in a
web browser.


I've had the idea of trying to simplify things further by either
running Emacs inside of a terminal emulator or by running a terminal
emulator inside of Emacs. Running Emacs inside of a terminal emulator
is too limiting--while modern terminal emulators have some support for
mouse events and graphics, it isn't as usable is running it
natively. On the other hand, Emacs does have some terminal emulator
capabilities, but I found it cumbersome to use compared to just having
sway launch foot. Might as well stick to the best tool for the job. I
don't really see a big need to integrate that into Emacs--the unix
philosophy of smaller simpler programs seems to work just fine
there. There isn't much ecosystem overlap, so there isn't much benefit
to consolidation.

My main interactions with my personal computer these days are reading
email and news, both of which I get through Emacs/notmuch. I sometimes
think about whether I should create a dedicated application to replace
my email/news usage. If I went with the web ecosystem, perhaps I
could replace Emacs with a simpler text editor, but then I would need
to add all the Emacs functionality to my new email/news agent. At this
point, which I think I have blogged about previously, I find it
unfortunate that the web ecosystem is so big, so maybe I should choose
to stay in the Emacs ecosystem. I have used aerc for email from the
terminal in the past, but I like having another software ecosystem in
between terminal emulators and web browsers.


