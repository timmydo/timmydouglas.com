---
date: "Fri, 13 Nov 2020 22:31:26 -0800"
tags:
- hugo
- jekyll
- blog
title: Migrating from Jekyll to Hugo
---

I was out of ideas for a new blog entry so I thought I'd migrate my
blog from Jekyll to Hugo and make it a little more minimalistic. The
main driving factors were:

  - I don't like how web browsers have become overly
    complicated--essentially virtual machines executing code and
    becoming their own app platform. See [this
    essay](https://www.gnu.org/philosophy/javascript-trap.html) for
    more details. I'd like to practice what I preach and make it so
    that my blog doesn't require javascript.
	
  - I had to run Jekyll in a docker image because of all the
    dependencies/setup. Hugo is easier to install and run, so less
    friction for new blog posts.

  - I didn't want to use a third-party theme that did all the
    magic/code generation. It was easy enough to [copy another site's
    code](https://git.sr.ht/~sircmpwn/drewdevault.com).
	
  - I want a migration path towards serving a gemini site in the
    future. (This ties into the first bullet point about complicated
    web browsers)
	
  - I wanted to be able to self-host this blog fairly
    easily. Basically have a git CD scirpt that runs hugo and uploads
    the output to a web server I control. GitHub pages works great and
    is free, but I think the FOSS ethos is a lot about
    self-sufficiency, and I'd like to own the whole blog end-to-end.
	
  - I'm looking for little hobby projects that don't take too long to
    complete and this one was pretty easy.
	
	
How to migrate? Well I basically ran [hugo import
jekyll](https://gohugo.io/commands/hugo_import_jekyll/), then used
Drew's site (see link above) as a template, and hand edited a lot of
things (since it was imported from Jekyll). One nifty feature I found
(maybe this can be a future blog post) was using Emacs's [Wdired
mode](https://www.gnu.org/software/emacs/manual/html_node/emacs/Wdired.html)
(`dired-toggle-read-only`), then using macros (`C-x (`) to bulk rename
files in a directory. I'm trying to replace my terminal usage with
Emacs.


