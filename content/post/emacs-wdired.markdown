---
date: "Sat, 14 Nov 2020 11:46:04 -0800"
tags:
- emacs
- dired
title: Renaming files easily with Emacs and Dired mode
---

Expanding on the post yesterday, I wanted to illustrate a way to
quickly rename files that I found fascinating (editing file names in
a text editor buffer).

This uses Emacs's [Wdired
mode](https://www.gnu.org/software/emacs/manual/html_node/emacs/Wdired.html)
(`dired-toggle-read-only`), then using macros to automate some of the
repetitive edits. Some key bindings:

```text
C-x C-f open a directory to start dired mode
C-x C-q enable dired write mode
C-x ( start macro
... C-f or C-b move right or left
... C-n or C-p move down or up
... C-d delete character
C-x ) end macro
C-x e perform recorded macro
C-u 20 C-x e perform macro 20 times
C-c C-c commit changes in dired mode (to rename files)
```

You could do the same thing without macros if you use `C-x SPACE` to
start a column selection.

[Link to 30 second video
recording](/assets/emacs-wdired-2020-11-14.mp4). Recorded using
[wf-recorder -g "$(slurp)"](https://github.com/ammen99/wf-recorder).





