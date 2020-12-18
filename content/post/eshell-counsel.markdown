---
date: 2020-12-17
tags:
- emacs
- shell
- Lisp
- Eshell
title: "Extending Eshell: Fuzzy History Search"
---

I've been spending some of my time off customizing my Emacs
config. I've used Emacs a long time but I've never dipped into writing
Emacs Lisp to customize it. Now is the time.

I started trying to use the Emacs shell for various things ([previous
blog post](/2020/11/15/eshell.html)), but one of the things I didn't
like was the history completion. I wanted my `Ctrl-r` to act like
[fzf](https://github.com/junegunn/fzf) rather than built-in commands
that just pull the first thing that prefix-matches. It's nice to see a
list of what else is in the history and to have some sort of fuzzy
matching capability.

It took about 10 minutes to patch together something searching the
internet and `M-x describe-function` to find other relevant code
inside Emacs itself. Here is what I came up with:

```EmacsLisp
(defun timmy/counsel-eshell-history-action (cmd)
  "Insert cmd into the buffer"
  (interactive)
  (insert cmd))

(defun timmy/counsel-eshell-history (&optional initial-input)
  "Find command from eshell history.
INITIAL-INPUT can be given as the initial minibuffer input."
  (interactive)
    (ivy-read "Find cmd: " (timmy/eshell-history-list)
              :initial-input initial-input
              :action #'timmy/counsel-eshell-history-action
              :caller 'timmy/counsel-eshell-history))

(defun timmy/eshell-history-list ()
  "return the eshell history as a list"
  (and (or (not (ring-p eshell-history-ring))
	   (ring-empty-p eshell-history-ring))
       (error "No history"))
  (let* ((index (1- (ring-length eshell-history-ring)))
	 (ref (- (ring-length eshell-history-ring) index))
	 (items (list)))
    (while (>= index 0)
      (setq items (cons (format "%s" (eshell-get-history index)) items)
	    index (1- index)
	    ref (1+ ref)))
    items))

(use-package esh-mode
  :ensure nil
  :bind (:map eshell-mode-map
	      ("C-r" . timmy/counsel-eshell-history)))
```


I use counsel/ivy already, so I basically just wrote a function to
gather the eshell history and pass it to counsel. Selecting the
command is pretty straightforward--it just inserts the text into the
buffer. There are probably a lot of better ways to write this code,
but that's not the point.

On a somewhat related note, I'm also enjoying setting up global
bindings for my function keys. Here is what I have as of right now,
but this will probably change a lot as I get a feel for what I like:

```EmacsLisp
(global-set-key (kbd "<f1>") 'eshell)
(global-set-key (kbd "<f2>") 'recompile)
(global-set-key (kbd "<f5>") 'deadgrep)
(global-set-key (kbd "<f6>") 'counsel-git)
(global-set-key (kbd "<f9>") 'dired)
(global-set-key (kbd "<f10>") 'magit-status)
(global-set-key (kbd "<f11>") 'bury-buffer)
(global-set-key (kbd "<f12>") 'delete-other-windows)
```
