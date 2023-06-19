---
date: 2023-06-19
tags:
- lisp
title: "A common lisp environment"
---

I started writing another text editor. Not exactly original, but at
this point I don't really have any original ideas anymore. I want to
write some code on the side for fun, but I don't have as much time or
motivation as I used to. I have been looking for a lisp environment
that's free software, but there isn't much out there. The two
implementations that I'm aware of are lem and Second Climacs.

Lem is probably the most mature implementation, but I wasn't able to
get the SDL2-backend working on my machine. There was some exception
early on at startup. Poking around with the code, I was able to get it
to display the initial screen if I messed around with the threading so
that it wasn't using locks and multiple threads. I was able to get the
terminal ncurses backend working, but I didn't really feel like I
would be missing something big by not using it. The undo
implementation seemed lacking but I didn't really write things down
for a review.

Second Climacs runs on McCLIM, which currently only supports running
under X. I'm running sway without xwayland, so I don't have a way to
run that currently unless I install xwayland, which I'm not
particularly motivated to do. If it was further along I might have
done it, but from what I've seen, it's still in its infancy. I have
wanted to try McCLIM for a while now, but all the concepts ("ports,
grafts, and mirrored sheets") come across as so foreign and
abstract. I just want something simple like SDL.

That leaves Emacs as the only modern lisp environment, and
while it's pretty much "good enough" for everyone, people are also
always asking the question, "What if it was in a modern lisp?"

Anyways, after lem being so close to usable, I decided to start
writing another text editor using common lisp and cl-sdl2. Perhaps one
of the things Common Lisp got wrong was not having a formal threading
specification, but on the other hand, C was successful without one. A
lot of people say that the "single threadedness" of Emacs is one of
its biggest weaknesses, but I think the simplicity of the programming
model is why so many people were able to build so much on top of
it. Using that as inspiration, I've decided to make the lisp
environment I'm working on single threaded as well.

There are probably a lot of questions I'll need to answer, like, "If
an inferior lisp model is the best way to work, then why does it
matter what language the editor is written in?" I think I'd agree with
that, the editor's language doesn't matter. At the same time, I don't
really want to make a programmer's IDE. My main uses of emacs are for
reading news and email, so that's my goal. So if I can replace
notmuch-emacs, dired, and eww, then I'll be all set. For news, I have
a custom rss to maildir program, so I'd probably add that in somewhere.


