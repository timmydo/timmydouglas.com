---
date: 2022-08-13
tags:
- groff
- roff
- tex
- latex
title: "GNU troff in 2022 part 2"
---

In my last post, I described my first experience with GNU troff and
how I tried using the mom macro set to typeset my resume as a way to
learn it. Long story short, shortly after that post I wanted to try
another take without using the mom macro set. I came upon [this great
set of troff
resources](http://www.kohala.com/start/troff/troff.html). From that
list, the original troff user's manual, the troff tutorial, and the
original tbl user's manual were ones I started with. It encouraged me
to start again in raw troff and using the `-tbl` flag to invoke the
table preprocessor. (`groff -Tpdf -tbl resume.nroff > resume.pdf`)

In the troff tutorial, after Brian Kernighan introduces troff, he
states the most important rule: "The single most important rule of
using troff is not to use it directly, but through some
intermediary. In many ways, troff resembles an assembly language — a
remarkably powerful and ﬂexible one — but nonetheless such that many
operations must be speciﬁed at a level of detail and in a form that is
too hard for most people to use effectively."

Using the `tbl` preprocessor, I was able to revisit the first part of
my resume where I listed my name and some buzzwords:

```
.sp
.sp
.TS
expand;
l  c  r.
\s10https://www.timmydouglas.com	\s30Timmy Douglas\s10	my@email.com
.TE
.sp
.TS
box;
c | c
lw(3i) | lw(3.25i).
Recent Languages	Recent Systems
_
.ds TeX T\h'-.1667m'\v'.224m'E\v'-.224m'\h'-.125m'X
T{
Bash, C, Common Lisp, C#, TypeScript, MSBuild, Python, Troff (this document), Smalltalk, SQL, \*[TeX]
T}	T{
Windows, Linux, Visual Studio, VS Code, Emacs, Make, Docker, Kubernetes, Kustomize, Azure, AWS EC2/S3/Glacier
T}
.TE
```

While it isn't too much different from the first attempt, I think I
enjoyed using `tbl` more than mom to layout the tables. `tbl` feels
like a purpose-built language for creating tables, while mom macros
were more like using C-like macros to write assembly.


I typeset the work experience and following sections by creating a
macro for each title and another macro for the bullets under it:

```
.de JOB
.sp
.ps 14
.ti +0.0i
..
.de ITEM
.sp
.ps 10
.ti +0.25i
..
```

Then the rest flowed like this:

```
.JOB
Company: Title (start date \(en end date)
.ITEM
some accomplishment etc etc
.ITEM
another accomplishment etc etc
```

I do like the idea of thinking about troff as an assembly
language. With that and the unix mindset, I could imagine a future
program I write generating troff as an intermediate language to create
postscript, PDF files, man pages or even formatted text. It wasn't too
bad using raw troff directly if you are fine with keeping things
simple.
