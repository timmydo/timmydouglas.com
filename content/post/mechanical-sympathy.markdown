---
date: 2021-06-24
tags:
- mechanical sympathy
title: "Mechanical Sympathy"
---


About half a year ago, someone sent me the article [Mechanical
Sympathy: Understanding the Hardware Makes You a Better
Developer](https://dzone.com/articles/mechanical-sympathy). It's worth
a read. At the time, it irked me because in the context at that
moment, it felt like advocacy towards premature optimization.

Fast forward to now. I'm working on a hobby project using C, since I
haven't really had a chance to write C in like 15 years. It's
refreshing to have to think about memory layout and allocations for
everything you do. The lack of garbage collection helps prevent
convenient abstractions that come at a high performance cost. C also
doesn't provide programming abstractions that hide
what code is going to run--what you see is what you get.


It's hard to find people that are passionate about writing software. A
lot of people want to ship things and move on. If there aren't enough
tests, the code's lifespan is decreased as it will be much more
difficult to refactor. Likewise, if the code isn't performant or
correct, it's also likely to be replaced. If you manage to have
correct, performant, and well tested code, then you have a gem.


It's even harder to find people that benchmark their code. I think
it's one of those things--if it needs to be optimized, someone will
look at it. But in my experience, that threshold is high enough that
it rarely occurs. Since it rarely occurs, people will often do a poor
job at it--commonly by making guesses at why things are slow (without
profiling) and not benchmarking the changes they make.

Related:

  - [The LMAX
    Architecture](https://martinfowler.com/articles/lmax.html)
  - [How is GNU yes so
    fast?](https://news.ycombinator.com/item?id=14542938)
  - [Napkin Math](https://github.com/sirupsen/napkin-math)
  

