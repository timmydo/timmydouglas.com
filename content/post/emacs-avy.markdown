---
date: 2021-12-03
tags:
- emacs
- avy
- easymotion
title: "Emacs and Avy: Edit text using a mouse?"
---

When you use a text editor and want to jump around on the current
page, do you reach for your mouse? Increase the repeat rate on your
keyboard? Use something like Avy (Emacs) or EasyMotion (vim)?

I came across a [blog post about
avy](https://karthinks.com/software/avy-can-do-anything/) recently.


I can give a quick summary here since that post was rather
lengthy. Avy can be invoked a couple of ways--whether to move the
cursor to another place on the screen (like clicking the mouse) or by
performing an action like copy-and-pasting another line on the
(that you can customize to your keyboard home-row) to indicate the
position.


This simplest way to invoke it would be `avy-goto-char`. When you
invoke that function, you type the first character of the position you
want to go to. Here is a picture of me invoking `avy-goto-char` and
then pressing the character `e`:

![picture of avy-goto-char](/assets/avy.png)

To move to those highlighted positions in the buffer, then I would
press the highlighted characters and the cursor would jump there.

You might modify `avy-keys` if you use a different keyboard layout:

```lisp
(setq avy-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n))
```

These keys are used for navigation. I use the dvorak keyboard layout,
so I switch the defaults so that the generated navigation keys would
land on my home-row.


