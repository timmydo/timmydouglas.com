---
date: 2026-07-25
tags:
- code
- tests
title: "Tests are the new Code"
---

With AI agents being able to write code faster than we can type,
writing code is no longer the long pole in software
development. That's the same first sentence I used in my last journal
entry. With AI agents orchestrating software development more, the
specification is becoming the new source code--and tests are the coded
specification.

[SQLite](https://sqlite.org/testing.html) is semi-famous for its
testing. "The project has 590 times as much test code and test
scripts" as the source code. Tests are what enable you to modify code
without worrying about breaking things, and when you have that many
tests, it becomes pretty trivial to rewrite in the best language or
with the best optimizations possible.

We're increasingly seeing Rust being used as the AI agent language of
choice because of safety and the lack of the overhead of a garbage
collector. When humans aren't writing the code, "convenience" and
"ease of use" are not features you really need in a programming
language. Maybe we'll see a lower level safe language in the future
that works better than Rust, and the important thing is that we have
the tests and oracles to be able to safely rewrite anything into that
better language.

A lot of the free software world is getting caught up with all the AI
stuff and fretting about the copyright implications of AI generated
code. These days, I find myself beginning to view source code itself
as looking at disassembly or some intermediate language
(i.e. unimportant). It tells me how a program will execute, sure, but
the specification is really in the tests. If it's unspecified (no test
coverage), you could call that "undefined behavior" the same way as a
C program is compiled by a compiler and decides to do something you
might not like. Looking ahead, I would imagine more emphasis to be
placed on tests rather than the code.


