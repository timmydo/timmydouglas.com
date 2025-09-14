---
date: 2025-09-14
tags:
- tle
- squeak
title: "Toy Lisp Environment: Part Two"
---

I wrote a blog post a little over two years ago about another text
editor I started writing in common lisp. In typical fashion, I lost
interest around the time I got the basic stuff working. At the time it
was something simple--just printing lines on a SDL2 canvas.

In somewhat related news, the main developer working on Lem announced
he was thinking about the [deprecation of the SDL2 frontend for
Lem](https://github.com/lem-project/lem/issues/1867) in favor of using
a webview frontend. The webview frontend idea is basically a minimal
web browser (WebKitGTK) connecting to a web server (the lisp
part). Some people found this off putting...I'm not sure if you'd call
them traditionalists? I think there is the thought that you can't have
lisp all the way down if half of the app is a C++ web browser. 

After playing with webview some, I think this is likely the best
future for lisp GUI applications. On the github issue thread, cxxxr
basically lays the landscape from the research he did and I think it's
pretty clear that unless you want to build your own UI toolkit, you
the modern web browser has solved so many problems that it makes the
most sense for most people. That's probably why so many modern UI apps
are running on a web-based UI. From a common lisp point of view, this
is convenient because there isn't much you have to do dependency
wise--a web server is pretty easy and the webview is like a library
with 4-5 functions in it.

So, being inspired by this, I revived this old text editor I started
by basically deleting all the existing code, and then vibe coding a
web server to display windows and sort of a mini UI toolkit. Using
that, I created a couple of different types of windows: a REPL, a
LOGO-like program, a terminal, a text editor, and a package
inspector. Later on, I added webview support. It's all really toy-ish,
and sort of reminds me of [Squeak](https://squeak.org/), my old happy
place for programming.

Link to [git repo](https://git.sr.ht/~timmydo/tle). Screenshot:

![directory listing of root](/assets/tle-20250914.png)

Watching Claude code implement things like undo was entertaining to
watch. It often struggled with matching parenthesis, but was sometimes
able to work itself out of the hole by using the instructions in
`Claude.md` to run the paren-checker (that it wrote itself) on the
source file. I think this is probably a project I wouldn't have come
back to without the help of an AI agent, and being able to knock this
out in about a month's time after work and on the weekend left me
pretty impressed with the future for AI agent coding.

