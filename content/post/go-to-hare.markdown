---
date: 2023-12-15
tags:
- hare
- golang
title: "My First Hare Program"
---

I have wanted to learn Hare since it was announced and took the
opportunity to write my first program yesterday. Hare is marketed as a
simple and boring language, and something that you might use as an
alternative to C. It fixes some of C's issues while not trying to do
anything too ambitious with any of its other features. One of the
aspects that appeals to me is how quickly it compiles itself. The
standard library is fairly minimal and Go seems to be another source
of inspiration. It's nice to return to a time where the stack is
simple enough that a single person can have a full understanding of
how it works.

Anyways, my goal was to port my
[feed2maildir](https://github.com/timmydo/feed2maildir/blob/master/feed2maildir.go)
program from Go to Hare. It's a fairly simple program: it reads
command line parameters, downloads a RSS feed, and converts the feed
items into mail messages that it writes into a maildir. At first I
tried to link against libcurl but ran into an issue with what appeared
to be relocation offsets. I decided to just `exec` curl instead
to download a file to my `XDG_CACHE_HOME`. Then, `hare-xml` is used to
parse the RSS feed and I simply write files and move them into the
maildir. There are a couple of memory leaks for things like `strdup()`
but for a one-shot program it doesn't really matter. Here is the
[source at the time of this blog
entry](https://git.sr.ht/~timmydo/rss2maildir/tree/cc3052a29bade3481931df1ddb14f04788360f5b/item/cmd/rss2maildir/main.ha).

Funnily enough, both the Go and the Hare program clocked in at 181
lines of code. The Hare program is more dense and a little harder to
read due to the XML library not dynamically allocating a tree of
objects like the Go one. I use a couple of variables to track the
state and I have to add some `match` statements to manually handle the
different tokens the XML parser gives me. Otherwise, they are pretty
similar. There is something refreshing about the absence of garbage
collection and `ldd myapp` printing `not a dynamic executable`. At the
same time, there is something I enjoy about single threaded
applications that use static allocation.
