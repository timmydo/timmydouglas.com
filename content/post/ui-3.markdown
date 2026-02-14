---
date: 2026-02-13
tags:
- tui
- web browsers
title: "Web is dead; text is king"
---

Today I was thinking about some of the posts I made previously on
bemoaning the web browser as becoming the ubiquitous user interface. I
complained the technology was so complicated that it couldn't be
recreated easily--and that's why there are only a couple of browser
implementations. I (probably?) complained that many of the apps we use
on computers do rendering with some sort of embedded web
component. It's easy, cross platform, and mature technology.

I wrote all that before [AI agents were writing C
compilers](https://www.anthropic.com/engineering/building-c-compiler). I
wrote all that before I stopped using IDEs and primarily programming
through the terminal using tools like Claude Code.

Maybe it's time now that someone attempts to use these new powers to
build a new UI framework from scratch, in a safe/GC-free language like
Rust, without extra dependencies. In the meantime, I will enjoy how
coding agents have put more life into TUIs.

If I was making a new UI framework today, what might it look like? I
am sort of spit balling as I type, but maybe something like an event
loop over a socket. The language you write the program in wouldn't
need to be the same as the UI toolkit. Maybe you could send reduced
form of HTML to render to display the UI toolkit components. The
events could come like JSON RPC. That way your embeddable web view
replacement wouldn't need to be a full browser--it could be a lot
simpler, but you could get most of the functionality.

