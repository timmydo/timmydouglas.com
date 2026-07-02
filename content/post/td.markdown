---
date: 2026-07-01
tags:
- ai
- linux
title: "Timmy's Distro"
---

A couple of weeks ago, around the time of the (first) Claude Fable
launch, I upgraded my Claude subscription to the 20x Max one. There
had been weeks of discussion on the Guix mailing lists about code
contributing guidelines in the age of AI agents, and it wasn't really
looking promising for people that want to contribute to the project
using AI.

My general feeling was that a lot of people were taking the stance
that AI was bad for the planet, thus it shouldn't be used by people
contributing to free software. There were certainly people that
pointed out that we don't require contributors to run their computers
on renewable energy, so taking that kind of stance on AI/LLM
contributions would be a more political than not. There are others
that feel like the copyright situation is unsettled, so we should wait
for the law to catch up, but I can assure you that most companies
aren't waiting for that. Even so, source code isn't the product
anymore, and free software should be more about user freedom than the
source code.

Anyways, so I wanted to talk about creating my own linux distribution
in light of all of this. Given we are in the age of bespoke software,
it feels apt to have my own distribution to suit my tastes. I don't
have too many issues with Guix itself, but I wanted something more
Rust-focused, because with AI agents writing code, that language
probably makes the most sense. Many projects written in C are being
rewritten as I type this.

At a high level, I was thinking the seed dependency would be a current
rust toolchain. From there you would build the tools for managing the
distro (package manager, package builder, etc.). Those tools would
then be used to bootstrap the distro itself--following a mes bootstrap
process, building a gcc-toolchain to build the kernel with, a glibc
for a rust-toolchain, and then use that for all the user space
stuff. I was thinking the filesystem would be an immutable oci image
rather than strictly following Guix's lead of just having read-only
folders on the root filesystem. The user's home directory would host
most of the software that the user would run--I'd want to get rid of
the ad-hoc commands like `guix install` and just have the equivalent
of `guix home configure` and `guix system configure`.

There's still a lot to figure out, but what's interesting is that this
is never something I would have attempted years ago. It would have
been too ambitious and time consuming. Now, I feel like I'm only
limited by my imagination (and how much time I'm willing to spend
talking to my AI agents). That said, I feel like I made a pretty big
mistake at the beginning where I let the agents write the prompt and
design. I was fighting an uphill battle until 250 PRs later when I
rewrote it myself.
