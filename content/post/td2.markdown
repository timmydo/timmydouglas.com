---
date: 2026-08-05
tags:
- linux
- distro
title: "Timmy's Distro Two Month Update"
---

I've been making some progress on my Linux distro that I've been
working on for about two months at this point. Linux runs td-init,
which invokes td-svc, a service manager. It boots directly into a custom
wayland compositor td-compositor, opening a td-term with td-sh.

![Timmy's Distro Screenshot](/assets/td-2026-08-05.png)

The OS is built by td-builder, the rust-based control plane for
building recipes. Along the same lines as Guix, it is bootstrapped
from a tiny auditable seed. Unlike Guix though, there is a rust
toolchain dependency and all the packages are basically defined in
rust code.

I was originally building it on GitHub with my AI agent using a
separate account as to not use my main account's credentials. Oddly
enough, that account got suspended and I learned a lesson about not
taking a dependency on a forge. I'm not quite sure why it happened
because it was only working on my repo to create PRs, issues,
etc. When your account gets suspended, everything goes poof (all the
open/closed PRs and issues by the AI agent disappeared), so thankfully
my primary account created the git repository itself. It's funny
because the whole thesis of this linux distro is to avoid
external dependencies. Now I just using GitHub (and sourcehut) as code
mirrors. I'm currently using uutils for
coreutils and russh for a SSH implementation, but generally speaking
that's it. I think everything in userspace that I can think of right
now is written in rust.


I found a workflow that works pretty well for me: I have a couple of
claude agents, each with its own work stream (e.g. td-sh,
td-compositor, etc.), then I have a `/loop` to keep them from stopping
after each git commit. The agents run as a test user and they push
their branches to origin, which is a shared directory under
`/srv`. Each commit gets a code review with the latest opus, gemini,
and gpt model. As my own user, I use td-review, a fairly simple rust TUI app
that fetches from origin and let's me review their branches. I can
rebase their branches into main and then they can continue rolling
their next commits into the same branch to repeat. 
