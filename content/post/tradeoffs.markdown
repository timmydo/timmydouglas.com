---
date: 2026-10-22
tags:
- tradeoffs
- baking
title: "Tradeoffs"
---


One of the things that still requires humans to be in the loop in
software development is deciding on tradeoffs. How a human makes that
decision is oftentimes called 'taste', but taste itself may just be
years of accumulated experience put into writing. The tradeoff is having
a goal in mind that you're designing towards. Usually you only need to
make a tradeoff decision if something isn't strictly better. With the
td-mta mail server I'm working on now, I made a decision to pivot from
the mail database being SQLite-based to using Postgres. SQLite might
have been simpler and faster for my scenario, but the idea of being able
to backup or modify the database while the mail server was running was
something I desired more. In this case, I directly told the AI agent to
rewrite it about halfway through the project, but a lot of tradeoffs can
come from more subtle context--existing coding conventions, AGENTS.md,
documents in the repo, system context from the harness, etc. I think
that's a strong case for harnesses that don't hide the system prompt.
Not to mention you don't know what a closed model is really thinking.

Another example might be how an AI agent decides to fix a bug. They
might over-engineer a solution, or they might add a bunch of
documentation that's not necessary, or they might not do enough. There
are likely small tradeoffs being made that will compound over time
(number of tests that have to run) and influence later decesions made by
coding agents (comment volume?). The foundation that has been laid in
the AGENTS.md has a big impact on the future trajectory of the project.
To use an example from td-mta again, I originally put a requirement that
I wanted to keep the working memory under a certain size because I
wanted to run it on a small AWS virtual machine. That had an adverse
affect on a lot of work afterwards because the AI agent would constantly
count bytes it was allocating everywhere. It even hardcoded array sizes
for the maximum number of inboxes that the MTA would support (that was
the "enough is enough" point). If you don't specify anything, will the
model try to optimize for cost per task, code maintenance cost, or
runtime performance? It's too open-ended to make any assumptions. You
have to specify what tradeoffs you want.

As the first year of not-writing-code-by-hand-anymore comes to a close,
one thing that is top of mind now is code that was written pre-AI and
post-AI. It's almost like having different time segments in the brain
for pre-covid and post-covid experiences. It's not purely that code
isn't written by human hands, it's that the agent writing it is
superhuman level at this point. At work you might have this idea like,
"I wouldn't trust any code that person writes." But now it's like, "I
don't trust any codebase that was pre-AI." This is a slight
exaggeration--there are certainly high quality codebases out there, but
recent AI models have a known bar. Outside of small hobbyist circles, I
would expect the half-life of code just got a lot shorter. Cost calculus
for rewrites has completely changed.

What's next? Generally speaking, there are a couple of top picks right
now when it comes to programming languages: rust for runtime performance
or python/typescript for build-time performance. There are tradeoffs to
choosing any language. I think a frontier model company would have the
capability to build a new language that could be fast at build time and
runtime performance, while still having a lot of the safety/feedback
capabilities that a language like Rust might have. The key part would be
to have the capability to generate a bunch of code and train the model
on it, which is why I think a frontier company would probably be the
first mover to have any success with that. Right now there are major
tradeoffs in programming language selection, but in the near future,
there might be clear winners given we don't have a constraint that
humans need to write it. I don't know the governance structure of the
top languages, but people moving at AI speed probably want to own their
own language. I don't think bun counts as owning a programming language
yet since it's still typescript?

I recently made a fairly large change of direction for my td linux
distro. Previously I leaned heavily into the "bootstrap from GNU Mes"
for the idea that you could audit the code. But honestly, I don't think
anyone is really going to be auditing the seed or old versions of gcc to
make it worth the trouble. I didn't realize the cost of watching a bunch
of old compilers compile each other on a single thread when I made that
decision. And now AI agents have progressed so much when it comes to
decompiling (all the recent gaming news), that if someone ever wants to
audit something, they can just have AI agents look at the machine code.

