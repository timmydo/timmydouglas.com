---
date: 2022-04-09
tags:
- ui
- paradigm
- web
- terminal
title: "A new UI paradigm and self-sufficiency"
---

I wonder if it's time for a new user interface paradigm.

On one hand, we have the [computer
terminal](https://en.wikipedia.org/wiki/Computer_terminal), which has
been around for about 50 years now. It was designed for hardware from
a different era. While modern terminal emulators (I currently use
[foot](https://codeberg.org/dnkl/foot)) have things like sixel image
support, colors, and features that let you click on URLs, it is still
a fairly primitive design. Terminal UIs (TUIs) generally only support
keyboard input, and they are pretty simple, which is good because
there is a wide variety of implementations to choose from. The
majority of the programs I run on my computer are in a terminal emulator.


On the other hand, we have the web browser, which supports many
different communication protocols, HTML/CSS/JavaScript, and is the
probably the most complicated piece of software most people use
today. The same technology stack is reused to create portable client
applications with frameworks like Electron. The problem with modern
web browsers is that the complexity of creating one is so high, that
only a handful of companies can spend the engineering resources to
build (actually, maintain) one, and the barrier to entry is so high that all of the
existing players have consolidated around a couple of engines. The
cost of creating a new one is too high for anyone at this point.

Both of the above UI paradigms communicate sending the display data
over a connection, making it simpler for the apps to run locally or
remotely. In contrast, we have a bunch of GUI toolkits libraries, such
as GTK, Qt, etc., which have language bindings allowing users of a
specific programming language to create GUIs with them. It feels like
these are waning in popularity as they are harder to learn and
use. The generally suffer from being harder to make cross-platform
than the alternatives. Many GUI toolkits only work well in the
programming language they were designed in.


Finally, it seems like we have a fourth category comprised of new
frameworks created by big companies. Unlike the UI toolkits in the
paragraph above, these frameworks, such as React Native and Flutter,
aren't libraries you add to your application, instead it's more like
you're writing an application inside their framework. For React Native
you're using JavaScript to talk over a channel and with Flutter you
use Dart.  While I don't closely follow the latest UI trends, it seems
like these are gaining in popularity.


Will the future of GUIs be controlled by a few big companies similar
to how a few big companies control the web? Will it be possible to
simplify the web browser feature set so that indy developers are able
to create a compatible implementation? Will the future of mobile and
desktop UIs be dominated by frameworks that only run on a single
programming language? It would be nice if we could create a
specification like the web that could design native UI
applications. Could the UI paradigm be more like a Lisp Machine
REPL? Would it be based around someone else's choice of design
aesthetic or would the user be allowed to choose the UI components?


I think the unfortunate part is that average consumer does not think
about free software freedoms, or even what it might take to be
self-sufficient in the software that they use. Many users would be in
a bad place if their account provider (social media, email, etc.)
decided to delete their account. Being self-sufficient and
not worrying about that is too hard for the average computer user
these days. Even if it was easier though, I'm not sure they would have
the incentive.

