---
date: 2025-08-19
tags:
- claude code
title: "Claude Code"
---

I finally jumped on the bandwagon of people that are paying for an AI
subscription. A couple of days ago I started paying for the $20/month
Claude Pro subscription so that I could use Claude Code. I have used
various models at work through vscode, and personally through
openrouter or a web interface, but this was my first time using a
terminal-based CLI experience.

For evaluation, there don't seem to be many options. You could buy
credits I guess, but if you're going to evaluate for a month, then
it's probably easier to just pay for a month. Gemini actually was able
to use my google account to use a free tier, so I gave that a shot,
but the results weren't great. Maybe it wasn't a fair shot because I
wasn't on a paid tier. I ponied up $20 for Claude Code and gave it a
shot.

And wow I did not expect to be this impressed. I feel like I've had
success using claude sonnet for some various odd job tasks at work,
but generally speaking, I don't work on many projects where I'm asking
an agent to vibe code something from scratch. I feel like I have a
different "text editor" project for every programming language I'm
playing with, so I found one I started in common lisp where I was
writing a program to display text in SDL 2, and repurposed it to be a
web based text editor.

I was recently inspired by [Puter](https://puter.com/), basically a
Javascript website that emulates a computer. I feel like that might be
a better future for VDI than people running actual operating systems
and remote display protocols. Anyways, I had some boilerplate common
lisp code that I wanted to repurpose to be a web-based editor running
in vscode-like windows like you'd see with Puter, so I asked Claude
Code to create a web server that displays some windows that you can
drag around. The window state remained in common lisp objects and
dragging them would update the state. If you refresh the page, the
windows would be where you left them (until you restart sbcl).

While claude code/CS4 was able to put it together pretty effortlessly,
there were a few things it struggled with. The first one I remember
was parsing the HTTP requests, which it chose to do manually instead
of using a library like hutchentoot. This was nice to see, and maybe
it got the idea because one of my readme files mentioned how I like
minimal dependencies. The bug was with it trying to read-line beyond
the end of the headers, which was causing it to never reply to the
request. This one was sort of funny because it did various things to
try to debug (running SBCL in the background, curling URLs, etc.) and
it finally concluded there must be a bug in SBCL or something. That
might have been hard to debug if I had been less experienced (I feel
like that is a bug you've experienced if they have written code
long enough). There was a similar issue with writing the response--it
was writing newlines to the stream with `(format t "~%")` instead of
properly writing CRLF. Once I told it to fix that bug and refactor the
methods it uses to write the response, it was able to implement more
features without running into the same issue again.

There was another interesting bug it introduced where a function it
wrote would return whether to keep-alive or close the connection, but
after it changed it's code to debug something (probably an earlier
bug) it introduced another bug where it wasn't looking at the return
value anymore and was closing all connections, which broke the
server-sent event loop. That one it was actually able to fix when I
gave it the symptoms. It was pretty impressive watching it
troubleshoot and fix bugs. The speed it can put together curl commands
(instead of using a browser) is way beyond human speed. When you have
built an ample suite of tests, it runs them after every change and
uses the results to fix its own bugs. It's fun to watch it write its
own tests for a new feature, then use those test failures to refine
its own code that it wrote earlier.

So, I basically go through features like "implement forward-char",
without giving it too much direction other than telling it to
implement tests and it's able to one-shot these features without any
help. After a couple of these features, I ask it to come up with a
TODO of common editor features (it quickly threw together a 178-line
file). Then I just started telling it to implement the next thing in
the TODO file and check it off when it's done. I asked it to implement
undo/redo and it literally did it and added tests without any
issues. Coding this sort of thing probably would have taken me a
couple of hours and it can just one-shot this in a couple of minutes,
not to mention adding like 300 lines of tests. "Very impressive!"
(project farm from youtube voice)

So far it's probably written over 2k LOC of regular code and almost 3k
LOC of tests. I've probably spent 5-6 hours watching over it, and
usually just accepting its code changes without thinking about it too
much (except when I didn't--it was easy to steer in another
direction). I'm sure the fact that this is a small project helps, but
I'm still coming away really impressed that I was able to put this
together so easily. I think one of the things that will be harder to
get used to is to "trust the process". I'm so used to being able to
write the code the exact way I like, sort of like painting a painting
myself. But using an agent like this is like telling someone else to
paint, and you can't be shy about telling them to start over if you
don't like the result. As long as you're able to put guard rails up in
your prompt, in your build, or in your tests, you should be able to
get an end result that you're happy with, even if you don't fully take
the time to see how it works under the hood at the end of the day.

