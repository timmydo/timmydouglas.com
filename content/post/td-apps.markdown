---
date: 2026-10-15
tags:
- timmy's distro
- tui
- gui
title: "Apps on Timmy's Distro"
---

A couple of months ago I started porting a lot of my apps from separate
git repos to the td repo where my linux distro is located. The two main
ones were my mail and news client, which were renamed to td-mail and
td-news. The list of td-apps now includes: td-agent, td-dua, td-editor,
td-mail, td-news, td-pass, td-photo, td-pinentry, td-review, td-taskmgr,
and td-term.

Along that journey, everything is now using the td-ui GUI toolkit. There
was a YouTube video a couple of months ago [Scott and Mark Learn
To...Rethink Authorship](https://youtu.be/0c0evW57Klk?t=95) where Mark
talks about his views on TUI vs GUI, basically pointing out that GUIs
are a complete superset of functionality. Historically, I would have
been more partial to TUIs, but when you're coding with AI agents, you're
really only limited by your imagination. I think TUIs were much easier
to program against when we were hand-coding, and it was much easier to
build a cross-platform app using them because they had less
dependencies. But when ease of programming is no longer a constraint,
then it makes a lot less sense to make a TUI app. td-ui doesn't have any
dependencies--it can talk directly to a wayland socket and render its
fonts to a shared memory buffer that's rendered onto the screen, and if
I want it to work differently I just tell my agent to do it and it's
done.

These apps all use the same toolkit. You can press F1 at any time in any
of them to bring up keyboard shortcuts or you can press F12 to change
the theme color. Because the td-news and td-mail look very similar, I
use a different color for them.

My newest project under the td umbrella is to create a new MTA to
replace my stalwart install. It has served me well enough, but these
days I don't really see a reason to not own my own if I can spare the
credits. However, subscription credits from Anthropic and OpenAI aren't
going as far as I would like--even being on the $200/month plan for
each, I can find ways to burn through the week's quota in a day or two.
I'm currently out of claude credits, so I set up my own harness to do
opus-5.5 code reviews instead of codex invoking claude from the CLI, but
even one running agent was able to spend more than $50/day just doing
code reviews with openrouter credits.


Here are some screenshots:

![agent harness](/assets/td-agent-20261015.png)

![disk usage analyzer](/assets/td-dua-20261015.png)

![mail](/assets/td-mail-20261015.png)

![review](/assets/td-review-20261015.png)

