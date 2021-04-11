---
date: 2021-04-11
tags:
- Guix
- CFLAGS
- march=native
title: "GNU Guix: Building packages with custom CFLAGS"
---

In a previous [post](/2021/02/07/guix-router.html), I discussed how to
set up a custom channel. I currently have one hosted
[here](https://github.com/timmydo/guix-channel). I'm using that in
this post where I use guix on a foreign distribution. I have
customized my `~/.config/guix/channels.scm` to include my channel with
custom packages:


```scheme

(cons (channel
       (name 'timmy-packages)
       (url "https://github.com/timmydo/guix-channel.git")
       (branch "main")
       (introduction
	(make-channel-introduction
	 "4cec36d449afcf0a6c70e1b63b12bd73372cd122"
	 (openpgp-fingerprint "4334F13EFD13BC4D7F5E69B61CA27EA507096538"))))
      %default-channels)

```

Then I created a modified package:

```scheme
(define-module (timmy my)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (ice-9 match))


(define-public my-hello
  (package
    (inherit hello)
    (name "my-hello")
    (arguments
     `(#:make-flags (list "CFLAGS=-g -fno-omit-frame-pointer -O3 -march=native")
       #:strip-binaries? #f))))
```

After running `guix pull`, I can find the new package I created.

```text
> guix search my-hello
name: my-hello
version: 2.10
outputs: out
systems: x86_64-linux i686-linux
dependencies:
location: timmy/my.scm:17:2
homepage: https://www.gnu.org/software/hello/
license: GPL 3+
synopsis: Hello, GNU world: An example GNU package
description: GNU Hello prints the message "Hello, world!" and then exits.  It serves as an example of standard GNU coding
+ practices.  As such, it supports command-line arguments, multiple languages, and so on.
relevance: 20

```

Compare the old:

```sh
$ gdb /gnu/store/a462kby1q51ndvxdv3b6p0rsixxrgx1h-hello-2.10/bin/hello
Reading symbols from /gnu/store/a462kby1q51ndvxdv3b6p0rsixxrgx1h-hello-2.10/bin/hello...
(No debugging symbols found in /gnu/store/a462kby1q51ndvxdv3b6p0rsixxrgx1h-hello-2.10/bin/hello)
(gdb) break main
Breakpoint 1 at 0x4022f0
(gdb) r
Starting program: /gnu/store/a462kby1q51ndvxdv3b6p0rsixxrgx1h-hello-2.10/bin/hello

Breakpoint 1, 0x00000000004022f0 in main ()
(gdb) disassemble
Dump of assembler code for function main:
=> 0x00000000004022f0 <+0>:	push   %r12
   0x00000000004022f2 <+2>:	push   %rbp
   0x00000000004022f3 <+3>:	mov    %edi,%ebp
   0x00000000004022f5 <+5>:	push   %rbx
   0x00000000004022f6 <+6>:	mov    %rsi,%rbx
   0x00000000004022f9 <+9>:	xor    %r12d,%r12d
   0x00000000004022fc <+12>:	sub    $0x10,%rsp
   0x0000000000402300 <+16>:	mov    (%rsi),%rdi
   0x0000000000402303 <+19>:	callq  0x4027b0 <set_program_name>
   0x0000000000402308 <+24>:	mov    $0x40501a,%esi
   0x000000000040230d <+29>:	mov    $0x6,%edi
   0x0000000000402312 <+34>:	callq  0x402260 <setlocale@plt>
   0x0000000000402317 <+39>:	mov    $0x405248,%esi
   0x000000000040231c <+44>:	mov    $0x40505f,%edi
   0x0000000000402321 <+49>:	callq  0x402100 <bindtextdomain@plt>
   0x0000000000402326 <+54>:	mov    $0x40505f,%edi
   0x000000000040232b <+59>:	callq  0x4020e0 <textdomain@plt>
   0x0000000000402330 <+64>:	mov    $0x5,%edx
   0x0000000000402335 <+69>:	mov    $0x405065,%esi
   0x000000000040233a <+74>:	xor    %edi,%edi
   0x000000000040233c <+76>:	callq  0x402110 <dcgettext@plt>
   0x0000000000402341 <+81>:	mov    $0x402710,%edi
   0x0000000000402346 <+86>:	mov    %rax,0x8(%rsp)
   0x000000000040234b <+91>:	callq  0x4043b0 <atexit>
   0x0000000000402350 <+96>:	xor    %r8d,%r8d
   0x0000000000402353 <+99>:	mov    $0x4053e0,%ecx
   0x0000000000402358 <+104>:	mov    $0x405091,%edx
   0x000000000040235d <+109>:	mov    %rbx,%rsi
   0x0000000000402360 <+112>:	mov    %ebp,%edi
   0x0000000000402362 <+114>:	callq  0x402140 <getopt_long@plt>
   0x0000000000402367 <+119>:	cmp    $0xffffffff,%eax
   0x000000000040236a <+122>:	je     0x402420 <main+304>
   0x0000000000402370 <+128>:	cmp    $0x68,%eax
   0x0000000000402373 <+131>:	je     0x402414 <main+292>
   0x0000000000402379 <+137>:	jle    0x4023d8 <main+232>
   0x000000000040237b <+139>:	cmp    $0x74,%eax
   0x000000000040237e <+142>:	je     0x4023f9 <main+265>
   0x0000000000402380 <+144>:	cmp    $0x76,%eax
   0x0000000000402383 <+147>:	jne    0x4023ee <main+254>
```

With the new:

```sh
$ gdb /gnu/store/2h5cr9f4kxv0sd4jlb0kwgvvl9m91pmm-my-hello-2.10/bin/hello
Reading symbols from /gnu/store/2h5cr9f4kxv0sd4jlb0kwgvvl9m91pmm-my-hello-2.10/bin/hello...
(gdb) b main
Breakpoint 1 at 0x4022f0: file src/hello.c, line 41.
(gdb) r
Starting program: /gnu/store/2h5cr9f4kxv0sd4jlb0kwgvvl9m91pmm-my-hello-2.10/bin/hello
n
Breakpoint 1, main (argc=1, argv=0x7fffffffdd88) at src/hello.c:41
41	src/hello.c: No such file or directory.
(gdb) disassemble
Dump of assembler code for function main:
=> 0x00000000004022f0 <+0>:	push   %rbp
   0x00000000004022f1 <+1>:	mov    %rsp,%rbp
   0x00000000004022f4 <+4>:	push   %r13
   0x00000000004022f6 <+6>:	xor    %r13d,%r13d
   0x00000000004022f9 <+9>:	push   %r12
   0x00000000004022fb <+11>:	mov    %edi,%r12d
   0x00000000004022fe <+14>:	push   %rbx
   0x00000000004022ff <+15>:	mov    %rsi,%rbx
   0x0000000000402302 <+18>:	sub    $0x18,%rsp
   0x0000000000402306 <+22>:	mov    (%rsi),%rdi
   0x0000000000402309 <+25>:	callq  0x4027c0 <set_program_name>
   0x000000000040230e <+30>:	mov    $0x40701a,%esi
   0x0000000000402313 <+35>:	mov    $0x6,%edi
   0x0000000000402318 <+40>:	callq  0x402260 <setlocale@plt>
   0x000000000040231d <+45>:	mov    $0x407248,%esi
   0x0000000000402322 <+50>:	mov    $0x40705f,%edi
   0x0000000000402327 <+55>:	callq  0x402100 <bindtextdomain@plt>
   0x000000000040232c <+60>:	mov    $0x40705f,%edi
   0x0000000000402331 <+65>:	callq  0x4020e0 <textdomain@plt>
   0x0000000000402336 <+70>:	mov    $0x5,%edx
   0x000000000040233b <+75>:	mov    $0x407065,%esi
   0x0000000000402340 <+80>:	xor    %edi,%edi
   0x0000000000402342 <+82>:	callq  0x402110 <dcgettext@plt>
   0x0000000000402347 <+87>:	mov    $0x402720,%edi
   0x000000000040234c <+92>:	mov    %rax,-0x28(%rbp)
   0x0000000000402350 <+96>:	callq  0x4065b0 <atexit>
   0x0000000000402355 <+101>:	xor    %r8d,%r8d
   0x0000000000402358 <+104>:	mov    $0x4073e0,%ecx
   0x000000000040235d <+109>:	mov    $0x407091,%edx
   0x0000000000402362 <+114>:	mov    %rbx,%rsi
   0x0000000000402365 <+117>:	mov    %r12d,%edi
   0x0000000000402368 <+120>:	callq  0x402140 <getopt_long@plt>
   0x000000000040236d <+125>:	cmp    $0xffffffff,%eax
   0x0000000000402370 <+128>:	je     0x402426 <main+310>
   0x0000000000402376 <+134>:	cmp    $0x68,%eax
   0x0000000000402379 <+137>:	je     0x40241a <main+298>
   0x000000000040237f <+143>:	jle    0x4023e0 <main+240>
   0x0000000000402381 <+145>:	cmp    $0x74,%eax
   0x0000000000402384 <+148>:	je     0x402400 <main+272>
   0x0000000000402386 <+150>:	cmp    $0x76,%eax
   0x0000000000402389 <+153>:	jne    0x4023f5 <main+261>
```
