---
date: 2026-02-21
tags:
- software
- email
- news
- rss
- codex
- claude
title: "My Personal Mail and News Client"
---

In my last post, I talked about using Claude Opus 4.6 and Codex 5.3 to create a
[TUI Rust email client](https://github.com/timmydo/tmc). Later on that
weekend, I went a step further and created a news client to replace
the RSS to email solution I had previously. Now I have a dedicated TUI
(called [Timmy's News](https://github.com/timmydo/news)) for reading
RSS feeds. It's pretty amazing to see how easy it was to create. While
I have looked at the source diffs as they scrolled through the screen,
I haven't actually looked at the code. When I had questions about
the architecture, I just asked the model to tell me.

There were some design decisions to make regarding how to synchronize
the data store/cache with the online server. I also had it walk me
through various options for storing data and what Rust libraries were
available. In both cases, I went with redb for storage. News is easier
because it's read-only--you can have a process downloading to the news
to a database, then the TUI just renders the database. With the email
client, it was a little more complicated because you had to
synchronize with the server and keep a consistent representation
between the cache and the email server. Both Opus and Codex are at the
point where they aren't leaving the code in a broken state, getting
lost, or introducing elementary bugs, which is pretty impressive.

Email client:

![Timmy's Mail Client screenshot](/assets/tmc-2026-02-21.png)

News client:

![Timmy's News screenshot](/assets/tn-2026-02-21.png)


Historically you'd need to make software a little more complicated to
have things like customizable key bindings, themes, configuration
settings, etc. With this "bespoke software" approach, this can be
hard-coded, and you just tell the agent to change the source when you
want it to be different. I sort of wonder if we extrapolate this line
of thinking, if programmable platforms like emacs and scripting
languages will become less common because of the lower barriers around
changing the application itself. Libraries still remain important, but
the UI can be completely custom code.

Regarding Opus 4.6 vs Codex 5.3, I didn't see much of a difference or
much of a learning curve going from Opus to Codex. This project isn't
the best example to benchmark two state of the art coding agents at
this point. I slightly prefer the TUI of Codex, in particular how
scrolling feels ergonomic and lightweight, unlike Claude Code, which
feels more like a game engine rendering a single screen. I have only
come close once to the Codex usage limits (which apparently are under
a 2x promo currently), but I was consistently hitting limits with
Claude (which is what pushed me to pay for an OpenAI subscription).

