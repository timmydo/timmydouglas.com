---
date: "2019-08-17T22:47:23Z"
tags:
- fzf
- shell
- git
title: Shell shortcuts and fzf
---

I wanted to write a blog entry to gather some shell scripting aliases into one place. I'll update this as time goes.


### Git

Edit with `git config --global -e`

```
alias.cof=!git for-each-ref --format='%(refname:short)' refs/heads | fzf | xargs git checkout
alias.pom=pull origin master
alias.co=checkout
alias.b=branch
alias.s=status
push.default=current
```

  - `git cof` to use fzf to select a branch to checkout (good if you have a lot of branches).
  - `git co -` to go to your last branch. 
  - Bash should still auto-complete if you type `git co branch<tab>...`

### Kubectl


[kubectl/kubens Commands](https://github.com/ahmetb/kubectx)

### fzf

Examples here. Look into later.

[https://github.com/junegunn/fzf/wiki/Examples](https://github.com/junegunn/fzf/wiki/Examples)

### fd-find

[https://github.com/sharkdp/fd](https://github.com/sharkdp/fd)