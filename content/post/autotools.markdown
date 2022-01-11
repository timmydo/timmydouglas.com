---
date: 2022-01-10
tags:
- autotools
- automake
- autoconf
title: "Autotools"
---

I recently bought the book: "Autotools: A practitioner's guide to GNU
Autoconf, Automake, and Libtool," by John Calcote. I was reading some
articles on build systems and I came across a post from the [Sabotage
Linux blog](https://sabotage-linux.github.io/blog/5/) explaining build
systems for C/C++. It's a fairly good overview and there is another
post talking about build tools in [When progress is backwards:
Showcase 5](https://sabotage-linux.github.io/blog/8/). During the
holiday, I spent some time following the Linux From Scratch (LFS)
guide, and if you learn anything from it, it's how to build other
people's software. You will most likely run into autotools usage along
the way, as most of the applications in a Linux distribution are
written in C.


Back to the book. It's a fairly nice introduction, but the larger
examples became harder to follow along in the end without a project of
my own to use for hands on experience. I think autotools code is
probably best copied from a bunch of other recipes as if you were to
make your own cookbook.


When you follow the LFS guide, you really begin to appreciate packages
that ship with minimal dependencies. Autotools-based packages just
need a POSIX shell and GNU Make, which is one of its largest
strengths, not just because of the ease of bootstrapping, but also
because of its transparency. Autoconf/Automake set up a bunch of
common targets that distributions have come to expect (with regards to
cross compiling, `--prefix`, `DESTDIR=..`, and so on), and people
coding things themselves will likely leave a lot of those out to the
chagrin of distribution maintainers.


Separately, but on a similar topic, I spent a little time before I
read the book trying to learn the m4 macro processing language, which
is a little tricky at first glance. m4 is used by autoconf to generate
the configure script among other things. m4 takes a little time to
wrap your head around if you're new to it. Here is a sample program
from the [GNU m4 manual](https://www.gnu.org/software/m4/manual/m4.html#Intro):

```
changequote([,])dnl
define([gl_STRING_MODULE_INDICATOR],
  [dnl comment
  GNULIB_[]translit([[$1]], [a-z], [A-Z])=1dnl
])dnl
  gl_STRING_MODULE_INDICATOR([strcase])
```

The output of the program is:

```
   GNULIB_STRCASE=1
```

It's readable, but if you were asked why the following doesn't work,
you would need an understanding of whitespace tokenization and quoting
in macro expansion.

```
changequote([,])dnl
define([gl_STRING_MODULE_INDICATOR],
  [
    dnl comment
    GNULIB_]translit([$1],[a-z],[A-Z])[=1
  ])dnl
  gl_STRING_MODULE_INDICATOR([strcase])
  
  
⇒        GNULIB_strcase=1
```

