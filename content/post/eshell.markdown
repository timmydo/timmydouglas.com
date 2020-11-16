---
date: 2020-11-15
tags:
- emacs
- shell
- lisp
- Eshell
title: Emacs shell
---

I've been thinking about shells a little recently. Not seashells, but
the [computer
kind](https://en.wikipedia.org/wiki/Shell_(computing)). The command line
(unix-based) shells that most people are familiar with these days run in a
terminal emulator. Many people will run a terminal emulator like
xterm, GNOME Terminal,
[alacritty](https://github.com/alacritty/alacritty), or even the new
[Windows Terminal](https://github.com/Microsoft/Terminal), and then
run a shell such as bash, zsh, etc.

This fine and dandy--it allows some customizations through aliases,
shell functions, etc. but are there alternatives? Is this 'worse is
better' or is it just the unix philosophy of having a lot of simple
executables and the ability to string them together with pipes and
files? When you want to build a richer interface, do you just launch
another program like midnight commander, GNOME Nautilus, a web
browser, or an IDE? How would those interact with your shell?

It was before my time to experience, but I've been interested in Lisp
Machines. Maybe I should try to get an emulator to try one out. I'm an
Emacs user so maybe that is fairly close? For quite a while Common
Lisp was my language of choice, and I enjoyed programming environments
like Squeak. Since then, I've leaned more towards static, compiled
languages like C, C# or Go, but a recent excursion I made yesterday
debugging why [Magit was not able to create a git
commit](https://github.com/magit/magit/issues/4209), I experienced
some nostalgia. When they say Emacs is an extensible, self-documenting
editor, they mean you can type things like `C-h b` to find the
bindings for the current buffer, `C-s` to find "commit", `C-h f`
"magit-commit" to find the method that gets called when you press `c`
for commit, click on the link to the implementation, then jump through
the code, and make live changes as necessary. I don't think I'd
imagine ever opening up Nautilus or Windows Explorer's source code to
see how things work or make some changes, but it wouldn't be so far
fetched to do that with Emacs dired-mode.

Most shells let you create aliases and key bindings, but
at the end of the day, the interface doesn't really go beyond a
command prompt. There aren't hyperlinks, mouse buttons, and context
menus unless you were to launch another application, and by then
you've exited your shell. It's not really a holistic vision. Not that
it has to be--but it's interesting to imagine a computer environment
where everything flows as a single interface.

[Emacs Eshell](https://www.gnu.org/software/emacs/manual/html_node/eshell/Introduction.html) is somewhere between an elisp REPL and a traditional unix
shell. Maybe in some ways similar to
[CLIM](https://en.wikipedia.org/wiki/Common_Lisp_Interface_Manager) or
what you'd see on Lisp machines. It can run regular executables
(wouldn't be of much use if it couldn't), but a lot of the regular
coreutils are actually elisp functions. You can call your own elisp
methods or built-in ones, pipe output to an Emacs buffer, or pipe an
Emacs buffer to a command. [This youtube video gives an introduction
to Eshell](https://www.youtube.com/watch?v=RhYNu6i_uY4).

I'm going to try spending the next couple of weeks trying to do things
through Eshell rather than launching terminal. I think it will be a
good exercise to learn more about extending Emacs. I've used it for
like 20 years and I haven't really written any significant elisp code.


