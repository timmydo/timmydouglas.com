---
date: 2026-07-05
tags:
- code
- long pole
title: "Code is not the Long Pole"
---

With AI agents being able to write code faster than we can type,
writing code is no longer the long pole in software development. The
wikipedia entry for Amdahl's law says, "the overall performance
improvement gained by optimizing a single part of a system is limited
by the fraction of time that the improved part is actually used."


This has led me to an interesting realization in the development of my
linux distro that I described in my last post: most of the time is
spent running tests now. While you can buy more hardware to run your
tests if they can be run in parallel, you're still subject to the same
law above when it comes to minimizing test time.


One of the tradeoffs you can make is running fewer tests when you
merge git commits but running the full suite on release
candidates. The downside is that you might have a broken main, but
with AI automation, the labor toil of keeping main green goes
down. When you have multiple people working on a project, you might
lean towards more tests before commits to main (preventing lazy actors
and more work to correct), but with a single maintainer, you might
choose the other direction.

When tests take a long time to run on a new change, it's less
efficient for AI agents to run on a cached session when you're using a
cloud provider that has limited space for caching tokens. Hopefully
we'll see more local agents that can handle these loops while calling
out to smarter agents for problem solving. I wonder if it'll be better
to have a bigger model manage smaller models or if it'll work to have
smaller models call out to bigger models as needed.




