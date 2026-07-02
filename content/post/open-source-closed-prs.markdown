---
date: 2026-06-05
tags:
- ai
- pull requests
- open source
- contributions
title: "Open Source, Closed Contributions"
---

Today the Ladybird Browser project
[announced](https://ladybird.org/posts/changing-how-we-develop-ladybird/)
changes to how they're developing Ladybird. Basically, they're going
to remain open source but not be open for externally created pull
requests. For those of you reading this in 5 years, free open source
software projects used to be written by humans, and because writing
code took a lot of time, people that wanted to make larger
contributions to a project would contribute code. It was sort of the
next step up from contributing bug reports, one that involved actual
effort on the contributor side, rather than most of the effort being
on the maintainer side.

The economics have changed this year because writing code is
effortless with modern AI agents. You could have argued the value of a
product is never in the code, it's in the culture and the tests, but
that's a topic for another day. Spending hours finding a bug,
learning the project's code structure, making a fix, prettying up the
commit history, figuring out how to use git send-email (heh), and
having the maintainers of the software review it took a long time. Now
doing all that could take someone a minute, but the maintainers of the
project still need to spend a good amount of time reviewing the
code. Instead it just makes more sense for them to type the sentence
or two to their AI agent and then they only need to trust their AI agent
to do the right thing.

It's inevitable, and this will only be more common in the
future. There's currently a lot of projects in the early phases of AI
who are still trying to figure out if AI-generated source code is
copyrightable or if they should ban it because they don't agree with
the environmental footprint of the technology. If you're using the
crawl/walk/run terminology, that's pre-crawl. It's
unfortunate, and their future prospects could be described by
some Darwin metaphor.

Continuing the analogy, you have crawl when some of the contributors
are using AI. Walking is when the maintainers use it near
100% of the time on coding and reviews. Running is when AI's are
triaging issues, creating PRs, and reviewing PRs. I think it's only a
matter of time until a lot of projects have cron + triggers for all
the maintenance work and a human doesn't need to be in the loop. I
would imagine projects like openclaw are the cutting edge of
what you might see publicly.


