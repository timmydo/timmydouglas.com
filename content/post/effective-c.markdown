---
date: 2021-05-22
tags:
- C
title: "Effective C"
---

I recently bought a book called [Effective C: An intorudction to
Professional C Programming](https://nostarch.com/Effective_C) by
Robert Seacord. I haven't done any C programming in the last 15 years,
so I thought it would be a good refresher. I want to find a hobby
project that I could write in C (I'm still looking). I've mainly been
writing C# professionally and I've written some Go on the side.

I enjoy programming languages that are simple enough to pick up
quickly. I think C and [Go](https://golang.org/) are good examples of
that. I've been wanting to learn a new systems programming language
that doesn't include a garbage collector, but Rust hasn't felt
appealing or simple enough for me to go out of my way to learn
it. [Zig](https://ziglang.org/) and [V](https://vlang.io/) feel
interesting, but I know if either are mature enough. I'm also think
[Drew DeVault's new language](https://drewdevault.com/) will be
exciting to see when it lands.

Back to the book. I wanted to call out some of the things that were
either new to me (since I last wrote C about 15 years ago) or things I
never picked up on (in no particular order):

  - _Alignof
  - static_assert
  - `restrict` keyword
  - size_t (stddef.h)
  - reserved names ending with `_t`
  - integer conversions specifics
  - integer promotions (and avoiding undefined behavior with an explicit
    cast: `char c = '\xFF'; isdigit((unsigned char)c)`)
  - _Atomic
  - recommendation using `f(void)` rather than `f()` for functions
  without arguments
  - enums
  - `bool` (stdbool.h)
  - flexible arrays (`int data[]` in a struct)
  - variable length arrays (`char msg[size]` in a function
  block--alternative to `alloca`)
  - struct field initialization `point abc = { .x = 1, .y = 2};`
  - type generic macros (`#define sin(X) _Generic((X), float: sinf, double: sin, long
    double: sinl)(X)`)
	
Overall, the book was nice, but short. At just over 200
pages, it's an afternoon read. I was hoping it would go further than
an "introduction" to professional C programming and spend more time
discussing analysis tools to secure C programming. These days, it
feels like you get chastised for choosing C for a new project due to
security and safety. C still has a lot of foot guns, so it would have
been nice to dive deeper than a few compile flags and a pointer to
AddressSanitizer in the last couple of pages in the book.


