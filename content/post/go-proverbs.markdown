---
date: 2024-08-14
tags:
- golang
- proverbs
title: "Go Proverbs"
---

There is a nice website at
[https://go-proverbs.github.io](https://go-proverbs.github.io), which
introduces Go Proverbs. Here are a couple favorites (some are
rephrased):

- Share memory by communicating
- The bigger the interface, the weaker the abstraction
- A little copying is better than a little dependency
- Clear is better than clever
- Reflection is never clear

Just yesterday, I was dealing with a bug in a library that was due to
a misuse of reflection. The library's code is nearly unreadable given
how it makes use of reflection and runtime code generation. Reflection
often adds a dependency on dynamic code generation, while closing the
door on ahead-of-time compilation. The only benefit I can think of is
that a runtime/stdlib upgrade could potentially unlock better
performance or provide a security patch. I think it'd be better if the
engineering system just made it easy to recompile the world.

Share memory by communicating is an easy conclusion to come to if you
have had to deal with ugly programs that communicate by sharing
memory. But I don't think it's any more interesting than saying clear
is better than clever. Although clear being better than clever rolls
into the next proverb while also ringing the "worse is better" bell.

My favorite on the list might be "a little copying is better than a
little dependency." As someone who basically has to vet every new
dependency added to our platform at work, there is not much I dislike
more than someone adding a new dependency. Often times it means a new
component of your application that is not trivial to replace, which is
bad in itself because all good code should be easily replaceable. In
unfortunate cases, this could mean having a binary that you can't
replace at all because it can't be recreated. If you were following
the proverb above by having small and simple interfaces, then the
dependency would be easier to replace. Changes in the dependencies
aren't easily reviewed, and your application's supported platforms is
the smallest intersection of your code and all the dependencies you
use. Depending on the language, dependencies aren't easy to upgrade,
modify, or debug. I feel like one of the best indicators of quality in
a project is how well they manage their dependencies and which ones
they decide to take.

