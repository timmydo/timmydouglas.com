---
date: 2024-08-22
tags:
- lisp
title: "Why Lisp failed to get mass adoption"
---

I thought read a comment on Hacker News a while back that said
something like "Macros are why Common Lisp failed to attain mass
adoption as a general purpose programming language." It was sort of
thought provoking because many people think of S-expressions and
macros to be one of the standout features of Common Lisp. I wish I
could find the comment again but it doesn't come up with a quick
search. So this will be a hastily written blog entry before I head to
bed with some of my current thoughts on the matter.

I think languages that succeed in mass adoption have to have an
idiomatic way of doing things, and with Common Lisp, you can
redefine what the language looks like with macros. Without an IDE, it
can be harder to read or understand code that makes heavy use of
macros. It helps when code bases have a standard way to do things, and
a language like Common Lisp does not do you any favors when it comes
to that. It's better than Perl at least.

I think the second major reason is state. When you do development in
Lisp, your environment often has a lot of state in it. You may have
code defined or running whose implementation isn't in a file. Sure, you
can restart and recompile everything every time you want to make a
change, but the usual flow involves keeping state around and mending
things together rather than building from scratch every time. When I
work in this manner I would probably tend to cut corners on build and
test hygiene. Naturally, when someone wants to ship a Common Lisp
application to someone it's a big ordeal to figure out the right way
to do it, whereas with a language like C or Go you compile an
executable and execute it. While it seems like there could be some
great scenario where you preload a bunch of data in a lisp image and
ship that around, I think file and databases are a better solution
because they can be used to keep the application stateless.

Lastly, this might be half a reason, and an add-on to the state
argument, but I think that a more constrained language with static
typing allows for an more powerful IDE. When you have 100k lines of
code and you need to refactor something, I think an IDE parsing a
stateless, statically typed language is going to have an easier time
helping you find and make large changes. This is probably mostly
because it's an easier job to do. There is a lot of info revealed by
the typing itself, and while most lisp environments will warn you and
help you more if you declare things, I still don't find it to be
equivalent. But I will admit I don't have as much experience using
Lisp IDEs on large codebases.

It would be enjoyable to use Common Lisp for a small project, but I'm
worried it wouldn't scale well. I'm sure people have gotten it to
work at scale, but I'm worried it that it wouldn't be simple. Maybe
that's just a roundabout way of saying worse is better.

