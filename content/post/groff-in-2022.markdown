---
date: 2022-08-10
tags:
- groff
- roff
- tex
- latex
title: "Groff (GNU troff) in 2022"
---

[Groff](https://en.wikipedia.org/wiki/Groff_%28software%29) is a
typesetting system similar to TeX. I was always intrigued by the
cryptic syntax of man pages, which use the same software. I read an
interesting article about someone trying to write their [PhD using
groff](https://jstutter.netlify.app/) and was interesting in learning
more. LaTeX has always felt a little bloated, so I have been
interested in looking at alternatives. A while back
[Lout](https://en.wikipedia.org/wiki/Lout_(software)) was on my radar,
but usage of it has not seemed to take off.

Anyways, after installing groff, I had to decide what macro package to
use. [This
document](https://www.stephenlindholm.com/groff_macros.html) gives a
good overview--the short advice was to use ms unless you are writing a
novel ("then use mom").

First I needed to find a document to typeset, and while maybe I could
have used a blog entry, there isn't much formatting in those, so I
tried to convert my resume. Unfortunately, that proved to be slightly
more complicated than I expected. I also likely made the wrong
decision by choosing to use the mom macro package. The mom macro
package has [great
documentation](https://www.schaffter.ca/mom/momdoc/toc.html), and got
my attention with its friendly macro names, but probably isn't
intended for a single page document with the formatting I'm trying to
acheieve. I wasn't able to reproduce the background colors I had in
the tables, and the fonts are not as pretty as computer modern or what
you get in Word.

The first step is to figure out how to invoke groff. My install
through Guix has some convenience commands like `pdfmom`, but in general
you would run it like this: `groff -Tpdf -mom resume.ms > resume.pdf
&& evince resume.pdf`. This fits nicely in a makefile `.PHONY` target
that gets executed when I press F2 in Emacs.

I decided to start things off with the mom boilerplate and a table
showing my website on the left, my name centered, and my email on the
right:

```
.PAPER LETTER
.TITLE "Timmy Douglas"
.DRAFT 1
.REVISION 1
.PRINTSTYLE TYPESET
.L_MARGIN 3P
.R_MARGIN 3P
.T_MARGIN 3P
.FAMILY P
.SIZE -2
.DOCHEADER OFF
.START
.TAB_SET 1 0 7i L
.TAB_SET 2 0 7.5i C
.TAB_SET 3 0 7.5i R
.TAB 1
https://www.timmydouglas.com\*[TB+]
.PT_SIZE +10
Timmy Douglas\*[TB+]
.PT_SIZE -10
my@email.address
.TQ
```

That part wasn't too bad. The next part was a little more tricky. I
wanted to have two columns with some tool and systems keywords (BTW
this isn't a final draft of my resume). The `TAB_SET` arguments are
index, start offset, length, and alignment.

```
.PP
.PP
.TAB_SET 1 0 3.75i C
.TAB_SET 2 3.75i 3.75i C
.TAB 1
Some Languages Used
.TN
Some Systems Used
.TQ
.PP
.PT_SIZE 8
.TAB_SET 1 0 3.75i L QUAD
.TAB_SET 2 3.75i 3.75i L QUAD
.MCO
.TAB 1
.ds TeX T\h'-.1667m'\v'.224m'E\v'-.224m'\h'-.125m'X
Bash, C, Common Lisp, C#, TypeScript, MSBuild, Python, Troff (this document), Smalltalk, SQL, \*[TeX]
.MCR
.TAB 2
Windows, Linux, Visual Studio, VS Code, Emacs, Make, Docker, Kubernetes, Kustomize, Azure, AWS EC2/S3/Glacier
.MCX
```

The use of `.MCR`, `.MCR`, and `.MCX` is important here. Without it,
the mom tabular format would put the TAB 2 contents vertically aligned
with the bottom of the TAB 1 contents. This way, they are on the same
level:

 Tools | Systems 
-------|---------
 a, b  | c, d
 

The `.ds` macro creates a string that you can re-use and invoke with
a shorthand. I found that TeX example somewhere.
 
The next section was work experience. I wasn't able to find a good
look, and landed on this:
 
 ```
 .HEADING 1 "Work Experience"
.PARA_INDENT 0m
.PP
.PT_SIZE 8
\*[SLANT]Company Name: Title (Start date \(en Present)\*[SLANTX]
.PT_SIZE 6
.LIST BULLET
.SHIFT_LIST 18p
.ITEM
Some accomplishment or job duties
.LIST OFF
.PP
 ```

It was a little odd to me the endash has a parenthesis in it:
`\en(`. I think the next steps would be to learn more about how the
macros are written. On my comuter, I can find the mom macros in
`/gnu/store/g6pw8f6zi6yljasxigblaw3dl0g8v785-groff-1.22.4/share/groff/1.22.4/tmac/om.tmac`. I
think in a future exercise it might be interesting to learn the base
troff language and how it works. While I'm not a huge fan of the look,
I do appreciate the speed and small footprint.
