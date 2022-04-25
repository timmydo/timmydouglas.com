---
date: 2022-04-25
tags:
- patterns of software
title: "Patterns of Software"
---

I recently started reading the book "Patterns of Software" by Richard
Gabriel. I think he's fairly well known for his "Worse is Better"
essay, but this work came after that. The first part of the book
discusses software abstraction and Christopher Alexander's
architecture studies ("A Pattern Language"). I've only read the first
60 pages so this is my take at that point.


One of the issues with the software industry today is that there is
very little retrospection. There is not much study of past work, be it
a company looking at its recent successes/failures or what leaders in
the field have done thirty years ago. Students are learning
programming by writing code, not by reading important works. Learning
English in school, we didn't just write papers, we read books by
famous writers. I'm as guilty as anybody--it's more fun to create your
own programming language or text editor than to fully understand the
all of the other ones out there. Imagine if physicists all started
from scratch: they'd all be wasting their time discovering the same
things. Software is not the same thing, but I still worry the
lifetime of software is too short.


Recently I've been having a common lisp renaissance. I've been playing
with the language again for the first time in like 15 years. It may be
one of the best programming languages, but it hasn't gotten as much
attention as newer languages these days. There are probably a lot of
reasons why, but one might have been due to it being late to the open
source movement. A lot of the prominent software companies working on
it in its heyday were fairly restrictive with source code. GNU Emacs
is probably the most active lisp environment these days, and I would
guess that's partly due to it being free open source software. I worry
that a lot of the interesting innovations that happened during the
lisp machine era will be forgotten in history. I enjoy watching lisp
machine demos such as [this
one](https://www.youtube.com/watch?v=jACcgLfyiyM). I'm hoping to learn
how to use CLIM to make similar interfaces in the future.



In the beginning of the book he outlines "habitability" as an
important pillar for both building and software construction. The idea
is that you want to build something that is easy to live with and
modify. In practice, software is a living thing--you don't have all
the requirements up front, and you rarely ever finish it. So it is
important that it is easy for someone to modify. Gabriel highlights
"piecemeal growth" as important to the design, and abstractions have a
large piece to play in that area. He cautions about overusing
abstractions talks about the process of defining beauty. He reflects
on how subclassing didn't live up to it's hype. Overall the book is a
little high-level and philosophical, and maybe only appreciated by
experienced software developers. You won't find much when it comes to
detailed technical examples.
