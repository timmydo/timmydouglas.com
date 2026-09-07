---
date: 2026-09-07
tags:
- linux
- distro
title: "Omarchy and the rise of agentic Linux distros"
---

I was thinking about doing another status update for my in-progress
Linux distro, but instead I thought I'd do a post on another Linux
distro.

I was watching the [Lex interview with
DHH](https://www.youtube.com/watch?v=NYFGCESmikA) and it seems like
DHH is going on a media tour promoting his latest [Omarchy linux
distro](https://omarchy.org/). It was a great watch and if you haven't
been following AI-assisted software development recently, it's a good
summary of how that has changed things. The funny point they made is
that you could have been backpacking offline for the last year and
it'd only take you a couple of hours to get caught up on the latest
practices because things have moved and become obsolete so fast.

I felt like I had a similar story--after Opus 4.5 was released near
the end of last year, I more-or-less stopped hand-writing
code. Oftentimes I'd learn a new programming language by creating a
text editor in that language, but now I barely using text editors
anymore. I'm using emacs for writing these blog posts and composing
email, but I recently started working on td-editor, the notepad-like
editor that will be in my linux distro, and this might be the last
blog post I write in emacs. It's amazing how fast things have
changed. Emacs has a long lineage back to extensions for the TECO text
editor in 1976, and while it has up and downs over the years, it felt
like it was in steady decline in more recent years due to the
competition moving faster. This could have been a cyclical trend
though, as I remember [Lucid
Emacs](https://www.jwz.org/doc/lemacs.html) being a fork that tried to
get GNU Emacs to move faster. While jwz's post about it is an
interesting read, I think the bigger change now is that there isn't
really a need for IDEs anymore in the age of AI agent-assisted
development. Creating your own text editor is pretty easy for an agent
to do from scratch. Here is td-editor, std-only Rust directly speaking
wayland-protocol and doing its own font rendering, only a couple days
with an AI agent:

![td-editor](/assets/td-editor1.png)


Anyways, back to Omarchy. While I'd praise their work on the batteries
included approach, the approach I'm taking with td is more like
SerenityOS--a NIH project where we don't have external
dependencies. DHH tries to answer this on another
[podcast](https://youtu.be/Lg2RYoA4-xE?t=1500), but I feel like his
answer misses the mark. Just because he can self host most of the
packages on the AUR, doesn't mean he's looking hard at the packages
that he's serving. For example, you could look at the 12k LOC
Cargo.lock file for the mise package manager the distro uses. That
said, td is a distro for me and doesn't need to support what most
users are trying to do, while he's trying to make something for
everyone. I do think we'll start to see a lot more NIH-like solutions
where people create bespoke software instead of relying on external
packages.


