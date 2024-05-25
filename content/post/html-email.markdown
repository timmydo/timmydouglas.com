---
date: 2024-05-25
tags:
- html email
title: "HTML Email"
---

I believe one of the unfortunate things that happened in the computer
world is the prevalence of HTML email. Perhaps this is not as bad as
web browsers becoming complicated super apps that do everything, but
HTML email borrows the same rendering technology as the web browser,
so maybe I should consider them the same thing. Ultimately, with
email, I want to control how the content is displayed to me. With HTML
email, the sender is trying to make that decision. It's harder to
parse the content itself with HTML because the markup isn't a trivial
language anymore.

As an experiment, I've created another folder for email with a
text/html MIME type. I'll check it less often than my inbox, perhaps
like a spam folder. Here is roughly what it looks like using
notmuch/Emacs:

```
(setq notmuch-saved-searches '(
  (:name "inbox" :query "tag:inbox and not tag:list and not tag:html")
  (:name "html" :query "tag:inbox and tag:html and not tag:list")))
```

Abbreviation of what my tags batch file is doing:

```
notmuch tag +html -- mimetype:text/html
```

I've noticed some senders include a text/plain section but it's either
garbage or an empty alternative. So it's not sufficient to see if
senders are including a text/plain section. I always prefer when
senders give me an option to send text-only email.
